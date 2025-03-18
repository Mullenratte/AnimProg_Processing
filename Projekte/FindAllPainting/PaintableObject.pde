import processing.sound.*;

class PaintableObject implements Runnable {
  PImage currentImg;
  PImage imgPainted;

  boolean paintCoroutineRunning = false;
  boolean isPainted = false;
  boolean canSelect = true;

  PVector position;
  PVector boundingBoxPosition;
  float boundingBoxWidth;
  float boundingBoxHeight;

  BoundingBox boundingBox;

  // objects with lowest zIndex get drawn first, highest last
  int zIndex;

  Animator animator;

  int smokeParticlePoolSize = 150;

  ParticleSystem smokePS;

  // minimal duration before the particle system gets inactive
  float smokePSMinimalDuration = 1.5f;

  // factor that determines how much longer (or shorter) the PS should exist after the obj has been fully painted. 1.5 = 50% longer than the original duration
  float smokePSLingerFactor = 2.5f;

  // time the thread is put to sleep each frame, in milliseconds;
  int threadSleepTime_ms = 5;

  SoundFile[] onPaintedSFX;
  boolean onPaintedSFXLooping;
  boolean playSFXWhenPainted = true;

  PaintableObject(int zIndex, Animator animator) {
    this.currentImg = animator.currentImg;
    this.imgPainted = animator.imgPainted;
    this.position = new PVector(0, 0);
    this.zIndex = zIndex;
    smokePS = new ParticleSystem(0, 50, 3.5, false);
    //smokePS.setActiveParticleType(ParticleType.Particle_Smoke);
    updateBoundingBox();
    this.animator = animator;
    if (animator != null && animator instanceof PhysicsAnimator) {
      this.playSFXWhenPainted = false;
      animator.obj = this;
    }
  }

  void run() {
    //smokePS.init(mouseX, mouseY);
    // time it takes to fully paint the object (seconds)
    //smokePS.duration = Math.max(smokePSMinimalDuration, smokePSLingerFactor * boundingBoxHeight * threadSleepTime_ms / 1000f);
    SoundManager.Instance.PlayRandomSoundOnce(FindAllPainting.pencilSounds, 0.8f);
    int milliseconds = 0;
    for (int y = (int)boundingBoxPosition.y; y < (int)boundingBoxPosition.y + boundingBoxHeight; y++) {
      for (int x = (int)boundingBoxPosition.x; x < (int)boundingBoxPosition.x + boundingBoxWidth; x++) {
        currentImg.set(x, y, imgPainted.get(x, y));
      }

      try {
        Thread.sleep(threadSleepTime_ms);
        milliseconds += threadSleepTime_ms;
      }
      catch(InterruptedException e) {
        println("Thread interrupted");
      }
    }
    if (!isPainted) {
      FindAllPainting.paintedObjects++;
    }
    isPainted = true;
    canSelect = false;
    tryPlayOnPaintedSFX();
  }


  void draw() {
    if (animator != null) {
      if (animator.isRunning) {
        animator.draw();
      } else {
        // HIER
        image(currentImg, position.x, position.y);
        if (isPainted
          //&& mouseOver()
          //&& mousePressed
          && animator != null
          && !(animator instanceof StaticAnimator)) {
          animator.playAnimation();
        }
      }
    } else {
      image(currentImg, position.x, position.y);
    }

    //if (mouseOver()) drawBoundingBox();
  }

  void update() {
    if (!Selector.hoveredObjects.contains(this)
      && !isPainted
      && mouseOver()
      && !Selector.paintedObjects.contains(this)
      ||
      !Selector.hoveredObjects.contains(this)
      && FindAllPainting.wholeImagePainted
      && mouseOver()) {
      //println("added " + this.zIndex);
      Selector.hoveredObjects.add(this);
    }
    if (Selector.hoveredObjects.contains(this)
      && (!mouseOver()    ||    isPainted && !FindAllPainting.wholeImagePainted)) {
      //println("removed " + this.zIndex);
      Selector.hoveredObjects.remove(this);
    }


    smokePS.update();
  }

  void startPaintCoroutine() {
    if (paintCoroutineRunning || isPainted) return;
    paintCoroutineRunning = true;
    Selector.paintedObjects.add(this);
    Thread t = new Thread(this);
    t.start();
  }


  void tryPlayOnPaintedSFX() {
    if (onPaintedSFX != null && playSFXWhenPainted || onPaintedSFX != null && this.animator instanceof PhysicsAnimator) {
      if (onPaintedSFXLooping) {
        SoundManager.Instance.AddSFXPlaylist(onPaintedSFX);
      } else {
        SoundManager.Instance.PlayRandomSoundOnce(onPaintedSFX, 0.5f);
      }
    }
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
    line(boundingBox.position.x, boundingBox.position.y, boundingBox.position.x + boundingBoxWidth, boundingBox.position.y);
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

  void setOnPaintedSFX(SoundFile[] files, boolean isLooping) {
    onPaintedSFX = files;
    onPaintedSFXLooping = isLooping;
  }
}
