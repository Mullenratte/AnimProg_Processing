import processing.sound.*;

static class SoundManager {

  public static SoundManager Instance;

  static PApplet parent;
  HashMap<SFX, SoundFile> globalSoundList;

  private SoundManager() {
    globalSoundList = new HashMap<SFX, SoundFile>();
    if (this.parent != null) {
      globalSoundList.put(SFX.PAINT, new SoundFile(parent, "./Audio/test.wav"));
    }
  };

  public SoundManager(PApplet in_parent) {
    if (Instance == null) {
      parent = in_parent;
      Instance = new SoundManager();
    } else {
      println("An Instance of SoundManager already exists!");
    }
    return;
  }


  public void PlaySoundOnce(SFX soundListKey) {
    globalSoundList.get(soundListKey).play();
  }
}
