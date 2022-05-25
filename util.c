#include "util.h"
#include "config.h"
#include <stdio.h>


uint hamming_weight(uint n) {
	uint r = 0;
	while(n) {
		r += HAMMING[n&0xF];
		n >>= 4;
	}
	return r;
}

uint _getIndex(uint b) {
	uint index = 0;
	uint pos = b & 1;
	while(b) {
		index += (b & 1) * INDEX[pos];
		b = b >> 1;
		pos += 8 + (b & 1);
	}
	return index;
}

long getIndex(char *input) {
	long pos = 0;
	long index = 0;
	do {
		if(*input == 'a') {
			pos += 7;
		} else if(*input == 'b') {
			pos += 1;
		} else if(*input == 'd') {
			pos += 8;
		}
		index += INDEX[pos];
		pos += 49;
		printf("[%i]\n", pos);
	} while(*(++input) != '\0');
	return index;
}
