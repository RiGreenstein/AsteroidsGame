class Asteroid extends Floater {
  protected double radius, rotationSpeed;

  Asteroid(double x, double y) {
    radius = Math.random()*20+15;

    corners = (int)(Math.random()*10+10);
    xCorners = new int[corners];
    yCorners = new int[corners];

    xCorners[0] = (int)radius;
    yCorners[0] = 0;

    for (int i = 1; i < corners; i++) {
      double angle = i*2*Math.PI/corners;
      double r = radius* (Math.random()*0.4 + 0.8);

      xCorners[i] = (int)(Math.cos(angle)*r);
      yCorners[i] = (int)(Math.sin(angle)*r);
      //xCorners[i] = (int)(Math.cos(angle)*radius+xCorners[i-1]*Math.random()*0.1);

      //yCorners[i] = (int)(Math.sin(angle)*radius+yCorners[i-1]*Math.random()*0.1);
    }

    myColor = color(20);

    myCenterX = x;
    myCenterY = y;

    myXspeed = Math.random()*2-1;
    myYspeed = Math.random()*2-1;

    myPointDirection = Math.random()*360;
    rotationSpeed = Math.random()*4-2;
  }
  
  public double getCenterX() {
    return myCenterX;
  }
  
  public double getCenterY() {
    return myCenterY;
  }

  public void show ()  //Draws the floater at the current positis ion
  {
    fill(myColor);
    stroke(color(180), 140);
    strokeWeight(5);


    //translate the (x,y) center of the ship to the correct position
    translate((float)myCenterX, (float)myCenterY);

    //convert degrees to radians for rotate()
    float dRadians = (float)(myPointDirection*(Math.PI/180));

    //rotate so that the polygon will be drawn in the correct direction
    rotate(dRadians);

    //draw the polygon
    beginShape();
    for (int nI = 0; nI < corners; nI++)
    {
      vertex(xCorners[nI], yCorners[nI]);
    }
    endShape(CLOSE);

    //"unrotate" and "untranslate" in reverse order
    rotate(-1*dRadians);
    translate(-1*(float)myCenterX, -1*(float)myCenterY);
  }
  
  public void move ()   //move the floater in the current direction of travel
  {      
    //change the x and y coordinates by myXspeed and myYspeed       
    myCenterX += myXspeed;
    myCenterY += myYspeed;
    myPointDirection += rotationSpeed;

    //wrap around screen
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
