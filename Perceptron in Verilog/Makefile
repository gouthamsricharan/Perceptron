


SRCS = core_perceptron.v core_perceptron_top.v mem_x1.v mem_x2.v mem_w.v mem_label.v

# Output executable
OUT = simv

# Default target
all: $(OUT)

# Compile all sources into simv
$(OUT): $(SRCS)
	iverilog -o $(OUT) $(SRCS)

# Run the simulation
run: $(OUT)
	vvp $(OUT)

# Clean simulation output
clean:
	rm -f $(OUT) *.vcd
