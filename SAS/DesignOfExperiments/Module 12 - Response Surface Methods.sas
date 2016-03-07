
/*
Module 12 - Response Surface Methods.sas
Enayetur Raheem
Last modified: April 14, 2015
*/

/* SAS Example of Contour plot */

proc contents data=sashelp.lake;
run;

proc print data=sashelp.lake;
run;

proc gcontour data=sashelp.lake;
    plot length*width=depth;
run;
quit;

/* 
EXAMPLE 1

Effect of hours spent on reviewing materials
and doing homework problems on final score.
Fictious data for demonstration purposes only
*/
data hw;
input review hw score;
cards;
1	1	70
1	2	72
2	2	72
2	3	80
3	2	77
3	4	80
3	6	88
3	6	82
3	6	79
2	6	84
2	6	84
;
run;

proc print; run;

* Regression with contour plot (no interaction);
proc glm data=hw;
model score = review hw;
run;

* Contour plot with interaction 
using PROC GLM;
proc glm data=hw;
model score = review|hw;
run;
quit;


* Contour plot with interaction using RSREG; 
proc rsreg data=hw plots=(surface(3d overlaypairs)); 
model score = review hw;
run;


  
/* 
EXAMPLE 2

Exercise from Dean and Voss, p. 590
An experiment was conducted to study the effects of drying time (hours)
and temperature(deg celsius) on the content y (ppm) of undesirable
compounds in resin. 

a) Determine the coded levels of time and temperature
b) Fit a second order model
c) Test for lack of fit
d) Check for homogeneity of variance and normality of errors
e) Conduct canonical analysis
f) Conduct ANOVA
g) Summarize the results

*/

data resin;
input time temp y;
cards;
7 232.4 18.5
3 220 22.5
11 220 17.2
1.3 190 42.2
7 190 28.6
7 190 19.8
7 190 23.6
7 190 24.1
7 190 24.2
12.7 190 19.1
3 160 54.1
11 160 33.8
7 147 55.4
;
run;

title 'Resin Data';
proc print; run;
title;


proc univariate data=resin;
var time temp;
run;


* Response surface analysis;
* lack of fit test;
ods graphics on;

title 'Response Surface Analysis of Resin Impurity';
proc rsreg data=resin plots=(surface(3d overlaypairs)); 
model y = time temp / lackfit;
run;


* with contour plot;
proc rsreg data=resin plots=(surface); 
model y= time temp /lackfit; 
run;


* with 3D surface plot instead of contour plot;
proc rsreg data=resin plots=(surface(3d lines)); 
model y= time temp /lackfit; 
run;


* Tests for model assumptions;
proc rsreg data=resin plots=all; 
model y= time temp /lackfit; 
run;


* Ridge analysis;
title 'Response Surface Analysis of Resin Impurity';
proc rsreg data=resin plots=(surface(3d overlaypairs)); 
model y = time temp / lackfit;
ridge min; *Our objective is to minimize y; 
run;

/*
EXAMPLE 3

Copper pattern platting example.
Ref: Dean and Voss, p. 558

G.K.K. Poon (1995) conducted a sequence of fractional
factorial and response surface experiments each involving
as many as seven factors to minimize the coating
thickness variation of an acide copper-platting process.

In the final experiments, conducted in the vicinity of
minimim thickness variation, response surface methods
were utilized to study the effects of anode-cathode
separation (factor A) and cathodic current density
(factor B) on the standard deviation of coating thickness.

The experiment used factorial points of a single replicated
2^2 design, augmented by two center points. 

The response was the standard deviation in (mu m) of 
copper-platting thickness. 

The uncoded factor levels and the response are given in the
code below.
*/

* Copper data with two center points;
data copper;
input ancasep curden y;
cards;
9.5 31 5.6 
9.5 41 6.45 
11.5 31 4.84 
11.5 41 5.19 
10.5 36 4.32 
10.5 36 4.25
;
run;

proc print;run;

title;

* To see why a qudratic model is not possible
to fit with 6 observations, try the proc glm
with cross product term only;
proc glm data=copper;
model y = ancasep curden ancasep*curden;
run;

* Response surface analysis;
proc rsreg data=copper; 
model y = ancasep curden; 
run;


* Response surface analysis with LOF test;
proc rsreg data=copper; 
model y = ancasep curden /lackfit; 
run;

/*
Since there is significant lack of fit of the 
first-order model, additional observations
were taken to fit a second-order model. 

The researcher augmented the first-order design
with four axial points using (n)^(1/4)= (4)^(1/4)=sqrt(2)

Data (copper2) is now showing with the center points
and axial points added.
*/

title 'Uncoded variables in copper-platting experiment';
data copper2;
input ancasep curden y;
cards;
9.5 31 5.6 
9.5 41 6.45 
11.5 31 4.84 
11.5 41 5.19 
10.5 36 4.32 
10.5 36 4.25
9 36 5.76 
12 36 4.42 
10.5 29 5.46 
10.5 43 5.81
;
run;
title;

proc print; run;

* Response surface analysis;
proc rsreg data=copper2; 
model y = ancasep curden /lackfit; 
run;


* Response surface analysis;
* with 3D surface plots;
proc rsreg data=copper2 plots=(surface(3d lines)); 
model y=ancasep curden /lackfit; 
run;

* Response surface analysis;
* with surface/contour plots;
proc rsreg data=copper2 plots=(surface(overlaypairs)); 
model y = ancasep curden /lackfit; 
run;

* Ridge Analysis;
proc rsreg data=copper2 plots=(surface(overlaypairs)); 
model y = ancasep curden /lackfit; 
ridge min;
run;


