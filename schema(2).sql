create schema if not exists PowerliftingBase;
use PowerliftingBase;

create table athlete(
	athlname varchar(50) not null,
    sex varchar(5)
    );

create table meet(
	meetdate varchar(10), 
    meetcountry varchar(30),
    meetname varchar(200) not null
    );
    
create table ageclass(
	age float,
    ageclass varchar(10)
	);

create table results as 
select a.id as athlete, m.id as meet, r.totalkg, r.place, r.age, r.bodyweight, r.category, r.division, r.equipment 
from athlete as a join results_temp as r on a.athlname = r.athl_name and a.sex = r.sex join meet as m 
where r.meetdate = m.meetdate and r.meetname = m.meetname;

create table squat as
select a.id as athlete, m.id as meet, r.category, r.division, squat1, squat2, squat3, squat4
from athlete as a join results_temp as r on a.athlname = r.athl_name and a.sex = r.sex join meet as m on r.meetdate = m.meetdate and r.meetname = m.meetname
where r.category = 'SBD' or r.category = 'S' or r.category = 'SB' or r.category = 'SD';
	
create table bench as
select a.id as athlete, m.id as meet, r.category, r.division, bench1, bench2, bench3, bench4
from athlete as a join results_temp as r on a.athlname = r.athl_name and a.sex = r.sex join meet as m on r.meetdate = m.meetdate and r.meetname = m.meetname
where r.category = 'SBD' or r.category = 'B' or r.category = 'SB' or r.category = 'BD';

create table deadlift as
select a.id as athlete, m.id as meet, r.category, r.division, deadlift1, deadlift2, deadlift3, deadlift4, r.equipment
from athlete as a join results_temp as r on a.athlname = r.athl_name and a.sex = r.sex join meet as m on r.meetdate = m.meetdate and r.meetname = m.meetname
where r.category = 'SBD' or r.category = 'D' or r.category = 'SD' or r.category = 'BD';
    
create table scores as 
select a.ID as athlete, m.ID as meet, r.category, r.division, wilks, mcculloch, glossbrenner, ipfpoints as ipfp
from athlete as a join results_temp as r on a.athlname = r.athl_name and a.sex = r.sex join meet as m on r.meetdate = m.meetdate and r.meetname = m.meetname
where r.place <> 'DQ';

create table equipment as
select distinct r.equipment 
from results as r;
