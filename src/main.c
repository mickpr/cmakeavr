#include <stdio.h>
int main() {
  
  DDRB =0xFF;
  while(1){
    PORTB&=0x10;
  }
}
 