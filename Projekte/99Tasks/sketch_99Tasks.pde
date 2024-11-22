float lineX, lineY, lineLength;

void setup() {
  size(800, 800);
  frameRate(60);
  
  lineX = 200;
  lineY = height/2;
  lineLength = width/2;

  update();
}

void draw() {
  background(#C4267A);
  
  line(lineX, lineY, lineX + lineLength, lineY);
  noFill();
  float mappedX = map(mouseX, 0, width, lineX, lineX + lineLength);
  circle(mappedX, lineY, 50);
  

  update();
}

void update() {

}
