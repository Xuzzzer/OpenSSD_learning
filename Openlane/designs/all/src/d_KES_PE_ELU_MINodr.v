


`include "d_KES_parameters.vh"
`timescale 1ns / 1ps

module d_KES_PE_ELU_MINodr // error locate update module: minimum order
(
	input  wire                       i_clk,
	input  wire                       i_RESET_KES,
	input  wire						  i_stop_dec,
	
	input  wire                       i_EXECUTE_PE_ELU,
	
	input  wire [`D_KES_GF_ORDER-1:0] i_delta_2im2,
    
	output reg  [`D_KES_GF_ORDER-1:0] o_v_2i_X,
	output reg                        o_v_2i_X_deg_chk_bit,
    output reg  [`D_KES_GF_ORDER-1:0] o_k_2i_X
);
	
	parameter [11:0] D_KES_VALUE_ZERO = 12'b0000_0000_0000;
	parameter [11:0] D_KES_VALUE_ONE = 12'b0000_0000_0001;
	
	// FSM parameters
	parameter PE_ELU_RST = 2'b01; // reset
	parameter PE_ELU_OUT = 2'b10; // output buffer update
	
	
	
	// variable declaration
	reg [1:0] r_cur_state;
	reg [1:0] r_nxt_state;
	
	
	
	wire [`D_KES_GF_ORDER-1:0] w_v_2ip2_X_term_A;
	wire [`D_KES_GF_ORDER-1:0] w_v_2ip2_X;
	
	wire [`D_KES_GF_ORDER-1:0] w_k_2ip2_X;
	
	
	
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
			o_v_2i_X[`D_KES_GF_ORDER-1:0] <= D_KES_VALUE_ONE[`D_KES_GF_ORDER-1:0];
			o_v_2i_X_deg_chk_bit <= 1;
			o_k_2i_X[`D_KES_GF_ORDER-1:0] <= D_KES_VALUE_ONE[`D_KES_GF_ORDER-1:0];
		end
		
		else begin		
			case (r_nxt_state)
			PE_ELU_RST: begin // hold original data
				o_v_2i_X[`D_KES_GF_ORDER-1:0] <= o_v_2i_X[`D_KES_GF_ORDER-1:0];
				o_v_2i_X_deg_chk_bit <= o_v_2i_X_deg_chk_bit;
				o_k_2i_X[`D_KES_GF_ORDER-1:0] <= o_k_2i_X[`D_KES_GF_ORDER-1:0];
			end
			
			PE_ELU_OUT: begin // output update only
				o_v_2i_X[`D_KES_GF_ORDER-1:0] <= w_v_2ip2_X[`D_KES_GF_ORDER-1:0];
				o_v_2i_X_deg_chk_bit <= |(w_v_2ip2_X[`D_KES_GF_ORDER-1:0]);
				o_k_2i_X[`D_KES_GF_ORDER-1:0] <= w_k_2ip2_X[`D_KES_GF_ORDER-1:0];
			end
			default: begin
				o_v_2i_X[`D_KES_GF_ORDER-1:0] <= o_v_2i_X[`D_KES_GF_ORDER-1:0];
				o_v_2i_X_deg_chk_bit <= o_v_2i_X_deg_chk_bit;
				o_k_2i_X[`D_KES_GF_ORDER-1:0] <= o_k_2i_X[`D_KES_GF_ORDER-1:0];
			end
			endcase
		end
	end
	
    d_parallel_FFM_gate_GF12 d_delta_2im2_FFM_v_2i_X (
    .i_poly_form_A     (i_delta_2im2[`D_KES_GF_ORDER-1:0]), 
    .i_poly_form_B     (o_v_2i_X[`D_KES_GF_ORDER-1:0]), 
    .o_poly_form_result(w_v_2ip2_X_term_A[`D_KES_GF_ORDER-1:0]));
	
	assign w_v_2ip2_X[`D_KES_GF_ORDER-1:0] = w_v_2ip2_X_term_A[`D_KES_GF_ORDER-1:0];
	
	assign w_k_2ip2_X[`D_KES_GF_ORDER-1:0] = D_KES_VALUE_ZERO[`D_KES_GF_ORDER-1:0];
	
endmodule
