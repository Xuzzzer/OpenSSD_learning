create_clock -name iClock -period 10 [get_ports iClock]

set_output_delay 2.0 -clock [get_clocks iClock] [all_outputs]
set_output_delay 0.5 -clock [get_clocks iClock] [all_outputs]

set_driving_cell -lib_cell sky130_fd_sc_hd__inv_1 -pin Y [all_inputs]
set_load 0.05 [all_outputs]
set_max_fanout 20 [current_design]
set_max_transition 0.5 [current_design]
set_clock_uncertainty 0.1 [get_clocks iClock]
set_clock_transition 0.1 [get_clocks iClock]
set_timing_derate -early 0.95
set_timing_derate -late 1.05