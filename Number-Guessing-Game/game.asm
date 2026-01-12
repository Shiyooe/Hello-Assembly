; game.asm - Game logic untuk Number Guessing Game

section .data
    prompt_msg db "Tebakan kamu: ", 0
    prompt_len equ $ - prompt_msg
    
    too_high_msg db "Terlalu tinggi! Coba lagi.", 10, 0
    too_high_len equ $ - too_high_msg
    
    too_low_msg db "Terlalu rendah! Coba lagi.", 10, 0
    too_low_len equ $ - too_low_msg
    
    correct_msg db "BENAR! Kamu menang dalam ", 0
    correct_len equ $ - correct_msg
    
    attempts_msg db " percobaan!", 10, 0
    attempts_len equ $ - attempts_msg

section .text
    global play_game
    
    extern print_string
    extern print_number
    extern read_number

; Main game loop
; Input: rdi = angka rahasia
; Output: none
play_game:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    
    mov r12, rdi    ; simpan angka rahasia
    xor r13, r13    ; counter percobaan
    
.game_loop:
    ; Print prompt
    mov rdi, prompt_msg
    mov rsi, prompt_len
    call print_string
    
    ; Baca input user
    call read_number
    mov r14, rax    ; simpan tebakan
    
    ; Increment counter
    inc r13
    
    ; Bandingkan dengan angka rahasia
    cmp r14, r12
    je .correct
    jl .too_low
    
.too_high:
    mov rdi, too_high_msg
    mov rsi, too_high_len
    call print_string
    jmp .game_loop
    
.too_low:
    mov rdi, too_low_msg
    mov rsi, too_low_len
    call print_string
    jmp .game_loop
    
.correct:
    ; Print pesan menang
    mov rdi, correct_msg
    mov rsi, correct_len
    call print_string
    
    ; Print jumlah percobaan
    mov rdi, r13
    call print_number
    
    mov rdi, attempts_msg
    mov rsi, attempts_len
    call print_string
    
    pop r13
    pop r12
    pop rbp
    ret