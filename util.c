#include "lookup.h"
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
	long m = 0;
	long c = 0;
	do {
		m = 0;
		if(*(c+input) == 'b') {
			m = pos + 1;
			pos += 4;
		} else if(*(c+input) == 'a') {
			m = pos + 2;
			pos += 4*8;
		} else if(*(c+input) == 'd') {
			m = pos + 3;
			pos += 4+8*4;
		}
		index += INDEX[m];
	//	printf(" [%2i] %8i (%8i) %8i\n",c, m,pos, index);
		pos += 64*4;
		printf("[%2i] %c %8i (%8i) %i\n",c,*(c+input),m, INDEX[m], index);
	} while(*((++c)+input) != '\0');
	return index;
}
