/*
 * main.c
 *
 *  Created on: Mar 5, 2019
 *      Author: Brock
 */


int main(){
	volatile unsigned int * LEDR 	= (unsigned int *)0x00000050;
	volatile unsigned char * SW 	= (unsigned char *)0x00000060;
	volatile unsigned int * LEDG 	= (unsigned int *)0x00000070;
	volatile unsigned char * KEY	= (unsigned char *)0x00000030;

	int i = 0;
	int sum = 0;
	*LEDR = 0x0;
	int acc_button_flag = 1;

	while(1){
		if(i > 100000){
			i = 0;
			*LEDG ^= 0x01;
		}

		//1 = button released
		//0 = button pressed

		//only on rising edge
		if(!acc_button_flag && (*KEY & 0x01)){
			sum += (int)(*SW & 0x00FF);
			sum &= (int)0x00FF;
			*LEDR = sum;
		}

		i++;
		acc_button_flag = *KEY & 0x01;
	}

	return 0;
}
