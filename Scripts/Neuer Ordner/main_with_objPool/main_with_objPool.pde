int poolSize = 1000;
ArrayList<Particle> particlePool = new ArrayList<Particle>();

int particleSize = 5;

float minParticleVelocity = -10f;
float maxParticleVelocity = 10f;

void setup(){
   size(600, 600);
   background(33, 33, 33);
   for (int i = 0; i < poolSize; i++){
     particlePool.add(new Particle(particleSize, 10000, 10000));
   }
}

void draw(){
  background(33, 33, 33);
   if (mousePressed){
      Particle part = new Particle(particleSize, mouseX, mouseY);
      float rndX = random(minParticleVelocity, maxParticleVelocity);
      float rndY = random(minParticleVelocity, maxParticleVelocity);
      
      PVector velocityRand = new PVector(rndX, rndY);
      part.setVelocity(velocityRand);   
      particles.add(part);
   }
   
   for(var part : particles){
     part.draw();
   }
   
   
}

Particle tryGetParticleFromPool(){
  if (particlePool
}
