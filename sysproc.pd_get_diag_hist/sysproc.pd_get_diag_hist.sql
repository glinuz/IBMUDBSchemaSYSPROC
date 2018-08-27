/*
 * 1a) PD_GET_DIAG_HIST table function - Return records from a given facility
 https://www.ibm.com/support/knowledgecenter/en/SSEPGG_9.5.0/com.ibm.db2.luw.sql.rtn.doc/doc/r0052903.html
 
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

, cteDiagHist
as
(

    SELECT 
             tblDH.*
                
    FROM TABLE
        (
        
            sysproc.pd_get_diag_hist           
            ( 
            
                  'ALL'
                , 'ALL'
                , 'POTENTIAL'
                , CAST (NULL AS TIMESTAMP)
                , CAST (NULL AS TIMESTAMP)
                
            )
            
        ) as tblDH
        
)

SELECT 
          cteDH.LEVEL
          
        , case cteDH.LEVEL
            WHEN 'C' THEN 'Critical'
            WHEN 'E' THEN 'Error'
            WHEN 'I' THEN 'Informational'
            WHEN 'S' THEN 'Severe'
            WHEN 'W' THEN 'Warning'
          END AS "levelLiteral"
          
        , cteDH.IMPACT
  
        , varchar_format
            (
                (
                         cteDH.TIMESTAMP 
                    +    (  cteDH.TIMEZONE / 60) HOURS
                    + MOD(  cteDH.TIMEZONE, 60) MINUTES
                )
                , 'YYYY-MM-DD HH24:MI AM'
                
            )
                AS "TS"

       -- , CURRENT TIMEZONE AS "currentTimeZone"        
        , cteDH.MSG
        , cteDH.DUMPFILE
    --  , cteDH.*


FROM cteDiagHist cteDH

CROSS JOIN cteESR

CROSS JOIN sysibmadm.env_inst_info tblEII

ORDER BY
        cteDH.TIMESTAMP DESC
        
FETCH FIRST 100 ROWS ONLY