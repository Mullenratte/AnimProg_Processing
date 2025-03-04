abstract class Animator implements Runnable, IAnimatable {
  PImage currentImg;
  PImage imgPainted;

  PImage currentFrameImage;
  PVector position;
  int currentFrame = 0;
  int fps = 24;
  boolean isRunning = false;
  boolean isLooping = false;

  PaintableObject obj;

  Animator(PVector position, PImage currentImg, PImage imgPainted) {
    this.currentImg = currentImg;
    this.imgPainted = imgPainted;
    this.position = position;
    this.currentFrameImage = new PImage();
  }


  void run() {
    isRunning = true;
    animate();
  }

  void draw() {
    image(currentFrameImage, position.x, position.y);
  }

  abstract void animate();

  abstract void playAnimation();
}
