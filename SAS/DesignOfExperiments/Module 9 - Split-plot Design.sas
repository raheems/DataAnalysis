
/*
Split-plot Design
*/

* Create the data collection form 
for the split-plot design (Cookie baking
experiment);

/*
Recipes for chocolate and orange cookies include exactly 
the same ingredients up to the point where the syrup was 
added to the batch.

The problem: After the cookies were backed, the orange 
cookies spread during the baking process and became thin,
flat and unappealing. Chocolate cookies had no such problems.
A factorial experiment was planned to know if there is 
any change in the process that would reduce the spreading 
during baking.

The following are the factors considered to vary.

A: amount of shortening in the dough batch (2 levels)
80% of the original recipe
100% of the recipe 

B: baking temperature (3 levels)
Below normal
Normal temperature
Above normal temperature

C: temperature of the cookie sheet upon which cookies were 
placed to be baked (tray temperature) (2 levels)
Hot out of oven
Cooled to room temperature

Outcome variable: diameter of the baked cookies
*/

* Generated data collection scheme;
proc factex;
factors trayTmp;
output out=s1 trayTmp cvals=('RoomTmp' 'Hot');
run;

factors bakeTmp /nlev=3;
output out=s2 pointrep=s1 bakeTmp cvals=('Low' 'Norm' 'High');
run;

* Create the whole-plot design and randomize;
factors shortening;
size design=4;
output out=sp pointrep=s2 randomize(1012) shortening cvals=('80%' '100%');
run;

proc print data=sp;
run;

* Add the batch and tray numbers within batch 
and merge it with the randomized design sp;
data batches;
do batch=1 to 4;
 do tray = 1 to 6;
 output;
 end;
end;
data sp; 
merge batches sp;
proc print data=sp;
run;

* Add the response to the data and
create the final data set, cookie;

data y;
input y @@;
cards;
2.37 2.46 2.45 2.28 2.11 2.08 
1.18 1.77 1.74 1.33 1.33 2.09
1.72 0.94 1.72 1.28 1.34 1.23
2.26 2.34 2.14 2.19 2.01 2.07
;
data cookie;
merge sp y;
run;

* Final data for analysis;
proc print data=cookie;
run;


* Analysis using PROC GLM;

proc glm data=cookie;
class batch shortening bakeTmp trayTmp;

model y = shortening batch(shortening) 
	bakeTmp trayTmp 
	shortening*bakeTmp 
	shortening*trayTmp 	
	bakeTmp*trayTmp 
	shortening*bakeTmp*trayTmp;

*random batch(shortening)/test;
random batch(shortening);

* Equivalently, correct test for shortening with appropriate denominator;
test h=shortening  e=batch(shortening);
run;
quit;


* Analysis using PROC MIXED;

proc mixed data=cookie;
class batch shortening bakeTmp trayTmp;

model y = shortening bakeTmp trayTmp 
	shortening*bakeTmp
	shortening*trayTmp 
	bakeTmp*trayTmp 
	shortening*bakeTmp*trayTmp;

random batch(shortening);

estimate 'Shortening effect' shortening -1 1;
lsmeans shortening bakeTmp shortening*trayTmp;

run;
quit;


* Getting the interaction plots for shortening 
and bakeTmp;
proc glm data=cookie;
class  shortening  trayTmp;
model y = shortening trayTmp shortening*trayTmp ;
run;
quit;


/*
Split-plot design with randomized block at the
whole-plot level;

Sausage example:
*/

data sausage;
input Block  A B C D burst;
datalines;
 1      -1    -1    -1    -1    2.07
 1      -1    -1     1    -1    2.07
 1      -1    -1    -1     1    2.10
 1      -1    -1     1     1    2.12
 1       1    -1    -1    -1    2.02
 1       1    -1     1    -1    1.98
 1       1    -1    -1     1    2.00
 1       1    -1     1     1    1.95
 1      -1     1    -1    -1    2.09
 1      -1     1     1    -1    2.05
 1      -1     1    -1     1    2.08
 1      -1     1     1     1    2.05
 1       1     1    -1    -1    1.98
 1       1     1     1    -1    1.96
 1       1     1    -1     1    1.97
 1       1     1     1     1    1.97
 2      -1    -1    -1    -1    2.08
 2      -1    -1     1    -1    2.05
 2      -1    -1    -1     1    2.07
 2      -1    -1     1     1    2.05
 2       1    -1    -1    -1    2.03
 2       1    -1     1    -1    1.97
 2       1    -1    -1     1    1.99
 2       1    -1     1     1    1.97
 2      -1     1    -1    -1    2.05
 2      -1     1     1    -1    2.02
 2      -1     1    -1     1    2.02
 2      -1     1     1     1    2.01
 2       1     1    -1    -1    2.01
 2       1     1     1    -1    2.01
 2       1     1    -1     1    1.99
 2       1     1     1     1    1.97
 ;
 run;

 proc print data=sausage;
 run;

proc glm data=sausage;
  class A B Block C D;
  model burst=Block A B A*B Block(A*B) C D C*D A*C A*D B*C  
   		B*D A*B*C A*B*D A*C*D B*C*D A*B*C*D;
  random Block Block(A*B)/test; 
  output out=sausageout p=predy r=resy;
run;

* Proc mixed;
proc mixed data=sausage;
class A B Block C D;
model burst =A B A*B C D C*D A*C A*D B*C B*D A*B*C A*B*D A*C*D B*C*D A*B*C*D;
random Block Block(A*B);
run;

* Proc mixed and LSMEANS for the 
significant effects;
proc mixed data=sausage;
class A B Block C D;
model burst =A B A*B C D C*D A*C A*D B*C B*D A*B*C A*B*D A*C*D B*C*D A*B*C*D;
random Block Block(A*B);
lsmeans A;
lsmeans C;
run;


proc sort data=sausage; by A B C;
proc means noprint; by A B C; var burst;
output out=s mean = yh;
run;

proc print data=s; run;
proc format;
  value levels -1=' Low Level '
               	1=' High Level ';
run;

*ods graphics on;

proc sgpanel data=s;
  panelby C/columns=2;
  series x=A y=yh/group=B markers;
  refline 2.0 / lineattrs=(pattern=34);
  rowaxis label='Mean Bursting Strength';
  colaxis  type=discrete label='Factor A';
  format A levels. B levels. C levels.;
run;

*ods graphics off;
