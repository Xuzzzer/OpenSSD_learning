# SDC for FMCTop (顶层时钟端口为 iClock，复位为 iReset)


create_clock -name iClock -period 10 [get_ports iClock]

# 2. 设置时钟不确定性和转换
set_clock_uncertainty 0.1 [get_clocks iClock]
set_clock_transition 0.1 [get_clocks iClock]


# 4. 设置输入延迟（可根据实际需求调整）
set_input_delay -max 2.0 -clock [get_clocks iClock] [all_inputs]
set_input_delay -min 0.5 -clock [get_clocks iClock] [all_inputs]

# 5. 设置输出延迟（可根据实际需求调整）
set_output_delay -max 2.0 -clock [get_clocks iClock] [all_outputs]
set_output_delay -min 0.5 -clock [get_clocks iClock] [all_outputs]

# 6. 设置输入驱动能力（sky130工艺标准单元）
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_1 -pin Y [all_inputs]

# 7. 设置输出负载
set_load 0.05 [all_outputs]

# 8. 设置最大扇出和最大转换
set_max_fanout 20 [current_design]
set_max_transition 0.5 [current_design]

# 9. 工艺裕量
set_timing_derate -early 0.95
set_timing_derate -late 1.05

