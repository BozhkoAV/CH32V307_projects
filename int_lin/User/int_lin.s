.globl int_lin

.text
int_lin:
li a7, 0x40001024;

// div_N = (N_out - N_in) / (N_in - 1);
sub a1, t3, t0;   // a1 = N_out - N_in
add a2, t0, -1;   // a2 = N_in - 1
div a0, a1, a2;   // div_N = a0 = a1 / a2

// mod_N = (N_out - N_in) % (N_in - 1);
rem a1, a1, a2;   // mod_N = a1 = a1 % a2

// for (int i = 0; i < N_in - 1; i++) {
li a3, 0;         // i = t0 = 0
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

lw t3, 0(a7);
// prev_x = input_x[0];
flw ft0, 0(t1); // ft0 = prev_x = input_x[0]
// prev_y = input_y[0];
flw ft1, 0(t2); // ft1 = prev_y = input_y[0]

// for (int i = 1; i < N_in; i++) {
li a3, 1;         // a3 = i = 1
for_loop_2:
	// output_x[k] = prev_x;
	fsw ft0, 0(t4);
	// output_y[k] = prev_y;
	fsw ft1, 0(t5);
	// next_x = input_x[i];
	add t1, t1, 4;
	flw ft2, 0(t1);
	// next_y = input_y[i];
	add t2, t2, 4;
	flw ft3, 0(t2);
	// k++ (+1 word);
	add t4, t4, 4;
	add t5, t5, 4;

	// for (int j = 0; j < interval[i-1]; j++) {
	li a4, 0;         // j = a4 = 0
	add a5, t6, 0;	  // a5 = 忘忱把快扼 interval[0]
	add a0, a3, 0;    // a0 = a3 = i
	slli a0, a0, 2;   // a0 = a0 * 4
	add a5, a5, a0;   // a5 = a5 + a0 = a5 + i * 4 = a5 + i words
	add a5, a5, -4;   // a5 = a5 - 4 = a5 - 1 word
	lw a0, 0(a5);     // a0 = interval[i-1]
	add a1, a0, 1;    // a1 = a0 + 1 = interval[i-1] + 1
	fcvt.s.w ft4, a1; // ft4 = a1 (int -> float)

	for_loop_3:
		// output_x[k] = (next_x - prev_x) * (j + 1) / (interval[i-1] + 1) + prev_x;
		add a4, a4, 1;        // a4 = j + 1
		fcvt.s.w ft5, a4;     // ft5 = a4 (int -> float)
		fsub.s ft6, ft2, ft0; // ft6 = ft2 - ft0 = next_x - prev_x
		fmul.s ft6, ft6, ft5; // ft6 = ft6 * ft5 = (next_x - prev_x) * (j + 1)
		fdiv.s ft6, ft6, ft4; // ft6 = ft6 / ft4 = (next_x - prev_x) * (j + 1) / (interval[i-1] + 1)
		fadd.s ft6, ft6, ft0; // ft6 = ft6 + ft0 = (next_x - prev_x) * (j + 1) / (interval[i-1] + 1) + prev_x
		fsw ft6, 0(t4);       // output_x[k] = ft6

		// output_y[k] = (output_x[k] - prev_x) * (prev_y - next_y) / (prev_x - next_x) + prev_y;
		fsub.s ft6, ft6, ft0; // ft6 = ft6 - ft0 = output_x[k] - prev_x
		fsub.s ft5, ft1, ft3; // ft5 = ft1 - ft3 = prev_y - next_y
		fmul.s ft6, ft6, ft5; // ft6 = ft6 * ft5 = (output_x[k] - prev_x) * (prev_y - next_y)
		fsub.s ft5, ft0, ft2; // ft5 = ft0 - ft2 = prev_x - next_x
		fdiv.s ft6, ft6, ft5; // ft6 = ft6 / ft5 = (output_x[k] - prev_x) * (prev_y - next_y) / (prev_x - next_x)
		fadd.s ft6, ft6, ft1; // ft6 = ft6 + ft1 = (output_x[k] - prev_x) * (prev_y - next_y) / (prev_x - next_x) + prev_y
		fsw ft6, 0(t5);       // output_y[k] = ft6

		// k++; (+1 word);
		add t4, t4, 4;
		add t5, t5, 4;
		blt a4, a0, for_loop_3; // go to for_loop_3 if j < interval[i-1] (a4 < a0)
	// }

	// prev_x = next_x;
	flw ft0, 0(t1);  // ft0 = input_x[i] = next_x
	// prev_y = next_y;
	flw ft1, 0(t2);  // ft1 = input_y[i] = next_y

	add a3, a3, 1;  // i++
	blt a3, t0, for_loop_2; // go to for_loop_2 if i < N_in (a3 < t0)
// }

// output_x[N_out-1] = input_x[N_in-1];
flw ft2, 0(t1);  // ft2 = input_x[N_in-1]
fsw ft2, 0(t4);  // output_x[N_out-1] = ft2

// output_y[N_out-1] = input_y[N_in-1];
flw ft3, 0(t2);  // ft3 = input_y[N_in-1]
fsw ft3, 0(t5);  // output_y[N_out-1] = ft3

lw t2, 0(a7);
sub t2, t2, t3;

jr ra;
