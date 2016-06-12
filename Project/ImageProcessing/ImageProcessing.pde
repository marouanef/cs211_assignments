import java.util.Collections;
import java.util.List;
import java.util.Random;

PImage img;
HoughTransform hough;
ImageProcessor processor;

void settings() {
  size(1966, 600);
}

void setup() {
  img = loadImage("board4.jpg");
  processor = new ImageProcessor(img);
  hough = new HoughTransform();
  noLoop(); // no interactive behaviour: draw() will be called only once.
}

void draw() {
  process();
  drawImages();
}

void process() {
  int hueMean = 0;
  int counter = 0;
  float brightnessMean = -1;
  for (int i = 0; i < img.pixels.length; i++) {
    if (hue(img.pixels[i]) > 110 && hue(img.pixels[i]) < 136) {
      hueMean += hue(img.pixels[i]);
      brightnessMean += brightness(img.pixels[i]);
      counter++;
    }
  }

  hueMean /= counter;
  brightnessMean /= counter;
  processor.hueFilter(hueMean - 10, hueMean + 10);
  processor.saturationFilter(100, 255);
  //image(processor.img, 0, 0);
  processor.gauss(100.f);
  //image(processor.img, 0, 0);
  processor.brightnessFilter(10, brightnessMean + 35);
  //image(processor.img, 0, 0);
  processor.sobel();
  //image(processor.img, 0, 0);
  hough.compute(processor.img);
  hough.updateLines(4);
  hough.updateIntersections();
}

void drawImages() {
  image(img, 0, 0);
  hough.drawLines();
  image(processor.img, 800, 0);
  hough.drawAccumulator();
  hough.drawIntersections();
}