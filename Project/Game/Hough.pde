class HoughTransform {
  float discretizationStepsPhi = 0.06f;
  float discretizationStepsR = 2.5f;

  int imgWidth;
  int imgHeight;

  int[] accumulator;

  int phiDim = (int) (Math.PI / discretizationStepsPhi);
  int rDim = 0;
  float[] tabSin = new float[phiDim + 2];
  float[] tabCos = new float[phiDim + 2];

  ArrayList<PVector> lines;
  ArrayList<PVector> intersections;

  QuadGraph graph = new QuadGraph();

  HoughTransform() {
    computeTables();
    lines = new ArrayList<PVector>();
    intersections = new ArrayList<PVector>();
  }

  void computeTables() {
    // pre-compute the sin and cos values
    float ang = 0;
    float inverseR = 1.f / discretizationStepsR;
    for (int accPhi = 0; accPhi <= phiDim + 1; ang += discretizationStepsPhi, accPhi++) {
      // we can also pre-multiply by (1/discretizationStepsR) since we need it in the Hough loop
      tabSin[accPhi] = (float) (Math.sin(ang) * inverseR);
      tabCos[accPhi] = (float) (Math.cos(ang) * inverseR);
    }
  }

  void compute(PImage edgeImg) {
    imgWidth = edgeImg.width;
    imgHeight = edgeImg.height;
    rDim = (int) (((imgWidth + imgHeight) * 2 + 1) / discretizationStepsR);
    int[] accumulator = new int[(phiDim + 2) * (rDim + 2)];
    for (int y = 0; y < imgHeight; y++) {
      for (int x = 0; x < imgWidth; x++) {
        if (brightness(edgeImg.pixels[y * imgWidth + x]) != 0) {
          for (int phi = 0; phi <= phiDim + 1; phi++) {
            int r = (int) (x * tabCos[phi] + y * tabSin[phi]);
            r += (rDim - 1) / 2 ;
            accumulator[phi * rDim + r] += 1;
          }
        }
      }
    }
    this.accumulator = accumulator;
  }

  void updateLines(int nLines) {
    ArrayList<Integer> bestCandidates = new ArrayList<Integer>();
    // size of the region we search for a local maximum
    int neighbourhood = 10;
    // only search around lines with more that this amount of votes
    // (to be adapted to your image)
    int minVotes = 100;
    for (int accR = 0; accR < rDim; accR++) {
      for (int accPhi = 0; accPhi < phiDim; accPhi++) {
        // compute current index in the accumulator
        int idx = (accPhi + 1) * (rDim + 2) + accR + 1;
        if (accumulator[idx] > minVotes) {
          boolean bestCandidate=true;
          // iterate over the neighbourhood
          for (int dPhi=-neighbourhood/2; dPhi < neighbourhood/2+1; dPhi++) {
            // check we are not outside the image
            if ( accPhi+dPhi < 0 || accPhi+dPhi >= phiDim) continue;
            for (int dR=-neighbourhood/2; dR < neighbourhood/2 +1; dR++) {
              // check we are not outside the image
              if (accR+dR < 0 || accR+dR >= rDim) continue;
              int neighbourIdx = (accPhi + dPhi + 1) * (rDim + 2) + accR + dR + 1;
              if (accumulator[idx] < accumulator[neighbourIdx]) {
                // the current idx is not a local maximum!
                bestCandidate=false;
                break;
              }
            }
            if (!bestCandidate) break;
          }
          if (bestCandidate) {
            // the current idx *is* a local maximum
            bestCandidates.add(idx);
          }
        }
      }
    }

    Collections.sort(bestCandidates, new HoughComparator(accumulator));
    for (int j = 0; j < nLines; j++) {
      int idx = bestCandidates.get(j);
      int accPhi = (int) (idx / rDim);
      int accR = idx - (accPhi * rDim);
      float r = (accR - ((rDim - 1) * 0.5f));
      r *= discretizationStepsR;
      float phi = accPhi * discretizationStepsPhi;
      lines.add(new PVector(r, phi));
    }
  }

  void drawAccumulator() {
    PImage houghImg = createImage(rDim + 2, phiDim + 2, ALPHA);
    for (int i = 0; i < accumulator.length; i++) {
      houghImg.pixels[i] = color(min(255, accumulator[i]));
    }
    houghImg.resize(366, 366);
    houghImg.updatePixels();
    image(houghImg, 1600, 0);
  }

  void drawLines() {
    for (PVector line : lines) {
      int x0 = 0;
      int y0 = (int) (line.x / sin(line.y));
      int x1 = (int) (line.x / cos(line.y));
      int y1 = 0;
      int x2 = imgWidth;
      int y2 = (int) (-cos(line.y) / sin(line.y) * x2 + line.x / sin(line.y));
      int y3 = imgHeight;
      int x3 = (int) (-(y3 - line.x / sin(line.y)) * (sin(line.y) / cos(line.y)));
      // Finally, plot the lines
      stroke(204, 102, 0);
      if (y0 > 0) {
        if (x1 > 0)
          line(x0, y0, x1, y1);
        else if (y2 > 0)
          line(x0, y0, x2, y2);
        else
          line(x0, y0, x3, y3);
      } else {
        if (x1 > 0) {
          if (y2 > 0)
            line(x1, y1, x2, y2);
          else
            line(x1, y1, x3, y3);
        } else
          line(x2, y2, x3, y3);
      }
    }
  }
  PVector intersection(PVector v1, PVector v2) {
    float d = cos(v2.y) * sin(v1.y) - cos(v1.y) * sin(v2.y); 
    float x = v2.x * sin(v1.y) - v1.x * sin(v2.y);
    x /= d;
    float y = v1.x * cos(v2.y) - v2.x * cos(v1.y);
    y /= d;
    return new PVector(x, y);
  }

  void intersections() {

    graph.build(lines, 800, 600);

    List<int[]> quads = graph.findCycles();

    for (int[] quad : quads) {
      
      List<PVector> sortedQuad;
      
      PVector l1 = lines.get(quad[0]);
      PVector l2 = lines.get(quad[1]);
      PVector l3 = lines.get(quad[2]);
      PVector l4 = lines.get(quad[3]);

      PVector c12 = intersection(l1, l2);
      PVector c23 = intersection(l2, l3);
      PVector c34 = intersection(l3, l4);
      PVector c41 = intersection(l4, l1);

      if (graph.isConvex(c12, c23, c34, c41) &&
        graph.validArea(c12, c23, c34, c41, 800 * 600, 0.1 * 800 * 600) &&
        graph.nonFlatQuad(c12, c23, c34, c41)) { 

        intersections.add(new PVector(c12.x, c12.y));
        intersections.add(new PVector(c23.x, c23.y));
        intersections.add(new PVector(c34.x, c34.y));
        intersections.add(new PVector(c41.x, c41.y));

        Random random = new Random();
        fill(color(min(255, random.nextInt(300)), 
          min(255, random.nextInt(300)), 
          min(255, random.nextInt(300))));

        for (PVector inter : intersections) {
          ellipse(inter.x, inter.y, 10, 10);
        }
      }
    }
  }
}

class HoughComparator implements java.util.Comparator<Integer> {
  int[] accumulator;
  public HoughComparator(int[] accumulator) {
    this.accumulator = accumulator;
  }
  @Override
    public int compare(Integer l1, Integer l2) {
    if (accumulator[l1] > accumulator[l2]
      || (accumulator[l1] == accumulator[l2] && l1 < l2)) return -1;
    return 1;
  }
}