class Spaceship extends Floater  
{   
  protected double myMaxSpeed, targetX, targetY, targetRotation, closestBorderX, closestBorderY, hyperAcceleration;
  protected int hyperStage = -1; // -1 = Inactive, 0 = Stretching, 1 = Moving, 2 = Unstretching
  protected double xStretch = 1.0;
  protected double yStretch = 1.0;
  protected int hyperCounter = 0;
  protected int hyperHalfFrames;
  
  protected int[] originalX, originalY;
  
  protected ArrayList<PVector[]> tailHistory = new ArrayList<PVector[]>();

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
    
    xCorners = new int[]{-40, -20, 20, 40, 20, -20, -40, -35};
    yCorners = new int[]{-30, -15, -15, 0, 15, 15, 30, 0};
    
    originalX = new int[xCorners.length];
    originalY = new int[yCorners.length];
    
    for (int i = 0; i < xCorners.length; i++) {
      originalX[i] = xCorners[i];
    }
    
    for (int i = 0; i < yCorners.length; i++) {
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
  
  public void cappedAccelerate (double dAmount) {
    double dRadians =myPointDirection*(Math.PI/180);     
    //change coordinates of direction of travel    
    myXspeed += ((dAmount) * Math.cos(dRadians));
    myYspeed += ((dAmount) * Math.sin(dRadians));
    
    myXspeed = Math.max(Math.min(myMaxSpeed, myXspeed), -myMaxSpeed);
    myYspeed = Math.max(Math.min(myMaxSpeed, myYspeed), -myMaxSpeed);
  }
  
  public void activateHyperspace() {
    if (hyperStage == -1) {
      hyperStage = 0;
      targetX = Math.random()*600+100;
      targetY = Math.random()*600+100;
      
      double targetCornerX, targetCornerY;
      
      closestBorderX = targetX>=400 ? 799 : 0;
      closestBorderY = targetY>=400 ? 799 : 0;
      targetCornerX = 799-closestBorderX;
      targetCornerY = 799-closestBorderY;
      targetRotation = (Math.PI/180)*(Math.atan2(targetCornerY - myCenterY, targetCornerX - myCenterX));
      targetRotation = ((targetRotation % 360) + 540)%360 - 180;
      
      println(targetRotation);
      println(targetCornerX);
      println(targetCornerY);
    }
  }
  
  public void betterMove ()   //move the floater in the current direction of travel
  {      
    //change the x and y coordinates by myXspeed and myYspeed       
    myCenterX += myXspeed;
    myCenterY += myYspeed;     

    //wrap around screen
    if (hyperStage == -1) {
      if(myCenterX >width)
      {     
        myCenterX = 0;    
      }    
      else if (myCenterX<0)
      {     
        myCenterX = width;    
      }    
      if(myCenterY >height)
      {    
        myCenterY = 0;    
      } 
      
      else if (myCenterY < 0)
      {     
        myCenterY = height;    
      } 
    }
  }
  
  public void drawHyperTail() {
    float speed = (float)Math.hypot(myXspeed, myYspeed);
  
    if (hasTailPosition &&
        ((lastTailStage == 1 && hyperStage == 2) ||
         Math.abs(myCenterX - lastTailX) > width / 2.0 ||
         Math.abs(myCenterY - lastTailY) > height / 2.0)) {
      tailHistory.clear();
    }
  
    lastTailX = myCenterX;
    lastTailY = myCenterY;
    lastTailStage = hyperStage;
    hasTailPosition = true;
  
    if (speed < 0.01f) {
      tailHistory.clear();
      return;
    }
  
    tailHistory.add(0, new PVector[] { wingPosition(0), wingPosition(6) });
  
    if (tailHistory.size() > 25) {
      tailHistory.remove(tailHistory.size() - 1);
    }
  
    float intensity = Math.min(1.0f, speed / 10.0f);
  
    pushStyle();
    strokeCap(ROUND);
  
    for (int i = tailHistory.size() - 2; i >= 0; i--) {
      float fade = 1.0f - (float)i / (tailHistory.size() - 1);
      stroke(180, 180, 180, 180 * intensity * fade);
      strokeWeight(10 * fade);
  
      PVector[] current = tailHistory.get(i);
      PVector[] previous = tailHistory.get(i + 1);
  
      for (int wing = 0; wing < 2; wing++) {
        line(current[wing].x, current[wing].y,
             previous[wing].x, previous[wing].y);
      }
    }
  
    popStyle();
  }
  
  private PVector wingPosition(int corner) {
    double angle = myPointDirection*(Math.PI/180);
    double cos = Math.cos(angle);
    double sin = Math.sin(angle);
  
    return new PVector(
      (float)(myCenterX + xCorners[corner] * cos - yCorners[corner] * sin),
      (float)(myCenterY + xCorners[corner] * sin + yCorners[corner] * cos)
    );
  }
  
  public void hyperspace() {
    
    if (hyperStage == 0) {
      myXspeed = 0;
      myYspeed = 0;
      
      xStretch += (1.5-xStretch)*0.1;
      yStretch += (0.75-yStretch)*0.1;
      
      for (int i = 0; i < corners; i++) {
        xCorners[i] = (int)(Math.round(originalX[i] * xStretch));
        yCorners[i] = (int)(Math.round(originalY[i] * yStretch));
      }
      
      double diff = targetRotation - myPointDirection;
      diff = ((diff % 360) + 540) % 360 - 180;
      
      boolean aligned = Math.abs(diff) < 0.1;
      
      if (aligned) {
        myPointDirection = targetRotation;
      } else {
        myPointDirection += diff * 0.13;
      }
      
      if (xStretch >= 1.48 && yStretch <= 0.77 && Math.abs(targetRotation - myPointDirection)< 1) {
        myPointDirection = targetRotation;
        xStretch = 1.5;
        hyperStage = 1;
      }
    }
    
    if (hyperStage == 1) {
      
      accelerate(1.5);
      
      
      if ((myCenterX <= -40 || myCenterX >= 840) && (myCenterY <= -40 || myCenterY >= 840)) {
        myCenterX = closestBorderX==0 ? -40 : 840;
        myCenterY = closestBorderY==0 ? -40 : 840;
        
        myXspeed = 0;
        myYspeed = 0;
        
        myPointDirection = (Math.PI/180)*(Math.atan2(targetY - myCenterY, targetX - myCenterX));
        
        double dx = targetX - myCenterX;
        double dy = targetY - myCenterY;
        double distance = Math.hypot(dx, dy);
        
        hyperHalfFrames = Math.max(1, (int)Math.ceil(Math.max(Math.sqrt(distance/0.3),distance/10.0)));
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
      
      if (hyperCounter >= 2 * hyperHalfFrames) {
        myCenterX = targetX;
        myCenterY = targetY;
        hyperStage = -1;
        myXspeed = 0;
        myYspeed = 0;
      }
      
      if (hyperCounter >= hyperHalfFrames) {
        xStretch += (1.0-xStretch)*0.06;
        yStretch += (1.0-yStretch)*0.06;
        
        for (int i = 0; i < corners; i++) {
          xCorners[i] = (int)(Math.round(originalX[i] * xStretch));
          yCorners[i] = (int)(Math.round(originalY[i] * yStretch));
        }
      }
    }
  }
}
