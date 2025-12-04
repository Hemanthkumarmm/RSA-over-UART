# RSA Over UART Communication
This repository contains the design, implementation, and analysis of UART communication secured using RSA encryption, developed using Verilog HDL and implemented on a Xilinx Spartan-3 FPGA.
The project integrates RSA key generation, encryption, and decryption with a UART transmitter/receiver, enabling real-time secure serial communication.
Simulation, synthesis, and hardware validation are performed based on the procedures described in the research paper “Design and Development of UART Communication Over RSA Encryption” 

---

## Abstract

UART is one of the most widely used communication protocols in embedded and IoT systems due to its simplicity and low overhead. However, UART transmits data in plain text, making it vulnerable to eavesdropping and tampering.
This project implements RSA—an asymmetric key cryptographic algorithm—directly in hardware to secure UART communication. The system consists of:

- RSA key generation
- RSA encryption
- RSA decryption
- UART TX/RX modules
<img width="1600" height="786" alt="Screenshot-14" src="https://github.com/user-attachments/assets/a03c5cd9-1745-4e71-ae3d-e9432891db54" />

## Tool used : Xilinx ISE
## Language used : Verilog

All modules are written in Verilog and synthesized on a Spartan-3 FPGA, demonstrating successful encrypted transmission and recovery of plaintext.
This hardware design ensures confidentiality, integrity, and secure serial data transfer for embedded applications.

---

## Working Principle
The complete RSA-over-UART flow works as follows:
1) Plaintext Input
User enters plaintext (8-bit or higher depending on implementation).
2) RSA Key Generation
     - Select primes p and q
     - Compute modulus:

        n=p×q
     - Compute totient:

        ϕ(n)=(p−1)(q−1)
     - Choose public exponent e 
     - Compute private exponent:

        d=e⁻¹modϕ(n)

3) RSA Encryption
Sender computes ciphertext:

   C = (M^e) mod n 

4) UART Transmission
UART-TX serializes ciphertext by adding:
     - Start bit
     - 8 data bits
     - Stop bit
and transmits it over TX line.

5) UART Reception:
- UART-RX detects start bit, samples data bits, validates stop bit, and reconstructs ciphertext.

6) RSA Decryption
Receiver computes:

   M = C^d mod N

The decrypted value matches the original plaintext, validating secure transmission.

---

## RSA Algorithm
<img width="468" height="775" alt="image" src="https://github.com/user-attachments/assets/7f931fc0-680f-473c-9073-83d033cb94b8" />

Key Generation Steps

   - Choose two primes: p, q
   - Compute modulus:
            n=p×q
   - Compute totient:
            ϕ(n)=(p−1)(q−1)
   - Choose public exponent e such that
          1<e<ϕ(n), gcd(e,ϕ(n))=1
   - Compute private exponent:
          d=e⁻¹modϕ(n)
     
Public key = (e, n)
Private key = (d, n)

- Encryption and decryption are of the following form, for some plaintext M and ciphertext C: <br>
    - C = M<sup>e</sup>(mod n) 
    - M = C<sup>d</sup>(mod n) = (M<sup>e</sup>)<sup>d</sup>(mod n) = M<sup>ed</sup>(mod n)

## UART Communication Overview
UART is a serial, asynchronous protocol used for TX/RX between systems. It frames each data byte with:
- Start bit (0)
- Data bits (LSB first)
- Optional parity
- Stop bit (1)

### UART features:
- Parallel-to-serial conversion
- Baud rate synchronization
- Error detection (parity, framing errors)
- Full-duplex operation
- Flow control (RTS/CTS)

UART is ideal for FPGA-to-FPGA or FPGA-to-microcontroller communication.

---

## Simulation Results
Example 1: 
Plaintext = 43
p = 17, q = 23
Public key = (3, 391)
Private key = (235, 391)
Ciphertext = 134
Decrypted = 43
<img width="1600" height="786" alt="Screenshot-3" src="https://github.com/user-attachments/assets/d31981f9-1d6c-4ee5-8940-168db86de841" />


   - UART RX receives same ciphertext
   - Decrypted = Plaintext 

Example 2 
Plaintext = 78
p = 23, q = 41
Public key = (3, 943)
Private key = (587, 943)
Ciphertext = 223
Decrypted = 78
<img width="1600" height="786" alt="Screenshot-6" src="https://github.com/user-attachments/assets/cfa960c2-9106-4f8c-ac0e-c81897438783" />

   - UART RX receives same ciphertext
   - Decrypted = Plaintext 

---

## RTL Generation and Synthesis Flow

The complete RSA-over-UART system was described in **Verilog HDL** and synthesized using **Xilinx ISE** targeting the **Spartan-3 XC3S400-TQ144** FPGA.

### RTL Generation

The synthesis tool generates the RTL netlist and schematic for the integrated design:

- **RTL Top-Level Output File Name:** `rsa3.ngr`  
- **Top-Level Design Name:** `rsa3`  
- **Output Format:** NGC  
- **Optimization Goal:** Speed  
- **Keep Hierarchy:** No (hierarchy flattened for optimization)

The RTL schematic shows the interconnection of the following major blocks:

- RSA Key Generator  
- RSA Encryption (Modular Exponentiation)  
- RSA Decryption  
- UART Transmitter (TX)  
- UART Receiver (RX)  
- Control logic and data path multiplexing  

These modules are structurally connected to form a fully pipelined **RSA over UART** communication system in hardware.

### Cell / Component Usage (RTL View)

From the RTL-level breakdown, the design includes:
<img width="404" height="650" alt="image" src="https://github.com/user-attachments/assets/c065b5ec-7401-4be4-a4a8-3ddb4c871c7a" />


- **128 × 128-bit Multiplier** – 1  
- **128-bit Subtractors** – 4  
- **32-bit Adders** – 2  
- **128-bit Latches** – 2  
- **32-bit Latch** – 1  
- **32-bit Comparators (≥)** – 1  
- **32-bit Comparators (>)** – 2  
- **32-bit 4-to-1 Multiplexers** – 2  

These arithmetic and control elements implement the **modular exponentiation** and **comparison logic** required for the RSA algorithm, while the UART blocks handle serial framing and data transfer.

---

## Synthesis Summary

After RTL generation, the design is synthesized with the following characteristics:

- **Device:** Xilinx Spartan-3 XC3S400-TQ144  
- **IOs:** 386 (reported at detailed RTL level)  
- **Clock Buffer:** 1× BUFGP (global clock buffer)  
- **Flip-Flops/Latches:** 128 (LD – Latch with Data input)  
- **GND / VCC primitives:** Present as standard FPGA resources  

The RTL and post-synthesis schematics confirm correct module integration and timing feasibility for **real-time secure UART communication** using RSA.

---

## Resource Utilization
Based on Spartan-3 XC3S400-TQ144


### Utilization Summary
| Resource             | Used | Available | Utilization |
| -------------------- | ---- | --------- | ----------- |
| Logic Slices         | 10   | 3584      | 0%          |
| LUTs                 | 17   | 7168      | 0%          |
| Flip-Flops           | 8    | —         | —           |
| Bonded IOBs          | 27   | 97        | 27%         |
| Global Clock Buffers | 1    | 8         | 12%         |

### Timing Analysis
| Parameter              | Value    |
| ---------------------- | -------- |
| Min Input Arrival Time | 6.491 ns |
| Max Output Delay       | 7.078 ns |
| Clock Source           | BUFGP    |


Conclusion:
- Supports UART baud rates 9600–115200 bps
- Very low resource usage
- Efficient and fast modular arithmetic implementation

## FPGA Hardware Implementation

The complete RSA-over-UART system was implemented on a **FPGA board**.  
All modules — RSA key generation, RSA encryption, UART transmission, UART reception, and RSA decryption — were integrated and tested on one device.

### Hardware Flow:
1. Plaintext is given as input to the FPGA.
2. RSA Encryption module encrypts the plaintext.
3. Encrypted data is passed through the UART transmitter.
4. UART receiver captures the serialized ciphertext.
5. RSA Decryption module recovers the original plaintext.
6. Output is displayed and verified on LEDs/monitoring interface.

<img width="448" height="260" alt="image" src="https://github.com/user-attachments/assets/32d7579c-85d5-48b2-a0c1-4cd8981e23e0" />

### Validation:
- Ciphertext is successfully generated.
- UART correctly transfers encrypted data internally.
- Decrypted output matches the original plaintext.
- LED indicators confirm system functionality.

<img width="478" height="321" alt="image" src="https://github.com/user-attachments/assets/63050b42-13ad-4f19-8d2f-69862064e4f5" />

### GPIO Usage:
- UART TX/RX pins  
- 8 pins for plaintext input  
- 8 pins for decrypted output  
- LED pins for visual verification  
- Clock and reset inputs  

This confirms that the **entire RSA-over-UART pipeline works correctly on a FPGA board**, without requiring multiple devices.

---

## Conclusion

This project successfully demonstrates secure UART communication using RSA implemented entirely in hardware.
- RSA key generation, encryption, and decryption implemented in Verilog
- UART TX/RX integrated for real serial communication
- Synthesized and deployed on Spartan-3 FPGA
- Waveforms validate correctness
- Hardware demonstration validates real-world applicability

The system provides an FPGA-based secure communication framework suitable for IoT devices, embedded systems, automation, and authentication protocols.

---

## Publication

This project is based on our research work **published in the IEEE Proceedings of ICECER 2025** under the title:

**“Design and Development of UART Communication Over RSA Encryption”**

Authors:  
Dr. Vasudeva G, Dr. Mallikarjun P Y, Prof. Mahadev S,  
Dr. Tripti R Kulkarni, Dr. Bharathi Gururaj,  
**Hemanth Kumar M.M**, Abhishek H.J  

The implementation, simulation results, and analysis presented in this repository are aligned with the methods and findings described in the IEEE paper.

