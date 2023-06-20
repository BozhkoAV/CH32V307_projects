.globl ext

.text
ext:
li a6, 0x40001024;
flw ft1, 0(t1);       // ft1 = input_x[0]
add a1, t1, 4;
flw ft2, 0(a1);       // ft2 = input_x[1]
fsub.s ft0, ft2, ft1; // ft0 = ft2 - ft1 = delta = input_x[1] - input_x[0]
add a1, t5, 0;        // §Ñ§Õ§â§Ö§ã output_y[0]

lw t6, 0(a6);
// for (int i = 0; i < N_in; i++) {
li a0, 0;             // i = a0 = 0
fcvt.s.w ft3, zero;   // ft4 = 0

for_loop:
	// x_i = input_x[i];
	flw ft1, 0(t1);       // ft1 = x_i = input_x[i]
	// y_i = input_y[i];
	flw ft2, 0(t2);       // ft2 = y_i = input_y[i]
	// output_x[i] = x_i;
	fsw ft1, 0(t4);       // output_x[i] = x_i = ft1
	// output_y[i] = y_i;
	fsw ft2, 0(t5);       // output_y[i] = y_i = ft2

	fadd.s ft3, ft3, ft2; // ft3 = ft3 + ft2 = ft3 + y_i

	// i++;
	add t1, t1, 4;
	add t2, t2, 4;
	add t4, t4, 4;
	add t5, t5, 4;
	add a0, a0, 1;
	blt a0, t0, for_loop; // go to for_loop_4 if i < N_in (a0 < t0)
// }


// for (int i = 0; i < N_in; i++) {
li a0, 0;             // i = a0 = 0
fcvt.s.w ft4, t0;     // ft4 = N_in
sub t3, t3, t0;       // t3 = t3 - t0 = N_out - N_in

for_loop_2:
	// x_i = x_N_in-1 + delta;
	fadd.s ft1, ft1, ft0;   // ft1 = ft1 + ft0 = x_N_in-1 + delta
	// output_x[i] = x_i;
	fsw ft1, 0(t4);         // output_x[i] = x_i = ft4

	fdiv.s ft5, ft3, ft4;   // ft5 = ft3 / ft4 = (y_i + ... + y_i+N_in-1) / N_in
	fsw ft5, 0(t5);         // output_y[i] = y_i = ft5

	flw ft6, 0(a1);         // ft6 = output_y[i-N_in]
	fsub.s ft3, ft3, ft6;   // ft3 = ft3 - ft6 = (y_i + ... + y_i+N_in-1) - output_y[i-N_in]
	fadd.s ft3, ft3, ft5;   // ft3 = ft3 + ft5 = (y_i + ... + y_i+N_in-1) - output_y[i-N_in] + output_y[i]

	// i++;
	add t4, t4, 4;
	add t5, t5, 4;
	add a1, a1, 4;
	add a0, a0, 1;
	blt a0, t3, for_loop_2; // go to for_loop_4 if i < N_out - N_in (a0 < t3)
// }

lw t2, 0(a6);
sub t2, t2, t6;
jr ra;
