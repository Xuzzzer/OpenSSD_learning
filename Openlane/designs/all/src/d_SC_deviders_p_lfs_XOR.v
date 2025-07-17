


`include "d_SC_parameters.vh"
`timescale 1ns / 1ps


module d_SC_parallel_lfs_XOR_001(i_message, i_cur_remainder, o_nxt_remainder);

    input wire [`D_SC_P_LVL-1:0] i_message;
    input wire [`D_SC_GF_ORDER-1:0] i_cur_remainder;
    output wire [`D_SC_GF_ORDER-1:0] o_nxt_remainder;
    wire [`D_SC_GF_ORDER*(`D_SC_P_LVL+1)-1:0] w_parallel_wire;
    genvar i;
    generate
        for (i=0; i<`D_SC_P_LVL; i=i+1)
        begin: lfs_XOR_blade_enclosure
            d_SC_serial_lfs_XOR_001 lfs_XOR_001_blade(
                .i_message(i_message[i]),
                .i_cur_remainder(w_parallel_wire[`D_SC_GF_ORDER*(i+2)-1:`D_SC_GF_ORDER*(i+1)]),
                .o_nxt_remainder(w_parallel_wire[`D_SC_GF_ORDER*(i+1)-1:`D_SC_GF_ORDER*(i)]  ) );
        end
    endgenerate
    assign w_parallel_wire[`D_SC_GF_ORDER*(`D_SC_P_LVL+1)-1:`D_SC_GF_ORDER*(`D_SC_P_LVL)] = i_cur_remainder[`D_SC_GF_ORDER-1:0];
    assign o_nxt_remainder[`D_SC_GF_ORDER-1:0] = w_parallel_wire[`D_SC_GF_ORDER-1:0];
endmodule

module d_SC_parallel_lfs_XOR_003(i_message, i_cur_remainder, o_nxt_remainder);

    input wire [`D_SC_P_LVL-1:0] i_message;
    input wire [`D_SC_GF_ORDER-1:0] i_cur_remainder;
    output wire [`D_SC_GF_ORDER-1:0] o_nxt_remainder;
    wire [`D_SC_GF_ORDER*(`D_SC_P_LVL+1)-1:0] w_parallel_wire;
    genvar i;
    generate
        for (i=0; i<`D_SC_P_LVL; i=i+1)
        begin: lfs_XOR_blade_enclosure
            d_SC_serial_lfs_XOR_003 lfs_XOR_003_blade(
                .i_message(i_message[i]),
                .i_cur_remainder(w_parallel_wire[`D_SC_GF_ORDER*(i+2)-1:`D_SC_GF_ORDER*(i+1)]),
                .o_nxt_remainder(w_parallel_wire[`D_SC_GF_ORDER*(i+1)-1:`D_SC_GF_ORDER*(i)]  ) );
        end
    endgenerate
    assign w_parallel_wire[`D_SC_GF_ORDER*(`D_SC_P_LVL+1)-1:`D_SC_GF_ORDER*(`D_SC_P_LVL)] = i_cur_remainder[`D_SC_GF_ORDER-1:0];
    assign o_nxt_remainder[`D_SC_GF_ORDER-1:0] = w_parallel_wire[`D_SC_GF_ORDER-1:0];
endmodule

module d_SC_parallel_lfs_XOR_005(i_message, i_cur_remainder, o_nxt_remainder);

    input wire [`D_SC_P_LVL-1:0] i_message;
    input wire [`D_SC_GF_ORDER-1:0] i_cur_remainder;
    output wire [`D_SC_GF_ORDER-1:0] o_nxt_remainder;
    wire [`D_SC_GF_ORDER*(`D_SC_P_LVL+1)-1:0] w_parallel_wire;
    genvar i;
    generate
        for (i=0; i<`D_SC_P_LVL; i=i+1)
        begin: lfs_XOR_blade_enclosure
            d_SC_serial_lfs_XOR_005 lfs_XOR_005_blade(
                .i_message(i_message[i]),
                .i_cur_remainder(w_parallel_wire[`D_SC_GF_ORDER*(i+2)-1:`D_SC_GF_ORDER*(i+1)]),
                .o_nxt_remainder(w_parallel_wire[`D_SC_GF_ORDER*(i+1)-1:`D_SC_GF_ORDER*(i)]  ) );
        end
    endgenerate
    assign w_parallel_wire[`D_SC_GF_ORDER*(`D_SC_P_LVL+1)-1:`D_SC_GF_ORDER*(`D_SC_P_LVL)] = i_cur_remainder[`D_SC_GF_ORDER-1:0];
    assign o_nxt_remainder[`D_SC_GF_ORDER-1:0] = w_parallel_wire[`D_SC_GF_ORDER-1:0];
endmodule

module d_SC_parallel_lfs_XOR_007(i_message, i_cur_remainder, o_nxt_remainder);

    input wire [`D_SC_P_LVL-1:0] i_message;
    input wire [`D_SC_GF_ORDER-1:0] i_cur_remainder;
    output wire [`D_SC_GF_ORDER-1:0] o_nxt_remainder;
    wire [`D_SC_GF_ORDER*(`D_SC_P_LVL+1)-1:0] w_parallel_wire;
    genvar i;
    generate
        for (i=0; i<`D_SC_P_LVL; i=i+1)
        begin: lfs_XOR_blade_enclosure
            d_SC_serial_lfs_XOR_007 lfs_XOR_007_blade(
                .i_message(i_message[i]),
                .i_cur_remainder(w_parallel_wire[`D_SC_GF_ORDER*(i+2)-1:`D_SC_GF_ORDER*(i+1)]),
                .o_nxt_remainder(w_parallel_wire[`D_SC_GF_ORDER*(i+1)-1:`D_SC_GF_ORDER*(i)]  ) );
        end
    endgenerate
    assign w_parallel_wire[`D_SC_GF_ORDER*(`D_SC_P_LVL+1)-1:`D_SC_GF_ORDER*(`D_SC_P_LVL)] = i_cur_remainder[`D_SC_GF_ORDER-1:0];
    assign o_nxt_remainder[`D_SC_GF_ORDER-1:0] = w_parallel_wire[`D_SC_GF_ORDER-1:0];
endmodule

module d_SC_parallel_lfs_XOR_009(i_message, i_cur_remainder, o_nxt_remainder);

    input wire [`D_SC_P_LVL-1:0] i_message;
    input wire [`D_SC_GF_ORDER-1:0] i_cur_remainder;
    output wire [`D_SC_GF_ORDER-1:0] o_nxt_remainder;
    wire [`D_SC_GF_ORDER*(`D_SC_P_LVL+1)-1:0] w_parallel_wire;
    genvar i;
    generate
        for (i=0; i<`D_SC_P_LVL; i=i+1)
        begin: lfs_XOR_blade_enclosure
            d_SC_serial_lfs_XOR_009 lfs_XOR_009_blade(
                .i_message(i_message[i]),
                .i_cur_remainder(w_parallel_wire[`D_SC_GF_ORDER*(i+2)-1:`D_SC_GF_ORDER*(i+1)]),
                .o_nxt_remainder(w_parallel_wire[`D_SC_GF_ORDER*(i+1)-1:`D_SC_GF_ORDER*(i)]  ) );
        end
    endgenerate
    assign w_parallel_wire[`D_SC_GF_ORDER*(`D_SC_P_LVL+1)-1:`D_SC_GF_ORDER*(`D_SC_P_LVL)] = i_cur_remainder[`D_SC_GF_ORDER-1:0];
    assign o_nxt_remainder[`D_SC_GF_ORDER-1:0] = w_parallel_wire[`D_SC_GF_ORDER-1:0];
endmodule

module d_SC_parallel_lfs_XOR_011(i_message, i_cur_remainder, o_nxt_remainder);

    input wire [`D_SC_P_LVL-1:0] i_message;
    input wire [`D_SC_GF_ORDER-1:0] i_cur_remainder;
    output wire [`D_SC_GF_ORDER-1:0] o_nxt_remainder;
    wire [`D_SC_GF_ORDER*(`D_SC_P_LVL+1)-1:0] w_parallel_wire;
    genvar i;
    generate
        for (i=0; i<`D_SC_P_LVL; i=i+1)
        begin: lfs_XOR_blade_enclosure
            d_SC_serial_lfs_XOR_011 lfs_XOR_011_blade(
                .i_message(i_message[i]),
                .i_cur_remainder(w_parallel_wire[`D_SC_GF_ORDER*(i+2)-1:`D_SC_GF_ORDER*(i+1)]),
                .o_nxt_remainder(w_parallel_wire[`D_SC_GF_ORDER*(i+1)-1:`D_SC_GF_ORDER*(i)]  ) );
        end
    endgenerate
    assign w_parallel_wire[`D_SC_GF_ORDER*(`D_SC_P_LVL+1)-1:`D_SC_GF_ORDER*(`D_SC_P_LVL)] = i_cur_remainder[`D_SC_GF_ORDER-1:0];
    assign o_nxt_remainder[`D_SC_GF_ORDER-1:0] = w_parallel_wire[`D_SC_GF_ORDER-1:0];
endmodule

module d_SC_parallel_lfs_XOR_013(i_message, i_cur_remainder, o_nxt_remainder);

    input wire [`D_SC_P_LVL-1:0] i_message;
    input wire [`D_SC_GF_ORDER-1:0] i_cur_remainder;
    output wire [`D_SC_GF_ORDER-1:0] o_nxt_remainder;
    wire [`D_SC_GF_ORDER*(`D_SC_P_LVL+1)-1:0] w_parallel_wire;
    genvar i;
    generate
        for (i=0; i<`D_SC_P_LVL; i=i+1)
        begin: lfs_XOR_blade_enclosure
            d_SC_serial_lfs_XOR_013 lfs_XOR_013_blade(
                .i_message(i_message[i]),
                .i_cur_remainder(w_parallel_wire[`D_SC_GF_ORDER*(i+2)-1:`D_SC_GF_ORDER*(i+1)]),
                .o_nxt_remainder(w_parallel_wire[`D_SC_GF_ORDER*(i+1)-1:`D_SC_GF_ORDER*(i)]  ) );
        end
    endgenerate
    assign w_parallel_wire[`D_SC_GF_ORDER*(`D_SC_P_LVL+1)-1:`D_SC_GF_ORDER*(`D_SC_P_LVL)] = i_cur_remainder[`D_SC_GF_ORDER-1:0];
    assign o_nxt_remainder[`D_SC_GF_ORDER-1:0] = w_parallel_wire[`D_SC_GF_ORDER-1:0];
endmodule

module d_SC_parallel_lfs_XOR_015(i_message, i_cur_remainder, o_nxt_remainder);

    input wire [`D_SC_P_LVL-1:0] i_message;
    input wire [`D_SC_GF_ORDER-1:0] i_cur_remainder;
    output wire [`D_SC_GF_ORDER-1:0] o_nxt_remainder;
    wire [`D_SC_GF_ORDER*(`D_SC_P_LVL+1)-1:0] w_parallel_wire;
    genvar i;
    generate
        for (i=0; i<`D_SC_P_LVL; i=i+1)
        begin: lfs_XOR_blade_enclosure
            d_SC_serial_lfs_XOR_015 lfs_XOR_015_blade(
                .i_message(i_message[i]),
                .i_cur_remainder(w_parallel_wire[`D_SC_GF_ORDER*(i+2)-1:`D_SC_GF_ORDER*(i+1)]),
                .o_nxt_remainder(w_parallel_wire[`D_SC_GF_ORDER*(i+1)-1:`D_SC_GF_ORDER*(i)]  ) );
        end
    endgenerate
    assign w_parallel_wire[`D_SC_GF_ORDER*(`D_SC_P_LVL+1)-1:`D_SC_GF_ORDER*(`D_SC_P_LVL)] = i_cur_remainder[`D_SC_GF_ORDER-1:0];
    assign o_nxt_remainder[`D_SC_GF_ORDER-1:0] = w_parallel_wire[`D_SC_GF_ORDER-1:0];
endmodule

module d_SC_parallel_lfs_XOR_017(i_message, i_cur_remainder, o_nxt_remainder);

    input wire [`D_SC_P_LVL-1:0] i_message;
    input wire [`D_SC_GF_ORDER-1:0] i_cur_remainder;
    output wire [`D_SC_GF_ORDER-1:0] o_nxt_remainder;
    wire [`D_SC_GF_ORDER*(`D_SC_P_LVL+1)-1:0] w_parallel_wire;
    genvar i;
    generate
        for (i=0; i<`D_SC_P_LVL; i=i+1)
        begin: lfs_XOR_blade_enclosure
            d_SC_serial_lfs_XOR_017 lfs_XOR_017_blade(
                .i_message(i_message[i]),
                .i_cur_remainder(w_parallel_wire[`D_SC_GF_ORDER*(i+2)-1:`D_SC_GF_ORDER*(i+1)]),
                .o_nxt_remainder(w_parallel_wire[`D_SC_GF_ORDER*(i+1)-1:`D_SC_GF_ORDER*(i)]  ) );
        end
    endgenerate
    assign w_parallel_wire[`D_SC_GF_ORDER*(`D_SC_P_LVL+1)-1:`D_SC_GF_ORDER*(`D_SC_P_LVL)] = i_cur_remainder[`D_SC_GF_ORDER-1:0];
    assign o_nxt_remainder[`D_SC_GF_ORDER-1:0] = w_parallel_wire[`D_SC_GF_ORDER-1:0];
endmodule

module d_SC_parallel_lfs_XOR_019(i_message, i_cur_remainder, o_nxt_remainder);

    input wire [`D_SC_P_LVL-1:0] i_message;
    input wire [`D_SC_GF_ORDER-1:0] i_cur_remainder;
    output wire [`D_SC_GF_ORDER-1:0] o_nxt_remainder;
    wire [`D_SC_GF_ORDER*(`D_SC_P_LVL+1)-1:0] w_parallel_wire;
    genvar i;
    generate
        for (i=0; i<`D_SC_P_LVL; i=i+1)
        begin: lfs_XOR_blade_enclosure
            d_SC_serial_lfs_XOR_019 lfs_XOR_019_blade(
                .i_message(i_message[i]),
                .i_cur_remainder(w_parallel_wire[`D_SC_GF_ORDER*(i+2)-1:`D_SC_GF_ORDER*(i+1)]),
                .o_nxt_remainder(w_parallel_wire[`D_SC_GF_ORDER*(i+1)-1:`D_SC_GF_ORDER*(i)]  ) );
        end
    endgenerate
    assign w_parallel_wire[`D_SC_GF_ORDER*(`D_SC_P_LVL+1)-1:`D_SC_GF_ORDER*(`D_SC_P_LVL)] = i_cur_remainder[`D_SC_GF_ORDER-1:0];
    assign o_nxt_remainder[`D_SC_GF_ORDER-1:0] = w_parallel_wire[`D_SC_GF_ORDER-1:0];
endmodule

module d_SC_parallel_lfs_XOR_021(i_message, i_cur_remainder, o_nxt_remainder);

    input wire [`D_SC_P_LVL-1:0] i_message;
    input wire [`D_SC_GF_ORDER-1:0] i_cur_remainder;
    output wire [`D_SC_GF_ORDER-1:0] o_nxt_remainder;
    wire [`D_SC_GF_ORDER*(`D_SC_P_LVL+1)-1:0] w_parallel_wire;
    genvar i;
    generate
        for (i=0; i<`D_SC_P_LVL; i=i+1)
        begin: lfs_XOR_blade_enclosure
            d_SC_serial_lfs_XOR_021 lfs_XOR_021_blade(
                .i_message(i_message[i]),
                .i_cur_remainder(w_parallel_wire[`D_SC_GF_ORDER*(i+2)-1:`D_SC_GF_ORDER*(i+1)]),
                .o_nxt_remainder(w_parallel_wire[`D_SC_GF_ORDER*(i+1)-1:`D_SC_GF_ORDER*(i)]  ) );
        end
    endgenerate
    assign w_parallel_wire[`D_SC_GF_ORDER*(`D_SC_P_LVL+1)-1:`D_SC_GF_ORDER*(`D_SC_P_LVL)] = i_cur_remainder[`D_SC_GF_ORDER-1:0];
    assign o_nxt_remainder[`D_SC_GF_ORDER-1:0] = w_parallel_wire[`D_SC_GF_ORDER-1:0];
endmodule

module d_SC_parallel_lfs_XOR_023(i_message, i_cur_remainder, o_nxt_remainder);

    input wire [`D_SC_P_LVL-1:0] i_message;
    input wire [`D_SC_GF_ORDER-1:0] i_cur_remainder;
    output wire [`D_SC_GF_ORDER-1:0] o_nxt_remainder;
    wire [`D_SC_GF_ORDER*(`D_SC_P_LVL+1)-1:0] w_parallel_wire;
    genvar i;
    generate
        for (i=0; i<`D_SC_P_LVL; i=i+1)
        begin: lfs_XOR_blade_enclosure
            d_SC_serial_lfs_XOR_023 lfs_XOR_023_blade(
                .i_message(i_message[i]),
                .i_cur_remainder(w_parallel_wire[`D_SC_GF_ORDER*(i+2)-1:`D_SC_GF_ORDER*(i+1)]),
                .o_nxt_remainder(w_parallel_wire[`D_SC_GF_ORDER*(i+1)-1:`D_SC_GF_ORDER*(i)]  ) );
        end
    endgenerate
    assign w_parallel_wire[`D_SC_GF_ORDER*(`D_SC_P_LVL+1)-1:`D_SC_GF_ORDER*(`D_SC_P_LVL)] = i_cur_remainder[`D_SC_GF_ORDER-1:0];
    assign o_nxt_remainder[`D_SC_GF_ORDER-1:0] = w_parallel_wire[`D_SC_GF_ORDER-1:0];
endmodule

module d_SC_parallel_lfs_XOR_025(i_message, i_cur_remainder, o_nxt_remainder);

    input wire [`D_SC_P_LVL-1:0] i_message;
    input wire [`D_SC_GF_ORDER-1:0] i_cur_remainder;
    output wire [`D_SC_GF_ORDER-1:0] o_nxt_remainder;
    wire [`D_SC_GF_ORDER*(`D_SC_P_LVL+1)-1:0] w_parallel_wire;
    genvar i;
    generate
        for (i=0; i<`D_SC_P_LVL; i=i+1)
        begin: lfs_XOR_blade_enclosure
            d_SC_serial_lfs_XOR_025 lfs_XOR_025_blade(
                .i_message(i_message[i]),
                .i_cur_remainder(w_parallel_wire[`D_SC_GF_ORDER*(i+2)-1:`D_SC_GF_ORDER*(i+1)]),
                .o_nxt_remainder(w_parallel_wire[`D_SC_GF_ORDER*(i+1)-1:`D_SC_GF_ORDER*(i)]  ) );
        end
    endgenerate
    assign w_parallel_wire[`D_SC_GF_ORDER*(`D_SC_P_LVL+1)-1:`D_SC_GF_ORDER*(`D_SC_P_LVL)] = i_cur_remainder[`D_SC_GF_ORDER-1:0];
    assign o_nxt_remainder[`D_SC_GF_ORDER-1:0] = w_parallel_wire[`D_SC_GF_ORDER-1:0];
endmodule

module d_SC_parallel_lfs_XOR_027(i_message, i_cur_remainder, o_nxt_remainder);

    input wire [`D_SC_P_LVL-1:0] i_message;
    input wire [`D_SC_GF_ORDER-1:0] i_cur_remainder;
    output wire [`D_SC_GF_ORDER-1:0] o_nxt_remainder;
    wire [`D_SC_GF_ORDER*(`D_SC_P_LVL+1)-1:0] w_parallel_wire;
    genvar i;
    generate
        for (i=0; i<`D_SC_P_LVL; i=i+1)
        begin: lfs_XOR_blade_enclosure
            d_SC_serial_lfs_XOR_027 lfs_XOR_027_blade(
                .i_message(i_message[i]),
                .i_cur_remainder(w_parallel_wire[`D_SC_GF_ORDER*(i+2)-1:`D_SC_GF_ORDER*(i+1)]),
                .o_nxt_remainder(w_parallel_wire[`D_SC_GF_ORDER*(i+1)-1:`D_SC_GF_ORDER*(i)]  ) );
        end
    endgenerate
    assign w_parallel_wire[`D_SC_GF_ORDER*(`D_SC_P_LVL+1)-1:`D_SC_GF_ORDER*(`D_SC_P_LVL)] = i_cur_remainder[`D_SC_GF_ORDER-1:0];
    assign o_nxt_remainder[`D_SC_GF_ORDER-1:0] = w_parallel_wire[`D_SC_GF_ORDER-1:0];
endmodule


