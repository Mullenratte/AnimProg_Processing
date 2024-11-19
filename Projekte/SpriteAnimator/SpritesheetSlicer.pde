class SpritesheetSlicer {
  PImage spritesheet;
  int widthPerSprite, heightPerSprite;

  SpritesheetSlicer(PImage spritesheet, int widthPerSprite, int heightPerSprite) {
    this.spritesheet = spritesheet;
    this.widthPerSprite = widthPerSprite;
    this.heightPerSprite = heightPerSprite;

    IsEmptyCell(0, 0);
  }

  ArrayList<PImage[]> GetSlicedRows() {
    int rows = (spritesheet.height / heightPerSprite);
    int columns = (spritesheet.width / widthPerSprite);
    ArrayList<PImage[]> animationRows = new ArrayList<PImage[]>();

    for (int y = 0; y < rows; y++) {
      int amountFramesInRow = 0;
      for (int x = 0; x < columns; x++) {
        if (!IsEmptyCell(x * widthPerSprite, y * heightPerSprite)) {
          amountFramesInRow++;
        }
      }

      PImage[] animFrames = new PImage[amountFramesInRow];

      for (int x = 0; x < columns; x++) {
        if (!IsEmptyCell(x * widthPerSprite, y * heightPerSprite)) {
          animFrames[x] = spritesheet.get(x * widthPerSprite, y * heightPerSprite, widthPerSprite, heightPerSprite);
        }
      }

      animationRows.add(animFrames);
    }

    return animationRows;
  }

  void SetSpritesheet(PImage spritesheet) {
    this.spritesheet = spritesheet;
  }

  boolean IsEmptyCell(int x, int y) {
    color backgroundColor = spritesheet.get(x, y);
    for (int u = x; u < x + widthPerSprite; u++) {
      for (int v = y; v < y + heightPerSprite; v++) {
        if (spritesheet.get(u, v) != backgroundColor) {
          return false;
        }
      }
    }
    return true;
  }
}
