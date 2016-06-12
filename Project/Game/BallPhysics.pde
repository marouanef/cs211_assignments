class BallPhysics {

  PVector gravity;
  PVector friction;
  PVector velocity;

  BallPhysics (PVector gravity, PVector friction, PVector velocity) 
  {
    this.gravity  = gravity;
    this.friction = friction;
    this.velocity = velocity;
  }

  void update() 
  {
    updateGravity(angleX, angleZ);
    updateFriction();
    velocity.add(gravity);
    velocity.add(friction);
  }

  void bounceOffXEdges(int direction)
  {
    score.subThis(velocity);
    velocity.x = direction * abs(velocity.x);
  }

  void bounceOffZEdges(int direction) 
  {
    score.subThis(velocity);
    velocity.z = direction * abs(velocity.z);
  }

  void bounceOffCylinderSurface(PVector normalVector) 
  {
    score.addThis(velocity);
    normalVector.mult(PVector.dot(velocity, normalVector) * 2);
    velocity.sub(normalVector);
  }

  private void updateGravity(float rotationX, float rotationZ)
  {
    gravity.x = sin(rotationZ) * gravityConstant;
    gravity.z = sin(rotationX) * gravityConstant;
  }

  private void updateFriction()
  {
    friction.x = velocity.x;
    friction.y = velocity.y;
    friction.z = velocity.z;
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
  }
}