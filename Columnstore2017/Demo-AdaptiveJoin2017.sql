use atlas
go

create or alter procedure uspGetAssignments
@TypeID int = null,
@statusID int = null
as

if object_id('tempdb.dbo.#Assignments') is not null drop table #Assignments
create table	#Assignments (
		QueueID				integer,
		AssignedTo			integer,
		AssignedToRoleID	integer)

insert into	#Assignments
select		a.QueueID,
			a.AssignedTo,
			a.AssignedToRoleID
from		[Workflow].[Assignments] as a
inner join	[Workflow].[Queue] as q
	on		q.QueueID = a.QueueID
where		a.Active = 1
	and		nullif(@TypeID, q.TypeID) is null
	and		nullif(@StatusID, q.StatusID) is null
option (label = 'F1352E2F-866A-4A10-B660-2875D18B05D8');
go

set nocount on;
set statistics io, time on;

exec uspGetAssignments
go
--00:00:00.886
--9 operations, row execution mode.
/*Table 'Assignments'. Scan count 9, logical reads 8052, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Queue'. Scan count 9, logical reads 8995, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Workfile'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 3939 ms,  elapsed time = 706 ms.

 SQL Server Execution Times:
   CPU time = 3954 ms,  elapsed time = 714 ms.
*/
--get from plan xml or from cache below.
--StatementSqlHandle="..."

select cp.usecounts, cp.plan_handle, st.text
from sys.dm_exec_cached_plans as cp
cross apply sys.dm_exec_sql_text(cp.plan_handle) as st
where st.text like '%F1352E2F-866A-4A10-' + 'B660-2875D18B05D8%';

dbcc freeproccache (0x050024002F24801DA0FB01F76C00000001000000000000000000000000000000000000000000000000000000);

select cp.usecounts, cp.plan_handle, st.text
from sys.dm_exec_cached_plans as cp
cross apply sys.dm_exec_sql_text(cp.plan_handle) as st
where st.text like '%F1352E2F-866A-4A10-' + 'B660-2875D18B05D8%';

drop index if exists ncci_WorkflowQueue_YESPLEASE ON [Workflow].[Queue];
create nonclustered columnstore index ncci_WorkflowQueue_YESPLEASE
  on [Workflow].[Queue](QueueID) where QueueID = -1 AND QueueID = -2;

exec uspGetAssignments
--00:00:00.693
--7 operations
/*
Table 'Queue'. Scan count 9, logical reads 8995, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Assignments'. Scan count 9, logical reads 8052, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.
Table 'Worktable'. Scan count 0, logical reads 0, physical reads 0, read-ahead reads 0, lob logical reads 0, lob physical reads 0, lob read-ahead reads 0.

 SQL Server Execution Times:
   CPU time = 2843 ms,  elapsed time = 747 ms.

 SQL Server Execution Times:
   CPU time = 2859 ms,  elapsed time = 758 ms.
*/

select cp.usecounts, cp.plan_handle, st.text
from sys.dm_exec_cached_plans as cp
cross apply sys.dm_exec_sql_text(cp.plan_handle) as st
where st.text like '%F1352E2F-866A-4A10-' + 'B660-2875D18B05D8%';

--cleanup
dbcc freeproccache (0x05002400F6FF8B1CA0FB01F76C00000001000000000000000000000000000000000000000000000000000000);
drop index if exists ncci_WorkflowQueue_YESPLEASE ON [Workflow].[Queue];
drop procedure if exists uspGetAssignments;