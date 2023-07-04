/* Encoder Library - Basic Example
 * http://www.pjrc.com/teensy/td_libs_Encoder.html
 *
 * This example code is in the public domain.
 */
#include <Encoder.h>
#include <Bounce2.h>

#define NUM_BUTTONS 6

Encoder doze_horas(1, 2);
Encoder dez_horas(4, 5);
Encoder oito_horas(7, 8);
Encoder seis_horas(10, 11);
Encoder quatro_horas(19, 20);
Encoder duas_horas(22, 23);

const uint8_t BUTTON_PINS[NUM_BUTTONS] = { 0, 3, 6, 9, 18, 21 };
Bounce* buttons = new Bounce[NUM_BUTTONS];
bool toggle = 0;  // variable for reading the pushbutton status

void setup() {
  // 1) IF YOUR BUTTON HAS AN INTERNAL PULL-UP:
  // button.attach( BUTTON_PIN ,  INPUT_PULLUP ); // USE INTERNAL PULL-UP
  // 2) IF YOUR BUTTON USES AN EXTERNAL PULL-UP:
  // button.attach( BUTTON_PIN, INPUT ); // USE EXTERNAL PULL-UP
  for (int i = 0; i < NUM_BUTTONS; i++) {
    buttons[i].attach(BUTTON_PINS[i], INPUT);  // setup the bounce instance for the current button
    buttons[i].interval(5);                    // DEBOUNCE INTERVAL IN MILLISECONDS

    // INDICATE THAT THE LOW STATE CORRESPONDS TO PHYSICALLY PRESSING THE BUTTON
    button.setPressedState(LOW);
    Serial.begin(38400);
  }

  for (int i = 0; i < NUM_BUTTONS; i++) {
    // Update the Bounce instance :
    buttons[i].update();
    // If it fell, flag the need to toggle the LED
    if (buttons[i].fell()) {
      buttonState = !buttonState;
    }
  }

  u_char old_12h_position;
  u_char _12h_position;
//  bool old_12h_btn_state = 1;
  bool _12h_btn_state = 0;  // variable for reading the pushbutton status
  u_char old_10h_position;
  u_char _10h_position;
 // bool old_10h_btn_state = 1;
  bool _10h_btn_state = 0;  // variable for reading the pushbutton status
  u_char old_8h_position;
  u_char _8h_position;
  // bool old_8h_btn_state = 1;
  bool _8h_btn_state = 0;  // variable for reading the pushbutton status
  u_char old_6h_position;
  u_char _6h_position;
  // bool old_6h_btn_state = 1;
  bool _6h_btn_state = 0;  // variable for reading the pushbutton status
  u_char old_4h_position;
  u_char _4h_position;
  // bool old_4h_btn_state = 1;
  bool _4h_btn_state = 0;  // variable for reading the pushbutton status
  u_char old_2h_position;
  u_char _2h_position;
  // bool _2h_btn_state = 1;
  bool _2h_btn_state = 0;  // variable for reading the pushbutton status

  void loop() {

    for (int i = 0; i < NUM_BUTTONS; i++) {
      // Update the Bounce instance :
      buttons[i].update();
      if (buttons[i].fell()) {
        switch (buttons[i]) {
          case 0:
            _12h_btn_state = !=_12h_btn_state;
            Serial.write(247);
            Serial.write(_12h_btn_state);
            Serial.write(248);
            break;
          case 1:
            _10h_btn_state = !=_10h_btn_state;
            Serial.write(245);
            Serial.write(_10h_btn_state);
            Serial.write(246);
            break;
          case 2:
            _8h_btn_state = !=_8h_btn_state;
            Serial.write(243);
            Serial.write(_8h_btn_state);
            Serial.write(244);
            break;
          case 3:
            _6h_btn_state = !=_6h_btn_state;
            Serial.write(241);
            Serial.write(_6h_btn_state);
            Serial.write(242);
            break;
          case 4:
            _4h_btn_state = !=_4h_btn_state;
            Serial.write(239);
            Serial.write(_4h_btn_state);
            Serial.write(240);
            break;
          case 5:
            _2h_btn_state = !=_2h_btn_state;
            Serial.write(237);
            Serial.write(_2h_btn_state);
            Serial.write(238);
            break;
        }
      }
    }

    newPosition = doze_horas.read() % 256;
    if (newPosition != oldPosition) {
      oldPosition = newPosition;
      oldBtnState = buttonState;
      Serial.write(248);
      Serial.write(249);
      Serial.write(250);
      Serial.write(252);
      Serial.write(253);
      Serial.write(254);
      Serial.write(newPosition);
      Serial.write(buttonState);
      Serial.write(255);
    }
    delay(8);
  }
