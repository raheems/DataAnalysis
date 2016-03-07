
/*
Module 13: Mixture Designs.sas
*/

/* 
Example 1: Montegomery Ex 11.5
page. 469

Cornell (2002) describes a mixture experiment in which three
components--polythelyne (x1), polystyrene (x2), and 
polypropylene (x3)--were blended to form fiber that will be
spun into yarn for draperies.

The response variable was yarn elongation in kilograms of 
force applied. 

A {3, 2} simplex lattice design was used to study the product.
The design and the observed responses are shown in Table.

Notice that all of the design points involve either pure blend
or binary blends; that is, only two of the three components
were used in any formulation of the product. 

Replicate observations were run; two at each of the pure blends,
and three replicates at each of the binary blends. 

*/	

data yarn;
input x1 x2 x3 y;
cards;
1 0 0 11
1 0 0 12.4
.5 .5 0 15
.5 .5 0 14.8
.5 .5 0 16.1
0 1 0 8.8
0 1 0 10
0 .5 .5 10
0 .5 .5 9.7
0 .5 .5 11.8
0 0 1 16.8
0 0 1 16
.5 0 .5 17.7
.5 0 .5 16.4
.5 0 .5 16.6
;
run;

title 'Yarn Elongation Data';
proc print data=yarn; run; title;



/* Example 2 from Lawson (2010), page 461  */
data form;
input x1 x2 x3 y;
datalines;
1.0 0 0 48.7
.8 .1 .1 49.5
.6 .2 .2 50.2
.5 0 .5 52.8
.5 .5 0 49.3
.333333 .333333 .333334 51.1
.3 .2 .5 52.7
.3 .5 .2 50.3
.1 .1 .8 60.7
.1 .8 .1 49.9
0 0 1.0 64.9
0 .5 .5 53.5
0 1.0 0 50.6
proc glm data=form;
model y=x1 x2 x1*x2 x1*x3 x2*x3/solution;
estimate 'beta1' intercept 1 x1 1;
estimate 'beta2' intercept 1 x2 1;
estimate 'beta3' intercept 1;
run;
