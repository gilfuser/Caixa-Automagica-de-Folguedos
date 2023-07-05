/* Encoder Library - Basic Example
 * http://www.pjrc.com/teensy/td_libs_Encoder.html
 *
 * This example code is in the public domain.
 */
#include <Encoder.h>
#include <Bounce2.h>

#define NUM_BUTTONS 6

Encoder enc_12h(1, 2);
Encoder enc_10h(4, 5);
Encoder enc_8h(7, 8);
Encoder enc_6h(10, 11);
Encoder enc_4h(19, 20);
Encoder enc_2h(22, 23);
// Encoder encoders[6] = { enc_12h, enc_10h, enc_8h, enc_6h, enc_4h, enc_2h};

const uint8_t BUTTON_PINS[NUM_BUTTONS] = { 0, 3, 6, 9, 18, 21 };
Bounce* buttons = new Bounce[NUM_BUTTONS];
bool toggle = 0;  // variable for reading the pushbutton status

u_char changes[14] = { 254, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255 };
u_char old_changes[14] = { 254, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255 };

void setup() {
  // 1) IF YOUR BUTTON HAS AN INTERNAL PULL-UP:
  // button.attach( BUTTON_PIN ,  INPUT_PULLUP ); // USE INTERNAL PULL-UP
  // 2) IF YOUR BUTTON USES AN EXTERNAL PULL-UP:
  // button.attach( BUTTON_PIN, INPUT ); // USE EXTERNAL PULL-UP
  for (int i = 0; i < NUM_BUTTONS; i++) {
    buttons[i].attach(BUTTON_PINS[i], INPUT);  // setup the bounce instance for the current button
    buttons[i].interval(5);                    // DEBOUNCE INTERVAL IN MILLISECONDS
  }
  // INDICATE THAT THE LOW STATE CORRESPONDS TO PHYSICALLY PRESSING THE BUTTON
  // button.setPressedState(LOW);
  Serial.begin(38400);
}

bool checkArrays(u_char arrayA[], u_char arrayB[], byte numItems) {
  bool same = true;
  byte i = 1;
  while (i <= numItems && same) {
    same = arrayA[i] == arrayB[i];
    i++;
  }
  return same;
}

  u_char enc_12h_old_position = 0;
  u_char enc_12h_position = 0;
  bool btn_12h_state = 0;  // variable for reading the pushbutton status
  u_char enc_10h_old_position = 0;
  u_char enc_10h_position = 0;
  bool btn_10h_state = 0;
  u_char enc_8h_old_position = 0;
  u_char enc_8h_position = 0;
  bool btn_8h_state = 0;
  u_char enc_6h_old_position = 0;
  u_char enc_6h_position = 0;
  bool btn_6h_state = 0;
  u_char enc_4h_old_position = 0;
  u_char enc_4h_position = 0;
  bool btn_4h_state = 0;
  u_char enc_2h_old_position = 0;
  u_char enc_2h_position = 0;
  bool btn_2h_state = 0;

void loop() {


    enc_12h_position = enc_12h.read() % 256;
    if ( changes[1] != enc_12h_position ) {
      changes[1] = enc_12h_position;
    }
    enc_10h_position = enc_10h.read() % 256;
    if (changes[2] != enc_10h_position) {
      changes[2] = enc_10h_position;
    }
    enc_8h_position = enc_8h.read() % 256;
    if (changes[3] != enc_8h_position) {
      changes[3] = enc_8h_position;
    }
    enc_6h_position = enc_6h.read() % 256;
    if ( changes[4] != enc_6h_position) {
      changes[4] = enc_6h_position;
    }
    enc_4h_position = enc_4h.read() % 256;
    if ( changes[5] != enc_4h_position ) {
      changes[5] = enc_4h_position;
    }
    enc_2h_position = enc_2h.read() % 256;
    if ( changes[6] != enc_2h_position) {
      changes[6] = enc_2h_position;
    }

  for (int i = 0; i < NUM_BUTTONS; i++) {
    // Update the Bounce instance :
    buttons[i].update();
    if (buttons[i].fell()) {
      changes[i+7] = !changes[i+7];
    }
  }

if(checkArrays(changes, old_changes, 12) == 0 ) {
  Serial.write(changes, 14);
} else {
  Serial.write(0);
}
for ( int i = 1; i <= 12; i++ ) {
  if ( changes[i] != old_changes[i] ) {
    old_changes[i] = changes[i];
  }
}
delay(4);
}
