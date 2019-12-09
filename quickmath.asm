; The purpose of this assignment is to practice the use of floating point numbers
; in intel x86_64 assemnly language


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
	elapsed db "The elapsed time was %ld tics. At 2.7 GHz that is %lf seconds",10,0
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

;===== prompt the user to input a number =======================================

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
	pop	r15			      ;stores the number of partial sums

;===== print out the current clock time ========================================

	rdtsc
	shl	rdx, 32
	or	rdx, rax
	mov	r14, rdx 		      ;r14 stores the current clock time

	mov qword rax, 0
	mov	rdi, clockprompt 	      ;The clock is now ___ tics...
	mov	rsi, r14
	call	printf

;===== prepare the registers for loop ==========================================

	cvtis2sd xmm12, r15 		      ;cast r15 register to xmm12 stores condition for loop

	movsd	xmm15, 0x3FF0000000000000  ;counter for sigma loop (starts at 1.0)
	movsd	xmm14, 0x3FF0000000000000  ;1.0 (numerator)
	movsd	xmm13, 0x0000000000000000  ;store the sum
	movsd	xmm10, 0x3FF0000000000000  ;store 1.0 for counter

;===== beginning of summation loop =============================================
sigma:

	divsd xmm14, xmm15	;ratio = 1/n
	addsd xmm13, xmm14	;sum += ratio


	movsd	xmm11, xmm15
	divsd	xmm11, 0x4010000000000000  ;divide by 4.0
	ucomisd xmm11, 0x0000000000000000 ;check if multiple of zero
	je	partialsum

sigma2:
	movsd xmm14, 0x3FF0000000000000   ;reset numerator for next loop
	addsd xmm15, xmm10   ;increment n by 1.0

	ucomisd xmm15, xmm12
	jbe	sigma                      ;loop to sigma if counter is <= xmm12
	jmp	finish

;===== print out partial sum ===================================================
partialsum:

	push qword 0
	mov	rax, 2
	mov	rdi, partialsumprompt      ;With ___ terms, the sum is ___
	movsd	xmm0, xmm15
	movsd	xmm1, xmm13
	call	printf

	pop	rax
	jmp	sigma2

;===== print final sum =========================================================

finish:

	push qword 0
	mov	rax, 1
	mov	rdi, finalsum		      ;The Final Sum is ___
	movsd	xmm0, xmm13
	call	printf
	pop rax

;===== print the second clock time =============================================

	rdtsc
	shl	rdx, 32
	or	rdx, rax
	mov	r13, rdx 		      ;r14 stores the current clock time

	mov qword rax, 0
	mov	rdi, clockfinal	      ;The clock is now...
	mov	rsi, r13
	call	printf

;===== calculate the time in seconds ===========================================

	sub	r13, r14		       ;find the runtime in milliseconds

	cvtis2sd xmm9, r13;convert r13 into a float

	;do math to calculate time in seconds on a 2.7 ghz processor


;===== print the runtime to show the user ======================================

	mov qword rax, 0
	mov	rdi, elapsed	      	       ;The elapsed time...
	mov	rsi, r13
	mov	xmm0, xmm9			;!! change to the calculated value printed in block above !!
	call	printf

;===== return the sum to the driver module =====================================

	mov	rax, xmm13

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
