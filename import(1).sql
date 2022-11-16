set global local_infile=1;

# move files in secure_file_priv = DIRECTORY or change secure_file_priv = '' sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf ---> TRY TO CHANGE VARIABLE + MOVING FILES 
# move files in correct directory: sudo cp PATH_FILES_TO_COPY /var/lib/mysql/DATABASENAME/
# change '' in '\N' to allow NULL values to be imported

# ATHLETE

LOAD DATA INFILE 'athlete.csv'
INTO TABLE athlete
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

alter table athlete add id int not null auto_increment key;
ALTER TABLE athlete CHANGE COLUMN id id INT NOT NULL AUTO_INCREMENT FIRST;

# MEET

LOAD DATA INFILE 'meet.csv'
INTO TABLE meet
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

alter table meet add id int not null auto_increment key;
ALTER TABLE meet CHANGE COLUMN id id INT NOT NULL AUTO_INCREMENT FIRST;

# RESULTS_TEMP

create table results_temp(
	athl_name varchar(50),
    sex varchar(1),
	category varchar(3),
    division varchar(50),
	meetdate varchar(10),
    meetcountry varchar(50), 
    meetname varchar(200),
    equipment varchar(15),
    age float,
    bodyweight float, 
    squat1 float,
    squat2 float,
    squat3 float,
    squat4 float,
    bench1 float,
    bench2 float,
    bench3 float,
    bench4 float,
    deadlift1 float, 
    deadlift2 float,
    deadlift3 float,
    deadlift4 float,
	totalkg float,
    place varchar(4),
    wilks float,
    mcculloch float,
    glossbrenner float,
    ipfpoints float
    ); 
    
LOAD DATA INFILE 'results.csv'
INTO TABLE results_temp
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

update results_temp set division = 'NA' where division is null;

# squat < 0 set equal to 0
update results_temp set squat1=0 where squat1<0;
update results_temp set squat2=0 where squat2<0;
update results_temp set squat3=0 where squat3<0;
update results_temp set squat4=0 where squat4<0;

# bench < 0 set equal to 0
update results_temp set bench1=0 where bench1<0;
update results_temp set bench2=0 where bench2<0;
update results_temp set bench3=0 where bench3<0;
update results_temp set bench4=0 where bench4<0;

# deadlift < 0 set equal to 0
update results_temp set deadlift1=0 where deadlift1<0;
update results_temp set deadlift2=0 where deadlift2<0;
update results_temp set deadlift3=0 where deadlift3<0;
update results_temp set deadlift4=0 where deadlift4<0;

# AGE CLASS

LOAD DATA INFILE 'ageclass.csv'
INTO TABLE ageclass
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;