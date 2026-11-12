class Spaceship extends Floater  
{   
    Spaceship(int spaceshipColor, double xCenter, double yCenter, double direction) {
      corners = 8;
      myColor = spaceshipColor;
      myCenterX = xCenter;
      myCenterY = yCenter;
      myPointDirection = direction;
      myXspeed = 1;
      myYspeed = 0;
      
      xCorners = new int[]{-40, -20, 20, 40, 20, -20, -40, -35};
      yCorners = new int[]{-30, -15, -15, 0, 15, 15, 30, 0};
    }
}
