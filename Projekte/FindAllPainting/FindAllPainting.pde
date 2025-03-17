import java.util.Comparator;

// every image needs to be resized from 3508x2480. Choosing globalRescaleFactor = 4 results in 1/4 = 25% the size. 877x620
int globalRescaleFactor = 4;
PImage sheetPainted, animations;
ArrayList<PImage[]> sheetSliced, sheetPaintedSliced, animationsSliced;
SpritesheetSlicer slicer;

ArrayList<PaintableObject> pObjects = new ArrayList<PaintableObject>();
PaintableObject testObject;
PaintableObject testObject2;

PImage egg, eggFilled;



Helper Helper = new Helper();

float lastTime = 0;
float deltaTime = 0;
float gameTime = 0;


void setup() {
  frameRate(60);
  size(800, 600);
 // fullScreen();
  
  // construct Singleton
  new SoundManager(this);



  //sheet = loadImage("sheet.png");
  sheetPainted = loadImage("p_sheet.png");
  animations = loadImage("guy_anim_walk.png");
  slicer = new SpritesheetSlicer(sheetPainted, 400, 400);
  //sheetSliced = slicer.GetSlicedRows();
  slicer.SetSpritesheet(sheetPainted);
  sheetPaintedSliced = slicer.GetSlicedRows();
  sheetSliced = slicer.GetSlicedRows();

  for (PImage[] array : sheetSliced) {
    array[0].filter(THRESHOLD, 0.05);
  }

  slicer.SetSpritesheet(animations);
  animationsSliced = slicer.GetSlicedRows();

  for (int i = 0; i < sheetSliced.size(); i++) {
    PImage defaultImg = sheetSliced.get(i)[0];
    PImage paintedImg = sheetPaintedSliced.get(i)[0];

    // character
    if (i == 0) {
      SpriteAnimator animator = new SpriteAnimator(new PVector(0, 0), defaultImg, paintedImg, animationsSliced.get(i));
      animator.isLooping = true;
      pObjects.add(new PaintableObject(i, animator));
    }
    // cloud
    else if (i == 2) {
      pObjects.add(new PaintableObject(10, new AffineAnimator(new PVector(0, 0), defaultImg, paintedImg, true, AffineAnimationType.TRANSLATE)));
    } else {
      pObjects.add(new PaintableObject(i, new StaticAnimator(new PVector(0, 0), defaultImg, paintedImg)));
    }
  }

  // egg
  egg = loadImage("egg.png");
  eggFilled = loadImage("egg_f.png");

  pObjects.add(new PaintableObject(10, new PhysicsAnimator(new PVector(0, 0), egg, eggFilled, true, PhysicsAnimationType.BOUNCE, false)));


  // tree
  //PImage treeSheet = loadImage("tree.png");
  //slicer.SetSpritesheet(treeSheet);
  //ArrayList<PImage[]> treeLayers = slicer.GetSlicedRows();
  //for (int i = 0; i < treeLayers.size(); i++) {
  //  PImage layerImg = treeLayers.get(i)[0];
  //  if (i == 0) {
  //    pObjects.add(new PaintableObject(10, new StaticAnimator(new PVector(0, 0), layerImg, layerImg)));
  //  } else {
  //    pObjects.add(new PaintableObject(10, new PhysicsAnimator(new PVector(0, 0), layerImg, layerImg, true, PhysicsAnimationType.SWAY, true)));
  //  }
  //}


  // house
  File directory = new File(dataPath("./Haus"));
  File[] files = directory.listFiles((d, name) -> name.endsWith(".PNG"));

  PImage[] houseParts = new PImage[files.length];
  // Load images into an array
  if (files != null) {
    for (int i = 0; i < files.length; i++) {
      houseParts[i] = loadImage(files[i].getAbsolutePath());
      houseParts[i].resize(houseParts[i].width / globalRescaleFactor, houseParts[i].height / globalRescaleFactor);
      if (i != 8) {
        pObjects.add(new PaintableObject(30 + i, new StaticAnimator(new PVector(0, 0), houseParts[i], houseParts[i])));
      }
      // Ball auf Dach
      else {
        pObjects.add(new PaintableObject(30 + i, new PhysicsAnimator(new PVector(0, 0), houseParts[i], houseParts[i], true, PhysicsAnimationType.BOUNCE, false)));
      }
    }
  }



  // sort all pObjects based on z Index (after that, ArrayList starts with lowest zIndex)
  pObjects.sort(Comparator.comparingInt(PaintableObject::getZIndex));
}

void draw() {
  deltaTime = (millis() - lastTime) / 1000;
  lastTime = millis();
  gameTime += deltaTime;

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

color getFireColor() {
  return color(random(200, 255), random(50, 200), random(0, 50));
}

color getRandomColor() {
  return color(random(255), random(255), random(255));
}
