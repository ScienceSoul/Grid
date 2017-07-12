int pointInTriangle (float p1, float p2, float a1, float a2, float b1, float b2, float c1, float c2);

int pointInTriangle (float p1, float p2, float a1, float a2, float b1, float b2, float c1, float c2) 
{
	int i;
	
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
	for (i=0; i<2; i++) {
		dot00 = dot00 + v0[i]*v0[i];
	}
	
	dot01 = 0.0;
	for (i=0; i<2; i++) {
		dot01 = dot01 + v0[i]*v1[i];
	}
	
	dot02 = 0.0;
	for (i=0; i<2; i++) {
		dot02 = dot02 + v0[i]*v2[i];
	}
	
	dot11 = 0.0;
	for (i=0; i<2; i++) {
		dot11 = dot11 + v1[i]*v1[i];
	}
	
	dot12 = 0.0;
	for (i=0; i<2; i++) {
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

__kernel void interpolate (__global float *gx, __global float *gy, __global float *triangles, __global float *grid, __global int *gridMask, int N1, int N2)
{
	int i;
	int jj, ii;
	int l, k;
    
    int igrid = get_global_id(0);
	
	float theInterpolatedValue, weightsum, weight;
	float distanceToPoint[5][3];
	
	int foundTriangles[10][3];
	
	l = 0;
	k = 0;
	
	for (ii=0;ii<10;ii++) {
        for (jj=0;jj<3;jj++) {
            foundTriangles[ii][jj] = 0;
        }
	}
	
	for (ii=0; ii<(N2*(N1/3)*12); ii=ii+12) {
		k = pointInTriangle(gx[igrid], gy[igrid], triangles[ii+1], triangles[ii+2], triangles[ii+4], triangles[ii+5], triangles[ii+7], triangles[ii+8]);
		if (k == 1) {
		    foundTriangles[l][0] = ii;
			foundTriangles[l][1] = triangles[ii+10];
			foundTriangles[l][2] = triangles[ii+11];
			l++;
        }
	}
    
	if (l > 0) { 
        
		for (i=0; i<l; i++) {
			distanceToPoint[i][0] = sqrt( pow( (triangles[foundTriangles[i][0]+1]-gx[igrid]), (float)2.0 ) + pow( (triangles[foundTriangles[i][0]+2]-gy[igrid]), (float)2.0 ) );
			distanceToPoint[i][1] = sqrt( pow( (triangles[foundTriangles[i][0]+4]-gx[igrid]), (float)2.0 ) + pow( (triangles[foundTriangles[i][0]+5]-gy[igrid]), (float)2.0 ) );
			distanceToPoint[i][2] = sqrt( pow( (triangles[foundTriangles[i][0]+7]-gx[igrid]), (float)2.0 ) + pow( (triangles[foundTriangles[i][0]+8]-gy[igrid]), (float)2.0 ) );
		}
		
		weightsum = 0.0;
		theInterpolatedValue = 0.0;
		
		for (i=0; i<l; i++) {
			weight = pow( distanceToPoint[i][0], (float)-2.0 );
			theInterpolatedValue = theInterpolatedValue + weight * triangles[foundTriangles[i][0]+3];
			weightsum = weightsum + weight;
			
			weight = pow( distanceToPoint[i][1], (float)-2.0 );
			theInterpolatedValue = theInterpolatedValue + weight * triangles[foundTriangles[i][0]+6];
			weightsum = weightsum + weight;
			
			weight = pow( distanceToPoint[i][2], (float)-2.0 );
			theInterpolatedValue = theInterpolatedValue + weight * triangles[foundTriangles[i][0]+9];
			weightsum = weightsum + weight;
		}
        
		grid[ igrid ] = theInterpolatedValue/weightsum;
		gridMask[ igrid ] = 3;
	} else {
		grid[ igrid ] = 0.0;
		gridMask[ igrid ] = 0;
	}
    
}