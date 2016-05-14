#define PERL_NO_GET_CONTEXT
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "const-c.inc"

typedef struct { double x, y; } GEOM_POINT;
typedef struct { double x, y, z; } GEOM_POINT_3D;

MODULE = Local::perlxs                PACKAGE = Local::perlxs                

INCLUDE: const-xs.inc

#include <math.h>

PROTOTYPES: DISABLE

double distance_point(x1,y1,x2,y2)
    double x1
    double y1
    double x2
    double y2

    CODE:
    double ret;
    ret = sqrt( pow(x1-x2, 2) + pow(y1-y2, 2) );
    RETVAL = ret;

    OUTPUT:
    RETVAL

void distance_ext_point(x1,y1,x2,y2)
    double x1
    double y1
    double x2
    double y2

    PPCODE:
    double dx = fabs(x1-x2);
    double dy = fabs(y1-y2);
    double dist = sqrt( pow(dx, 2) + pow(dy, 2) );

    PUSHs(sv_2mortal(newSVnv(dist)));
    PUSHs(sv_2mortal(newSVnv(dx)));
    PUSHs(sv_2mortal(newSVnv(dy)));

double distance_call_point()
    PPCODE:
    int count;
    double x1, y1, x2, y2;
    ENTER;
    SAVETMPS;
    PUSHMARK(SP);
    PUTBACK;
    count = call_pv("Local::perlxs::get_points", G_ARRAY|G_NOARGS);

    SPAGAIN;
    if (count != 4) croak("call get_points trouble\n");
    x1 = POPn;
    y1 = POPn;
    x2 = POPn;
    y2 = POPn;
    double dist = sqrt( pow(x1-x2, 2) + pow(y1-y2, 2) );
    FREETMPS;
    LEAVE;
    PUSHs(sv_2mortal(newSVnv(dist)));

double distance_call_arg_point()
    PPCODE:
    int count;
    double x1, y1, x2, y2;

    ENTER;
    SAVETMPS;

    PUSHMARK(SP);
    XPUSHs(sv_2mortal(newSViv(1)));
    PUTBACK;
    count = call_pv("Local::perlxs::get_points", G_ARRAY);
    SPAGAIN;
    if (count != 2) croak("call get_points trouble\n");
    x1 = POPn;
    y1 = POPn;

    PUSHMARK(SP);
    XPUSHs(sv_2mortal(newSViv(2)));
    PUTBACK;
    count = call_pv("Local::perlxs::get_points", G_ARRAY);
    SPAGAIN;
    if (count != 2) croak("call get_points trouble\n");
    x2 = POPn;
    y2 = POPn;

    double dist = sqrt( pow(x1-x2, 2) + pow(y1-y2, 2) );
    FREETMPS;
    LEAVE;
    PUSHs(sv_2mortal(newSVnv(dist)));

double distance_pointobj(r_point1, r_point2)
    SV *r_point1
    SV *r_point2
    PPCODE:
    double x1,y1,x2,y2;
    SV **_x1, **_y1, **_x2, **_y2, *_point1, *_point2;
    HV *point1, *point2;
    if(!(SvOK(r_point1) && SvROK(r_point1) && SvOK(r_point2) && SvROK(r_point2))){
        croak("Point must be a hashref");
    }
    _point1 = SvRV(r_point1); _point2 = SvRV(r_point2);
    if( SvTYPE(_point1) != SVt_PVHV || SvTYPE(_point2) != SVt_PVHV){
        croak("Point must be a hashref");
    }
    point1 = (HV*)_point1; point2 = (HV*)_point2;
    if(!(hv_exists(point1, "x", 1) && hv_exists(point2, "x", 1) && 
            hv_exists(point1, "y", 1) && hv_exists(point2, "y", 1))){
        croak("Point mush contain x and y keys");
    }
    _x1 = hv_fetch(point1, "x", 1, 0); _y1 = hv_fetch(point1, "y", 1, 0);
    _x2 = hv_fetch(point2, "x", 1, 0); _y2 = hv_fetch(point2, "y", 1, 0);
    if( !(_x1 && _x2 && _y1 && _y2)){ croak("Non allow NULL in x and y coords"); }
    x1 = SvNV(*_x1); x2 = SvNV(*_x2);
    y1 = SvNV(*_y1); y2 = SvNV(*_y2);
    PUSHs(sv_2mortal(newSVnv(sqrt( pow(x1-x2,2) + pow(y1-y2,2)))));


double distance_pointstruct(point1, point2)
    GEOM_POINT *point1
    GEOM_POINT *point2
    CODE:
    double ret;
    ret = sqrt( pow(point1->x-point2->x,2) + pow(point1->y-point2->y,2));
    free(point1);
    free(point2);
    RETVAL = ret;
    OUTPUT:
    RETVAL

double distance3d_pointstruct(point1, point2)
    GEOM_POINT_3D *point1
    GEOM_POINT_3D *point2
    CODE:
    double ret;
    ret = sqrt( pow(point1->x-point2->x,2) + pow(point1->y-point2->y,2) + pow(point1->z-point2->z,2));
    free(point1);
    free(point2);
    RETVAL = ret;
    OUTPUT:
    RETVAL



SV *matrix_multiply (matr1, matr2)
	SV * matr1
	SV * matr2
	
	CODE:
	AV *result_matr;
	AV *row;
	SSize_t numcols, numrows, midindex, n, m, k;
	if(!(SvOK(matr1) && SvROK(matr1) && (SvTYPE(SvRV(matr1))==SVt_PVAV))) {
		croak("First matrix argument must be an arrayref");
	}
	if(!(SvOK(matr2) && SvROK(matr2) && (SvTYPE(SvRV(matr2))==SVt_PVAV))){
		croak("Second matrix argument must be an arrayref");
	}
	numrows = av_top_index((AV*)SvRV(matr1));
	row = (AV*)(SvRV(*av_fetch((AV*)SvRV(matr1), 0, 0)));
	midindex = av_top_index(row);

	double m1[numrows+1][midindex+1];
	
	for (n=0; n<=numrows; n++) {
		row = (AV*)(SvRV(*av_fetch((AV*)SvRV(matr1), n, 0)));
		if (av_top_index(row) != midindex) {croak ("First matrix has rows of different lengths");}
		for (m=0; m<=midindex; m++) {
			m1[n][m] = SvNV(*av_fetch(row, m, 0));
		} 
	}
	
	if (midindex != av_top_index((AV*)SvRV(matr2))) {
		croak ("Matrix can't be multiplied because number of columns of first matrix differs from number of rows of second matrix");
	}
	row = (AV*)(SvRV(*av_fetch((AV*)SvRV(matr2), 0, 0)));
	numcols = av_top_index(row);
	
	//using the transposed representation for acceleration
	double m2[numcols+1][midindex+1];
	for (n=0; n<=midindex; n++) {
		row = (AV*)(SvRV(*av_fetch((AV*)SvRV(matr2), n, 0)));
		if (av_top_index(row) != numcols) {croak ("First matrix has rows of different lengths");}
		for (m=0; m<=numcols; m++) {
			m2[m][n] = SvNV(*av_fetch(row, m, 0));
		} 
	}
	
	//Calculating
	double result[numrows+1][numcols+1];
	for (n=0; n<=numrows; n++) {
		for (m=0; m<=numcols; m++) {
			result[n][m] = 0;
			for (k=0; k<=midindex; k++){
				result[n][m] += m1[n][k] * m2[m][k];
			}
		}
	}
	
	result_matr = (AV*)sv_2mortal((SV*)newAV());
	for (n=0; n<=numrows; n++) {
		row = (AV*)sv_2mortal((SV*)newAV()); 	
		for (m=0; m<=numcols; m++) {
			av_push(row, newSVnv(result[n][m]));
		}
		av_push(result_matr, newRV((SV*)row));
	}
	
	RETVAL = newRV((SV *)result_matr);
	OUTPUT:
	RETVAL
