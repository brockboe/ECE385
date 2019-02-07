transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/Brock/School/ECE385/GitLab/ece385/Lab4/LogicProcessor {C:/Users/Brock/School/ECE385/GitLab/ece385/Lab4/LogicProcessor/Synchronizers.sv}
vlog -sv -work work +incdir+C:/Users/Brock/School/ECE385/GitLab/ece385/Lab4/LogicProcessor {C:/Users/Brock/School/ECE385/GitLab/ece385/Lab4/LogicProcessor/Router.sv}
vlog -sv -work work +incdir+C:/Users/Brock/School/ECE385/GitLab/ece385/Lab4/LogicProcessor {C:/Users/Brock/School/ECE385/GitLab/ece385/Lab4/LogicProcessor/Reg_4.sv}
vlog -sv -work work +incdir+C:/Users/Brock/School/ECE385/GitLab/ece385/Lab4/LogicProcessor {C:/Users/Brock/School/ECE385/GitLab/ece385/Lab4/LogicProcessor/HexDriver.sv}
vlog -sv -work work +incdir+C:/Users/Brock/School/ECE385/GitLab/ece385/Lab4/LogicProcessor {C:/Users/Brock/School/ECE385/GitLab/ece385/Lab4/LogicProcessor/Control.sv}
vlog -sv -work work +incdir+C:/Users/Brock/School/ECE385/GitLab/ece385/Lab4/LogicProcessor {C:/Users/Brock/School/ECE385/GitLab/ece385/Lab4/LogicProcessor/compute.sv}
vlog -sv -work work +incdir+C:/Users/Brock/School/ECE385/GitLab/ece385/Lab4/LogicProcessor {C:/Users/Brock/School/ECE385/GitLab/ece385/Lab4/LogicProcessor/Register_unit.sv}
vlog -sv -work work +incdir+C:/Users/Brock/School/ECE385/GitLab/ece385/Lab4/LogicProcessor {C:/Users/Brock/School/ECE385/GitLab/ece385/Lab4/LogicProcessor/Processor.sv}

vlog -sv -work work +incdir+C:/Users/Brock/School/ECE385/GitLab/ece385/Lab4/LogicProcessor {C:/Users/Brock/School/ECE385/GitLab/ece385/Lab4/LogicProcessor/testbench_8.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench_8

add wave *
view structure
view signals
run 1000 ns
