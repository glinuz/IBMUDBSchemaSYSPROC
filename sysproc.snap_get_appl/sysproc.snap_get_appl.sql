SELECT  
          
           tblApp.AUTHID AS "authID"
         
         , tblSAI.APPL_NAME AS "appName"
         
         , tblSAI.APPL_STATUS AS "appStatus"
         
         , tblApp.APPL_ID AS "applID"        
          
         , tblApp.ROWS_WRITTEN AS "RowsWritten"

         , tblApp.ROWS_READ AS "RowsRead"
         
         , tblApp.ROWS_DELETED AS "RowsDeleted"
         
         , tblApp.ROWS_INSERTED AS "RowsInserted"        

         , tblApp.ROWS_UPDATED AS "RowsUpdated"
         
         , tblApp.ROWS_SELECTED AS "RowsSelected"        
         
         , tblApp.SELECT_SQL_STMTS AS "SQLSelectStmts"

         , tblApp.FAILED_SQL_STMTS AS "failedSQLStmts"

         , tblApp.COMMIT_SQL_STMTS AS "CommitSQLStmts"
         
         , tblApp.ROLLBACK_SQL_STMTS AS "RollbackSQLStmts"      
         
         , tblApp.DDL_SQL_STMTS AS "DDLSQLStmts"        
         
         , cast
            (
            
                  ( tblApp.AGENT_USR_CPU_TIME_MS / 1E6 )
                  
                 AS decimal(10, 2)
                
            ) AS "AgentUserCPUTimeInSec"
         
         , CAST
         	(
         		tblApp.ELAPSED_EXEC_TIME_S
         		
                 	AS decimal(10, 2)
                 	
			)         		
             AS "ElapsedExecTimeInSec"
         
         -- , tblApp.*
 
           
FROM TABLE
      (
              
         SYSPROC.SNAP_GET_APPL
         (
         
             -- '' current database, NULL all databases 
              NULL
         
            -- all database partitions
             ,-1
             
         )
                
     ) AS tblApp 

/*
      
    CROSS JOIN SYSIBMADM.ENV_INST_INFO tblII
    
*/
INNER JOIN SYSIBMADM.SNAPAPPL_INFO tblSAI
    ON tblApp.AGENT_ID = tblSAI.AGENT_ID
    
    
INNER JOIN SYSIBMADM.APPLICATIONS tblApp    
    ON tblSAI.APPL_ID = tblApp.APPL_ID
        


ORDER BY
           (
                  tblApp.ROWS_READ 
         
                + tblApp.ROWS_WRITTEN
                
           )  DESC

         , tblAPP.ROWS_INSERTED DESC
         