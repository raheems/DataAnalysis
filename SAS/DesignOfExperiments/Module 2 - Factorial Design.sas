
/*
SAS Program file to go with Module 2 on Factorial Design;
File name: Module 2 - Factorial Design.sas
Created by: Enayetur Raheem

CONTENTS
Two exercies:
Exercise 6.2 p. 218 of Kuehl
Example 6.5 p. 200 of Kuehl
*/


/*
*******************************
Exercise 2 in Chapter 6, p.218
*******************************
Two-Factor Completely Randomized Design Example.

Concencentration of glucose were measured for two methods and 
three glucose levels.

Factor A: Methods: 1, 2
Factor B: Glucose levels: 1, 2, 3
*/

/*
DM LOG 'clear';
DM OUTPUT 'clear';
*/

*ods html close;
*ods html;

data glucose;
input level method conc;
cards;
1	1	42.5
1	1	43.3
1	1	42.9
1	2	39.8
1	2	40.3
1	2	41.2
2	1	138.4
2	1	144.4
2	1	142.7
2	2	132.4
2	2	132.4
2	2	130.3
3	1	180.9
3	1	180.5
3	1	183
3	2	176.8
3	2	173.6
3	2	174.9
;
run;


/* 
Uncomment ODS RTF statement to route results to external file;
If path is not given, it will be saved in the default path
where SAS was installed;

It is possible to change the current folder by going to
Tools > Options > Change Current Folder
and setting your folder of choice.
*/

*ODS RTF FILE="snails.rtf";

proc print data = glucose;
	var level method conc;
run;

* Analysis of Variance;
proc glm data = glucose plot=intplot;
class level method;
model conc = level|method / ss3;
* LSMEANS statement is better than means statement;
* LSMEANS statement performs multiple comparisons on 
interactions as well as main effects. MEANS works for main effects only;
lsmeans level method level*method / cl pdiff adjust=tukey plot=none; 

* Contrast comparisons;
contrast 'Level 1 vs 2 & 3' level -2 1 1;
contrast 'Method 1 vs 2' method 1 -1;

run;
quit;

*ODS RTF CLOSE;


/*
Sample Size and Power;
Exercise 6.2 Glucose Level Data;
*/

proc glmpower data=glucose;
class level method;
model conc = level method;
power
 stddev= 1 2.5 5
 ntotal= 18
 power=.;
 plot x=n min=18 max=60;
run;


/*
***********************
Example 6.5 of Kuehl.
***********************

Investigator wanted to know how water temperature, water salinity,
and density of shrimp populations influenced the growth rate 
of shrimp raised in aquaria and whether the factors acted independently
on the shrimp population.

Treatments: Three factors
Temperature: two levels (25C, 35C)
Salinity: three levels (10%, 25%, 40%)
Density of shrimp in the aquarium: two levels (80 shrimps/40 lit, 160/40 lit)
Replications: 3
Total obsevations: 36

Outcome: Four-week weight gain (mg)
*/

*ods html close;
*ods html;

data shrimp;
input temp salinity density t_level s_level d_level gain;
cards;
25	10	80	1	1	1	86
25	10	80	1	1	1	52
25	10	80	1	1	1	73
25	10	160	1	1	2	86
25	10	160	1	1	2	53
25	10	160	1	1	2	73
25	25	80	1	2	1	544
25	25	80	1	2	1	371
25	25	80	1	2	1	482
25	25	160	1	2	2	393
25	25	160	1	2	2	398
25	25	160	1	2	2	208
25	40	80	1	3	1	390
25	40	80	1	3	1	290
25	40	80	1	3	1	397
25	40	160	1	3	2	249
25	40	160	1	3	2	265
25	40	160	1	3	2	243
35	10	80	2	1	1	439
35	10	80	2	1	1	436
35	10	80	2	1	1	349
35	10	160	2	1	2	324
35	10	160	2	1	2	305
35	10	160	2	1	2	364
35	25	80	2	2	1	249
35	25	80	2	2	1	245
35	25	80	2	2	1	330
35	25	160	2	2	2	352
35	25	160	2	2	2	267
35	25	160	2	2	2	316
35	40	80	2	3	1	247
35	40	80	2	3	1	277
35	40	80	2	3	1	205
35	40	160	2	3	2	188
35	40	160	2	3	2	223
35	40	160	2	3	2	281
;
run;


proc print data=shrimp;
	*var temp salinity density gain;
run;

* Descriptive statistics;
* To obtain the cell means;
proc means data=shrimp;
class salinity temp;
var gain;
run;

* Calculating the marginal means for salinity and density;
proc glm data=shrimp;
class temp salinity density;
model gain = temp|salinity|density / ss3;
lsmeans salinity temp;
run;
quit;


* ANOVA;
proc glm data=shrimp;
class temp salinity density;
model gain = temp|salinity|density / ss3;
run;
quit;

* Examining two-factor interactions (temp*salinity);
proc glm data=shrimp plot=intplot;
class salinity temp ; * putting salinity on the x-axis;
model gain = salinity|temp / ss3;
run;
quit;

* Further examination of temp*salinity interaction;
* Slicing by salinity;
proc glm data=shrimp plot=intplot;
class salinity temp ; * putting salinity on the x-axis;
model gain = salinity|temp / ss3;
lsmeans salinity*temp / slice=salinity plot=none;
run;
quit;

* Using PROC MIXED and SLICE option
slicing by salinity;
proc mixed data=shrimp;
class salinity temp ; * putting salinity on the x-axis;
model gain = salinity|temp;
lsmeans salinity*temp / slice=salinity;
run;
quit;

* Using PROC MIXED and SLICE option
slicing by temp;
proc mixed data=shrimp;
class salinity temp ; * putting salinity on the x-axis;
model gain = salinity|temp;
lsmeans salinity*temp / slice=temp;
run;
quit;



* Three-factor interactions;
* Examining interactions;
proc glm data=shrimp;
class temp salinity density;
model gain = temp|salinity|density / ss3;
lsmeans temp*salinity*density / slice=temp*salinity plot=none; 
run;
quit;

* Slicing by temp*salinity using 
PROC MIXED;
proc mixed data=shrimp;
class temp salinity density;
model gain=temp|salinity|density;
lsmeans temp*salinity*density / slice=temp*salinity;
run; quit;

* Slicing by temp*density using PROC MIXED;
* Note: This is a test for salinity (which has 3 levels);
* Results not shown/discussed on the slides;
proc mixed data=shrimp;
class temp salinity density;
model gain=temp|salinity|density;
lsmeans temp*salinity*density / slice=temp*density;
run; quit;


/*
Comparison of cell means when significant 
interaction is present;
*/

* Two-factor case;
* Using PROC MIXED and SLICE option
slicing by temp with DIFF option;
proc mixed data=shrimp;
class salinity temp ; * putting salinity on the x-axis;
model gain = salinity|temp;
lsmeans salinity*temp / slice=salinity diff;
run;
quit;

* Three factor case;
* Slicing by temp*salinity using 
PROC MIXED with the DIFF option;
proc mixed data=shrimp;
class temp salinity density;
model gain=temp|salinity|density;
lsmeans temp*salinity*density / slice=temp*salinity diff;
run; quit;

/*
Power Analysis and Sample size calculation;
*/

* Getting the means;
ods trace on;
proc glm data=shrimp plot=intplot;
class salinity temp density ; * putting salinity on the x-axis;
model gain = salinity|temp|density / ss3;
lsmeans salinity|temp|density / plot=none;
run;
quit;
ods trace off;

* Saving the outpur file with the 
desired tables only; 
* In this case, we want to save the table whose
path is salinit_temp_density.LSMeans;
ods output where=(_path_ ? "salinit_temp_density.LSMeans" and  _name_='LSMeans')=shrimpmeans ;

proc glm data=shrimp ;
class salinity temp density ; * putting salinity on the x-axis;
model gain = salinity|temp|density / ss3;
lsmeans salinity|temp|density / plot=none;
run;quit;

ods output close;

* Print the data to verify if the 
right columns are there;
proc print data=shrimpmeans;
run; 

* Now apply PROC GLMPOWER on the 
shrimpmeans data set;
proc glmpower data=shrimpmeans;
class temp salinity density;
model gainLSmean=temp|salinity|density;
power
 stddev= 50
 ntotal= 24 to 60 by 6
 power=.;
 plot x=n min=20 max=100;
run;

* Using the main effects only;
proc glmpower data=shrimpmeans;
class temp salinity density;
model gainLSmean=temp salinity density;
power
 stddev= 40 50
 ntotal= 24 to 60 by 6
 power=.;
 plot x=n min=20 max=100;
run;
