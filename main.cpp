#include <stdio.h>
#include <avr/io.h>

int main() {
  
  DDRA =0xFF;
  while(1){
    PORTA&=0x10;
  }

}
 