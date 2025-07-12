create_clock -name iClock -period 15 [get_ports iClock]

set_clock_uncertainty 0.2 [get_clocks iClock]
set_clock_transition 0.1 [get_clocks iClock]


set_output_delay -max 3.0 -clock iClock [all_outputs]
set_output_delay -min 1 -clock iClock [all_outputs]

set_driving_cell -lib_cell sky130_fd_sc_hd__inv_1 -pin Y [all_inputs]
set_load 0.05 [all_outputs]

set_max_fanout 25 [current_design]
set_max_transition 0.5 [current_design]

set_timing_derate -early 0.95
set_timing_derate -late 1.05

set_max_area 0
