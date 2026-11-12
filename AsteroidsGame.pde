//your variable declarations here

Spaceship bobby;

public void setup() 
{
  size(800,800);
  bobby = new Spaceship(color(255, 0, 0), 400, 400, 0);
}
public void draw() 
{
  bobby.show();
}
