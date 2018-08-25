/*
 * 1a) MON_GET_EXTENDED_LATCH_WAIT table function - Return information for latches
 *     https://www.ibm.com/support/knowledgecenter/es/SSEPGG_10.1.0/com.ibm.db2.luw.sql.rtn.doc/doc/r0059271.html
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

, cteExtendedLatchWait
as
(

    SELECT 
             tblELW.*
                
    FROM TABLE
        (
        
            sysproc.mon_get_extended_latch_wait           
            ( 
            
                /* Specify -1 for the current database member, or -2 for all active database members */
                -2
                
            )
            
        ) as tblELW
        
)

SELECT 

/*
          cteESR.HOSTNAME AS "host"
          
        , tblEII.INST_NAME AS "instance"      
  
*/              
          cteELW.LATCH_NAME AS "latch"

        , cteELW.TOTAL_EXTENDED_LATCH_WAIT_TIME AS "latchWaitTime"
        
        , cteELW.TOTAL_EXTENDED_LATCH_WAITS AS "latchWaits" 


FROM cteExtendedLatchWait cteELW

CROSS JOIN cteESR

CROSS JOIN sysibmadm.env_inst_info tblEII

ORDER BY

        cteELW.TOTAL_EXTENDED_LATCH_WAIT_TIME DESC