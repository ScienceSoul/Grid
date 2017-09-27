/*
 *  memory.c
 *  FlowErosModel alpha 3.
 *
 *  Created by Hakime SEDDIK on Thu Mar 11 2004.
 *  Copyright © 2004 ScienceSoul. All rights reserved.
 *
 */

#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>

#include "memory.h"

#define FI_END 1
#define FREE_ARG char*

unsigned char *uns_charvec(long nl, long nh) {

    unsigned char *v;
	
	v = (unsigned char *)malloc((size_t) ((nh-nl+1+FI_END)*sizeof(unsigned char)));
	if (!v) errorfunct("Allocation failure for the unsigned char vector");
	return v-nl+FI_END;
}

GLubyte *GLubytevec(long nl, long nh) {
    
    GLubyte *v;
	
	v = (GLubyte *)malloc((size_t) ((nh-nl+1+FI_END)*sizeof(GLubyte)));
	if (!v) errorfunct("Allocation failure for the GLubyte vector");
	return v-nl+FI_END;
}

int *intvec(long nl, long nh) {
	int *v;
	
	v = (int *)malloc((size_t) ((nh-nl+1+FI_END)*sizeof(int)));
	if (!v) errorfunct("Allocation failure for the integer vector");
	return v-nl+FI_END;
}

double *doublevec(long nl, long nh) {
	
	double *v;
	
	v = (double *)malloc((size_t) ((nh-nl+1+FI_END)*sizeof(double)));
	if (!v) errorfunct("Allocation failure for the double vector");
	
	return v-nl+FI_END;
}

float *floatvec(long nl, long nh) {
	float *v;
	
	v = (float *)malloc((size_t) ((nh-nl+1+FI_END)*sizeof(float)));
	if (!v) errorfunct("Allocation failure for the float vector");
	
	return v-nl+FI_END;
}

double **doublematrix(long nrl, long nrh, long ncl, long nch) {
	long i, nrow=nrh-nrl+1, ncol=nch-ncl+1;
	double **m;
	
	m = (double **) malloc((size_t) ((nrow+FI_END)*sizeof(double*)));
	if (!m) errorfunct("Allocation failure for the double matrix 1");
	m += FI_END;
	m -= nrl;
	
	m[nrl]=(double *) malloc((size_t) ((nrow*ncol+FI_END)*sizeof(double)));
	if (!m[nrl]) errorfunct("Allocation failure for the double matrix 2");
	m[nrl] += FI_END;
	m[nrl] -= ncl;
	
	for(i=nrl+1;i<=nrh;i++) m[i]=m[i-1]+ncol;
	
	return m;
}

float **floatmatrix(long nrl, long nrh, long ncl, long nch) {
	long i, nrow=nrh-nrl+1, ncol=nch-ncl+1;
	float **m;
	
	m = (float **) malloc((size_t) ((nrow+FI_END)*sizeof(float*)));
	if (!m) errorfunct("Allocation failure for the float matrix 1");
	m += FI_END;
	m -= nrl;
	
	m[nrl]=(float *) malloc((size_t) ((nrow*ncol+FI_END)*sizeof(float)));
	if (!m[nrl]) errorfunct("Allocation failure for the float matrix 2");
	m[nrl] += FI_END;
	m[nrl] -= ncl;
	
	for(i=nrl+1;i<=nrh;i++) m[i]=m[i-1]+ncol;
	
	return m;
}

int **intmatrix(long nrl, long nrh, long ncl, long nch) {
	
	long i, nrow=nrh-nrl+1, ncol=nch-ncl+1;
	int **m;
	
	m = (int **) malloc((size_t) ((nrow+FI_END)*sizeof(int*)));
	if (!m) errorfunct("Allocation failure for the integer matrix 1");
	m += FI_END;
	m -= nrl;
	
	m[nrl] = (int *) malloc((size_t) ((nrow*ncol+FI_END)*sizeof(int)));
	if (!m[nrl]) errorfunct("Allocation failure for the integer matrix 2");
	m[nrl] += FI_END;
	m[nrl] -= ncl;
	
	for (i=nrl+1;i<=nrh;i++) m[i]=m[i-1]+ncol;
	
	return m;
}

double ***d3tensor(long nrl, long nrh, long ncl, long nch, long ndl, long ngh) {
	long i, j, nrow=nrh-nrl+1, ncol=nch-ncl+1, ndep=ngh-ndl+1;
	double ***t;
	
	/*Allocate pointers to pointers to rows*/
	t = (double ***) malloc((size_t) ((nrow+FI_END)*sizeof(double**)));
	if (!t) errorfunct("Allocation failure 1 in d3tensor()");
	t += FI_END;
	t -= nrl;
	
	/*Alocate pointers to rows and set pointers to them*/
	t[nrl] = (double **) malloc((size_t) ((nrow*ncol+FI_END)*sizeof(double*)));
	if (!t[nrl]) errorfunct("Allocation failure 2 in d3tensor()");
	t[nrl] += FI_END;
	t[nrl] -= ncl;
	
	/*Allocate rows and set pointers to them*/
	t[nrl][ncl] = (double *) malloc((size_t) ((nrow*ncol*ndep+FI_END)*sizeof(double)));
	if (!t[nrl][ncl]) errorfunct("Allocation failure 3 in d3tensor()");
	t[nrl][ncl] += FI_END;
	t[nrl][ncl] -= ndl;
	
	for (j=ncl+1; j<=nch; j++) t[nrl][j] = t[nrl][j-1]+ndep;
	for (i=nrl+1; i<=nrh; i++) {
		t[i] = t[i-1]+ncol;
		t[i][ncl] = t[i-1][ncl]+ncol*ndep;
		for (j=ncl+1; j<=nch; j++) t[i][j]=t[i][j-1]+ndep;
	}
	
	/*Return pointer to array of pointers to rows*/
	return t;	    
}

float ***f3tensor(long nrl, long nrh, long ncl, long nch, long ndl, long ngh) {
	long i, j, nrow=nrh-nrl+1, ncol=nch-ncl+1, ndep=ngh-ndl+1;
	float ***t;
	
	/*Allocate pointers to pointers to rows*/
	t = (float ***) malloc((size_t) ((nrow+FI_END)*sizeof(float**)));
	if (!t) errorfunct("Allocation failure 1 in f3tensor()");
	t += FI_END;
	t -= nrl;
	
	/*Alocate pointers to rows and set pointers to them*/
	t[nrl] = (float **) malloc((size_t) ((nrow*ncol+FI_END)*sizeof(float*)));
	if (!t[nrl]) errorfunct("Allocation failure 2 in f3tensor()");
	t[nrl] += FI_END;
	t[nrl] -= ncl;
	
	/*Allocate rows and set pointers to them*/
	t[nrl][ncl] = (float *) malloc((size_t) ((nrow*ncol*ndep+FI_END)*sizeof(float)));
	if (!t[nrl][ncl]) errorfunct("Allocation failure 3 in f3tensor()");
	t[nrl][ncl] += FI_END;
	t[nrl][ncl] -= ndl;
	
	for (j=ncl+1; j<=nch; j++) t[nrl][j] = t[nrl][j-1]+ndep;
	for (i=nrl+1; i<=nrh; i++) {
		t[i] = t[i-1]+ncol;
		t[i][ncl] = t[i-1][ncl]+ncol*ndep;
		for (j=ncl+1; j<=nch; j++) t[i][j]=t[i][j-1]+ndep;
	}
	
	/*Return pointer to array of pointers to rows*/
	return t;
}

int ***i3tensor(long nrl, long nrh, long ncl, long nch, long ndl, long ngh) {
	long i, j, nrow=nrh-nrl+1, ncol=nch-ncl+1, ndep=ngh-ndl+1;
	int ***t;
	
	/*Allocate pointers to pointers to rows*/
	t = (int ***) malloc((size_t) ((nrow+FI_END)*sizeof(int**)));
	if (!t) errorfunct("Allocation failure 1 in i3tensor()");
	t += FI_END;
	t -= nrl;
	
	/*Alocate pointers to rows and set pointers to them*/
	t[nrl] = (int **) malloc((size_t) ((nrow*ncol+FI_END)*sizeof(int*)));
	if (!t[nrl]) errorfunct("Allocation failure 2 in i3tensor()");
	t[nrl] += FI_END;
	t[nrl] -= ncl;
	
	/*Allocate rows and set pointers to them*/
	t[nrl][ncl] = (int *) malloc((size_t) ((nrow*ncol*ndep+FI_END)*sizeof(int)));
	if (!t[nrl][ncl]) errorfunct("Allocation failure 3 in i3tensor()");
	t[nrl][ncl] += FI_END;
	t[nrl][ncl] -= ndl;
	
	for (j=ncl+1; j<=nch; j++) t[nrl][j] = t[nrl][j-1]+ndep;
	for (i=nrl+1; i<=nrh; i++) {
		t[i] = t[i-1]+ncol;
		t[i][ncl] = t[i-1][ncl]+ncol*ndep;
		for (j=ncl+1; j<=nch; j++) t[i][j]=t[i][j-1]+ndep;
	}
	
	/*Return pointer to array of pointers to rows*/
	return t;	    
}

void free_uns_cvector(unsigned char *v, long nl, long nh) {
	free((FREE_ARG) (v+nl-FI_END));
}

void free_GLubytevector(GLubyte *v, long nl, long nh) {
	free((FREE_ARG) (v+nl-FI_END));
}

void free_uns_ivector(unsigned int *v, long nl, long nh) {
	free((FREE_ARG) (v+nl-FI_END));
}

void free_dvector(double *v, long nl, long nh) {
	free((FREE_ARG) (v+nl-FI_END));
}

void free_fvector(float *v, long nl, long nh) {
	free((FREE_ARG) (v+nl-FI_END));
}

void free_ivector(int *v, long nl, long nh) {
	free((FREE_ARG) (v+nl-FI_END));
}

void free_dmatrix(double **m, long nrl, long nrh, long ncl, long nch) {
	free((FREE_ARG) (m[nrl]+ncl-FI_END));
	free((FREE_ARG) (m+nrl-FI_END));
}

void free_fmatrix(float **m, long nrl, long nrh, long ncl, long nch) {
	free((FREE_ARG) (m[nrl]+ncl-FI_END));
	free((FREE_ARG) (m+nrl-FI_END));
}

void free_imatrix(int **m, long nrl, long nrh, long ncl, long nch) {
	free((FREE_ARG) (m[nrl]+ncl-FI_END));
	free((FREE_ARG) (m+nrl-FI_END));
}

void free_d3tensor(double ***t, long nrl, long nrh, long ncl, long nch, long ndl, long ndh) {
	/*Free a double d3tensor allocated by d3tensor*/
	free((FREE_ARG) (t[nrl][ncl]+ndl-FI_END));
	free((FREE_ARG) (t[nrl]+ncl-FI_END));
	free((FREE_ARG) (t+nrl-FI_END));
}

void free_f3tensor(float ***t, long nrl, long nrh, long ncl, long nch, long ndl, long ndh) {
	/*Free a double d3tensor allocated by d3tensor*/
	free((FREE_ARG) (t[nrl][ncl]+ndl-FI_END));
	free((FREE_ARG) (t[nrl]+ncl-FI_END));
	free((FREE_ARG) (t+nrl-FI_END));
}

void free_i3tensor(int ***t, long nrl, long nrh, long ncl, long nch, long ndl, long ndh) {
	/*Free a double d3tensor allocated by d3tensor*/
	free((FREE_ARG) (t[nrl][ncl]+ndl-FI_END));
	free((FREE_ARG) (t[nrl]+ncl-FI_END));
	free((FREE_ARG) (t+nrl-FI_END));
}

void errorfunct(char message[]) {
	printf("One error occured in the process\n");
	printf("The error is:%s\n", message);
	printf("The programm will exit\n");
	exit(1);
}



