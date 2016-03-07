/*
Research Objective: Whether or not different flavors of ice cream 
melt at different speed. 

A random sample of three flavors was selected from a large population of flavors. 
The theoretical population is therefore the population of all flavors that 
could be made with ingredients similar to those flavors available.

The three flavors were stored in the same freezer in similar-sized 
containers. One teaspoonful of ice cream was taken from freezer and 
the melting time at room temp was recorded.

11 observations were taken on each flavor of ice creams.

*/

*ods html close;
*ods html;

data ice;
input flavor time runorder;
cards;
1 924 1
1 876 2
1 1150 5
1 1053 7
1 1041 10
1 1037 12
1 1125 15
1 1075 16
1 1066 20
1 977 22
1 886 25
2 891 3
2 982 4
2 1041 8
2 1135 13
2 1019 14
2 1093 18
2 994 27
2 960 30
2 889 31
2 967 32
2 838 33
3 817 6
3 1032 9
3 844 11
3 841 17
3 785 19
3 823 21
3 846 23
3 840 24
3 848 26
3 848 28
3 832 29
;
run;

* Print the data;
title 'Ice Cream Data';
proc print data=ice;
run;
title;


title1 'Plot of the data';
proc gplot data=ice;
plot time*flavor; /* y by x */
run;
title;

* Alternatively use this procedure;
proc sgplot data=ice;
scatter  x=flavor y=time;
run;



*Calculate the means and plot them;
* Calculate means and save the data in 
another data set called 'iceout';
proc means data=ice;
output out=iceout mean=avtime;
var time;
by flavor;

/* Alternatively run this;

proc means data=ice;
class flavor;
var time;
run;

*/

* Print iceout data set;
proc print data = iceout;
run;

* Plot the means of melting time;
symbol1 v=circle i=join c=black;
proc gplot data=iceout;
plot avtime*flavor;
run;


* ANOVA - Fixed-effects model;
proc glm data=ice;
class flavor;
model time= flavor;
run;
quit;

* ANOVA - Random-effects model;
proc glm data=ice;
class flavor;
model time= flavor;
random flavor /test;
lsmeans flavor;
run;
quit;

* Another way of estimating variance components;
proc varcomp data=ice;
class flavor;
model time=flavor;
run;

* Has more options than PROC GLM and PROC VARCOMP;
proc mixed data=ice cl alpha=.01;
class flavor;
model time=; 
random flavor / vcorr;
run;
