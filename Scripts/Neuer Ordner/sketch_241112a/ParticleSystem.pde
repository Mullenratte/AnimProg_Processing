class ParticleSystem {
  int poolSize = 30;
  ArrayList<Particle> particlePool = new ArrayList<Particle>();
  ArrayList<Particle> particles = new ArrayList<Particle>();

  float minParticleVelocity = -10f;
  float maxParticleVelocity = 10f;

  int particleSize = 15;

  Particle[] system = new Particle[50];

  ParticleSystem() {
    for (int i = 0; i < system.length; i++) {
      system[i] = new Particle(particleSize, mouseX, mouseY, color(random(255), random(255), random(255)));
    }
  }
  
  void update(){
    for (Particle p : system){
      p.update();
    }
  }
  
  void draw(){
    for (Particle p : system){
      p.draw();
    }
  }
}
