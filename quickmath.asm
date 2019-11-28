global quickmath

extern printf
extern scanf

segment .data

	welcome db "This machine is running an Intel Core i5 Processor at 2.7 GHz",10,0
	inputprompt db "Please enter the number of terms you would like to calculate",10,0
	clockprompt db "The clock is now %ld tics and the computation will begin immediately",10,0
	partialsumprompt db "With %lf terms, the sum is %lf",10,0
	finalsum db "The Final Sum is %lf",10,0
	clockfinal db "The clock is now %ld and the computation is complete.",10,0
	elapsed db "The elapsed time was %ld tics.at 2.7 GHz that is %lf seconds",10,0
	finalprompt db "This program will now return the harmonic sum to the driver program",10,0

	stringformat db "%s"
	integerformat db "%ld" ;used for counter in loop

segment .bss

segment .text

quickmath:

	push	rbp
	mov	rbp, rsp

	push	rbx
	push	rcx
	push	rdx
	push	rsi
	push	rdi
	push	r8
	push	r9
	push	r10
	push	r11
	push	r12
	push	r13
	push	r14
	push	r15

;===== welcome statement =======================================================

	mov qword rax, 0
	mov	rdi, stringformat
	mov	rsi, welcome
	call	printf

;===== prompt the user to input a number =====================================

	mov qword rax, 0
	mov	rdi, stringformat
	mov	rsi, inputprompt
	call	printf

;===== receive user input ======================================================

	push qword 0
	mov qword  rax, 0
	mov	rdi, integerformat
	mov	rsi, rsp
	call	scanf

	cdqe
	pop	r15	;stores the number of partial sums

;===== print out the current clock time =====

	rdtsc
	shl	rdx, 32
	or	rdx, rax
	mov	r13, rdx ;r13 stores the current clock time

;===== prepare the registers for loop =====

	cvtis2sd xmm12, r15 ;xmm12 stores condition for loop

	movsd	xmm15, 0x3FF0000000000000  ;counter for sigma loop (start at 1.0)
	movsd	xmm14, 0x3FF0000000000000   ;1.0 (numerator)
	movsd	xmm13, 0x0000000000000000  ;store the sum

;===== beginning of summation loop =============================================
sigma:

	divsd xmm14, xmm15	;ratio = 1/n
	addsd xmm13, xmm14	;sum += ratio

	;check if multiple of 4
	movsd	xmm11, xmm15
	divsd	xmm11, 0x4010000000000000  ;divide by 4.0
	ucomisd xmm11, 0x0000000000000000 ;check if equal to zero
	je	partialsum

sigma2:
	addsd xmm15, 0x3FF0000000000000 ;increment n

	ucomisd xmm15, xmm12
	jbe	sigma ;loop if counter is <= xmm12
	jmp	finish

;===== print out partial sum ===================================================
partialsum:

	push qword 0
	mov	rax, 2
	mov	rdi, partialsumprompt
	movsd	xmm0, xmm15
	movsd	xmm1, xmm13
	call	printf
	pop	rax

	jmp	sigma2


;===== final steps =============================================================
finish:

	push qword 0
	mov	rax, 1
	mov	rdi, finalsum
	movsd	xmm0, xmm13
	call	printf
	pop rax

	pop	r15
	pop	r14
	pop    r13
	pop    r12
	pop    r11
	pop    r10
	pop    r9
	pop    r8
	pop    rdi
	pop    rsi
	pop    rdx
	pop    rcx
	pop    rbx
	pop    rbp

	ret
