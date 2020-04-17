import ddf.minim.*;
import processing.serial.*;

Minim minim;
AudioPlayer musicaFondo;

Serial port;

int leer;
int boton1;


float malX[];
float malY[];

float malX2[];
float malY2[];

int x = 0;
int y = 0;

int xBtn = 530;
int yBtn = 510;
int anBtn = 200;
int alBtn = 60;


int estado [];
int estadoMalo[];
int estado2[];

int puntaje = 0;
float distancia = 0;
int vida = 0;

PImage fondo, enemigos, mira, inicio, enemigo2, perder, explicacion, ganar;
int velocidad = 5;
int velocidad2 = 10;


int begin;
int duration;
int time;

float xpos;
float ypos;

int state = 0;
final int mainMenu = 0;
final int game=1;

void setup()
{
  //boton
  println(Serial.list());
  port = new Serial(this, Serial.list()[0], 9600);
  //boton
  
  size(1281, 721);

  //sonido
  minim = new Minim(this);
  musicaFondo = minim.loadFile("song.mp3");
  musicaFondo.setGain(-15);
  musicaFondo.loop();


  frameRate(24);
  begin = millis();
  time = duration = 50;

  malX = new float[50];
  malY = new float[50];

  malX2 = new float[5];
  malY2= new float[5];

  estado = new int[20];
  estado2 = new int[5];


  fondo = loadImage("fondo.png");
  enemigos = loadImage("Enemigo.png");
  mira = loadImage("mira.png");
  inicio = loadImage("Inicio.jpg");
  enemigo2 = loadImage("Enemigo2.png");
  perder = loadImage("Perder.jpg");
  explicacion = loadImage("Explicacion.jpg");
  ganar = loadImage("Ganar.jpg");


  for (int i=0; i<20; i++)
  {
    malX[i] = random(0, 500);
    malY[i] = random(700);

    estado[i] =1;
  }

  for (int i=0; i<5; i++)
  {
    malX2[i] = random(0, 500);
    malY2[i] = random(700);

    estado2[i] =1;
  }
}

void draw()
{
  switch(key)
  {
  case mainMenu:
    runMenu();
    break;

  case 'p':
    runGame();
    break;

  case 'o':
    explicacion();
    break;
  }
}

void runMenu()
{
  background(inicio);
  textSize(20);
  fill(#ffffff);
  
  if(mousePressed == true)
 {
   if(mouseX >xBtn && mouseX <xBtn + anBtn && mouseY >yBtn && mouseY <yBtn +alBtn)
   {
     setup();
   }
 }
}

void runGame()
{
  background(fondo);
  image(mira, x, y, 100, 110);



  y += velocidad;
  x += velocidad2;


  //boton
  if (0 < port.available())
  {
    boton1 = port.read();
    println(boton1);
  }
  if (boton1 == 1)
  {    
    for (int i=0; i<20; i++)
    {
      distancia = dist(mouseX, mouseY, malX[i], malY[i]);

      if (distancia <30)
      {
        estado[i]=0;
      }
    }
  }
  //boton 


  interactionMouse();

  for (int i=0; i<50; i++)
  {
    malX[i] = malX[i] + random(5, 8);//random para la velocidad 
    if (malX[i] >= 1281 || malX[i] <= 0)
    {
      malX[i] = 0;
      malY[i] = random(680);
    }
  }

  //enemi2

  for (int i=0; i<5; i++)
  {
    malX2[i] = malX2[i] + random(5, 8);//random para la velocidad 
    if (malX2[i] >= 1281 || malX2[i] <= 0)
    {
      malX2[i] = 0;
      malY2[i] = random(680);
    }
  }



  for (int i=0; i<20; i++)
  {
    if (estado[i] == 1)//visibilidad del enemigo dependiendo del estado
    {
      image(enemigos, malX[i], malY[i], 50, 80);
    }
  }

  //enemigo

  for (int i=0; i<5; i++)
  {
    if (estado[i] == 1)//visibilidad del enemigo dependiendo del estado
    {
      image(enemigo2, malX2[i], malY2[i], 50, 80);
    }
  }

  for (int i=0; i<20; i++)
  {
    if (mousePressed == true)
    {
      distancia = dist(mouseX, mouseY, malX[i], malY[i]);

      if (distancia <45)
      {
        estado[i]=0;
      }
    }
  }

  //enemi2

  for (int i=0; i<5; i++)
  {
     if (mousePressed == true)
    {
    
      distancia = dist(mouseX, mouseY, malX2[i], malY2[i]);

      if (distancia <45)
      {
        estado2[i]=0;
      }
    }
  }

  //sumar el puntaje cuando mato al enemigo
  fill(#ffffff);

  text("Puntaje: " + puntaje, 30, 40);
  text("Tiempo Restante : " + time, 1020, 40);
  puntaje=0;
  for (int i =0; i<20; i++)
  {
    if (estado[i] == 0)
    {
      puntaje ++;
    }
    if (puntaje == 20)
    {
      textSize(20);
      background(inicio);
      
      noFill();

      rect(xBtn, yBtn, anBtn, alBtn);
      if (mousePressed == true)
      {
        if (mouseX >xBtn && mouseX <xBtn + anBtn && mouseY >yBtn && mouseY <yBtn + alBtn)
        {
          setup();
        }
      }
    }
  }

  fill(#ffffff);
  for (int i =0; i<20; i++)
  {
    //Perder por tiempo o por puntaje

    if (time > 0)  time = duration - (millis() - begin)/1000;
    if (time <= 0 && puntaje != 15)
    {
      background(perder);
      noFill();

      rect(xBtn, yBtn, anBtn, alBtn);
      if (mousePressed == true)
      {
        if (mouseX >xBtn && mouseX <xBtn + anBtn && mouseY >yBtn && mouseY <yBtn + alBtn)
        {
          setup();
        }
      }
    }
  }

  //Ganar 

  for (int i =0; i<20; i++)
  {

    if (time > 0)  time = duration - (millis() - begin)/1000;
    if (time <= 0 && puntaje >= 5)
    {
      background(ganar);
      
      noFill();

      rect(xBtn, yBtn, anBtn, alBtn);
      if (mousePressed == true)
      {
        if (mouseX >xBtn && mouseX <xBtn + anBtn && mouseY >yBtn && mouseY <yBtn + alBtn)
        {
          setup();
        }
      }
    }
  }

  if (time <= 20 && puntaje != 20) {

    for (int i=0; i<50; i++)
    {
      malX[i] = malX[i] + random(5, 30);//random para la velocidad en posy
      if (malX[i] >= 1281 || malX[i] <= 0)
      {
        malX[i] = 0;
        malY[i] = random(680);
      }
    }
  }


  //perder por tocar un enemigo naranja

  for (int i =0; i<5; i++)
  {
    if (estado2[i] == 0)
    {
      background(perder);
      noFill();

      rect(xBtn, yBtn, anBtn, alBtn);
      if (mousePressed == true)
      {
        if (mouseX >xBtn && mouseX <xBtn + anBtn && mouseY >yBtn && mouseY <yBtn + alBtn)
        {
          
          setup();
        }
      }
    }
  }
}

void explicacion()
{
  background(explicacion);
}

void interactionMouse() {
  x = mouseX;
  y = mouseY;
}
