
drop database prince;
create database prince;
use prince;
show databases;

create table Students(
	studId int not null primary key,
	studname varchar(25),
    marks int
);
create table address(
	studId int not null,
    city varchar(15),
    state varchar(15),
    postalCode int
); 

show Tables;

Rename Table Students to Student;

select * from Student;
select * from address;

Insert into Student values(10,"SRameshT",'100');
Insert into  student values (17,"ABD",45), (3,"Jaques","65"), (45,"RGurunathS",45), (99,"RChandranA",5);

create table students as select * from student;
drop table student;
delete from address where studId = 18;
create table students(
	studId int not null primary key,
	studname varchar(25),
    marks int
);
insert into students select * from student ;
rename table students to student;

alter table student add primary key (studId);
alter table address add primary key (studId);
alter table address drop Primary key;

alter table address add foreign key (studId) references student(studId);

Alter table student add column email varchar(30) after studname;
Alter table student add column uniq varchar(30) first ;
Alter table student add column defaul varchar(30);
alter table student drop column email;
alter table student drop uniq, drop defaul;

Insert into address (studId, city, state, postalCode) values (10, 'mumbai', "maharastra", 100100);
Insert into address (studId, state, postalCode) values (17, 'SouthAfrica', 45100);
Insert into address values(3, null, "southAfrica", 65100);
Insert into address values(18, 'newDelhi', 'Delhi', 78100);
Insert into address values(45, "nagpur", "maharastra", 45100);

update address set state = "westernCape" where studId =3;
update address set state = "warmbad" where studId =17;
alter table address modify column postalcode varchar(10);
alter table address modify column state char(15);
alter table address modify column postalcode int;

select distinct state from address;
select * from address where city is not null;
select studId, studname from student where marks = 45 and studname like '_Guru%';
select studId as ID, studname as NAME from student where marks = 100 or studname like 'A%';
select studId, state from address where state not like "%tr_"; 
-- '[AS]%' doesn't work  

select * from student where marks between 50 and 100;
Delete from student where studId in (10,3);
delete from student where studId <> 10;
Delete from Student;
Truncate student;

update student set studname = "ABenjaminD" where studId = 17;

select * from address limit 2 offset 1;
select * from address order by state desc, city asc;

select state, count(studId) from address group by state having count(studId)>1;
select min(postalCode),max(state) from address;

select * from student where studId < any (select studId from address);
select studId,state from address where studId <= all (select studId from student where marks = 100);

select studId,state,
case 
	when studId = 10 then 'Its master blaster'
    when studId = 17 then "Its alien"
    when studId = 18 then "he is all class"
end as nicknames
from address;

-- union does not allows duplicates by default 
select studId, postalCode from address
Union
select state,city from address;
select studId, postalCode from address
Union all
select state,city from address;
-- unionall allows duplicates
select studId, studname from student
Union all
select studname,marks from student;

select sum(marks) from student;
select count(*) from student;
select avg(marks) from student;

-- innerjoin 
select student.studId, student.studname, address.state from student
inner join address on student.studId = address.studId;

-- LeftJoin
select S.studId, S.studname, A.state from student S
left join address A on S.studId = A.studId;

-- rightjoin
select s.studId, s.studname, a.state, a.postalCode from student as s
right join address as a on s.studId = a.studId;

-- outerjoin
select student.studId, student.studname, address.state from student
cross join address;

-- selfjoin
SELECT A.studId AS StudentId1, B.state AS StudentId2, A.City
FROM address A, address B
WHERE A.studId <> B.studId AND A.state = B.state
ORDER BY A.city;

create index ID on student (studId);
create unique index STATE on address (city, state, postalCode);
alter table student drop index ID;

-- ifnull takes only two arg
select ifnull(city , state) from address;
-- coalesce takes more than two arg
select coalesce(city, null , 'default') from address;

select 10 & 15 and 10 | 15 or 0 & 5 as Bitwise_Operations;

create table studentAge(
	studId int not null,
    age int,
    foreign key (studId) references student (studId)
);
insert into studentAge values (3,48), (10,50), (45,36), (17,39), (99,37);

select s.studId, s.studname, a.age from student s
inner join studentage a
where s.studid = a.studId
order by s.marks desc;
