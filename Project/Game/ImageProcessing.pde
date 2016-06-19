class ImageProcessing extends PApplet { //<>// //<>//

  HoughTransform hough;
  ImageProcessor processor;
  TwoDThreeD computations;
  PVector rotations;
  boolean ready = false;

  public void settings() {
    size(1966, 600);
  }

  public void setup() {
    println("Setting up image processing...");
    processor = new ImageProcessor(img);
    hough = new HoughTransform();
    computations = new TwoDThreeD(img.width, img.height);
    noLoop(); // no interactive behaviour: draw() will be called only once.
    println("Set-up complete");
  }

  public void draw() {
    process();
    drawImages();
    updateRotations();
    ready();
  }

  void process() {
    println("Processing image...");
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
    processor.hueFilter(hueMean - 15, hueMean + 10);
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
    println("Processing complete");
  }

  void drawImages() {
    println("Drawing results...");
    println("    Drawing original image");
    image(img, 0, 0);
    hough.drawLines();
    hough.drawIntersections();
    hough.drawAccumulator();
    println("    Drawing processed image");
    image(processor.img, 800, 0);
    println("Drawing complete");
  }

  void updateRotations() {
    println("Updating rotations...");
    rotations = computations.get3DRotations(hough.intersections);
    println("Update complete");
  }

  void ready() {
    ready = true;
    println("Ready for data fetch");
  }
}