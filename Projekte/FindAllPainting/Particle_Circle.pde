class Particle_Circle extends BaseParticle {

  Particle_Circle(int size, int posX, int posY, color pColor) {
    super(size, posX, posY, pColor);
  }

  void update() {
    posX += velocity.x * deltaTime;
    posY += velocity.y * deltaTime;
    velocity = new PVector(velocity.x * velocityGrowthOverTime, velocity.y * velocityGrowthOverTime);
  }

  void draw() {
    pushStyle();
    ellipseMode(CENTER);
    fill(pColor);
    circle(posX, posY, size);
    popStyle();
  }

  void setVelocity(PVector velocity) {
    this.velocity = velocity;
  }
}
