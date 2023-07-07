# jbattle
This is a program to explore turn-based combat like in JRPGs: 

+ What makes them fun?
+ How many aspects do you need to make it interesting?
+ How should rage be timed?
+ How should damage, healing, armor, speed etc. be calibrated?

I wrote the program in 64-bit Assembly on GNU/Linux, using yasm. To compile, make a small script executable:

```
#!/bin/bash
yasm -g dwarf2 -f elf64 $1.asm -l $1.lst	
ld -g -o $1 $1.o
```

Then simply recompile `yourscript jbattle` after changing the numbers in the main `jbattle.asm`. Run from the terminal.
