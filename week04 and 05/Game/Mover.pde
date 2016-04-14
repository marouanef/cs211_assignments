class Mover {

  //Position field definition
  
  private final PVector location;
  private final PVector velocity;
  
  //Force field definition
  
  private final PVector gravity;
  private final PVector friction;
  
  //Constants
  
  private final float gravityConstant;
  private final float frictionMagnitude;
  private final int   ballRadius;
  private final int   plateDimensions;
  private final int   collisionDistance;
    
  //Constructor
  
  Mover(float gravityConstant, float frictionMagnitude, int ballRadius, int plateDimensions, int cylinderBaseSize) {
    location = new PVector(0, 0, 0);
    velocity = new PVector(0, 0, 0);
    
    gravity = new PVector(0, 0, 0);
    this.gravityConstant = gravityConstant;
    
    friction = new PVector(0, 0, 0);
    this.frictionMagnitude = frictionMagnitude;
    
    this.ballRadius = ballRadius;
    this.plateDimensions = plateDimensions;
    collisionDistance = cylinderBaseSize + ballRadius;
  }
  
  //Changes gravity force and friction then updates velocity and location
  
  void update(float rotationX, float rotationZ) {
    gravity.x = sin(rotationZ) * gravityConstant;
    gravity.z = sin(rotationX) * gravityConstant;   
    
    friction.x = velocity.x;
    friction.y = velocity.y;
    friction.z = velocity.z;
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);

    velocity.add(gravity);
    velocity.add(friction);
    location.add(velocity);
    
  }
  
  //Checks if there is a collision with the edges of the plate
  
  void checkEdges() {
     if (location.x > plateDimensions / 2) {
      velocity.x = -abs(velocity.x);
      location.x = plateDimensions / 2;
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
  
  //Checks if there is a collision with a cylinder  
  
  void checkCylinderCollision(ArrayList<PVector> cylinders) {
    for(PVector cylinder : cylinders) {
      float distance = sqrt(((location.x - cylinder.x) * (location.x - cylinder.x)) + ((location.z - cylinder.z) * (location.z - cylinder.z)));
      if(distance <= collisionDistance) {
        PVector normalVector = PVector.sub(location, cylinder);
        normalVector.normalize();
        normalVector.mult(PVector.dot(velocity, normalVector) * 2);
        velocity.sub(normalVector);
      }
    }
  }
  
  //Displays the ball
  
  void display() {
    fill(122, 187, 180);
    translate(location.x, location.y, location.z);
    sphere(ballRadius);
  } //<>//
}