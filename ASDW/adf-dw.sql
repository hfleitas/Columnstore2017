drop table character;
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
	VoicedBy		varchar(50)			null,
);
go

if object_id('Customer') is not null drop table Customer
begin
	create table Customer (
 		 [CustomerId]	int 
		,[Name]			nvarchar(256)
		,[Email]		varchar(320)
	);
end
go
if object_id('CustomerAccount') is not null drop table CustomerAccount
begin
	create table CustomerAccount (
 		 [CustomerAccountId]	int 
		,[CustomerId]			int 
		,[AcctNumEnding]		int
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