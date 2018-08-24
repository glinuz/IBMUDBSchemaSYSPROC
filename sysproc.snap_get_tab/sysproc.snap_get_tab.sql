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
 
          cteESR.hostname AS "host"
          
        , tblEII.INST_NAME AS "instance"          
           
        , SUBSTR(tblTab.TABSCHEMA,1,8) AS "schema"
          
        , SUBSTR(tblTab.TABNAME,1,15) AS "table"
        
        , tblTab.TAB_TYPE AS "tabType"
        
        , tblSTT.TBSPACE as "tabSpace"
        
        , tblSTT.INDEX_TBSPACE as "indexTabSpace"
        
    --  , tblSTT.LONG_TBSPACE
        
        , VARCHAR_FORMAT
        	(
        		  tblSTT.STATS_TIME
        		, 'YYYY-MM-DD HH24:MI:SS' 
    		) AS "StatsTS"
        
        , tblTSD.PAGESIZE AS "pageSizeInBytes"
        
        -- , tblSTT.npages AS "#ofPagesN"
        -- , tblSTT.mpages AS "#ofPagesM"       
        , tblSTT.fpages AS "#ofPagesF"      
        
        , (
                  tblATI.DATA_OBJECT_P_SIZE
                + tblATI.INDEX_OBJECT_P_SIZE 
                + tblATI.LONG_OBJECT_P_SIZE 
                + tblATI.LOB_OBJECT_P_SIZE 
                + tblATI.XML_OBJECT_P_SIZE
          ) 
          / 
          (1024) 
            AS totalSizeInMBBasedOnAdminGetTabInfo
        

    
        , ( tblSTT.fpages * tblTSD.PAGESIZE)
              / (1024 * 1024)
              AS "sizeInMBBasedOnPages"
        

FROM TABLE
      (
         /*
          * Data Returned in KB 
          */     
         sysproc.SNAP_GET_TAB
         (
         
             -- current database 
              ''
         
            -- all database partitions
             ,-2
             
         )
                 
     ) AS tblTab 


INNER JOIN SYSCAT.TABLES tblSTT

    ON  tblTAB.TABSCHEMA = tblSTT.TABSCHEMA
    AND tblTAB.TABNAME = tblSTT.TABNAME


INNER JOIN SYSCAT.TABLESPACES tblTSD
   
    ON tblSTT.TBSPACE = tblTSD.TBSPACE
    
-- INNER JOIN  SYSIBMADM.ADMINTABINFO tblATI
    
INNER JOIN TABLE
    (
    
        sysproc.admin_get_tab_info
        (
              -- schema
              tblSTT.TABSCHEMA
              
              -- table
            , tblSTT.TABNAME
            
        )
        
    ) tblATI    
   
    ON  tblSTT.TABSCHEMA = tblATI.TABSCHEMA
    AND tblSTT.TABNAME = tblATI.TABNAME
        
CROSS JOIN cteESR

CROSS JOIN sysibmadm.env_inst_info tblEII


/*
    Skip catalog tables
*/  
WHERE  tblTab.TAB_TYPE NOT IN
         (
            'CATALOG_TABLE'
         )
    
         
ORDER BY

      tblTab.TABSCHEMA
      
    , tblTab.TABNAME
         