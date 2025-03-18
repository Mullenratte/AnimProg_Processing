class ParticleSystemAnimator extends Animator {

  PVector startPos = new PVector(0, 0);

  boolean isAnimating;
  float startTime;


  ParticleSystem particleSys;

  ParticleSystemAnimator(PVector position, PImage currentImg, PImage imgPainted, ParticleSystem ps) {
    super(position, currentImg, imgPainted);
    //this.startPos = position;
    this.particleSys = ps;
  }

// Animator.draw() needs to be overwritten, because image(currentFrameImage, posX, posY) needs to be drawn at (0,0), not at the PS's position
  void draw() {
    if (isAnimating) {
      particleSys.update();
      particleSys.draw();
      currentFrameImage = currentImg;
    }
    
    image(currentFrameImage, 0, 0);
  }

  void animate() {
    particleSys.init((int)position.x, (int)position.y);
    isAnimating = true;
  }

  void playAnimation() {
    if (isRunning) return;
    currentFrame = 0;
    //startPos = position;
    Thread t = new Thread(this);
    t.start();
  }
}
