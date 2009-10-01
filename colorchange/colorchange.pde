#define PI 3.14159;

int redPin = 9;
int bluePin = 10;
int greenPin = 11;
int periodPin = 4;
int intensityPin = 5;

float greenDampeningFactor = 0.75;
int sleepMillis = 25;
int granularity = 10000;
int minPeriodMillis = 500;
int maxPeriodMillis = 6000;

int minOut = 0;
int maxOut = 255;
int minIn = 0;
int maxIn = 1024;


void setup() {
  pinMode(redPin, OUTPUT);
  pinMode(bluePin, OUTPUT);
  pinMode(greenPin, OUTPUT);

  pinMode(periodPin, INPUT);
  pinMode(intensityPin, INPUT);
}

int value(int intensity, int period, float phase) {
  int periodMillis = map(period, minIn, maxIn, minPeriodMillis, maxPeriodMillis);
  int angle = map(millis() % periodMillis, 0, periodMillis, 0, 2*PI*granularity);
  int sine = sin(1.0*angle/granularity+phase*PI)*granularity;
  int maxValue = map(intensity, minIn, maxIn, minOut, maxOut);
  int out_value = map(sine, -1*granularity, granularity, 0, maxValue);

  return out_value;
}

int times = 0;

void loop() {
  int period = analogRead(periodPin);
  int max_intensity = analogRead(intensityPin);

  int greenValue = value(max_intensity, period, 0) * greenDampeningFactor;
  int blueValue = value(max_intensity, period, 2.0/3);
  int redValue = value(max_intensity, period, 4.0/3);

  analogWrite(greenPin, greenValue);
  analogWrite(bluePin, blueValue);
  analogWrite(redPin, redValue);
  
  delay(sleepMillis);
}
