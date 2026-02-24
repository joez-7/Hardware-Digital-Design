## Finite State Machine
Here are some example tasks implemented using a finite state machine.
### Sequence Detector 1
For this task, we are supposed to detect the sequence 1001 from a finite bitstream with an input of 1 bit per clock. 

![image](https://github.com/joez-7/Hardware-Digital-Design/blob/a663f87e2e3e7128642ca9906e6c9a866d412428/images/sequence%20detector%201%20fsm%20diagram.png)

### Sequence Detector 2
Similarly, for this task, we need to detect two sequences, 101101 and 101001, from a finite bitstream, where the input arrives at 1 bit per clock cycle. Since we are detecting two sequences and the first three bits are the same (101), we can share the initial detection path and then split into two branches for the remaining three bits, as shown in the image below.

![image](https://github.com/joez-7/Hardware-Digital-Design/blob/bbde50bfc4d2238ccd1ed4ab9c01761d757a6e33/images/sequence%20detector%202%20fsm%20diagram.png)

