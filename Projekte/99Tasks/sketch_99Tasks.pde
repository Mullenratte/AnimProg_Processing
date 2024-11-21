Circle[] circles = new Circle[100];

void setup() {
  size(800, 800);
  frameRate(120);

  for (int i = 0; i < circles.length; i++) {
    float circleX = random(0, width);
    float circleY = random (0, height);
    color circleColor = color(random(255), random(255), random(255));
    
    circles[i] = new Circle(circleColor, random(25, 70), circleX, circleY);
  }
}

void draw() {
  background(#C4267A);

  stroke(255);
  line(width / 2 - 100, height / 2, mouseX, mouseY);
  
  for (int i = 0; i < circles.length; i++) {
    circles[i].draw();
  }
}
