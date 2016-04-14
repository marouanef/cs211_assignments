class Mode {
  
  ModeType type;
  
  Mode() {
    type = ModeType.GAME;
  }
  
  void switchMode() {
    if(type == ModeType.GAME) {
      type = ModeType.DRAWING;
    } else {
      type = ModeType.GAME;
    }
  }
  
  boolean inDrawingMode() {
    return type == ModeType.DRAWING;
  }
}

enum ModeType {
    GAME, DRAWING;
}