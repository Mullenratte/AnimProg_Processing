void setup() {
  size(800, 800);
  frameRate(60);



  update();
}

void draw() {
  background(#C4267A);

  strokeWeight(1.5);
  line(width/2, 0, width/2, height);
  text("X", width - 25, height/2 + 25);

  line(0, height/2, width, height/2);
  text("Y", width / 2 - 25, 25);

  for (int i = 0; i < 360; i++) {
    float x = map(i, 0, 359, 0, width);
    float y = map(sin(radians(i)), -1, 1, height/2 - 150, height/2 + 150);
    float cosY = map(cos(radians(i)), -1, 1, height/2 - 150, height/2 + 150);
    pushStyle();
    fill(37, 153, 103);
    rectMode(CENTER);
    rect(x, y, 20, 20);
    fill(199, 33, 22);
    rect(x, cosY, 20, 20);
    popStyle();
  }

  update();
}

void update() {
}
