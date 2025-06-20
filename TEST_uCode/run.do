vlib work

vlog -lint fpu_parms.sv
vlog -lint fpu_add_RTL.sv
vlog -lint fpu_div_RTL.sv
vlog -lint fpu_mul_RTL.sv
vlog -lint fpu_top_RTL.sv

vlog -lint fpu_def.sv 


vlog -lint fpu_top.sv	+define+NORMAL

vsim work.top  +UVM_VERBOSITY=UVM_DEBUG
do wave.do
run -all