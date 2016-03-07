
/* 
Module 5 - MANOVA
File: NANOVA.sas 
*/


proc format;
 value BC 1="4000 B.C."
          2="3300 B.C."
          3="1850 B.C.";
run;


* Another way to read the data;
Data EgyptianSkulls;
  Skull+1;
 Input MaxBreadth BasHeight BasLength NasHeight TimePeriod;

 /* 
 LMaxBreadth=Log(MaxBreadth);
 LBasHeight=Log(BasHeight);
 LBasLength=Log(BasLength);
 LNasHeight=Log(NasHeight);
 */

Label MaxBreadth="Maximum Breadth of Skull (mm)"
       BasHeight ="Basibregmatic Height of Skull (mm)"
	   BasLength ="Basialveolar Length of Skull (mm)"
	   NasHeight ="Nasal Height of Skull (mm)"
	   TimePeriod="Time Period";
 Format TimePeriod BC.;
DataLines;
  131  138  89  49  1
  125  131  92  48  1
  131  132  99  50  1
  119  132  96  44  1
  136  143  100  54  1
  138  137  89  56  1
  139  130  108  48  1
  125  136  93  48  1
  131  134  102  51  1
  134  134  99  51  1
  129  138  95  50  1
  134  121  95  53  1
  126  129  109  51  1
  132  136  100  50  1
  141  140  100  51  1
  131  134  97  54  1
  135  137  103  50  1
  132  133  93  53  1
  139  136  96  50  1
  132  131  101  49  1
  126  133  102  51  1
  135  135  103  47  1
  134  124  93  53  1
  128  134  103  50  1
  130  130  104  49  1
  138  135  100  55  1
  128  132  93  53  1
  127  129  106  48  1
  131  136  114  54  1
  124  138  101  46  1
  124  138  101  48  2
  133  134  97  48  2
  138  134  98  45  2
  148  129  104  51  2
  126  124  95  45  2
  135  136  98  52  2
  132  145  100  54  2
  133  130  102  48  2
  131  134  96  50  2
  133  125  94  46  2
  133  136  103  53  2
  131  139  98  51  2
  131  136  99  56  2
  138  134  98  49  2
  130  136  104  53  2
  131  128  98  45  2
  138  129  107  53  2
  123  131  101  51 2
  130  129  105  47  2
  134  130  93  54  2
  137  136  106  49  2
  126  131  100  48  2
  135  136  97  52  2
  129  126  91  50  2
  134  139  101  49  2
  131  134  90  53  2
  132  130  104  50  2
  130  132  93  52  2
  135  132  98  54  2
  130  128  101  51  2
  137  141  96  52  3
  129  133  93  47  3
  132  138  87  48  3
  130  134  106  50  3
  134  134  96  45  3
  140  133  98  50  3
  138  138  95  47  3
  136  145  99  55  3
  136  131  92  46  3
  126  136  95  56  3
  137  129  100  53  3
  137  139  97  50  3
  136  126  101  50  3
  137  133  90  49  3
  129  142  104  47  3
  135  138  102  55  3
  129  135  92  50  3
  134  125  90  60  3
  138  134  96  51  3
  136  135  94  53  3
  132  130  91  52  3
  133  131  100  50  3
  138  137  94  51  3
  130  127  99  45  3
  136  133  91  49  3
  134  123  95  52  3
  136  137  101  54  3
  133  131  96  49  3
  138  133  100  55  3
  138  133  91  46  3
;
run;

Proc Print Data=EgyptianSkulls Label;
 Id Skull;
Run;

ods trace on;

* Read the data from file;
proc format;
 value BC 1="4000 B.C."
          2="3300 B.C."
          3="1850 B.C.";
run;
data skull;
infile "C:\Users\Raheem\Documents\MyFolder\UNCO\teaching\SRM 610\
Core Materials\SAS Programs and Data Sets\Skull.txt";

input MaxBreadth BasHeight BasLength NasHeight TimePeriod;

label MaxBreadth="Maximum Breadth of Skull (mm)"
       BasHeight ="Basibregmatic Height of Skull (mm)"
	   BasLength ="Basialveolar Length of Skull (mm)"
	   NasHeight ="Nasal Height of Skull (mm)"
	   TimePeriod="Time Period";

format TimePeriod BC.;
run;

proc print data=skull(obs=4);
run;

/*
* MANOVA for testing effect of time period on the 
* skull measurements.
* Use the ORDER=INTERNAL option so that contrast
* coefficients correspond correctly with the Time Periods.
*/

/*
RQ-1 
Is there a significance effect of TimePeriod 
-On the DVs separately (univariate)? 
-On the DVs combined (multivariate)?
*/

* RQ-1: this code produces both univariate (4 models)
and multivariate test results;

proc glm data=skull order = internal;
 class TimePeriod;
 model MaxBreadth BasHeight BasLength NasHeight = TimePeriod /ss3;
 manova h=TimePeriod / printe; *printe shows error SSCP matrix;
run;
quit;



/*
* RQ-2 a): 
Compare TimePeriod 3 with the average of the rest 
2 groups (univariate and multivariate tests taking 
all four DVs together)
*/

proc glm data=skull order = internal;
 class TimePeriod;
 model MaxBreadth BasHeight BasLength NasHeight = TimePeriod / nouni ss3;
 contrast '1&2 Vs 3' TimePeriod -1 -1 2;
 manova h=TimePeriod;
run;
quit;

/*
RQ - 2b)
Compare TimePeriods 1 and 3 (univariate and multivariate 
tests taking all four DVs together)
*/
proc glm data=skull order = internal;
 class TimePeriod;
 model MaxBreadth BasHeight BasLength NasHeight = TimePeriod / nouni ss3;
 contrast '1 Vs 3' TimePeriod 1 0 -1;
 manova h=TimePeriod;
run;
quit;

/*
RQ 2 c)

Testing contrast 1 vs 3 taking some of the DVs 
together (not all of them).

How do we decide which DVs to consider? 
-Run univariate pairwise comparisons first 
to detect potential DVs.

-In particular, run the following SAS codes
*/
proc glm data=skull order = internal;
 class TimePeriod;
 model MaxBreadth BasHeight BasLength NasHeight = TimePeriod 
/  ss3;
 contrast '1 Vs 3' TimePeriod 1 0 -1;
 *lsmeans TimePeriod / pdiff adjust=Tukey;
run;
quit;

/*
RQ - 3c) continues...

We see that  MaxBreadth (1) and BasLength (3) are 
significant on the contrast (TimePeriod 1 vs 3)

Thus, we may want to test the contrast taking 
MaxBreadh and BasLength together
*/

proc glm data=skull order = internal;
 class TimePeriod;
 model MaxBreadth BasHeight BasLength NasHeight = TimePeriod / nouni ss3;
 contrast '1 Vs 3' TimePeriod 1 0 -1;
 manova h=TimePeriod m=(1 0 0 0,
						0 0 0 0,
						0 0 1 0,
						0 0 0 0);
run;
quit;


* Multiple Comparisions;
* LSMEANS;
proc glm data=skull order = internal;
 class TimePeriod;
 model MaxBreadth BasHeight BasLength NasHeight = TimePeriod / ss3;
 lsmeans TimePeriod;
 run;
quit;


* Pairwise comparisons;
* LSMEANS with pdiff adjust=tykey;
proc glm data=EgyptianSkulls order = internal;
 class TimePeriod;
 model MaxBreadth BasHeight BasLength NasHeight = TimePeriod / ss3;
 lsmeans TimePeriod / pdiff adjust=Tukey cl;
 run;
quit;

* Pairwise comparisons;
* LSMEANS with pdiff adjust=tykey and adjusted CL for LSMEANS;
proc glm data=EgyptianSkulls order = internal;
 class TimePeriod;
 model MaxBreadth BasHeight BasLength NasHeight = TimePeriod / ss3;
 lsmeans TimePeriod / pdiff adjust=Tukey cl alpha=.0167;
 run;
quit;



/*
Residual Analysis :
Test for multivariate normality;
*/

* Saving Pairwise multiple comparisons;
proc glm data=skull order = internal;
 class TimePeriod;
 model MaxBreadth BasHeight BasLength NasHeight = TimePeriod / ss3;
 output out=egyptout r=r1-r4; /* output the residuals */
run;
quit;

proc print data=egyptout;
run;


/*
* Multivariate Normality Test for the variables in a data set;
* We will use a SAS macro located at:
* http://support.sas.com/kb/24/983.html
*/

* First, tell SAS where to look for the macro file;
%inc "multnorm.sas";

* Then run the macro file;
%multnorm(data=datafilename, var=var1 var2 var3, plot=mult)

* Requesting all plots;
%multnorm(data=datafilename, var=var1 var2 var3, plot=both)


* Testing Multivariate normality of the errors;
* You may use univariate tests for normality as well;

%multnorm(data = skull, 
var = MaxBreadth BasHeight BasLength NasHeight, 
plot = mult);

%multnorm(data=egyptout, var=r1 r2 r3 r4, plot=mult)

/*
Assumption:
Linearity of the DVs, IVs, and DV-IV paris;
*/

proc sgscatter data=skull;
matrix MaxBreadth BasHeight BasLength NasHeight;
run;

* Scatter plot matrix with regression plot;
* http://support.sas.com/kb/35/168.html;
proc sgscatter data=skull;
  plot (MaxBreadth BasHeight) * (BasLength NasHeight) / 
        group=TimePeriod reg=(nogroup clm degree=2) grid ;
run;


/*
Examine data for homogeneity of covariance matrices.
A large value of the test statistic indicates the assumption
of equal covariance is satisfied. As a result, the procedure
can pool the covariance matrices to obtain the pooled covariance
matrix.
*/

ods select ChiSq;
proc discrim Data=skull method=normal pool=test;
 class TimePeriod;
 var MaxBreadth BasHeight BasLength NasHeight;
run;

/*
Assumption: Homogeneity of regression or equal slope.
*/

proc sgpanel data=skull;
panelby TimePeriod;
reg x=MaxBreadth y=BasHeight /nomarkers cli degree=1;
scattter x=MaxBreadth y=BasHeight/ transparency=0.7;
run;

proc sgpanel data=skull;
panelby TimePeriod;
reg x=MaxBreadth y=BasLength /nomarkers cli degree=1;
scattter x=MaxBreadth y=BasLength/ transparency=0.7;
run;

proc sgpanel data=skull;
panelby TimePeriod;
reg x=MaxBreadth y=NasHeight /nomarkers cli degree=1;
scattter x=MaxBreadth y=NasHeight/ transparency=0.7;
run;


/*
Exercise - MANOVA.
Johnson and Wichern, 6/ed, Ex 6.31, page 353
*/

data penuts;
infile 'T6-17.dat';
input location variety yield SdMatKer SeedSize;
run;

proc print data=penuts;
run;

* Analysis of penuts data set 
including interaction term;
proc glm data=penuts;
 class location variety;
 model yield SdMatKer SeedSize = location variety location*variety;
 manova h = location variety location*variety;
 output out=penutsout r=r1-r3; /* output the residuals */
 run;
 quit;

* Test for univariate normality;
%multnorm(data=penutsout, var=r1 r2 r3, plot=both)
%multnorm(data=penuts, var=yield SdMatKer SeedSize, plot=both)



