CREATE PROC [ext].[MoveTable] @extDestination [nvarchar](256),@dboSource [nvarchar](256),@extLocation [nvarchar](256),@extDS [nvarchar](256),@extFF [nvarchar](128),@printonly [bit] AS
    
    --checks
    if @extDS not in (select name from sys.external_data_sources) --hlramerica_raw, hlramerica_stage, hlramerica_prod
    and @extDestination in (select name from sys.external_tables where schema_id = SCHEMA_ID('ext'))
    and @extFF not in (select name from sys.external_file_formats) --parquet_ff, csv_ff
    and @dboSource not in (select name from sys.tables)
    begin 
        throw 151000, 'Checks Error: Invalid inputs.', 1;
    end 

    --run
    declare @sql nvarchar(max) =N'create external table [ext].['+@extDestination+']
    with (   
        location = '''+ @extLocation +''',
        data_source = '+ @extDS +',  
        file_format = '+ @extFF +'
    )
    as select * from [dbo].['+@dboSource+'];
    select count_big (*) from [ext].['+@extDestination+'];
    exec sp_spaceused '+@dboSource+';
    drop table [dbo].['+@dboSource+'];'

    print @sql;
    if @printonly = 0
    begin
        execute sp_executesql @sql;
    end