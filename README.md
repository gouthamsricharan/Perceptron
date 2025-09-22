# Perceptron-In-Verilog
Perceptron Algorithm and Its Verilog Design

This project implements a Perceptron Learning Algorithm entirely in Verilog HDL.
It demonstrates how a simple perceptron can be realized in hardware using a lightweight core and memory units for training data, weights, and labels.

📖 Overview

Implements a 2-input perceptron with sign activation.

Supports online learning with weight updates.

Uses integer-based arithmetic to approximate floating-point operations.

Organized into modular Verilog files for clarity (core + memory).

Includes dataset files for training/testing and simulation output (.vcd).

🛠️ Project Structure
.
├── core_perceptron.v        # Perceptron core (learning + update logic)
├── core_perceptron_top.v    # Top-level module connecting core + memories
├── mem_label.v              # Memory for labels
├── mem_w.v                  # Memory for weights
├── mem_x1.v                 # Memory for x1 input data
├── mem_x2.v                 # Memory for x2 input data
├── w.txt                    # Initial weight data
├── x1.txt                   # Training input feature x1
├── x2.txt                   # Training input feature x2
├── z.txt                    # Labels for training data
├── perceptron.vcd           # Simulation waveform dump
└── simv                     # Simulation executable (compiled output)

🚀 How to Run
Requirements

Verilog simulation tool (e.g., Icarus Verilog, ModelSim, or Xilinx Vivado).

GTKWave (optional, for waveform viewing).

Steps

Compile the design:

iverilog -o simv core_perceptron_top.v core_perceptron.v mem_*.v


Run the simulation:

vvp simv


View waveforms (optional):

gtkwave perceptron.vcd

📊 Results

Accuracy: ~98% on provided dataset (200 test samples).

Precision: 100%

Sensitivity: 96%

Specificity: 100%

Synthesis (example using 25nm TSMC library):

Area: 0.0078 mm²

Frequency: up to 1.9 GHz

Power: ~1.8 mW

🔮 Future Improvements

Extend the design to support multi-dimensional inputs.

Add more advanced memory controllers for efficient data handling.

Improve scalability for integration with larger ML accelerators.

🙏 Acknowledgments

This work is my original Verilog implementation of a perceptron-based learning system, combining hardware efficiency with fundamental machine learning principles.
