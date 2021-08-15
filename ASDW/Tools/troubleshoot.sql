dbcc pdw_showspaceused (Output12);
dbcc pdw_showspaceused (Out12Coverage);
dbcc pdw_showspaceused (Output12Joins);
dbcc pdw_showspaceused (ctasGAAPFactorID);


exec sp_spaceused 'Output12';            --14401258581         	820780000 KB	709209728 KB	111536752 KB	33520 KB
exec sp_spaceused 'Out12Coverage';       --139,496,057
exec sp_spaceused 'Output12Joins';       --112,867,163
exec sp_spaceused 'ctasGAAPFactorID';    --3,071,446,009

exec sp_spaceused 'TempDeleteMe2b';      --5,740,199,672

alter index all on Output12 rebuild; --22 minutes
alter index all on Out12Coverage rebuild;
alter index all on Output12Joins rebuild;
alter index all on ctasGAAPFactorID rebuild;


--gen2
select * from sys.dm_pdw_errors
select * from sys.dm_pdw_dms_cores
select * from sys.dm_pdw_dms_workers where request_id = 'QID3187802'
--gen1
--select * from sys.dm_pdw_component_health_alerts
--select * from sys.dm_pdw_os_event_logs