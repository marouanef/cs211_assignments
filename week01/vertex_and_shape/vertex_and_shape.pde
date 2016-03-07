void settings() {
  size(400, 800, P2D);
}

void setup () {
  background(255, 204, 0);
  noLoop();
}

void draw() {
  translate(width/2, height/2);
  leaf();
}

void leaf() {
  beginShape();
    vertex(100.0, -70.0);
    bezierVertex(90.0, -60.0, 40.0, -100.0, 0.0, 0.0);
    bezierVertex(0.0, 0.0, 100.0, 40.0, 100.0, -70.0);
  endShape();
}