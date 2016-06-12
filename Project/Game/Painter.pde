class Painter {
  Setter       setter;
  ShapePainter shapes;
  Utils        utils;

  PGraphics background;
  PGraphics topView;
  PGraphics gameScore;
  PGraphics scoreChart;

  Painter() {
    setter = new Setter();
    shapes = new ShapePainter();
    utils  = new Utils();

    background = createGraphics(sketchWidth, backgroundHeight, P2D);
    topView = createGraphics(topViewDimensions, scoreBoardItemsHeight, P2D);
    gameScore = createGraphics(gameScoreWidth, scoreBoardItemsHeight, P2D);
    scoreChart = createGraphics(scoreChartWidth, scoreBoardItemsHeight, P2D);
  }

  void game() {
    pushMatrix();
    basis.centered();
    if (mode.inDrawingMode()) {
      basis.tilted(drawingX, 0, drawingZ);
    } else {
      basis.tilted(-angleX, 0, angleZ);
    }

    pushMatrix();
    basis.fromCenteredToPlate();
    shapes.thisOne(Shape.CYLINDERS);
    basis.setToCentered();
    popMatrix();

    pushMatrix();
    basis.fromCenteredToBall();
    if (!mode.inDrawingMode()) {
      ball.update();
      ball.checkEdges();
      ball.checkCylinderCollision(data.cylinders);
      ball.display();
    }
    basis.setToCentered();
    popMatrix();

    shapes.thisOne(Shape.PLATE);
    basis.reset();
    popMatrix();
  }

  void scoreBoard() {
    drawBackground();
    drawTopView();
    drawGameScore();
    drawScoreChart();
    bar.display();
  }

  private void drawBackground() {
    background.beginDraw();
    background.background(backgroundColor);
    background.endDraw();
    image(background, 0, sketchHeight - backgroundHeight);
  }

  private void drawTopView() {
    topView.beginDraw();
    topView.noStroke();
    topView.background(topViewPlateColor);
    topView.pushMatrix();
    topView.translate(topView.width / 2, topView.height /2);
    for (Map.Entry<Integer, Integer> position : data.getCylindersTopViewPosition().entrySet()) {
      topView.pushMatrix();
      topView.translate(position.getKey(), position.getValue());
      topView.fill(topViewCylinderColor);
      topView.ellipse(0, 0, 20, 20);
      topView.popMatrix();
    }
    topView.pushMatrix();
    topView.translate(data.getBallTopViewPosition().getKey(), data.getBallTopViewPosition().getValue());
    topView.fill(topViewBallColor);
    topView.ellipse(0, 0, 5, 5);
    topView.endDraw();
    topView.popMatrix();
    topView.popMatrix();
    image(topView, (backgroundHeight / 2) - (topViewDimensions / 2), sketchHeight - (backgroundHeight / 2) - (topViewDimensions / 2));
  }

  private void drawGameScore() {
    gameScore.beginDraw();
    background.background(backgroundColor);
    gameScore.fill(0);
    gameScore.text(totalS, 40, 20);
    gameScore.text(score.getValue(), 40, 35);
    gameScore.text(velocityS, 40, 70);
    gameScore.text(ball.physics.velocity.mag(), 40, 85);
    gameScore.text(lastScoreS, 40, 120);
    gameScore.text(score.getLast(), 40, 135);
    gameScore.endDraw();
    image(gameScore, 2 * ((backgroundHeight / 2) - (topViewDimensions / 2)) + topViewDimensions, sketchHeight - (backgroundHeight / 2) - (topViewDimensions / 2));
  }

  private void drawScoreChart() { 
    scoreChart.beginDraw();
    bar.update();
    scoreChart.background(backgroundColor);
    scoreChart.strokeWeight(1);
    scoreChart.stroke(0);
    scoreChart.line(0, 90, scoreChart.width, 90);
    
    float lowerBound, upperBound;
    if(score.getMax() < 3 * abs(score.getMin())) {
      lowerBound = score.getMin();
      upperBound = abs(score.getMin()) * 3;
    } else {
      lowerBound = - score.getMax() / 3;
      upperBound = score.getMax();
    }
    
    LinkedList<Float> scoreList = score.getList();
    for (int i = 1; i < scoreList.size(); i++) {
      float a, b;
      if (score.getMin() == score.getMax()) {
        a = 90;
        b = 90;
      } else { 
        a = map(scoreList.get(i - 1), lowerBound, upperBound, -120, 0);
        a = -a;
        b = map(scoreList.get(i), lowerBound, upperBound, -120, 0);
        b = -b;
      }
      scoreChart.strokeWeight(4);
      scoreChart.stroke(255, 0, 0);
      scoreChart.line(10 * (i - 1) * (bar.getPos() + 0.5), a, 10 * i * (bar.getPos() + 0.5), b);
    }
    scoreChart.endDraw();
    image(scoreChart, mouseXOffset, sketchHeight - (backgroundHeight / 2) - (topViewDimensions / 2));
  }
}