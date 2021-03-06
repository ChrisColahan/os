#ifndef IO_H
#define IO_H

// get the scancode from the keyboard
unsigned char getScancode();

// write a byte to a port
void outb(unsigned short port, unsigned char val);

//read a byte from a port
unsigned char inb(unsigned short port);

#endif
