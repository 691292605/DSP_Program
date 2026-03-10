				.mmregs
				;.ref filter_start
K_DATA_SIZE		.set 8
K_BUFFER_SIZE	.set 8

K_STACK_SIZE	.set 8
K_A				.set 3
K_B				.set 4
K_CIR			.set K_BUFFER_SIZE

STACK			.usect "stack", K_STACK_SIZE
SYSTEM_STACK	.set	K_STACK_SIZE + STACK

DATA_DP			.usect "filter_vars", 0
filterdata		.usect "filter_vars", K_DATA_SIZE
bufferdatay		.usect "filter_vars", K_BUFFER_SIZE*2
bufferdatax		.usect "filter_vars", K_BUFFER_SIZE*2
			
			.data
			.global inputdata
inputdata
	.WORD 21315, 4595, -2444, 11368, 15066, -2014, -8408, 6957
			.text
			.asg AR2, ORIGIN
			.asg AR3, INPUT
			.asg AR4, FILTER
			.asg AR5, OUTPUT

START:
			SSBX FRCT
			SSBX INTM
			LD #DATA_DP, DP
			STM #STACK, SP
			CALL filter_start
			NOP
			NOP
			NOP
LOOP:
			B LOOP

				.def b1, b2, b3, a1, a2
				.def filter_start
b1				.set 1456h
b2				.set 3D07h
b3				.set 3D07h
b4				.set 1456h
a1				.set -103Ah
a2				.set 430Fh
a3				.set -1016h

				.text
filter_start:
				STM #K_CIR, BK
				STM #1, AR0
				STM #inputdata, ORIGIN
				STM #bufferdatax, INPUT
				STM #bufferdatay, FILTER
				STM #filterdata, OUTPUT

				RPT #K_A - 1
				MVDD *ORIGIN+, *INPUT+0%
				STM #bufferdatax, INPUT

				RPT #K_A - 1
				MVDD *INPUT+0%, *FILTER+0%
				STM #bufferdatay, FILTER
				STM #bufferdatax, INPUT

				STM #K_DATA_SIZE - 3 - 1, BRC
				RPTB filter_end - 1
				MVDD *ORIGIN+, *INPUT
				RPT #K_B - 1 - 1
				MAR *INPUT - 0%
				MPY *INPUT + 0%, #b4, B
				LD B, A
				MPY *INPUT + 0%, #b3, B
				ADD B, A
				MPY *INPUT + 0%, #b2, B
				ADD B, A
				MPY *INPUT + 0%, #b1, B
				ADD B, A
				MPY *INPUT + 0%, #a3, B
				ADD B, A
				MPY *INPUT + 0%, #a2, B
				ADD B, A
				MPY *INPUT + 0%, #a1, B
				ADD B, A
				STH A, *FILTER - 0%
				STH A, *OUTPUT+
				MAR *FILTER - 0%
filter_end:		NOP
				RET
				.end
