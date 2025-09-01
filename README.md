# NSU CSE332 — MIPS CPU (Verilog) & Validation

A project for NSU CSE332 (Computer Organization and Architecture) based on a provided single-cycle 32-bit MIPS CPU and assembler. Contributions: implemented JAL and JR in Verilog, fixed critical assembler bugs (branch offsets for beq, bne, bgez), added CLI flag for binary/hex output, improved binary field grouping to MIPS conventions, and developed test/validation programs and simulations. Full report is in /Report.

**Course:** CSE 332 — Computer Organization and Architecture  
**Semester:** Summer 25 (Summer 2025)  
**Instructor:** Muhammad Abdul Qaium (MAQm)

## Contents
- Verilog source (CPU modifications for jal/jr, datapath, control)
- Assembler (provided; bug fixes and improvements)
- Benchmarks (minMaxMean, Fibonacci, array tests, branch tests)
- Report (PDF)
- Simulation assets (ModelSim/CPUlator screenshots and memory files)

## Key Features / Changes
- Implemented JAL (stores return addr in $ra) and JR (returns via register) in the supplied Verilog CPU.
- Fixed branch offset computation: Offset = target_address - (PC + 4).
- Added assembler CLI flag to output .text in binary or hex (--hex).
- Improved human-readable output grouping for MIPS fields:
  - R-type: 6 | 5 | 5 | 5 | 5 | 6
  - I-type: 6 | 5 | 5 | 16
  - J-type: 6 | 26
- Test programs validate function calls, branching, memory access, and ALU ops.

## Quick start (Mac)
1. Build assembler (if source available)
```bash
cd Assembler
g++ -O2 -std=c++17 -o MipsAssembler finalassembler.cpp
```

2. Assemble a program
```bash
# binary text format (default)
./MipsAssembler input.s output.text

# hexadecimal formatted output
./MipsAssembler --hex input.s output.text
```

3. Load into Verilog testbench
- For binary text use `$readmemb("instruction.mem", Imem);`

4. Run simulation
- Open ModelSim and create a new project. Add all files and compile.
- Run the simulation using:
```bash
vsim MIPS_SCP_tb.v -do "run -all"
```
- CPUlator: paste assembly into CPUlator web UI to cross-check behavior.

## Test & Validation
- Run provided benchmark programs in /Benchmarks.
- Verify $ra behavior after jal, and correct target after jr.
- Confirm beq/bne/bgez branch behavior by comparing expected PC targets.

## Project structure
```
/Verilog/           # Verilog source files
/Programs/          # Assembly test programs
/Screenshots/       # ModelSim, CPUlator screenshots
Report.pdf          # LaTeX report and PDF
README.md
```

## Authors
- Walidur Rahman — 231 1712 642
- Mridha Fahad Hossain — 231 2199 042
- Sabbir Ahmod — 231 1501 042
- Hasan Al Bannah — 211 2290 642


## Notes
- This project builds on faculty-provided CPU and assembler; contributions focused on correctness (jal/jr, assembler fixes) and validation.
- See Report.pdf for full technical details, diagrams, and benchmarking results.
