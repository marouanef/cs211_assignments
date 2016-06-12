class Ball {

  private final PVector location;

  BallPhysics           physics;

  private final int     collisionDistance;

  Ball() {
    location          = new PVector(0, 0, 0);
    physics           = new BallPhysics(new PVector(0, 0, 0), new PVector(0, 0, 0), new PVector(0, 0, 0));
    collisionDistance = cylinderBaseSize + ballRadius;
  }

  void update() {
    physics.update();
    location.add(physics.velocity);
  }

  void checkEdges() {
    if (location.x > plateDimensions / 2) {
      physics.bounceOffXEdges(-1);
      location.x = plateDimensions / 2;
    } else if (location.x < -plateDimensions / 2) {
      physics.bounceOffXEdges(1);
      location.x = - plateDimensions / 2;
    }
    if (location.z > plateDimensions / 2) {
      physics.bounceOffZEdges(-1);
      location.z= plateDimensions / 2;
    } else if (location.z < -plateDimensions / 2) {
      physics.bounceOffZEdges(1);
      location.z= - plateDimensions / 2;
    }
  }

  void checkCylinderCollision(ArrayList<PVector> cylinders) {
    for (PVector cylinder : cylinders) {
      float distance = sqrt(((location.x - cylinder.x) * (location.x - cylinder.x)) + ((location.z - cylinder.z) * (location.z - cylinder.z)));
      if (distance <= collisionDistance) {
        PVector normalVector = PVector.sub(location, cylinder);
        normalVector.normalize();
        adjust(normalVector, distance);
        physics.bounceOffCylinderSurface(normalVector);
      }
    }
  }

  void display() {
    basis.translated(location);
    draw.shapes.thisOne(Shape.BALL);
  }

  private void adjust(PVector normalVector, float distance) {
    PVector adjustingVector = new PVector(normalVector.x, normalVector.y, normalVector.z);
    location.add(adjustingVector.mult(collisionDistance - distance));
  }
}