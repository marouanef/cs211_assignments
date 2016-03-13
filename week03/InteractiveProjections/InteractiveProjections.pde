void settings() {
  size(1000, 1000, P2D);
}

void setup () {
}

float scaleValue = 1;
float xAngle = 0;
float yAngle = 0;

void draw() {
  background(255, 255, 255);

  My3DPoint eye = new My3DPoint(0, 0, -5000);
  My3DPoint origin = new My3DPoint(500, 500, 500);
  My3DBox input3DBox = new My3DBox(origin, 100, 150, 300);

  if (keyPressed == true) {
    if (key == CODED) {
      if (keyCode == UP) {
        xAngle += 0.05;
      } else if (keyCode == DOWN) {
        xAngle -= 0.05;
      } else if (keyCode == LEFT) {
        yAngle -= 0.05;
      } else if (keyCode == RIGHT) {
        yAngle += 0.05;
      }
    }
  }

  My3DPoint cubeCenter = new My3DPoint(0, 0, 0);

  for (My3DPoint point : input3DBox.p) {
    cubeCenter.x += point.x;
    cubeCenter.y += point.y;
    cubeCenter.z += point.z;
  }

  cubeCenter.x = cubeCenter.x / 8;
  cubeCenter.y = cubeCenter.y / 8;
  cubeCenter.z = cubeCenter.z / 8;

  float[][] translateToOrigin = translationMatrix(-cubeCenter.x, -cubeCenter.y, -cubeCenter.z);
  float[][] translateBack = translationMatrix(cubeCenter.x, cubeCenter.y, cubeCenter.z);

  input3DBox = transformBox(input3DBox, translateToOrigin);

  float[][] transform1 = rotateXMatrix(xAngle);
  input3DBox = transformBox(input3DBox, transform1);

  float[][] transform2 = rotateYMatrix(yAngle);
  input3DBox = transformBox(input3DBox, transform2);

  if (scaleValue > 0) {
    float[][] transform3 = scaleMatrix(scaleValue, scaleValue, scaleValue);
    input3DBox = transformBox(input3DBox, transform3);
  } else {
     input3DBox = transformBox(input3DBox, scaleMatrix(0,0,0)); 
     scaleValue = 0;
  }

  input3DBox = transformBox(input3DBox, translateBack);

  projectBox(eye, input3DBox).render();
}

void mouseDragged() 
{
  if (pmouseY - mouseY > 0) {
    scaleValue += 0.05;
  } else if (pmouseY - mouseY < 0) {
    scaleValue -= 0.05;
  }
}

class My2DPoint {
  float x;
  float y;
  My2DPoint(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

class My3DPoint {
  float x;
  float y;
  float z;
  My3DPoint(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
}

My2DPoint projectPoint(My3DPoint eye, My3DPoint p) {
  return new My2DPoint(((p.x - eye.x) * eye.z) / (eye.z - p.z), ((p.y - eye.y) * eye.z) / (eye.z - p.z) );
}

class My2DBox {
  My2DPoint[] s;
  My2DBox(My2DPoint[] s) {
    this.s = s;
  }
  void render() {
    
    //First method, didn't quite work out because we first need to draw outer side.
    
    //strokeWeight(4);
    //for (int i = 0; i < s.length; i++) {
    // My2DPoint point1 = s[i];
    // if (i<4) {
    //   stroke(255, 0, 0);
    // } else {
    //   stroke(0, 255, 0);
    // }
    // if ( (i + 1) % 4 != 0) {
    //   My2DPoint point2 = s[i + 1];

    //   line(point1.x, point1.y, point2.x, point2.y);
    // } else {
    //   My2DPoint point2 = s[i - 3];
    //   line(point1.x, point1.y, point2.x, point2.y);
    // }
    // if (i < 4) {
    //   My2DPoint point3 = s[i + 4];
    //   stroke(0, 0, 255);
    //   line(point1.x, point1.y, point3.x, point3.y);
    // }
    //}
    
    //Second method, every face is drawn separately.
    
    strokeWeight(4);
    stroke(0, 255, 0);
    for (int i = 4; i < 8; i++) {
      if   (i == 7) {
        line(s[i].x, s[i].y, s[i - 3].x, s[i -3].y);
      } else {
        line(s[i].x, s[i].y, s[i + 1].x, s[i + 1].y);
      }
    }
    stroke(0, 0, 255);
    for (int i = 0; i < 4; i++) {
      line(s[i].x, s[i].y, s[i + 4].x, s[i + 4].y);
    }
    stroke(255, 0, 0);
    for (int i = 0; i < 4; i++) {
      if   (i == 3) {
        line(s[i].x, s[i].y, s[i - 3].x, s[i -3].y);
      } else {
        line(s[i].x, s[i].y, s[i + 1].x, s[i + 1].y);
      }
    }
  }
}

class My3DBox {
  My3DPoint[] p;
  My3DBox(My3DPoint origin, float dimX, float dimY, float dimZ) {
    float x = origin.x;
    float y = origin.y;
    float z = origin.z;
    this.p = new My3DPoint[]{new My3DPoint(x, y+dimY, z+dimZ), 
      new My3DPoint(x, y, z+dimZ), 
      new My3DPoint(x+dimX, y, z+dimZ), 
      new My3DPoint(x+dimX, y+dimY, z+dimZ), 
      new My3DPoint(x, y+dimY, z), 
      origin, 
      new My3DPoint(x+dimX, y, z), 
      new My3DPoint(x+dimX, y+dimY, z)
    };
  }
  My3DBox(My3DPoint[] p) {
    this.p = p;
  }
}

My2DBox projectBox (My3DPoint eye, My3DBox box) {
  My2DPoint[] s = new My2DPoint[8];
  int i = 0;
  for (My3DPoint point : box.p) {
    s[i] = projectPoint(eye, point);
    i++;
  }
  return new My2DBox(s);
}

float[] homogeneous3DPoint (My3DPoint p) {
  float[] result = {p.x, p.y, p.z, 1};
  return result;
}

float[][] rotateXMatrix(float angle) {
  return new float[][] {{1, 0, 0, 0}, 
    {0, cos(angle), -sin(angle), 0}, 
    {0, sin(angle), cos(angle), 0}, 
    {0, 0, 0, 1}};
}
float[][] rotateYMatrix(float angle) {
  return new float[][] {{cos(angle), 0, sin(angle), 0}, {0, 1, 0, 0}, {-sin(angle), 0, cos(angle), 0}, {0, 0, 0, 1}};
}
float[][] rotateZMatrix(float angle) {
  return new float[][] {{cos(angle), -sin(angle), 0, 0}, {sin(angle), cos(angle), 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}};
}
float[][] scaleMatrix(float x, float y, float z) {
  return new float[][] {{x, 0, 0, 0}, {0, y, 0, 0}, {0, 0, z, 0}, {0, 0, 0, 1}};
}
float[][] translationMatrix(float x, float y, float z) {
  return new float[][] {{1, 0, 0, x}, {0, 1, 0, y}, {0, 0, 1, z}, {0, 0, 0, 1}};
}

float[] matrixProduct(float[][] a, float[] b) {
  float[] product = new float[4];
  for (int i = 0; i < 4; i++) {
    product[i] = a[i][1] * b[1] + a[i][2] * b[2] + a[i][3] * b[3] + a[i][0] * b[0];
  }
  return product;
}

My3DBox transformBox(My3DBox box, float[][] transformMatrix) {
  My3DPoint[] pointsList = new My3DPoint[8];
  for (int i = 0; i < 8; i++) {
    float[] homogeneousPoint = homogeneous3DPoint(box.p[i]);
    float[] transformedPoint = matrixProduct(transformMatrix, homogeneousPoint);
    pointsList[i] = euclidian3DPoint(transformedPoint);
  }
  return new My3DBox(pointsList);
}

My3DPoint euclidian3DPoint (float[] a) {
  My3DPoint result = new My3DPoint(a[0]/a[3], a[1]/a[3], a[2]/a[3]);
  return result;
}