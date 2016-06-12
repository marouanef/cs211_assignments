//--------------------------------------------------------------------------------
//-------------------------------IMPORTS------------------------------------------
//--------------------------------------------------------------------------------

import java.util.Map;
import java.util.LinkedList;

//--------------------------------------------------------------------------------
//-------------------------------OBJECTS------------------------------------------
//--------------------------------------------------------------------------------

Ball       ball;
Cylinder   cylinder;
Mode       mode;
Basis      basis;
Painter    draw;
Data       data;
Score      score;
HScrollbar bar;

//--------------------------------------------------------------------------------
//-------------------------------DIMENSIONS---------------------------------------
//--------------------------------------------------------------------------------

final int sketchWidth           = 1920;
final int sketchHeight          = 1060;
final int backgroundHeight      = 170;
final int scoreBoardItemsHeight = 150;
final int topViewDimensions     = 150;
final int gameScoreWidth        = 200;
final int scoreChartWidth       = 1530;
final int mouseXOffset          = 380;
final int mouseYOffset          = 900;

//--------------------------------------------------------------------------------
//------------------------OBJECTS-COLOR-DEFINITION--------------------------------
//--------------------------------------------------------------------------------

final color ambientLightColor     = color(110);
final color directionalLightColor = color(255);
final color ballColor             = color(70, 120, 190);
final color plateColor            = color(100);
final color cylinderColor         = color(0, 0, 100);
final color backgroundColor       = color(204, 255, 229);
final color topViewCylinderColor  = color(128, 255, 0);
final color topViewPlateColor     = color(0, 0, 180);
final color topViewBallColor      = color(255, 0, 0);

//--------------------------------------------------------------------------------
//--------------------------PLATE-CHARACTERISTICS---------------------------------
//--------------------------------------------------------------------------------

final int   plateWidth      = 10;
final int   plateDimensions = 500;

//--------------------------------------------------------------------------------
//------------------------PLATE-TILTING-SPEED-DEFINITION--------------------------
//--------------------------------------------------------------------------------

float       speedValue           = 1;
final float speedValueLowerLimit = 0.2;
final float speedValueUpperLimit = 1.6;

//--------------------------------------------------------------------------------
//-------------------------TILTING-ANGLE-DEFINITION-------------------------------
//--------------------------------------------------------------------------------

float       angleX      = 0;
float       angleZ      = 0;
final float limitAngle  = PI/3;
final float drawingX    = -PI/2;
final float drawingZ    = 0;

//--------------------------------------------------------------------------------
//-----------------------BALL-CHARACTERISTICS-AND-PHYSICS-------------------------
//--------------------------------------------------------------------------------

final int   ballRadius        = 24;
final float gravityConstant   = 0.05;
final float frictionMagnitude = 0.01;

//--------------------------------------------------------------------------------
//---------------------------CYLINDERS-CHARACTERISTICS----------------------------
//--------------------------------------------------------------------------------

final int cylinderBaseSize   = 20; 
final int cylinderHeight     = 50; 
final int cylinderResolution = 40;

//--------------------------------------------------------------------------------
//------------------------------------TEXT----------------------------------------
//--------------------------------------------------------------------------------

final String totalS     = "Total Score : ";
final String velocityS  = "Velocity : ";
final String lastScoreS = "Last Score : ";

//--------------------------------------------------------------------------------
//-------------------------------SKETCH-SETTINGS----------------------------------
//--------------------------------------------------------------------------------

void settings() 
{
  size(sketchWidth, sketchHeight, P3D);
}

//--------------------------------------------------------------------------------
//--------------------SKETCH-SETUP-AND-OBJECTS-INITIALISATION---------------------
//--------------------------------------------------------------------------------

void setup () 
{
  noStroke();
  ball     = new Ball();
  cylinder = new Cylinder();
  mode     = new Mode();
  basis    = new Basis();
  draw     = new Painter();
  data     = new Data();
  score    = new Score();
  bar      = new HScrollbar(width - scoreChartWidth - 10  , height - 30, 500, 20);
}

//--------------------------------------------------------------------------------
//-----------------------------------DRAWING--------------------------------------
//--------------------------------------------------------------------------------

void draw() 
{
  draw.setter.setSketch();
  draw.scoreBoard();
  draw.setter.setSpeed();
  draw.setter.setAngleValues();
  draw.game();
}

//--------------------------------------------------------------------------------
//---------------------------USER-INTERACTION-METHODS-----------------------------
//--------------------------------------------------------------------------------

void mouseDragged() {
  if (!mode.inDrawingMode()) {
    angleX += map(mouseY - pmouseY, -height / 2, height / 2, -PI, PI) * speedValue;
    angleZ += map(mouseX - pmouseX, -width / 2, width / 2, -PI, PI) * speedValue;
  }
}

void mousePressed() {
  if (mode.inDrawingMode() && draw.utils.checkIfMouseIsInThePlate()) {
    draw.utils.addCylinder();
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