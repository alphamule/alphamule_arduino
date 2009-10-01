#define PI 3.14159;

#define redPin 9
#define bluePin 10
#define greenPin 11

#define intensityPin 4
#define periodPin 5

#define granularity 10000

int sensor4 = 4;
int sensor5 = 5;

void setup() {
  pinMode(redPin, OUTPUT);
  pinMode(bluePin, OUTPUT);
  pinMode(greenPin, OUTPUT);

  pinMode(intensityPin, INPUT);
  pinMode(periodPin, INPUT);
}

int value(int intensity_knob, int color_knob, float phase) {
  int period_millis = map(color_knob, 0, 1024, 500, 6000);
  return map(
    sin(1.0*map(millis() % period_millis, 0, period_millis, 0, 2*PI*granularity)/granularity+phase*PI)*granularity,
    -1*granularity,
    granularity,
    1,
    map(intensity_knob, 0, 1024, 0, 255));
}

void loop() {
  analogWrite(greenPin, value(analogRead(intensityPin), analogRead(periodPin), 0));
  analogWrite(bluePin, value(analogRead(intensityPin), analogRead(periodPin), 2.0/3));
  analogWrite(redPin, value(analogRead(intensityPin), analogRead(periodPin), 4.0/3));
}
