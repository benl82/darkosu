#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <dos.h>

unsigned char read_1(unsigned char buffer[], int *k) {
    return buffer[(*k)++];
}
unsigned short read_2(unsigned char buffer[], int *k) {
    *k += 2;
    return (buffer[*k - 1] << 8) + buffer[*k - 2];
}
unsigned int read_4(unsigned char buffer[], int *k) {
    *k += 4;
    return (buffer[*k - 1] << 24) + (buffer[*k - 2] << 16) + (buffer[*k - 3] << 8) + buffer[*k - 4];
}
long long int read_8(unsigned char buffer[], int *k) {
    unsigned int p1 = read_4(buffer, k);
    unsigned int p2 = read_4(buffer, k);
    long long int x = (long long int)(p2) * 4294967296 + (long long int)(p1);
    return x;
}
void spit_string(unsigned char buffer[], int *k, int silent) {
    unsigned char toss = read_1(buffer, k);
    if (toss != 0x0b) {
        printf("Error: invalid string starting point. Either make sure the file is not corrupted, or message RED POCKET.");
        exit(1);
    }
    unsigned char t = read_1(buffer, k); int len = t;
    for (int i = 0; i < len; i++) {
        if (silent == 0) { printf("%c", read_1(buffer, k)); } else { read_1(buffer, k); } // type silent = 1 to not print
        if ((i == len - 1) && silent == 1) { // hoping that lifebar is the only one silenced, also why tf does changing silent == 0 make it run but silent == 1 kills it?
            *k += 1;
            char m = read_1(buffer, k); *k -= 1;
            if ((m >= 0x30 && m <= 0x39) || (m == 0x2e) || (m == 0x2c) || (m == 0x7c)) {
                i -= 256;
                *k -= 1;
            }
        }
    }
}
void success(int b) { if (b == 0) { printf("No"); } else { printf("Yes"); } }

int main(void) {
    char path[] = "replay-mania_1443309_419638875.osr";
    char pathf[] = "_hashinshin - Camellia - Shun no Shifudo o Ikashita Kare Fumi Paeria [Giant Pacific Octopus] (2020-05-13) OsuMania.osr";
    char pathg[] = "replay-mania_3362200_497162661.osr";
    
    FILE *fr;
    char *buffer;
    long filelen;
    fr = fopen(pathg, "rb");
    fseek(fr, 0, SEEK_END);
    filelen = ftell(fr);
    rewind(fr);
    buffer = (char *)malloc(filelen * sizeof(char) + 1); // + 1 so i dont get trolled randomly
    fread(buffer, filelen, 1, fr);
    fclose(fr);

    int k = 0; // crawler
    printf("Game mode: ");
    printf("%x", read_1(buffer, &k));
    printf("\nGame version: ");
    printf("%u", read_4(buffer, &k));
    printf("\nBeatmap Hash: ");
    spit_string(buffer, &k, 0);
    printf("\nPlayer Name: ");
    spit_string(buffer, &k, 0);
    printf("\nMap Hash: ");
    spit_string(buffer, &k, 0);
    unsigned short *judgments = (unsigned short *)malloc(sizeof(unsigned short) * 6 + 1); // 320, 300, 200, 100, 50, 0
    judgments[1] = read_2(buffer, &k); judgments[3] = read_2(buffer, &k); judgments[4] = read_2(buffer, &k); judgments[0] = read_2(buffer, &k); judgments[2] = read_2(buffer, &k); judgments[5] = read_2(buffer, &k);
    printf("\n320 Count: ");
    printf("%u", judgments[0]);
    printf("\n300 Count: ");
    printf("%u", judgments[1]);
    printf("\n200 Count: ");
    printf("%u", judgments[2]);
    printf("\n100 Count: ");
    printf("%u", judgments[3]);
    printf("\n50 Count: ");
    printf("%u", judgments[4]);
    printf("\nMiss Count: ");
    printf("%u", judgments[5]);
    printf("\nScore: ");
    printf("%u", read_4(buffer, &k));
    printf("\nMax Combo: ");
    printf("%u", read_2(buffer, &k));
    printf("\nFull Combo: ");
    success(read_1(buffer, &k));
    printf("\nMods: ");
    printf("%u", read_4(buffer, &k));
    spit_string(buffer, &k, 1);
    printf("\nTimestamp in ticks: ");
    printf("%lld", read_8(buffer, &k));
    unsigned int rl = read_4(buffer, &k);
    printf("\nLZMA bounds: ");
    printf("%u", k); k += rl; printf(" "); printf("%u", k); // the ending bound is actually the start of the next one, so do end - 1
    printf("\nReplay ID: ");
    printf("%lld", read_8(buffer, &k));

    free(buffer);
    free(judgments);
}