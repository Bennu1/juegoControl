int btn1= 7;


int ledPin= 13;
int estado= 0;
int sensor= 0;

void setup()
{
  pinMode(ledPin,OUTPUT);

  pinMode(btn1,INPUT);

  Serial.begin(9600);
  
}
void loop()
{
  estado = digitalRead(btn1);  


  if(estado == HIGH ){
    digitalWrite(ledPin, HIGH);
    sensor = 1;
  }
 

    else{
    digitalWrite(ledPin,LOW);
    sensor=0;      
      } 

    Serial.write(sensor);

    delay(100); 
 
 }
