class Particle extends BaseParticle {

  Particle(int size, int posX, int posY, color pColor) {
    this.size = size;
    this.posX = posX;
    this.posY = posY;
    this.velocity = new PVector(0, 0);
    this.pColor = pColor;
  }

  void update() {
    posX += velocity.x;
    posY += velocity.y;
    velocity = new PVector(velocity.x * velocityGrowthOverTime, velocity.y * velocityGrowthOverTime);
  }

  void draw() {
    posX += velocity.x;
    posY += velocity.y;
    pushStyle();
    fill(pColor);
    rect(posX, posY, size, size);
    popStyle();

    velocity = new PVector(velocity.x * velocityGrowthOverTime, velocity.y * velocityGrowthOverTime);
  }

  void setVelocity(PVector velocity) {
    this.velocity = velocity;
  }
}
