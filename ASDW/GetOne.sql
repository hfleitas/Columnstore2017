drop table one;
go

create table one (dt datetime, n int)
go

insert one (dt, n)
select getdate(), 1
go

if object_id('getone') is not null drop proc getone;
go 

create proc getone 
as 
    set nocount on;
    --set result_set_caching on;

    select * from one;
go

execute dbo.getone;