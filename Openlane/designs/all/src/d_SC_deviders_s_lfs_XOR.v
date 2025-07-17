


`include "d_SC_parameters.vh"
`timescale 1ns / 1ps


module d_SC_serial_lfs_XOR_001(i_message, i_cur_remainder, o_nxt_remainder);

    parameter [0:12] MIN_POLY = 13'b1001100100001;
    input wire i_message;
    input wire [`D_SC_GF_ORDER-1:0] i_cur_remainder;
    output wire [`D_SC_GF_ORDER-1:0] o_nxt_remainder;
    wire w_FB_term;
    assign w_FB_term = i_cur_remainder[`D_SC_GF_ORDER-1];
    assign o_nxt_remainder[0] = i_message ^ w_FB_term;
    genvar i;
    generate
        for (i=1; i<`D_SC_GF_ORDER; i=i+1)
        begin: linear_function
            if (MIN_POLY[i] == 1)
            begin
                assign o_nxt_remainder[i] = i_cur_remainder[i-1] ^ w_FB_term;
            end
            else
            begin
                assign o_nxt_remainder[i] = i_cur_remainder[i-1];
            end
        end
    endgenerate
endmodule

module d_SC_serial_lfs_XOR_003(i_message, i_cur_remainder, o_nxt_remainder);

    parameter [0:12] MIN_POLY = 13'b1111010111001;
    input wire i_message;
    input wire [`D_SC_GF_ORDER-1:0] i_cur_remainder;
    output wire [`D_SC_GF_ORDER-1:0] o_nxt_remainder;
    wire w_FB_term;
    assign w_FB_term = i_cur_remainder[`D_SC_GF_ORDER-1];
    assign o_nxt_remainder[0] = i_message ^ w_FB_term;
    genvar i;
    generate
        for (i=1; i<`D_SC_GF_ORDER; i=i+1)
        begin: linear_function
            if (MIN_POLY[i] == 1)
            begin
                assign o_nxt_remainder[i] = i_cur_remainder[i-1] ^ w_FB_term;
            end
            else
            begin
                assign o_nxt_remainder[i] = i_cur_remainder[i-1];
            end
        end
    endgenerate
endmodule

module d_SC_serial_lfs_XOR_005(i_message, i_cur_remainder, o_nxt_remainder);

    parameter [0:12] MIN_POLY = 13'b1000010100011;
    input wire i_message;
    input wire [`D_SC_GF_ORDER-1:0] i_cur_remainder;
    output wire [`D_SC_GF_ORDER-1:0] o_nxt_remainder;
    wire w_FB_term;
    assign w_FB_term = i_cur_remainder[`D_SC_GF_ORDER-1];
    assign o_nxt_remainder[0] = i_message ^ w_FB_term;
    genvar i;
    generate
        for (i=1; i<`D_SC_GF_ORDER; i=i+1)
        begin: linear_function
            if (MIN_POLY[i] == 1)
            begin
                assign o_nxt_remainder[i] = i_cur_remainder[i-1] ^ w_FB_term;
            end
            else
            begin
                assign o_nxt_remainder[i] = i_cur_remainder[i-1];
            end
        end
    endgenerate
endmodule

module d_SC_serial_lfs_XOR_007(i_message, i_cur_remainder, o_nxt_remainder);

    parameter [0:12] MIN_POLY = 13'b1000010100101;
    input wire i_message;
    input wire [`D_SC_GF_ORDER-1:0] i_cur_remainder;
    output wire [`D_SC_GF_ORDER-1:0] o_nxt_remainder;
    wire w_FB_term;
    assign w_FB_term = i_cur_remainder[`D_SC_GF_ORDER-1];
    assign o_nxt_remainder[0] = i_message ^ w_FB_term;
    genvar i;
    generate
        for (i=1; i<`D_SC_GF_ORDER; i=i+1)
        begin: linear_function
            if (MIN_POLY[i] == 1)
            begin
                assign o_nxt_remainder[i] = i_cur_remainder[i-1] ^ w_FB_term;
            end
            else
            begin
                assign o_nxt_remainder[i] = i_cur_remainder[i-1];
            end
        end
    endgenerate
endmodule

module d_SC_serial_lfs_XOR_009(i_message, i_cur_remainder, o_nxt_remainder);

    parameter [0:12] MIN_POLY = 13'b1101110001111;
    input wire i_message;
    input wire [`D_SC_GF_ORDER-1:0] i_cur_remainder;
    output wire [`D_SC_GF_ORDER-1:0] o_nxt_remainder;
    wire w_FB_term;
    assign w_FB_term = i_cur_remainder[`D_SC_GF_ORDER-1];
    assign o_nxt_remainder[0] = i_message ^ w_FB_term;
    genvar i;
    generate
        for (i=1; i<`D_SC_GF_ORDER; i=i+1)
        begin: linear_function
            if (MIN_POLY[i] == 1)
            begin
                assign o_nxt_remainder[i] = i_cur_remainder[i-1] ^ w_FB_term;
            end
            else
            begin
                assign o_nxt_remainder[i] = i_cur_remainder[i-1];
            end
        end
    endgenerate
endmodule

module d_SC_serial_lfs_XOR_011(i_message, i_cur_remainder, o_nxt_remainder);

    parameter [0:12] MIN_POLY = 13'b1011100010101;
    input wire i_message;
    input wire [`D_SC_GF_ORDER-1:0] i_cur_remainder;
    output wire [`D_SC_GF_ORDER-1:0] o_nxt_remainder;
    wire w_FB_term;
    assign w_FB_term = i_cur_remainder[`D_SC_GF_ORDER-1];
    assign o_nxt_remainder[0] = i_message ^ w_FB_term;
    genvar i;
    generate
        for (i=1; i<`D_SC_GF_ORDER; i=i+1)
        begin: linear_function
            if (MIN_POLY[i] == 1)
            begin
                assign o_nxt_remainder[i] = i_cur_remainder[i-1] ^ w_FB_term;
            end
            else
            begin
                assign o_nxt_remainder[i] = i_cur_remainder[i-1];
            end
        end
    endgenerate
endmodule

module d_SC_serial_lfs_XOR_013(i_message, i_cur_remainder, o_nxt_remainder);

    parameter [0:12] MIN_POLY = 13'b1010101001011;
    input wire i_message;
    input wire [`D_SC_GF_ORDER-1:0] i_cur_remainder;
    output wire [`D_SC_GF_ORDER-1:0] o_nxt_remainder;
    wire w_FB_term;
    assign w_FB_term = i_cur_remainder[`D_SC_GF_ORDER-1];
    assign o_nxt_remainder[0] = i_message ^ w_FB_term;
    genvar i;
    generate
        for (i=1; i<`D_SC_GF_ORDER; i=i+1)
        begin: linear_function
            if (MIN_POLY[i] == 1)
            begin
                assign o_nxt_remainder[i] = i_cur_remainder[i-1] ^ w_FB_term;
            end
            else
            begin
                assign o_nxt_remainder[i] = i_cur_remainder[i-1];
            end
        end
    endgenerate
endmodule

module d_SC_serial_lfs_XOR_015(i_message, i_cur_remainder, o_nxt_remainder);

    parameter [0:12] MIN_POLY = 13'b1000011001111;
    input wire i_message;
    input wire [`D_SC_GF_ORDER-1:0] i_cur_remainder;
    output wire [`D_SC_GF_ORDER-1:0] o_nxt_remainder;
    wire w_FB_term;
    assign w_FB_term = i_cur_remainder[`D_SC_GF_ORDER-1];
    assign o_nxt_remainder[0] = i_message ^ w_FB_term;
    genvar i;
    generate
        for (i=1; i<`D_SC_GF_ORDER; i=i+1)
        begin: linear_function
            if (MIN_POLY[i] == 1)
            begin
                assign o_nxt_remainder[i] = i_cur_remainder[i-1] ^ w_FB_term;
            end
            else
            begin
                assign o_nxt_remainder[i] = i_cur_remainder[i-1];
            end
        end
    endgenerate
endmodule

module d_SC_serial_lfs_XOR_017(i_message, i_cur_remainder, o_nxt_remainder);

    parameter [0:12] MIN_POLY = 13'b1011111000001;
    input wire i_message;
    input wire [`D_SC_GF_ORDER-1:0] i_cur_remainder;
    output wire [`D_SC_GF_ORDER-1:0] o_nxt_remainder;
    wire w_FB_term;
    assign w_FB_term = i_cur_remainder[`D_SC_GF_ORDER-1];
    assign o_nxt_remainder[0] = i_message ^ w_FB_term;
    genvar i;
    generate
        for (i=1; i<`D_SC_GF_ORDER; i=i+1)
        begin: linear_function
            if (MIN_POLY[i] == 1)
            begin
                assign o_nxt_remainder[i] = i_cur_remainder[i-1] ^ w_FB_term;
            end
            else
            begin
                assign o_nxt_remainder[i] = i_cur_remainder[i-1];
            end
        end
    endgenerate
endmodule

module d_SC_serial_lfs_XOR_019(i_message, i_cur_remainder, o_nxt_remainder);

    parameter [0:12] MIN_POLY = 13'b1110010111011;
    input wire i_message;
    input wire [`D_SC_GF_ORDER-1:0] i_cur_remainder;
    output wire [`D_SC_GF_ORDER-1:0] o_nxt_remainder;
    wire w_FB_term;
    assign w_FB_term = i_cur_remainder[`D_SC_GF_ORDER-1];
    assign o_nxt_remainder[0] = i_message ^ w_FB_term;
    genvar i;
    generate
        for (i=1; i<`D_SC_GF_ORDER; i=i+1)
        begin: linear_function
            if (MIN_POLY[i] == 1)
            begin
                assign o_nxt_remainder[i] = i_cur_remainder[i-1] ^ w_FB_term;
            end
            else
            begin
                assign o_nxt_remainder[i] = i_cur_remainder[i-1];
            end
        end
    endgenerate
endmodule

module d_SC_serial_lfs_XOR_021(i_message, i_cur_remainder, o_nxt_remainder);

    parameter [0:12] MIN_POLY = 13'b1000000110101;
    input wire i_message;
    input wire [`D_SC_GF_ORDER-1:0] i_cur_remainder;
    output wire [`D_SC_GF_ORDER-1:0] o_nxt_remainder;
    wire w_FB_term;
    assign w_FB_term = i_cur_remainder[`D_SC_GF_ORDER-1];
    assign o_nxt_remainder[0] = i_message ^ w_FB_term;
    genvar i;
    generate
        for (i=1; i<`D_SC_GF_ORDER; i=i+1)
        begin: linear_function
            if (MIN_POLY[i] == 1)
            begin
                assign o_nxt_remainder[i] = i_cur_remainder[i-1] ^ w_FB_term;
            end
            else
            begin
                assign o_nxt_remainder[i] = i_cur_remainder[i-1];
            end
        end
    endgenerate
endmodule

module d_SC_serial_lfs_XOR_023(i_message, i_cur_remainder, o_nxt_remainder);

    parameter [0:12] MIN_POLY = 13'b1100111001001;
    input wire i_message;
    input wire [`D_SC_GF_ORDER-1:0] i_cur_remainder;
    output wire [`D_SC_GF_ORDER-1:0] o_nxt_remainder;
    wire w_FB_term;
    assign w_FB_term = i_cur_remainder[`D_SC_GF_ORDER-1];
    assign o_nxt_remainder[0] = i_message ^ w_FB_term;
    genvar i;
    generate
        for (i=1; i<`D_SC_GF_ORDER; i=i+1)
        begin: linear_function
            if (MIN_POLY[i] == 1)
            begin
                assign o_nxt_remainder[i] = i_cur_remainder[i-1] ^ w_FB_term;
            end
            else
            begin
                assign o_nxt_remainder[i] = i_cur_remainder[i-1];
            end
        end
    endgenerate
endmodule

module d_SC_serial_lfs_XOR_025(i_message, i_cur_remainder, o_nxt_remainder);

    parameter [0:12] MIN_POLY = 13'b1100100101101;
    input wire i_message;
    input wire [`D_SC_GF_ORDER-1:0] i_cur_remainder;
    output wire [`D_SC_GF_ORDER-1:0] o_nxt_remainder;
    wire w_FB_term;
    assign w_FB_term = i_cur_remainder[`D_SC_GF_ORDER-1];
    assign o_nxt_remainder[0] = i_message ^ w_FB_term;
    genvar i;
    generate
        for (i=1; i<`D_SC_GF_ORDER; i=i+1)
        begin: linear_function
            if (MIN_POLY[i] == 1)
            begin
                assign o_nxt_remainder[i] = i_cur_remainder[i-1] ^ w_FB_term;
            end
            else
            begin
                assign o_nxt_remainder[i] = i_cur_remainder[i-1];
            end
        end
    endgenerate
endmodule

module d_SC_serial_lfs_XOR_027(i_message, i_cur_remainder, o_nxt_remainder);

    parameter [0:12] MIN_POLY = 13'b1011101001111;
    input wire i_message;
    input wire [`D_SC_GF_ORDER-1:0] i_cur_remainder;
    output wire [`D_SC_GF_ORDER-1:0] o_nxt_remainder;
    wire w_FB_term;
    assign w_FB_term = i_cur_remainder[`D_SC_GF_ORDER-1];
    assign o_nxt_remainder[0] = i_message ^ w_FB_term;
    genvar i;
    generate
        for (i=1; i<`D_SC_GF_ORDER; i=i+1)
        begin: linear_function
            if (MIN_POLY[i] == 1)
            begin
                assign o_nxt_remainder[i] = i_cur_remainder[i-1] ^ w_FB_term;
            end
            else
            begin
                assign o_nxt_remainder[i] = i_cur_remainder[i-1];
            end
        end
    endgenerate
endmodule


