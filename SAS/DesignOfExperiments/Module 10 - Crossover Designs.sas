
/* Example 1 AB, BA Design   */

data antifungal;
input group subject p1 p2;
 if group=1 then do;
  period=1; pl=p1; treat='A'; output;
  period=2; pl=p2; treat='B'; output;
 end;
 if group=2 then do;
  period=1; pl=p1; treat='B'; output;
  period=2; pl=p2; treat='A'; output;
 end; 
keep group subject period treat pl;
datalines;
1	2	12.8	8.2
1	3	16.5	13.1
1	6	18.7	15.9
1	8	11.6	14.2
1	11	13.6	12.8
1	12	9.8	15.3
1	16	12.8	14
1	18	12.1	12
2	1	10.9	12.3
2	4	13.5	11.5
2	5	13.7	16
2	7	12.2	14.8
2	9	12.6	16.2
2	10	13	17.5
2	14	10.7	7.5
2	15	14.2	12.4
2	17	12.2	12.8
;
run;

proc print data=antifungal;
run;

proc glm data=antifungal;
  class subject period treat;
  model pl=subject period treat /ss3;
  lsmeans treat/pdiff;
  estimate 'B-A' treat -1 1;
run;
quit;



* Estimating the carryover effect;
proc mixed data=antifungal;
class group subject period treat;
model pl=group period treat;
random subject(group);
estimate 'B-A' treat -1 1;
estimate 'Carryover Diff' group 1 -1;
run;
quit;


/*
Example 2: Bioequivalence Study 
to demonstrate the crossover design with 
carryover effects
*/

data bioequiv;
input group	subject	y1	y2	y3;
if group =1 then do;
period=1; y=y1; treat='A'; carry='none'; output;
period=2; y=y2; treat='B'; carry='A';    output;
period=3; y=y3; treat='B'; carry='B';    output;
end;
if group = 2 then do;
period=1; y=y1; treat='B'; carry='none'; output;
period=2; y=y2; treat='A'; carry='B';    output;
period=3; y=y3; treat='A'; carry='A';    output;
end;
drop y1 y2 y3;
datalines;
1	2	112.25	106.36	88.59
1	3	153.71	150.13	151.31
1	6	278.65	293.27	295.35
1	8	30.25	35.81	34.66
1	10	65.51	52.48	47.48
1	12	35.68	41.79	42.79
1	13	96.03	75.87	82.81
1	14	111.57	115.92	118.14
1	18	72.98	70.69	74.20
1	19	148.98	157.70	178.62
1	21	140.22	119.83	139.48
1	23	60.44	44.09	35.53
1	26	136.10	161.76	163.57
1	28	111.19	101.83	101.70
1	31	85.87	99.60	107.48
1	34	111.25	114.90	135.94
1	36	58.79	96.42	122.60
1	129	299.50	303.45	385.34
2	1	52.66	47.65	13.91
2	4	128.44	173.22	140.44
2	5	233.18	88.18	31.93
2	7	53.87	89.18	70.08
2	9	62.07	54.99	73.39
2	11	183.30	153.88	122.41
2	15	51.91	73.01	23.10
2	16	90.75	89.70	111.94
2	17	59.51	56.26	48.87
2	24	83.01	73.85	71.30
2	25	85.37	86.67	92.06
2	27	84.85	75.41	79.45
2	30	70.33	40.80	46.91
2	32	110.04	102.61	113.18
2	33	93.58	87.31	87.58
2	35	66.54	43.29	84.07
2	120	59.67	56.86	69.49
2	122	49.02	50.29	51.71
;
run;

proc print data=bioequiv; 
run;

proc freq;
table subject*carry*group;
run;

/* Checking if balanced/unbalanced;
proc glm data=bioequiv;
class group subject period treat carry;
model y=group subject(group) period treat;
random subject(group)/test;
run;
quit;
*/

proc glm data=bioequiv;
class group subject period treat carry;
model y=group subject(group) period treat carry /ss3;
random subject(group)/test;
run;
quit;

* With the LSMEANS statement for treatment;
proc glm data=bioequiv;
class group subject period treat carry;
model y=group subject(group) period treat carry /ss3;
random subject(group)/test;
*lsmeans treat /pdiff;
run;
quit;

* Testing the subject effect, period effect
treatment and carryover effect using 
within subject variability;
proc glm data=bioequiv;
class group subject period treat carry;
model y= subject period treat carry / ss3;
lsmeans treat/pdiff; 
run;
quit;
