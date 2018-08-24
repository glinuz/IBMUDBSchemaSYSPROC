/*
 * MON_GET_TABLESPACE table function - Get table space metrics
 * https://www.ibm.com/support/knowledgecenter/en/SSEPGG_9.8.0/com.ibm.db2.luw.sql.rtn.doc/doc/r0053943.html
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
          cteESR.hostname AS "host"
          
		, tblEII.INST_NAME AS "INSTANCE"
		
        , tblTS.TBSP_NAME AS "name"
        
        , tblTS.TBSP_ID AS "id"
        
        , tblTS.TBSP_TYPE AS "type"
        
        , tblTS.TBSP_CONTENT_TYPE AS "contentType"
        
        , tblTS.TBSP_PAGE_SIZE AS "pageSize"
        
        , ( tblTS.TBSP_USED_PAGES * tblTS.TBSP_PAGE_SIZE )  / ( 1024  * 1024) 
        	AS "usedMB"
        
        , ( tblTS.TBSP_FREE_PAGES * tblTS.TBSP_PAGE_SIZE )  / ( 1024  * 1024) 
        	AS "freeMB"
        
        , ( tblTS.TBSP_TOTAL_PAGES * tblTS.TBSP_PAGE_SIZE )  / ( 1024 * 1024) 
        	AS "totalMB"
        
        , cast
        	(
        	
        		(
        			  ( tblTS.TBSP_USED_PAGES * 100.00 )
        			/ NULLIF
        				(
        					tblTS.TBSP_TOTAL_PAGES
        					, 0
        				)	
				)
				AS decimal(10, 2)
				
        	) AS "used%"
		

FROM TABLE
      (
              
         SYSPROC.MON_GET_TABLESPACE
         (
         
             -- current database 
         	 ''
         
         	-- all database partitions
             ,-1
             
         )
                
     ) AS tblTS 

CROSS JOIN cteESR

CROSS JOIN sysibmadm.env_inst_info tblEII 

ORDER BY

     ( tblTS.TBSP_TOTAL_PAGES * tblTS.TBSP_PAGE_SIZE ) desc