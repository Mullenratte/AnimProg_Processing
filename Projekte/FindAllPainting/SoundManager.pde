import processing.sound.*;

static class SoundManager {

  public static SoundManager Instance;

  static PApplet parent;
  HashMap<SFX, SoundFile> globalSoundList;

  ArrayList<SoundFile> backgroundMusicPlaylist;
  HashMap<SoundFile[], Integer> sfxPlaylists;
  boolean playlistActive = false;
  int currentSongIndex = 0;

  float musicVolume = 0.18f;
  float musicRate = 1f;

  private SoundManager() {
    globalSoundList = new HashMap<SFX, SoundFile>();
    backgroundMusicPlaylist = new ArrayList<SoundFile>();
    sfxPlaylists = new HashMap<SoundFile[], Integer>();

    if (this.parent != null) {
      globalSoundList.put(SFX.PAINT, new SoundFile(parent, "./Audio/pencil/test.wav"));
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

    HandleActiveSFXPlaylists();
  }

  public void PlaySoundOnce(SFX soundListKey, float volume) {
    PlaySoundOnce(globalSoundList.get(soundListKey), volume);
  }

  public void PlaySoundOnce(SoundFile file, float volume) {
    file.play(1f, volume);
  }

  public void PlayRandomSoundOnce(SoundFile[] fileSelection, float volume) {
    int i = (int)(Math.random() * fileSelection.length);
    PlaySoundOnce(fileSelection[i], volume);
  }

  public void PlayContinuously(SoundFile file, float volume) {
    file.loop(1f, volume);
  }

  public void AddSFXPlaylist(SoundFile[] files) {
    if (!sfxPlaylists.containsKey(files)) {
      sfxPlaylists.put(files, 0);
    }
  }

  private void HandleActiveSFXPlaylists() {
    for (SoundFile[] playlist : sfxPlaylists.keySet()) {
      Integer currentSongIndex = sfxPlaylists.get(playlist);
      if (!playlist[currentSongIndex].isPlaying()) {
        currentSongIndex = (sfxPlaylists.get(playlist) + 1) % playlist.length;
        sfxPlaylists.put(playlist, currentSongIndex);
        playlist[currentSongIndex].play(1, 0.5f);
      }
    }
  }

  public void StartPlaylist() {
    backgroundMusicPlaylist.get(currentSongIndex).play(musicRate, musicVolume);
    playlistActive = true;
  }

  public void StartPlaylistWithRandomSong() {
    
    currentSongIndex = (int)(Math.random() * backgroundMusicPlaylist.size());
    StartPlaylist();
  }

  private void HandleNextSong() {
    if (!backgroundMusicPlaylist.get(currentSongIndex).isPlaying()) {
      currentSongIndex = (currentSongIndex + 1) % backgroundMusicPlaylist.size();
      backgroundMusicPlaylist.get(currentSongIndex).play(musicRate, musicVolume);
    }
  }
}
