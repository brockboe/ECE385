#include <stdlib.h>
#include <stdio.h>
#include "crypto.h"
#include "aes.h"

void KeyExpansion(uchar * key, uint * w){
      uint temp;
      uint i = 0;

      while(i < Nk){
            //transpose the key
            w[i] = (key[i] << 24) | (key[1*4 + i] << 16) | (key[2*4 + i] << 8) | (key[3*4 + i]);
            i++;
      }

      i = Nk;

      while(i < Nb * (Nr + 1)){
            temp = w[i - 1];
            if(i % Nk == 0){
                  RotWord(&temp);
                  SubWord(&temp);
                  temp ^= Rcon[i/Nk];
            }
            w[i] = w[i-Nk] ^ temp;
            i++;
      }

      return;
}

void SubBytes(uchar * State){
      int i = 0;
      while(i < 16){
            State[i] = aes_sbox[State[i]];
            i++;
      }
      return;
}

void InvSubBytes(uchar * state){
      int i = 0;
      while(i < 16){
            state[i] = aes_invsbox[state[i]];
            i++;
      }
      return;
}

void SubWord(uint * w){
      uint result = 0x0;
      int i;
      for(i = 0; i < 4; i++){
            uchar temp = ((*w) & (0xFF << i*8)) >> (i*8);
            result |= aes_sbox[temp] << (i*8);
      }
      *w = result;
      return;
}

void RotWord(uint * w){
      uchar a = (*w & 0xFF000000) >> 24;
      uchar b = (*w & 0x00FF0000) >> 16;
      uchar c = (*w & 0x0000FF00) >> 8;
      uchar d = (*w & 0x000000FF) >> 0;

      *w = (b << 24) | (c << 16) | (d << 8) | a;
}

void AddRoundKey(uchar * state, uint * w, int key){
      int i;
      for(i = 0; i < 16; i++){
            int wIndex = (4*key) + (i%4);
            state[i] ^= (w[wIndex] & (0xFF << (3 - (i/4))*8)) >> (3 - (i/4))*8;
      }
}

void ShiftLeft(uchar * arr, int amount){
      int i = 0;
      uchar temp;
      for(i = 0; i < amount; i++){
            temp = arr[0];
            arr[0] = arr[1];
            arr[1] = arr[2];
            arr[2] = arr[3];
            arr[3] = temp;
      }
      return;
}

void ShiftRight(uchar * arr, int amount){
      int i = 0;
      uchar temp;
      for(i = 0; i < amount; i++){
            temp = arr[3];
            arr[3] = arr[2];
            arr[2] = arr[1];
            arr[1] = arr[0];
            arr[0] = temp;
      }
      return;
}

void ShiftRows(uchar * state){
      int i, j;
      uchar temp[4];
      for(i = 0; i < 4; i++){
            for(j = 0; j < 4; j++){
                  temp[j] = state[(i * 4) + j];
            }
            ShiftLeft(temp, i);
            for(j = 0; j < 4; j++){
                  state[(i * 4) + j] = temp[j];
            }
      }

      return;
}

void InvShiftRows(uchar * state){
      int i, j;
      uchar temp[4];
      for(i = 0; i < 4; i++){
            for(j = 0; j < 4; j++){
                  temp[j] = state[(i*4) + j];
            }
            ShiftRight(temp, i);
            for(j = 0; j< 4; j++){
                  state[(i*4) + j] = temp[j];
            }
      }

      return;
}

uchar xtime(uchar a){
      return (a & 0x80) ? (a << 1) ^ 0x1B : (a << 1);
}

void MixColumns(uchar * state){
      int i = 0;
      uchar a[4];
      uchar b[4];
      for(i = 0; i < 4; i++){
            a[0] = state[i + 0];
            a[1] = state[i + 4];
            a[2] = state[i + 8];
            a[3] = state[i + 12];

            b[0] = xtime(a[0]) ^ (xtime(a[1]) ^ a[1]) ^ a[2] ^ a[3];
            b[1] = a[0] ^ xtime(a[1]) ^ (xtime(a[2]) ^ a[2]) ^ a[3];
            b[2] = a[0] ^ a[1] ^ xtime(a[2]) ^ (xtime(a[3]) ^ a[3]);
            b[3] = (xtime(a[0]) ^ a[0]) ^ a[1] ^ a[2] ^ xtime(a[3]);

            state[i + 0] = b[0];
            state[i + 4] = b[1];
            state[i + 8] = b[2];
            state[i + 12] = b[3];
      }
      return;
}

void InvMixColumns(uchar * state){
      int i = 0;
      uchar a[4];
      uchar b[4];

      //5 = 0e
      //4 = 0d
      //3 = 0b
      //2 = 09
      //1 = 03
      //0 = 02

      for(i = 0; i < 4; i++){
            a[0] = state[i + 0];
            a[1] = state[i + 4];
            a[2] = state[i + 8];
            a[3] = state[i + 12];

            b[0] = gf_mul[a[0]][5] ^ gf_mul[a[1]][3] ^ gf_mul[a[2]][4] ^ gf_mul[a[3]][2];
            b[1] = gf_mul[a[0]][2] ^ gf_mul[a[1]][5] ^ gf_mul[a[2]][3] ^ gf_mul[a[3]][4];
            b[2] = gf_mul[a[0]][4] ^ gf_mul[a[1]][2] ^ gf_mul[a[2]][5] ^ gf_mul[a[3]][3];
            b[3] = gf_mul[a[0]][3] ^ gf_mul[a[1]][4] ^ gf_mul[a[2]][2] ^ gf_mul[a[3]][5];

            state[i + 0] = b[0];
            state[i + 4] = b[1];
            state[i + 8] = b[2];
            state[i + 12] = b[3];
      }
      return;
}

void printState(uchar * state){
      int i, j;
      for(i = 0; i < 4; i++){
            for(j = 0; j < 4; j++){
                  printf("%2x ", state[(i*4) + j]);
            }
            printf("\n");
      }
      printf("\n");
      return;
}

void printw(uint * w){
      int i;
      uchar temp[4];
      for(i = 0; i < 44; i++){
            temp[0] = w[i] & 0xFF000000 >> 24;
            temp[1] = w[i] & 0x00FF0000 >> 16;
            temp[2] = w[i] & 0x0000FF00 >> 8;
            temp[3] = w[i] & 0x000000FF >> 0;
            printf("w(%d): %8x \n", i, w[i]);
      }
      printf("\n");
}
