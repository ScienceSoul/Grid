//
//  Timing.c
//  Grid
//
//  Created by Hakime Seddik on 14/09/11.
//  Copyright © 2011 ScienceSoul. All rights reserved.
//

#include <stdio.h>
#include <sys/file.h>
#include <sys/param.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <time.h> 
#include <mach/mach_time.h>

#include "Timing.h"

double machcore(uint64_t endTime, uint64_t startTime) {
    
	uint64_t difference = endTime - startTime;
	static double conversion = 0.0;
	double value = 0.0;
	
	if ( 0.0 == conversion ) {
		mach_timebase_info_data_t info;
		kern_return_t err = mach_timebase_info( &info );
		
		if ( 0 == err) {
			/* seconds */
			conversion = 1e-9 * (double) info.numer / (double) info.denom;
			/* nanoseconds */
			//conversion = (double) info.numer / (double) info.denom;
		}
	}
	
	value = conversion * (double) difference;
	return value;
}
