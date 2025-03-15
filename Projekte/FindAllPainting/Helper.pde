class Helper {

  float getRandomBetweenWithoutZero(float a, float b) {
    float rnd = random(a, b - 1);
    if (rnd >= 0) rnd += 1;

    return rnd;
  }
}
