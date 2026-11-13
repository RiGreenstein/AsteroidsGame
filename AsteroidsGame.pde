//your variable declarations here

Spaceship bobby;
Star[] tungtungs = new Star[500];

boolean leftPressed = false;
boolean rightPressed = false;
boolean upPressed = false;

double turnSpeed = 5;
double deceleration = 0.93;

float shakeAmount = 0;
float maxShake = 5;
float starStretchX = 0;
float starStretchY = 0;
float maxStarStretch = 20;

public void setup() 
{
  size(800,800);
  bobby = new Spaceship(color(255), 400, 400, 0, 10);
  
  for (int i = 0; i < tungtungs.length; i++) {
    Star tralalero = new Star((float)(Math.random()*800), (float)(Math.random()*800));
    tungtungs[i] = tralalero;
  }
}
public void draw() 
{
  background(0);
  
  if (bobby.getHyperStage() == -1) {  
    if (leftPressed) {
      bobby.turn(-turnSpeed);
    }
    
    if (rightPressed) {
      bobby.turn(turnSpeed);
    }
    
    if (upPressed) {
      bobby.cappedAccelerate(0.6);
    }
    
    if (!upPressed & bobby.getXSpeed() != 0) {
      bobby.setXSpeed(bobby.getXSpeed() * deceleration);
      
      if (bobby.getXSpeed() <= 0.1 && bobby.getXSpeed() >= -0.1) {bobby.setXSpeed(0);}
    }
    
    if (!upPressed & bobby.getYSpeed() != 0) {
      bobby.setYSpeed(bobby.getYSpeed() * deceleration);
      
      if (bobby.getYSpeed() <= 0.1 && bobby.getYSpeed() >= -0.1) {bobby.setYSpeed(0);}
    }
  }
  
  bobby.hyperspace();
  bobby.betterMove();
  
  int hyperStage = bobby.getHyperStage();
  float speed = (float)Math.hypot(bobby.getXSpeed(), bobby.getYSpeed());
  
  float currentLength = (float)Math.hypot(starStretchX, starStretchY);
  float targetLength = 0;
  
  if (hyperStage == 1 || hyperStage == 2) {
    targetLength = Math.min(maxStarStretch, speed * 4);
  
    if (hyperStage == 2) {
      targetLength = Math.max(currentLength, targetLength);
    }
  }
  
  float newLength = currentLength + (targetLength - currentLength) * 0.1f;
  
  double angle = Math.atan2(starStretchY, starStretchX);
  
  if (speed > 0.001f && (hyperStage == 1 || hyperStage == 2)) {
    double targetAngle = Math.atan2(
      bobby.getYSpeed(), bobby.getXSpeed()
    );
  
    if (currentLength <= 0.001f) {
      angle = targetAngle;
    } else {
      // Take the shortest rotation, including across -180/180 degrees.
      double difference = Math.atan2(
        Math.sin(targetAngle - angle),
        Math.cos(targetAngle - angle)
      );
  
      angle += difference * 0.08;
    }
  }
  
  starStretchX = (float)(Math.cos(angle) * newLength);
  starStretchY = (float)(Math.sin(angle) * newLength);
  
  int stage = bobby.getHyperStage();
  float targetShake = 0;
  
  if (stage == 0 || stage == 1) {
    targetShake = maxShake;
  } else if (stage == 2) {
    speed = (float)Math.hypot(bobby.getXSpeed(), bobby.getYSpeed());
    targetShake = maxShake * Math.min(1.0f, speed / 10.0f);
  }
  
  shakeAmount += (targetShake - shakeAmount) * 0.05f;
  
  float shakeX = (noise(frameCount * 0.3f, 0) - 0.5f) * 2 * shakeAmount;
  float shakeY = (noise(frameCount * 0.3f, 100) - 0.5f) * 2 * shakeAmount;
  
  pushMatrix();
  translate(shakeX, shakeY);
  
  for (int i = 0; i < tungtungs.length; i++) {
    tungtungs[i].show(starStretchX, starStretchY);
  }
  
  bobby.drawHyperTail();

  pushStyle();
  strokeWeight(1);
  strokeJoin(MITER);
  bobby.show();
  popStyle();
  popMatrix();
}

public void keyPressed() {
  if (keyCode == LEFT || keyCode == 'A') {
    if (bobby.getHyperStage() == -1) {
      leftPressed = true;
      rightPressed = false;
    }
  }
  
  if (keyCode == RIGHT || keyCode == 'D') {
    if (bobby.getHyperStage() == -1) {
      leftPressed = false;
      rightPressed = true;
    }
  }
  
  if (keyCode == UP || keyCode == 'W') {
    if (bobby.getHyperStage() == -1) {
      upPressed = true;
    }
  }
  
  if (keyCode == DOWN || keyCode == 'S' ) {
    bobby.activateHyperspace();
    
    leftPressed = false;
    rightPressed = false;
    upPressed = false;
    
  }
}

public void keyReleased() {
  if (keyCode == LEFT || keyCode == 'A') {
    leftPressed = false;
  }
  
  if (keyCode == RIGHT || keyCode == 'D') {
    rightPressed = false;
  }
  
  if (keyCode == UP || keyCode == 'W') {
    upPressed = false;
  }
}
