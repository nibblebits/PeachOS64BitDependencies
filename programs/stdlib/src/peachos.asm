; Copyright (C) 2025 Daniel McCarthy <daniel@dragonzap.com>
; Part of the PeachOS Part Two Development Series.
; https://github.com/nibblebits/PeachOS64BitCourse
; https://github.com/nibblebits/PeachOS64BitModuleTwo
; Licensed under the GNU General Public License version 2 (GPLv2).
;
; Community contributors to this source file:
; NONE AS OF YET
; ----------------
; Disclaimer: Contributors are hobbyists that contributed to the public source code, they are not affiliated or endorsed by Daniel McCarthy the author of the PeachOS Kernel      
; development video series. Contributors did not contribute to the video content or the teaching and have no intellectual property rights over the video content for the course video * material and did not contribute to the video material in anyway.
;

[BITS 64]

section .asm

global print:function
global peachos_getkey:function
global peachos_malloc:function
global peachos_free:function
global peachos_putchar:function
global peachos_process_load_start:function
global peachos_process_get_arguments:function 
global peachos_system:function
global peachos_exit:function
global peachos_window_create:function
global peachos_divert_stdout_to_window:function
global peachos_process_get_window_event:function
global peachos_window_get_graphics:function
global peachos_graphics_create:function
global peachos_graphic_pixels_get:function
global peachos_window_redraw:function
global peachos_realloc:function
global peachos_fopen:function
global peachos_fclose:function
global peachos_fread:function
global peachos_fseek:function
global peachos_fstat:function
global peachos_window_redraw_region:function
global peachos_udelay:function
global peachos_window_title_set:function


; FILE COULD OPEN BUT THE READ FAILED
; LETS GET THE DEBUGGER ON FIND WHAT HAPPEND

; void print(const char* filename)
print:
    push qword rdi
    mov rax, 1 ; Command print
    int 0x80
    add rsp, 8 ; Due to the push restore the stack.
    ret

; int peachos_getkey()
peachos_getkey:
    mov rax, 2 ; Command getkey
    int 0x80
    ret

; void peachos_putchar(char c)
peachos_putchar:
    mov rax, 3 ; Command putchar
    push qword rdi ; Variable "c"
    int 0x80
    add rsp, 8 ; Due to the push restore the stack.
    ret

; void* peachos_malloc(size_t size)
peachos_malloc:
    mov rax, 4 ; Command malloc (Allocates memory for the process)
    push qword rdi
    int 0x80
    add rsp, 8 ; Due to the push restore the stack.
    ret

; void peachos_free(void* ptr)
peachos_free:
    mov rax, 5 ; Command 5 free (Frees the allocated memory for this process)
    push qword rdi
    int 0x80
    add rsp, 8 ; Due to the push restore the stack.
    ret

; void peachos_process_load_start(const char* filename)
peachos_process_load_start:
    mov rax, 6 ; Command 6 process load start ( stars a process )
    push qword rdi
    int 0x80
    add rsp, 8 ; Due to the push restore the stack.
    ret

; int peachos_system(struct command_argument* arguments)
peachos_system:
    mov rax, 7 ; Command 7 process_system ( runs a system command based on the arguments)
    push qword rdi
    int 0x80
    add rsp, 8 ; Due to the push restore the stack.
    ret


; void peachos_process_get_arguments(struct process_arguments* arguments)
peachos_process_get_arguments:
    mov rax, 8 ; Command 8 Gets the process arguments
    push qword rdi
    int 0x80
    add rsp, 8 ; Due to the push restore the stack.
    ret

; void peachos_exit()
peachos_exit:
    mov rax, 9 ; Command 9 process exit
    int 0x80
    ret

; void* peachos_window_create(const char* title, long width, long height, long flags, long id)
peachos_window_create:
    mov rax, 10 ; Command 10 - window create
    push qword R8
    push qword rcx
    push qword rdx
    push qword rsi
    push qword rdi
    int 0x80
    ; Restore the stack.
    add rsp, 40

    ; RAX contains the return result from this procedure
    ret


; void peachos_divert_stdout_to_window(struct window* window);
peachos_divert_stdout_to_window:
    mov rax, 11 ; Command 11 - divert stdout to window
    push qword rdi ; Pointer to the userland window
    int 0x80
    add rsp, 8
    ret

; int peachos_process_get_window_event(struct window_event* event);
peachos_process_get_window_event:
    mov rax, 12 ; Command 12 - get next window event from our process
    push qword rdi ; The pointer to the window event
    int 0x80
    add rsp, 8
    ;rax is set and equal to return value
    ret

; process_window
; void* peachos_window_get_graphics(struct window* window);
peachos_window_get_graphics:
    mov rax, 13 ; Command 13 - get the graphics of a window
    push qword rdi ; THE POINTER TO the process_window
    int 0x80       ; Invoke kernel
    add rsp, 8      ; restore stack
    ; RAX = void pointer to the kernel graphics
    ; not accessible by userspace
    ret

;void* peachos_graphics_create(size_t x, size_t y, size_t width, size_t height, void* parent_graphics);
peachos_graphics_create:
    mov rax, 14 ; Command 14 - create new realtive graphics
    push qword rdi ; x
    push qword rsi ; y 
    push qword rdx ; width
    push qword rcx ; height
    push qword r8 ; parent graphics
    int 0x80
    add rsp, 40 ; Restore the stack

    ; RAX now contains the new child graphics element
    ret


; void* peachos_graphic_pixels_get(void* graphics);
peachos_graphic_pixels_get:
    mov rax, 15     ; Gets the pixel array pointer of a graphic entity
    push qword rdi   ; push graphics ptr.
    int 0x80        ; invoke kernel
    add rsp, 8       ; Restore stack
    ret

; void peachos_window_redraw(struct window* window);
peachos_window_redraw:
    mov rax, 16   ; Redraws a window
    push qword rdi ; Push window pointer
    int 0x80
    add rsp, 8     ; Restore the stack
    ret

; void* peachos_realloc(void* old_ptr, size_t new_size);
peachos_realloc:
    mov rax, 17   ; Command 17 realloc
    push qword rsi ; new_size
    push qword rdi ; old_ptr
    int 0x80
    add rsp, 16    ; Restore stack
    ;RAX = new pointer address.
    ret


; int peachos_fopen(const char* filename, const char* mode)
peachos_fopen:
    mov rax, 18 ; Command 18 fopen, consider abstraction to just "open"
    push qword rsi  ; Push the mode
    push qword rdi  ; Push the filename
    int 0x80        ; CALL THE KENREL
    add rsp, 16     ; restore the stack
    ret             ; return
    ; RAX CONTAINS THE FILE HANDLE NUMBER

; void peachos_fclose(size_t fd);
peachos_fclose:
    mov rax, 19   ; COmmand 19 fclose, consider abstraction to just "close"
    push qword rdi  ; Push the fd
    add rsp, 8      ; restore the stack
    ret
    

; long peachos_fread(void* buffer, size_t size, size_t count, long fd);
peachos_fread:
    mov rax, 20    ; Command 20 fread 
    push qword rcx ; fd
    push qword rdx ; count
    push qword rsi ; size
    push qword rdi ; buffer
    int 0x80       ; invoke kernel
    add rsp, 32     ; restore stack
    ret         ; return

; long peachos_fseek(long fd, long offset, long whence);
peachos_fseek:
    mov rax, 21 ; Command 21 fseek
    push qword rdx ; whence 
    push qword rsi ; offset
    push qword rdi ; fd
    int 0x80        ; Invoke the kernel
    add rsp, 24     ; Restore the stack
    ret         ; return

; long peachos_fstat(long fd, struct file_stat* file_stat_out);
peachos_fstat:
    mov rax, 22  ; Command 22 fstat
    push qword rsi ; file_stat_out
    push qword rdi ; fd
    int 0x80        ; invoke kernel
    add rsp, 16     ; restore stack
    ret             ; return


; void peachos_window_redraw_region(long rel_x, long rel_y, long rel_width, long rel_height, struct window* window);
peachos_window_redraw_region:
    mov rax, 23    ; Command 23 redraw region on window
    push qword r8  ; window.
    push qword rcx ; rel_height
    push qword rdx ; rel_width
    push qword rsi ; rel_y
    push qword rdi ; rel_x
    int 0x80
    add rsp, 40    ; Restore stack
    ret 

; void peachos_udelay(uint64_t microseconds);
peachos_udelay:
    mov rax, 24    ; Command 24 udelay
    push qword rdi  ; Push the microseconds to delay by
    int 0x80        ; Invoke that kernel
    add rsp, 8      ; By the time we get to this instruction the delay finished
    ret

; void peachos_window_title_set(struct window* window, const char* title)
peachos_window_title_set:
    mov rax, 25 ; Command 25 (Update window)
    push qword rsi  ; Push the title
    push qword rdi  ; window
    push qword 0    ; sub command zero update window
    int 0x80        ; INvoke kernel
    add rsp, 24     ; restore stack
    ret
