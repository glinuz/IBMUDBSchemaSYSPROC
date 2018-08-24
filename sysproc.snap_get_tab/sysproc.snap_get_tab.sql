 /*
  * GET SNAPSHOT FOR TABLES -- ON database-alias
  * 
  */
SELECT 
 
           CURRENT_SERVER AS "Database"
           
 	    ,  SUBSTR(tblTab.TABSCHEMA,1,8) AS TABSCHEMA
 		  
 		, SUBSTR(tblTab.TABNAME,1,15) AS TABNAME
 		
 		, tblTab.TAB_TYPE
   		
   		, tblSTT.TBSPACE
   		
   		, tblSTT.INDEX_TBSPACE
   		
   	--	, tblSTT.LONG_TBSPACE
   		
   		, tblSTT.STATS_TIME AS "StatsTS"
 		
 	--	, tblTab.TAB_FILE_ID 
    		
	--	, tblTSD.TBSPACEID AS "TableSpaceDataID"
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
		
		, tblSTT.fpages AS totalNumberofPages
  	
		, tblTSD.PAGESIZE AS TSPageSizeInBytes
		
		, ( tblSTT.fpages * tblTSD.PAGESIZE)
		      / (1024 * 1024)
		      AS totalSizeInMBBasedOnPages
		
FROM TABLE
      (
              
         sysproc.SNAP_GET_TAB
         (
         	  ''
             ,-2
         )
                 
     ) AS tblTab 


INNER JOIN SYSCAT.TABLES tblSTT

	ON  tblTAB.TABSCHEMA = tblSTT.TABSCHEMA
	AND tblTAB.TABNAME = tblSTT.TABNAME

	
-- INNER JOIN  SYSIBMADM.ADMINTABINFO tblATI
	
INNER JOIN TABLE
	(
		sysproc.admin_get_tab_info
		(
	    	  tblSTT.TABSCHEMA
			, tblSTT.TABNAME
		)
		
	) tblATI	
   
	ON  tblSTT.TABSCHEMA = tblATI.TABSCHEMA
	AND tblSTT.TABNAME = tblATI.TABNAME
   		

INNER JOIN SYSCAT.TABLESPACES tblTSD
   
	ON tblSTT.TBSPACE = tblTSD.TBSPACE
   	

WHERE  tblTab.TAB_TYPE NOT IN
         (
         	'CATALOG_TABLE'
		 )
     
ORDER BY

      tblTab.TABSCHEMA
	  
	, tblTab.TABNAME
         