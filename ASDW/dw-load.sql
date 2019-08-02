dw-load 

--asdw
drop table Band
drop table Song
go
create table Band (BandId int identity(1,1), Band nvarchar(50), Album nvarchar(50));
create table Song (SongId int identity(1,1), BandId int, Cost int);

drop proc LoadBand;
go
create proc LoadBand as 
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

drop proc LoadSong;
go
create proc LoadSong as 
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
go     

exec sp_spaceused 'band' --539208 KB	537120 KB	2008 KB
exec sp_spaceused 'song' --320456 KB	319176 KB	1200 KB

exec LoadBand;
exec LoadSong;