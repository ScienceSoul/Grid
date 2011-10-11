//
//  maxmin.c
//  Grid
//
//  Created by Hakime Seddik on 28/09/11.
//  Copyright 2011 Institute of Low Temperature Science. All rights reserved.
//

#include <stdio.h>
#include "maxmin.h"

float computemax(float b[],int n)
{
    float max = 0.0;
    
    for(int c=0; c<n; c++)
    {
        if(b[c]>max)
            max=b[c];
    }
    return max;
}

float computemin(float b[],int n)
{
    float min = 1000000;
    
    for(int c=0; c<n; c++)
    {
        if(b[c]<min)
            min=b[c];
    }
    return min;
}
