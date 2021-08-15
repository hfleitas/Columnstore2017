-- select count_big(*) from ext.TempDeleteMe2b 
-- where JOIN_KEY_NO_DATE = '1026922533864758664'
-- 12:28:35 PMStarted executing query at Line 1
-- (1 row affected)
-- Total execution time: 00:07:59.437

-- with hiram below


-- select table_name, row_count_total, rowgroup_per_distribution_MAX, COMPRESSED_rowgroup_rows_MIN, COMPRESSED_rowgroup_rows_AVG from vColumnstoreDensity
-- where table_name like 'ctasSuperTableSum%'
-- order by table_name

-- DBCC PDW_SHOWSPACEUSED('dbo.ctasSuperTableSum');



-- select COUNT_BIG(*) from ctasSuperTableSumUpdate where Treaty_Model_ID is null; 
-- select COUNT_BIG(*) from ctasSuperTableSumUpdate;


-- select count_big(JOIN_KEY_NO_DATE) from ctasSuperTableActualStage where RyanFilter = 1 group by JOIN_KEY_NO_DATE having count_big(JOIN_KEY_NO_DATE) > 500000;


select sourceTableName, sourceTableNameInput, Output12Group, Output12CleanGroup, valntimeforlag, dateIncurred, sum_if_b, sum_if_e, dth_clms, premium from ext.TempDeleteMe2b
where JOIN_KEY_NO_DATE = '1026922533864758664'
order by sourceTableName, sourceTableNameInput, Output12Group, Output12CleanGroup, dateIncurred
-- 2:10:52 PMStarted executing query at Line 1
-- (579 rows affected)
-- Total execution time: 00:52:11.377