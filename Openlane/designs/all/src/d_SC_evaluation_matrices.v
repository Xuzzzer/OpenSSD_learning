


`include "d_SC_parameters.vh"
`timescale 1ns / 1ps

module d_SC_evaluation_matrix_001(i_in, o_out);

    input wire [11:0] i_in;
    output wire [`D_SC_GF_ORDER-1:0] o_out;
    assign o_out[0] = i_in[0];
    assign o_out[1] = i_in[1];
    assign o_out[2] = i_in[2];
    assign o_out[3] = i_in[3];
    assign o_out[4] = i_in[4];
    assign o_out[5] = i_in[5];
    assign o_out[6] = i_in[6];
    assign o_out[7] = i_in[7];
    assign o_out[8] = i_in[8];
    assign o_out[9] = i_in[9];
    assign o_out[10] = i_in[10];
    assign o_out[11] = i_in[11];
endmodule

module d_SC_evaluation_matrix_002(i_in, o_out);

    input wire [11:0] i_in;
    output wire [`D_SC_GF_ORDER-1:0] o_out;
    assign o_out[0] = i_in[0] ^ i_in[6] ^ i_in[10] ^ i_in[11];
    assign o_out[1] = i_in[9] ^ i_in[11];
    assign o_out[2] = i_in[1] ^ i_in[7] ^ i_in[11];
    assign o_out[3] = i_in[6] ^ i_in[11];
    assign o_out[4] = i_in[2] ^ i_in[6] ^ i_in[8] ^ i_in[9] ^ i_in[10];
    assign o_out[5] = i_in[7] ^ i_in[9] ^ i_in[11];
    assign o_out[6] = i_in[3] ^ i_in[7] ^ i_in[9] ^ i_in[10] ^ i_in[11];
    assign o_out[7] = i_in[6] ^ i_in[8] ^ i_in[11];
    assign o_out[8] = i_in[4] ^ i_in[8] ^ i_in[9] ^ i_in[10];
    assign o_out[9] = i_in[7] ^ i_in[9];
    assign o_out[10] = i_in[5] ^ i_in[9] ^ i_in[10] ^ i_in[11];
    assign o_out[11] = i_in[8] ^ i_in[10];
endmodule

module d_SC_evaluation_matrix_003(i_in, o_out);

    input wire [11:0] i_in;
    output wire [`D_SC_GF_ORDER-1:0] o_out;
    assign o_out[0] = i_in[0] ^ i_in[4] ^ i_in[7] ^ i_in[8] ^ i_in[9] ^ i_in[11];
    assign o_out[1] = i_in[6] ^ i_in[7] ^ i_in[11];
    assign o_out[2] = i_in[8] ^ i_in[10] ^ i_in[11];
    assign o_out[3] = i_in[1] ^ i_in[4] ^ i_in[5] ^ i_in[7] ^ i_in[10] ^ i_in[11];
    assign o_out[4] = i_in[4] ^ i_in[6] ^ i_in[7] ^ i_in[9];
    assign o_out[5] = i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[9] ^ i_in[10] ^ i_in[11];
    assign o_out[6] = i_in[2] ^ i_in[5] ^ i_in[6] ^ i_in[10];
    assign o_out[7] = i_in[4] ^ i_in[5] ^ i_in[9] ^ i_in[10] ^ i_in[11];
    assign o_out[8] = i_in[6] ^ i_in[8] ^ i_in[9] ^ i_in[10];
    assign o_out[9] = i_in[3] ^ i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[10];
    assign o_out[10] = i_in[5] ^ i_in[6] ^ i_in[10] ^ i_in[11];
    assign o_out[11] = i_in[7] ^ i_in[9] ^ i_in[10] ^ i_in[11];
endmodule

module d_SC_evaluation_matrix_004(i_in, o_out);

    input wire [11:0] i_in;
    output wire [`D_SC_GF_ORDER-1:0] o_out;
    assign o_out[0] = i_in[0] ^ i_in[3] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[11];
    assign o_out[1] = i_in[7] ^ i_in[8] ^ i_in[9] ^ i_in[10];
    assign o_out[2] = i_in[6] ^ i_in[9] ^ i_in[10];
    assign o_out[3] = i_in[3] ^ i_in[7] ^ i_in[8] ^ i_in[9] ^ i_in[11];
    assign o_out[4] = i_in[1] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[7] ^ i_in[8] ^ i_in[10] ^ i_in[11];
    assign o_out[5] = i_in[6] ^ i_in[7] ^ i_in[9] ^ i_in[10] ^ i_in[11];
    assign o_out[6] = i_in[5] ^ i_in[7] ^ i_in[11];
    assign o_out[7] = i_in[3] ^ i_in[4] ^ i_in[7] ^ i_in[10] ^ i_in[11];
    assign o_out[8] = i_in[2] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[10] ^ i_in[11];
    assign o_out[9] = i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[9] ^ i_in[11];
    assign o_out[10] = i_in[5] ^ i_in[8] ^ i_in[9];
    assign o_out[11] = i_in[4] ^ i_in[5] ^ i_in[8] ^ i_in[11];
endmodule

module d_SC_evaluation_matrix_005(i_in, o_out);

    input wire [11:0] i_in;
    output wire [`D_SC_GF_ORDER-1:0] o_out;
    assign o_out[0] = i_in[0] ^ i_in[4] ^ i_in[7] ^ i_in[9] ^ i_in[11];
    assign o_out[1] = i_in[5] ^ i_in[7] ^ i_in[8] ^ i_in[9] ^ i_in[10];
    assign o_out[2] = i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[10] ^ i_in[11];
    assign o_out[3] = i_in[3] ^ i_in[5] ^ i_in[6] ^ i_in[9] ^ i_in[10] ^ i_in[11];
    assign o_out[4] = i_in[4] ^ i_in[7] ^ i_in[8] ^ i_in[10];
    assign o_out[5] = i_in[1] ^ i_in[6] ^ i_in[8] ^ i_in[9] ^ i_in[10] ^ i_in[11];
    assign o_out[6] = i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[9] ^ i_in[10];
    assign o_out[7] = i_in[3] ^ i_in[6] ^ i_in[8] ^ i_in[10] ^ i_in[11];
    assign o_out[8] = i_in[4] ^ i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[9];
    assign o_out[9] = i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[9] ^ i_in[10];
    assign o_out[10] = i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[9] ^ i_in[11];
    assign o_out[11] = i_in[4] ^ i_in[6] ^ i_in[10];
endmodule

module d_SC_evaluation_matrix_006(i_in, o_out);

    input wire [11:0] i_in;
    output wire [`D_SC_GF_ORDER-1:0] o_out;
    assign o_out[0] = i_in[0] ^ i_in[2] ^ i_in[4] ^ i_in[8] ^ i_in[10] ^ i_in[11];
    assign o_out[1] = i_in[3] ^ i_in[6] ^ i_in[8] ^ i_in[9] ^ i_in[11];
    assign o_out[2] = i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[11];
    assign o_out[3] = i_in[2] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[9] ^ i_in[11];
    assign o_out[4] = i_in[2] ^ i_in[3] ^ i_in[7] ^ i_in[8] ^ i_in[9] ^ i_in[10];
    assign o_out[5] = i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[8] ^ i_in[10];
    assign o_out[6] = i_in[1] ^ i_in[3] ^ i_in[5] ^ i_in[7] ^ i_in[8] ^ i_in[10];
    assign o_out[7] = i_in[2] ^ i_in[5] ^ i_in[7] ^ i_in[8] ^ i_in[10] ^ i_in[11];
    assign o_out[8] = i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[10] ^ i_in[11];
    assign o_out[9] = i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[9] ^ i_in[11];
    assign o_out[10] = i_in[3] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[11];
    assign o_out[11] = i_in[5] ^ i_in[8] ^ i_in[9] ^ i_in[11];
endmodule

module d_SC_evaluation_matrix_007(i_in, o_out);

    input wire [11:0] i_in;
    output wire [`D_SC_GF_ORDER-1:0] o_out;
    assign o_out[0] = i_in[0] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[7] ^ i_in[10];
    assign o_out[1] = i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[7] ^ i_in[8] ^ i_in[10];
    assign o_out[2] = i_in[2] ^ i_in[5] ^ i_in[7] ^ i_in[10] ^ i_in[11];
    assign o_out[3] = i_in[3] ^ i_in[4] ^ i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[9] ^ i_in[11];
    assign o_out[4] = i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[10] ^ i_in[11];
    assign o_out[5] = i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[7] ^ i_in[10];
    assign o_out[6] = i_in[2] ^ i_in[4] ^ i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[10] ^ i_in[11];
    assign o_out[7] = i_in[1] ^ i_in[4] ^ i_in[6] ^ i_in[9] ^ i_in[10] ^ i_in[11];
    assign o_out[8] = i_in[4] ^ i_in[5] ^ i_in[7] ^ i_in[8] ^ i_in[9] ^ i_in[10] ^ i_in[11];
    assign o_out[9] = i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[9] ^ i_in[10];
    assign o_out[10] = i_in[6] ^ i_in[7] ^ i_in[9] ^ i_in[10];
    assign o_out[11] = i_in[3] ^ i_in[8] ^ i_in[9] ^ i_in[10];
endmodule

module d_SC_evaluation_matrix_008(i_in, o_out);

    input wire [11:0] i_in;
    output wire [`D_SC_GF_ORDER-1:0] o_out;
    assign o_out[0] = i_in[0] ^ i_in[3] ^ i_in[4] ^ i_in[6] ^ i_in[8] ^ i_in[9] ^ i_in[11];
    assign o_out[1] = i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[9];
    assign o_out[2] = i_in[3] ^ i_in[5] ^ i_in[9];
    assign o_out[3] = i_in[4] ^ i_in[7] ^ i_in[8];
    assign o_out[4] = i_in[2] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[9] ^ i_in[11];
    assign o_out[5] = i_in[3] ^ i_in[5] ^ i_in[6] ^ i_in[9] ^ i_in[10] ^ i_in[11];
    assign o_out[6] = i_in[6] ^ i_in[7] ^ i_in[9] ^ i_in[10];
    assign o_out[7] = i_in[2] ^ i_in[5] ^ i_in[6] ^ i_in[8] ^ i_in[10] ^ i_in[11];
    assign o_out[8] = i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[5] ^ i_in[7] ^ i_in[8] ^ i_in[11];
    assign o_out[9] = i_in[3] ^ i_in[4] ^ i_in[6] ^ i_in[8] ^ i_in[9] ^ i_in[10];
    assign o_out[10] = i_in[4] ^ i_in[8] ^ i_in[9] ^ i_in[10] ^ i_in[11];
    assign o_out[11] = i_in[2] ^ i_in[4] ^ i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[9] ^ i_in[10] ^ i_in[11];
endmodule

module d_SC_evaluation_matrix_009(i_in, o_out);

    input wire [11:0] i_in;
    output wire [`D_SC_GF_ORDER-1:0] o_out;
    assign o_out[0] = i_in[0] ^ i_in[3] ^ i_in[5] ^ i_in[8] ^ i_in[9] ^ i_in[10];
    assign o_out[1] = i_in[2] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[8] ^ i_in[10] ^ i_in[11];
    assign o_out[2] = i_in[4] ^ i_in[8] ^ i_in[10];
    assign o_out[3] = i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[9] ^ i_in[10] ^ i_in[11];
    assign o_out[4] = i_in[2] ^ i_in[3] ^ i_in[6] ^ i_in[8] ^ i_in[9] ^ i_in[11];
    assign o_out[5] = i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[8] ^ i_in[10];
    assign o_out[6] = i_in[2] ^ i_in[5] ^ i_in[8] ^ i_in[9] ^ i_in[10];
    assign o_out[7] = i_in[3] ^ i_in[7];
    assign o_out[8] = i_in[2] ^ i_in[3] ^ i_in[5] ^ i_in[7] ^ i_in[9] ^ i_in[10];
    assign o_out[9] = i_in[1] ^ i_in[2] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[10] ^ i_in[11];
    assign o_out[10] = i_in[2] ^ i_in[4] ^ i_in[5] ^ i_in[7] ^ i_in[8] ^ i_in[9] ^ i_in[10];
    assign o_out[11] = i_in[3] ^ i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[9];
endmodule

module d_SC_evaluation_matrix_010(i_in, o_out);

    input wire [11:0] i_in;
    output wire [`D_SC_GF_ORDER-1:0] o_out;
    assign o_out[0] = i_in[0] ^ i_in[2] ^ i_in[6] ^ i_in[7] ^ i_in[9];
    assign o_out[1] = i_in[4] ^ i_in[5] ^ i_in[7] ^ i_in[9];
    assign o_out[2] = i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[7] ^ i_in[9] ^ i_in[10] ^ i_in[11];
    assign o_out[3] = i_in[3] ^ i_in[5] ^ i_in[9];
    assign o_out[4] = i_in[2] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[10];
    assign o_out[5] = i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[9] ^ i_in[10] ^ i_in[11];
    assign o_out[6] = i_in[2] ^ i_in[3] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[9] ^ i_in[11];
    assign o_out[7] = i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[8];
    assign o_out[8] = i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[6] ^ i_in[7] ^ i_in[9] ^ i_in[11];
    assign o_out[9] = i_in[3] ^ i_in[5] ^ i_in[7] ^ i_in[8] ^ i_in[9] ^ i_in[11];
    assign o_out[10] = i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[7] ^ i_in[8] ^ i_in[9] ^ i_in[10];
    assign o_out[11] = i_in[2] ^ i_in[3] ^ i_in[5] ^ i_in[7] ^ i_in[8] ^ i_in[11];
endmodule

module d_SC_evaluation_matrix_011(i_in, o_out);

    input wire [11:0] i_in;
    output wire [`D_SC_GF_ORDER-1:0] o_out;
    assign o_out[0] = i_in[0] ^ i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[8] ^ i_in[11];
    assign o_out[1] = i_in[2] ^ i_in[3] ^ i_in[6] ^ i_in[9];
    assign o_out[2] = i_in[2] ^ i_in[3] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[10];
    assign o_out[3] = i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[9];
    assign o_out[4] = i_in[4] ^ i_in[7] ^ i_in[8] ^ i_in[9];
    assign o_out[5] = i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[8] ^ i_in[10];
    assign o_out[6] = i_in[2] ^ i_in[4] ^ i_in[7] ^ i_in[10] ^ i_in[11];
    assign o_out[7] = i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[8];
    assign o_out[8] = i_in[4] ^ i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[10];
    assign o_out[9] = i_in[4] ^ i_in[6] ^ i_in[9] ^ i_in[10];
    assign o_out[10] = i_in[2] ^ i_in[3] ^ i_in[5] ^ i_in[6] ^ i_in[8] ^ i_in[11];
    assign o_out[11] = i_in[1] ^ i_in[3] ^ i_in[4] ^ i_in[6] ^ i_in[8] ^ i_in[10] ^ i_in[11];
endmodule

module d_SC_evaluation_matrix_012(i_in, o_out);

    input wire [11:0] i_in;
    output wire [`D_SC_GF_ORDER-1:0] o_out;
    assign o_out[0] = i_in[0] ^ i_in[1] ^ i_in[2] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[8] ^ i_in[9] ^ i_in[11];
    assign o_out[1] = i_in[3] ^ i_in[4] ^ i_in[6] ^ i_in[7];
    assign o_out[2] = i_in[2] ^ i_in[3] ^ i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[10] ^ i_in[11];
    assign o_out[3] = i_in[1] ^ i_in[3] ^ i_in[7] ^ i_in[9] ^ i_in[10] ^ i_in[11];
    assign o_out[4] = i_in[1] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[9];
    assign o_out[5] = i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[8] ^ i_in[10] ^ i_in[11];
    assign o_out[6] = i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[8] ^ i_in[9] ^ i_in[10] ^ i_in[11];
    assign o_out[7] = i_in[1] ^ i_in[4] ^ i_in[5] ^ i_in[7] ^ i_in[9];
    assign o_out[8] = i_in[2] ^ i_in[5] ^ i_in[7] ^ i_in[11];
    assign o_out[9] = i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[6] ^ i_in[9] ^ i_in[10];
    assign o_out[10] = i_in[3] ^ i_in[6] ^ i_in[8] ^ i_in[10] ^ i_in[11];
    assign o_out[11] = i_in[4] ^ i_in[6] ^ i_in[7] ^ i_in[10];
endmodule

module d_SC_evaluation_matrix_013(i_in, o_out);

    input wire [11:0] i_in;
    output wire [`D_SC_GF_ORDER-1:0] o_out;
    assign o_out[0] = i_in[0] ^ i_in[3] ^ i_in[5] ^ i_in[9] ^ i_in[10];
    assign o_out[1] = i_in[1] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[7];
    assign o_out[2] = i_in[2] ^ i_in[7] ^ i_in[8] ^ i_in[10];
    assign o_out[3] = i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[10];
    assign o_out[4] = i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[6] ^ i_in[7] ^ i_in[10];
    assign o_out[5] = i_in[1] ^ i_in[6] ^ i_in[8] ^ i_in[10] ^ i_in[11];
    assign o_out[6] = i_in[3] ^ i_in[4] ^ i_in[7] ^ i_in[10];
    assign o_out[7] = i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[9] ^ i_in[11];
    assign o_out[8] = i_in[1] ^ i_in[5] ^ i_in[6] ^ i_in[8] ^ i_in[9] ^ i_in[10] ^ i_in[11];
    assign o_out[9] = i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[7];
    assign o_out[10] = i_in[2] ^ i_in[5] ^ i_in[7] ^ i_in[10] ^ i_in[11];
    assign o_out[11] = i_in[2] ^ i_in[4] ^ i_in[5] ^ i_in[7] ^ i_in[9];
endmodule

module d_SC_evaluation_matrix_014(i_in, o_out);

    input wire [11:0] i_in;
    output wire [`D_SC_GF_ORDER-1:0] o_out;
    assign o_out[0] = i_in[0] ^ i_in[2] ^ i_in[5] ^ i_in[7] ^ i_in[11];
    assign o_out[1] = i_in[2] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[8];
    assign o_out[2] = i_in[1] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[10] ^ i_in[11];
    assign o_out[3] = i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[6] ^ i_in[7] ^ i_in[9] ^ i_in[11];
    assign o_out[4] = i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[9] ^ i_in[10] ^ i_in[11];
    assign o_out[5] = i_in[1] ^ i_in[2] ^ i_in[5] ^ i_in[8] ^ i_in[9] ^ i_in[10] ^ i_in[11];
    assign o_out[6] = i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[9];
    assign o_out[7] = i_in[2] ^ i_in[3] ^ i_in[5] ^ i_in[6] ^ i_in[8] ^ i_in[10];
    assign o_out[8] = i_in[2] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[9];
    assign o_out[9] = i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[5] ^ i_in[11];
    assign o_out[10] = i_in[3] ^ i_in[5] ^ i_in[8] ^ i_in[9];
    assign o_out[11] = i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[8] ^ i_in[11];
endmodule

module d_SC_evaluation_matrix_015(i_in, o_out);

    input wire [11:0] i_in;
    output wire [`D_SC_GF_ORDER-1:0] o_out;
    assign o_out[0] = i_in[0] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[6];
    assign o_out[1] = i_in[3] ^ i_in[5] ^ i_in[6] ^ i_in[9];
    assign o_out[2] = i_in[2] ^ i_in[5] ^ i_in[6] ^ i_in[8] ^ i_in[10];
    assign o_out[3] = i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[9] ^ i_in[10];
    assign o_out[4] = i_in[4] ^ i_in[5] ^ i_in[9] ^ i_in[11];
    assign o_out[5] = i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[8] ^ i_in[11];
    assign o_out[6] = i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[9];
    assign o_out[7] = i_in[1] ^ i_in[2] ^ i_in[4] ^ i_in[10] ^ i_in[11];
    assign o_out[8] = i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[6] ^ i_in[10] ^ i_in[11];
    assign o_out[9] = i_in[2] ^ i_in[3] ^ i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[9] ^ i_in[11];
    assign o_out[10] = i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[6] ^ i_in[8] ^ i_in[10] ^ i_in[11];
    assign o_out[11] = i_in[2] ^ i_in[8] ^ i_in[9] ^ i_in[11];
endmodule

module d_SC_evaluation_matrix_016(i_in, o_out);

    input wire [11:0] i_in;
    output wire [`D_SC_GF_ORDER-1:0] o_out;
    assign o_out[0] = i_in[0] ^ i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[6] ^ i_in[8] ^ i_in[10] ^ i_in[11];
    assign o_out[1] = i_in[2] ^ i_in[3] ^ i_in[7] ^ i_in[11];
    assign o_out[2] = i_in[6];
    assign o_out[3] = i_in[2] ^ i_in[4] ^ i_in[8] ^ i_in[11];
    assign o_out[4] = i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[8] ^ i_in[10];
    assign o_out[5] = i_in[3] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[10];
    assign o_out[6] = i_in[3] ^ i_in[5] ^ i_in[6] ^ i_in[8] ^ i_in[9] ^ i_in[11];
    assign o_out[7] = i_in[1] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[7];
    assign o_out[8] = i_in[1] ^ i_in[4] ^ i_in[8] ^ i_in[9] ^ i_in[11];
    assign o_out[9] = i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[9] ^ i_in[11];
    assign o_out[10] = i_in[2] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[11];
    assign o_out[11] = i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[7] ^ i_in[9] ^ i_in[10];
endmodule

module d_SC_evaluation_matrix_017(i_in, o_out);

    input wire [11:0] i_in;
    output wire [`D_SC_GF_ORDER-1:0] o_out;
    assign o_out[0] = i_in[0] ^ i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[8] ^ i_in[10];
    assign o_out[1] = i_in[2] ^ i_in[4] ^ i_in[7] ^ i_in[9] ^ i_in[10] ^ i_in[11];
    assign o_out[2] = i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[7] ^ i_in[8] ^ i_in[10];
    assign o_out[3] = i_in[1] ^ i_in[6] ^ i_in[8] ^ i_in[11];
    assign o_out[4] = i_in[1] ^ i_in[4] ^ i_in[7] ^ i_in[9] ^ i_in[10];
    assign o_out[5] = i_in[1] ^ i_in[3] ^ i_in[5] ^ i_in[7] ^ i_in[8];
    assign o_out[6] = i_in[2] ^ i_in[3] ^ i_in[6] ^ i_in[9] ^ i_in[11];
    assign o_out[7] = i_in[1] ^ i_in[2] ^ i_in[4] ^ i_in[5] ^ i_in[10] ^ i_in[11];
    assign o_out[8] = i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[7] ^ i_in[9];
    assign o_out[9] = i_in[1] ^ i_in[4] ^ i_in[5] ^ i_in[7];
    assign o_out[10] = i_in[3] ^ i_in[4] ^ i_in[7] ^ i_in[8] ^ i_in[9];
    assign o_out[11] = i_in[2] ^ i_in[4] ^ i_in[9] ^ i_in[10];
endmodule

module d_SC_evaluation_matrix_018(i_in, o_out);

    input wire [11:0] i_in;
    output wire [`D_SC_GF_ORDER-1:0] o_out;
    assign o_out[0] = i_in[0] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[10];
    assign o_out[1] = i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[9] ^ i_in[10] ^ i_in[11];
    assign o_out[2] = i_in[2] ^ i_in[4] ^ i_in[5] ^ i_in[9] ^ i_in[10] ^ i_in[11];
    assign o_out[3] = i_in[2] ^ i_in[3] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[10];
    assign o_out[4] = i_in[1] ^ i_in[3] ^ i_in[4] ^ i_in[6] ^ i_in[7] ^ i_in[9] ^ i_in[10] ^ i_in[11];
    assign o_out[5] = i_in[1] ^ i_in[2] ^ i_in[4] ^ i_in[5] ^ i_in[7] ^ i_in[9] ^ i_in[10] ^ i_in[11];
    assign o_out[6] = i_in[1] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[9] ^ i_in[10];
    assign o_out[7] = i_in[6] ^ i_in[9];
    assign o_out[8] = i_in[1] ^ i_in[5] ^ i_in[7] ^ i_in[8] ^ i_in[9] ^ i_in[10];
    assign o_out[9] = i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[8] ^ i_in[10] ^ i_in[11];
    assign o_out[10] = i_in[1] ^ i_in[2] ^ i_in[4] ^ i_in[5] ^ i_in[7] ^ i_in[10] ^ i_in[11];
    assign o_out[11] = i_in[3] ^ i_in[4] ^ i_in[8];
endmodule

module d_SC_evaluation_matrix_019(i_in, o_out);

    input wire [11:0] i_in;
    output wire [`D_SC_GF_ORDER-1:0] o_out;
    assign o_out[0] = i_in[0] ^ i_in[2] ^ i_in[3] ^ i_in[6] ^ i_in[8] ^ i_in[9] ^ i_in[11];
    assign o_out[1] = i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[9];
    assign o_out[2] = i_in[1] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[9];
    assign o_out[3] = i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[7] ^ i_in[8] ^ i_in[11];
    assign o_out[4] = i_in[5] ^ i_in[7] ^ i_in[9] ^ i_in[10] ^ i_in[11];
    assign o_out[5] = i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[8] ^ i_in[9];
    assign o_out[6] = i_in[1] ^ i_in[4] ^ i_in[5] ^ i_in[7] ^ i_in[10];
    assign o_out[7] = i_in[1] ^ i_in[4] ^ i_in[7] ^ i_in[8] ^ i_in[9] ^ i_in[11];
    assign o_out[8] = i_in[6] ^ i_in[9] ^ i_in[11];
    assign o_out[9] = i_in[1] ^ i_in[3] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[10] ^ i_in[11];
    assign o_out[10] = i_in[1] ^ i_in[8] ^ i_in[10];
    assign o_out[11] = i_in[1] ^ i_in[2] ^ i_in[5] ^ i_in[7] ^ i_in[11];
endmodule

module d_SC_evaluation_matrix_020(i_in, o_out);

    input wire [11:0] i_in;
    output wire [`D_SC_GF_ORDER-1:0] o_out;
    assign o_out[0] = i_in[0] ^ i_in[1] ^ i_in[3] ^ i_in[8] ^ i_in[9] ^ i_in[10];
    assign o_out[1] = i_in[2] ^ i_in[9];
    assign o_out[2] = i_in[2] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[9] ^ i_in[11];
    assign o_out[3] = i_in[6] ^ i_in[9];
    assign o_out[4] = i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[5] ^ i_in[7] ^ i_in[8] ^ i_in[9];
    assign o_out[5] = i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[9];
    assign o_out[6] = i_in[1] ^ i_in[3] ^ i_in[4] ^ i_in[6] ^ i_in[9] ^ i_in[10];
    assign o_out[7] = i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[7] ^ i_in[11];
    assign o_out[8] = i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[9];
    assign o_out[9] = i_in[4] ^ i_in[6] ^ i_in[9] ^ i_in[11];
    assign o_out[10] = i_in[1] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[9] ^ i_in[11];
    assign o_out[11] = i_in[1] ^ i_in[4] ^ i_in[6] ^ i_in[8] ^ i_in[10] ^ i_in[11];
endmodule

module d_SC_evaluation_matrix_021(i_in, o_out);

    input wire [11:0] i_in;
    output wire [`D_SC_GF_ORDER-1:0] o_out;
    assign o_out[0] = i_in[0] ^ i_in[1] ^ i_in[7] ^ i_in[8] ^ i_in[10] ^ i_in[11];
    assign o_out[1] = i_in[1] ^ i_in[4] ^ i_in[8] ^ i_in[10];
    assign o_out[2] = i_in[4] ^ i_in[7] ^ i_in[8] ^ i_in[11];
    assign o_out[3] = i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[9] ^ i_in[10];
    assign o_out[4] = i_in[1] ^ i_in[2] ^ i_in[4] ^ i_in[6] ^ i_in[7];
    assign o_out[5] = i_in[1] ^ i_in[6] ^ i_in[7] ^ i_in[9] ^ i_in[10];
    assign o_out[6] = i_in[2] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[11];
    assign o_out[7] = i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[7] ^ i_in[10] ^ i_in[11];
    assign o_out[8] = i_in[3] ^ i_in[4] ^ i_in[6] ^ i_in[9] ^ i_in[10] ^ i_in[11];
    assign o_out[9] = i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[5] ^ i_in[8] ^ i_in[9] ^ i_in[10];
    assign o_out[10] = i_in[2] ^ i_in[3] ^ i_in[6] ^ i_in[8] ^ i_in[10] ^ i_in[11];
    assign o_out[11] = i_in[1] ^ i_in[3] ^ i_in[4] ^ i_in[7] ^ i_in[8];
endmodule

module d_SC_evaluation_matrix_022(i_in, o_out);

    input wire [11:0] i_in;
    output wire [`D_SC_GF_ORDER-1:0] o_out;
    assign o_out[0] = i_in[0] ^ i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[6] ^ i_in[7] ^ i_in[8];
    assign o_out[1] = i_in[1] ^ i_in[3] ^ i_in[8] ^ i_in[9] ^ i_in[11];
    assign o_out[2] = i_in[1] ^ i_in[3] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[9] ^ i_in[10] ^ i_in[11];
    assign o_out[3] = i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[6] ^ i_in[7] ^ i_in[8];
    assign o_out[4] = i_in[2] ^ i_in[4] ^ i_in[7] ^ i_in[9];
    assign o_out[5] = i_in[1] ^ i_in[2] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[9] ^ i_in[11];
    assign o_out[6] = i_in[1] ^ i_in[2] ^ i_in[5] ^ i_in[6] ^ i_in[8];
    assign o_out[7] = i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[10];
    assign o_out[8] = i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[8] ^ i_in[11];
    assign o_out[9] = i_in[2] ^ i_in[3] ^ i_in[5] ^ i_in[7] ^ i_in[8] ^ i_in[9] ^ i_in[10];
    assign o_out[10] = i_in[1] ^ i_in[3] ^ i_in[4] ^ i_in[6] ^ i_in[8] ^ i_in[9] ^ i_in[10];
    assign o_out[11] = i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[7] ^ i_in[10] ^ i_in[11];
endmodule

module d_SC_evaluation_matrix_023(i_in, o_out);

    input wire [11:0] i_in;
    output wire [`D_SC_GF_ORDER-1:0] o_out;
    assign o_out[0] = i_in[0] ^ i_in[3] ^ i_in[4] ^ i_in[6] ^ i_in[7] ^ i_in[8];
    assign o_out[1] = i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[5] ^ i_in[7] ^ i_in[8] ^ i_in[10];
    assign o_out[2] = i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[8] ^ i_in[10];
    assign o_out[3] = i_in[1] ^ i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[10];
    assign o_out[4] = i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[7] ^ i_in[8] ^ i_in[11];
    assign o_out[5] = i_in[3] ^ i_in[4] ^ i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[10] ^ i_in[11];
    assign o_out[6] = i_in[1] ^ i_in[2] ^ i_in[5] ^ i_in[7] ^ i_in[9];
    assign o_out[7] = i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[7] ^ i_in[9] ^ i_in[10];
    assign o_out[8] = i_in[1] ^ i_in[3] ^ i_in[4];
    assign o_out[9] = i_in[2] ^ i_in[3] ^ i_in[5] ^ i_in[9] ^ i_in[10] ^ i_in[11];
    assign o_out[10] = i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[8] ^ i_in[9];
    assign o_out[11] = i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[10];
endmodule

module d_SC_evaluation_matrix_024(i_in, o_out);

    input wire [11:0] i_in;
    output wire [`D_SC_GF_ORDER-1:0] o_out;
    assign o_out[0] = i_in[0] ^ i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[7] ^ i_in[8] ^ i_in[10] ^ i_in[11];
    assign o_out[1] = i_in[2] ^ i_in[3] ^ i_in[7] ^ i_in[9];
    assign o_out[2] = i_in[1] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[7] ^ i_in[9] ^ i_in[10];
    assign o_out[3] = i_in[5] ^ i_in[7] ^ i_in[8] ^ i_in[9] ^ i_in[11];
    assign o_out[4] = i_in[2] ^ i_in[3] ^ i_in[8];
    assign o_out[5] = i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5];
    assign o_out[6] = i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[9];
    assign o_out[7] = i_in[2] ^ i_in[8] ^ i_in[9];
    assign o_out[8] = i_in[1] ^ i_in[6] ^ i_in[8];
    assign o_out[9] = i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[10];
    assign o_out[10] = i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[7] ^ i_in[9];
    assign o_out[11] = i_in[2] ^ i_in[3] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[10];
endmodule

module d_SC_evaluation_matrix_025(i_in, o_out);

    input wire [11:0] i_in;
    output wire [`D_SC_GF_ORDER-1:0] o_out;
    assign o_out[0] = i_in[0] ^ i_in[3] ^ i_in[7] ^ i_in[8] ^ i_in[9];
    assign o_out[1] = i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[10];
    assign o_out[2] = i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[9] ^ i_in[10] ^ i_in[11];
    assign o_out[3] = i_in[1] ^ i_in[2] ^ i_in[5] ^ i_in[6] ^ i_in[7];
    assign o_out[4] = i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5];
    assign o_out[5] = i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[7] ^ i_in[9] ^ i_in[11];
    assign o_out[6] = i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[7] ^ i_in[8] ^ i_in[10] ^ i_in[11];
    assign o_out[7] = i_in[2] ^ i_in[5] ^ i_in[6] ^ i_in[7];
    assign o_out[8] = i_in[6] ^ i_in[7] ^ i_in[9];
    assign o_out[9] = i_in[1] ^ i_in[2] ^ i_in[5] ^ i_in[7] ^ i_in[9] ^ i_in[11];
    assign o_out[10] = i_in[1] ^ i_in[4] ^ i_in[6] ^ i_in[9];
    assign o_out[11] = i_in[2] ^ i_in[7] ^ i_in[8] ^ i_in[9] ^ i_in[11];
endmodule

module d_SC_evaluation_matrix_026(i_in, o_out);

    input wire [11:0] i_in;
    output wire [`D_SC_GF_ORDER-1:0] o_out;
    assign o_out[0] = i_in[0] ^ i_in[5] ^ i_in[7] ^ i_in[10] ^ i_in[11];
    assign o_out[1] = i_in[2] ^ i_in[6] ^ i_in[9];
    assign o_out[2] = i_in[1] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[11];
    assign o_out[3] = i_in[2] ^ i_in[3] ^ i_in[5] ^ i_in[9] ^ i_in[10];
    assign o_out[4] = i_in[1] ^ i_in[3] ^ i_in[5] ^ i_in[9];
    assign o_out[5] = i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[7] ^ i_in[11];
    assign o_out[6] = i_in[2] ^ i_in[5] ^ i_in[6] ^ i_in[7];
    assign o_out[7] = i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[6] ^ i_in[8] ^ i_in[11];
    assign o_out[8] = i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[9] ^ i_in[10];
    assign o_out[9] = i_in[2] ^ i_in[3] ^ i_in[9] ^ i_in[11];
    assign o_out[10] = i_in[1] ^ i_in[5] ^ i_in[7] ^ i_in[8] ^ i_in[9];
    assign o_out[11] = i_in[1] ^ i_in[2] ^ i_in[6] ^ i_in[7] ^ i_in[8] ^ i_in[9];
endmodule

module d_SC_evaluation_matrix_027(i_in, o_out);

    input wire [11:0] i_in;
    output wire [`D_SC_GF_ORDER-1:0] o_out;
    assign o_out[0] = i_in[0] ^ i_in[1] ^ i_in[3] ^ i_in[4] ^ i_in[9] ^ i_in[11];
    assign o_out[1] = i_in[2] ^ i_in[5] ^ i_in[6] ^ i_in[8];
    assign o_out[2] = i_in[6] ^ i_in[8] ^ i_in[9];
    assign o_out[3] = i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[7] ^ i_in[8];
    assign o_out[4] = i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[9];
    assign o_out[5] = i_in[1] ^ i_in[6] ^ i_in[7];
    assign o_out[6] = i_in[3] ^ i_in[4] ^ i_in[5] ^ i_in[6] ^ i_in[8] ^ i_in[9] ^ i_in[10];
    assign o_out[7] = i_in[1] ^ i_in[4] ^ i_in[6] ^ i_in[8] ^ i_in[9] ^ i_in[11];
    assign o_out[8] = i_in[1] ^ i_in[3] ^ i_in[6] ^ i_in[7];
    assign o_out[9] = i_in[2] ^ i_in[4] ^ i_in[5] ^ i_in[7] ^ i_in[9] ^ i_in[10] ^ i_in[11];
    assign o_out[10] = i_in[3] ^ i_in[8];
    assign o_out[11] = i_in[1] ^ i_in[2] ^ i_in[3] ^ i_in[5] ^ i_in[11];
endmodule



