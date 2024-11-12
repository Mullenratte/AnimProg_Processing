abstract class BaseParticle implements IDrawable {
  int size;
  int posX;
  int posY;
  PVector velocity;
  color pColor;
  float velocityGrowthOverTime = 1.00;

  BaseParticle(int size, int posX, int posY, color pColor) {
    this.size = size;
    this.posX = posX;
    this.posY = posY;
    this.velocity = new PVector(0, 0);
    this.pColor = pColor;
  }

  abstract void update();
  abstract void draw();
  abstract void setVelocity(PVector velocity);
}
