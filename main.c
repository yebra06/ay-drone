#include <avr/io.h>
#include <util/delay.h>

// Tell compiler frequency of mcu.
#define F_CPU 16000000UL

// Port B - digital D8-D12
// Port C - analog A0-A5
// Port D - digital D2-D7
// I2C - 4 (SDA), 5(SCL)

int main(void) {
    DDRB = 0b11111111;

    while(1) {
        PORTB = 0xFF;
        _delay_ms(100);
        PORTB = 0x00;
        _delay_ms(100);
    }
}
