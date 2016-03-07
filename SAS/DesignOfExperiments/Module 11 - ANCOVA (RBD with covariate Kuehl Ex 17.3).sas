
/* 
Exercise 17.3 of Kuehl, p. 573
*/

proc format;
value irrif
	1="15.8 in"
	2="24.0 in"
	3="28.5 in"
;
run;

data plant;
input block irrigation y x;
format irrigation irrif.;
cards;
1 1 1.5 45
2 1 3.1 58
3 1 3.8 61
4 1 3.3 59
1 2 1.9 54
2 2 1.8 57
3 2 2.9 55
4 2 2.3 56
1 3 1.1 43
2 3 1.8 60
3 3 3.7 71
4 3 1.8 48
run;
 proc print; run;

* Scatterplot of the data;
proc gplot data = plant;
plot x*y;
run;

* Calculate correlation between the scores and gpa;
proc corr data = plant;
var x  y;
run;

* Unadjusted analysis;
proc glm data = plant  plots = diagnostics;
class block irrigation;
model Y = irrigation block ;
run;
quit;

* Adjusted Analysis;
proc glm data = plant  plots = diagnostics;
class block irrigation;
model Y = x block irrigation;
* (unadjusted) treatment means;
means irrigation;
* (adjusted) treatment means;
lsmeans irrigation / cl pdiff adjust=dunnett;
run;
quit;


* Testing for homogeneity of regression;
proc glm data = plant  plots = diagnostics;
class block irrigation;
model Y = x block irrigation x*irrigation;
run;
quit;


proc glm data = plant  plots = diagnostics;
class block irrigation;
model Y = x block  x*irrigation irrigation;
run;
quit;
