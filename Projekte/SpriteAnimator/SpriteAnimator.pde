PImage spritesheet;
PImage[] effect = new PImage[16];
PImage[] explo_1 = new PImage[16];

int frame = 0;
float animSpeed = 15f;

void setup() {
  noCursor();
  fullScreen();
  frameRate(120);
  background(33);

  spritesheet = loadImage("smokeFX.png");

  for (int i = 0; i < effect.length; i++) {
    effect[i] = spritesheet.get(64 * i, 0, 64, 64);
  }


  for (int i = 0; i < explo_1.length; i++) {
    explo_1[i] = spritesheet.get(64 * i, 64*3, 64, 64);
  }
}


void draw() {
  background(33);

  image(effect[frame], mouseX/2, mouseY/2);

  if (frameCount % (120 / animSpeed) == 0) {
    frame = (frame + 1) % effect.length;
  }
}
