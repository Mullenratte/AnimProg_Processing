import java.util.Comparator;
import java.io.File;
import processing.sound.*;

// ---------------------
// AUDIO

SoundFile backgroundMusic;
static SoundFile[] pencilSounds;
SoundFile[] birdSounds;

// ----------------------

// every image needs to be resized from 3508x2480. Choosing globalRescaleFactor = 4 results in 1/4 = 25% the size. 877x620
int globalRescaleFactor = 1;

PImage imageFrame;

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

PaintableObject backgroundObj;

static int paintedObjects = 0;
int paintableObjectsTotal;


void setup() {
  frameRate(60);
  size(1280, 905);
  // ----- AUDIO ------
  // construct Singleton
  new SoundManager(this);

  // fill background music playlist, then start
  File[] musicDirFiles = Helper.loadFilesFromDirectory("./Audio/bgm");
  for (int i = 0; i < musicDirFiles.length; i++) {
    SoundManager.Instance.backgroundMusicPlaylist.add(new SoundFile(this, musicDirFiles[i].getAbsolutePath()));
  }
  //SoundManager.Instance.StartPlaylist();
  SoundManager.Instance.StartPlaylistWithRandomSong();

  pencilSounds = Helper.loadSoundFilesFromDirectory(this, "./Audio/pencil");
  birdSounds = Helper.loadSoundFilesFromDirectory(this, "./Audio/birds");

  // ----- AUDIO END ------

  // ----- LOAD IMAGES ------
  PImage uf_bg = loadImage("Background_unfilled.PNG");
  PImage f_bg = loadImage("Background_filled.PNG");

  backgroundObj = new PaintableObject(-1, new StaticAnimator(new PVector(0, 0), uf_bg, f_bg));
  imageFrame = loadImage("Rahmen.PNG");

  //sheetPainted = loadImage("p_sheet.png");
  //animations = loadImage("guy_anim_walk.png");
  //slicer = new SpritesheetSlicer(sheetPainted, 400, 400);
  //slicer.SetSpritesheet(sheetPainted);
  //sheetPaintedSliced = slicer.GetSlicedRows();
  //sheetSliced = slicer.GetSlicedRows();

  //for (PImage[] array : sheetSliced) {
  //  array[0].filter(THRESHOLD, 0.05);
  //}

  //slicer.SetSpritesheet(animations);
  //animationsSliced = slicer.GetSlicedRows();

  //for (int i = 0; i < sheetSliced.size(); i++) {
  //  PImage defaultImg = sheetSliced.get(i)[0];
  //  PImage paintedImg = sheetPaintedSliced.get(i)[0];

  //  // character
  //  if (i == 0) {
  //    SpriteAnimator animator = new SpriteAnimator(new PVector(0, 0), defaultImg, paintedImg, animationsSliced.get(i));
  //    animator.isLooping = true;
  //    pObjects.add(new PaintableObject(i, animator));
  //  }
  //  // cloud
  //  else if (i == 2) {
  //    pObjects.add(new PaintableObject(10, new AffineAnimator(new PVector(0, 0), defaultImg, paintedImg, true, AffineAnimationType.TRANSLATE_RIGHT)));
  //  } else {
  //    pObjects.add(new PaintableObject(i, new StaticAnimator(new PVector(0, 0), defaultImg, paintedImg)));
  //  }
  //}

  //// egg
  //egg = loadImage("egg.png");
  //eggFilled = loadImage("egg_f.png");

  //pObjects.add(new PaintableObject(10, new PhysicsAnimator(new PVector(0, 0), egg, eggFilled, true, PhysicsAnimationType.BOUNCE, false)));


  // house
  File directory = new File(dataPath("./Weiss"));
  File[] u_files = directory.listFiles((d, name) -> name.endsWith(".PNG"));

  directory = new File(dataPath("./Farbe"));
  File[] f_files = directory.listFiles((d, name) -> name.endsWith(".PNG"));
  if (u_files != null && f_files != null) {
    PImage[] unfilledImages = new PImage[u_files.length];
    PImage[] filledImages = new PImage[u_files.length];

    // Load images into an array
    for (int i = 0; i < u_files.length; i++) {
      String absPath = u_files[i].getAbsolutePath();
      unfilledImages[i] = loadImage(absPath);
      absPath = f_files[i].getAbsolutePath();
      filledImages[i] = loadImage(absPath);
      int zIndex = Integer.parseInt(u_files[i].getName().substring(0, 2));
      unfilledImages[i].resize(unfilledImages[i].width / globalRescaleFactor, unfilledImages[i].height / globalRescaleFactor);
      filledImages[i].resize(filledImages[i].width / globalRescaleFactor, filledImages[i].height / globalRescaleFactor);

      switch (zIndex) {
        // Wolken
      case 2:
        pObjects.add(new PaintableObject(zIndex, new AffineAnimator(new PVector(0, 0), unfilledImages[i], filledImages[i], true, AffineAnimationType.TRANSLATE_RIGHT)));
        break;
        // großer Baum links
      case 13:
        PaintableObject obj = new PaintableObject(zIndex, new StaticAnimator(new PVector(0, 0), unfilledImages[i], filledImages[i]));
        obj.setOnPaintedSFX(birdSounds, true);
        pObjects.add(obj);

        break;
        // Ball auf Dach
      case 28:
        pObjects.add(new PaintableObject(zIndex, new PhysicsAnimator(new PVector(0, 0), unfilledImages[i], filledImages[i], true, PhysicsAnimationType.BOUNCE, false)));
        break;
        // Schornstein
      case 29:
        ParticleSystem chimneySmokePS = new ParticleSystem(125, 40, -1);
        chimneySmokePS.setActiveParticleType(ParticleType.Particle_Smoke);
        PaintableObject chimneyObject = new PaintableObject(zIndex, new StaticAnimator(new PVector(0, 0), unfilledImages[i], filledImages[i]));
        PVector chimneyPosition = new PVector (chimneyObject.boundingBox.position.x + chimneyObject.boundingBox.boxWidth / 2, chimneyObject.boundingBox.position.y - 5);
        chimneyObject.animator = new ParticleSystemAnimator(chimneyPosition, unfilledImages[i], unfilledImages[i], chimneySmokePS);

        chimneyObject.onPaintedSFX = new SoundFile[]{new SoundFile(this, "./Audio/Chimney.wav")};
        pObjects.add(chimneyObject);
        break;
      default:
        pObjects.add(new PaintableObject(zIndex, new StaticAnimator(new PVector(0, 0), unfilledImages[i], filledImages[i])));
      }
    }
  }



  // sort all pObjects based on z Index (after that, ArrayList starts with lowest zIndex)
  pObjects.sort(Comparator.comparingInt(PaintableObject::getZIndex));
  paintableObjectsTotal = pObjects.size();
}

void draw() {
  background(255);
  backgroundObj.update();
  backgroundObj.draw();
  //background(153, 206, 255);
  SoundManager.Instance.update();
  deltaTime = (millis() - lastTime) / 1000;
  lastTime = millis();
  gameTime += deltaTime;


  for (PaintableObject obj : pObjects) {
    obj.update();
    obj.draw();
  }

  if (paintedObjects >= paintableObjectsTotal) {
    backgroundObj.startPaintCoroutine();
  }

  image(imageFrame, 0, 0);
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

int getRandomInt(int min, int max) {
  return (int)random(min, max+1);
}
