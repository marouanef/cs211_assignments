//Plate definition

final int   plateWidth      = 10;
final int   plateDimensions = 500;

//Plate movement speed

float       speedValue           = 1;
final float speedValueLowerLimit = 0.2;
final float speedValueUpperLimit = 1.6;

//Plate tilting angle

float       angleValueX = 0;
float       angleValueY = 0;
final float limitAngle  = PI/3;
final float drawingX    = 0;
final float drawingY    = -PI/2;

//Mover

Mover       mover;
final int   ballRadius        = 24;
final float gravityConstant   = 0.05;
final float frictionMagnitude = 0.01;

//Cylinders

Cylinder                  cylinder;
int                       cylinderBaseSize   = 20; 
int                       cylinderHeight     = 50; 
int                       cylinderResolution = 40;
ArrayList<PVector>        cylinders          = new ArrayList<PVector>();
HashMap<Integer, Integer> cylindersPos       = new HashMap<Integer, Integer>();

//Mode definition

enum Mode {
  DRAWING, GAME
};
Mode mode = Mode.GAME;

//Secondary surfaces definition

PGraphics scoreBackground;
PGraphics topView;

//Settings

void settings() {
  size(1920, 1000, P3D);
}

//Sketch setup

void setup() {
  noStroke();
  mover    = new Mover(gravityConstant, frictionMagnitude, ballRadius, plateDimensions, cylinderBaseSize);
  cylinder = new Cylinder(cylinderBaseSize, cylinderHeight, cylinderResolution);
  scoreBackground = createGraphics(1920, 170, P2D);
  topView = createGraphics(150, 150, P2D);
}

//Mode Setup Functions

void gameMode() {
  mode = Mode.GAME;
}

void drawingMode() {
  mode = Mode.DRAWING;
}

boolean isInDrawingMode() {
  return mode == Mode.DRAWING;
}

//Drawing function
void draw() {

  //SETTINGS :

  camera();
  ambientLight(110, 110, 110);
  background(255);

  directionalLight(200, 200, 200, 1, 1, -1);
  drawScoreboard();

  //DRAWING :

  //Speed value limit definition

  if (speedValue <= speedValueLowerLimit) {
    speedValue = speedValueLowerLimit;
  } else if (speedValue >= speedValueUpperLimit) {
    speedValue = speedValueUpperLimit;
  } 

  //Angle limit definition

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

  //Translation, rotation and drawing of the plate

  pushMatrix();
  translate(width/2, height/2, 0);
  if (isInDrawingMode()) { //Places the plate with a view from above
    rotateX(drawingY);
    rotateZ(drawingX);
  } else { //rotates the plate normally
    rotateX(-angleValueY);
    rotateZ(angleValueX);
  }

  //Cylinders drawing 

  for (int i = 0; i < cylinders.size(); i++) {
    PVector vec = cylinders.get(i);
    pushMatrix();
    translate(vec.x, -(plateWidth / 2), vec.z);
    shape(cylinder.shape);
    popMatrix();
  } 

  //Ball drawing

  pushMatrix();
  if (!isInDrawingMode()) { //Only draws the ball when in gaming mode
    translate(0, -(plateWidth / 2) - ballRadius, 0);
    mover.update(angleValueY, angleValueX);
    mover.checkEdges();
    mover.checkCylinderCollision(cylinders);
    mover.display();
  }
  popMatrix();

  //Plate drawing
  if (!isInDrawingMode()) {
    transparencyOfPlate();
  } else {
    fill(122, 187, 180);
  }
  box(plateDimensions, plateWidth, plateDimensions);

  popMatrix();
}

void drawScoreBackground() {
  scoreBackground.beginDraw();
  scoreBackground.background(255, 255, 204);
  scoreBackground.endDraw();
}

void drawTopView() {
  topView.beginDraw();
  topView.background(255);
  for(Integer positionX : cylindersPos.keySet()) {
    pushMatrix();
    translate(85, 925);
    translate(floor(map(positionX, -250, 250, -75, -75)), floor(map(cylindersPos.get(positionX), -250, 250, -75, 75)));
    fill(255, 255, 204);
    ellipse(0, 0, 20, 20);
    popMatrix();
  }
  topView.endDraw();
}

//Method that draws the scoreboard

void drawScoreboard() {
  drawScoreBackground();
  fill(255);
  image(scoreBackground, 0, 830);
  drawTopView();
  fill(255);
  image(topView, 10, 840);
}


//Method that checks if the mouse is inside the box while in drawing mode

boolean checkIfMouseIsInThePlate() {
  if ((mouseX - (width / 2) >= ((plateDimensions / 2) - cylinderBaseSize)) || mouseX - (width / 2) <= -((plateDimensions / 2) - cylinderBaseSize)) {
    return false;
  } else {
    return ((mouseY - (height / 2) <= ((plateDimensions / 2) - cylinderBaseSize)) && mouseY - (height / 2) >= -((plateDimensions / 2) - cylinderBaseSize));
  }
}

//Method that adds a cylinder to the array

void addCylinder() {  
  cylinders.add(new PVector( -(width / 2 - mouseX), 0, -(height / 2 - mouseY)));
  cylindersPos.put(-(width / 2 - mouseX), -(height / 2 - mouseY));
}

void transparencyOfPlate() {
  int transparency;
  if (angleValueY < 0) {
    transparency = floor(map(angleValueY, 0, -PI/3, 0, 255));
  } else {
    transparency = 0;
  }
  fill(122, 187, 180, 255 - floor(transparency * 0.8));
}

//User interaction methods

void mouseDragged() {
  if (!isInDrawingMode()) {
    angleValueX += map(mouseX - pmouseX, -width / 2, width / 2, -PI, PI) * speedValue;
    angleValueY += map(mouseY - pmouseY, -height / 2, height / 2, -PI, PI) * speedValue;
  }
}

void mousePressed() {
  if (isInDrawingMode() && checkIfMouseIsInThePlate()) {
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
      drawingMode();
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      gameMode();
    }
  }
}