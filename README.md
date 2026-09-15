# 5-Stage RISC-V Processor

A SystemVerilog implementation of a **5-stage, single-issue RISC-V processor** implementing a subset of the RV32I instruction set. The processor uses a pipelined datapath with forwarding, stall, and flush logic to maintain correct instruction flow in the presence of data and control hazards.

---

## Architecture

<img width="1648" height="697" alt="5-Stage RISC-V Processor Architecture" src="https://github.com/user-attachments/assets/3618fea6-b0e8-4732-abf9-97d945716c3e" />

The processor is organized into five pipeline stages:

|  Stage  | Description                        |
| :-----: | ---------------------------------- |
|  **IF** | Instruction Fetch                  |
|  **ID** | Instruction Decode / Register Read |
|  **EX** | ALU Execution                      |
| **MEM** | Data Memory Access                 |
|  **WB** | Register Writeback                 |

---

### Pipeline Registers

Pipeline registers separate each stage and maintain the instruction's data and control state as it moves through the processor.

```text
        IF/ID       ID/EX       EX/MEM       MEM/WB

     ┌────────┐  ┌────────┐  ┌──────────┐  ┌──────────┐
IF ─▶│ IF / ID │─▶│ ID / EX │─▶│ EX / MEM │─▶│ MEM / WB │─▶ WB
     └────────┘  └────────┘  └──────────┘  └──────────┘
```

## Implementation

### Datapath

* Single-ALU execution datapath
* 32-register RISC-V register file
* Immediate generation and operand selection
* Instruction fetch and program counter logic
* Data memory interface
* Writeback datapath

### Control Logic

* Instruction decoding for supported RV32I instructions
* Generation of datapath control signals
* ALU operation selection
* Register write and memory control signals
* Branch / jump control

---

## Supported RV32I Instructions

The processor currently supports the following subset of RV32I:

| Category                 | Instructions |
| :----------------------- | :----------- |
| **Register Arithmetic**  | `ADD`, `SUB` |
| **Immediate Arithmetic** | `ADDI`       |
| **Loads**                | `LW`         |
| **Comparison**           | `SLT`        |
| **Jumps**                | `JAL`        |

---

## Pipeline Hazards

### Data Hazards

The forwarding logic detects dependencies between instructions and selects the most recently available operand rather than unnecessarily waiting for register-file writeback.

For example:

```text
ADD  x5, x1, x2
SUB  x6, x5, x3
         ↑
    Data dependency
```

The result produced by the `ADD` can be forwarded to the dependent `SUB` instruction when the value is available.

### Stalls

When forwarding cannot resolve a dependency because the required value is not yet available, the pipeline is stalled until the operand can be safely used.

### Control Hazards

Instructions following a control-flow change can be invalidated through pipeline flushing to prevent incorrect instructions from completing.

---

## Verification

The processor was verified using **SystemVerilog testbenches** and **ModelSim** simulation.

### Module-Level Verification

Individual modules were tested independently to verify:

* ALU operations
* Register file behavior
* Immediate generation
* Control signal generation
* Pipeline register behavior
* Hazard detection and forwarding logic

### Simulation

*Add representative ModelSim waveform screenshots here.*

<!-- Example:
<img src="docs/images/pipeline_waveform.png" alt="ModelSim Pipeline Simulation" width="100%">
-->

---

## Design Highlights

| Feature             | Implementation             |
| :------------------ | :------------------------- |
| **Architecture**    | 5-stage pipelined RISC-V   |
| **Issue Width**     | Single-issue               |
| **ISA**             | RV32I subset               |
| **Execution Unit**  | Single ALU                 |
| **Pipeline Stages** | IF / ID / EX / MEM / WB    |
| **Hazard Handling** | Forwarding / Stall / Flush |
| **HDL**             | SystemVerilog              |
| **Simulation**      | ModelSim                   |

---

## Tools & Technologies

![SystemVerilog](https://img.shields.io/badge/SystemVerilog-RTL-blue)
![RISC-V](https://img.shields.io/badge/ISA-RISC--V-orange)
![ModelSim](https://img.shields.io/badge/Simulation-ModelSim-green)

* **SystemVerilog** — RTL implementation
* **RISC-V RV32I** — Instruction set architecture
* **ModelSim** — RTL simulation and waveform analysis

---

## Future Improvements

* Expand RV32I instruction coverage
* Improve automated verification and regression testing
* Add additional execution functionality
* Extend hazard and branch handling
* Evaluate synthesis and FPGA implementation

---
