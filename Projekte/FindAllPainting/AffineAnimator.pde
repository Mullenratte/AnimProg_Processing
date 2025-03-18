class AffineAnimator extends Animator {

  PVector startPos = new PVector(0, 0);

  boolean isAnimating;
  float startTime;

  boolean isScrolling;

  AffineAnimationType currentAnimationType;

  AffineAnimator(PVector position, PImage currentImg, PImage imgPainted, boolean isScrolling, AffineAnimationType currentAnimationType) {
    super(position, currentImg, imgPainted);
    //this.startPos = position;
    this.isScrolling = isScrolling;
    this.currentAnimationType = currentAnimationType;
  }


  void animate() {
    isAnimating = true;
    while (isAnimating) {
      switch(currentAnimationType) {
      case TRANSLATE_UP:
        translate(new PVector(0f, -1f));
        try {
          Thread.sleep((long)(1000/pixelsPerSecond));
        }
        catch(InterruptedException e) {
          println("Thread interrupted");
        }
        break;
      case TRANSLATE_RIGHT:
        translate(new PVector(1f, 0f));
        try {
          Thread.sleep((long)(1000/pixelsPerSecond));
        }
        catch(InterruptedException e) {
          println("Thread interrupted");
        }
        break;
      case ROTATE:

        break;
      }
    }
  }

  float pixelsPerSecond = 150f;
  void translate(PVector dir) {
    position.add(dir);
    if (isScrolling) {
      if (position.x >= width) {
        position.x = -width;
      }
      if (position.y >= height) {
        position.y = -height;
      }
    }

    currentFrameImage = currentImg;
  }

  void playAnimation() {
    if (isRunning) return;
    currentFrame = 0;
    //startPos = position;
    Thread t = new Thread(this);
    t.start();
  }
}
