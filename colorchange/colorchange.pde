#define PI 3.1415;

int pin9 = 9;
int pin10 = 10;
int pin11 = 11;

int sensor4 = 4;
int sensor5 = 5;

void setup() {
  pinMode(pin9, OUTPUT);
  pinMode(pin10, OUTPUT);
  pinMode(pin11, OUTPUT);

  pinMode(sensor4, INPUT);
  pinMode(sensor5, INPUT);

  Serial.begin(9600);
}

int value(int intensity_knob, int color_knob, float phase) {
  int period_millis = map(color_knob, 0, 1024, 500, 6000);
  long time = millis();
  int granularity = 10000;
  int angle = map(time % period_millis, 0, period_millis, 0, 2*PI*granularity);
  int sine = sin(angle/granularity+phase*PI)*granularity;
  int max_value = map(intensity_knob, 0, 1024, 0, 255);
  int out_value = map(sine, -1*granularity, granularity, 0, max_value);

  if(phase == -1) {
    Serial.print("time: ");
    Serial.print(time);
    Serial.print(" period_millis: ");
    Serial.print(period_millis);
    Serial.print(" angle: ");
    Serial.print(angle);
    Serial.print(" sine: ");
    Serial.print(sine);
    Serial.print(" out_value: ");
    Serial.println(out_value);
  }
  return out_value;

}

int times = 0;

void loop() {
  int angle = analogRead(sensor4);
  int max_intensity = analogRead(sensor5);

  int g_value = value(max_intensity, angle, 0);
  int b_value = value(max_intensity, angle, 2.0/3);
  int r_value = value(max_intensity, angle, 4.0/3);

  analogWrite(pin11, g_value);
  analogWrite(pin10, b_value);
  analogWrite(pin9, r_value);

  //  Serial.print("period: ");
  //  Serial.print(period);
  //  Serial.print(" max_intensity: ");
  //  Serial.print(max_intensity);

  if (times++ % 500 == 0) {  
    Serial.print(" r_value: ");
    Serial.print(r_value);
    Serial.print(" g_value: ");
    Serial.print(g_value);
    Serial.print(" b_value: ");
    Serial.println(b_value);
  }
}
