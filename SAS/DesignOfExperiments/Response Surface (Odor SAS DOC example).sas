/*
http://support.sas.com/documentation/cdl/en/statug/
63033/HTML/default/viewer.htm#statug_rsreg_sect005.htm
*/

ods html close;
ods html;

*ods graphics on;

title 'Response Surface with a Simple Optimum';
   data smell;
      input Odor T R H @@;
      label
         T = "Temperature"
         R = "Gas-Liquid Ratio"
         H = "Packing Height";
      datalines;
    66 40 .3 4     39 120 .3 4     43 40 .7 4     49 120 .7  4
    58 40 .5 2     17 120 .5 2     -5 40 .5 6    -40 120 .5  6
    65 80 .3 2      7  80 .7 2     43 80 .3 6    -22  80 .7  6
   -31 80 .5 4    -35  80 .5 4    -26 80 .5 4
   ;
   run;

   proc print; run;

/*
The following statements invoke PROC RSREG on the data set smell. 
Figure 75.1 through Figure 75.3 display the results of the analysis, 
including a lack-of-fit test requested with the LACKFIT option.
*/

* Response surface regression;
proc rsreg data=smell;
model Odor = T R H;
run;

* With lack of fit test;
proc rsreg data=smell;
model Odor = T R H / lackfit;
run;


proc rsreg data=smell 
plots(unpack)=surface(3d at(H=7.541050));
model Odor = T R H;
*ods select 'T * R = Pred';
run;

*ods graphics off;

/*
the following statements produce an output data set containing the 
surface information, which you can then use for plotting surfaces 
or searching for optima. The first DATA step fixes H, the least 
significant factor variable, at its estimated optimum value (7.541), 
and generates a grid of points for T and R. To ensure that the grid 
data do not affect parameter estimates, the response variable (Odor) 
is set to missing. (See the section Missing Values.)
*/

data grid;
      do;
         Odor =  .  ;
         H    = 7.541;
         do T = 20 to 140 by 5;
            do R = .1 to .9 by .05;
               output;
            end;
         end;
      end;
   data grid;
      set smell grid;
   run;
/*
The second DATA step concatenates these grid points to the original data. 
   Then PROC RSREG computes predictions for the combined data. The last 
   DATA step subsets the predicted values over just the grid points, 
   which excludes the predictions at the original data.
*/ 

   proc rsreg data=grid out=predict noprint;
      model Odor = T R H / predict;
   run;
   
   data grid;
      set predict;
      if H = 7.541;
   run;

   proc print;run;
