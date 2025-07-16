
# PCIe 用户逻辑主时钟
create_clock -name user_clk -period 10 [get_ports user_clk_out]

# AXI 接口从属时钟
create_clock -name s0_axi_clk -period 10.0 [get_ports s0_axi_aclk]      ;# 100MHz
create_clock -name m0_axi_clk -period 5.0  [get_ports m0_axi_aclk]      ;# 200MHz
# PCIe 差分参考时钟（常用于GT）
create_clock -name pcie_ref_clk -period 10.0 [get_ports pcie_ref_clk_p]

set_clock_uncertainty 0.15 [get_clocks *]
set_clock_transition 0.2 [get_clocks *]


set_timing_derate -early 0.95 -cell
set_timing_derate -late  1.05 -cell

set_output_delay 2.0 -clock [get_clocks user_clk] [all_outputs]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_1 -pin Y [all_inputs]

set_load 0.05 [all_outputs]

# Fanout and transition limit
set_max_fanout 30 [current_design]
set_max_transition 0.5 [current_design]