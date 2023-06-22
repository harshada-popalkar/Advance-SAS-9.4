libname cert '/home/u63348281/2023/Cert';
* Group By Having ;
data input27 ;
set cert.input27 ;
run;
proc sort data=input27 out=out27 ;
by country ;
run;
proc sql;
select distinct(upcase(state)) as state ,count(state) as state_count from out27
where upcase(state) in('PA' ,'FL' ,'CA')
group by upcase(state) 
having state_count
;
quit;

proc sql ;
select distinct(sex),
	round(avg(height)) as weight ,
	round(avg(weight)) as height ,
	round(median(height)) as med_weight ,
	min(height) as min_weight ,
	age
from sashelp.class;
group by age
having sex = 'F' & age > 12;
run;
/*---------------------------------------------------------------------------------------*/
 
*Creating And Updating Tables and views ;
proc sql ;
create table student_info(
student_name char(20),
student_id int,
DOB num format = date9. informat= date9.
);
describe table student_info ;
run;
proc contents data= student_info ;
run;

* Modify variables  ;
proc sql ;
create table xww as
	select Amount 'Sale' format = dollar10. ,
		   date format= date.7
	from sashelp.buy ;
select * from xww (drop = date);
run ;
*Creating Tables like an Existing Table;
proc sql ;
create table sale_history
like  xww;
run;

*Copying an Existing Table;
proc sql;
create table resale as 
   select * from xww;
run;
  
*Using Data Set Options;
proc sql;
create table sales_info as
	select * from sashelp.buy(drop=date);
run;
*----------------------------------------------------------------------------------------*;
*_Inserting Rows into Tables ;
*Using Set statement ;
proc sql ;
describe table sale_history ;
insert into sale_history 
set amount= 13490  , date =324546 
set amount =438798 , date =327864
;run;
proc sql ;
select * from sale_history ;
run;

*Using value clause ;
proc sql;
insert into sale_history (amount , date )
values (2109483 ,324873)
values(2487794,457848)	;
select amount , date from sale_history ;
run; 

* using where condition ;
proc sql ;
create table birth  
	like sashelp.Birthwgt (drop = somecollege race );
insert into birth 
select * from sashelp.Birthwgt(drop = somecollege race )
where LowBirthWgt='Yes' & Drinking= 'Yes' & Smoking ='Yes'
;
run;

proc sql ;
select distinct(Agegroup) as AgeGroup , count(Drinking)as Drink, count(Smoking) as Smoke ,
 LowBirthWgt
from sashelp.birthwgt
group by Agegroup 
;
run;
*-------------------------------------------------------------------------------------------*;
*Updating Data Values in a Table;
libname cert '/home/u63348281/2023/Cert' ;
data input ;
set cert.input36 ;
run ;

proc sql ;
create table Health_info like input(drop=Member_id);
insert into health_info 
select * from input(drop=Member_id);
update Health_info set kilograms = Kilograms*1000  ;
update health_info set centimeters = Centimeters*0.01;
update Health_info set Firstname = upcase(Firstname);
update Health_info set Lastname = upcase(Lastname);

select  Firstname , Lastname , group ,
        kilograms as grams ,  
	    centimeters as meters 
from health_info 
where (not missing(kilograms)) & ( not missing(centimeters));
describe table health_info ;
;run;
*case when then ;
proc sql;
select group,case
when group = 'A' then 1
when group= 'B' then 2
else 3
end as Group_no
from Health_info ;
quit;

*Delete rows;
proc sql ; 
delete from health_info where group ^= 'A' ;
select * from health_info ;
run ;
*delete table ;
proc sql ;
drop table health_info;
run;

* Altering A Column ;
*The ALTER TABLE statement adds, modifies, and deletes columns in existing tables.
 You can use the ALTER TABLE statement with tables onl it does not work with views.
 A note appears in the SAS log that describes how you have modified the table;
*MODIFY clause to change the width, informat, format, and label of a column ;
proc format ;
value BMI
0 -<18 = 'under_weight'
18 -< 25 ='Healthy'
25 -<30 = 'Over_weight'
30 -< 100= 'Obese';
run;
proc sql ;
alter table health_info add FullName char(50) , BMI num ,status char(15),date num ;
alter table health_info modify date format = date9. ;
update health_info set date = 224678 ;
update health_info set Fullname = Propcase(FirstName||' '||MI||'. '||Lastname);
update health_info set BMI = (Kilograms*0.001)/( Centimeters**2);
update health_info set status = put(Bmi,bmi.) ;
delete from health_info where Bmi > 100 | missing(Bmi);
describe table health_info ;
select fullname , BMI format numeric5.1, status ,date from health_info ;
run;
* DROP clause deletes columns from tables.;
proc sql ;
alter table health_info drop date ,FirstName, MI , LastName ;
select * from health_info;
run;
proc print data= health_info ;
run;
*Using PROC SQL to Create Indexes;
proc sql ;
create index FullName on health_info(FullName) ;
select * from health_info ;
run;
*Deleting Indexes;
proc sql ;
drop index group from health_info ;
run;

proc contents data=health_info ;
run;







	


