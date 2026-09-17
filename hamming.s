.section .data
prompt1: .ascii "Enter your first string: "
len1 = . - prompt1
prompt2: .ascii "Enter your second string: "
len2 = . - prompt2

.section .bss
.lcomm input1, 256
.lcomm input2, 256
.lcomm hamming, 4

.section .text
.globl _start

_start:
    mov $1, %rax
    mov $1, %rdi
    mov $prompt1, %rsi
    mov $len1, %rdx
    syscall

    mov $0, %rax
    mov $0, %rdi
    movq $input1, %rsi
    movq $256, %rdx
    syscall

    mov $1, %rax
    mov $1, %rdi
    mov $prompt2, %rsi
    mov $len2, %rdx
    syscall

    mov $0, %rax
    mov $0, %rdi
    movq $input2, %rsi
    movq $256, %rdx
    syscall

    movq $input1, %rsi
    movq $input2, %rdi
    mov $0, %rcx

char_loop:
    movb (%rsi), %al
    movb (%rdi), %bl

    cmpb $0x0A, %al
    je total
    cmpb $0x0A, %bl
    je total
    cmpb $0x00, %al
    je total

    xorb %bl, %al

bit_count_loop:
    cmpb $0, %al
    je next

    shrb $1, %al
    jnc skip
    incq %rcx

skip:
    jmp bit_count_loop

next:
    incq %rsi
    incq %rdi
    jmp char_loop

total:
movl %ecx, hamming

mov $60, %rax
mov %rcx, %rdi
syscall


.section .note.GNU-stack,"",@progbits