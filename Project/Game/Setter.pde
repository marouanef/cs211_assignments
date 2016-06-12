class Setter {
  Setter() {
  }

  void setSketch() {
    camera();
    ambientLight(red(ambientLightColor), green(ambientLightColor), blue(ambientLightColor));
    background(255);
    directionalLight(red(directionalLightColor), green(directionalLightColor), blue(directionalLightColor), 1, 1, -1);
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
}