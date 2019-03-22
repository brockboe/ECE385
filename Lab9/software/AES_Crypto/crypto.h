#ifndef CRYPTO_H
#define CRYPTO_H

#define Nb 4
#define Nr 10
#define Nk 4

#define uchar unsigned char // 8-bit byte
#define uint unsigned int // 32-bit word

void KeyExpansion(uchar * key, uint * w);

void SubBytes(uchar * State);

void SubWord(uint * w);

void RotWord(uint * w);

void AddRoundKey(uchar * state, uint * w, int key);

void ShiftRows(uchar * state);

void ShiftLeft(uchar * arr, int amount);

uchar xtime(uchar a);

void MixColumns(uchar * state);

void printState(uchar * state);

void printw(uint * w);

void InvSubBytes(uchar * state);

void ShiftRight(uchar * arr, int amount);

void InvShiftRows(uchar * state);

void InvMixColumns(uchar * state);

#endif
