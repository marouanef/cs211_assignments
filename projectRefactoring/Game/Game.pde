Ball ball;
Cylinder cylinder;
Mode mode;
Basis basis;
ShapePainter paint;
Utils utils;

final int sketchWidth = 1980;
final int sketchHeight = 1000;

color ballColor = color(187, 120, 70);
color plateColor = color(122, 187, 180);
color cylinderColor = color(122, 220, 180);

//Plate definition

final int   plateWidth      = 10;
final int   plateDimensions = 500;

//Plate movement speed

float       speedValue           = 1;
final float speedValueLowerLimit = 0.2;
final float speedValueUpperLimit = 1.6;

//Plate tilting angle

float       angleX = 0;
float       angleZ = 0;
final float limitAngle  = PI/3;
final float drawingX    = -PI/2;
final float drawingZ    = 0;

//Ball


final int   ballRadius        = 24;
final float gravityConstant   = 0.05;
final float frictionMagnitude = 0.01;

//Cylinders


final int                 cylinderBaseSize   = 20; 
final int                 cylinderHeight     = 50; 
final int                 cylinderResolution = 40;
ArrayList<PVector>        cylinders          = new ArrayList<PVector>();
HashMap<Integer, Integer> cylindersPos       = new HashMap<Integer, Integer>();

void settings() 
{
  size(sketchWidth, sketchHeight, P3D);
}

void setup () 
{
  noStroke();
  ball = new Ball();
  cylinder = new Cylinder();
  mode = new Mode();
  basis = new Basis();
  paint = new ShapePainter();
  utils = new Utils();
}

void draw() 
{
  utils.setSketch();
  utils.setSpeed();
  utils.setAngleValues();
  
  pushMatrix();
  basis.centered();
  if(mode.inDrawingMode()) {
    basis.tilted(drawingX, 0, drawingZ);
  } else {
    basis.tilted(-angleX, 0, angleZ);
  }
  
  pushMatrix();
  basis.fromCenteredToPlate();
  paint.cylinders();
  basis.setToCentered();
  popMatrix();
  
  pushMatrix();
  basis.fromCenteredToBall();
  if(!mode.inDrawingMode()) {
    ball.update();
    ball.checkEdges();
    ball.checkCylinderCollision(cylinders);
    ball.display();
  }
  basis.setToCentered();
  popMatrix();
  
  paint.plate();
  basis.reset();
  popMatrix();
  
}

void mouseDragged() {
  if (!mode.inDrawingMode()) {
    angleX += map(mouseY - pmouseY, -height / 2, height / 2, -PI, PI) * speedValue;
    angleZ += map(mouseX - pmouseX, -width / 2, width / 2, -PI, PI) * speedValue;
  }
}

void mousePressed() {
  if (mode.inDrawingMode() && utils.checkIfMouseIsInThePlate()) {
    utils.addCylinder();
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  speedValue = speedValue + (0.1 * e);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      mode.switchMode();
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      mode.switchMode();
    }
  }
}