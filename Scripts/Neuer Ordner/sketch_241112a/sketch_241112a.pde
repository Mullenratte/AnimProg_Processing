int poolSize = 300;
ArrayList<Particle> particlePool = new ArrayList<Particle>();
ArrayList<Particle> particles = new ArrayList<Particle>();

float minParticleVelocity = -10f;
float maxParticleVelocity = 10f;

int particleSize = 5;

void setup() {
  size(600, 600);
  frameRate(200);
  background(33, 33, 33);

  for (int i = 0; i < poolSize; i++) {
    Particle newPart = new Particle((int)random(particleSize, particleSize * 2.5), -50, -50, getFireColor());
    particlePool.add(newPart);
  }
}

void draw() {
  background(33, 33, 33);
  if (mousePressed) {
    Particle part = tryGetParticleFromPool();
    if (part != null) {
      part.posX = mouseX;
      part.posY = mouseY;
      float rndX = random(minParticleVelocity, maxParticleVelocity);
      float rndY = random(minParticleVelocity, maxParticleVelocity);

      if (rndX == 0 && rndY == 0) {
        addParticleToPool(part);
      } else {
        PVector velocityRand = new PVector(rndX, rndY);
        part.setVelocity(velocityRand);
      }
    }
  }

  ArrayList<Particle> addToPool = new ArrayList<Particle>();
  for (var p : particles) {
    p.draw();
    if (p.posX < 0 || p.posX > width || p.posY < 0 || p.posY > height) {
      addToPool.add(p);
    }
  }
  
  for (var pOffScreen : addToPool){
    addParticleToPool(pOffScreen);
  }
}

Particle tryGetParticleFromPool() {
  if (particlePool.size() > 0) {
    Particle part = particlePool.get(0);
    particlePool.remove(part);
    particles.add(part);
    return part;
  }
  return null;
}

void addParticleToPool(Particle particle) {
  particlePool.add(particle);
  particles.remove(particle);
  particle.setVelocity(new PVector(0, 0));
  particle.posX = -500;
  particle.posY = -500;
}

color getFireColor(){
  return color(random(200, 255), random(50, 200), random(0,50));
}
