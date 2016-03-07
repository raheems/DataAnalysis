
/*************************************************;
** Module 5 - 2^k Factorial Designs.sas **;

** Useful Resources **

- How to create a factorial design with SAS (many scenarios)
  http://bit.ly/21ebLQf

*************************************************/


/*
Consider a simple example of creating a factorial designs.
Let's start with a 2^3 fractional factorial design
in A, B, C
*/

* Just print the design;
proc factex;
factors A B C;
examine design;
run;

* Now with the alias structure;
proc factex;
factors A B C;
examine design aliasing;
run;

* Now with the design+alias structure + confounding;
* No confounding will be shown here as we are displaying
* the full factorial design;
proc factex;
factors A B C;
examine design aliasing confounding;
run;

***********************************;
** EXAMPLE **
***********************************;

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
 2^4 Factorial design in standard order;
*/

proc factex;
 factors D C B A;
 examine design;
run;


/*
A full factorial design in three factors, each at two levels. 
The entire design is replicated twice, and the design with 
recoded factor levels is saved in a SAS data set.

The randomize(123) is to tell SAS to randomize the runs,
and the 123 is the random seed. If you do not change the
random see, you will be able to get the same order of runs
every time you run the PROC FACTEX.
*/

proc factex;
	factors A B C D;
	output out = SavedDesign
	designrep = 2 randomize(123);
run;


* print the design;
proc print data = SavedDesign;
run;
