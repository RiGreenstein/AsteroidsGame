//your variable declarations here

Spaceship bobby;
boolean leftPressed = false;
boolean rightPressed = false;
boolean upPressed = false;

double turnSpeed = 3;

public void setup() 
{
  size(800,800);
  bobby = new Spaceship(color(255), 400, 400, 0, 5);
}
public void draw() 
{
  background(0);
  if (leftPressed) {
    bobby.turn(turnSpeed);
  }
  
  if (rightPressed) {
    bobby.turn(-turnSpeed);
  }
  
  if (upPressed) {
    bobby.move();
  }
  
  bobby.show();
}

public void keyPressed() {
  if (keyCode == LEFT || keyCode == 'A') {
    leftPressed = true;
    rightPressed = false;
  } else if (keyCode == RIGHT || keyCode == 'D') {
    leftPressed = false;
    rightPressed = true;
  } else if (keyCode == UP || keyCode == 'W') {
    upPressed = true;
  }
}

public void keyReleased() {
  if (keyCode == LEFT) {
    leftPressed = false;
  } else if (keyCode == RIGHT) {
    rightPressed = false;
  } else if (keyCode == UP || keyCode == 'W') {
    upPressed = false;
  }
}
