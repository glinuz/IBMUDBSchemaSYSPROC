/*
 * 1a) MON_GET_CONNECTION table function - Get connection metrics
 *     https://www.ibm.com/support/knowledgecenter/en/SSEPGG_10.5.0/com.ibm.db2.luw.sql.rtn.doc/doc/r0053938.html
 * 
 * 
 */

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
      
        , tblMGC.SESSION_AUTH_ID AS "authIDSession"

        , tblMGC.SYSTEM_AUTH_ID AS "authIDSystem"
        
        , tblMGC.execution_ID AS "executionID"
        
        , tblMGC.IS_SYSTEM_APPL AS "isSystemAppl"
        
        , tblMGC.CLIENT_APPLNAME AS "appClient"

        , tblMGC.APPLICATION_NAME AS "appName"
        
        , tblMGC.CLIENT_WRKSTNNAME AS "workstation"
        
        , tblMGC.POOL_DATA_L_READS  AS "poolDataReadsLogical"

        , tblMGC.POOL_INDEX_L_READS AS "poolIndexReadsLogical"

      --  , tblMGC.POOL_TEMP_DATA_L_READS  AS "poolTempDataReadsLogical"
        
      --  , tblMGC.POOL_TEMP_INDEX_L_READS AS "poolTempIndexReadLogical"
       
        , tblMGC.POOL_DATA_P_READS AS "poolDataReadsPhysical"
        
        , tblMGC.POOL_INDEX_P_READS AS "poolIndexReadsPhysical"
        
        , tblMGC.TOTAL_CPU_TIME AS "cpuTime"
        
       -- , TOTAL_APP_COMMITS AS "appCommits"
        
        , tblMGC.TCPIP_RECV_VOLUME AS "tcpReceive"
        
        , tblMGC.TCPIP_SEND_VOLUME AS "tcpSend"
        
        , tblMGC.rows_returned
        
            AS "rowsReturned"

        , tblMGC.rows_read
        
            AS "rowsRead"

        , tblMGC.rows_modified
        
            AS "rowsModified"
            
        , (
              tblMGC.rows_deleted
            + tblMGC.rows_inserted
            + tblMGC.rows_updated
          )
          
            AS "rowsAffected"
            
        , tblMGC.*
        
FROM TABLE
        (
            SYSPROC.MON_GET_CONNECTION
            ( 
            
                  -- application_handle
                  NULL 
                
                
                /* Specify -1 for the current database member, or -2 for all active database members */
                , -2
                
                -- user_appls = 0
                -- system and user appls = 1
                , 1
            )
            
        ) as tblMGC 


CROSS JOIN cteESR

CROSS JOIN sysibmadm.env_inst_info tblEII

ORDER BY 

        (
              tblMGC.POOL_INDEX_L_READS 
            + tblMGC.POOL_INDEX_L_READS
            + tblMGC.POOL_TEMP_DATA_L_READS
            + tblMGC.POOL_TEMP_INDEX_L_READS

            + tblMGC.POOL_DATA_P_READS
            + tblMGC.POOL_INDEX_P_READS
            
        ) desc

        , (
            tblMGC.rows_returned
          ) DESC

/*
    FETCH FIRST 10 ROWS ONLY     
*/
