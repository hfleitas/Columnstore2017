create or alter proc GetRowCounts --'SRUSSegmentedPolicyRecords_Final2017Revised, HLRSegmentedPolicyRecords_Final2017Revised, BrockSegmentedPolicyRecords_Final2017Revised'
    @tables nvarchar(max)
as 
set nocount on;
    
    declare @sql nvarchar(max), @cnt int, @cnt2 int, @name nvarchar(128);

    if object_id('tempdb.dbo.#t') is not null drop table #t
    create table #t (
        name        nvarchar(128),
        rows        char(20),
        reserved    varchar(18),
        data        varchar(18),
        index_size  varchar(18),
        unused      varchar(18)
    );

    if object_id('tempdb.dbo.#tables') is not null drop table #tables
    create table #tables (
        name        nvarchar(128)
    );
    insert into #tables (name) select trim(value) from string_split(@tables,',');
    
    select @cnt = count(*) from information_schema.tables where table_name in (select name from #tables);
    select @cnt2 = count(*) from #t;
   
    while @cnt>@cnt2
    begin
        select  top 1 @sql='insert into #t exec sp_spaceused '''+table_name+'''', @name=table_name
        from    information_schema.tables 
        where   table_name in (select top 1 name from #tables);
        
        exec sp_executesql @sql; --print @sql;
        
        delete from #tables where name = @name;
        select  @cnt2 = count(*) from #t;
    end
    select * from #t
go