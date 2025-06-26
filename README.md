<p align="center">
  <img src="https://img.shields.io/badge/RTL-Asynchronous%20FIFO-blueviolet?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Verification-UVM%20%26%20SVA-brightgreen?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Language-SystemVerilog-orange?style=for-the-badge" />
</p>

<h1 align="center" style="color:#7c3aed;">🌀 Verification of an Asynchronous FIFO using UVM & SVA 🌀</h1>

<p align="center">
  <b>A comprehensive SystemVerilog project illustrating the design and advanced UVM verification of an Asynchronous FIFO, with SVA!</b><br>
  <a href="https://github.com/AbdelrahmanYassien11/Verification-of-an-Asynchronous-FIFO-using-UVM-SVA/blob/main/documentation_illustrations/UVM_ASYNC_FIFO_REPORT.pdf">
    📄 Full Report (PDF)
  </a>
</p>

---

## 🌈 Overview

This project demonstrates the **design** and **verification** of an <span style="color:#0099ff"><b>Asynchronous FIFO</b></span> (First-In-First-Out) buffer using industry-standard methodologies:
- **RTL Implementation** in SystemVerilog
- **Verification with UVM (Universal Verification Methodology)**
- **Assertion-based verification using SVA (SystemVerilog Assertions)**

---

## 📁 Project Structure

```
.
├── documentation_illustrations/
│   └── UVM_ASYNC_FIFO_REPORT.pdf
├── dut/
│   ├── fifo1.v
│   ├── fifomem.v
│   ├── rptr_empty.v
│   ├── sync_r2w.v
│   ├── sync_w2r.v
│   └── wptr_full.v
└── dv/
    ├── FIFO_sva.sv
    ├── FIFO_uvm_pkg.sv
    ├── dut.f
    ├── run.do
    ├── tb.f
    ├── top_test_uvm.sv
    ├── components/
    ├── interface/
    ├── reports/
    ├── sequence/
    ├── sequence_item/
    ├── sequence_macros/
    ├── tests/
    └── work/
```

---

## 🚀 Quick Start

1. **Clone the repository:**
   ```bash
   git clone https://github.com/AbdelrahmanYassien11/Verification-of-an-Asynchronous-FIFO-using-UVM-SVA.git
   cd Verification-of-an-Asynchronous-FIFO-using-UVM-SVA
   ```

2. **Explore the Design (`dut/`):**
    - `fifo1.v`, `fifomem.v`, `rptr_empty.v`, `sync_r2w.v`, `sync_w2r.v`, `wptr_full.v`: All RTL modules for FIFO.

3. **Verification Environment (`dv/`):**
    - UVM testbench, SVA files, and make/run scripts.
    - Components, interface, sequences, and tests are modularized for clarity and reuse.

4. **Run Simulations:**
    - Use `run.do` or your preferred simulator with the filelists (`dut.f`, `tb.f`).

---

## 🧩 Key Features

- **Modular RTL Design** for Asynchronous FIFO
- **Comprehensive UVM Testbench**
- **Assertion-based Verification (SVA)**
- **Well-documented Report:**  
  👉 [Read the full PDF report](https://github.com/AbdelrahmanYassien11/Verification-of-an-Asynchronous-FIFO-using-UVM-SVA/blob/main/documentation_illustrations/UVM_ASYNC_FIFO_REPORT.pdf)

---

## 📦 Directory Details

- **documentation_illustrations/**
  - Project report with design & verification details.
- **dut/**
  - All RTL source files for the FIFO design.
- **dv/**
  - Full UVM testbench, SVA files, and test utilities.
  - Subfolders for components, interfaces, sequences, macros, and more.

---

## ✨ Screenshots & Diagrams

> 📌 Add diagrams or waveform captures here for extra color!  
> You can embed images from the `/documentation_illustrations` folder if available.

---

## 👨‍💻 Author

- **Abdelrahman Yassien**  
  <a href="https://github.com/AbdelrahmanYassien11"><img src="https://img.shields.io/badge/GitHub-AbdelrahmanYassien11-blue?style=flat-square&logo=github"></a>

---

## 🌟 Star this repo if you find it useful!  
<p align="center">
  <img src="https://img.shields.io/github/stars/AbdelrahmanYassien11/Verification-of-an-Asynchronous-FIFO-using-UVM-SVA?style=social" />
</p>
