#create work library
vlib work

#compile verilog
vlog vectorbitslicing.v

#run the simulation
vsim work.vectorbitslicing

run 100ns