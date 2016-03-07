
/*
Module 7 : Principal Components Analysis (PCA)
*/

/* Ski Data, p. 620, 622;
Five subjects who were trying on ski boots were asked about the 
importance of each of four variables to their selection of a ski
resort. The variables were

COST: cost of ski ticket
LIFT: speed of ski lift
DEPTH: depth of snow
POWDER: moisture of snow

Research Question:
To investigate the pattern of relationship among the variables
in an effort to understand better the dimensions underlying 
choice of ski resort.

*/

data ski;
	input cost lift depth powder;
	cards;
	32 64 65 67
	61 37 62 65
	59 40 45 43
	36 62 34 35
	62 46 43 40
;
run;
proc print; run;


* Principal component analysis;
title 'Principal Component Analysis';
proc princomp data = ski out = skiout;
var cost lift depth powder;
run;

proc print data=skiout;
run;



/**********************************************
Principal Components Analysis of 
US Air pollution Data
***********************************************/

proc import datafile='USairpollution-SAS.csv'
     out=usair /* SAS dataset name */
     dbms=dlm
     replace;
     delimiter=','; 
     datarow=2;
run;

proc contents data = usair;
run;

proc print data = usair (obs=10);
run;



/*
HELP:
PLOTS(NCOMP=3)=ALL N=6 in the PROC PRINCOMP statement requests all plots 
to be produced but limits the number of components to be plotted in the 
component pattern plots and the component score plots to three. 

The N=6 option sets the number of principal components to be computed to six. 
Also, this is the #PCs to be plotted in the scoreplot matrix;

OUT=usairout
Is the output data set that contains all existing variable plus the component scores;
*/

*ods rtf file='out.rtf';


title 'Principal Component Analysis';
title2 'US Air pollution Data';
proc princomp data = usair out=usairout
plots(ncomp=3)=all n=3; 
var so2 temp manu popul wind precip predays;
* ncomp=3: pairwise plots for 3 components;
* n=6: construct and plot 6 PCs in scoreplot matrix and profile pattern;
run;
*ods rtf close;

* This dataset contain PC scores;
proc print data = usairout;
run;


*ods rtf close;



/**************************************************
Factor Analysis
*************************************************/

* By default, Factor analysis is performed on correlation matrix;
title "PCFA - Investigate Number of Factors";
proc factor data = ski method = prin plots= (scree initloadings);
var cost lift depth powder;
run;

* Altering the number of factors to extract using NFACTORS option;
title "PCFA - Three Factors";
proc factor data = ski method = prin plots=(scree initloadings) nfactors = 3;
var cost lift depth powder;
run;


* Varimax Factor Rotation;
proc factor data = ski 
method = prin
rotate=varimax reorder
plots=(scree initloadings loadings);
run;

/* 
Oblique Rotation: Promax, which includes Varimax when requested;
INITLOADINGS: shows initial loadings plot (unrotated)
PRELOADINGS: shows VARIMAX loadings plot (rotated)
LOADINGS: shows PROMAX loadings plot (rotated)
*/

title;
title2 'PCA PROMAX Rotation';
proc factor data = ski 
method = prin
rotate=promax reorder
plots=(scree initloadings preloadings loadings);
run;




/**********************************************
Factor Analysis of 
US Air pollution Data
***********************************************/

proc import datafile='USairpollution-SAS.csv'
     out=usair /* SAS dataset name */
     dbms=dlm
     replace;
     delimiter=','; 
     datarow=2;
run;

proc print data = usair (obs=10);
run;

* FUZZ =.3 suppresses loadings smaller than .3;
title 'FA of US Air pollution Data';
title2 'FA PROMAX Rotation';
proc factor data = usair 
method = prin
rotate=promax reorder fuzz=.4
plots=(scree initloadings preloadings loadings);
var so2 temp manu popul wind precip predays;
run;



/* 
Here is another data set on air pollution;
Factor Analysis of Air Pollution Data;
*/

data air;
input wind solar CO NO NO2 O3 HC;
cards;
  8  98  7  2  12  8  2
  7  107  4  3  9  5  3
  7  103  4  3  5  6  3
  10  88  5  2  8  15  4
  6  91  4  2  8  10  3
  8  90  5  2  12  12  4
  9  84  7  4  12  15  5
  5  72  6  4  21  14  4
  7  82  5  1  11  11  3
  8  64  5  2  13  9  4
  6  71  5  4  10  3  3
  6  91  4  2  12  7  3
  7  72  7  4  18  10  3
  10  70  4  2  11  7  3
  10  72  4  1  8  10  3
  9  77  4  1  9  10  3
  8  76  4  1  7  7  3
  8  71  5  3  16  4  4
  9  67  4  2  13  2  3
  9  69  3  3  9  5  3
  10  62  5  3  14  4  4
  9  88  4  2  7  6  3
  8  80  4  2  13  11  4
  5  30  3  3  5  2  3
  6  83  5  1  10  23  4
  8  84  3  2  7  6  3
  6  78  4  2  11  11  3
  8  79  2  1  7  10  3
  6  62  4  3  9  8  3
  10  37  3  1  7  2  3
  8  71  4  1  10  7  3
  7  52  4  1  12  8  4
  5  48  6  5  8  4  3
  6  75  4  1  10  24  3
  10  35  4  1  6  9  2
  8  85  4  1  9  10  2
  5  86  3  1  6  12  2
  5  86  7  2  13  18  2
  7  79  7  4  9  25  3
  7  79  5  2  8  6  2
  6  68  6  2  11  14  3
  8  40  4  3  6  5  2
;
run;

proc print;run;


title;
title2 'FA PROMAX Rotation';
proc factor data = air 
nfactors =2
method = prin
rotate=promax reorder
plots=(scree initloadings preloadings loadings);
run;



/**********************************************
Factor Analysis of
Socio-economic Data
***********************************************/

data Socio;
   input Population School Employment Services HouseValue;
   datalines;
5700     12.8      2500      270       25000
1000     10.9      600       10        10000
3400     8.8       1000      10        9000
3800     13.6      1700      140       25000
4000     12.8      1600      140       25000
8200     8.3       2600      60        12000
1200     11.4      400       10        16000
9100     11.5      3300      60        14000
9900     12.5      3400      180       18000
9600     13.7      3600      390       25000
9600     9.6       3300      80        12000
9400     11.4      4000      100       13000
;
run;

proc print;run;

title 'FA of Socio-Economic Data';
title2 'FA PROMAX Rotation';
proc factor data = socio 
method = prin
rotate=promax reorder
plots=(scree initloadings preloadings loadings);
run;


/* 
* Iterated FA with SMC as priors;
* Socio-Economic Data;
* HEYWOOD Case
*/

title 'FA of Socio-Economic Data';
title2 'PRINIT FA (SMC) PROMAX Rotation';
proc factor data = socio 
method = prinit
priors = SMC
heywood
rotate=promax reorder
plots=(scree initloadings preloadings loadings);
run;



title 'FA of Socio-Economic Data';
title2 'ML FA (SMC) PROMAX Rotation';
proc factor data = socio 
method = ML
priors = SMC 
heywood
rotate=promax reorder
plots=(scree initloadings preloadings loadings);
run;


/**************************************
Other Factor Extraction Methods
**************************************/

title 'PF Method of extraction, no iteration, no rotation';
proc factor data = ski method = prin priors = smc nfactors = 2
	heywood reorder plot;
run;

title 'Principal factor method of extraction, no iteration';
proc factor data = ski method = prin priors = smc nfactors = 2
  	rotate=varimax heywood reorder plot;
run;


title 'Iterated Principal Factor Analysis';
proc factor data = ski method = prinit priors = smc nfactors = 2
  	rotate=varimax heywood reorder plot;
run;


title 'ML Factor Extraction with varimax rotation';
proc factor data = ski method = ML priors = smc nfactors=2 
  rotate=varimax heywood reorder;
run;


title2 'MLFA, Request 2 Factors, PROMAX rotation';
proc factor data=ski 
	method=ml priors=smc nfactors=2 
  	rotate=promax heywood reorder fuzz=.3;
	* fuzz option supresses printing the loadings when the absolute value of 
	loadings are below the value specified.;
run;
