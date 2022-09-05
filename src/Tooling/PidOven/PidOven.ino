//===============================================================================
//  Header Files
//===============================================================================
#include <LinkedList.h>
#include <SmoothThermistor.h>
#include <AutoPID.h>

typedef struct {
  int pin;
  double currentTemperature;
  SmoothThermistor smoothThermistor;
} thermistor_t;

typedef struct {
  int temperature;
  long duration;
} temp_target_t;

//===============================================================================
//  Constants
//===============================================================================
#define KP 50
#define KI 0
#define KD 80
#define OUTPUT_MIN 0
#define OUTPUT_MAX 255
#define MAX_TEMP 230
#define PID_THERMISTOR_IDX 0



// resistance at 25 degrees C
#define THERMISTORNOMINAL 100000
// temp. for nominal resistance (almost always 25 C)
#define TEMPERATURENOMINAL 25   
// how many samples to take and average, more takes longer
// but is more 'smooth'
#define NUMSAMPLES 10
// The beta coefficient of the thermistor (usually 3000-4000)
#define BCOEFFICIENT 3950
// the value of the 'other' resistor
#define SERIESRESISTOR 93000

//===============================================================================
//  Pin Declarations
//===============================================================================
//Inputs:
int thermistor0Pin = A0;
int thermistor1Pin = A1;

//Outputs:
int ledPin = 13;  // LED output
int pwmPin = 6;  // PWM output

//===============================================================================
//  Variables
//===============================================================================
// Here is where we will save the current temperature
thermistor_t thermistors[2] = {
  {thermistor0Pin, 0,
      SmoothThermistor(thermistor0Pin,   // the analog pin to read from
                       ADC_SIZE_10_BIT,  // the ADC size
                       THERMISTORNOMINAL,           // the nominal resistance
                       SERIESRESISTOR,            // the series resistance
                       BCOEFFICIENT,             // the beta coefficient of the thermistor
                       TEMPERATURENOMINAL,               // the temperature for nominal resistance
                       NUMSAMPLES)},              // the number of samples to take for each measurement
  {thermistor1Pin, 0,
      SmoothThermistor(thermistor1Pin,   // the analog pin to read from
                       ADC_SIZE_10_BIT,  // the ADC size
                       THERMISTORNOMINAL,           // the nominal resistance
                       SERIESRESISTOR,            // the series resistance
                       BCOEFFICIENT,             // the beta coefficient of the thermistor
                       TEMPERATURENOMINAL,               // the temperature for nominal resistance
                       NUMSAMPLES)}              // the number of samples to take for each measurement
};


long lastStatus = 0;
long targetReached = 0;
double targetTemperature = 0.0;
double outputVal = 0;

AutoPID myPID(&(thermistors[PID_THERMISTOR_IDX].currentTemperature), &targetTemperature, &outputVal, OUTPUT_MIN, OUTPUT_MAX, KP, KI, KD);

LinkedList<temp_target_t> temperatureTargets = LinkedList<temp_target_t>();


//===============================================================================
//  Initialization
//===============================================================================
void setup() 
{
  Serial.println("in setup()");
  
  pinMode(thermistor0Pin, INPUT);
  pinMode(thermistor1Pin, INPUT);
  pinMode(ledPin, OUTPUT);
  pinMode(pwmPin, OUTPUT);
  analogReference(EXTERNAL);
  
  for (int i = 0; i < (sizeof(thermistors)/sizeof(thermistor_t)); i++) {
    thermistors[i].smoothThermistor.useAREF(true);
  }
  
  Serial.begin(115200);
}

//===============================================================================
//  Main
//===============================================================================
void loop() 
{
  
  readNewTemp();
  
  updateTemps();

  updateTempTarget();
  
  updatePwm();

  if (isStatusDue()) {
    printTemps();
    lastStatus = millis();
  }
  
  
  delay(1000);
}

//===============================================================================
//  Functions
//===============================================================================
void readNewTemp() {

  // if there's any serial available, read it:
  if (Serial.available() > 0) {

    long duration = Serial.parseInt();

    if (Serial.read() == '@') {
      
      int temperature = Serial.parseInt();
      temperature = constrain(temperature, 0, MAX_TEMP);
  
      if (Serial.read() == '\n') {
        temp_target_t newTarget = {temperature, duration*1000};
        
        Serial.print("New Target Acquired: ");
        Serial.print(newTarget.duration/1000);
        Serial.print(" seconds at ");
        Serial.print(newTarget.temperature);
        Serial.println("C.");
        
        temperatureTargets.add(newTarget);
      }
    }
  }
}


void updateTemps() {
  for (int i = 0; i < (sizeof(thermistors)/sizeof(thermistor_t)); i++) {
    thermistors[i].currentTemperature = thermistors[i].smoothThermistor.temperature();
  }
}

void printTemps() {

  Serial.print("ok");
  for (int i = 0; i < (sizeof(thermistors)/sizeof(thermistor_t)); i++) {
    Serial.print(" T");
    Serial.print(i);
    Serial.print(": ");
    Serial.print(thermistors[i].currentTemperature);
    Serial.print(" /");
    Serial.print(targetTemperature);
  }

  analogWrite(pwmPin, outputVal);
  digitalWrite(ledPin, outputVal > 0);

  Serial.print(" @:");
  Serial.println(outputVal);
}

void updatePwm() {
  myPID.run();
  analogWrite(pwmPin, outputVal);
  digitalWrite(ledPin, outputVal > 0);
}

boolean isStatusDue() {
  return millis() - lastStatus > 10000;
}

void updateTempTarget() {
  if (temperatureTargets.size() > 0) {

    int currentTemperature = thermistors[PID_THERMISTOR_IDX].currentTemperature;
    temp_target_t currentTarget = temperatureTargets.get(0);
    targetTemperature = currentTarget.temperature;
    
    // If we've already reached the current target and the duration has passed
    // then remove the current target from the list
    if (targetReached != 0) {

      // Time since current target temp was reached
      long elapsedMillis = millis()-targetReached;
      long remainingMillis = currentTarget.duration - elapsedMillis;
      
      if (elapsedMillis >= currentTarget.duration) {

        Serial.print("Completed ");
        Serial.print(currentTarget.duration/1000);
        Serial.print(" seconds at ");
        Serial.print(currentTarget.temperature);
        Serial.println("C. ");
        
        temperatureTargets.shift(); // Delete the current target
        targetReached = 0;
      } else {
        if (isStatusDue()) {
          Serial.print("Seconds remaining at ");
          Serial.print(currentTarget.temperature);
          Serial.print("C: ");
          Serial.println(remainingMillis/1000);
        }
      }
    } else {
      
      // Target had not been reached previously.
      // If the current target temperature has been reached
      // Then mark the time
      if (thermistors[PID_THERMISTOR_IDX].currentTemperature >= currentTarget.temperature) {
        targetReached = millis();
        
        Serial.print("Begin ");
        Serial.print(currentTarget.duration/1000);
        Serial.print(" seconds at ");
        Serial.print(currentTarget.temperature);
        Serial.println("C. ");
      } else {
        if (isStatusDue()) {
          Serial.print("Heating: ");
          Serial.print(currentTemperature);
          Serial.print("C / ");
          Serial.print(currentTarget.temperature);
          Serial.println("C.");
        }
      }
    }
  } else {
    targetTemperature = 0;
    
    if (isStatusDue())
    Serial.println("No active temp targets.");
  }
}
