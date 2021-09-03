

if object_id('tempdb.dbo.#t') is not null drop table #t
create table #t (
    name        nvarchar(128),
    rows        char(20),
    reserved    varchar(18),
    data        varchar(18),
    index_size  varchar(18),
    unused      varchar(18)
)

declare @sql nvarchar(max);
insert into #t exec sp_spaceused 'treatymap' 
insert into #t exec sp_spaceused 'inforce'
insert into #t exec sp_spaceused 'premium'
insert into #t exec sp_spaceused 'modelfeatures'
insert into #t exec sp_spaceused 'center'        
insert into #t exec sp_spaceused 'claim'         
insert into #t exec sp_spaceused 'model'         
insert into #t exec sp_spaceused 'policyshare'  

select  name, convert(decimal(5,2),cast(rows as bigint)/4797*100) as prog from #t where name ='treatymap' union all
select  name, convert(decimal(5,2),cast(rows as bigint)/342486803*100) as prog from #t where name ='inforce' union all
select  name, convert(decimal(5,2),cast(rows as bigint)/158515622*100) as prog from #t where name ='premium' union all
select  name, convert(decimal(5,2),cast(rows as bigint)/5937812*100) as prog from #t where name ='modelfeatures' union all
select  name, convert(decimal(5,2),cast(rows as bigint)/2587059330*100) as prog from #t where name ='center' union all
select  name, convert(decimal(5,2),cast(rows as bigint)/30697256*100) as prog from #t where name ='claim' union all
select  name, convert(decimal(5,2),cast(rows as bigint)/2203326241*100) as prog from #t where name ='model' union all
select  name, convert(decimal(5,2),cast(rows as bigint)/133193365*100) as prog from #t where name ='policyshare'

select * from #t

-- master 
select  top 1 storage_in_megabytes/1024 as DatabaseDataSpaceUsedInGB
from    sys.resource_stats 
where   database_name = 'stage' 
order by end_time desc;
go

-- stage
select      sum(size*8/1024/1024) as DatabaseDataSpaceAllocatedInMB, 
            sum(size*8/1024/1024 - cast(fileproperty(name, 'SpaceUsed') as int)*8/1024/1024) AS DatabaseDataSpaceAllocatedUnusedInMB 
from        sys.database_files 
group by    type_desc 
having      type_desc = 'ROWS' 

-- stage
select databasepropertyex('stage', 'MaxSizeInBytes') AS MaxSizeInBytes 
