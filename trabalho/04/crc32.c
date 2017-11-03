#include <stdio.h>
#include <stdlib.h>

unsigned int crc32b(unsigned char *message) {
   int i, j;
   unsigned int byte, crc, mask;

   i = 0;
   crc = 0xFFFFFFFF;
   while (message[i] != 0) {
      byte = message[i];            // Get next byte.
      crc = crc ^ byte;
      for (j = 7; j >= 0; j--) {    // Do eight times.
         mask = -(crc & 1);
         crc = (crc >> 1) ^ (0xEDB88320 & mask);
      }
      i = i + 1;
   }
   return ~crc;
}

int main() {
	char orig[] = "Alo mundo.";
	unsigned char *message;
	unsigned int crc;
	int i;
	message = malloc(sizeof(unsigned char) * 16);
	printf("%s\n", orig);
	for(i = 0;i < 16; ++i) {
		message[i] = (unsigned char)orig[i];
	}
	crc = crc32b(message);
	printf("%x\n", crc);
   printf("%c - %x - %x\n", orig[0], (int)orig[0], (unsigned char)orig[0]);
	return 0;
}
