--  By: Hiram Fleitas, hiramfleitas@hotmail.com. 

--  +--------+
--  | Backup |
--  +--------+
--  :connect lprospect010
backup database [\,,/(◣_◢)\,,/] to disk = 'C:\Deployments\RockOn.bak'
with noformat, noinit, skip, norewind, nounload, compression
--, encryption(algorithm = AES_256, server certificate = [BackupCertWithPK])
, stats = 25;
go

--  +-------------------+
--  | Restore + Replace |
--  +-------------------+
--  :connect localhost
set nocount on;
declare @kill nvarchar(max) = '';

if exists (select 1 from sys.dm_exec_sessions where database_id  = db_id('\,,/(◣_◢)\,,/'))
begin
	select 	@kill = @kill + 'KILL ' + convert(varchar(5), session_id) + ';'
	from	sys.dm_exec_sessions
	where 	database_id  = db_id('\,,/(◣_◢)\,,/')

	exec sp_executesql @kill;
end
go

if db_id(N'\,,/(◣_◢)\,,/') is not null
begin 
	alter database [\,,/(◣_◢)\,,/] set single_user with rollback immediate;
	drop database [\,,/(◣_◢)\,,/] end
else begin
	restore database [\,,/(◣_◢)\,,/] from disk = '\\lprospect010\c$\Deployments\RockOn.bak' with replace, file = 1,  
	move N'RockOn' to N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\RockOn.mdf', 
	move N'RockOn_log' to N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\RockOn_log.ldf',  
	nounload, stats = 25;
end
go
