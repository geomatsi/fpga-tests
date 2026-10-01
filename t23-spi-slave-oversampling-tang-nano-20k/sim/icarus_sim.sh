#!/bin/bash

set -e

usage() {
	echo "usage: ./icarus_sim.sh [-h] [-g] testbench.v"
	echo "  -h  show this help"
	echo "  -g  show the simulation results in GTKwave"
}

gtkwave=0

while getopts "hg" opt; do
	case $opt in
		h) usage; exit 0 ;;
		g) gtkwave=1 ;;
		*) usage; exit 1 ;;
	esac
done
shift $((OPTIND - 1))

if [ -z "$1" ] ; then
	usage
	exit 1
fi

echo compile verilog files for simulation
iverilog -s testbench "$1" ../src/*.v

echo run the simulation
vvp -la.lst -n a.out -vcd

if [ $gtkwave -eq 1 ] ; then
	echo show the simulation results in GTKwave
	gtkwave dump.vcd
fi
