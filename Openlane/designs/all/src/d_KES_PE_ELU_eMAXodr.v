

`include "d_KES_parameters.vh"
`timescale 1ns / 1ps

module d_KES_PE_ELU_eMAXodr // error locate update module: maximum order + 1 (extended)
(
	input  wire                       i_clk,
	input  wire                       i_RESET_KES,
	input  wire						  i_stop_dec,
	
	input  wire                       i_EXECUTE_PE_ELU,
	
    input  wire [`D_KES_GF_ORDER-1:0] i_k_2i_Xm1,
    input  wire [`D_KES_GF_ORDER-1:0] i_d_2i,
    input  wire [`D_KES_GF_ORDER-1:0] i_delta_2im2,
    
	output reg                        o_v_2i_X_deg_chk_bit
);
	
	parameter [11:0] D_KES_VALUE_ZERO = 12'b0000_0000_0000;
	parameter [11:0] D_KES_VALUE_ONE = 12'b0000_0000_0001;
	
	// FSM parameters
	parameter PE_ELU_RST = 2'b01; // reset
	parameter PE_ELU_OUT = 2'b10; // output buffer update
	
	
	
	// variable declaration
	reg  [1:0] r_cur_state;
	reg  [1:0] r_nxt_state;
	
	
	
	wire [`D_KES_GF_ORDER-1:0] w_v_2ip2_X_term_A;
	wire [`D_KES_GF_ORDER-1:0] w_v_2ip2_X_term_B;
	wire [`D_KES_GF_ORDER-1:0] w_v_2ip2_X;
	reg  [`D_KES_GF_ORDER-1:0] r_v_2i_X;
	
	// update current state to next state
	always @ (posedge i_clk)
	begin
		if ((i_RESET_KES) || (i_stop_dec)) begin
			r_cur_state <= PE_ELU_RST;
		end else begin
			r_cur_state <= r_nxt_state;
		end
	end
	
	// decide next state
	always @ ( * )
	begin
		case (r_cur_state)
		PE_ELU_RST: begin
			r_nxt_state <= (i_EXECUTE_PE_ELU)? (PE_ELU_OUT):(PE_ELU_RST);
		end
		PE_ELU_OUT: begin
			r_nxt_state <= PE_ELU_RST;
		end
		default: begin
			r_nxt_state <= PE_ELU_RST;
		end
		endcase
	end

	// state behaviour
	always @ (posedge i_clk)
	begin
		if ((i_RESET_KES) || (i_stop_dec)) begin // initializing
			r_v_2i_X[`D_KES_GF_ORDER-1:0] <= D_KES_VALUE_ZERO[`D_KES_GF_ORDER-1:0];
			o_v_2i_X_deg_chk_bit <= 0;
		end
		
		else begin		
			case (r_nxt_state)
			PE_ELU_RST: begin // hold original data
				r_v_2i_X[`D_KES_GF_ORDER-1:0] <= r_v_2i_X[`D_KES_GF_ORDER-1:0];
				o_v_2i_X_deg_chk_bit <= o_v_2i_X_deg_chk_bit;
			end
			
			PE_ELU_OUT: begin // output update only
				r_v_2i_X[`D_KES_GF_ORDER-1:0] <= w_v_2ip2_X[`D_KES_GF_ORDER-1:0]; // internal only
				o_v_2i_X_deg_chk_bit <= |(w_v_2ip2_X[`D_KES_GF_ORDER-1:0]);
			end
			default: begin
				r_v_2i_X[`D_KES_GF_ORDER-1:0] <= D_KES_VALUE_ZERO[`D_KES_GF_ORDER-1:0];
				o_v_2i_X_deg_chk_bit <= 0;
			end
			endcase
		end
	end
	
	
	
	d_parallel_FFM_gate_GF12 d_delta_2im2_FFM_v_2i_X (
    .i_poly_form_A     (i_delta_2im2[`D_KES_GF_ORDER-1:0]), 
    .i_poly_form_B     (r_v_2i_X[`D_KES_GF_ORDER-1:0]), 
    .o_poly_form_result(w_v_2ip2_X_term_A[`D_KES_GF_ORDER-1:0]));
	
	d_parallel_FFM_gate_GF12 d_d_2i_FFM_k_2i_Xm1 (
    .i_poly_form_A     (i_d_2i[`D_KES_GF_ORDER-1:0]), 
    .i_poly_form_B     (i_k_2i_Xm1[`D_KES_GF_ORDER-1:0]), 
    .o_poly_form_result(w_v_2ip2_X_term_B[`D_KES_GF_ORDER-1:0]));
	
	assign w_v_2ip2_X[`D_KES_GF_ORDER-1:0] = w_v_2ip2_X_term_A[`D_KES_GF_ORDER-1:0] ^ w_v_2ip2_X_term_B[`D_KES_GF_ORDER-1:0];

endmodule
