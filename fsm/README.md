## Finite State Machine
Here are some example tasks implemented using a finite state machine.
### Sequence Detector 1
For this task, we need to detect the sequence 1001 from a finite bitstream, with 1 input bit arriving each clock cycle. A simple way to implement this is with an FSM, where each state represents how much of the sequence we’ve matched so far, starting from the first bit (1). Each time a new bit comes in, if it matches the expected next bit in the pattern, we move to the next state. If it doesn’t match, we fall back to the state that represents the longest partial match that still fits the sequence.

![image](https://github.com/joez-7/Hardware-Digital-Design/blob/5cede2532a1b203ea9c52da9b0c00fdd41a1a8dd/images/sequence%20detector%201%20fsm%20diagram2.png)

### Sequence Detector 2
Similarly, for this task, we need to detect two sequences, 101101 and 101001, from a finite bitstream, where the input arrives at 1 bit per clock cycle. Since we are detecting two sequences and the first three bits are the same (101), we can share the initial detection path and then split into two branches for the remaining three bits, as shown in the image below.

![image](https://github.com/joez-7/Hardware-Digital-Design/blob/c6848c8723fd958bbc40c493e7004ab201f25447/images/sequence%20detector%202%20fsm%20diagram.png)

