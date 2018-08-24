/*
 * 
 * 1a)
 * 		The ADMIN_GET_MEM_USAGE table function gets the total memory consumption for a given instance.
* 		https://www.ibm.com/support/knowledgecenter/SSEPGG_10.5.0/com.ibm.db2.luw.sql.rtn.doc/doc/r0059004.html
* 
* 1b ) ADMIN_GET_DBP_MEM_USAGE table function - Get total memory consumption for instance
* 		https://www.ibm.com/support/knowledgecenter/en/SSEPGG_10.5.0/com.ibm.db2.luw.sql.rtn.doc/doc/r0052895.html
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
             
		   , tblEII.INST_NAME AS "instance"          
             
		   , tblMem.MAX_MEMBER_MEM / ( 1024 * 1024) AS memMaxGB
 
		   , tblMem.CURRENT_MEMBER_MEM / ( 1024 * 1024) AS memCurrentGB
		   
		   , tblMem.PEAK_MEMBER_MEM / ( 1024 * 1024) AS memPeakGB		   
		   
FROM TABLE
      (
              
         --SYSPROC.ADMIN_GET_DBP_MEM_USAGE
         SYSPROC.ADMIN_GET_MEM_USAGE 
         (
         
         
         	-- all database partitions
             -1
             
         )
                
     ) AS tblMem 


CROSS JOIN  cteESR

CROSS JOIN sysibmadm.env_inst_info tblEII 