
ArrayList<Circle> drawnCircles = new ArrayList<Circle>();
int circleTraceSize = 80;

PVector tri1, tri2, tri3;

float triVelX = 0.9;
float triVelY = 0.9;
color triColor;

void setup() {
  size(800, 800);
  frameRate(60);

  tri1 = new PVector(width/2, height/2);

  update();
}

void draw() {
  background(#C4267A);
  
  if (drawnCircles.size() < circleTraceSize){
    drawnCircles.add(new Circle(color(150), 25, mouseX, mouseY));
    
  } else{
    Circle newLast = drawnCircles.get(0);
    drawnCircles.remove(0);
    newLast.posX = mouseX;
    newLast.posY = mouseY;
    drawnCircles.add(newLast);
  }
  
  for (var circle : drawnCircles){
    circle.draw();
  }
  

  update();
/*
  pushStyle();
  fill(triColor);
  beginShape();

  vertex(tri1.x, tri1.y);
  vertex(tri2.x, tri2.y);
  vertex(tri3.x, tri3.y);
  endShape();
  popStyle();
  */
}

void update() {

  PVector dist = new PVector(mouseX - tri1.x, mouseY - tri1.y);
  PVector dir = dist.copy();
  dir.normalize();
  // mouse is left of Tri

  tri1 = new PVector(tri1.x + dir.x * triVelX, tri1.y + dir.y * triVelY);
  tri2 = new PVector(tri1.x + 100, tri1.y);
  tri3 = new PVector((tri1.x + tri2.x) / 2, (tri1.y + tri2.y) / 3);

  PVector screen = new PVector(width, height);

  triColor = lerpColor(color(255, 0, 0), color(0, 255, 0), dist.mag() / screen.mag());
}
