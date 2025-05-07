# DFA-NFA-Simulator

A Scheme-based simulator for Deterministic Finite Automata (DFA) and Non-deterministic Finite Automata (NFA) with visual representation capabilities using Graphviz.
Overview
This tool allows users to:

Define both DFAs and NFAs in Scheme
Test whether these automata accept specific input strings
Generate visual representations using Graphviz

What are DFAs and NFAs?
Finite Automata (FA) are abstract computational models used to recognize patterns through input strings. They consist of:

A set of states
Transitions between states based on input symbols
An initial state
Accepting states

Two Main Types:

Deterministic Finite Automata (DFAs)

There is exactly one transition for each state and input symbol
The machine can only be in one state at a time


Non-deterministic Finite Automata (NFAs)

Can have multiple possible next states for a given state and input
Can make ε (epsilon) transitions without consuming input
Can be in multiple states simultaneously



Prerequisites

DrRacket

Download and install from https://racket-lang.org/


Graphviz

Download and install from https://graphviz.org/download/
Verify installation by running dot -v in your terminal


Code Setup

Clone this repository or download the file nfa_simulator.rkt



Required Libraries

(lib "tls.ss" "OWU")
(lib "trace.ss")

Implementation Details
Both DFAs and NFAs are represented as lists with the following structure:
scheme(list-of-all-states
 transitions
 initial-state
 accepting-states
 input-string)
DFA Implementation Functions

is-accepting-state?: Checks if a state is an accepting state
get-next-state: Finds the next state given a current state and input symbol
dfa-helper: Processes an input string through the DFA
dfa-simulator: Runs the simulation with the helper function
graphviz-to-file: Generates a DOT file representing the DFA

NFA Implementation Functions

is-accepting-states?: Checks if any state in a list is an accepting state
in-list?: Helper function to check if an element is in a list
combine: Merges two lists without duplicates
get-next-states: Finds all possible next states given a current state and input symbol
process-next-states: Processes transitions for a set of states and a given input
get-epsilon-closure and get-epsilon-closure-helper: Gets all states reachable through epsilon transitions
nfa-helper: Processes an input string through the NFA
nfa-simulator: Runs the simulation with the helper function
graphviz-to-file: Generates a DOT file representing the NFA

How to Use the Tool
Step 1: Define Your DFA/NFA
Example DFA:
scheme(define dfa-example
  '((q0 q1 q2)
    (((q0 0) q0)
     ((q0 1) q1)
     ((q1 0) q2)
     ((q1 1) q0)
     ((q2 0) q1)
     ((q2 1) q2))
    q0
    (q1)
    "1001"))
Example NFA:
scheme(define nfa-example
  '((q0 q1 q2)
    (((q0 0) (q0 q1))
     ((q0 1) (q0))
     ((q0 ε) (q2))
     ((q1 1) (q1 q2))
     ((q2 0) (q2)))
    q0
    (q2)
    "10"))
Step 2: Run the Simulator Function
scheme(dfa-simulator dfa-example)
scheme(nfa-simulator nfa-example)
Both functions return #t if the automaton accepts the input string, and #f otherwise.
Step 3: Generate the Visual Representation
scheme(graphviz-to-file dfa-example "dfa.dot")
scheme(graphviz-to-file nfa-example "nfa.dot")
Step 4: Convert DOT to Image
Open the terminal and run:
bash# If dot file is in the same folder as GraphViz
dot -Tpng nfa.dot -o nfa.png

# If dot file is in a different folder
dot.exe -Tpng "C:\path\to\your\nfa.dot" -o "C:\path\to\your\nfa.png"
Future Directions

Create step-by-step animated visualizations showing the processing of input strings using JavaScript
Extend the simulator to include other theoretical computation concepts


Feel free to reach out!
