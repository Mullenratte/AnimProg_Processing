import processing.sound.*;

static class SoundManager {

  public static SoundManager Instance;

  static PApplet parent;
  HashMap<SFX, SoundFile> globalSoundList;

  ArrayList<SoundFile> backgroundMusicPlaylist;
  boolean playlistActive = false;
  int currentSongIndex = 0;

  private SoundManager() {
    globalSoundList = new HashMap<SFX, SoundFile>();
    backgroundMusicPlaylist = new ArrayList<SoundFile>();

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

  void update() {
    HandleNextSong();
  }

  public void PlaySoundOnce(SFX soundListKey) {
    globalSoundList.get(soundListKey).play();
  }

  public void PlayContinuously(SoundFile file) {
    file.loop();
  }

  public void StartPlaylist() {
    backgroundMusicPlaylist.get(currentSongIndex).play();
    playlistActive = true;
  }

  public void StartPlaylistWithRandomSong() {
    backgroundMusicPlaylist.get((int)(Math.random() * backgroundMusicPlaylist.size())).play();
    playlistActive = true;
  }

  private void HandleNextSong() {
    if (!backgroundMusicPlaylist.get(currentSongIndex).isPlaying()) {
      currentSongIndex = (currentSongIndex + 1) % backgroundMusicPlaylist.size();
      backgroundMusicPlaylist.get(currentSongIndex).play();
    }
  }
}
