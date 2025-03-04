PImage sheetPainted, animations;
ArrayList<PImage[]> sheetSliced, sheetPaintedSliced, animationsSliced;
SpritesheetSlicer slicer;

ArrayList<PaintableObject> pObjects = new ArrayList<PaintableObject>();
PaintableObject testObject;
PaintableObject testObject2;

PImage egg, eggFilled;

void setup() {
  frameRate(500);
  size(800, 800);


  //sheet = loadImage("sheet.png");
  sheetPainted = loadImage("p_sheet.png");
  animations = loadImage("guy_anim_walk.png");
  slicer = new SpritesheetSlicer(sheetPainted, 400, 400);
  //sheetSliced = slicer.GetSlicedRows();
  slicer.SetSpritesheet(sheetPainted);
  sheetPaintedSliced = slicer.GetSlicedRows();
  sheetSliced = slicer.GetSlicedRows();
  
  for (PImage[] array : sheetSliced){
    array[0].filter(THRESHOLD, 0.05);
  }
  
  slicer.SetSpritesheet(animations);
  animationsSliced = slicer.GetSlicedRows();

  for (int i = 0; i < sheetSliced.size(); i++) {
    PImage defaultImg = sheetSliced.get(i)[0];
    PImage paintedImg = sheetPaintedSliced.get(i)[0];

    if (i == 0) {
      SpriteAnimator animator = new SpriteAnimator(new PVector(0,0), defaultImg, paintedImg, animationsSliced.get(i));
      animator.isLooping = true;
      pObjects.add(new PaintableObject(i, animator));
    } else {
      pObjects.add(new PaintableObject(i, new StaticAnimator(new PVector(0,0), defaultImg, paintedImg)));
    }
  }


  egg = loadImage("egg.png");
  eggFilled = loadImage("egg_f.png");
  pObjects.add(new PaintableObject(10, new PhysicsAnimator(new PVector(0,0), egg, eggFilled, true)));
}

void draw() {
  background(255);
  for (PaintableObject obj : pObjects) {
    obj.update();
    obj.draw();
  }
}


void mousePressed() {
  tryPaintForegroundObject();
}

void keyPressed() {
}

void tryPaintForegroundObject() {
  PaintableObject highestZObj = null;
  int highestZ = -1;
  for (PaintableObject obj : Selector.GetInstance().hoveredObjects) {
    if (obj.zIndex > highestZ) {
      highestZ = obj.zIndex;
      highestZObj = obj;
    }
  }

  if (highestZObj != null) {
    highestZObj.startPaintCoroutine();
  }
}
