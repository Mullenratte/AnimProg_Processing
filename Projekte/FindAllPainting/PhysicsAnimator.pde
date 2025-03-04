class PhysicsAnimator extends Animator {

  PVector startPos = new PVector(0, 0);
  PVector endPos;
  float fallDistance = 250;

  boolean isAnimating;
  float startTime;
  float animDuration = 2.0;

  boolean keepState;


  PhysicsAnimator(PVector position, PImage currentImg, PImage imgPainted, boolean keepState) {
    super(position, currentImg, imgPainted);
    //this.startPos = position;
    this.keepState = keepState;
    println(this.startPos);
    endPos = new PVector(startPos.x, startPos.y + fallDistance);
  }


  void animate() {
    do {
      float progress = 0;
      while (isAnimating) {
        float currentTime = millis() / 1000.0;
        float elapsedTime = currentTime - startTime;
        progress = elapsedTime / animDuration;

        if (progress >= 1) {
          progress = 1;
          isAnimating = false;
        }

        position.y = map(easeOutBounce(progress), 0.0, 1.0, (float)startPos.y, (float)endPos.y);

        currentFrameImage = currentImg;
      }
    } while (this.isLooping);

    if (!keepState) {
      isRunning = false;
    }
  }

  void playAnimation() {
    println("once");
    if (isRunning) return;
    currentFrame = 0;
    //startPos = position;
    startTime = millis() / 1000.0;
    isAnimating = true;
    Thread t = new Thread(this);
    t.start();
  }

  float easeOutBounce(float x) {
    float n1 = 7.5625;
    float d1 = 2.75;

    if (x < 1 / d1) {
      return n1 * x * x;
    } else if (x < 2 / d1) {
      return n1 * (x -= 1.5 / d1) * x + 0.75;
    } else if (x < 2.5 / d1) {
      return n1 * (x -= 2.25 / d1) * x + 0.9375;
    } else {
      return n1 * (x -= 2.625 / d1) * x + 0.984375;
    }
  }
}
