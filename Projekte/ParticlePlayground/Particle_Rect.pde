class Particle_Rect extends BaseParticle {

  Particle_Rect(int size, int posX, int posY, color pColor) {
    super(size, posX, posY, pColor);
  }

  void update() {
    posX += velocity.x * deltaTime;
    posY += velocity.y * deltaTime;
    velocity = new PVector(velocity.x * velocityGrowthOverTime, velocity.y * velocityGrowthOverTime);
  }

  void draw() {
    pushStyle();
    rectMode(CENTER);
    fill(pColor);
    rect(posX, posY, size, size);
    popStyle();
  }

  void setVelocity(PVector velocity) {
    this.velocity = velocity;
  }
}
