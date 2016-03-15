#include <stdio.h>
#include "stdlib.h"

void rotbmp24(void *img, void *buf,int width);

int main(int argc, char *argv[])
{
    FILE* f = fopen(argv[1], "r+b");
    unsigned char info[54];
    fread(info, sizeof(unsigned char), 54, f); 
    int width = *(int*)&info[18];
    int padding = ((3*width)%4==0) ? 0 : (4 - (3*width)%4);
    int size = 3 * width * width + width*padding;
    unsigned char* data = (unsigned char*)malloc(size);
    unsigned char* buf = (unsigned char*)malloc(size);

    fseek(f, *(int*)&info[0xa], SEEK_SET);
    fread(data, sizeof(unsigned char), size, f);
    rotbmp24(data, buf, width);
    fseek(f, *(int*)&info[0xa], SEEK_SET);
    fwrite(data, 1, size, f);
    fclose(f);
    free(data);
    free(buf);
    return 0;
}
