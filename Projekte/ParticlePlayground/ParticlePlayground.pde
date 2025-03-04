Helper Helper = new Helper();
int poolSize = 50;

ParticleSystem partSys;

float lastTime = 0;
float deltaTime = 0;
float gameTime = 0;


void setup() {
  size(600, 600);
  frameRate(60);
  background(33, 33, 33);

  partSys = new ParticleSystem(poolSize, 4, .3, false);
}

void draw() {
  deltaTime = (millis() - lastTime) / 1000;
  lastTime = millis();
  gameTime += deltaTime;

  background(33, 33, 33);


  partSys.draw();
  partSys.update();
}

void mousePressed() {
  background(33);
  partSys.init(mouseX, mouseY);
}

color getFireColor() {
  return color(random(200, 255), random(50, 200), random(0, 50));
}

color getRandomColor(){
  return color(random(255), random(255), random(255));
}
