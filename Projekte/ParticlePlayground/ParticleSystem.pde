class ParticleSystem {
  int posX, posY;

  ParticleType activeParticleType;

  float duration = 1;
  float timer;

  int poolSize;
  ArrayList<BaseParticle> particlePool = new ArrayList<BaseParticle>();
  ArrayList<BaseParticle> particles = new ArrayList<BaseParticle>();

  float minParticleVelocity = -150f;
  float maxParticleVelocity = 150f;

  int particleSize = 15;

  boolean isActive = true;

  // Gizmos
  boolean drawGizmo = false;
  float axisLength = 15;
  color xAxisColor = color(255, 0, 0);
  color yAxisColor = color(0, 255, 0);


  ParticleSystem(int poolSize, float duration) {
    this.poolSize = poolSize;
    this.duration = duration;
  }

  ParticleSystem(int poolSize, float duration, boolean drawGizmo) {
    this.poolSize = poolSize;
    this.duration = duration;
    this.drawGizmo = drawGizmo;
  }

  void init(int posX, int posY) {
    this.posX = posX;
    this.posY = posY;


    timer = 0;

    particlePool.clear();
    particles.clear();

    for (int i = 0; i < poolSize; i++) {
      setRandomActiveParticleType();
      switch (activeParticleType) {
      case Particle_Circle:
        addParticleToPool(new Particle_Circle(particleSize, -500, -500, color(random(255), random(255), random(255))));
        break;
      case Particle_Rect:
        addParticleToPool(new Particle_Rect(particleSize, -500, -500, color(random(255), random(255), random(255))));
        break;
      default:
        addParticleToPool(new Particle_Rect(particleSize, -500, -500, color(random(255), random(255), random(255))));
        break;
      }
    }

    isActive = true;
    /*
    if (drawGizmo){
      pushStyle();
      // x-Handle
      fill(xAxisColor);
      rect(
      popStyle();
    }
    */
  }

  void draw() {
    if (!isActive) return;

    BaseParticle part = tryGetParticleFromPool();
    if (part != null) {
      part.posX = this.posX;
      part.posY = this.posY;
      float rndX = Helper.getRandomBetweenWithoutZero(minParticleVelocity, maxParticleVelocity);
      float rndY = Helper.getRandomBetweenWithoutZero(minParticleVelocity, maxParticleVelocity);
      PVector velocityRand = new PVector(rndX, rndY);
      part.setVelocity(velocityRand);
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
  }

  void update() {
    timer += deltaTime;
    if (timer >= this.duration) {
      isActive = false;
    }
    for (BaseParticle p : particles) {
      p.update();
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
}
