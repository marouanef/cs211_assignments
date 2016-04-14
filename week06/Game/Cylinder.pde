class Cylinder {
  
  //Fields
  
  PShape shape            = new PShape();
  PShape openCylinder     = new PShape(); 
  PShape topOfCylinder    = new PShape();
  PShape bottomOfCylinder = new PShape();
  
  
  //Constructor
  
  Cylinder(float cylinderBaseSize, float cylinderHeight, int cylinderResolution) {
    shape = createShape(GROUP);
    
    float angle;
    float[] x = new float[cylinderResolution + 1]; 
    float[] y = new float[cylinderResolution + 1];

    for (int i = 0; i < x.length; i++) {
      angle = (TWO_PI / cylinderResolution) * i; 
      x[i] = sin(angle) * cylinderBaseSize;
      y[i] = cos(angle) * cylinderBaseSize;
    }
    
    //Open cylinder
    
    openCylinder = createShape();
    openCylinder.beginShape(QUAD_STRIP);
    for (int i = 0; i < x.length; i++) { 
      openCylinder.vertex(x[i], 0, y[i]); 
      openCylinder.vertex(x[i], -cylinderHeight, y[i]);
    }
    openCylinder.endShape();
    
    shape.addChild(openCylinder);
  
    //Top of the cylinder
    
    topOfCylinder = createShape();
    topOfCylinder.beginShape(TRIANGLE_FAN);
    topOfCylinder.vertex(0, -cylinderHeight, 0);
    for (int i = 0; i< x.length; i++) {
      topOfCylinder.vertex(x[i], -cylinderHeight, y[i]);
    }
    topOfCylinder.endShape();
    
    shape.addChild(topOfCylinder);
    
    //Bottom of the cylinder
    
    bottomOfCylinder = createShape();
    bottomOfCylinder.beginShape(TRIANGLE_FAN);
    bottomOfCylinder.vertex(0, 0, 0);
    for (int i = 0; i< x.length; i++) {
      bottomOfCylinder.vertex(x[i], 0, y[i]);
    }
    bottomOfCylinder.endShape();
    
    shape.addChild(bottomOfCylinder);
  }
}