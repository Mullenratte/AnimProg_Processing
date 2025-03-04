static class Selector{
  static Selector Instance = new Selector()  ;
  
  private Selector(){}
  
  static ArrayList<PaintableObject> hoveredObjects = new ArrayList<PaintableObject>();
  static ArrayList<PaintableObject> paintedObjects = new ArrayList<PaintableObject>();

  
  public static Selector GetInstance(){
    if (Instance == null){
      Instance = new Selector();
    }
    
    return Instance;
  }
}
