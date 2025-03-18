class PhysicsAnimator extends Animator {

  // bounce
  PVector startPos = new PVector(0, 0);
  PVector endPos;
  float fallDistance = 350;

  boolean isAnimating;
  float startTime;
  float animDuration = 2.0;

  boolean keepState;

  PhysicsAnimationType currentAnimationType;


  PhysicsAnimator(PVector position, PImage currentImg, PImage imgPainted, boolean keepState, PhysicsAnimationType type, boolean isLooping) {
    super(position, currentImg, imgPainted);
    //this.startPos = position;
    currentAnimationType = type;
    this.isLooping = isLooping;
    this.keepState = keepState;
  }


  void animate() {
    do {
      float progress = 0;
      startTime = millis() / 1000.0;
      isAnimating = true;
      isSwaying = false;
      while (isAnimating) {
        float currentTime = millis() / 1000.0;
        float elapsedTime = currentTime - startTime;
        progress = elapsedTime / animDuration;
        if (progress >= 1) {
          progress = 1;
          isAnimating = false;
        }
        switch(currentAnimationType) {
        case BOUNCE:
          endPos = new PVector(startPos.x, startPos.y + fallDistance);
          bounce(progress);
          break;
        case SWAY:
          if (!isSwaying) {
            isSwaying = true;
            swayDirX = random(-.5f, .5f);
            swayDirY = random(-0.1f, 0.1f);
          }
          PVector dir = progress <= 0.5f ? new PVector(swayDirX, swayDirY) : new PVector(-swayDirX, swayDirY);
          sway(dir);
          break;
        }
      }
    } while (this.isLooping);

    if (!keepState) {
      isRunning = false;
    }
  }

  int bounceDir = 1; // 1 = down, -1 = up
  void bounce(float progress) {
    position.y = map(easeOutBounce(progress), 0.0, 1.0, (float)startPos.y, (float)endPos.y);
    float nextStepY = map(easeOutBounce(progress + 0.01f), 0.0, 1.0, (float)startPos.y, (float)endPos.y);
    if (nextStepY - position.y < 0 && bounceDir == 1) {
      obj.tryPlayOnPaintedSFX();
      bounceDir = -1;
    } else if (nextStepY - position.y >= 0 && bounceDir == -1){
      bounceDir = 1;
    }

    currentFrameImage = currentImg;
  }

  boolean isSwaying = false;
  float swaySpeed = 0.0025f;
  float swayDirX;
  float swayDirY;
  float maxSwayDist = 30f;

  void sway(PVector dir) {
    if (position.dist(startPos) >= maxSwayDist) {
      dir = startPos.sub(position).normalize();
    }

    PVector velocity = dir.mult(swaySpeed);
    position.add(velocity);

    // ADD PRINTLN IF WEIRD CHUNKY ANIMATION

    currentFrameImage = currentImg;
  }

  void playAnimation() {
    if (isRunning) return;
    currentFrame = 0;
    //startPos = position;
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

  float easeInOutBounce(float x) {
    return x < 0.5
      ? (1 - easeOutBounce(1 - 2 * x)) / 2
      : (1 + easeOutBounce(2 * x - 1)) / 2;
  }

  PVector getRandomDirectionNormalized() {
    return new PVector(random(-1, 1), random(-1, 1)).normalize();
  }
}
