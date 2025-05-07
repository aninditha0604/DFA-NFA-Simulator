# DFA and NFA Simulator

## Overview

This tool provides simulation capabilities for both **Deterministic Finite Automata (DFA)** and **Non-deterministic Finite Automata (NFA)** implemented in **Scheme**. It allows users to:

- Define DFAs and NFAs
- Test if they accept specific input strings
- Generate visual representations using **Graphviz**

## What are DFAs and NFAs?

**Finite Automata (FA)** are abstract computational models used to recognize patterns in input strings. They consist of:

- A set of states  
- Transitions between states based on input symbols  
- An initial state  
- Accepting states

### Deterministic Finite Automata (DFA)
- One transition per input symbol for each state
- Only one active state at a time

### Non-deterministic Finite Automata (NFA)
- Can transition to multiple states for a given input
- May include ε (epsilon) transitions that do not consume input
- Can be in multiple states simultaneously

---

## Prerequisites

### Install DrRacket
Download from [https://racket-lang.org](https://racket-lang.org)

### Install Graphviz
Download from [https://graphviz.org/download](https://graphviz.org/download)  
Verify installation with:

```bash
dot -v
```

---

## Getting Started

### Step 1: Download Code

Save the Scheme source file as `nfa_simulator.rkt`.

#### Optional Libraries Used
```scheme
(lib "tls.ss" "OWU")
(lib "trace.ss")
```

---

## Code Structure

### Automaton Format
Each automaton is defined as a list:

```scheme
(list-of-all-states
 transitions
 initial-state
 accepting-states
 input-string)
```

---

## DFA Functions

- `is-accepting-state?` – Checks if a state is an accepting state
- `get-next-state` – Finds the next state from the current state and input
- `dfa-helper` – Processes input string through the DFA
- `dfa-simulator` – Wrapper function to run DFA simulation
- `graphviz-to-file` – Generates a DOT file for DFA visualization

---

## NFA Functions

- `is-accepting-states?` – Checks if any state is accepting
- `in-list?` – Helper to check list membership
- `combine` – Merges lists without duplicates
- `get-next-states` – Finds all next states for current state and input
- `process-next-states` – Processes transitions
- `get-epsilon-closure` & `get-epsilon-closure-helper` – Finds reachable states through ε-transitions
- `nfa-helper` – Processes input string through the NFA
- `nfa-simulator` – Wrapper function to run NFA simulation
- `graphviz-to-file` – Generates a DOT file for NFA visualization

---

## How to Use

### Step 1: Define DFA or NFA

Example definitions are included in the file. Modify them as needed by changing:

- States  
- Transitions  
- Initial state  
- Accepting states  
- Input string

### Step 2: Run the Simulator

Call:

```scheme
(dfa-simulator your-dfa)
(nfa-simulator your-nfa)
```

Returns `#t` if the input is accepted, `#f` otherwise.

### Step 3: Generate DOT File

Call:

```scheme
(graphviz-to-file your-automaton "filename.dot")
```

### Step 4: Convert DOT to PNG

Open terminal and run:

```bash
dot -Tpng filename.dot -o filename.png
```

Or specify the full path:

```bash
dot.exe -Tpng "C:\path\to\nfa.dot" -o "C:\path\to\nfa.png"
```

---

## Future Directions

- Add step-by-step animated visualizations using JavaScript
- Expand simulator to include additional TOC (Theory of Computation) concepts


Feel free to reach out!
