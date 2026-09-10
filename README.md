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
<img width="636" height="411" alt="image" src="https://github.com/user-attachments/assets/ad3153c3-2c40-4ad1-bc76-da269dc12b09" />

# DEMO: 1-byte array mode
<img width="637" height="386" alt="image" src="https://github.com/user-attachments/assets/63e7a4ec-2e2e-44a5-9da4-00d89c5a7a0f" />

# DEMO: 2-byte array mode
<img width="633" height="377" alt="image" src="https://github.com/user-attachments/assets/57a07b57-1cb0-4549-bb0d-100b4a30268b" />

# DEMO: 4-byte array mode
<img width="635" height="380" alt="image" src="https://github.com/user-attachments/assets/91325d76-4bd0-406a-b9ba-52c25654c056" />

# DEMO: 8-byte array mode
<img width="636" height="376" alt="image" src="https://github.com/user-attachments/assets/a3c10d65-e922-4be3-939e-d93933fc6be1" />

# DEMO: 10-byte array mode
<img width="638" height="378" alt="image" src="https://github.com/user-attachments/assets/3c37928b-7238-418f-8a12-dcebe6e581f1" />


