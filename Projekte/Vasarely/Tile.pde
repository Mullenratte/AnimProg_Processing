class Tile implements IDrawable{
  private int posX = 0;
  private int posY = 0;
  int size = 10;
  
  color outerColor;
  color innerColor;
  boolean isCircle = false;
  
  Tile(int size){
    this.size = size;
    
    innerColor = color(random(255), random(255), random(255));
    outerColor = color(random(255), random(255), random(255));
    

    
    

  }
  
  void draw(int posX, int posY){
    fill(outerColor);
    rect(posX, posY, size, size);
    
    if (isCircle){
      pushStyle();
      ellipseMode(CENTER);
      fill(innerColor);
      circle(posX + size / 2, posY + size / 2, size * 0.66);
      popStyle();
    } else{
      pushStyle();
      rectMode(CENTER);
      fill(innerColor);
      rect(posX + size / 2, posY + size / 2, size * 0.66, size * 0.66);
      popStyle();
    }
    
    
  }
  
  void update(){
    
  }
  
  void ChangePositionAndUpdateIsCircle(int posX, int posY){
    this.posX = posX;
    this.posY = posY;
    
    if(posY < 2 * size || posX < 2 * size && posY < 5 * size || posX > 7 * size && posY < 5 * size || posY > 4 * size && posY < 8 * size && posX > 1 * size && posX < 8 * size){
      isCircle = true;
    }
  }
}
