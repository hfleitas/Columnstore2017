--dw master

if exists (select 1 from sys.sql_logins where name='LoaderXL') drop login LoaderXL;
create login LoaderXL with password = 'XL!sqlPools2021'
alter login LoaderXL enable
go 
drop user LoaderXL;
go
create user LoaderXL for login LoaderXL
alter role dbmanager add member LoaderXL

-- use hiramdw
drop user LoaderXL;
create user LoaderXL for login LoaderXL
go
exec sp_addrolemember db_owner, LoaderXL;
EXEC sp_addrolemember 'xlargerc', 'LoaderXL'

grant view definition to public;
grant showplan to LoaderXL;
grant connect to LoaderXL
go 