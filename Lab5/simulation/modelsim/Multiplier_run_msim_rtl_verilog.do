transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/Brock/School/ECE385/GitLab/ece385/Lab5 {C:/Users/Brock/School/ECE385/GitLab/ece385/Lab5/ShiftRegister.sv}
vlog -sv -work work +incdir+C:/Users/Brock/School/ECE385/GitLab/ece385/Lab5 {C:/Users/Brock/School/ECE385/GitLab/ece385/Lab5/RippleCarryAdder.sv}
vlog -sv -work work +incdir+C:/Users/Brock/School/ECE385/GitLab/ece385/Lab5 {C:/Users/Brock/School/ECE385/GitLab/ece385/Lab5/ArithmaticUnit.sv}
vlog -sv -work work +incdir+C:/Users/Brock/School/ECE385/GitLab/ece385/Lab5 {C:/Users/Brock/School/ECE385/GitLab/ece385/Lab5/8BitMultiplier-toplevel.sv}
vlog -sv -work work +incdir+C:/Users/Brock/School/ECE385/GitLab/ece385/Lab5 {C:/Users/Brock/School/ECE385/GitLab/ece385/Lab5/counter.sv}
vlog -sv -work work +incdir+C:/Users/Brock/School/ECE385/GitLab/ece385/Lab5 {C:/Users/Brock/School/ECE385/GitLab/ece385/Lab5/controlUnit.sv}

vlog -sv -work work +incdir+C:/Users/Brock/School/ECE385/GitLab/ece385/Lab5 {C:/Users/Brock/School/ECE385/GitLab/ece385/Lab5/testbench.sv}
vlog -sv -work work +incdir+C:/Users/Brock/School/ECE385/GitLab/ece385/Lab5 {C:/Users/Brock/School/ECE385/GitLab/ece385/Lab5/ArithmaticUnit.sv}
vlog -sv -work work +incdir+C:/Users/Brock/School/ECE385/GitLab/ece385/Lab5 {C:/Users/Brock/School/ECE385/GitLab/ece385/Lab5/ShiftRegister.sv}
vlog -sv -work work +incdir+C:/Users/Brock/School/ECE385/GitLab/ece385/Lab5 {C:/Users/Brock/School/ECE385/GitLab/ece385/Lab5/RippleCarryAdder.sv}
vlog -sv -work work +incdir+C:/Users/Brock/School/ECE385/GitLab/ece385/Lab5 {C:/Users/Brock/School/ECE385/GitLab/ece385/Lab5/8BitMultiplier-toplevel.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 1000 ns