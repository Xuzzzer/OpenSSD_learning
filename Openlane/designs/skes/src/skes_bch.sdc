# SDC for SharedKESTop (顶层时钟端口为 iClock，复位为 iReset)


create_clock -name iClock -period 10 [get_ports iClock]


set_clock_uncertainty 0.1 [get_clocks iClock]
set_clock_transition 0.1 [get_clocks iClock]

#同步复位



set_input_delay -max 2.0 -clock [get_clocks iClock] [all_inputs]
set_input_delay -min 0.5 -clock [get_clocks iClock] [all_inputs]


set_output_delay -max 2.0 -clock [get_clocks iClock] [all_outputs]
set_output_delay -min 0.5 -clock [get_clocks iClock] [all_outputs]


set_driving_cell -lib_cell sky130_fd_sc_hd__inv_1 -pin Y [all_inputs]


set_load 0.05 [all_outputs]


set_max_fanout 20 [current_design]
set_max_transition 0.5 [current_design]


set_timing_derate -early 0.95
set_timing_derate -late 1.05


# group_path -name control_signals -from [get_ports iErrorDetectionEnd_* iDecodeNeeded_* iCSAvailable_*] -to [get_ports oSharedKESReady_* oIntraSharedKESEnd_*]
# group_path -name data_path -from [get_ports iSyndromes_*] -to [get_ports oELPCoefficients_* oClusterErrorCount_* oErroredChunk_* oCorrectionFail_*]


set_max_area 0

