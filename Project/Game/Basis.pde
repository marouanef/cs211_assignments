class Basis {
  BasisType type;

  Basis() 
  {
    type = BasisType.TOPLEFTCORNER;
  }

  void translated(PVector vector)
  {
    translate(vector.x, vector.y, vector.z);
    type = BasisType.OTHER;
  }

  void tilted(float angleX, float angleY, float angleZ) {
    rotateX(angleX);
    rotateY(angleY);
    rotateZ(angleZ);
    if (type == BasisType.CENTERED) {
      type = BasisType.BOTH;
    } else {
      type = BasisType.TILTED;
    }
  }

  void centered() 
  {
    if (type == BasisType.TOPLEFTCORNER) {
      translate(width / 2, height / 2, 0);
      type = BasisType.CENTERED;
    } else {
      println("ERROR : basis already altered");
      println("    Type : " + type);
    }
  }

  void fromCenteredToPlate()
  {
    if (type == BasisType.CENTERED || type == BasisType.BOTH) {
      translate(0, -plateWidth / 2, 0);
      type = BasisType.PLATE;
    } else {
      println("ERROR : basis not centered");
      println("    Type : " + type);
    }
  }

  void fromCenteredToBall()
  {
    if (type == BasisType.CENTERED || type == BasisType.BOTH) {
      translate(0, (-plateWidth / 2) - ballRadius, 0);
      type = BasisType.BALL;
    } else {
      println("ERROR : basis not centered");
      println("    Type : " + type);
    }
  }

  void setToCentered() {
    type = BasisType.CENTERED;
  }

  void reset() 
  {
    type = BasisType.TOPLEFTCORNER;
  }
}

enum BasisType {
  TOPLEFTCORNER("Top left corner"), 
    CENTERED("Centered"), 
    TILTED("Tilted"), 
    BOTH("Centered and tilted"), 
    PLATE("On the top center of the plate"), 
    BALL("In the center of the ball"), 
    OTHER("Other");

  private String name;
  BasisType(String name) {
    this.name = name;
  }

  public String toString() {
    return name;
  }
}