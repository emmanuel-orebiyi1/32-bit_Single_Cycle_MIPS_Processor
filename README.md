# 32-bit Single-Cycle MIPS Processor on FPGA

A 32-bit single-cycle MIPS processor designed and implemented in **Verilog HDL** and deployed on an **Altera DE2 FPGA (Cyclone II)**.

The processor implements a custom MIPS datapath, control unit, ALU, register file, instruction memory, data memory, branching, jumping, and FPGA I/O. It can execute MIPS programs directly on the FPGA, including arithmetic operations and algorithms such as **Two Sum**.

---

## 📌 Project Overview

This project demonstrates the design and implementation of a complete **32-bit single-cycle MIPS processor** from the hardware level.

Each instruction is fetched, decoded, executed, and completed within a single clock cycle. The processor consists of a datapath and control unit that work together to execute supported MIPS instructions.

The processor was implemented using Verilog HDL and tested through simulation before being synthesized and deployed onto an **Altera DE2 development board**.

One of the demonstration programs implemented on the processor is the **Two Sum algorithm**, where the processor searches an array for two values whose sum matches a target value supplied through the FPGA switches.

---

## 🏗️ Architecture

The processor follows a **single-cycle MIPS architecture**.

### Major Components

* Program Counter (PC)
* Instruction Memory
* Register File
* Arithmetic Logic Unit (ALU)
* ALU Control Unit
* Main Control Unit
* Sign Extension Unit
* Data Memory
* Branch Logic
* Jump Logic
* Adders
* Multiplexers
* FPGA Input/Output Interface

### Simplified Datapath

```text
                   ┌──────────────────┐
                   │ Program Counter  │
                   └────────┬─────────┘
                            │
                            ▼
                   ┌──────────────────┐
                   │ Instruction      │
                   │ Memory           │
                   └────────┬─────────┘
                            │
                            ▼
                   ┌──────────────────┐
                   │ Control Unit     │
                   └────────┬─────────┘
                            │
                ┌───────────┴───────────┐
                │                       │
                ▼                       ▼
        ┌───────────────┐       ┌───────────────┐
        │ Register File │       │ Sign Extend   │
        └───────┬───────┘       └───────┬───────┘
                │                       │
                └──────────┬────────────┘
                           ▼
                    ┌───────────────┐
                    │      ALU      │
                    └───────┬───────┘
                            │
                   ┌────────┴────────┐
                   │                 │
                   ▼                 ▼
            ┌─────────────┐   ┌─────────────┐
            │ Data Memory │   │ Write Back  │
            └─────────────┘   └──────┬──────┘
                                     │
                                     ▼
                               Register File
```

### Single-Cycle Operation

For each instruction:

```text
Fetch → Decode → Execute → Memory Access → Write Back
```

All of these operations are completed during one clock cycle.

---

## 🧩 Processor Modules

| Module               | Function                                           |
| -------------------- | -------------------------------------------------- |
| `mips_core`          | Top-level MIPS processor core                      |
| `program_counter`    | Stores and updates the current instruction address |
| `instruction_memory` | Stores program instructions                        |
| `register_file`      | Contains the 32 general-purpose MIPS registers     |
| `alu`                | Performs arithmetic and logical operations         |
| `alu_control`        | Determines the ALU operation                       |
| `control_unit`       | Generates processor control signals                |
| `sign_extend`        | Extends 16-bit immediate values to 32 bits         |
| `data_memory`        | Stores program data                                |
| `branch_logic`       | Handles conditional branch decisions               |
| `jump_logic`         | Handles jump instructions                          |
| `mux`                | Selects between datapath inputs                    |
| `adder`              | Performs address calculations                      |
| `fpga_top`           | Connects the processor to the DE2 FPGA hardware    |

---

# 📖 Instruction Set Supported

The processor implements a subset of the **32-bit MIPS instruction set**.

### R-Type Instructions

| Instruction | Description      |
| ----------- | ---------------- |
| `add`       | Addition         |
| `sub`       | Subtraction      |
| `and`       | Bitwise AND      |
| `or`        | Bitwise OR       |
| `nor`       | Bitwise NOR      |
| `slt`       | Set on Less Than |

### I-Type Instructions

| Instruction | Description          |
| ----------- | -------------------- |
| `addi`      | Add immediate        |
| `lw`        | Load word            |
| `sw`        | Store word           |
| `beq`       | Branch if equal      |
| `lui`       | Load upper immediate |
| `ori`       | OR immediate         |

### J-Type Instructions

| Instruction | Description        |
| ----------- | ------------------ |
| `j`         | Unconditional jump |

The supported instruction set is sufficient to implement arithmetic operations, memory access, conditional execution, loops, and algorithms such as Two Sum.

---

# 🔌 Hardware Used

### FPGA Development Board

**Altera DE2 Development and Education Board**

* **FPGA:** Altera Cyclone II
* **Clock:** 50 MHz
* **Inputs:** Board switches and push buttons
* **Outputs:** LEDs and 7-segment displays

### FPGA I/O

The processor interfaces with the DE2 board through:

* `SW[17:0]` — switches
* `KEY[3:0]` — push buttons
* `LEDR[17:0]` — red LEDs
* `HEX7` – `HEX0` — seven-segment displays
* `CLOCK_50` — 50 MHz system clock

The switches provide inputs to demonstration programs, while the LEDs and seven-segment displays provide visual output.

---

# 💻 Software Used

* **Verilog HDL** — Hardware Description Language
* **Intel Quartus II** — FPGA design, synthesis, compilation, and programming
* **ModelSim** — HDL simulation and waveform analysis
* **Git/GitHub** — Version control and project hosting

---

# 🧪 Simulation

Before deploying the processor to the FPGA, the design can be simulated using ModelSim.

## 1. Open the Project

Open the Quartus project and ensure all Verilog source files are included.

## 2. Compile the Design

In Quartus:

```text
Processing → Start Compilation
```

Resolve any syntax or module errors before proceeding.

## 3. Open ModelSim

Launch ModelSim from Quartus or open it separately.

## 4. Compile the Verilog Files

Compile the processor modules and testbench.

For example:

```tcl
vlog *.v
```

## 5. Start the Simulation

Run the relevant testbench:

```tcl
vsim work.<testbench_name>
```

Add the required signals to the waveform:

```tcl
add wave *
```

Run the simulation:

```tcl
run 1000ns
```

The waveform can then be inspected to verify:

* Program Counter operation
* Instruction fetching
* Register reads/writes
* ALU operations
* Memory access
* Branching
* Jumping
* Processor outputs

---

# ⚙️ Compiling the Project in Quartus

## 1. Open Quartus

Open the Quartus project file (`.qpf`).

## 2. Check the Top-Level Module

The FPGA top-level module is:

```text
fpga_top
```

Make sure it is selected as the top-level entity:

```text
Assignments → Settings → General
```

Set:

```text
Top-level entity: fpga_top
```

## 3. Add the Verilog Files

Ensure all processor modules are included in the Quartus project.

Typical source files include:

```text
fpga_top.v
mips_core.v
program_counter.v
instruction_memory.v
register_file.v
alu.v
alu_control.v
control_unit.v
sign_extend.v
data_memory.v
branch_logic.v
jump_logic.v
mux.v
adder.v
```

## 4. Configure FPGA Pins

The DE2 board's clock, switches, keys, LEDs, and seven-segment displays should be assigned to their corresponding FPGA pins using the project's pin assignment configuration.

## 5. Compile

Select:

```text
Processing → Start Compilation
```

Quartus performs:

```text
Analysis & Synthesis
        ↓
      Fitter
        ↓
    Assembler
        ↓
  Timing Analysis
```

If compilation completes successfully, Quartus generates the FPGA programming file (`.sof`).

---

# 🚀 Running the Processor on the DE2 FPGA

## 1. Connect the DE2 Board

Connect the DE2 FPGA board to the computer using the appropriate USB-Blaster connection and power on the board.

## 2. Open Programmer

In Quartus:

```text
Tools → Programmer
```

## 3. Select the Hardware

Select the appropriate USB-Blaster hardware.

## 4. Load the `.sof` File

Select the generated:

```text
.sof
```

file.

Enable the **Program/Configure** option.

## 5. Program the FPGA

Click:

```text
Start
```

The FPGA will then be configured with the MIPS processor.

---

# 🎮 Running a Program

The processor executes the machine-code program stored in instruction memory.

The program is typically stored in:

```text
program.mem
```

The execution flow is:

```text
instruction_memory
        ↓
   program.mem
        ↓
 MIPS instruction fetch
        ↓
  Execute instruction
```

To run a different program, the instruction memory contents can be changed while keeping the processor hardware unchanged, provided that the program uses the supported instruction set and existing I/O interface.

---

# ➕ Two Sum Demonstration

One of the main demonstrations implemented on the processor is the **Two Sum algorithm**.

The array is stored in data memory, while the target value can be supplied through the FPGA switches.

For example:

```text
Array:
[2, 7, 11, 15, 3, 6, 8, 10]

Target:
9
```

The processor searches for:

```text
2 + 7 = 9
```

Result:

```text
index 0
index 1
```

The MIPS processor executes the algorithm rather than the FPGA directly hardwiring the Two Sum calculation.

The demonstration therefore shows that the processor can:

1. Read input.
2. Access data memory.
3. Perform arithmetic operations.
4. Compare values.
5. Execute loops and branches.
6. Produce a result through FPGA I/O.

---

# 📸 Demonstration

## FPGA Implementation

Add a screenshot of the working DE2 board here:

```markdown
![MIPS Processor Running on DE2 FPGA](images/de2-mips-demo.jpg)
```

## Video Demonstration

Add the demonstration video link here:

```markdown
[▶️ Watch the MIPS Processor Demo](YOUR_VIDEO_LINK_HERE)
```

The demonstration should show the processor executing the program on the physical DE2 FPGA, including the input provided through the switches and the resulting output displayed using the LEDs/7-segment displays.

---

# 👨‍💻 My Contribution

My contributions to the project included:

* Contributing to the design and implementation of the **32-bit single-cycle MIPS processor** in Verilog HDL.
* Working on the processor datapath and integration of processor components.
* Implementing and testing MIPS instructions and their corresponding control signals.
* Developing and debugging processor simulations using ModelSim.
* Testing the processor on the **Altera DE2 FPGA** using Quartus.
* Working on FPGA input/output integration using switches, LEDs, and seven-segment displays.
* Developing and testing the **Two Sum demonstration program**.
* Debugging hardware and simulation issues during integration.
* Contributing to project documentation, testing, and the final demonstration.

> **Note:** Since this was a team project, this section should be edited if necessary to reflect only the modules and tasks you personally handled.

---

# 📁 Project Structure

```text
MIPS/
│
├── fpga_top.v
├── mips_core.v
├── program_counter.v
├── instruction_memory.v
├── register_file.v
├── alu.v
├── alu_control.v
├── control_unit.v
├── sign_extend.v
├── data_memory.v
├── branch_logic.v
├── jump_logic.v
├── mux.v
├── adder.v
│
├── program.mem
│
├── testbenches/
│   └── ...
│
├── simulation/
│   └── ...
│
├── images/
│   └── de2-mips-demo.jpg
│
├── .gitignore
└── README.md
```

---

# 🎯 Learning Outcomes

This project provided practical experience with:

* Computer architecture
* MIPS instruction-set architecture
* Datapath and control-unit design
* RTL design using Verilog
* Digital logic design
* CPU implementation
* Memory systems
* HDL simulation
* FPGA synthesis
* FPGA programming
* Hardware debugging
* Assembly/machine-code programming
* Hardware/software interaction

---

# 🔮 Future Improvements

Possible extensions include:

* 5-stage pipelined MIPS architecture
* Hazard detection and forwarding
* UART communication
* Timer peripherals
* Interrupt support
* Additional MIPS instructions
* Memory-mapped I/O
* Cache memory
* Performance comparison between single-cycle and pipelined implementations
* RISC-V processor implementation
* Hardware acceleration for selected algorithms

---

# 👥 Project Team

This project was developed as a team project at:

**Obafemi Awolowo University (OAU)**
**Department of Computer Engineering**

---

# 📜 License

This project is intended primarily for educational and academic purposes.