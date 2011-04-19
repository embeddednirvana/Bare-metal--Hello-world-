/*_____________________________________________________________________________________________
Copyright 2011 Nishchay Mhatre

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
_____________________________________________________________________________________________ */ 
/*#####################################################################################

Bare metal hello world

#####################################################################################*/

#include"AT91SAM7X256.h"		 	// H/W includes
#include<stdint.h>				// Standard widths

// Control parameters
#define ALLISWELL 0
#define CRITICAL 160

// Sensor scaling parameters
#define SYS_ZERO 4
#define SYS_MAX 20

// Valve control command
#define OPEN 10
#define CLOSE 1


						/* Hardware setup macro  */ 
#define prvSetupHardware()			/*Rev 1: Change1*/ \
{\
 AT91C_BASE_AIC->AIC_EOICR = 0;\
 AT91C_BASE_RTTC->RTTC_RTMR = (0x1)|(AT91C_RTTC_RTTRST);\
 AT91C_BASE_PMC->PMC_PCER = (1 << AT91C_ID_PIOA);\
 AT91C_BASE_PMC->PMC_PCER = (1 << AT91C_ID_PIOB);\
}
/*#####################################################################################

Read sensors and open valve : stubs

##################################################################################### */ 

int read_sensor()
{
  uint32_t reading;
  while ((AT91C_BASE_SPI1->SPI_SR & AT91C_SPI_RDRF) == 0);
      	reading= AT91C_BASE_SPI1->SPI_RDR & 0xFFFF;

  return ( (reading-SYS_ZERO)*(CRITICAL / (SYS_MAX-SYS_ZERO )) );	// Scale

}

void valve(uint32_t action)
{
  AT91C_BASE_SPI1->SPI_TDR = (action & 0xFFFF);
  while ((AT91C_BASE_SPI1->SPI_SR & AT91C_SPI_TDRE) == 0);
  return;
}

/*#####################################################################################

Main function. Payload of boot code.

##################################################################################### */ 


int main(void)
{
 float a,b,c;
 int status;
 prvSetupHardware();				// Initial setup of board
 
 while(1)
 	{
	 if ( (status=read_sensor()) >= CRITICAL )
	 		valve(OPEN);	// Emergency - full open
	 
	 else if(status<SYS_ZERO)
	 		valve(CLOSE);		// Fail close
	
	}

  /*a = 3.14159;
  b = 3.0;
	
  while(1)
  	c = a*b;*/
}

