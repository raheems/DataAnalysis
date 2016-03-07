
/* 
Regression and Correlation
*/

* Importing SAS data sets;
* SAS data sets have extension .sas7bdat;

libname mydata 'C:\Users\Raheem\Documents\MyFolder\UNCO\teaching\SRM 610\Core Materials\SAS Programs and Data Sets';
data lung;
set mydata.lung;
run;

* Get an overall information about the data set;
proc contents data=lung;
run;

* Print only first 5 rows of data;
proc print data=lung (obs=5);
run;

proc freq data=lung;
run;

* Another way to import this data set;
filename lungdata "C:\Users\Raheem\Documents\MyFolder\
UNCO\teaching\SRM 610\Core Materials\
SAS Programs and Data Sets\Lung.txt";

data lung;
infile lungdata;
input 
ID AREA FSEX FAGE FHEIGHT FWEIGHT FFVC FFEV1 
MSEX MAGE MHEIGHT MWEIGHT MFVC MFEV1 OCSEX OCAGE 
OCHEIGHT OCWEIGHT OCFVC OCFEV1 MCSEX MCAGE 
MCHEIGHT MCWEIGHT MCFVC MCFEV1 YCSEX YCAGE 
YCHEIGHT YCWEIGHT YCFVC YCFEV1
;
label 
	fheight="Father's Height"
	ffev1 ="Father's FEV1"
	;
run;

proc print data=lung (obs=5);
run;


proc format ;
   value AREA /* area */
      1 = 'Burbank'  
      2 = 'Lancaster'  
      3 = 'Long Beach'  
      4 = 'Glendora' ;
   value FSEX /* sex of father */
      1 = 'male' ;
   value MSEX /* sex of mother */
      2 = 'female' ;
   value OCSEX /* sex, oldest child */
      1 = 'male'  
      2 = 'female' ;
run;


/*
proc datasets ;
modify lung;
   format      AREA AREA.;
   format      FSEX FSEX.;
   format      MSEX MSEX.;
   format     OCSEX OCSEX.;
run;
quit;
*/

* Scatterplot;

proc sgscatter data=lung;
 plot ffev1*fheight;
run; 

* Scatterplot with regression line;
proc sgplot data=lung;
 reg x=fheight y=ffev1 / lineattrs=(color=red thickness=2);
 Title "Scatter plot and regression line: height(X-axis) and FEV1(Y-axis)";
run;


* Correlation coefficient between FEV1 and Height;
ods trace on;
proc corr data=lung;
var FFEV1 FHEIGHT;
run;

* Regression line;
proc glm data = lung plots=all ;
model ffev1 = fheight / clparm;
run;
quit;


* Diagnostic Plots;
* Regression of Internet Use on GDP;
* ods trace on;

ods select FitStatistics OverallANOVA
ParameterEstimates
DiagnosticsPanel
ResidualPlots
ResidualHistogram
QQPlot
RStudentByPredicted
;

proc glm data = lung plots(unpack)=all;
model ffev1 = fheight;
run;
quit;



/* 
Multiple regression
*/

ods trace on;

* Scatterplot matrix;

proc sgscatter data=lung;
  title "Scatterplot Matrix for Lung Data";
  matrix FFEV1 FHEIGHT FAGE;
run; title;


* Partial correlation;
proc corr data=lung;
   var ffev1 fheight;
   partial fage;
run;

* Partial correlation with prediction ellipse;
proc corr data=lung plots=scatter(alpha=.20 .30);
   var ffev1 fheight;
   partial fage;
run;


ods select FitStatistics OverallANOVA
ParameterEstimates
DiagnosticsPanel
ResidualPlots
ResidualHistogram
QQPlot
RStudentByPredicted
;

proc glm data=lung plots(unpack)=all;
model ffev1 = fheight fage / clparm;
run; quit;


proc sgscatter data=lung;                                                                                    
   title "Multi-Celled Scatter Plot Using an Attribute Map";                                                                            
   plot (FFEV1 fage)*(fage fheight)                                                                               
        / attrid=myid                                                                                                     
          reg=(nogroup degree=2 lineattrs=(color=gray));                                                                                
run;     



/*
EXERCISE PROBLEMS FOR MODULE 3
REGRESSION AND CORRELATION
*/

/*
Use the lung function data set and perform a regression 
analysis of weight on height for fathers and for the mothers. 
That is, develop a model taking weight at the outcome 
variable and the height as the predictor variable. 
Test that the coefficients are significantly different 
from zero for both fathers and mothers. 

When you test for significance, you must write the 
hypothesis in terms of statistical notation and then 
provide appropriate tables and SAS output.  
*/

* Analysis for fathers;
proc glm data=lung plots(unpack)=diagnostics;
model fweight = fheight / clparm;
run; 
quit;

* Analysis for mothers;
proc glm data=lung plots(unpack)=diagnostics;
model mweight = mheight / clparm;
run; 
quit;


/*
Repeat the problem in Exercise~\ref{exer:lung:father:mother:simple} 
using {\tt log(weight)} and {\tt log(height)} for fathers and mothers. 
Using graphical and numerical tools, decide if the transformations help.
*/

* Analysis for fathers with transformed variables;
* this data set contains transformed variables;
data lung2; 
set lung;
* Create new variables for fathers;
fweight2 = log(fweight); 
fheight2 = log(fheight); 

* Create new variables for mothers;
mweight2 = log(mweight); 
mheight2 = log(mheight);
run;

* Regression model for fathers
with transformed variables;
proc glm data=lung2 plots(unpack)=diagnostics;
model fweight2 = fheight2 / clparm;
run; 
quit;

* Regression model for mothers
with transformed variables;
proc glm data=lung2 plots(unpack)=diagnostics;
model mweight2 = mheight2 / clparm;
run; 
quit;

/*
Using the depression data set, perform a regression analysis 
of depression, as measured by CESD, on income. That is, 
use the CESD as the outcome variable and INCOME as the 
predictor variable. Plot the residuals. Does the normality 
assumption appear to be met? Repeat using the logarithm of 
CESD instead of CESD. Is the fit improved?
*/

* First, read the data from SAS data set;
libname mydata 'C:\Users\Raheem\Documents\MyFolder\UNCO\
teaching\SRM 610\Core Materials\SAS Programs and Data Sets';
data depress;
set mydata.depress;
run;

proc glm data=depress plots(unpack)=diagnostics;
model CESD = INCOME / clparm;
run; 
quit;

/*
From the depression data set, obtain the prediction 
equation to predict the level of depression as given by CESD, 
using INCOME and AGE as independent variables. 
Analyze the residuals and decide whether or not it is 
reasonable to assume that they follow a normal distribution.
*/

proc glm data=depress plots(unpack)=diagnostics;
model cesd = income age / clparm;
run;
quit;

