class PaintableObject implements Runnable {
  PImage currentImg;
  PImage imgPainted;

  boolean isPainted = false;

  PVector position;
  PVector boundingBoxPosition;
  float boundingBoxWidth;
  float boundingBoxHeight;

  BoundingBox boundingBox;

  // objects with lowest zIndex get drawn first, highest last
  int zIndex;

  Animator animator;

  PaintableObject(int zIndex, Animator animator) {
    this.currentImg = animator.currentImg;
    this.imgPainted = animator.imgPainted;
    this.position = new PVector(0, 0);
    this.zIndex = zIndex;

    updateBoundingBox();
    this.animator = animator;
    if (animator != null && animator instanceof PhysicsAnimator) {
      animator.obj = this;
    }
  }

  void run() {
    SoundManager.Instance.PlaySoundOnce(SFX.PAINT);
    for (int y = (int)boundingBoxPosition.y; y < (int)boundingBoxPosition.y + boundingBoxHeight; y++) {
      for (int x = (int)boundingBoxPosition.x; x < (int)boundingBoxPosition.x + boundingBoxWidth; x++) {
        currentImg.set(x, y, imgPainted.get(x, y));
      }
      try {
        Thread.sleep(5);
      }
      catch(InterruptedException e) {
        println("Thread interrupted");
      }
    }
    isPainted = true;
  }



  void draw() {
    if (animator != null) {
      if (animator.isRunning) {
        animator.draw();
      } else {
        image(currentImg, position.x, position.y);
        if (isPainted
          && mouseOver()
          && mousePressed
          && animator != null) {
          animator.playAnimation();
        }
      }
    } else {
      image(currentImg, position.x, position.y);
    }

    drawBoundingBox();
  }

  void update() {
    if (mouseOver() && !Selector.paintedObjects.contains(this)) {
      Selector.hoveredObjects.add(this);
    } else {
      Selector.hoveredObjects.remove(this);
    }
  }

  void startPaintCoroutine() {
    Selector.paintedObjects.add(this);
    Thread t = new Thread(this);
    t.start();
  }

  void setPosition(PVector newPosition) {
    position = newPosition;
    updateBoundingBox();
  }

  void updateBoundingBox() {
    boundingBoxPosition = calculateBBPosition();
    PVector dimensions = calculateBBDimensions();
    boundingBoxWidth = dimensions.x;
    boundingBoxHeight = dimensions.y;
    this.boundingBox = new BoundingBox(boundingBoxPosition, boundingBoxWidth, boundingBoxHeight);
  }

  PVector calculateBBPosition() {
    PVector topLeftMostPosition = new PVector(9999, 9999);
    for (int x = 0; x < currentImg.width; x++) {
      for (int y = 0; y < currentImg.height; y++) {
        if (currentImg.get(x, y) != 0
          && x < topLeftMostPosition.x) {
          topLeftMostPosition.x = x;
        }
        if (currentImg.get(x, y) != 0
          && y < topLeftMostPosition.y) {
          topLeftMostPosition.y = y;
        }
      }
    }
    return topLeftMostPosition;
  }

  PVector calculateBBDimensions() {
    PVector bottomRightCorner = new PVector(-1, -1);
    for (int x = currentImg.width; x > 0; x--) {
      for (int y = currentImg.height; y > 0; y--) {
        if (currentImg.get(x, y) != 0
          && x > bottomRightCorner.x) {
          bottomRightCorner.x = x;
        }
        if (currentImg.get(x, y) != 0
          && y > bottomRightCorner.y) {
          bottomRightCorner.y = y;
        }
      }
    }
    return new PVector(bottomRightCorner.x - boundingBoxPosition.x,
      bottomRightCorner.y - boundingBoxPosition.y);
  }

  //debug
  void drawBoundingBox() {
    pushStyle();
    stroke(0, 255, 0);
    line(boundingBoxPosition.x, boundingBoxPosition.y, boundingBoxPosition.x + boundingBoxWidth, boundingBoxPosition.y);
    line(boundingBoxPosition.x, boundingBoxPosition.y, boundingBoxPosition.x, boundingBoxPosition.y + boundingBoxHeight);
    line(boundingBoxPosition.x + boundingBoxWidth, boundingBoxPosition.y, boundingBoxPosition.x + boundingBoxWidth, boundingBoxPosition.y + boundingBoxHeight);
    line(boundingBoxPosition.x, boundingBoxPosition.y + boundingBoxHeight, boundingBoxPosition.x + boundingBoxWidth, boundingBoxPosition.y + boundingBoxHeight);
    popStyle();
  }

  boolean mouseOver() {
    if (mouseX <= boundingBoxPosition.x + boundingBoxWidth
      && mouseX >= boundingBoxPosition.x
      && mouseY <= boundingBoxPosition.y + boundingBoxHeight
      && mouseY >= boundingBoxPosition.y) {
      return true;
    }

    return false;
  }

  int getZIndex() {
    return zIndex;
  }
}
