select count(*) from Band

SELECT  db.name [Database],	    
        ds.edition [Edition],
        ds.service_objective [Service Objective]
FROM    sys.database_service_objectives AS ds
JOIN    sys.databases AS db 
    ON ds.database_id = db.database_id
;

SELECT    *
FROM      sys.dm_operation_status
WHERE     resource_type_desc = 'Database'
AND       major_resource_id = 'dw'
;

alter database dw MODIFY (SERVICE_OBJECTIVE = 'DW1000c'); 
--DW100c

SELECT  db.name [Database],
        ds.edition [Edition],
        ds.service_objective [Service Objective]
FROM    sys.database_service_objectives ds
JOIN    sys.databases db 
    ON ds.database_id = db.database_id
WHERE   db.name = 'dw';

WHILE (
    SELECT TOP 1 state_desc
    FROM sys.dm_operation_status
    WHERE 1=1
    AND resource_type_desc = 'Database'
    AND major_resource_id = 'MySampleDataWarehouse'
    AND operation = 'ALTER DATABASE'
    ORDER BY start_time DESC
) = 'IN_PROGRESS'
BEGIN
    RAISERROR('Scale operation in progress',0,0) WITH NOWAIT;
    WAITFOR DELAY '00:00:05';
END
PRINT 'Complete';