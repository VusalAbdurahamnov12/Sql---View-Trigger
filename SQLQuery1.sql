CREATE database my_db;
use my_db


create table posts
(
Id int identity (1,1) primary key,
Content nvarchar(50) not null,
PostedTime date DEFAULT getdate(),
[Like] int default 0 check([Like]>0),
IsDeleted bit default 0,
UserId int references users(id)
)

insert into posts(Content,[Like],UserId)
values('Dunya',1000,1),('Worlklow',98084,2),('FirstVideo',1000000,3)


create table users(
Id int identity (1,1) primary key,
PeopleId int references People(id),
Login nvarchar(50) CHECK(len(Login) > 4) not null,
Password nvarchar(120) CHECK(len(Password) > 8) not null,
Mail nvarchar(200) 
)

insert into users(UserId,Login,Password,Mail)
values(2,'Ruslan_02','Test79897','test@gmail.com'),(1,'aqsin_02','Denemeasds','Deneme@gmail.com'),(3,'Mirzali','Unnasdsaamed','mail@mail.com')
select *from users


create table Comment (
Id int identity (1,1) primary key,
UserId int references users(id),
PostId int references posts(id),
[Like] int default 0 check([Like]>0),
IsDeleted bit default 0
)
insert into Comment(UserId,PostId,[Like],IsDeleted)
values(1,2,1000,0),(2,1,1000,0),(1,2,98000,1),(3,1,100000,0)



create table People  (
Id int identity (1,1) primary key,
name nvarchar(200) not null,
surname nvarchar(200) default 'XXX',
age int check(age>0) 
) 

select *from people
insert into People (name,surname,age)
values('aqsin','sadiqov',17),('ruslan','qasimov',19),('mirzali','memmedov',24)




--Postlara gələn comment sayların göstərin

SELECT p.Content, Count(c.Id) FROM Comment AS C
INNER JOIN Posts AS P
ON
P.Id = C.PostId
GROUP BY P.Content


--Bütün dataları göstərən relations qurun, Viewda saxlayın
CREATE VIEW AllData
As
SELECT p.Name, p.Surname, p.Age, u.Login, u.Mail, u.Password, ps.Content, ps.PostedTime, ps.[Like] AS 'Like Count', c.[Like] AS 'Comment Like Count' FROM Users AS u
 JOIN People AS p
ON
u.Id = p.Id 
 JOIN Posts AS ps
ON
ps.UserId = u.Id
 JOIN Comment AS c
ON
ps.Id = c.PostId

--select *from AllData

--Rəyi və ya paylaşımı silən zaman silinməsi əvəzinə IsDeleted dəyəri true olsun

CREATE TRIGGER PostDeleteUpdate
ON Posts
INSTEAD OF DELETE
AS
DECLARE @Id int
SELECT @Id = Id from deleted
UPDATE posts SET IsDeleted = 1 WHERE Id = @Id
CREATE TRIGGER Commentisdeleted
ON Comment
INSTEAD OF DELETE
AS
DECLARE @Id int
SELECT @Id = Id from deleted
UPDATE Comment SET IsDeleted = 1 WHERE Id = @Id