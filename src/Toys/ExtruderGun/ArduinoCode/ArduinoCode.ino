

#define TRIGGER_PIN A0
#define THERMISTOR_PIN A1
#define MOTOR_PIN   9
#define LED_PIN     13

#define TRIGGER_MIN_VALUE 400

// resistance at 25 degrees C
#define THERMISTORNOMINAL 100000      

// temp. for nominal resistance (almost always 25 C)
#define TEMPERATURENOMINAL 25   

// how many samples to take and average, more takes longer
// but is more 'smooth'
#define NUMSAMPLES 3

// The beta coefficient of the thermistor (usually 3000-4000)
#define BCOEFFICIENT 4267

// the value of the 'other' resistor
#define SERIESRESISTOR 100000

 
void setup(void) {  
  Serial.begin(9600);

  analogReference(EXTERNAL);

  pinMode(TRIGGER_PIN, INPUT);
  pinMode(MOTOR_PIN, OUTPUT);
  pinMode(LED_PIN, OUTPUT);

  analogWrite(MOTOR_PIN, 0);
  digitalWrite(LED_PIN, LOW);
}

void setMotorPwmByTrigger() {
  float val = averageAnalogReads(TRIGGER_PIN, 10, 20);
  
  if (val > TRIGGER_MIN_VALUE) {
    Serial.print("Motor: ");
    Serial.print(val/10.24);
    Serial.println("%");
    analogWrite(MOTOR_PIN, val/4);
	} else {
    Serial.println("Motor: Off");
    analogWrite(MOTOR_PIN, 0);
  }
}

float averageAnalogReads(int pin, int delayTime, int samples) {

  uint8_t i;
  float average;

  for (i = 0; i < samples; i++) {
    average += analogRead(pin);
    delay(delayTime);
  }

  return average/samples;
}

void setHeaterPwmByThermistor() {

  float average = averageAnalogReads(THERMISTOR_PIN, 10, 20);
 
  Serial.print("Average analog reading "); 
  Serial.println(average);
 
  // convert the value to resistance
  average = 1023 / average - 1;
  average = SERIESRESISTOR / average;

  Serial.print("Thermistor resistance "); 
  Serial.println(average);
 
  float steinhart;
  steinhart = average / THERMISTORNOMINAL;     // (R/Ro)
  steinhart = log(steinhart);                  // ln(R/Ro)
  steinhart /= BCOEFFICIENT;                   // 1/B * ln(R/Ro)
  steinhart += 1.0 / (TEMPERATURENOMINAL + 273.15); // + (1/To)
  steinhart = 1.0 / steinhart;                 // Invert
  steinhart -= 273.15;                         // convert to C
 

  Serial.print("Temperature "); 
  Serial.print(steinhart);
  Serial.println(" *C");
}
 
void loop(void) {
	//setMotorPwmByTrigger();
  digitalWrite(LED_PIN, HIGH);
  setHeaterPwmByThermistor();
  digitalWrite(LED_PIN, LOW);

  delay(1000);
}
