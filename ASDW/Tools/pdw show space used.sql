exec sp_spaceused 'ctasOutputCashSum12'
exec sp_spaceused 'ctasOutputCashSum36'

DBCC PDW_SHOWSPACEUSED('ctasOutputCashSum12')
DBCC PDW_SHOWSPACEUSED('ctasOutputCashSum36')

exec sp_spaceused 'ctasOutput12Stage2'
DBCC PDW_SHOWSPACEUSED('ctasOutput12Stage2')


exec sp_spaceused 'ctasOutputStageResCalc'
DBCC PDW_SHOWSPACEUSED('ctasOutputStageResCalc')

  
exec sp_spaceused 'ctasOutputStageResTrueUp' 
go
exec sp_spaceused 'ctasOutputStage2PremiumLag' 
go
exec sp_spaceused 'ctasOutput12Joins'

DBCC PDW_SHOWSPACEUSED('ctasOutputStageResTrueUp' )
go
DBCC PDW_SHOWSPACEUSED('ctasOutputStage2PremiumLag')
go
DBCC PDW_SHOWSPACEUSED('ctasOutput12Joins')