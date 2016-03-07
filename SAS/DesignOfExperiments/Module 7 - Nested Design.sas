
/*
Nested design : two-stage

Company buys raw materials in batches from three suppliers.
RQ: Is variability in purity due to variability among suppliers?

It is assumed that the supplier effect is fixed while raw materials
are random effects.

Ref: Montgomery Eg 14.1
*/

data quality;
input supplier batch purity;
cards;
1 1 94
1 1 92
1 1 93
1 2 91
1 2 90
1 2 89
1 3 91
1 3 93
1 3 94
1 4 94
1 4 97
1 4 93
2 1 94
2 1 91
2 1 90
2 2 93
2 2 97
2 2 95
2 3 92
2 3 93
2 3 91
2 4 93
2 4 96
2 4 95
3 1 95
3 1 97
3 1 93
3 2 91
3 2 93
3 2 95
3 3 94
3 3 92
3 3 95
3 4 96
3 4 95
3 4 94
;
run;

proc print; run;

/* Both supplier and batch are fixed effects;
proc glm;
class supplier batch;
model purity = supplier batch(supplier);
run;
*/

*ods html close;
*ods html;

* Supplier fixed and batch is random;
proc glm;
 class supplier batch;
 model purity = supplier batch(supplier) / ss3;
 random batch(supplier) / test;
 lsmeans supplier / stderr pdiff adjust=tukey;
run;
quit;



title2 'Incorrect analysis: Crossed Factors';
proc glm;
	class supplier batch;
	model purity = supplier batch supplier*batch / ss3;
	lsmeans supplier / stderr pdiff adjust=tukey;
run;
quit;


* Estimation of variance components;
Proc varcomp;
class supplier batch;
model purity = supplier batch(supplier) / fixed=1;
* by default all effects are assumed random unless 
specified otherwise by fixed=n option. Here fixed=n
indicates first n effect(s) are fixed;
run;



/*
EXAMPLE
Nested design
Ref: Kuehl, Exercise 7.3, p. 260 

The formulations of an alloy were prepared with
four separate castings for each formulation.
Two bars from each casting were tested for 
tensile strength. 

The data are tensile strengths of individual
bars. There are four castings nested within 
each alloy.

- Write a linear model for the experiment, 
assuming alloys as fixed effects, and
castings within alloys and bars within castings
as random effects. Exlain the terms, and 
compute the analysis of variace.

- Show the expected mean squares for the analysis

- Test the null hypothesis for alloy effects

- Comoute estimate means and the 95% CIs
for th emeans of each alloy

- Estimate the components of variance for 
castings and bars.

*/

data tensile;
input alloys $ castings bars strength;
cards;
A 1 1 13.2
A 1 2 15.5
A 2 1 15.2
A 2 2 15.0
A 3 1 14.8
A 3 2 14.2
A 4 1 14.6
A 4 2 15.1
B 1 1 17.1
B 1 2 16.7
B 2 1 16.5
B 2 2 17.3
B 3 1 16.1
B 3 2 15.4
B 4 1 17.4
B 4 2 16.8
C 1 1 14.1
C 1 2 14.8
C 2 1 13.2
C 2 2 13.9
C 3 1 14.5
C 3 2 14.7
C 4 1 13.8
C 4 2 13.5
;
run;

proc print; run;

*ods html close;
*ods html;

* Alloyes are fixed, all others are random;
proc glm;
 class alloys castings ;
 model strength = alloys castings(alloys)/ ss3;
 random castings(alloys) / test;
 *test h=supplier e=batch(supplier);
 lsmeans alloys / cl stderr;
run;
quit;

/*
See more on the options test h= e= in SAS Docs
http://support.sas.com/documentation/cdl/en/statug/63347/HTML/default/viewer.htm#statug_glm_sect024.htm
READ THE CAUTIONARY NOTE IN THE DOCUMENTATION
FOR TEST H= E= OPTIONS;
*/


* Estimation of variance components;
Proc varcomp;
class alloys castings;
model strength = alloys castings(alloys) / fixed=1;
* by default all effects are assumed random unless 
specified otherwise by fixed=n option. Here fixed=n
indicates first n effect(s) are fixed;
run;


/*
EXAMPLE 7.5 of Kuehl, p. 251
*/

data glucose;
input concen day run yield;
cards;
1 1 1 41.2
1 1 1 42.6
1 1 2 41.2
1 1 2 41.4
2 1 1 135.7
2 1 1 136.8
2 1 2 143.0
2 1 2 143.3
3 1 1 163.2
3 1 1 163.3
3 1 2 181.4
3 1 2 180.3
1 2 3 39.8
1 2 3 40.3
1 2 4 41.5
1 2 4 43.0
2 2 3 132.4
2 2 3 130.3
2 2 4 134.4
2 2 4 130.0
3 2 3 173.6
3 2 3 173.9
3 2 4 174.9
3 2 4 175.6
1 3 5 41.9
1 3 5 42.7
1 3 6 45.5
1 3 6 44.7
2 3 5 137.4
2 3 5 135.2
2 3 6 141.1
2 3 6 139.1
3 3 5 166.6
3 3 5 165.5
3 3 6 175.0
3 3 6 172.0
;
run;

proc print; run;

title;
* Need to work here on the calculation of 
test statistic for day effect;
proc glm;
class concen day run ;
model yield = concen day run(day) concen*day concen*run(day) / ss3;
random day run(day) concen*day concen*run(day) / test;
run;
quit;

*/
