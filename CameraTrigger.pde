


int Focus = 4;      
int Shoot = 5;
int Trigger = 12;
int led = 13;

long last_focus = 0; 
long refresh_time = 160000;           // 2 minutes 30 seconds

void setup()
{
  Serial.begin (9600);
  pinMode(Focus, OUTPUT);
  pinMode(Shoot, OUTPUT);
  pinMode(Trigger, INPUT);
  pinMode(led, OUTPUT);                
  keep_alive();                        // Get a time stamp
}

void loop() {
  keep_alive();                        // Keep the camera alive 
  if (digitalRead(Trigger) == HIGH){   // If we have trigger then:
    digitalWrite (led, LOW);           // debug led off
    digitalWrite (Focus, HIGH);        // Focus the camera and hold
    delay (1200);                      // Wait holding for the camera to focus
    digitalWrite (Shoot, HIGH);        // Take a picture
    delay (100);                       // Wait for the camera to receive the signal
    digitalWrite (Shoot, LOW);         // Release shooter
    digitalWrite (Focus, LOW);         // Releas focus
    last_focus = millis();             // Refresh the last focus variable
    wait();                            // Wait until we take another picture
  }else{
    digitalWrite (led, HIGH);          // Deboug led on
  }
}

void wait() {                          // Wait funciton waits 100*2*40 = 8000ms for another picture to be taken
  int i;
  int del = 100;                       // Delay of each led state
  for (i=0; i<40; i++) {               // Repeat 40 times
    digitalWrite (led, HIGH);          // Blink the led 
    delay (del); 
    digitalWrite (led, LOW);
    delay (del);
  }  
}

void keep_alive(){                      // Keep alives keeps the camera alive focusing every 2 minutes so the camera won't shut down automatically
  if ((millis() > refresh_time) && ((millis() - refresh_time) > last_focus)) {  // If the time - the laps is grater than the las time we focused then we focus again
    digitalWrite (Focus, HIGH);         // Press focus during
    delay (300);                        // 100 milliseconds
    digitalWrite (Focus, LOW);          // Then relase focus
    last_focus = millis();              // Recor the time stamp of the last focus
    Serial.println("refresh"); 
    Serial.println(last_focus);
    Serial.println(refresh_time);
    Serial.println(millis()); 
  }
}
