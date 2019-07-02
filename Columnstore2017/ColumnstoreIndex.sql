use tempdb
go
--  +---------+
--  | rockon! |
--  +---------+
if db_id(N'\,,/(◣_◢)\,,/') is null
begin
	create database [\,,/(◣_◢)\,,/] 
	on primary (name='RockOn',filename='C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\RockOn.mdf', size=1024MB, maxsize=unlimited, filegrowth=64MB)
	log on (name='RockOn_log',filename='C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\RockOn_log.ldf', size=256MB, filegrowth=64MB)
end
go

use [\,,/(◣_◢)\,,/]
go
create table Band (BandId int identity(1,1) primary key, Band nvarchar(50), Album nvarchar(50));
create table Song (SongId int identity(1,1) primary key, BandId int foreign key references Band(BandId), Cost int);
go

--asdw
create table Band (BandId int identity(1,1), Band nvarchar(50), Album nvarchar(50));
create table Song (SongId int identity(1,1), BandId int, Cost int);
go
drop table Band
drop table Song


--  +---------+
--  | rockon! | 1+mil 00:01:47.219, 10+mil 00:17:45.153
--  +---------+ 
declare @count int = 1;
set nocount on;
	while @count <= 5120000
	begin 
		insert into Band values ('Metalls','Justice') 
		set @count = @count + 1 --go 5120000
	end
	print @count
	while @count <=10240000
	begin 
		insert into Band values ('AZ/DZ','Screaming Bells')
		set @count = @count + 1 --go 5120000 
	end
go

select min(bandid), max(bandid) from band; --FK: set @minBand, @maxBand.
go

--  +---------+
--  | rockon! | 1+mil 00:01:49.583, 15+mil 00:27:44.412
--  +---------+
declare @count int=1, @Band int, @cost int, @minBand int=1, @maxBand int=10240000, @minCost int=1, @maxCost int=99;
set nocount on;
	while @count <= 15360000
	begin 
		select @Band = round(((@maxBand - @minBand) * rand()) + @minBand, 0)
		select @cost = round(((@maxCost - @minCost) * rand()) + @minCost, 0)

		insert into Song values (@Band, @cost)
		set @count = @count + 1
	end

exec sp_spaceused 'band' --539208 KB	537120 KB	2008 KB
exec sp_spaceused 'song' --320456 KB	319176 KB	1200 KB
go

--  +---------+
--  | rockon! |  9sec, 00:00:09.347
--  +---------+
set statistics io, time on;
select Band, Album, sum(Cost) as TotalCost
from Song s
inner join	Band b on s.BandId=b.BandId
group by Band, Album 
order by TotalCost desc
option(recompile, querytraceon 9453); --forces rowmode
go
	--  +------------+
	--  | drum solo! |
	--  +------------+
	alter table Song drop constraint PK__Song__12E3D6979254FB39 --get name first.
	create clustered columnstore index max_Bass on Song;
	go
		/*drop index max_Bass on Song; alter table Song add constraint PK__Song__12E3D6979254FB39 primary key clustered (SongId asc);*/

	--  +---------+
	--  | battle! |
	--  +---------+
	--alter table Song drop constraint FK__Song__BandId__398D8EEE; alter table Band drop constraint PK__Band__A03693A83083D908; create clustered columnstore index big_Concert on Band;
	--drop index big_Concert on Band; alter table Band add constraint PK__Band__A03693A83083D908 primary key clustered (BandId asc); alter table Song add constraint FK__Song__BandId__398D8EEE foreign key (BandId) references Band(BandId);	
	go

--  +---------+
--  | rockon! | 1sec
--  +---------+	
select Band, Album, sum(Cost) as TotalCost
from Song s
inner join Band b on s.BandId=b.BandId
group by Band, Album 
order by TotalCost desc
option(recompile);
go --00:00:01.153

/*
dbcc freeproccache
dbcc dropcleanbuffers
drop index max_Bass on Song; alter table Song add constraint PK__Song__12E3D6979254FB39 primary key clustered (SongId asc);
*/
go

--  +---------+
--  | rockon! | 9sec, 00:00:09.555
--  +---------+	
select Band, Album, avg(Cost) as AvgCost, min(Cost) as MinCost, max(Cost) as MaxCost
from Song s
inner join Band b on s.BandId=b.BandId
group by Band, Album 
order by AvgCost desc
option(recompile, querytraceon 9453); --forces rowmode
go

	--  +--------------+
	--  | guitar solo! |
	--  +--------------+
	alter table Song drop constraint PK__Song__12E3D6979254FB39 
	create clustered columnstore index max_Bass on Song;
	go

--  +---------+
--  | rockon! | 1sec
--  +---------+	
select Band, Album, avg(Cost) as AvgCost, min(Cost) as MinCost, max(Cost) as MaxCost
from Song s
inner join Band b on s.BandId=b.BandId
group by Band, Album 
order by AvgCost desc
option(recompile);
go --00:00:01.371

--  +---------+
--  | rockon! | 10x
--  +---------+	
--  drop table song2
select * into Song2 from Song 
exec sp_spaceused 'song'; exec sp_spaceused 'song2';
go

drop table if exists RockOn;
create table RockOn (id int);
create clustered columnstore index cidx_Loud on RockOn;
go

select Band, Album, avg(Cost) as AvgCost, min(Cost) as MinCost, max(Cost) as MaxCost
from Song2 s
inner join Band b on s.BandId=b.BandId
left outer join RockOn on 1=0 -- 1sec vs 9sec
group by Band, Album 
order by AvgCost desc
option(recompile);
go 

--  +--------------+
--  | end of show! |
--  +--------------+	
use tempdb
go
alter database [\,,/(◣_◢)\,,/] set single_user with rollback immediate --this will del file, offline will not.
drop database [\,,/(◣_◢)\,,/]
go