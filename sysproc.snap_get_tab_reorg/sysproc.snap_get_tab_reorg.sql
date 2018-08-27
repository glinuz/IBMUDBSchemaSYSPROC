/*
 * 1a) SNAPTAB_REORG administrative view and SNAP_GET_TAB_REORG table function - Retrieve table reorganization snapshot information
       https://www.ibm.com/support/knowledgecenter/no/SSEPGG_9.7.0/com.ibm.db2.luw.sql.rtn.doc/doc/r0021997.html
 
*/

/*

 db2 get snapshot for tables on [database];

 db2 get snapshot for tables on csstbl;
 
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

, cteTableReorg
as
(

    SELECT 
             tblDH.*
                
    FROM TABLE
        (
        
            sysproc.snap_get_tab_reorg         
            ( 
            
                    ''
                  , -2
                
            )
            
        ) as tblDH
        
)

SELECT 

          cteTR.TABSCHEMA       AS "schema"
        , cteTR.TABNAME         AS "table"
        , cteTR.PAGE_REORGS     AS "pageReOrgs"
        , cteTR.REORG_TYPE      AS "type"
        , cteTR.REORG_STATUS    AS "status"
        , cteTR.REORG_START     AS "tsStart"
        , cteTR.REORG_END       AS "tsEnd"
        , cteTR.REORG_INDEX_ID  AS "ind_id"
        , cteTR.REORG_TBSPC_ID  AS "tsID"

        -- cteTR.*
        
FROM cteTableReorg cteTR

CROSS JOIN cteESR

CROSS JOIN sysibmadm.env_inst_info tblEII
        
ORDER BY
          cteTR.REORG_END   DESC
        , cteTR.REORG_START DESC
        
FETCH FIRST 100 ROWS ONLY