//
//  GCD_compute.c
//  Grid
//
//  Created by Hakime Seddik on 14/09/11.
//  Copyright 2011 Institute of Low Temperature Science. All rights reserved.
//

#include <stdio.h>
#include <dispatch/dispatch.h>

#include "memory.h"
#include "GCD_compute.h"
#include "GridPoint.h"

void GCD_work_function(float ***grid1, int ***grid2, int t, float ***entry1, float *entry2, float *entry3, int N1, int N2, int N3, int N4)
// entry1 -> triangles
// entry2 -> x regular grid
// entry3 -> y regular grid
{
	
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	
	
	dispatch_apply(N4, queue, ^(size_t yy){
		
		int jj, ii, xx;
		int l, k;
		
		int **foundTriangles;
		
		l = 0;
		k = 0;
		
		foundTriangles = intmatrix(0, 9, 0, 1);
		
		for (ii=0;ii<10;ii++) {
			for (jj=0;jj<2;jj++) {
				foundTriangles[ii][jj] = 0;
			}
		}
		
		for (xx=0; xx<N3; xx++) {
			
			l = 0;
			for (jj=0; jj<N2; jj++) {
				for (ii=0; ii<N1/3; ii++) {
					k = pointInTriangle(entry2[xx], entry3[yy], entry1[jj][ii][1], entry1[jj][ii][2], entry1[jj][ii][4], entry1[jj][ii][5], 
										entry1[jj][ii][7], entry1[jj][ii][8]);
					if (k == 1) {
						foundTriangles[l][0] = jj;
						foundTriangles[l][1] = ii;
						//printf("%f %f %d %d\n", entry5[xx], entry6[yy], foundTriangles[l][0], foundTriangles[l][1]);
						l++;
					}
				}
			}
			//if (l > 1) printf("got %d triangles.\n", l);
			if (l > 0) { 
				grid1[t][yy][xx] = getInterpolatedValue(foundTriangles, l, entry2[xx], entry3[yy], entry1, 2.0);
				grid2[t][yy][xx] = 3;
			} else {
				grid1[t][yy][xx] = 0.0;
				grid2[t][yy][xx] = 0;
			}
			//printf("%d %d %d %f\n", t, (int) yy, xx, griddedData[t][yy][xx]);
		}
		
		free_imatrix(foundTriangles, 0, 9, 0, 1);
	});
}
