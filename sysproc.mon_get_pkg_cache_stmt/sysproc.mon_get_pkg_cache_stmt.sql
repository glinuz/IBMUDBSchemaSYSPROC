WITH cteESR
 (
    hostname
 )
 AS
 (
    SELECT 
            MAX
            (
                DECODE
                (
                      NAME
                    , 'HOST_NAME'
                    , VALUE
                )
            ) AS "hostname"

    
    FROM   SYSIBMADM.ENV_SYS_RESOURCES tblESR
    
    WHERE  tblESR.NAME IN
            (
               'HOST_NAME'
            )
            
 
 )
SELECT 

           cteESR.HOSTNAME AS "host"
          
        , tblEII.INST_NAME AS "instance"      

        , tblCS.STMT_TEXT AS "SQL"
      
        --, tblCS.STMTID AS "stmtID"
        --, tblCS.PLANID AS "planID"
        --, tblCS.EXECUTABLE_ID AS "executableID"
                        
        , tblCS.TOTAL_CPU_TIME AS "totalCPUTime"
        
        , tblCS.NUM_EXECUTIONS AS "# of Exec"
        
        , tblCS.STMT_EXEC_TIME AS "stmtExecTime"        
        
        , tblCS.QUERY_COST_ESTIMATE AS "queryCostEstimate"
        
        , tblCS.STMT_TYPE_ID AS "stmtType"
        
        , (
              tblCS.ROWS_DELETED
            + tblCS.ROWS_INSERTED
            + tblCS.ROWS_UPDATED
            
          )  AS "Rows Affected"
          
        -- , tblCS.POOL_DATA_P_READS AS "poolReadsPhysical"
        
        --, tblCS.POOL_DATA_L_READS AS "poolReadsLogical"
        
    --  , tblCS.*
        
FROM TABLE
        (
            SYSPROC.MON_GET_PKG_CACHE_STMT 
            ( 
            
                  'D' -- section type S/D
                  
                , NULL -- executable_id
                
                -- , NULL -- search_args
                --, '<modified_within>360</modified_within>'
                , NULL
                
                /* Specify -1 for the current database member, or -2 for all active database members */
                , -2
            )
        ) as tblCS 


CROSS JOIN cteESR

CROSS JOIN sysibmadm.env_inst_info tblEII

WHERE (

                ( tblCS.STMT_TEXT NOT LIKE '%SYSPROC%')
                
            AND ( tblCS.STMT_TEXT NOT LIKE '%SYSIBMADM%')
            
            
      )

ORDER BY 

          TOTAL_CPU_TIME DESC
          
        , ( tblCS.NUM_EXECUTIONS * tblCS.QUERY_COST_ESTIMATE ) DESC

        
-- FETCH FIRST 10 ROWS ONLY     