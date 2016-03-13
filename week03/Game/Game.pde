void settings() {
  size(1920, 1000, P3D);
}

void setup() {
  noStroke();
}

float angleValueX = 0;
float angleValueY = 0;

void draw() {
  camera();
  directionalLight(50, 100, 125, 1/sqrt(3), 1/sqrt(3), 1/sqrt(3));
  ambientLight(102, 102, 102);
  background(255);
  translate(width/2, height/2, 0);
  if(angleValueX < -PI/3) {
    angleValueX = -PI/3;
  } else if (angleValueX > PI/3) {
    angleValueX = PI/3;
  } 
  
  if(angleValueY < -PI/3) {
    angleValueY = -PI/3;
  } else if (angleValueY > PI/3) {
    angleValueY = PI/3;
  } 
  
  rotateX(-angleValueY);
  rotateZ(angleValueX);
  box (500, 10, 500);
}

void mouseDragged() {
   angleValueX += map(mouseX - pmouseX, -width/2, width/2, -PI, PI);
   angleValueY += map(mouseY - pmouseY, -height/2, height/2, -PI, PI);
}