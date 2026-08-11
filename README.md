# 8051 8-Digit 7-Segment Display with 8 Keys

An 8051 Assembly Language project that interfaces an **8-digit 7-segment LED display** with **8 push buttons**. The system displays the message **"BE3-uPuC"** in eight different visual patterns, with each pattern selected using a dedicated key.

## Features

- 8-digit 7-segment LED display interfacing
- 8 push-button key interface
- 8051 Assembly Language
- Multiplexed 7-segment display operation
- Lookup-table based character generation
- Multiple scrolling and blinking effects
- Button-based display mode selection
- Compatible with Keil A51 / Keil µVision
d
## Display Modes

Each key selects a different display pattern:

| Key | Display Mode |
|-----|--------------|
| Key 1 | Steady Display |
| Key 2 | Blinking Display |
| Key 3 | Rolling Left |
| Key 4 | Rolling Right |
| Key 5 | Odd Digit Blinking |
| Key 6 | Even Digit Blinking |
| Key 7 | Outside-to-Inside |
| Key 8 | Inside-to-Outside |

## Hardware

- 8051 Microcontroller
- 8-Digit 7-Segment LED Display
- 8 Push Buttons
- Current-limiting resistors
- Power supply
- Connecting wires
- Development/simulation platform

## Port Connections

| 8051 Port | Function |
|-----------|----------|
| P0 | 7-Segment segment data |
| P1.0–P1.7 | 8 Push Buttons |
| P2 | 8-Digit selection |

The display uses multiplexing, where the segment data is supplied through **Port 0** and the individual digits are selected through **Port 2**.

## Software

The program is developed using:

- **Keil µVision**
- **A51 Assembly**
- **8051 Microcontroller**

The character patterns are stored in lookup tables and accessed using the `MOVC` instruction. Delay routines are used to control the display refresh rate, blinking interval, and scrolling speed.

## Message

The programmed 8-character message is:

```text
BE3-uPuC