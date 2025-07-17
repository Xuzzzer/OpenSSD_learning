


`timescale 1ns / 1ps

module d_partial_FFM_gate_6b
(
	input  wire [5:0]  i_a, // input term A
	input  wire [5:0]  i_b, // input term B
	
	output wire [10:0] o_r  // output term result
);
	
	///////////////////////////////////////////////////////////
	// CAUTION! CAUTION! CAUTION! CAUTION! CAUTION! CAUTION! //
	//                                                       //
	//      ONLY FOR  6 BIT POLYNOMIAL MULTIPLICATION        //
	//                                                       //
	// CAUTION! CAUTION! CAUTION! CAUTION! CAUTION! CAUTION! //
	///////////////////////////////////////////////////////////
	
	// multiplication
	assign o_r[10] = (i_a[5]&i_b[5]);
	assign o_r[ 9] = (i_a[4]&i_b[5]) ^ (i_a[5]&i_b[4]);
	assign o_r[ 8] = (i_a[3]&i_b[5]) ^ (i_a[4]&i_b[4]) ^ (i_a[5]&i_b[3]);
	assign o_r[ 7] = (i_a[2]&i_b[5]) ^ (i_a[3]&i_b[4]) ^ (i_a[4]&i_b[3]) ^ (i_a[5]&i_b[2]);
	assign o_r[ 6] = (i_a[1]&i_b[5]) ^ (i_a[2]&i_b[4]) ^ (i_a[3]&i_b[3]) ^ (i_a[4]&i_b[2]) ^ (i_a[5]&i_b[1]);
	assign o_r[ 5] = (i_a[0]&i_b[5]) ^ (i_a[1]&i_b[4]) ^ (i_a[2]&i_b[3]) ^ (i_a[3]&i_b[2]) ^ (i_a[4]&i_b[1]) ^ (i_a[5]&i_b[0]);
	assign o_r[ 4] = (i_a[0]&i_b[4]) ^ (i_a[1]&i_b[3]) ^ (i_a[2]&i_b[2]) ^ (i_a[3]&i_b[1]) ^ (i_a[4]&i_b[0]);
	assign o_r[ 3] = (i_a[0]&i_b[3]) ^ (i_a[1]&i_b[2]) ^ (i_a[2]&i_b[1]) ^ (i_a[3]&i_b[0]);
	assign o_r[ 2] = (i_a[0]&i_b[2]) ^ (i_a[1]&i_b[1]) ^ (i_a[2]&i_b[0]);
	assign o_r[ 1] = (i_a[0]&i_b[1]) ^ (i_a[1]&i_b[0]);
	assign o_r[ 0] = (i_a[0]&i_b[0]);


endmodule
