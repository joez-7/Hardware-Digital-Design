## First In, First Out (FIFO)
### Synchronous FIFO
A synchronous FIFO works by using a read pointer and a write pointer to track locations in memory. The write pointer represents the next location where data be written, while the read pointer represents the next location where data will be read. The reason it's called synchronous FIFO is that both pointers are updated on the same clock edge, unlike asynchronous FIFO (which we’ll get to later). We use synchronous FIFO because in many cases, the write rate is faster than the read rate, so without a buffer, data could be lost because new data can be written before the old data can be read.

Whenever a write or read happens, their corresponding pointer increments to the next location, but write can only occur if write is enabled and the FIFO is not full. While a read can only occur if read is enabled and the FIFO is not empty. 

This leads to the important concept of how the empty and full conditions are implemented. For a synchronous FIFO, an empty check is simple: if the read pointer and the write pointer are pointing at the same location, then the read pointer has caught up to the write pointer, meaning there is nothing left to read. However, this becomes an issue; for instance, when a write pointer fills the memory, it "wraps" around and may point at the same location as the read pointer, which could incorrectly indicate that the FIFO is empty (a false empty condition).

To solve this issue, I used two methods in my example code.
1. Instead of making the read and write pointers the same width as the address size, we make them one bit wider. For example, if the FIFO depth is 8, the address ranges from 0 to 7, which normally requires 3 bits. However, with an extra bit, the pointers' width becomes 4 bits. If the read pointer is pointing at the first location (0000) and the write pointer fills out the memory and writes through location 0111, then on the next increment, it will "wrap" around. Changing the write pointer to 1000. At that point, only the lower bits may match the read pointer location, but the MSB is different. Thus, to detect full, we check whether the read and write pointers have different MSBs and the same remaining lower bits.

![image](https://github.com/joez-7/Hardware-Digital-Design/blob/77cde0d688a21b1376770cf2d5035479478f019f/images/synchronous%20fifo%20msb.png)

2. 

### References

1. Clifford E. Cummings, *Simulation and Synthesis Techniques for Asynchronous FIFO Design* (SNUG San Jose, Rev. 1.2).  
   [PDF](https://picture.iczhiku.com/resource/eetop/shiwuYyKkIJsqVcm.pdf)

2. Clifford E. Cummings and Peter Alfke, *Simulation and Synthesis Techniques for Asynchronous FIFO Design with Asynchronous Pointer Comparisons* (SNUG San Jose, Rev. 1.2).  
   [PDF](https://picture.iczhiku.com/resource/eetop/shiwuYyKkIJsqVcm.pdf)
