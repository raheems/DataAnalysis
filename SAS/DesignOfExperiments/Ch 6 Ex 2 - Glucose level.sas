/******************************************************************
Two-Factor Completely Randomized Design Example.
Exercise 2 in Chapter 6, p.218
Concencentration of glucose were measured for two methods and 
three glucose levels.

Factor A: Methods: 1, 2
Factor B: Glucose levels: 1, 2, 3
******************************************************************/
/*
DM LOG 'clear';
DM OUTPUT 'clear';
*/

ods html close;
ods html;

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
Uncomment to route results to external file;
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
*/

proc glmpower data=glucose;
class level method;
model conc = level|method;
power
 stddev= 1 2.5 5
 ntotal= 18
 power=.;
 plot x=n min=18 max=60;
run;
