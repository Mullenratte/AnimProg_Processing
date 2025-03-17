class Particle_Smoke extends BaseParticle {
  PImage spritesheet;
  ArrayList<PImage[]> sprites;
  PImage selectedSprite;

  Particle_Smoke(int size, float posX, float posY, color pColor) {
    super(size, posX, posY, pColor);


    this.spritesheet = loadImage("particles_smoke.png");
    SpritesheetSlicer slicer = new SpritesheetSlicer(spritesheet, 40, 40);
    sprites = slicer.GetSlicedRows();
    this.selectedSprite = sprites.get((int)random(sprites.size()))[0];
    //selectedSprite.resize(selectedSprite.width * size, selectedSprite.height * size);
    selectedSprite.resize(size, size);
  }

  void update() {
    posX += velocity.x * deltaTime;
    posY += velocity.y * deltaTime;
    velocity = new PVector(velocity.x * velocityGrowthOverTime, velocity.y * velocityGrowthOverTime);
  }

  void draw() {
    pushStyle();
    imageMode(CENTER);
    image(selectedSprite, posX, posY);

    fill(255, 0, 0);
    text(""+velocity.x, posX, posY);
    popStyle();
  }

  void setVelocity(PVector velocity) {
    this.velocity = velocity;
  }
}
