--Leads

if object_id('Customer') is not null drop table Customer
begin
	create table Customer (
 		 [CustomerId]	int 
		,[Name]			nvarchar(256)
		,[Email]		varchar(320)
	)
	with (
		distribution = hash(CustomerId),
		clustered columnstore index
	);
end
go

if object_id('CustomerAccount') is not null drop table CustomerAccount
begin
	create table CustomerAccount (
 		 [CustomerAccountId]	int 
		,[CustomerId]			int 
		,[AcctNumEnding]		int
	)
	with (
		distribution = hash(CustomerId),
		clustered columnstore index
	);
end
go
if object_id('Lead') is not null drop table Lead
begin
	create table Lead (
 		 [LeadId]		int 
		,[Name]			nvarchar(256)
		,[Email]		varchar(320)
		,[Address]		nvarchar(256)
		,[Status]		bit 
		,[CreatedBy]	nvarchar(128) 
		,[CreatedOn]	datetime 
		,[ModifiedBy]	nvarchar(128) 
		,[ModifiedOn]	datetime 
	);
end
go
if object_id('Ticket') is not null drop table Ticket
begin
	create table Ticket (
 		 [TicketId]			int 
		,[CustomerId]		int 
		,[AcctNumEnding]	int	
		,[Status]			bit 
		,[LeadId]			int 
		,[CreatedBy]		nvarchar(128) 
		,[CreatedOn]		datetime 
		,[ModifiedBy]		nvarchar(128) 
		,[ModifiedOn]		datetime
	);
end
go

--Trollhunters
if object_id('Character') is not null drop table Character
go
create table [Character] ( 
	CharacterId		int             	not null,
    FullName		varchar(50)			not null,
	Affiliation		varchar(60)			null, 
	Category		varchar(10)			null, 
	Aka				varchar(300)		null, --*
	[Status]		varchar(35)			null,
	Race			varchar(50)			null,
	Age				int					null,
	Home			varchar(50)			null,
	Relatives		varchar(300)		null, --*
	Weapons			varchar(100)		null, --*
	EyeColor		varchar(20)			null,
	HairColor		varchar(50)			null,
	Minions			varchar(100)		null,
	VoicedBy		varchar(50)			null
) 
with (
	distribution = hash(CharacterId),
	clustered columnstore index
);
go

if object_id('quotes') is not null drop table quotes
create table quotes (
    quoteid     int             ,
    character   varchar(128)    not null,
    quote       nvarchar(4000)   not null,
    sentiment   float
);
go 

select * from dbo.Character
select * from dbo.Quotes

select * from dbo.Customer
select * from dbo.CustomerAccount

-- Res: 
-- https://docs.microsoft.com/en-us/azure/data-factory/copy-activity-performance
-- https://docs.microsoft.com/en-us/azure/data-factory/connector-azure-sql-data-warehouse
-- https://docs.microsoft.com/en-us/azure/data-factory/connector-sql-server#append-data