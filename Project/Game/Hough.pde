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
  ArrayList<PVector> bestLines;
  ArrayList<PVector> intersections;

  QuadGraph graph = new QuadGraph();

  HoughTransform() {
    computeTables();
    lines = new ArrayList<PVector>();
    intersections = new ArrayList<PVector>();
  }

  void computeTables() {
    println("    Pre-computing the sin and cos values");
    float ang = 0;
    float inverseR = 1.f / discretizationStepsR;
    for (int accPhi = 0; accPhi <= phiDim + 1; ang += discretizationStepsPhi, accPhi++) {
      // we can also pre-multiply by (1/discretizationStepsR) since we need it in the Hough loop
      tabSin[accPhi] = (float) (Math.sin(ang) * inverseR);
      tabCos[accPhi] = (float) (Math.cos(ang) * inverseR);
    }
  }

  void compute(PImage edgeImg) {
    println("    Computing Hough accumulator");
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
    println("    Updating lines");
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
  
  PVector intersection(PVector v1, PVector v2) {
    float d = cos(v2.y) * sin(v1.y) - cos(v1.y) * sin(v2.y); 
    float x = v2.x * sin(v1.y) - v1.x * sin(v2.y);
    x /= d;
    float y = v1.x * cos(v2.y) - v2.x * cos(v1.y);
    y /= d;
    return new PVector(x, y);
  }

  void updateIntersections() {
println("    Updating intersections");
    graph.build(lines, 800, 600);

    List<int[]> quads = graph.findCycles();

    float maxArea = 0;

    for (int[] quad : quads) {
      PVector l1 = lines.get(quad[0]);
      PVector l2 = lines.get(quad[1]);
      PVector l3 = lines.get(quad[2]);
      PVector l4 = lines.get(quad[3]);
      PVector[] quadLines = {l1, l2, l3, l4};

      PVector c12 = intersection(l1, l2);
      PVector c23 = intersection(l2, l3);
      PVector c34 = intersection(l3, l4);
      PVector c41 = intersection(l4, l1);
      PVector[] vectorQuad = {c12, c23, c34, c41};

      float i1=c12.cross(c23).z;
      float i2=c23.cross(c34).z;
      float i3=c34.cross(c41).z;
      float i4=c41.cross(c12).z;

      float area = Math.abs(0.5f * (i1 + i2 + i3 + i4));

      if (graph.isConvex(c12, c23, c34, c41) &&
        graph.validArea(c12, c23, c34, c41, 800 * 600, 0.1 * 800 * 600) &&
        graph.nonFlatQuad(c12, c23, c34, c41) &&
        (area > maxArea)) { 
        println("        New valid quad");
        intersections = new ArrayList<PVector>(graph.sortCorners(Arrays.asList(vectorQuad)));
        bestLines = new ArrayList<PVector>(Arrays.asList(quadLines));
      }
    }
  }

  void drawAccumulator() {
    println("    Drawing accumulator");
    PImage houghImg = createImage(rDim + 2, phiDim + 2, ALPHA);
    for (int i = 0; i < accumulator.length; i++) {
      houghImg.pixels[i] = color(min(255, accumulator[i]));
    }
    houghImg.resize(366, 366);
    houghImg.updatePixels();
    imageProc.image(houghImg, 1600, 0);
  }

  void drawLines() {
    println("    Drawing lines");
    for (PVector line : bestLines) {
      int x0 = 0;
      int y0 = (int) (line.x / sin(line.y));
      int x1 = (int) (line.x / cos(line.y));
      int y1 = 0;
      int x2 = imgWidth;
      int y2 = (int) (-cos(line.y) / sin(line.y) * x2 + line.x / sin(line.y));
      int y3 = imgHeight;
      int x3 = (int) (-(y3 - line.x / sin(line.y)) * (sin(line.y) / cos(line.y)));
      // Finally, plot the lines
      imageProc.stroke(204, 102, 0);
      if (y0 > 0) {
        if (x1 > 0)
          imageProc.line(x0, y0, x1, y1);
        else if (y2 > 0)
          imageProc.line(x0, y0, x2, y2);
        else
          imageProc.line(x0, y0, x3, y3);
      } else {
        if (x1 > 0) {
          if (y2 > 0)
            imageProc.line(x1, y1, x2, y2);
          else
            imageProc.line(x1, y1, x3, y3);
        } else
          imageProc.line(x2, y2, x3, y3);
      }
    }
  }

  void drawIntersections() {
    println("    Drawing intersections");
    imageProc.fill(color(255));

    for (PVector inter : intersections) {
      imageProc.ellipse(inter.x, inter.y, 10, 10);
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