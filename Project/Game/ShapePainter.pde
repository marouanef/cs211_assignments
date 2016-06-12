class ShapePainter {

  ShapePainter() 
  {
  }

  void thisOne(Shape shape) {
    switch (shape) {
    case BALL      : 
      ball();
      break;

    case PLATE     : 
      plate();
      break;

    case CYLINDERS : 
      cylinders();
      break;
    }
  }

  private void ball()
  {
    fill(ballColor);
    sphere(ballRadius);
  }

  private void plate() 
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

  private void cylinders() 
  {
    cylinder.shape.setFill(cylinderColor);
    for (int i = 0; i < data.cylinders.size(); i++) {
      PVector vector = data.cylinders.get(i);
      pushMatrix();
      basis.translated(vector);
      shape(cylinder.shape);
      popMatrix();
    }
  }
}

enum Shape {
  BALL, PLATE, CYLINDERS;
}