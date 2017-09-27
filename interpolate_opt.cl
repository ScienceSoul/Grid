int pointInTriangle (float p1, float p2, float a1, float a2, float b1, float b2, float c1, float c2);

int pointInTriangle (float p1, float p2, float a1, float a2, float b1, float b2, float c1, float c2) {
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

__kernel void interpolate (__global float *gx, __global float *gy, __global float *x1, __global float *x2, __global float *x3, __global float *y1, __global float *y2, __global float *y3, __global float *z1, __global float *z2, __global float *z3, __global float *grid, __global int *gridMask, int N1, int N2, int aligned, __local float *shared, __global float *debug)
{
	int ii, k;
    
    int igrid = get_global_id(0);
    int lid = get_local_id(0);
    int lsize = get_local_size(0);
	
	float theInterpolatedValue, weightsum, weight;
	float distanceToPoint[3];
    
    debug[igrid] = (float)lsize;
    grid[ igrid ] = 0.0;
    gridMask[ igrid ] = 0;

    k = 0;
    
    weightsum = 0.0;
    theInterpolatedValue = 0.0;
    
    for (ii = 0; ii < aligned; ii+=lsize) {
        
        if ( (ii+lsize) > aligned )
            lsize = aligned - ii;
    
        if ( (ii+lid) < aligned ) {
        
            shared[lid]           = x1[ii + lid];
            shared[lid + lsize]   = x2[ii + lid];
            shared[lid + 2*lsize] = x3[ii + lid];
            shared[lid + 3*lsize] = y1[ii + lid];
            shared[lid + 4*lsize] = y2[ii + lid];
            shared[lid + 5*lsize] = y3[ii + lid];
            shared[lid + 6*lsize] = z1[ii + lid];
            shared[lid + 7*lsize] = z2[ii + lid];
            shared[lid + 8*lsize] = z3[ii + lid];
            
//            local_x1[lid] = x1[ii + lid];
//            local_x2[lid] = x2[ii + lid];
//            local_x3[lid] = x3[ii + lid];
//            local_y1[lid] = y1[ii + lid];
//            local_y2[lid] = y2[ii + lid];
//            local_y3[lid] = y3[ii + lid];
//            local_z1[lid] = z1[ii + lid];
//            local_z2[lid] = z2[ii + lid];
//            local_z3[lid] = z3[ii + lid];
            
            }
        
        barrier(CLK_LOCAL_MEM_FENCE);
            
        for (int i=0; i<lsize; i++) {
            
            k = pointInTriangle(gx[igrid], gy[igrid], shared[i], shared[i + 3*lsize], shared[i + lsize], shared[i + 4*lsize], shared[i + 2*lsize], shared[i + 5*lsize]);
            
            if (k == 1) {
                
                distanceToPoint[0] = sqrt( pow( (shared[i]-gx[igrid]), (float)2.0 ) + pow( (shared[i + 3*lsize]-gy[igrid]), (float)2.0 ) );
                distanceToPoint[1] = sqrt( pow( (shared[i + lsize]-gx[igrid]), (float)2.0 ) + pow( (shared[i + 4*lsize]-gy[igrid]), (float)2.0 ) );
                distanceToPoint[2] = sqrt( pow( (shared[i + 2*lsize]-gx[igrid]), (float)2.0 ) + pow( (shared[i + 5*lsize]-gy[igrid]), (float)2.0 ) );
                
                weight = pow( distanceToPoint[0], (float)-2.0 );
                theInterpolatedValue = theInterpolatedValue + weight * shared[i + 6*lsize];
                weightsum = weightsum + weight;
                
                weight = pow( distanceToPoint[1], (float)-2.0 );
                theInterpolatedValue = theInterpolatedValue + weight * shared[i + 7*lsize];
                weightsum = weightsum + weight;
                
                weight = pow( distanceToPoint[2], (float)-2.0 );
                theInterpolatedValue = theInterpolatedValue + weight * shared[i + 8*lsize];
                weightsum = weightsum + weight;

            }
        }
        
        barrier(CLK_LOCAL_MEM_FENCE);
    }
    
    grid[ igrid ] = theInterpolatedValue/weightsum;
    if (theInterpolatedValue != 0) {
        gridMask[ igrid ] = 3;
    }
       
}
