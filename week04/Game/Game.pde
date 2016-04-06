Mover mover;
Cylinder cylinder;

void settings() {
  size(1920, 1000, P3D);
}

void setup() {
  noStroke();
  mover = new Mover(0.1, 0.01, 1, 24, 10, 500);
  cylinder = new Cylinder();
}

float angleValueX = 0;
float angleValueY = 0;
float pauseX = 0;
float pauseY = -PI/2;
boolean pause = false;
float speedValue = 1;
ArrayList<PVector> cylinders = new ArrayList<PVector>();


void draw() {

  //____SETTINGS____

  camera();
  if(pause) {
    directionalLight(50, 100, 125, 0, 0, -1);
  } else {
    directionalLight(50, 100, 125, 1, 1, 0);
  }
  ambientLight(102, 102, 102);
  background(255);

  //____PLATE DRAWING____

  //Speed value limit definition
  if (speedValue <= 0.2) {
    speedValue = 0.2;
  } else if (speedValue >= 1.6) {
    speedValue = 1.6;
  } 

  //Angle limit definition
  float limitAngle = (PI/3);
  if (angleValueX < -limitAngle) {
    angleValueX = -limitAngle;
  } else if (angleValueX > limitAngle) {
    angleValueX = limitAngle;
  } 
  if (angleValueY < -limitAngle) {
    angleValueY = -limitAngle;
  } else if (angleValueY > limitAngle) {
    angleValueY = limitAngle;
  } 

  //Rotation and drawing
  pushMatrix();
  translate(width/2, height/2, 0);
  if (pause) {
    rotateX(pauseY);
    rotateZ(pauseX);
  } else {
    rotateX(-angleValueY);
    rotateZ(angleValueX);
  }
  box (500, 10, 500);
  
  for (int i = 0; i < cylinders.size(); i++) {
    PVector vec = cylinders.get(i);
    pushMatrix();
    translate(vec.x, 0, vec.z);
    shape(cylinder.shape);
    popMatrix();
  } 
  
  pushMatrix();
  
  if (!pause) {
    translate(0, -29, 0);
    mover.update(angleValueY, angleValueX);
    mover.checkEdges();
    mover.display();
  }

  popMatrix();
  popMatrix();
}

boolean checkMousePosition() {
  if(mouseX > width/2 + 230 || mouseX < width/2 - 230) {
     return false; 
  } else {
    if(mouseY > height/2 + 230 || mouseX < height/2 - 230) {
        return false;
    } else {
        return true; 
    }
  }
}

void addCylinder() {
  cylinders.add(new PVector(-(width/2-mouseX), 0, -(height/2-mouseY)));
}

void mouseDragged() {
  angleValueX += map(mouseX - pmouseX, -width/2, width/2, -PI, PI) * speedValue;
  angleValueY += map(mouseY - pmouseY, -height/2, height/2, -PI, PI) * speedValue;
}

void mousePressed() {
  if (pause && checkMousePosition()) {
    addCylinder();
  } 
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  speedValue = speedValue + (0.1 * e);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      pause = true;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      pause = false;
    }
  }
}