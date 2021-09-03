select count_big(*) from threeb         --4070752305
select count_big(*) from TempDeleteMe2b --4056357991
select count_big(*) from TempDeleteMe3b --4070752305
select count_big(*) from TempDeleteMe4b --4070752305
select count_big(*) from TempDeleteMe2bctas --4070752305


DBCC PDW_SHOWSPACEUSED('dbo.TempDeleteMe2b');
DBCC PDW_SHOWSPACEUSED('dbo.TempDeleteMe3b');
DBCC PDW_SHOWSPACEUSED('dbo.TempDeleteMe4b');
DBCC PDW_SHOWSPACEUSED('dbo.Output12');
DBCC PDW_SHOWSPACEUSED('dbo.Input12');

exec sp_spaceused 'dbo.threeb';         --4070752305          28715632 KB
exec sp_spaceused 'dbo.TempDeleteMe2b'; --4056357991          185309408 KB
exec sp_spaceused 'dbo.TempDeleteMe2bctas'; --4070752305          228891880 KB
exec sp_spaceused 'dbo.TempDeleteMe3b'; --4070752305          217515432KB/1GB
exec sp_spaceused 'dbo.TempDeleteMe4b'; --4070752305          205674616KB/1GB
exec sp_spaceused 'dbo.Output12';       --4049287744          195116008 KB
exec sp_spaceused 'dbo.Input12';        --256285023           10477080 KB

--10% data skew
select *
from dbo.vTableSizes
where two_part_name in
    (
    select two_part_name
    from dbo.vTableSizes
    where row_count > 0
    group by two_part_name
    having (max(row_count * 1.000) - min(row_count * 1.000))/max(row_count * 1.000) >= .10
    )
and table_name ='threeb'
order by two_part_name, row_count
;

select top 100
    PremJump,
	IFRS_Calc_Adj,
	IFRS_Calc_GAAP_Adj,
	IFRS_Calc_CC_Adj
from dbo.TempDeleteMe2b
where TempDeleteMe2bID <=100