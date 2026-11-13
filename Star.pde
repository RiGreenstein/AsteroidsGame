class Star //note that this class does NOT extend Floater
{
  float myX, myY, h;
  int myColor;
  
  Star(float x, float y) {
    myX = x;
    myY = y;
    h = 2;
    myColor = color(255);
  }
  
  public void show(float stretchX, float stretchY) {
    if (Math.abs(stretchX) < 0.5f && Math.abs(stretchY) < 0.5f) {
      noStroke();
      fill(myColor);
      ellipse(myX, myY, 2, h);
    } else {
      stroke(myColor);
      strokeWeight(2);
      strokeCap(ROUND);
      line(myX, myY, myX - stretchX, myY - stretchY);
    }
  }
}
