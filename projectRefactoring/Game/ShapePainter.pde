class ShapePainter {

  ShapePainter() 
  {
  }

  void ball()
  {
    fill(ballColor);
    sphere(ballRadius);
  }

  void plate() 
  {
    if (!mode.inDrawingMode()) {
      int transparency;
      if (angleX < 0) {
        transparency = floor(map(angleX, 0, -PI/3, 0, 255));
      } else {
        transparency = 0;
      }
      fill(plateColor, 255 - floor(transparency * 0.8));
    } else {
      fill(plateColor);
    }
    box(plateDimensions, plateWidth, plateDimensions);
  }

  void cylinders() 
  {
    cylinder.shape.setFill(cylinderColor);
    for (int i = 0; i < cylinders.size(); i++) {
      PVector vector = cylinders.get(i);
      pushMatrix();
      basis.translated(vector);
      shape(cylinder.shape);
      popMatrix();
    }
  }
}