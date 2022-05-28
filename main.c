

#include <stdio.h>
#include "config.h"
#include "util.h"
int main (int argc,  char **argv) {
	//uint k = 1;
	//printf("%u, %i\n", k, getIndex(k));
	//return 0;
	//			0123456789ABCD
	long index = 0;
	if(argc > 1)
		index = getIndex(argv[1]);
	printf("%i\n", index);
	return 0;

}

/*
 * This shit does not work!!!
 * in config.h, try "
 *	0  a1 a3
 * 	b1 a1b2
 * 	b2"
 *
 */
