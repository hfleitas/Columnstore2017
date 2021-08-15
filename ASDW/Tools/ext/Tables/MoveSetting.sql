CREATE TABLE [ext].[MoveSetting] (
    [MoveSettingId]           INT            NULL,
    [ExtDestination]          NVARCHAR (256) NULL,
    [DboSource]               NVARCHAR (256) NULL,
    [ExtLocation]             NVARCHAR (256) NULL,
    [ExtDS]                   NVARCHAR (256) NULL,
    [ExtFF]                   NVARCHAR (128) NULL,
    [PrintOnly]               BIT            NULL,
    [OverwriteExtDestination] BIT            NULL,
    [DropDboSourceOnly]       BIT            NULL
)
WITH (CLUSTERED INDEX([MoveSettingId]), DISTRIBUTION = REPLICATE);

