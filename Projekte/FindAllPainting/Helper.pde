class Helper {

  float getRandomBetweenWithoutZero(float a, float b) {
    float rnd = random(a - 1, b - 1);
    if (rnd != -1.0f) rnd += 1;
    return rnd;
  }

  File[] loadFilesFromDirectory(String path) {
    File dir = new File(dataPath(path));
    return dir.listFiles();
  }
  
  SoundFile[] loadSoundFilesFromDirectory(PApplet parent, String path) {
      File[] files = loadFilesFromDirectory(path);
      SoundFile[] soundFiles = new SoundFile[files.length];
      for (int i = 0; i < files.length; i++){
        soundFiles[i] = new SoundFile(parent, files[i].getAbsolutePath());
      }
      
      return soundFiles;
  }
}
