; io.asm - Input/Output utility functions

section .bss
    input_buffer resb 16

section .text
    global print_string
    global print_number
    global read_number

; Print string ke stdout
; Input: rdi = pointer ke string, rsi = length
; Output: none
print_string:
    push rbp
    mov rbp, rsp
    
    mov rax, 1      ; syscall: write
    mov rdx, rsi    ; length
    mov rsi, rdi    ; buffer
    mov rdi, 1      ; stdout
    syscall
    
    pop rbp
    ret

; Print angka ke stdout
; Input: rdi = number
; Output: none
print_number:
    push rbp
    mov rbp, rsp
    sub rsp, 32
    
    mov rax, rdi
    lea rsi, [rbp-32]
    mov byte [rsi], 10  ; newline di akhir
    inc rsi
    mov rcx, 10
    
    ; Convert number to string (reverse order)
.convert:
    xor rdx, rdx
    div rcx
    add dl, '0'
    dec rsi
    mov [rsi], dl
    test rax, rax
    jnz .convert
    
    ; Print the string
    lea rdx, [rbp-31]
    sub rdx, rsi
    inc rdx
    mov rdi, 1      ; stdout
    mov rax, 1      ; syscall: write
    syscall
    
    add rsp, 32
    pop rbp
    ret

; Baca angka dari stdin
; Input: none
; Output: rax = number yang dibaca
read_number:
    push rbp
    mov rbp, rsp
    
    ; Baca input
    mov rax, 0          ; syscall: read
    mov rdi, 0          ; stdin
    lea rsi, [input_buffer]
    mov rdx, 16
    syscall
    
    ; Convert string to number
    xor rax, rax        ; result
    xor rcx, rcx        ; index
    lea rsi, [input_buffer]
    
.convert:
    movzx rdx, byte [rsi + rcx]
    cmp dl, 10          ; newline?
    je .done
    cmp dl, 0           ; null?
    je .done
    cmp dl, '0'
    jl .done
    cmp dl, '9'
    jg .done
    
    sub dl, '0'
    imul rax, rax, 10
    add rax, rdx
    inc rcx
    jmp .convert
    
.done:
    pop rbp
    ret