#define NUM_PLAYERS 2

class Ringers {
  private:
    static int8_t* list;
  public:
    Ringers();
    void debug();
    void signal(int player);
    void reset();
};

int8_t* Ringers::list = 0;

Ringers::Ringers() {
  list = (int8_t*)calloc(NUM_PLAYERS, sizeof(int8_t));
  for (int i = 0; i < NUM_PLAYERS; i++) {
    list[i] = -1;
  }
}

void Ringers::debug() {
  for (int i = 0; i < NUM_PLAYERS; i++) {
    Serial.print(list[i]);
    if (i + 1 != NUM_PLAYERS) { Serial.print(", "); }
  }
  Serial.println("");
}

void Ringers::signal(int player) {
  for (int i = 0; i < NUM_PLAYERS; i++) {
    if (list[i] == -1) {
      // add ourselves
      list[i] = player;
      return;
    } else if (list[i] == player) {
      return;
      // give up now.  we're already here.
    } else {
      // keep going
    }
  }
  Serial.println("FAILURE: should not get here");
}

void Ringers::reset() {
  for (int i = 0; i < NUM_PLAYERS; i++) {
    list[i] = -1;
  }
}

Ringers ringers = Ringers();
  
void setup() {
   Serial.begin(9600);
   attachInterrupt(0, interrupt0, RISING);
   attachInterrupt(1, interrupt1, RISING);
   Serial.println("initializing");
   ringers.debug();
}

void loop() {
}

void interrupt0() {
  ringers.signal(0);
  makelog(0);
}

void interrupt1() {
  ringers.signal(1);
  makelog(1);
}

void makelog(int pin) {
  Serial.print(pin);
  Serial.println(" pressed");
  ringers.debug();
}
