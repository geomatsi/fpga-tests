#!/bin/bash

if [ -z $1 ] ; then
	echo "usage: ./icarus_sim.sh testbench.v"
	exit 0
fi

echo compile verilog files for simulation
iverilog -s testbench $1 ../src/*.v 

echo run the simulation
vvp -la.lst -n a.out -vcd

echo show the simulation results in GTKwave
gtkwave dump.vcd
