class ImageProcessor {
  PImage original;
  PImage img;

  float[][] gauss           = { { 9, 12, 9 }, 
    { 12, 15, 12 }, 
    { 9, 12, 9 }};

  ImageProcessor(PImage image) {
    original = image;
    img = image;
  }

  void hueFilter(int lowerBound, int upperBound) {
    PImage result = createImage(img.width, img.height, RGB); // create a new, initially transparent, ’result’ image
    for (int i = 0; i < img.pixels.length; i++) {
      if (hue(img.pixels[i]) > lowerBound && hue(img.pixels[i]) < upperBound) {
        result.pixels[i] = img.pixels[i];
      } else {
        result.pixels[i] = color(0);
      }
    }
    img = result;
  }

  void saturationFilter(int lowerBound, int upperBound) {
    PImage result = createImage(img.width, img.height, RGB); // create a new, initially transparent, ’result’ image
    for (int i = 0; i < img.pixels.length; i++) {
      if (saturation(img.pixels[i]) > lowerBound && saturation(img.pixels[i]) < upperBound) {
        result.pixels[i] = img.pixels[i];
      } else {
        result.pixels[i] = color(0);
      }
    }
    img = result;
  }

  void brightnessFilter(float lowerBound, float upperBound) {
    PImage result = createImage(img.width, img.height, RGB); // create a new, initially transparent, ’result’ image
    for (int i = 0; i < img.pixels.length; i++) {
      if (brightness(img.pixels[i]) < upperBound && brightness(img.pixels[i]) > lowerBound) {
        result.pixels[i] = color(255);
      } else {
        result.pixels[i] = color(0);
      }
    }
    img = result;
  }

  void convolute(float[][] kernel, float weight) {
    PImage result = createImage(img.width, img.height, ALPHA);

    for (int x = 1; x < img.width - 1; x++) {
      for (int y = 1; y < img.height - 1; y++) {
        int brightness = 0;
        for (int i = 0; i < kernel.length; i++) {
          for (int j = 0; j < kernel.length; j++) {
            int pos = ((x + i) - kernel.length/2) + ((y + j) - kernel.length/2) * img.width;
            brightness += brightness(img.pixels[pos]) * kernel[i][j];
          }
        }
        brightness /= weight;
        result.pixels[x + y * img.width] = color(brightness);
      }
    }

    img = result;
  }

  void gauss(float weight) {
    convolute(gauss, weight);
  }

  void sobel() {
    float[][] hKernel = { { 0, 1, 0 }, 
      { 0, 0, 0 }, 
      { 0, -1, 0 } };

    float[][] vKernel = { { 0, 0, 0 }, 
      { 1, 0, -1 }, 
      { 0, 0, 0 } };

    PImage result = createImage(img.width, img.height, ALPHA);
    // clear the image
    for (int i = 0; i < img.width * img.height; i++) {
      result.pixels[i] = color(0);
    }

    float max=0;
    float[] buffer = new float[img.width * img.height];


    for (int x = 1; x < img.width - 1; x++) {
      for (int y = 1; y < img.height - 1; y++) {
        int sum_h = 0;
        int sum_v = 0;
        for (int i = 0; i < 3; i++) {
          for (int j = 0; j < 3; j++) {
            int pos = ((x + i) - 1) + ((y + j) - 1) * img.width;
            sum_h += brightness(img.pixels[pos]) * hKernel[i][j];
            sum_v += brightness(img.pixels[pos]) * vKernel[i][j];
          }
        }
        float sum = sqrt((sum_h * sum_h) + (sum_v * sum_v));
        if (sum > max) {
          max = sum;
        }
        buffer[x + y * img.width] = sum;
      }
    }

    for (int y = 2; y < img.height - 2; y++) { // Skip top and bottom edges
      for (int x = 2; x < img.width - 2; x++) { // Skip left and right
        if (buffer[y * img.width + x] > (int)(max * 0.5f)) { // 30% of the max
          result.pixels[y * img.width + x] = color(255);
        } else {
          result.pixels[y * img.width + x] = color(0);
        }
      }
    }
    img = result;
  }

  void reset() {
    img = original;
  }
}