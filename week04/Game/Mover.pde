class Mover {

  //Position field definition
  
  PVector location;
  PVector velocity;
  PVector pVelocity;
  PVector acceleration;
  
  //Force field definition
  
  PVector gravity;
  PVector friction;
  
  //Constants
  
  float gravityConstant;
  float frictionMagnitude;
  int ballRadius;
  int plateWidth;
  int plateDimensions;
    
  //Constructor definition
  
  Mover(float gravityConstant, float frictionConstant, float normalForce, int ballRadius, int plateWidth, int plateDimensions) {
    location = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0);
    pVelocity = new PVector(0, 0, 0);
    acceleration = new PVector(0, 0, 0);
    
    gravity = new PVector(0, 0, 0);
    friction = new PVector(0, 0, 0);
    this.gravityConstant = gravityConstant;
    
    frictionMagnitude = frictionConstant * normalForce;
    
    this.ballRadius = ballRadius;
    this.plateWidth = plateWidth;
    this.plateDimensions = plateDimensions;
  }

  void update(float rotationX, float rotationZ) {
    friction = velocity.get();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
    gravity.x = sin(rotationZ) * gravityConstant;
    gravity.z = sin(rotationX) * gravityConstant;   
    velocity.add(gravity);
    velocity.add(friction);
    location.add(velocity);
    
  }

  void checkEdges() {
     if (location.x > plateDimensions / 2) {
      velocity.x = -abs(velocity.x);
      location.x= plateDimensions / 2;
    } else if (location.x < -plateDimensions / 2) {
      velocity.x = abs(velocity.x);
      location.x = - plateDimensions / 2;
    }
    if (location.z > plateDimensions / 2) {
      velocity.z = -abs(velocity.z);
      location.z= plateDimensions / 2;
    } else if (location.z < -plateDimensions / 2) {
      velocity.z = abs(velocity.z);
      location.z= - plateDimensions / 2;
    }
  }
  void display() {
    fill(122, 187, 180);
    translate(location.x, location.y, location.z);
    sphere(ballRadius);
  }
   //<>//
}