PImage spritesheet;
PImage[] effect = new PImage[16];
PImage[] explo_1 = new PImage[16];

int frame = 0;
float animSpeed = 15f;

int explodeFrame = 0;
boolean explode =false;
PVector explodePos;

void setup(){
  noCursor();
  fullScreen();
  frameRate(120);
  
  spritesheet = loadImage("smokeFX.png");
  background(33);
  
   for (int i = 0; i < effect.length; i++){
     effect[i] = spritesheet.get(64 * i, 0, 64, 64);
   }
   
     
   for (int i = 0; i < explo_1.length; i++){
     explo_1[i] = spritesheet.get(64 * i, 64*3, 64, 64);
   }
   
}


void draw(){
  background(33);
  
   image(effect[frame], mouseX/2, mouseY/2);
   
   if (frameCount % (120 / animSpeed) == 0){
     frame = (frame + 1) % effect.length;
     explodeFrame = (frame + 1) % effect.length;
   }
  
  if(explode){
       image(explo_1[explodeFrame], explodePos.x, explodePos.y);
      
  }
  
  if (explodeFrame == explo_1.length - 1){
    explode = false;
    explodeFrame = 0;
  }
  
  
}

void mousePressed(){
  explode = true;
  explodePos = new PVector(mouseX / 2 , mouseY / 2);
}
