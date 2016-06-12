class Data {
  ArrayList<PVector>        cylinders          = new ArrayList<PVector>();

  Data() {
    cylinders          = new ArrayList<PVector>();
  }

  Position getBallTopViewPosition() {
    Position position = new Position();
    pushMatrix();
    basis.centered();
    basis.tilted(drawingX, 0, drawingZ);
    position.setKey(floor(map(ball.location.x, -plateDimensions / 2, plateDimensions / 2, -topViewDimensions / 2, topViewDimensions / 2)));
    position.setValue(floor(map(ball.location.z, -plateDimensions / 2, plateDimensions / 2, -topViewDimensions / 2, topViewDimensions / 2)));
    basis.reset();
    popMatrix();
    return position;
  }

  Map<Integer, Integer> getCylindersTopViewPosition() {
    Map<Integer, Integer> cylinderPositions = new HashMap<Integer, Integer>();
    Position position = new Position();

    pushMatrix();
    basis.centered();
    basis.tilted(drawingX, 0, drawingZ);
    for (PVector cylinder : cylinders) {
      position.setKey(floor(map(cylinder.x, -plateDimensions / 2, plateDimensions / 2, -topViewDimensions / 2, topViewDimensions / 2)));
      position.setValue(floor(map(cylinder.z, -plateDimensions / 2, plateDimensions / 2, -topViewDimensions / 2, topViewDimensions / 2)));
      cylinderPositions.put(position.getKey(), position.getValue());
    }
    basis.reset();
    popMatrix();
    return cylinderPositions;
  }
}

class Position implements Map.Entry<Integer, Integer> {
  private int x;
  private int y;

  Position () {
    x = 0;
    y = 0;
  }

  public Integer getKey() {
    return x;
  }

  public Integer getValue() {
    return y;
  }

  Integer setKey(Integer x) {
    final Integer oldValue = this.x;
    this.x = x;
    return oldValue;
  }


  public Integer setValue(Integer y) {
    final Integer oldValue = this.y;
    this.y = y;
    return oldValue;
  }
}