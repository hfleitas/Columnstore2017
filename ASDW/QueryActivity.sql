select @@version

SELECT *
FROM    sys.dm_operation_status
WHERE   resource_type_desc = 'Database'
AND     major_resource_id = 'dw'

-- + -------------- +
-- | Query Activity |
-- + -------------- +
SELECT * FROM sys.dm_pdw_request_steps
WHERE request_id = 'QID725324'
--and status<>'Complete'
ORDER BY step_index;

SELECT waits.session_id,
      waits.request_id,  
      requests.command,
      requests.status,
      requests.start_time,  
      waits.type,
      waits.state,
      waits.object_type,
      waits.object_name
FROM   sys.dm_pdw_waits waits
   JOIN  sys.dm_pdw_exec_requests requests
   ON waits.request_id = requests.request_id
-- WHERE waits.request_id = 'QID725324'
ORDER BY waits.object_name, waits.object_type, waits.state;

SELECT request_id, distribution_id, status, spid 
FROM sys.dm_pdw_sql_requests 
WHERE request_id = 'QID1766589' 
AND step_index = 9;

-- https://docs.microsoft.com/en-us/sql/t-sql/database-console-commands/dbcc-pdw-showexecutionplan-transact-sql?view=aps-pdw-2016-au7#examples-
DBCC PDW_SHOWEXECUTIONPLAN(1, 612);

SELECT * FROM sys.dm_pdw_dms_workers
WHERE request_id = 'QID725324' AND step_index = 2;


--https://github.com/microsoft/sql-data-warehouse-samples/blob/master/solutions/monitoring/scripts/views/microsoft.vw_sql_requests.sql
PRINT 'Info: Creating the ''microsoft.vw_sql_requests'' view';
GO
create schema [microsoft]
go
CREATE VIEW microsoft.vw_sql_requests
AS
(
	SELECT
		sr.request_id,
		sr.step_index,
		(CASE WHEN (sr.distribution_id = -1 ) THEN (SELECT pdw_node_id FROM sys.dm_pdw_nodes WHERE type = 'CONTROL') ELSE d.pdw_node_id END) AS pdw_node_id,
		sr.distribution_id,
		sr.status,
		sr.error_id,
		sr.start_time,
		sr.end_time,
		sr.total_elapsed_time,
		sr.row_count,
		sr.spid,
		sr.command
	FROM
		sys.pdw_distributions AS d
		RIGHT JOIN sys.dm_pdw_sql_requests AS sr ON d.distribution_id = sr.distribution_id
)
GO

-- Monitor tempdb
SELECT
	sr.request_id,
	ssu.session_id,
	ssu.pdw_node_id,
	sr.command,
	sr.total_elapsed_time,
	es.login_name AS 'LoginName',
	DB_NAME(ssu.database_id) AS 'DatabaseName',
	(es.memory_usage * 8) AS 'MemoryUsage (in KB)',
	(ssu.user_objects_alloc_page_count * 8) AS 'Space Allocated For User Objects (in KB)',
	(ssu.user_objects_dealloc_page_count * 8) AS 'Space Deallocated For User Objects (in KB)',
	(ssu.internal_objects_alloc_page_count * 8) AS 'Space Allocated For Internal Objects (in KB)',
	(ssu.internal_objects_dealloc_page_count * 8) AS 'Space Deallocated For Internal Objects (in KB)',
	CASE es.is_user_process
	WHEN 1 THEN 'User Session'
	WHEN 0 THEN 'System Session'
	END AS 'SessionType',
	es.row_count AS 'RowCount'
FROM sys.dm_pdw_nodes_db_session_space_usage AS ssu
	INNER JOIN sys.dm_pdw_nodes_exec_sessions AS es ON ssu.session_id = es.session_id AND ssu.pdw_node_id = es.pdw_node_id
	INNER JOIN sys.dm_pdw_nodes_exec_connections AS er ON ssu.session_id = er.session_id AND ssu.pdw_node_id = er.pdw_node_id
	INNER JOIN microsoft.vw_sql_requests AS sr ON ssu.session_id = sr.spid AND ssu.pdw_node_id = sr.pdw_node_id
WHERE DB_NAME(ssu.database_id) = 'tempdb'
	AND es.session_id <> @@SPID
	-- and es.login_name <>'sa'
	-- AND es.login_name ='hiramXL'
ORDER BY sr.request_id;

-- Memory consumption
SELECT
  pc1.cntr_value as Curr_Mem_KB, 
  pc1.cntr_value/1024.0 as Curr_Mem_MB,
  (pc1.cntr_value/1048576.0) as Curr_Mem_GB,
  pc2.cntr_value as Max_Mem_KB,
  pc2.cntr_value/1024.0 as Max_Mem_MB,
  (pc2.cntr_value/1048576.0) as Max_Mem_GB,
  pc1.cntr_value * 100.0/pc2.cntr_value AS Memory_Utilization_Percentage,
  pc1.pdw_node_id
FROM
-- pc1: current memory
sys.dm_pdw_nodes_os_performance_counters AS pc1
-- pc2: total memory allowed for this SQL instance
JOIN sys.dm_pdw_nodes_os_performance_counters AS pc2 
ON pc1.object_name = pc2.object_name AND pc1.pdw_node_id = pc2.pdw_node_id
WHERE
pc1.counter_name = 'Total Server Memory (KB)'
AND pc2.counter_name = 'Target Server Memory (KB)'

-- Transaction log size
SELECT
  instance_name as distribution_db,
  cntr_value*1.0/1048576 as log_file_size_used_GB,
  pdw_node_id 
FROM sys.dm_pdw_nodes_os_performance_counters 
WHERE 
instance_name like 'Distribution_%' 
AND counter_name = 'Log File(s) Used Size (KB)'

-- Monitor rollback
SELECT 
	SUM(CASE WHEN t.database_transaction_next_undo_lsn IS NOT NULL THEN 1 ELSE 0 END),
	t.pdw_node_id,
	nod.[type]
FROM sys.dm_pdw_nodes_tran_database_transactions t
JOIN sys.dm_pdw_nodes nod ON t.pdw_node_id = nod.pdw_node_id
GROUP BY t.pdw_node_id, nod.[type]

SELECT * FROM sys.dm_pdw_waits

