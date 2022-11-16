# AVOIDING NULL VALUES:
# is suggested to not use null values because it doesn't represent a specific value as a numeric type. Using a numeric will speed up computation and avoid ambiguity.

update results_temp set VARIABLE = 0 where VARIABLE is null;


# ADDING CONSTRAINTS (PK & FK):
# adding primary keys speeds up the access to a table because very time we insert a primary key it automatically builds an index on it
update results_temp set division = 'NA' where division is null;
# add primary key to equipment
alter table equipment add primary key (equipment);
# add primary key to ageclass
alter table ageclass add primary key (age, ageclass);
# add primary key to results
alter table results add primary key (athlete, meet, category, division);
alter table results add foreign key results(athlete) references athlete(id); 
alter table results add foreign key results(meet) references meet(id);
# add primary key to bench
alter table bench add primary key (athlete, meet, category, division); 
alter table bench add foreign key (athlete, meet, category, division) references results(athlete, meet, category, division) on delete cascade on update cascade;  
# add primary key to squat
alter table squat add primary key (athlete, meet, category, division); 
alter table squat add foreign key (athlete, meet, category, division) references results(athlete, meet, category, division) on delete cascade on update cascade;
# add primary key to deadlift
alter table deadlift add primary key (athlete, meet, category, division); 
alter table deadlift add foreign key (athlete, meet, category, division) references results(athlete, meet, category, division)
  on delete cascade
  on update cascade;
alter table deadlift add foreign key (equipment) references equipment(equipment);
# add primary key to scores
alter table scores add primary key (athlete, meet, category, division); 
alter table scores add foreign key (athlete, meet, category, division) references results(athlete, meet, category, division) on delete cascade on update cascade;
# add primary key to winners
alter table winners add primary key (athlete, meet, category, division); 
alter table winners add foreign key (athlete, meet, category, division) references results(athlete, meet, category, division) on delete cascade on update cascade;  
# add foreign key averageWeight
alter table averageWeight add foreign key (athlname) references athlete(athlname);

# CREATING MATERIALIZED VIEWS

create table winners as
select a.athlname, r.*
from athlete as a join results as r on a.id = r.athlete
where place = '1';

create table averageWeight as
select a.athlname, round(avg(r.bodyweight), 2) as avgWeight
from results as r join athlete as a on a.id = r.athlete
where bodyweight > 0 
group by a.athlname;