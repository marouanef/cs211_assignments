class Utils {

  Utils() {
  }

  void setSketch() {
    camera();
    ambientLight(110, 110, 110);
    background(255);
    directionalLight(200, 200, 200, 1, 1, -1);
  }

  void setSpeed() {
    if (speedValue <= speedValueLowerLimit) {
      speedValue = speedValueLowerLimit;
    } else if (speedValue >= speedValueUpperLimit) {
      speedValue = speedValueUpperLimit;
    }
  }

  void setAngleValues() {
    if (angleZ < -limitAngle) {
      angleZ = -limitAngle;
    } else if (angleZ > limitAngle) {
      angleZ = limitAngle;
    } 
    if (angleX < -limitAngle) {
      angleX = -limitAngle;
    } else if (angleX > limitAngle) {
      angleX = limitAngle;
    }
  }
  
  

  boolean checkIfMouseIsInThePlate() {
    if ((mouseX - (width / 2) >= ((plateDimensions / 2) - cylinderBaseSize)) || mouseX - (width / 2) <= -((plateDimensions / 2) - cylinderBaseSize)) {
      return false;
    } else {
      return ((mouseY - (height / 2) <= ((plateDimensions / 2) - cylinderBaseSize)) && mouseY - (height / 2) >= -((plateDimensions / 2) - cylinderBaseSize));
    }
  }

  void addCylinder() {  
    cylinders.add(new PVector( -(width / 2 - mouseX), 0, -(height / 2 - mouseY)));
  }
}