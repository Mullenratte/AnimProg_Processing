int xPos;
int yPos;



void setup(){
  size(800, 600);
  
  frameRate(60);
  xPos = width/2;
  yPos = height/2;
  
  noCursor();
}

void draw(){
  background(200, 200, 200);  
  
  
  circle(xPos, yPos, 25); 
  
  
  // cursor
  line(mouseX - 30, mouseY, mouseX + 30, mouseY);
  line(mouseX, mouseY - 30, mouseX, mouseY + 30);
  
  
}
