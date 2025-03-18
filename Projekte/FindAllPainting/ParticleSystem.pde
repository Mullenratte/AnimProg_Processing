class ParticleSystem {
  int posX, posY;

  ParticleType activeParticleType;

  float duration;
  float timer;

  int poolSize;
  ArrayList<BaseParticle> particlePool = new ArrayList<BaseParticle>();
  ArrayList<BaseParticle> particles = new ArrayList<BaseParticle>();

  float minParticleVelocity = -350f;
  float maxParticleVelocity = 350f;

  int particleSize = 15;

  boolean isActive = true;


  // Gizmos
  boolean drawGizmo = false;
  float axisLength = 15;
  color xAxisColor = color(255, 0, 0);
  color yAxisColor = color(0, 255, 0);


  ParticleSystem(int poolSize, int particleSize, float duration) {
    this.poolSize = poolSize;
    this.duration = duration;
    this.particleSize = particleSize;
    setRandomActiveParticleType();
  }

  ParticleSystem(int poolSize, int particleSize, float duration, boolean drawGizmo) {
    this.poolSize = poolSize;
    this.duration = duration;
    this.drawGizmo = drawGizmo;
    this.particleSize = particleSize;
    setRandomActiveParticleType();
  }

  void init(int posX, int posY) {
    this.posX = posX;
    this.posY = posY;


    timer = 0;

    particlePool.clear();
    particles.clear();

    for (int i = 0; i < poolSize; i++) {

      switch (activeParticleType) {
      case Particle_Circle:
        addParticleToPool(new Particle_Circle(particleSize, -500, -500, getFireColor()));
        break;
      case Particle_Rect:
        addParticleToPool(new Particle_Rect(particleSize, -500, -500, getFireColor()));
        break;
      case Particle_Smoke:
        Particle_Smoke p = new Particle_Smoke(particleSize, -500, -500, getFireColor());
        p.setVelocity(new PVector(random(-0.3f, 0.3f), random(1f, 5f)));
        addParticleToPool(p);
        break;
      default:
        addParticleToPool(new Particle_Rect(particleSize, -500, -500, getFireColor()));
        break;
      }
    }

    isActive = true;
  }



  void draw() {
    if (!isActive) return;
    BaseParticle part = tryGetParticleFromPool();
    if (part != null) {
      part.posX = this.posX;
      part.posY = this.posY;

      updateParticleVelocity(part);
    }

    ArrayList<BaseParticle> addToPool = new ArrayList<BaseParticle>();

    for (BaseParticle p : particles) {
      p.draw();
      if (p.posX <= 0 || p.posX >= width || p.posY <= 0 || p.posY >= height) {
        addToPool.add(p);
      }
    }

    for (BaseParticle pOffScreen : addToPool) {
      addParticleToPool(pOffScreen);
    }

    if (drawGizmo) {
      DrawGizmo();
    }
  }

  void update() {
    timer += deltaTime;
    if (this.duration >= 0 && timer >= this.duration) {
      isActive = false;
    }
    for (BaseParticle p : particles) {
      p.update();
    }
  }

  private void updateParticleVelocity(BaseParticle part) {
    switch (activeParticleType) {
    case Particle_Circle:
      float rndX = Helper.getRandomBetweenWithoutZero(minParticleVelocity, maxParticleVelocity);
      float rndY = Helper.getRandomBetweenWithoutZero(minParticleVelocity, maxParticleVelocity);
      PVector velocityRand = new PVector(rndX, rndY);
      part.setVelocity(velocityRand);
      break;
    case Particle_Rect:
      rndX = Helper.getRandomBetweenWithoutZero(minParticleVelocity, maxParticleVelocity);
      rndY = Helper.getRandomBetweenWithoutZero(minParticleVelocity, maxParticleVelocity);
      velocityRand = new PVector(rndX, rndY);
      part.setVelocity(velocityRand);
      break;
    case Particle_Smoke:
      PVector vel = new PVector(random(-10f, 10f), random(-55f, -5f));
      part.setVelocity(vel);
      break;
    default:
      rndX = Helper.getRandomBetweenWithoutZero(minParticleVelocity, maxParticleVelocity);
      rndY = Helper.getRandomBetweenWithoutZero(minParticleVelocity, maxParticleVelocity);
      velocityRand = new PVector(rndX, rndY);
      part.setVelocity(velocityRand);
      break;
    }
  }


  // retrieve Particle from object pool and add to active particles
  BaseParticle tryGetParticleFromPool() {
    if (particlePool.size() > 0) {
      BaseParticle part = particlePool.get(0);
      particlePool.remove(part);
      particles.add(part);
      return part;
    }
    return null;
  }

  // add Particle to object pool and remove from active particles
  void addParticleToPool(BaseParticle particle) {
    particlePool.add(particle);
    particles.remove(particle);
    particle.setVelocity(new PVector(0, 0));
    particle.posX = -500;
    particle.posY = -500;
  }

  void setActiveParticleType(ParticleType particleType) {
    this.activeParticleType = particleType;
  }

  void setRandomActiveParticleType() {
    int rnd = (int)random(0, ParticleType.values().length);
    this.activeParticleType = ParticleType.values()[rnd];
  }

  void DrawGizmo() {
    pushStyle();
    // x-Handle
    fill(xAxisColor);
    rect(posX, posY, 25, 3);
    pushStyle();
    strokeWeight(2);
    stroke(xAxisColor);
    line(posX + 25, posY + 1 + 1.5, posX + 15, posY - 8 + 1.5);
    line(posX + 25, posY + 1 + 1.5, posX + 15, posY + 8 + 1.5);

    popStyle();

    // y-Handle
    fill(yAxisColor);
    rect(posX, posY, 3, -25);
    pushStyle();
    strokeWeight(2);
    stroke(yAxisColor);
    line(posX + 1.5, posY - 25, posX + -8 + 1.5, posY - 15);
    line(posX + 1.5, posY - 25, posX + 8 + 1.5, posY - 15);


    popStyle();

    popStyle();
  }
}
