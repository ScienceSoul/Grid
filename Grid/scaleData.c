//
//  scaleData.c
//  Grid
//
//  Created by Hakime Seddik on 03/10/11.
//  Copyright 2011 Institute of Low Temperature Science. All rights reserved.
//

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include "scaleData.h"

#define DEFAULT_FILL_VALUE	1.0e35

/*******************************************************************************
 
     Determine whether the data is "close enough" to the fill value
 
*******************************************************************************/
int close_enough( float data, float fill ) {
	float	criterion, diff;
	int	retval;
    
	if( fill == 0.0 )
		criterion = 1.0e-5;
	else if( fill < 0.0 )
		criterion = -1.0e-5*fill;
	else
		criterion = 1.0e-5*fill;
    
	diff = data - fill;
	if( diff < 0.0 ) 
		diff = -diff;
    
	if( diff <= criterion )
		retval = 1;
	else
		retval = 0;
    
    /* printf( "d=%f f=%f c=%f r=%d\n", data, fill, criterion, retval );  */
	return( retval );
}

void expand_data (float *big_data, float* data_in, size_t array_size, int nx, int ny, int blowup, int method) {
    
    size_t	idx, nxl, nyl, nxb, nyb;
    long	line, il, jl, i2b, j2b;
    int offset_xb, offset_yb, miss_base, miss_right, miss_below;
    float	step, final_est, extrap_fact;
	float	base_val, right_val, below_val, val, bupr;
	float	base_x, base_y, del_x, del_y;
	float	est1, est2, frac_x, frac_y;
	float 	fill_val, cval;

    nxl = nx;
    nyl = ny;
    nxb = nxl*blowup;
    nyb = nyl*blowup;
    
    fill_val = DEFAULT_FILL_VALUE;
    
    if (method == 1) { // Replicate
        for(jl=0; jl<nyl; jl++) {
            for(il=0; il<nxl; il++) {
                for(i2b=0; i2b<blowup; i2b++) {
                    if(il*blowup + jl*nxb*blowup + i2b >= array_size) {
                        printf("expand_data: mem error 001\n"); exit(-1);
                    }
                    *(big_data + il*blowup + jl*nxb*blowup + i2b) = *(data_in+il+jl*nxl);
                }
            }
            
            for(line=1; line<blowup; line++) {
                for(i2b=0; i2b<nxb; i2b++) {
                    if(i2b + jl*nxb*blowup + line*nxb >= array_size) {
                        printf("expand_data: mem error 002\n" ); exit(-1);
                    }
                    *(big_data + i2b + jl*nxb*blowup + line*nxb) =
                    *(big_data + i2b + jl*nxb*blowup);
                }
            }
        }
    } else if (method == 2) { // Bilinear
        
        bupr = 1.0/(float)blowup;
        
        /* Offset where we will put the center value into the big array. These are offsets
         * into the big array.
         */
        offset_xb = (blowup - 1)/2;
        offset_yb = offset_xb;
        
        /* Horizontal base lines */
        for(jl=0; jl<nyl; jl++) {
            for(il=0; il<nxl-1; il++) {
                base_val  = *(data_in + il + jl*nxl);
                right_val = *(data_in + il+1 + jl*nxl);
                
                miss_base  = close_enough(base_val,  fill_val);
                miss_right = close_enough(right_val, fill_val);
                if(miss_base) {
                    if(miss_right) {
                        /* BOTH missing */
                        step = 0.0;
                        val = base_val;		/* missing value */
                    }
                    else {
                        /* base missing, but right is there */
                        step = 0.0;
                        val = right_val;	/* an OK value */
                    }
                }
                else if(miss_right) {
                    /* ONLY right is missing, checked for both missing above */
                    val = base_val;
                    step = 0.0;
                }
                else {
                    /* NEITHER missing */
                    step = (right_val-base_val)*bupr;
                    val = base_val;
                }
                
                for(i2b=0; i2b < blowup; i2b++) {
                    if(il*blowup+i2b+offset_xb + jl*blowup*nxb + offset_yb*nxb >= array_size) {
                        printf("expand_data: mem error 003\n" ); exit(-1);
                    }
                    *(big_data + il*blowup+i2b+offset_xb + jl*blowup*nxb + offset_yb*nxb ) = val;
                    val += step;
                }
            }
            /* Fill in the last center value on the right, which was left unfilled by the above alg */
            if((nxl-1)*blowup+offset_xb + jl*blowup*nxb + offset_yb*nxb >= array_size) {
                printf("expand_data: mem error 004\n" ); exit(-1);
            }
            *(big_data + (nxl-1)*blowup+offset_xb + jl*blowup*nxb + offset_yb*nxb ) = *(data_in + (nxl-1) + jl*nxl);
        }
        
        /* Vertical base lines */
        for(jl=0; jl<nyl-1; jl++) {
            for(il=0; il<nxl;   il++) {
                base_val  = *(data_in + il + jl*nxl);
                below_val = *(data_in + il + (jl+1)*nxl);
                
                miss_base  = close_enough(base_val,  fill_val);
                miss_below = close_enough(below_val, fill_val);
                
                if(miss_base) {
                    if(miss_below) {
                        /* BOTH missing */
                        step = 0.0;
                        val = base_val;		/* missing value */
                    }
                    else {
                        /* base missing, but below is there */
                        step = 0.0;
                        val = below_val;	/* an OK value */
                    }
                }
                else if(miss_below) {
                    /* ONLY below is missing, checked for both missing above */
                    val = base_val;
                    step = 0.0;
                }
                else {
                    /* NEITHER missing */
                    step = (below_val-base_val)*bupr;
                    val = base_val;
                }
                
                for(j2b=0; j2b < blowup; j2b++) {
                    if(il*blowup+offset_xb + jl*blowup*nxb + (j2b+offset_yb)*nxb >= array_size) {
                        printf("expand_data: mem error 005\n" ); exit(-1);
                    }
                    *(big_data + il*blowup+offset_xb + jl*blowup*nxb + (j2b+offset_yb)*nxb ) = val;
                    val += step;
                }
            }
        }
        /* Fill in the last center value along the top, which was left unfilled by the above alg */
        for(il=0; il<nxl; il++) {
            if(il*blowup+offset_xb + (nyl-1)*blowup*nxb + offset_yb*nxb >= array_size) {
                printf("expand_data: mem error 006\n" ); exit(-1);
            }
            *(big_data + il*blowup+offset_xb + (nyl-1)*blowup*nxb + offset_yb*nxb) = *(data_in + il + (nyl-1)*nxl);
        }
        
        /* Now, fill in the interior of the interior squares by
         * interpolating from the horizontal and vertical
         * base lines.
         */
        for(jl=0; jl<nyl-1; jl++) {
            for(il=0; il<nxl-1; il++) {
                for(j2b=1; j2b<blowup; j2b++) {
                    for(i2b=1; i2b<blowup; i2b++) {
                        frac_x = (float)i2b*bupr;
                        frac_y = (float)j2b*bupr;
                        
                        base_x    = *(big_data + il*blowup+offset_xb + jl*blowup*nxb +(j2b+offset_yb)*nxb);
                        right_val = *(big_data + (il+1)*blowup+offset_xb + jl*blowup*nxb+ (j2b+offset_yb)*nxb);
                        base_y    = *(big_data + il*blowup+i2b+offset_xb + jl*blowup*nxb + offset_yb*nxb);
                        below_val = *(big_data + il*blowup+i2b+offset_xb + (jl+1)*blowup*nxb + offset_yb*nxb);
                        
                        if(close_enough(base_x, fill_val) || close_enough(right_val, fill_val) ||
                           (il == nxl-1))
                            del_x = 0.0;
                        else
                            del_x  = right_val - base_x;
                        if( close_enough(base_y,    fill_val) || close_enough(below_val, fill_val) || (jl == nyl-1) )
                            del_y = 0.0;
                        else
                            del_y  = below_val - base_y;
                        est1 = frac_x*del_x + base_x;
                        est2 = frac_y*del_y + base_y;
                        
                        if(close_enough( est1, fill_val )) {
                            if( close_enough( est2, fill_val ))
                                final_est = fill_val;
                            else
                                final_est = est2;
                        }
                        else if(close_enough( est2, fill_val ))
                            final_est = est1;
                        else
                            final_est = (est1 + est2)*.5;
                        
                        if(il*blowup+i2b+offset_xb + jl*blowup*nxb + (j2b+offset_yb)*nxb >= array_size) {
                            printf("expand_data: mem error 007\n" ); exit(-1);
                        }
                        *(big_data + il*blowup+i2b+offset_xb + jl*blowup*nxb + (j2b+offset_yb)*nxb ) = final_est;
                    }
                }
            }
        }
        
        /* It is a tricky and undetermined question as to whether we want to allow
         * extrema on the boundaries.  As a complete and total hack, we use only
         * some fraction of the linear projection when extrapolating out to the
         * edges.  If this is set to 1, then full linear extrapolation is used;
         * if set to 0, no extrapolation is done.
         */
        extrap_fact = 0.2;
        
        /* Fill in right hand side by extrapolating the gradient from the interior square fill.
         * This goes from y=the first center point to y=the last center point.
         */
        il = nxl-1;
        for(j2b=0; j2b<=blowup*(nyl-1); j2b++) {
            idx = il*blowup+offset_xb + (j2b+offset_yb)*nxb;
            step = (*(big_data + idx - 1) - *(big_data + idx - 2));
            val  = *(big_data + idx) + step;
            for(i2b=1; i2b<(blowup-offset_xb+1); i2b++) {
                if(idx + i2b >= array_size) {
                    printf("expand_data: mem error 008\n" );
                    exit(-1);
                }
                *(big_data + idx + i2b) = val;
                val += step*extrap_fact;
            }
        }
        
        /* Fill in left hand side */
        il = 0;
        for(j2b=0; j2b<=blowup*(nyl-1); j2b++) {
            idx = il*blowup+offset_xb + (j2b+offset_yb)*nxb;
            step = (*(big_data + idx + 2) - *(big_data + idx + 1));
            val  = *(big_data + idx) - step;
            for(i2b=1; i2b<=(blowup-1)/2; i2b++) {
                if(idx - i2b >= array_size) {
                    printf("expand_data: mem error 009\n" );
                    exit(-1);
                }
                *(big_data + idx - i2b) = val;
                val -= step*extrap_fact;
            }
        }
        
        /* Fill in bottom */
        jl = 0;
        for(i2b=0; i2b<=blowup*(nxl-1); i2b++) {
            idx = i2b+offset_xb + jl*blowup*nxb + offset_yb*nxb;
            step = (*(big_data + idx + 2*nxb) - *(big_data + idx + nxb));   /* big(,y+2) - big(,y+1) */
            val  = *(big_data + idx) - step;
            for(j2b=1; j2b<=(blowup-1)/2; j2b++) {
                if(idx - j2b*nxb >= array_size) {
                    printf("expand_data: mem error 010\n" );
                    exit(-1);
                }
                *(big_data + idx - j2b*nxb) = val;
                val -= step*extrap_fact;
            }
        }
        
        /* Fill in top */
        jl = nyl-1;
        for(i2b=0; i2b<blowup*(nxl-1); i2b++) {
            idx = i2b+offset_xb + jl*blowup*nxb + offset_yb*nxb;
            step = (*(big_data + idx - nxb) - *(big_data + idx - 2*nxb));  /* big(,y-1) - big(,y-2) */
            val  = *(big_data + idx) + step;
            for(j2b=1; j2b<=blowup/2; j2b++) {
                if(idx + j2b*nxb >= array_size) {
                    printf("expand_data: mem error 011\n" );
                    exit(-1);
                }
                *(big_data + idx + j2b*nxb) = val;
                val += step*extrap_fact;
            }
        }
        
        /* Still have to fill in the four corners at this point.   Because of the
         * extrapolation issue noted above, we take a simple approach.  Just fill
         * in the corner blocks with the center data value.
         */
        
        /* Lower left corner */
        il = 0;
        jl = 0;
        cval = *(data_in + il + jl*nxl);          /* Data value in lower left corner */
        if(!close_enough( cval, fill_val )) {
            /* Fill in lower left corner */
            for(j2b=0; j2b<=offset_yb; j2b++) {
                for(i2b=0; i2b<=offset_xb; i2b++) {
                    if(i2b + j2b*nxb >= array_size) {
                        printf("expand_data: mem error 012\n" );
                        exit(-1);
                    }
                    *(big_data + i2b + j2b*nxb) = cval;
                }
            }
        }
        
        /* Lower right corner */
        il = nxl - 1;
        jl = 0;
        cval = *(data_in + il + jl*nxl);          /* Data value in lower left corner */
        if(!close_enough( cval, fill_val )) {
            /* Fill in lower right corner */
            for(j2b=0; j2b<=offset_yb; j2b++) {
                for(i2b=offset_xb; i2b<blowup; i2b++) {
                    if(il*blowup + i2b + j2b*nxb >= array_size) {
                        printf("expand_data: mem error 013\n" );
                        exit(-1);
                    }
                    *(big_data + il*blowup + i2b + j2b*nxb) = cval;
                }
            }
        }
        
        /* Upper right corner */
        il = nxl - 1;
        jl = nyl - 1;
        cval = *(data_in + il + jl*nxl);          /* Data value in lower left corner */
        if(!close_enough( cval, fill_val )) {
            /* Fill in upper right corner */
            for(j2b=offset_yb; j2b<blowup; j2b++) {
                for(i2b=offset_xb; i2b<blowup; i2b++) {
                    if(il*blowup + i2b + jl*blowup*nxb + j2b*nxb >= array_size) {
                        printf("expand_data: mem error 014\n" );
                        exit(-1);
                    }
                    *(big_data + il*blowup + i2b + jl*blowup*nxb + j2b*nxb) = cval;
                }
            }
        }
        
        /* Upper left corner */
        il = 0;
        jl = nyl - 1;
        cval = *(data_in + il + jl*nxl);          /* Data value in lower left corner */
        if(!close_enough( cval, fill_val )) {
            /* Fill in upper left corner */
            for(j2b=offset_yb; j2b<blowup; j2b++) {
                for(i2b=0; i2b<=offset_xb; i2b++) {
                    if(il*blowup + i2b + jl*blowup*nxb + j2b*nxb >= array_size) {
                        printf("expand_data: mem error 015\n" );
                        exit(-1);
                    }
                    *(big_data + il*blowup + i2b + jl*blowup*nxb + j2b*nxb) = cval;
                }
            }
        }
        
        /* Paint missing value blocks */
        for(jl=0; jl<nyl; jl++) {
            for(il=0; il<nxl; il++) {
                base_val  = *(data_in + il + jl*nxl);
                if(close_enough( base_val, fill_val )) {
                    for(j2b=0; j2b<blowup; j2b++) {
                        for(i2b=0; i2b<blowup; i2b++) {
                            if(il*blowup+i2b + jl*nxb*blowup + j2b*nxb >= array_size) {
                                printf("expand_data: mem error 016\n" );
                                exit(-1);
                            }
                            *(big_data + il*blowup+i2b + jl*nxb*blowup + j2b*nxb ) = base_val;
                        }
                    }
                }
            }
        }
    }
}
