class Spaceship extends Floater {
  protected double myMaxSpeed;
  protected double targetX, targetY, targetRotation;
  protected double closestBorderX, closestBorderY;
  protected double hyperAcceleration;

  // -1 = inactive, 0 = stretching, 1 = departing, 2 = arriving
  protected int hyperStage = -1;
  protected int hyperCounter = 0;
  protected int hyperHalfFrames;

  protected double xStretch = 1.0;
  protected double yStretch = 1.0;
  protected int[] originalX, originalY;

  protected PVector[] leftTail = new PVector[25];
  protected PVector[] rightTail = new PVector[25];
  protected int tailCount = 0;

  protected double lastTailX, lastTailY;
  protected int lastTailStage = -1;
  protected boolean hasTailPosition = false;

  Spaceship(int spaceshipColor, double xCenter, double yCenter, double direction, double maxSpeed) {
    corners = 8;
    myXspeed = 0;
    myYspeed = 0;
    myColor = spaceshipColor;
    myCenterX = xCenter;
    myCenterY = yCenter;
    myPointDirection = direction;
    myMaxSpeed = maxSpeed;

    xCorners = new int[] {-40, -20, 20, 40, 20, -20, -40, -35};
    yCorners = new int[] {-30, -15, -15, 0, 15, 15, 30, 0};

    originalX = new int[corners];
    originalY = new int[corners];

    for (int i = 0; i < corners; i++) {
      originalX[i] = xCorners[i];
      originalY[i] = yCorners[i];
    }
  }

  public double getXSpeed() {
    return myXspeed;
  }

  public void setXSpeed(double speed) {
    myXspeed = speed;
  }

  public double getYSpeed() {
    return myYspeed;
  }

  public void setYSpeed(double speed) {
    myYspeed = speed;
  }

  public int getHyperStage() {
    return hyperStage;
  }

  public void cappedAccelerate(double amount) {
    double radians = myPointDirection * Math.PI / 180.0;

    myXspeed += amount * Math.cos(radians);
    myYspeed += amount * Math.sin(radians);

    myXspeed = Math.max(-myMaxSpeed, Math.min(myMaxSpeed, myXspeed));
    myYspeed = Math.max(-myMaxSpeed, Math.min(myMaxSpeed, myYspeed));
  }

  public void activateHyperspace() {
    if (hyperStage != -1) {
      return;
    }

    hyperStage = 0;
    hyperCounter = 0;
    myXspeed = 0;
    myYspeed = 0;
    tailCount = 0;

    targetX = 100 + Math.random() * (width - 200);
    targetY = 100 + Math.random() * (height - 200);

    closestBorderX = targetX >= width / 2.0 ? width - 1 : 0;
    closestBorderY = targetY >= height / 2.0 ? height - 1 : 0;

    double exitX = width - 1 - closestBorderX;
    double exitY = height - 1 - closestBorderY;

    // atan2 returns radians; the ship's direction is stored in degrees.
    targetRotation = Math.atan2(exitY - myCenterY, exitX - myCenterX) * 180.0 / Math.PI;
  }

  public void betterMove() {
    myCenterX += myXspeed;
    myCenterY += myYspeed;

    if (hyperStage == -1) {
      if (myCenterX > width) {
        myCenterX = 0;
      } else if (myCenterX < 0) {
        myCenterX = width;
      }

      if (myCenterY > height) {
        myCenterY = 0;
      } else if (myCenterY < 0) {
        myCenterY = height;
      }
    }
  }

  private void updateShape() {
    for (int i = 0; i < corners; i++) {
      xCorners[i] = (int)Math.round(originalX[i] * xStretch);
      yCorners[i] = (int)Math.round(originalY[i] * yStretch);
    }
  }

  public void hyperspace() {
    if (hyperStage == -1) {
      return;
    }

    if (hyperStage == 0) {
      myXspeed = 0;
      myYspeed = 0;

      xStretch += (1.5 - xStretch) * 0.1;
      yStretch += (0.75 - yStretch) * 0.1;

      double radians = (targetRotation - myPointDirection) * Math.PI / 180.0;
      double diff = Math.atan2(Math.sin(radians), Math.cos(radians)) * 180.0 / Math.PI;

      myPointDirection += diff * 0.13;

      if (xStretch >= 1.48 && yStretch <= 0.77 && Math.abs(diff) < 1) {
        myPointDirection = targetRotation;
        xStretch = 1.5;
        yStretch = 0.75;
        hyperStage = 1;
      }
    }

    if (hyperStage == 1) {
      accelerate(1.5);

      if (myCenterX <= -70 || myCenterX >= width + 70 || myCenterY <= -70 || myCenterY >= height + 70) {
        myCenterX = closestBorderX == 0 ? -70 : width + 70;
        myCenterY = closestBorderY == 0 ? -70 : height + 70;
        myXspeed = 0;
        myYspeed = 0;
        tailCount = 0;

        double dx = targetX - myCenterX;
        double dy = targetY - myCenterY;
        double distance = Math.sqrt(dx * dx + dy * dy);

        myPointDirection = Math.atan2(dy, dx) * 180.0 / Math.PI;

        hyperHalfFrames = Math.max(1, (int)Math.ceil(Math.max(Math.sqrt(distance / 0.3), distance / 10.0)));

        hyperAcceleration = distance / ((double)hyperHalfFrames * hyperHalfFrames);

        hyperCounter = 0;
        hyperStage = 2;
      }
    }

    if (hyperStage == 2) {
      if (hyperCounter < hyperHalfFrames) {
        accelerate(hyperAcceleration);
      } else {
        accelerate(-hyperAcceleration);
      }

      hyperCounter++;

      if (hyperCounter >= hyperHalfFrames) {
        double t = (double)(hyperCounter - hyperHalfFrames) /
          hyperHalfFrames;
        t = Math.min(1.0, t);
        double eased = t * t * (3 - 2 * t);

        xStretch = 1.5 - 0.5 * eased;
        yStretch = 0.75 + 0.25 * eased;
      }

      if (hyperCounter >= 2 * hyperHalfFrames) {
        myCenterX = targetX;
        myCenterY = targetY;
        myXspeed = 0;
        myYspeed = 0;
        xStretch = 1.0;
        yStretch = 1.0;
        hyperStage = -1;
      }
    }

    updateShape();
  }

  public void drawHyperTail() {
    float speed = (float)Math.sqrt(
      myXspeed * myXspeed + myYspeed * myYspeed
    );

    if (hasTailPosition &&
        ((lastTailStage == 1 && hyperStage == 2) || Math.abs(myCenterX - lastTailX) > width / 2.0 || Math.abs(myCenterY - lastTailY) > height / 2.0)) {
      tailCount = 0;
    }

    lastTailX = myCenterX;
    lastTailY = myCenterY;
    lastTailStage = hyperStage;
    hasTailPosition = true;

    if (speed < 0.01f) {
      tailCount = 0;
      return;
    }

    int lastIndex = Math.min(tailCount, leftTail.length - 1);

    for (int i = lastIndex; i > 0; i--) {
      leftTail[i] = leftTail[i - 1];
      rightTail[i] = rightTail[i - 1];
    }

    leftTail[0] = wingPosition(0);
    rightTail[0] = wingPosition(6);
    tailCount = Math.min(tailCount + 1, leftTail.length);

    float intensity = Math.min(1.0f, speed / 10.0f);

    pushStyle();
    strokeCap(ROUND);

    for (int i = tailCount - 2; i >= 0; i--) {
      float fade = 1.0f - (float)i / (tailCount - 1);

      stroke(180, 180, 180, 180 * intensity * fade);
      strokeWeight(10 * fade);

      line(leftTail[i].x, leftTail[i].y, leftTail[i + 1].x, leftTail[i + 1].y);

      line(rightTail[i].x, rightTail[i].y, rightTail[i + 1].x, rightTail[i + 1].y);
    }

    popStyle();
  }

  private PVector wingPosition(int corner) {
    double angle = myPointDirection * Math.PI / 180.0;
    double cosine = Math.cos(angle);
    double sine = Math.sin(angle);

    return new PVector((float)(myCenterX + xCorners[corner] *
    cosine - yCorners[corner] * sine),
    (float)(myCenterY + xCorners[corner] *
    sine + yCorners[corner] * cosine));
  }
}
