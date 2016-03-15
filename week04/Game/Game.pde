Mover mover;

void settings() {
  size(1920, 1000, P3D);
}

void setup() {
  noStroke();
  mover = new Mover();
}

float angleValueX = 0;
float angleValueY = 0;
float speedValue = 1;

void draw() {
  camera();
  directionalLight(50, 100, 125, 1, 1, 0);
  ambientLight(102, 102, 102);
  background(255);
  pushMatrix();
  translate(width/2, height/2, 0);
  if(speedValue <= 0.2){
    speedValue = 0.2;
  } else if(speedValue >= 1.6){
    speedValue = 1.6;
  }
  float limitAngle = (PI/3) /  speedValue;
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
  
  rotateX(-angleValueY * speedValue);
  rotateZ(angleValueX * speedValue);
  box (500, 10, 500);
  popMatrix();
  mover.update(angleValueY * speedValue, angleValueX * speedValue);
  mover.checkEdges();
  mover.display();
}

void mouseDragged() {
   angleValueX += map(mouseX - pmouseX, -width/2, width/2, -PI, PI);
   angleValueY += map(mouseY - pmouseY, -height/2, height/2, -PI, PI);
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  speedValue = speedValue + (0.1 * e);
  println(speedValue);
}