class Circle {
color circleColor;
float posX, posY;
float size;


  Circle(color cColor, float size, float posX, float posY) {
    this.circleColor = cColor;
    this.size = size;
    this.posX = posX;
    this.posY = posY;
  }

  void draw() {
    pushStyle();
    fill(circleColor);
    circle(posX, posY, size);
    popStyle();
  }
}
