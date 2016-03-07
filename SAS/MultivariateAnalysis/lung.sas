proc format ;
   value AREA /* area */
      1 = 'Burbank'  
      2 = 'Lancaster'  
      3 = 'Long Beach'  
      4 = 'Glendora' ;
   value FSEX /* sex of father */
      1 = 'male' ;
   value MSEX /* sex of mother */
      2 = 'female' ;
   value OCSEX /* sex, oldest child */
      1 = 'male'  
      2 = 'female' ;
run;

/*
proc datasets ;
modify lung;
   format      AREA AREA.;
   format      FSEX FSEX.;
   format      MSEX MSEX.;
   format     OCSEX OCSEX.;
run;
quit;
*/
PROC IMPORT OUT= WORK.LUNG2 
            DATAFILE= "C:\Users\Raheem\Documents\MyFolder\UNCO\teaching\
SRM 610\Core Materials\SAS Programs and Data Sets\Lung.txt" 
            DBMS=TAB REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

PROC IMPORT OUT= WORK.LUNG2 
            DATAFILE= "C:\Users\Raheem\Documents\MyFolder\UNCO\teaching\
SRM 610\Core Materials\SAS Programs and Data Sets\Lung.txt" 
            DBMS=DLM REPLACE;
     DELIMITER='20'x; 
     GETNAMES=NO;
     DATAROW=1; 
RUN;

proc print data=lung2 (obs=5);
run;
