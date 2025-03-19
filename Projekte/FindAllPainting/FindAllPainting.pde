import java.util.Comparator;
import java.io.File;
import processing.sound.*;

// ---------------------
// AUDIO

SoundFile backgroundMusic;
static SoundFile[] pencilSounds;
SoundFile[] birdSounds;
SoundFile[] leafSounds;
SoundFile[] ballSounds;
SoundFile[] doorSounds;
SoundFile easterEgg_hauab;

SoundFile gameFinishedSound;

// ----------------------

// every image needs to be resized from 3508x2480. Choosing globalRescaleFactor = 4 results in 1/4 = 25% the size. 877x620
int globalRescaleFactor = 1;

PGraphics imageFrame;

ArrayList<PImage[]> sheetSliced, sheetPaintedSliced, animationsSliced;
SpritesheetSlicer slicer;

ArrayList<PaintableObject> pObjects = new ArrayList<PaintableObject>();
PaintableObject testObject;
PaintableObject testObject2;

PImage characterWalk;
ArrayList<PImage[]> characterWalkSliced = new ArrayList<PImage[]>();
Character character;

Helper Helper = new Helper();

float lastTime = 0;
float deltaTime = 0;
float gameTime = 0;

PaintableObject backgroundObj;

static int paintedObjects = 0;
int paintableObjectsTotal;

PImage pencilAnimSheet;
ArrayList<PImage[]> pencilAnimSheetSliced;
SpriteAnimator pencilAnim;
boolean pencilActive;
float pencil_currentAnimFrame = 0;
float animFPS = 15f;

static boolean wholeImagePainted;

PGraphics pg;

PFont font;


void setup() {
  frameRate(60);
  size(1280, 905);
  noCursor();

  font = createFont("Vivaldi Italic", 50);

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
  leafSounds = Helper.loadSoundFilesFromDirectory(this, "./Audio/leaves");
  ballSounds = Helper.loadSoundFilesFromDirectory(this, "./Audio/ball");
  doorSounds = Helper.loadSoundFilesFromDirectory(this, "./Audio/door");
  easterEgg_hauab = new SoundFile(this, "./Audio/hauab.wav");
  gameFinishedSound = new SoundFile(this, "./Audio/LevelUp3.mp3");
  // ----- AUDIO END ------

  // ----- LOAD IMAGES ------
  PImage uf_bg = loadImage("Background_unfilled.PNG");
  PImage f_bg = loadImage("Background_filled.PNG");

  backgroundObj = new PaintableObject(-1, new StaticAnimator(new PVector(0, 0), uf_bg, f_bg));

  imageFrame = createGraphics(1280, 905);
  imageFrame.beginDraw();
  imageFrame.image(loadImage("Rahmen.PNG"), 0, 0);
  imageFrame.endDraw();

  //sheetPainted = loadImage("p_sheet.png");
  //animations = loadImage("guy_anim_walk.png");
  pencilAnimSheet = loadImage("PencilAnimation.png");
  slicer = new SpritesheetSlicer(pencilAnimSheet, 1280, 905);
  pencilAnimSheetSliced = slicer.GetSlicedRows();
  for (int i = 0; i < pencilAnimSheetSliced.get(0).length; i++) {
    pencilAnimSheetSliced.get(0)[i].resize(1280 / 4, 905 / 4);
  }

  pencilAnim = new SpriteAnimator(new PVector(mouseX, mouseY), pencilAnimSheetSliced.get(0)[0], pencilAnimSheetSliced.get(0)[0], pencilAnimSheetSliced.get(0));

  characterWalk = loadImage("./CharacterAnimations/Walk.png");
  slicer = new SpritesheetSlicer(characterWalk, 512, 512);
  characterWalkSliced = slicer.GetSlicedRows();
  for (int i = 0; i < characterWalkSliced.get(0).length; i++) {
    characterWalkSliced.get(0)[i].resize(512 / 3, 512 / 3);
  }


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
        // Tür
      case 24:
        obj = new PaintableObject(zIndex, new StaticAnimator(new PVector(0, 0), unfilledImages[i], filledImages[i]));
        obj.setOnPaintedSFX(doorSounds, false);
        pObjects.add(obj);
        break;
        // Ball auf Dach
      case 28:
        obj = new PaintableObject(zIndex, new PhysicsAnimator(new PVector(0, 0), unfilledImages[i], filledImages[i], true, PhysicsAnimationType.BOUNCE, false));
        obj.setOnPaintedSFX(ballSounds, false);
        pObjects.add(obj);

        break;
        // Schornstein
      case 29:
        ParticleSystem chimneySmokePS = new ParticleSystem(125, 40, -1);
        chimneySmokePS.setActiveParticleType(ParticleType.Particle_Smoke);
        PaintableObject chimneyObject = new PaintableObject(zIndex, new StaticAnimator(new PVector(0, 0), unfilledImages[i], filledImages[i]));
        PVector chimneyPosition = new PVector (chimneyObject.boundingBox.position.x + chimneyObject.boundingBox.boxWidth / 2, chimneyObject.boundingBox.position.y - 5);
        chimneyObject.animator = new ParticleSystemAnimator(chimneyPosition, unfilledImages[i], unfilledImages[i], chimneySmokePS);

        chimneyObject.setOnPaintedSFX(new SoundFile[]{new SoundFile(this, "./Audio/Chimney.wav")}, true);
        pObjects.add(chimneyObject);
        break;
        // Brunnen
      case 31:
        obj = new PaintableObject(zIndex, new StaticAnimator(new PVector(0, 0), unfilledImages[i], filledImages[i]));
        obj.setOnPaintedSFX(new SoundFile[]{new SoundFile(this, "./Audio/well/drop.wav")}, false);
        pObjects.add(obj);
        break;
      default:
        // leaves
        if (zIndex != 7 && zIndex >= 5 && zIndex <= 18) {
          obj = new PaintableObject(zIndex, new StaticAnimator(new PVector(0, 0), unfilledImages[i], filledImages[i]));
          obj.setOnPaintedSFX(leafSounds, false);
          pObjects.add(obj);
        } else {
          pObjects.add(new PaintableObject(zIndex, new StaticAnimator(new PVector(0, 0), unfilledImages[i], filledImages[i])));
        }
      }
    }
  }

  // sort all pObjects based on z Index (after that, ArrayList starts with lowest zIndex)
  pObjects.sort(Comparator.comparingInt(PaintableObject::getZIndex));
  paintableObjectsTotal = pObjects.size();

  character = new Character(new PVector(-25, 430), new PVector(1f, 0f), 30f, characterWalkSliced.get(0));

  //debug
  //for (PaintableObject o : pObjects) {
  //  o.startPaintCoroutine();
  //}

  mouseX = 0;
  mouseY = 0;
}

float tutorialDuration = 30;
float tutorialTime = 0;
boolean showTutorial = true;


void draw() {
  background(255);
  backgroundObj.update();
  backgroundObj.draw();
  //background(153, 206, 255);
  SoundManager.Instance.update();
  deltaTime = (millis() - lastTime) / 1000;
  lastTime = millis();
  gameTime += deltaTime;


  if (!wholeImagePainted && paintedObjects >= paintableObjectsTotal) {
    wholeImagePainted = true;
    backgroundObj.startPaintCoroutine();
    SoundManager.Instance.PlaySoundOnce(gameFinishedSound, 0.8f);
  }

  for (PaintableObject obj : pObjects) {
    if (obj.zIndex == 7 && !character.reachedFirstWP) {
      // character
      character.update(deltaTime);
      character.draw(deltaTime);
    }
    obj.update();
    obj.draw();
  }

  if (character.reachedFirstWP) {
    character.update(deltaTime);
    character.draw(deltaTime);
  }



  image(imageFrame, 0, 0);

  if (showTutorial) {
    handleTutorialScreen();
  }


  if (pencilActive) {
    pencil_currentAnimFrame += deltaTime * animFPS;
    if (pencil_currentAnimFrame >= pencilAnimSheetSliced.get(0).length) {
      pencilActive = false;
      pencil_currentAnimFrame = 0;
    }
    image(pencilAnimSheetSliced.get(0)[(int)pencil_currentAnimFrame], mouseX - 99, mouseY - 170);
    //pencil_currentAnimFrame = (pencil_currentAnimFrame + 1) % pencilAnimSheetSliced.get(0).length;
  } else {
    image(pencilAnimSheetSliced.get(0)[0], mouseX - 99, mouseY - 170);
  }
}

void handleTutorialScreen() {
  tutorialTime += deltaTime;

  if (tutorialTime > tutorialDuration) {
    showTutorial = false;
  }
  pushStyle();
  tint(0, 233);
  image(backgroundObj.currentImg, 0, 0);
  textSize(50);
  textAlign(CENTER);
  fill(225, 136, 46);
  //String[] fonts = PFont.list();
  //printArray(fonts);
  textFont(font);
  text("Paint objects by clicking them. \n Some objects add animation or sound when painted!", width/2, height/2);
  textSize(28);
  fill(233);
  text("Click to continue", width/2, height/2 + 225);
  popStyle();
}

void mousePressed() {
  if (showTutorial) {
    showTutorial = false;
  } else {
    tryPaintForegroundObject();
  }
}

void keyPressed() {
}

int clickedDoorAmounts = 0;
void tryPaintForegroundObject() {
  PaintableObject highestZObj = null;
  int highestZ = -1;
  for (PaintableObject obj : Selector.hoveredObjects) {
    if (obj.zIndex > highestZ) {
      highestZ = obj.zIndex;
      highestZObj = obj;
    }
  }

  if (highestZObj != null) {
    highestZObj.startPaintCoroutine();
    if (!highestZObj.isPainted) {
      pencilActive = true;
    }

    if (wholeImagePainted) {
      highestZObj.tryPlayOnPaintedSFX();
    }

    // check for door
    if (highestZObj.zIndex == 24) {
      clickedDoorAmounts++;
      if (clickedDoorAmounts > 5) {
        SoundManager.Instance.PlaySoundOnce(easterEgg_hauab, 1f);
        clickedDoorAmounts = 0;
      }
    }
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
