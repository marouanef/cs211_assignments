Mover mover;

void settings() {
  size(1920, 1000, P3D);
}

void setup() {
  noStroke();
  mover = new Mover(0.1, 0.01, 1, 24, 10, 500);
}

float angleValueX = 0;
float angleValueY = 0;
float speedValue = 1;


void draw() {
  
  //____SETTINGS____
  
  camera();
  directionalLight(50, 100, 125, 1, 1, 0);
  ambientLight(102, 102, 102);
  background(255);
  
  //____PLATE DRAWING____
  
  //Speed value limit definition
   if(speedValue <= 0.2){
    speedValue = 0.2;
  } else if(speedValue >= 1.6){
    speedValue = 1.6;
  } 
    
  //Angle limit definition
  float limitAngle = (PI/3);
  if(angleValueX < -limitAngle) {
    angleValueX = -limitAngle;
  } else if (angleValueX > limitAngle) {
    angleValueX = limitAngle;
  } 
  if(angleValueY < -limitAngle) {
    angleValueY = -limitAngle;
  } else if (angleValueY > limitAngle) {
    angleValueY = limitAngle;
  } 
    
  //Rotation and drawing
  pushMatrix();
  translate(width/2, height/2, 0);
  rotateX(-angleValueY);
  rotateZ(angleValueX);
  box (500, 10, 500);
  pushMatrix();
  translate(0, -29, 0);
  mover.update(angleValueY, angleValueX);
  mover.checkEdges();
  mover.display();
  popMatrix();
  popMatrix();

}

void mouseDragged() {
  angleValueX += map(mouseX - pmouseX, -width/2, width/2, -PI, PI) * speedValue;
  angleValueY += map(mouseY - pmouseY, -height/2, height/2, -PI, PI) * speedValue;
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  speedValue = speedValue + (0.1 * e);
}