class SpriteAnimator extends Animator {

  PImage[] spriteAnimation;

  SpriteAnimator(PVector position, PImage currentImg, PImage imgPainted, PImage[] spriteAnimation) {
    super(position, currentImg, imgPainted);
    this.spriteAnimation = spriteAnimation;
  }

  void animate() {
    do {
      for (int frame = 0; frame < spriteAnimation.length; frame++) {
        currentFrameImage = spriteAnimation[frame];
        try {
          println("Frame: " + frame);
          Thread.sleep(1000/fps);
        }
        catch(InterruptedException e) {
          println("Thread interrupted");
        }
      }
    } while (this.isLooping);

    isRunning = false;
  }

  void playAnimation() {
    if (isRunning || this.spriteAnimation == null) return;
    currentFrame = 0;
    Thread t = new Thread(this);
    t.start();
  }

  void addSpriteAnimation(PImage[] anim) {
    this.spriteAnimation = anim;
  }
}
