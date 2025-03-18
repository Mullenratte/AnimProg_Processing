class StaticAnimator extends Animator{

  
  StaticAnimator(PVector position, PImage currentImg, PImage imgPainted){
    super(position, currentImg, imgPainted);
  }
  
  void animate(){};

  void playAnimation(){
    println("no animation for StaticAnimators");
  };
}
