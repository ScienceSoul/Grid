//
//  GridPoint.c
//  Grid
//
//  Created by Hakime Seddik on 14/09/11.
//  Copyright © 2011 ScienceSoul. All rights reserved.
//

#include <stdio.h>
#include <math.h>

#include "memory.h"
#include "GridPoint.h"

int pointInTriangle (float p1, float p2, float a1, float a2, float b1, float b2, float c1, float c2) {
	
	float v0[2];
	float v1[2];
	float v2[2];
	
	float dot00, dot01, dot02, dot11, dot12;
	float invDenom, u, v;
	
	u = 0.0;
	v = 0.0;
	invDenom = 0.0;
	
	v0[0] = c1-a1;
	v0[1] = c2-a2;
	
	v1[0] = b1-a1;
	v1[1] = b2-a2;
	
	v2[0] = p1-a1;
	v2[1] = p2-a2;
	
	// Compute dot products
	dot00 = 0.0;
	for (int i=0; i<2; i++) {
		dot00 = dot00 + v0[i]*v0[i];
	}
	
	dot01 = 0.0;
	for (int i=0; i<2; i++) {
		dot01 = dot01 + v0[i]*v1[i];
	}
	
	dot02 = 0.0;
	for (int i=0; i<2; i++) {
		dot02 = dot02 + v0[i]*v2[i];
	}
	
	dot11 = 0.0;
	for (int i=0; i<2; i++) {
		dot11 = dot11 + v1[i]*v1[i];
	}
	
	dot12 = 0.0;
	for (int i=0; i<2; i++) {
		dot12 = dot12 + v1[i]*v2[i];
	}
	
	// Compute barycentric coordinates
	invDenom = 1.0/(dot00 * dot11 - dot01 * dot01);
	u = (dot11 * dot02 - dot01 * dot12) * invDenom;
	v = (dot00 * dot12 - dot01 * dot02) * invDenom;
	
	// Check if point is in triangle
	if ( u > 0.0 && v > 0.0 && (u+v) < 1.0 ) {
		return 1;
	}
	else {
		return -1;
	}
}


float getInterpolatedValue (int **trianglesForUse, int nbTriangles, float XI, float YI, float ***data, float exponent) {
    
	float **distanceToPoint;
	float theInterpolatedValue, weightsum, weight;
	
	distanceToPoint = floatmatrix(0, nbTriangles-1, 0, 2);
	for (int i=0; i<nbTriangles; i++) {
		distanceToPoint[i][0] = sqrtf(powf((data[trianglesForUse[i][0]][trianglesForUse[i][1]][1]-XI), 2.0) + powf((data[trianglesForUse[i][0]][trianglesForUse[i][1]][2]-YI), 2.0));
		distanceToPoint[i][1] = sqrtf(powf((data[trianglesForUse[i][0]][trianglesForUse[i][1]][4]-XI), 2.0) + powf((data[trianglesForUse[i][0]][trianglesForUse[i][1]][5]-YI), 2.0));
		distanceToPoint[i][2] = sqrtf(powf((data[trianglesForUse[i][0]][trianglesForUse[i][1]][7]-XI), 2.0) + powf((data[trianglesForUse[i][0]][trianglesForUse[i][1]][8]-YI), 2.0));
	}
	
	weightsum = 0.0;
	theInterpolatedValue = 0.0;
	for (int i=0; i<nbTriangles; i++) {
		weight = powf( distanceToPoint[i][0], -exponent );
		theInterpolatedValue = theInterpolatedValue + weight * data[trianglesForUse[i][0]][trianglesForUse[i][1]][3];
		weightsum = weightsum + weight;
		
		weight = powf( distanceToPoint[i][1], -exponent );
		theInterpolatedValue = theInterpolatedValue + weight * data[trianglesForUse[i][0]][trianglesForUse[i][1]][6];
		weightsum = weightsum + weight;
		
		weight = powf( distanceToPoint[i][2], -exponent );
		theInterpolatedValue = theInterpolatedValue + weight * data[trianglesForUse[i][0]][trianglesForUse[i][1]][9];
		weightsum = weightsum + weight;
	}
	
	free_fmatrix(distanceToPoint, 0, nbTriangles-1, 0, 2);
	
	return theInterpolatedValue/weightsum;
}
