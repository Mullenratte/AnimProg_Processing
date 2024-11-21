Circle[] circles = new Circle[100];

PVector tri1, tri2, tri3;

void setup() {
  size(800, 800);
  frameRate(120);
  
  tri1 = new PVector(width/2, height/2);
  
  update();
  
    
}

void draw() {
  background(#C4267A);
  
  update();
  
  beginShape();
  vertex(tri1.x, tri1.y);
  vertex(tri2.x, tri2.y);
  vertex(tri3.x, tri3.y);
  endShape();
}

void update() {
  float triVelX = 3;
  float triVelY = 3;
  PVector dist = new PVector(mouseX - tri1.x, mouseY - tri1.y);
  dist.normalize();
  // mouse is left of Tri
  
  tri1 = new PVector(tri1.x + dist.x * triVelX, tri1.y + dist.y * triVelY);
  tri2 = new PVector(tri1.x + 100, tri1.y);
  tri3 = new PVector((tri1.x + tri2.x) / 2, (tri1.y + tri2.y) / 3);
}
