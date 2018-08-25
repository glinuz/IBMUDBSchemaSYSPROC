/*
 * 1a) MON_GET_DATABASE table function - Get database metrics
 *     https://www.ibm.com/support/knowledgecenter/en/SSEPGG_10.5.0/com.ibm.db2.luw.sql.rtn.doc/doc/r0060769.html
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
         
        , tblMD.DB_STATUS
        
        , tblMD.DB_ACTIVATION_STATE
        
        , tblMD.LAST_BACKUP
        
        , tblMD.CONNECTIONS_TOP
        
        , tblMD.TOTAL_CONS
        
        , tblMD.APPLS_CUR_CONS
        
        , tblMD.APPLS_IN_DB2

        , tblMD.POOL_DATA_L_READS
        
        , tblMD.POOL_INDEX_L_READS
        
        , tblMD.POOL_DATA_P_READS
        
        , tblMD.POOL_INDEX_P_READS
    
 		, tblMD.TCPIP_RECV_VOLUME
 		
 		, tblMD.TCPIP_SEND_VOLUME
 		
        -- , tblMD.*
        
FROM TABLE
        (
            SYSPROC.MON_GET_DATABASE            
            ( 
                
                
                /* Specify -1 for the current database member, or -2 for all active database members */
                -2
                
            )
            
        ) as tblMD 


CROSS JOIN cteESR

CROSS JOIN sysibmadm.env_inst_info tblEII


/*
    FETCH FIRST 10 ROWS ONLY     
*/
