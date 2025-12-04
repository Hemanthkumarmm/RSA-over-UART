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

UART Transmission
UART-TX serializes ciphertext by adding:

Start bit

8/9 data bits

Stop bit
and transmits it over TX line.

UART Reception
UART-RX detects start bit, samples data bits, validates stop bit, and reconstructs ciphertext.

RSA Decryption
Receiver computes:

𝑀
=
𝐶
𝑑
m
o
d
 
 
𝑛
M=C
d
modn

The decrypted value matches the original plaintext, validating secure transmission.

RSA Algorithm
Key Generation Steps

(From section II-A, page 1 of the paper) 

Revised paper id_361

Choose two primes: p, q

Compute modulus:

𝑛
=
𝑝
×
𝑞
n=p×q

Compute totient:

𝜙
(
𝑛
)
=
(
𝑝
−
1
)
(
𝑞
−
1
)
ϕ(n)=(p−1)(q−1)

Choose public exponent e such that

1
<
𝑒
<
𝜙
(
𝑛
)
,
  
gcd
⁡
(
𝑒
,
𝜙
(
𝑛
)
)
=
1
1<e<ϕ(n),gcd(e,ϕ(n))=1

Compute private exponent:

𝑑
=
𝑒
−
1
m
o
d
 
 
𝜙
(
𝑛
)
d=e
−1
modϕ(n)

Public key = (e, n)
Private key = (d, n)

RSA Encryption Equation
𝐶
=
𝑀
𝑒
m
o
d
 
 
𝑛
C=M
e
modn

(Equation (1) in paper) 

Revised paper id_361

RSA Decryption Equation
𝑀
=
𝐶
𝑑
m
o
d
 
 
𝑛
M=C
d
modn

(Equation (2) in paper) 

Revised paper id_361

UART Communication Overview

UART is a serial, asynchronous protocol used for TX/RX between systems. It frames each data byte with:

Start bit (0)

Data bits (LSB first)

Optional parity

Stop bit (1)

Reference: Section III of the paper 

Revised paper id_361

UART features:

Parallel-to-serial conversion

Baud rate synchronization

Error detection (parity, framing errors)

Full-duplex operation

Flow control (RTS/CTS)

UART is ideal for FPGA-to-FPGA or FPGA-to-microcontroller communication.

System Architecture

The RSA-over-UART system consists of the following modules (Figure 4 in the paper) 

Revised paper id_361

:

1. RSA Key Generator

Computes n, φ(n), e, d

2. RSA Encryption Module

Implements modular exponentiation:

𝐶
=
𝑀
𝑒
m
o
d
 
 
𝑛
C=M
e
modn
3. RSA Decryption Module

Computes:

𝑀
=
𝐶
𝑑
m
o
d
 
 
𝑛
M=C
d
modn
4. UART Transmitter

Adds start/stop bits

Serializes ciphertext

5. UART Receiver

Detects start bit

Samples bits

Validates stop bit

Sends ciphertext to decryption unit

6. Control Logic

Synchronizes data flow between RSA and UART.

Simulation Results
Example 1 (From Fig. 6) 

Revised paper id_361

Plaintext = 43

p = 17, q = 23

Public key = (3, 391)

Private key = (235, 391)

Ciphertext = 134

Decrypted = 43

✔ RSA works
✔ UART RX receives same ciphertext
✔ Decrypted = Plaintext → Correct

Example 2 (From Fig. 7) 

Revised paper id_361

Plaintext = 78

p = 23, q = 41

Public key = (3, 943)

Private key = (587, 943)

Ciphertext = 223

Decrypted = 78

✔ Secure round-trip transmission successful

Synthesis and Resource Utilization

Based on Spartan-3 XC3S400-TQ144 (Tables on page 4–5) 

Revised paper id_361

:

Utilization Summary
Resource	Used	Available	Utilization
Logic Slices	10	3584	0%
LUTs	17	7168	0%
Flip-Flops	8	—	—
Bonded IOBs	27	97	27%
Global Clock Buffers	1	8	12%
Timing Analysis
Parameter	Value
Min Input Arrival Time	6.491 ns
Max Output Delay	7.078 ns
Clock Source	BUFGP

Conclusion:
✔ Supports UART baud rates 9600–115200 bps
✔ Very low resource usage
✔ Efficient and fast modular arithmetic implementation

FPGA Hardware Implementation

The system was deployed on two FPGA boards (Fig. 9) 

Revised paper id_361

:

Board 1 — Plaintext Input + RSA Encryption + UART Transmission

Board 2 — UART Reception + RSA Decryption + Output Display

LED patterns verify:

Successful ciphertext transmission

Correct decryption

End-to-end integrity

GPIO usage includes:

UART TX/RX pins

8 pins for plaintext

8 pins for decrypted output

Multiple LED status pins

Conclusion

This project successfully demonstrates secure UART communication using RSA implemented entirely in hardware.

✔ RSA key generation, encryption, and decryption implemented in Verilog
✔ UART TX/RX integrated for real serial communication
✔ Synthesized and deployed on Spartan-3 FPGA
✔ Waveforms validate correctness
✔ Hardware demonstration validates real-world applicability

The system provides an FPGA-based secure communication framework suitable for IoT devices, embedded systems, automation, and authentication protocols.
