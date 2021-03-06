/*
 *  memory.h
 *  FlowErosModel alpha 3.
 *
 *  Created by Hakime SEDDIK on Thu Mar 11 2004.
 *  Copyright © 2004 ScienceSoul. All rights reserved.
 *
 */

#import <GLUT/glut.h>

void errorfunct(char message[]);
unsigned char *uns_charvec(long nl, long nh);
GLubyte *GLubytevec(long nl, long nh);
int *intvec(long nl, long nh);
double *doublevec(long nl, long nh);
float *floatvec(long nl, long nh);
double **doublematrix(long nrl, long nrh, long ncl, long nch);
float **floatmatrix(long nrl, long nrh, long ncl, long nch);
double ***d3tensor(long nrl, long nrh, long ncl, long nch, long ndl, long ngh);
float ***f3tensor(long nrl, long nrh, long ncl, long nch, long ndl, long ngh);
int **intmatrix(long nrl, long nrh, long ncl, long nch);
int ***i3tensor(long nrl, long nrh, long ncl, long nch, long ndl, long ngh);
void free_uns_cvector(unsigned char *v, long nl, long nh);
void free_GLubytevector(GLubyte *v, long nl, long nh);
void free_uns_ivector(unsigned int *v, long nl, long nh);
void free_dvector(double *v, long nl, long nh);
void free_fvector(float *v, long nl, long nh);
void free_ivector(int *v, long nl, long nh);
void free_dmatrix(double **m, long nrl, long nrh, long ncl, long nch);
void free_fmatrix(float **m, long nrl, long nrh, long ncl, long nch);
void free_imatrix(int **m, long nrl, long nrh, long ncl, long nch);
void free_d3tensor(double ***t, long nrl, long nrh, long ncl, long nch, long ndl, long ndh);
void free_f3tensor(float ***t, long nrl, long nrh, long ncl, long nch, long ndl, long ndh);
void free_i3tensor(int ***t, long nrl, long nrh, long ncl, long nch, long ndl, long ndh);





