.data               # start of data section
# put any global or static variables here
A: .quad 10
B: .quad 6

.section .rodata    # start of read-only data section
# constants here, such as strings
# modifying these during runtime causes a segmentation fault, so be cautious!
printString3: .string "(A - B) + (A * B) = %d\n" 
printString2: .string "(A*5) = %d\n"
printString: .string "(A + B) - (A / B) = %d\n"



.text               # start of text /code
# everything inside .text is read-only, which includes your code!
.global main        # required, tells gcc where to begin execution

# === functions here ===
simple_mult:
    # A stored in %rdi
    # 5 stored in %rsi
    # return value in %rax

    #callee saving
    push %rdi
    push %rsi


    #function code
    movq A, %rdi
    movq $5, %rsi
    movq %rdi, %rax
    imul %rsi, %rax

    #callee saving
    pop %rsi
    pop %rdi

    ret
problem_two:

    # A stored in %rdi
    # B stored in %rsi
    # return value in %rax

    #callee saving
    push %rdi
    push %rsi

    #function code
    movq A, %rdi
    movq B, %rsi
    movq %rdi, %rdx
    #add (A+B) and store the value in %r8 for later
    add %rsi, %rdx
    movq %rdx, %r8
    #(A+B) stored in %rdx

    movq %rdi, %rax
    movq %rsi, %rcx
    cqo
    idivq %rcx

    sub %rax, %r8
    movq %r8, %rax

    #callee saving
    pop %rsi
    pop %rdi

    ret
Problem_three:
    # A stored in %rdi
    # B stored in %rsi
    # return value in %rax

    #callee saving
    push %rdi
    push %rsi

    #function code
    movq A, %rdi
    movq B, %rsi
    movq %rdi, %rdx
    sub %rsi, %rdx

    movq %rsi, %rax
    imul %rdi, %rax

    add %rdx, %rax



    #callee saving
    pop %rsi
    pop %rdi

    ret



main:               # start of main() function
# preamble
pushq %rbp
movq %rsp, %rbp

# === main() code here ===

call simple_mult

movq $printString2, %rdi
movq %rax, %rsi
call printf


call problem_two

movq $printString, %rdi
movq %rax, %rsi
call printf


call Problem_three

movq $printString3, %rdi
movq %rax, %rsi
call printf

# clean up and return
movq $0, %rax       # place return value in rax
leave               # undo preamble, clean up the stack
ret                 # return
