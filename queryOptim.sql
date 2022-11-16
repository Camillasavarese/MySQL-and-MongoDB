# 1. athlete with most first places  (RUNNING TIME: 4.9 sec)

# OPTIMIZATION: 
ALTER TABLE athlete ADD INDEX(id, athlname);
ALTER TABLE results ADD INDEX(athlete);
ALTER TABLE results ADD INDEX(place);

select a.athlname, count(id) as wins
from athlete as a join results as r on a.id = r.athlete
where place = '1'
group by athlname
order by count(id) desc
limit 1;

# rewritten query (RUNNING TIME: 0.8 sec)

# OPTIMIZATION:
ALTER TABLE winners ADD INDEX(athlname, athlete, meet, category, division);

select athlname, count(athlete) as wins
from winners
group by athlname
order by count(athlete) desc
limit 1;

############################################################################
############################################################################

# 2. average results of competitions he took part in (RUNNING TIME: 0.02 sec) 

# OPTIMIZATION:
ALTER TABLE athlete ADD INDEX(athlname);

select r.athlete, round(avg(r.age), 2) avg_age, round(avg(r.bodyweight), 2) avg_weight, round(avg(r.totalkg), 2) avg_totalkg, round(avg(r.place), 2) avg_place
from results as r join athlete as a on a.id = r.athlete 
where a.athlname = 'Sverre Paulsen'
group by r.athlete;

############################################################################
############################################################################

# 3. countries with most meetings (RUNNING TIME: 0.02)   

# OPTIMIZATION:
ALTER TABLE meet ADD INDEX(meetcountry); # NOT REALLY NECESSARY BECAUSE THE NUMBER OF ROWS IS SMALL

select meetcountry, count(meetcountry) as meets
from meet
group by meetcountry
order by count(meetcountry) desc
limit 20;

############################################################################
############################################################################

# 4. Meet where the youngest athletes competed (RUNNING TIME: 0.00075 sec)   

# OPTIMIZATION:
ALTER TABLE meet ADD INDEX(meetdate);
ALTER TABLE results ADD INDEX(meet);
ALTER TABLE results ADD INDEX(age);
ALTER TABLE meet ADD INDEX(id);

select m.*
from results as r join meet as m on m.id = r.meet
where r.age = (select min(age)
			   from ageclass)
order by meetdate desc;

############################################################################
############################################################################

# 5. Name and weight of athletes who weight more than the average, order by bodyweight (RUNNING TIME: 4.9 sec)

# OPTIMIZATION: 
ALTER TABLE results ADD INDEX(bodyweight);

select distinct a.athlname, round(avg(r.bodyweight), 2)
from results as r join athlete as a on a.id = r.athlete
where r.bodyweight > (select avg(r1.bodyweight)
					   from results as r1)
group by a.athlname
order by avg(r.bodyweight) desc;

# rewritten query (RUNNING TIME: 0.32 sec)

# (creating the table takes less time than computing each time the view [27 sec vs 38 sec])
# OPTIMIZATION:
ALTER TABLE averageWeight ADD INDEX(avgWeight);
ALTER TABLE averageWeight ADD INDEX(athlname, avgWeight);

select a.*
from averageWeight as a
where a.avgWeight > (select avg(a1.avgWeight)
					 from averageWeight as a1);

############################################################################
############################################################################

# 6. Names of athletes over 20 years old who compete in the "Open" or "Boys" category (RUNNING TIME: 1.5 sec)

# OPTIMIZATION:
ALTER TABLE results ADD INDEX(division);

select a.athlname, avg(r.age)
from results as r join athlete as a on a.id = r.athlete
where r.age > 20 and r.athlete in (select r1.athlete
				                   from results as r1
								   where r1.division = "Open" or r1.division= "Boys")
group by a.athlname
limit 100; 

# rewritten query (RUNNING TIME: 0.013 sec)   

select a.athlname, avg(r.age)
from results as r join athlete as a on a.id = r.athlete
where r.age > 20 and (r.division = "Open" or r.division = "Boys")
group by a.athlname
limit 100;

############################################################################
############################################################################

# 7. First attempts in squat, deadlift and bench for male athletes with "Raw" equipment. (RUNNING TIME: 0.36 sec)

# OPTIMIZATION:
ALTER TABLE athlete ADD INDEX(sex);

select a.athlname, round(avg(b.bench1), 2) avg_bench, round(avg(d.deadlift1),2) avg_deadlift, round(avg(s.squat1),2) avg_squat
from athlete as a, bench as b, deadlift as d, squat as s
where a.id = b.athlete and a.id = d.athlete and a.id = s.athlete and b.category = 'SBD'  and d.category = 'SBD' and s.category = 'SBD' and d.equipment = "Raw" and a.sex = 'M'
group by athlname;

# rewritten query (RUNNING TIME: 0.2 sec)

select a.athlname, round(avg(b.bench1), 2) avg_bench, round(avg(d.deadlift1),2) avg_deadlift, round(avg(s.squat1),2) avg_squat
from athlete as a join bench as b on a.id = b.athlete join deadlift as d on a.id = d.athlete and b.meet = d.meet join squat as s on a.id = s.athlete and b.meet = s.meet
where b.category = 'SBD' and d.equipment = "Raw" and a.sex = 'M'
group by athlname;

############################################################################
############################################################################

# 8. Top 10 women who have higher wilk than average men wilk (RUNNING TIME: 3.3 sec) 

# OPTIMIZATION: index on sex

select a.athlname, round(avg(s.wilks), 2)
from athlete a, scores s
where s.athlete = a.id and a.sex = 'F' and s.wilks > (select avg(s1.wilks)
                                                      from scores s1, athlete a1
													  where s1.athlete = a1.id and a1.sex = 'M')
group by a.athlname
order by round(avg(s.wilks), 2) desc
limit 10;

############################################################################
############################################################################

# 9. meet with no athletes with less than 18 years (RUNNING TIME: 0.7 sec)

# OPTIMIZATION: INDEX ON SEX
ALTER TABLE results ADD INDEX(meet);

select m.id , m.meetname
from meet as m join results as r on m.id = r.meet
where r.meet not in (select r1.meet 
					 from results as r1 
					 where r1.age < 18 and r1.age > 0
					 group by r1.athlete) 
group by m.id;

############################################################################
############################################################################

# 10. returns the athletes who have lifted in total (totkg) more than the average but with a score per mcculloch lower than the average (RUNNING TIME: 3.7 sec)

# OPTIMIZATION:
ALTER TABLE athlete ADD INDEX(id, athlname, sex);
ALTER TABLE results ADD INDEX(totalkg);
ALTER TABLE scores ADD INDEX(wilks);

select a.*
from athlete as a
WHERE EXISTS (select *
			  from results as r
			  where a.id = r.athlete and r.totalkg > (select avg(r1.totalkg)
													  from results as r1))
AND NOT EXISTS (select *
				from scores as s
				where a.id = s.athlete and s.wilks < (select avg(s1.wilks)
												      from scores as s1));
                                                      
############################################################################
############################################################################