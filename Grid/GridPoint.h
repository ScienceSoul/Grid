//
//  GridPoint.h
//  Grid
//
//  Created by Hakime Seddik on 14/09/11.
//  Copyright 2011 Institute of Low Temperature Science. All rights reserved.
//

int pointInTriangle (float p1, float p2, float a1, float a2, float b1, float b2, float c1, float c2);
float getInterpolatedValue (int **trianglesForUse, int nbTriangles, float XI, float YI, float ***data, float exponent);