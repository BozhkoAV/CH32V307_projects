.globl int_lag

.text
int_lag:
li a6, 0x40001024;

// div_N = (N_out - N_in) / (N_in - 1);
sub a1, t3, t0;   // a1 = N_out - N_in
add a2, t0, -1;   // a2 = N_in - 1
div a0, a1, a2;   // div_N = a0 = a1 / a2

// mod_N = (N_out - N_in) % (N_in - 1);
rem a1, a1, a2;   // mod_N = a1 = a1 % a2

// for (int i = 0; i < N_in - 1; i++) {
li a3, 0;         // i = a3 = 0
add a5, t6, 0;    // a5 = 忘忱把快扼 interval[0]
for_loop:
	add a4, a0, 0;        // N = div_N (a4 = a0)
	bge a3, a1, if_label; // go to if_label if i >= mod_N (a3 >= a1)
	add a4, a4, 1;        // a4 = N + 1
	if_label:
	sw a4, 0(a5);         // interval[i] = N
	add a5, a5, 4;        // a5 = a5 + 4 - 忘忱把快扼 扼抖快忱批攻投快忍抉 改抖快技快扶找忘 技忘扼扼我志忘 interval
	add a3, a3, 1;        // i++
	blt a3, a2, for_loop; // go to for_loop if i < N_in - 1 (a3 < a2)
// }

lw t3, 0(a6);
// x_i_1 = input_x[0];
flw ft0, 0(t1); // ft0 = x_i_1 = input_x[0]
// y_i_1 = input_y[0];
flw ft1, 0(t2); // ft1 = y_i_1 = input_y[0]
// x_i_2 = input_x[1];
add t1, t1, 4;
flw ft2, 0(t1); // ft2 = x_i_2 = input_x[1]
// y_i_2 = input_y[1];
add t2, t2, 4;
flw ft3, 0(t2); // ft3 = y_i_2 = input_y[1]
// x_i_3 = input_x[2];
add t1, t1, 4;
flw ft4, 0(t1); // ft4 = x_i_3 = input_x[2]
// y_i_3 = input_y[2];
add t2, t2, 4;
flw ft5, 0(t2); // ft5 = y_i_3 = input_y[2]

// for (int i = 2; i < N_in; i++) {
li a3, 2;         // a3 = i = 2
for_loop_2:
	// output_x[k] = x_i_1;
	fsw ft0, 0(t4);
	// output_y[k] = y_i_1;
	fsw ft1, 0(t5);
	// k++ (+1 word);
	add t4, t4, 4;
	add t5, t5, 4;

	// for (int j = 0; j < interval[i-2]; j++) {
	li a4, 0;         // j = a4 = 0
	add a0, t6, 0;	  // a0 = 忘忱把快扼 interval[0]
	add a5, a3, -2;   // a5 = a3 - 2 = i - 2
	slli a5, a5, 2;   // a5 = a5 * 4
	add a0, a0, a5;   // a0 = a0 + a5 = a0 + (i - 2) * 4 = a5 + (i - 2) words
	lw a5, 0(a0);     // a5 = interval[i-2]
	add a1, a5, 1;    // a1 = a5 + 1 = interval[i-2] + 1
	fcvt.s.w ft6, a1; // ft6 = a1 (int -> float)

	for_loop_3:
		// output_x[k] = (x_i_2 - x_i_1) * (j + 1) / (interval[i-2] + 1) + x_i_1;
		add a4, a4, 1;        // a4 = j + 1
		fcvt.s.w ft7, a4;     // ft7 = a4 (int -> float)
		fsub.s ft8, ft2, ft0; // ft8 = ft2 - ft0 = x_i_2 - x_i_1
		fmul.s ft8, ft8, ft7; // ft8 = ft8 * ft7 = (x_i_2 - x_i_1) * (j + 1)
		fdiv.s ft8, ft8, ft6; // ft8 = ft8 / ft6 = (x_i_2 - x_i_1) * (j + 1) / (interval[i-2] + 1)
		fadd.s ft8, ft8, ft0; // ft8 = ft8 + ft0 = (x_i_2 - x_i_1) * (j + 1) / (interval[i-2] + 1) + x_i_1
		fsw ft8, 0(t4);       // output_x[k] = ft8
		jal a7, point_calc;
		blt a4, a5, for_loop_3; // go to for_loop_3 if j < interval[i-2] (a4 < a5)
	// }

	// if (i < N_in - 1) {
	bge a3, a2, if_label_2;  // go to if_label if i >= N_in - 1 (a3 >= a2)

	// x_i_1 = x_i_2;
	fcvt.s.w ft0, zero;    // ft0 = x_i_1 = 0
	fadd.s ft0, ft0, ft2;  // ft0 = ft2 (x_i_1 = x_i_2)
	// y_i_1 = y_i_2;
	fcvt.s.w ft1, zero;    // ft1 = y_i_1 = 0
	fadd.s ft1, ft1, ft3;  // ft1 = ft3 (y_i_1 = y_i_2)
	// x_i_2 = x_i_3;
	fcvt.s.w ft2, zero;    // ft2 = x_i_2 = 0
	fadd.s ft2, ft2, ft4;  // ft2 = ft4 (x_i_2 = x_i_3)
	// y_i_2 = y_i_3;
	fcvt.s.w ft3, zero;    // ft3 = y_i_2 = 0
	fadd.s ft3, ft3, ft5;  // ft3 = ft5 (y_i_2 = y_i_3)
	// x_i_3 = input_x[i+1];
	add t1, t1, 4;
	flw ft4, 0(t1);        // ft4 = x_i_3 = input_x[i+1]
	// y_i_3 = input_y[i+1];
	add t2, t2, 4;
	flw ft5, 0(t2);        // ft5 = y_i_3 = input_y[i+1]

	if_label_2:
	// }

	add a3, a3, 1;  // i++
	blt a3, t0, for_loop_2; // go to for_loop_2 if i < N_in (a3 < t0)
// }

// output_x[k] = x_i_2;
fsw ft2, 0(t4);     // output_x[k] = ft2
// output_y[k] = y_i_2;
fsw ft3, 0(t5);     // output_y[k] = ft3
// k++; (+1 word);
add t4, t4, 4;
add t5, t5, 4;

// for (int j = 0; j < interval[N_in-2]; j++) {
li a4, 0;         // j = a4 = 0
add a0, t6, 0;	  // a0 = 忘忱把快扼 interval[0]
add a5, t0, -2;   // a5 = a3 - 2 = N_in - 2
slli a5, a5, 2;   // a5 = a5 * 4
add a0, a0, a5;   // a0 = a0 + a5 = a0 + (N_in - 2) * 4 = a5 + (N_in - 2) words
lw a5, 0(a0);     // a5 = interval[N_in-2]
add a1, a5, 1;    // a1 = a5 + 1 = interval[N_in-2] + 1
fcvt.s.w ft6, a1; // ft6 = a1 (int -> float)

for_loop_4:
	// output_x[k] = (x_i_3 - x_i_2) * (j + 1) / (interval[i-2] + 1) + x_i_2;
	add a4, a4, 1;        // a4 = j + 1
	fcvt.s.w ft7, a4;     // ft7 = a4 (int -> float)
	fsub.s ft8, ft4, ft2; // ft8 = ft4 - ft2 = x_i_3 - x_i_2
	fmul.s ft8, ft8, ft7; // ft8 = ft8 * ft7 = (x_i_3 - x_i_2) * (j + 1)
	fdiv.s ft8, ft8, ft6; // ft8 = ft8 / ft6 = (x_i_3 - x_i_2) * (j + 1) / (interval[i-2] + 1)
	fadd.s ft8, ft8, ft2; // ft8 = ft8 + ft2 = (x_i_3 - x_i_2) * (j + 1) / (interval[i-2] + 1) + x_i_2
	fsw ft8, 0(t4);       // output_x[k] = ft8
	jal a7, point_calc;
	blt a4, a5, for_loop_4; // go to for_loop_4 if j < interval[N_in-2] (a4 < a5)
// }

// output_x[k] = x_i_3;
fsw ft4, 0(t4);     // output_x[k] = ft4
// output_y[k] = y_i_3;
fsw ft5, 0(t5);     // output_y[k] = ft5

lw t2, 0(a6);
sub t2, t2, t3;

jr ra;

point_calc:
// output_y[k] =
// = y_i_1 * (output_x[k] - x_i_2) * (output_x[k] - x_i_3) / ((x_i_1 - x_i_2) * (x_i_1 - x_i_3)) +
// + y_i_2 * (output_x[k] - x_i_1) * (output_x[k] - x_i_3) / ((x_i_2 - x_i_1) * (x_i_2 - x_i_3)) +
// + y_i_3 * (output_x[k] - x_i_1) * (output_x[k] - x_i_2) / ((x_i_3 - x_i_1) * (x_i_3 - x_i_2));
fsub.s fa0, ft8, ft0; // fa0 = ft8 - ft0 = output_x[k] - x_i_1
fsub.s fa1, ft8, ft2; // fa1 = ft8 - ft2 = output_x[k] - x_i_2
fsub.s fa2, ft8, ft4; // fa2 = ft8 - ft4 = output_x[k] - x_i_3

fcvt.s.w ft9, zero;   // ft9 = 0
fadd.s ft9, ft9, ft1; // ft9 = ft1 = y_i_1
fmul.s ft9, ft9, fa1; // ft9 = ft9 * fa1 = y_i_1 * (output_x[k] - x_i_2)
fmul.s ft9, ft9, fa2; // ft9 = ft9 * fa2 = y_i_1 * (output_x[k] - x_i_2) * (output_x[k] - x_i_3)
fsub.s fa3, ft0, ft2; // fa3 = ft0 - ft2 = x_i_1 - x_i_2
fdiv.s ft9, ft9, fa3; // ft9 = ft9 / fa3 = y_i_1 * (output_x[k] - x_i_2) * (output_x[k] - x_i_3) / (x_i_1 - x_i_2)
fsub.s fa4, ft0, ft4; // fa4 = ft0 - ft4 = x_i_1 - x_i_3
fdiv.s ft9, ft9, fa4; // ft9 = ft9 / fa4 = y_i_1 * (output_x[k] - x_i_2) * (output_x[k] - x_i_3) / ((x_i_1 - x_i_2) * (x_i_1 - x_i_3))

fcvt.s.w ft10, zero;    // ft10 = 0
fadd.s ft10, ft10, ft3; // ft10 = ft3 = y_i_2
fmul.s ft10, ft10, fa0; // ft10 = ft10 * fa0 = y_i_2 * (output_x[k] - x_i_1)
fmul.s ft10, ft10, fa2; // ft10 = ft10 * fa2 = y_i_2 * (output_x[k] - x_i_1) * (output_x[k] - x_i_3)
fsub.s fa3, ft2, ft0;   // fa3 = ft2 - ft0 = x_i_2 - x_i_1
fdiv.s ft10, ft10, fa3; // ft10 = ft10 / fa3 = y_i_2 * (output_x[k] - x_i_1) * (output_x[k] - x_i_3) / (x_i_2 - x_i_1)
fsub.s fa4, ft2, ft4;   // fa4 = ft2 - ft4 = x_i_2 - x_i_3
fdiv.s ft10, ft10, fa4; // ft10 = ft10 / fa4 = y_i_2 * (output_x[k] - x_i_1) * (output_x[k] - x_i_3) / ((x_i_2 - x_i_1) * (x_i_2 - x_i_3))

fcvt.s.w ft11, zero;    // ft11 = 0
fadd.s ft11, ft11, ft5; // ft11 = ft5 = y_i_3
fmul.s ft11, ft11, fa0; // ft11 = ft11 * fa0 = y_i_3 * (output_x[k] - x_i_1)
fmul.s ft11, ft11, fa1; // ft11 = ft11 * fa1 = y_i_3 * (output_x[k] - x_i_1) * (output_x[k] - x_i_2)
fsub.s fa3, ft4, ft0;   // fa3 = ft4 - ft0 = x_i_3 - x_i_1
fdiv.s ft11, ft11, fa3; // ft11 = ft11 / fa3 = y_i_3 * (output_x[k] - x_i_1) * (output_x[k] - x_i_2) / (x_i_3 - x_i_1)
fsub.s fa4, ft4, ft2;   // fa4 = ft4 - ft2 = x_i_3 - x_i_2
fdiv.s ft11, ft11, fa4; // ft11 = ft11 / fa4 = y_i_3 * (output_x[k] - x_i_1) * (output_x[k] - x_i_2) / ((x_i_3 - x_i_1) * (x_i_3 - x_i_2))

fcvt.s.w fa5, zero;    // fa5 = 0
fadd.s fa5, fa5, ft9;  // fa5 = fa5 + ft9
fadd.s fa5, fa5, ft10; // fa5 = fa5 + ft10
fadd.s fa5, fa5, ft11; // fa5 = fa5 + ft11
fsw fa5, 0(t5);        // output_y[k] = fa5

// k++; (+1 word);
add t4, t4, 4;
add t5, t5, 4;
jr a7;
