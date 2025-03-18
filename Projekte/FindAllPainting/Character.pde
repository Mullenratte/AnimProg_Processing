class Character {
  PVector position;
  PVector direction;
  float speed;
  
  PImage[] animation;
  float animationFrame = 0;
  float animFPS = 6;
  
  boolean reachedFirstWP;
  boolean reachedSecondWP;
  
  public Character(PVector pos, PVector dir, float speed, PImage[] animation){
    position = pos;
    direction = dir;
    this.speed = speed;
    this.animation = animation;
  }
  
  
  void update(float deltaTime){
    if (!FindAllPainting.wholeImagePainted) return;
    PVector velocity = new PVector(direction.x * speed * deltaTime, direction.y * speed * deltaTime);
    position.add(velocity);
    if (position.x >= width / 3 && !reachedFirstWP){
      reachedFirstWP = true;
      direction = new PVector(direction.x, 0.71);
    } 
    
    if (position.y >= height / 1.5 && !reachedSecondWP){
      reachedSecondWP = true;
      direction = new PVector(direction.x, 0);
    }
  }
  
  
  void draw(float deltaTime){
    if (!FindAllPainting.wholeImagePainted) return;
    image(animation[(int)animationFrame], position.x, position.y);
    
    animationFrame += animFPS * deltaTime;
    animationFrame = animationFrame % animation.length;
  }
}
