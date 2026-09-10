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

## Workflow Screenshot
<img width="635" height="386" alt="image" src="https://github.com/user-attachments/assets/d5613d1d-a693-45bf-a27e-6f8c72ed7ad2" />
# SELECTION DEMO: 1-byte array mode
<img width="632" height="397" alt="image" src="https://github.com/user-attachments/assets/386ec56b-05dd-4ac1-8b0d-4c769d8d77a2" />
# SELECTION DEMO: 10-byte array mode
<img width="622" height="91" alt="image" src="https://github.com/user-attachments/assets/2225d045-2052-4b6d-afc0-aac882a4d37d" />

