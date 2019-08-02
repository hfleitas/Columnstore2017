create table Band (BandId int identity(1,1) primary key, Band nvarchar(50), Album nvarchar(50));
create table Song (SongId int identity(1,1) primary key, BandId int foreign key references Band(BandId), Cost int);
go


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