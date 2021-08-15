CREATE PROC [ext].[AddTable] @extDestination [nvarchar](128),@extLocation [nvarchar](256),@extDS [nvarchar](128),@extFF [nvarchar](50),@printonly [bit],@columns [nvarchar](max) AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--checks
    if @extDS not in (select name from sys.external_data_sources) --hlramerica_raw, hlramerica_stage, hlramerica_prod
    and @extDestination in (select name from sys.external_tables where schema_id = SCHEMA_ID('ext'))
    and @extFF not in (select name from sys.external_file_formats) --parquet_ff, csv_ff
    
    begin 
        throw 151000, 'Checks Error: Invalid inputs.', 1;
    end 

	--declare @dropsql nvarchar(max) ='DROP EXTERNAL TABLE '+@extDestination
	--execute sp_executesql @dropsql

--run
    declare @sql nvarchar(max) =N'create external table [ext].['+@extDestination+']('+@columns+')
    with (   
        location = '''+ @extLocation +''',
        data_source = '+ @extDS +',  
        file_format = '+ @extFF +'
    );'
	--select count_big (*) from [ext].['+@extDestination+'];'
	
print @sql;
    if @printonly = 0
    begin
        execute sp_executesql @sql;
    end
END