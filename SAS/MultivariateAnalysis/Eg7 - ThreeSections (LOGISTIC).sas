
ods html close;
ods html;


* Logistic regression with the Three Section Data;
* The outcome variable 'section' is recoded to take 
two possible values: 1=section 1 and 2=Other;

proc format;
value sectionf 1='Section 1' 2='Section 2' 3='Section 3';
run;

data ThreeSec;
input section quiz midterm final;
format section sectionf.;
sec = 0;
if section=1 then sec=1;
cards;
1 70 70 80
1 73 67 75
1 59 68 85
1 93 77 76
1 82 80 90
1 90 60 81
1 66 67 88
1 72 72 76
1 69 66 74
1 80 84 67
2 60 82 81
2 66 80 88
2 59 85 93
2 72 75 80
2 82 77 88
2 87 73 80
2 77 95 86
2 69 90 87
2 80 75 92
2 90 76 89
3 90 85 89
3 91 80 89
3 87 92 99
3 77 93 89
3 82 88 87
3 78 87 92
3 80 90 99
3 82 87 89
3 77 79 93
3 83 84 86
;
run;

proc print; run;

* Running binary logsitic model;
proc logistic data = threesec;
class sec;
model sec (event = '1')  = quiz midterm final;
run;


/* Comparing the results after modeling sec=2 as the event of interest;
* Running binary logsitic model;
proc logistic data = threesec;
class sec;
model sec (event ='1') = quiz midterm final;
run;
*/

* Saving the output to a new data set with the predicted values;
proc logistic data = threesec;
class sec;
model sec (event ='1') = quiz midterm final;
output out=secout p=pred;
run;

* Printing the output data set;
proc print data=secout; 
run;


* Classification of observations to group (binary);
proc logistic data = threesec;
class sec;
model sec (event = '1') = quiz midterm final / ctable;
run;

/* Running multinomial logsitic model with the predicted values;
proc logistic data = threesec;
class sec;
model sec = quiz midterm final / ctable;
run;
*/


* Sequential logistic regression;
ods html close;
ods html;

* Stepwise selection method;
proc logistic data = threesec;
class sec;
model sec (event='1') = quiz midterm final / 
	risklimits
	selection=stepwise
	slentry=0.05
	slstay=0.05;
run;


* Assessing model fit and predictive ability;
proc logistic data = threesec;
class sec;
model sec (event='1') = midterm final / 
	risklimits
	details
	ctable
	outroc=roc1
	lackfit;
run;



* Model selection/comparison;
* Does Quiz improve model fit significantly over what is does with
midterm and final exam scores?;

* Model comparison: testing significance of 'quiz';
* We need fit two models-- one with and ther other without 'quiz' variable;

* Fit model with all three predictors;
proc logistic data = threesec;
class sec;
model sec (event='1') = quiz midterm final;
run;

* -2 Log L = 15. 633, df = 4;


* Fit model with midterm and final only;
proc logistic data = threesec;
class sec;
model sec (event='1') = midterm final;
run;

* -2 Log L = 15. 671, df = 3;

* Quantile function returns cumulative probability from a given distribution;
data c2;
x = quantile('chisquare', .95, 1);
run;
proc print;run;

* p-value calculation;
data c3; * Creating a new data set to store the p-value;
x = 1-probchi(.038, 1); * 0.038 is the difference in -2 log L, and 1 is the difference in df;
run;
proc print;run;
