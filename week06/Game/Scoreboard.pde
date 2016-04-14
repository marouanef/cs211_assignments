class Scoreboard {
  
  PGraphics scoreBackground;
  PGraphics topView;
  
  int backgroundWidth;
  int backgroundHeight;
  int topViewWidth;
  int topViewHeight;
  
  Scoreboard(int backgroundWidth, int backgroundHeight, int topViewWidth, int topViewHeight) {
    scoreBackground = createGraphics(backgroundWidth, backgroundHeight);
  }
}