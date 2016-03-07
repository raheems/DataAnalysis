
*************************************************;
** Module 6 - Fractional Factorial Designs.sas **;
*************************************************;

/*
Creating Fractional Factorial Designs;
Let's start with a 2^3 fractional factorial design
in A, B, C
*/
proc factex;
   factors A B C;
   *size fraction=1;
   *model resolution=3;
   examine design aliasing confounding;
run;
quit;

* 2^3 design in standard order;
proc factex;
   factors C B A;
   examine design aliasing confounding;
   output out=orig23;
run;
quit;

* Reordering the variables/Factors;
data orig23;
retain A B C;
set orig23;
run;

title1 '2^3 Factorial Design';
title2 'in Standard Order';
proc print data=orig23;
run;
title;


/* 
Example of a 2^(3-1) Fractional Factorial (FF) design;

Notice the statement SIZE FRACTION=2. 
This is to tell SAS that it is a 1/2 fraction
of the full factorial design. 

You could also spacify the size of the design with
SIZE DESIGN=4, which is essentially a 1/2 fraction
that contains 4 treatment combinations (out of the total
of 8 treatment combinations in a 2^3 Factorial Design.
*/

proc factex;
 factors C B A;
 size fraction=1;
 model resolution=3;
 examine design aliasing confounding;
 output out=Full23;
data Full23;
 retain A B C;
 set Full23;
title '2^3 Full Factorial Design';
proc print data=Full23; 
 title; 
run;
quit;


title;

* One-half fraction of 2^3 Factorial Design;
proc factex;
 factors C B A;
 size fraction=2;
 model resolution=3;
 examine design aliasing confounding;
 output out=half23;
run;
quit;


* There is no 2^3 design of resolution IV;
* One-half fraction of 2^3 Factorial Design;
proc factex;
 factors C B A;
 size fraction=2;
 model resolution=4; *Notice here;
 examine design aliasing confounding;
 output out=half23;
run;
quit;

/* 
Example of a 2^(4-1) Fractional Factorial (FF) design;

Notice the statement SIZE FRACTION=2. 
This is to tell SAS that it is a 1/2 fraction
of the full factorial design. 

You could also spacify the size of the design with
SIZE DESIGN=8, which is essentially a 1/2 fraction
that contains 8 treatment combinations (out of the total
of 16 treatment combinations in a 2^4 Factorial Design.

*/

proc factex;
   factors A B C D;
   size fraction = 2;
   model resolution=4;
   examine design aliasing confounding;
   *output out=Original;
run;

* 2^(4-1) resolution iV minimum aberration designs;
proc factex;
   factors A B C D;
   size fraction = 2;
   model resolution=4 / minabs;
   examine design aliasing confounding;
   output out=Original;
run;
quit;

title '1/2 Fractional Factorial of a 2^4 Design';
proc print data=Original;
run;
title;

* 1/4 fraction of a 2^(5-2) resolution III design;
proc factex;
   factors A B C D E;
   size fraction = 4;
   model resolution=3 / minabs;
   examine design aliasing confounding;
   output out=Original;
run;
quit;

/* 
1/4 fraction of a 2^(5-2) resolution III design;

Mnaually creating the design with chosen 
confounding structure;
*/

data frac52;
do x3=-1 to 1 by 2;
 do x2=-1 to 1 by 2;
  do x1 = -1 to 1 by 2;
   A=x1; 
   B=x2;
   C=x3;
   D=A*B;
   E=A*B*C;
   output;
  end;
 end;
end;
keep A B C D E;
run;

title1 'Manually Created 2^(5-2)';
title2 'Fractional Factorial Design';
proc print data=frac52;
run;
title;

/*
Example: Consider the above 2^(5-2) 
design (frac52), input the data (yield);
*/

* Creating SAS data set to input 
response (yield) data;

data frac52y;
input y @@;
cards;
4 3 5 6 2 4 9 10
;
run;

* Merging the factorial design 
and the response (yield) data
into a new SAS data set;

data frac52data;
merge frac52 frac52y;
run;

* Printing the final SAS data set
ready for analysis;
proc print data=frac52data;
run;


/* Fitting model to obtain the estimated 
factor effects;
proc glm data=frac52data;
class A B C D E;
* Model should include all the main effects 
along with all possible interactions;
model y = A B C D E A*B A*C A*D A*D B*C B*D B*E C*D/solution;
ods output ParameterEstimates=sol;
run;
quit;

proc print data=sol;
run;

* Continue with normal and half normal 
probability plots to find important effects;

*/


/*
FOLD-OVER Design;

From: 
http://support.sas.com/documentation/cdl/en/qcug/67522/HTML/default/
viewer.htm#qcug_factex_sect037.htm

Folding over a fractional factorial design is a method 
for breaking the links between aliased effects in a design. 
Folding over a design means adding a new fraction identical 
to the original fraction except that the signs of all the 
factors are reversed. 

The new fraction is called a fold-over 
design. 

Combining a fold-over design with the original 
fraction converts a design of odd resolution r into a design 
of resolution r + 1. If the original design has even resolution
then this is not true. For example, folding over a 
resolution 3 design yields a resolution 4 design. 

You can use the FACTEX procedure to construct the original 
design fraction and a DATA step to generate the fold-over 
design.

*/

/* 
EXAMPLE

A human performance analyst is conducting an experiment to 
study eye focus time and has built an apparatus in which 
several factors can be controlled during the test. 

The factors he initially regards as important are 
Sharpness of vision (A)
Distance from target (B)
Target shape (C) 
Illumination level (D)
Target size (E) 
Target density (F) 
Subject (G)

Consider a 1/16 fraction of a 2^(7-4) factorial design 
with factors A, B, C, D, E, F, G. 

The following statements construct a 2^{7-4}_III design:
*/

* Or you could automate it using 
factex procedure, but you have to be
very careful in ordering the factors;
proc factex;
 factors C B A G D E F; * Notice the ordering;
 size fraction=16;
 model resolution=3;
 examine aliasing confounding design;
 output out=orig;
run;
quit;

data orig;
retain A B C D E F G;
set orig;
run;

* Creating the design;
data orig;
do x3=-1 to 1 by 2;
 do x2=-1 to 1 by 2;
  do x1 = -1 to 1 by 2;
   A=x1; B=x2; C=x3; D=A*B;
   E=A*C; F=B*C; G=A*B*C;
   output;
  end;
 end;
end;
keep A B C D E F G;
run;

proc print data=orig;
run;


title 'Original 2^(7-4) Design';
proc print data=orig;
run;
title;

* The response data;
data fold1y;
input y @@;
cards;
85.5 75.1 93.2 145.4 83.7 77.6 95.0 141.8
;
run;

* Merging the factorial design 
and the response (yield) data
into a new SAS data set;

data fold1;
merge orig fold1y;
run;

* Printing the final SAS data set
ready for analysis;
proc print data=fold1;
run;

/* 
Analyzing the first part of the foldover design;
*/

title 'First half of the foldover design';
proc glm data=fold1;
model y = A B C D E F G / solution ss3; 
run;
quit;


* Creating the Full-foldover design
where all the main effects are dealiased;

data fold2;
 set orig;
 A=-A; B=-B; C=-C; D=-D; 
 E=-E; F=-F; G=-G;
run;

title 'Full Fold-Over Design';
proc print data=fold2;
run;
title;

* The response data;
data fold2y;
input y @@;
cards;
91.3 136.7 82.4 73.4 94.1 143.8 87.3 71.9
;
run;

* Merging the factorial design 
and the response (yield) data
into a new SAS data set;

data fold2;
merge fold2 fold2y;
run;

* Rearranging the factors;
data fold2;
retain A B C D E F G;
set fold2;
run;


* Printing the fold2 SAS data set
ready for analysis;
proc print data=fold2;
run;

* Analyzing the second part of the
foldover design;
proc glm data=fold2;
model y = A B C D E F G/ solution ss3; 
title 'Second half of the foldover design';
run;
quit;
title;



*****************************************;
*** Analysis of Full FoldOver Design  ***;
*****************************************;
data fold1;  
set fold1;  
block=1;
data fold2; 
set fold2; 
block=2;
data foldover; 
 set fold1 fold2;
run;

proc print data=foldover;
run;

* Analyzing the full fold over design;
proc glm data=foldover;
model y = block A B C D E F G/ solution ss3; 
title 'Analysis of full foldover design';
run;
quit;
title;

/* 
Another way of solving the Eye focusing example may be found at
http://www.math.montana.edu/~jobo/st578/foldover.sas
*/
