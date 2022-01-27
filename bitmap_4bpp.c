#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

void main(int argc, char **argv) {
   FILE *ifp;
   FILE *ofp;

   char filename[256];

   uint8_t idata[2];
   uint8_t odata[2];

   if (argc < 3) {
      printf("Usage: %s [8bpp input] [4bpp output]\n", argv[0]);
      return;
   }

   ifp = fopen(argv[1], "r");
   if (ifp == NULL) {
      printf("Error opening %s for reading\n", argv[1]);
      return;
   }
   ofp = fopen(argv[2], "w");
   if (ofp == NULL) {
      printf("Error opening %s for writing\n", argv[2]);
      return;
   }

   odata[0] = 0; /* default address = 0000 */
   odata[1] = 0;
   fwrite(odata,1,2,ofp);

   while (!feof(ifp)) {
      if (fread(idata,1,2,ifp) > 0) {
         odata[0] = (idata[0] & 0xf) << 4;
         odata[0] |= idata[1] & 0xf;
         fwrite(odata,1,1,ofp);
      }
   }

   fclose(ifp);
   fclose(ofp);

   sprintf(filename,"%s.pal",argv[1]);
   ifp = fopen(filename, "r");
   if (ifp == NULL) {
      printf("Error opening %s for reading\n", filename);
      return;
   }

   ofp = fopen("PAL.BIN", "w");
   if (ofp == NULL) {
      printf("Error opening PAL.BIN for writing\n");
      return;
   }

   odata[0] = 0x00;   /* default address = FA00 */
   odata[1] = 0xFA;
   fwrite(odata,1,2,ofp);

   while (!feof(ifp)) {
      if (fread(idata,1,3,ifp) > 0) {
         odata[0] = (idata[1] & 0xf0) |         // green
                    ((idata[2] & 0xf0) >> 4);   // blue
         odata[1] = (idata[0] & 0xf0) >> 4;     // red
         fwrite(odata,1,2,ofp);
      }
   }

   fclose(ifp);
   fclose(ofp);
}
