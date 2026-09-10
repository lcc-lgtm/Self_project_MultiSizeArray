# MultiSizeArray (x86 Assembly Console Program)

An x86 assembly console program for storing and printing multi-size data arrays.

## Features

- Interactive console menu to choose different data sizes:
  - **1-byte array** (`db`)
  - **2-byte array** (`dw`)
  - **4-byte array** (`dd`)
  - **8-byte array** (`dq`)
  - **10-byte array** (`dt`)
- Dynamic array input and storage handling using DOS interrupts (`INT 21h`, `INT 10h`).
- Formatted output display for stored array elements.

## How to Run

1. Make sure you have an x86 assembler and emulator environment installed (such as **MASM** and **DOSBox**).
2. Mount and compile the source file:
   ```cmd
   masm ....asm;
   link ....obj;
   ....exe
