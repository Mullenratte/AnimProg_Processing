class Helper {

  float getRandomBetweenWithoutZero(float a, float b) {
    float rnd = random(a - 1, b - 1);
    if (rnd != -1.0f) rnd += 1;
    return rnd;
  }
}
