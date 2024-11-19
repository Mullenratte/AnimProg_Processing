SpritesheetSlicer slicer;
PImage spritesheet;
PImage characterSpritesheet;
PImage[] effect = new PImage[16];
PImage[] explo_1 = new PImage[16];
PImage[] charWalk = new PImage[8];

ArrayList<PImage[]> characterAnimations;

float animationFrame = 0;

float animFramesPerSecond = 12;

float lastTime = 0;
float deltaTime = 0;

void setup() {
  noCursor();
  fullScreen();
  frameRate(120);
  background(33);


  characterSpritesheet = loadImage("AnimationSheet_Character.png");
  spritesheet = loadImage("smokeFX.png");

  slicer = new SpritesheetSlicer(characterSpritesheet, 32, 32);
  characterAnimations = slicer.GetSlicedRows();

  for (int i = 0; i < effect.length; i++) {
    effect[i] = spritesheet.get(64 * i, 0, 64, 64);
  }


  for (int i = 0; i < explo_1.length; i++) {
    explo_1[i] = spritesheet.get(64 * i, 64*3, 64, 64);
  }
}

void update() {
  deltaTime = (millis() - lastTime) / 1000;
  lastTime = millis();
}

void draw() {
  update();
  background(33);

  int animationIndex = 8;
  
  image(characterAnimations.get(animationIndex)[(int)animationFrame], mouseX/2, mouseY/2, slicer.widthPerSprite * 4, slicer.heightPerSprite * 4);


  animationFrame += (animFramesPerSecond * deltaTime);
  animationFrame = animationFrame % characterAnimations.get(animationIndex).length;
}
