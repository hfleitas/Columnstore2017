SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[QueryActivity] AS 
-- + -------------- +
-- | Query Activity |
-- + -------------- +
with cte as (
    select      top 100
                request_id, 
                status, 
                total_elapsed_time/60000 as TotalElapsedMinutes, 
                resource_class, 
                importance
    from        sys.dm_pdw_exec_requests 
    where       status not in ('Completed','Failed','Cancelled','Suspended')
                -- and request_id in ('QID3187802','QID3188080')
    and         session_id <> session_id()
    order by    submit_time desc
)
select      es.app_name,
            rs.request_id, 
            rs.step_index, 
            rs.operation_type, 
            rs.distribution_type, 
            rs.location_type, 
            rs.status, 
            rs.error_id, 
            rs.start_time, 
            rs.end_time, 
            case when rs.end_time is not null then cast(rs.end_time - rs.start_time as time) end as duration, 
            rs.total_elapsed_time/60000 as TotalElapsedMinutes, 
            rs.total_elapsed_time/3600000 as TotalElapsedHours, 
            rs.row_count, 
            rs.command, 
            cte.*
from        sys.dm_pdw_request_steps rs
inner join  cte 
    on rs.request_id = cte.request_id
left join  sys.dm_pdw_exec_sessions es 
    on rs.request_id = es.request_id
where       rs.status<>'complete'
order by    step_index;

--request_id	step_index	operation_type	distribution_type	location_type	status	error_id	start_time	end_time	duration	TotalElapsedMinutes	TotalElapsedHours	row_count	command	request_id	status	TotalElapsedMinutes	resource_class	importance
--QID827319	3	OnOperation	AllDistributions	Compute	Running	NULL	2019-09-05 21:30:07.010	NULL	NULL	199	3	-1	INSERT INTO [sql-eastus2-int-dev-reboot-analytics_wh].[dbo].[Inforce12New] WITH (TABLOCK) ([JOIN_KEY_ACTUALS], [SourceTableName], [BLOCK], [Date_Incurred], [Date_Reported], [Date_Posted], [YRMO], [InforceQuarter], [TLID], [TLID_SecondInsd], [Treaty_Sage_ID], [Treaty_TRS_ID], [Policy_Number], [Policy_Record_Number], [Policy_Rider_Number], [Coverage_Sage_CCID], [ConversionFlag], [OriginalCCID], [OriginalCCID_2], [OriginalPolicy], [OriginalPolicy_2], [FACE], [ReinsuredFace], [NAR], [sourceTableNameInput], [sourceTableNameInputTS], [sourceFileName], [IssueAgeL1], [SmokerL1], [BusinessBlockShort], [mosesBand], [mosesSeries], [mosesClassL1], [GenderL1], [mosesPlan], [IssueDate], [FalloutType1], [Treaty_Model_ID], [Treaty_PeopleSoft_ID], [BusinessBlock], [JOIN_KEY_MODEL], [JOIN_KEY_NO_DATE], [BenefitType])SELECT [T1_1].[JOIN_KEY_ACTUALS], [T1_1].[SourceTableName], [T1_1].[BLOCK], [T1_1].[Date_Incurred], [T1_1].[Date_Reported], [T1_1].[Date_Posted], [T1_1].[YRMO], [T1_1].[InforceQuarter], [T1_1].[TLID], [T1_1].[TLID_SecondInsd], [T1_1].[Treaty_Sage_ID], [T1_1].[Treaty_TRS_ID], [T1_1].[Policy_Number], [T1_1].[Policy_Record_Number], [T1_1].[Policy_Rider_Number], [T1_1].[Coverage_Sage_CCID], [T1_1].[ConversionFlag], [T1_1].[OriginalCCID], [T1_1].[OriginalCCID_2], [T1_1].[OriginalPolicy], [T1_1].[OriginalPolicy_2], [T1_1].[FACE], [T1_1].[ReinsuredFace], [T1_1].[NAR], [T1_1].[sourceTableNameInput], [T1_1].[sourceTableNameInputTS], [T1_1].[sourceFileName], [T1_1].[IssueAgeL1], [T1_1].[SmokerL1], [T1_1].[BusinessBlockShort], [T1_1].[mosesBand], [T1_1].[mosesSeries], [T1_1].[mosesClassL1], [T1_1].[GenderL1], [T1_1].[mosesPlan], [T1_1].[IssueDate], [T1_1].[FalloutType1], [T1_1].[Treaty_Model_ID], [T1_1].[col], [T1_1].[BusinessBlock], [T1_1].[JOIN_KEY_MODEL], [T1_1].[JOIN_KEY_NO_DATE], [T1_1].[BenefitType] FROM (SELECT CASE WHEN ([T2_1].[Treaty_PeopleSoft_ID] LIKE CAST (N'HA%' COLLATE SQL_Latin1_General_CP1_CI_AS AS VARCHAR (3)) COLLATE SQL_Latin1_General_CP1_CI_AS) THEN concat([T2_1].[Treaty_PeopleSoft_ID], CAST (N'-001' COLLATE SQL_Latin1_General_CP1_CI_AS AS VARCHAR (4)) COLLATE SQL_Latin1_General_CP1_CI_AS) ELSE [T2_1].[Treaty_PeopleSoft_ID]END AS [col], [T2_1].[JOIN_KEY_ACTUALS] AS [JOIN_KEY_ACTUALS], [T2_1].[SourceTableName] AS [SourceTableName], [T2_1].[BLOCK] AS [BLOCK], [T2_1].[Date_Incurred] AS [Date_Incurred], [T2_1].[Date_Reported] AS [Date_Reported], [T2_1].[Date_Posted] AS [Date_Posted], [T2_1].[YRMO] AS [YRMO], [T2_1].[InforceQuarter] AS [InforceQuarter], [T2_1].[TLID] AS [TLID], [T2_1].[TLID_SecondInsd] AS [TLID_SecondInsd], [T2_1].[Treaty_Sage_ID] AS [Treaty_Sage_ID], [T2_1].[Treaty_TRS_ID] AS [Treaty_TRS_ID], [T2_1].[Policy_Number] AS [Policy_Number], [T2_1].[Policy_Record_Number] AS [Policy_Record_Number], [T2_1].[Policy_Rider_Number] AS [Policy_Rider_Number], [T2_1].[Coverage_Sage_CCID] AS [Coverage_Sage_CCID], [T2_1].[ConversionFlag] AS [ConversionFlag], [T2_1].[OriginalCCID] AS [OriginalCCID], [T2_1].[OriginalCCID_2] AS [OriginalCCID_2], [T2_1].[OriginalPolicy] AS [OriginalPolicy], [T2_1].[OriginalPolicy_2] AS [OriginalPolicy_2], [T2_1].[FACE] AS [FACE], [T2_1].[ReinsuredFace] AS [ReinsuredFace], [T2_1].[NAR] AS [NAR], [T2_1].[sourceTableNameInput] AS [sourceTableNameInput], [T2_1].[sourceTableNameInputTS] AS [sourceTableNameInputTS], [T2_1].[sourceFileName] AS [sourceFileName], [T2_1].[IssueAgeL1] AS [IssueAgeL1], [T2_1].[SmokerL1] AS [SmokerL1], [T2_1].[BusinessBlockShort] AS [BusinessBlockShort], [T2_1].[mosesBand] AS [mosesBand], [T2_1].[mosesSeries] AS [mosesSeries], [T2_1].[mosesClassL1] AS [mosesClassL1], [T2_1].[GenderL1] AS [GenderL1], [T2_1].[mosesPlan] AS [mosesPlan], [T2_1].[IssueDate] AS [IssueDate], [T2_1].[FalloutType1] AS [FalloutType1], [T2_1].[Treaty_Model_ID] AS [Treaty_Model_ID], [T2_1].[BusinessBlock] AS [BusinessBlock], [T2_1].[JOIN_KEY_MODEL] AS [JOIN_KEY_MODEL], [T2_1].[JOIN_KEY_NO_DATE] AS [JOIN_KEY_NO_DATE], [T2_1].[BenefitType] AS [BenefitType] FROM [sql-eastus2-int-dev-reboot-analytics_w	QID827319	Running	199	xlargerc	normal
/*
SELECT * FROM sys.dm_pdw_sql_requests WHERE request_id = 'QID891260' AND status <>'Complete' -- and step_index = 3;
DBCC PDW_SHOWEXECUTIONPLAN(57, 192);
SELECT 'DBCC PDW_SHOWEXECUTIONPLAN(',distribution_id,',',spid,')' FROM sys.dm_pdw_sql_requests WHERE request_id = 'QID891260' AND step_index = 3;

dbcc pdw_showspaceused(ctasSuperTableSum)
dbcc pdw_showspaceused(mapTreatyTermsReplicate)
*/
GO
