/*
 * 1)   IBM Knowledge Center
 * 		HomeDb2 on Cloud, Db2 Warehouse, Db2 Warehouse on Cloud, Integrated Analytics System
 * 		Object\Usage
 * 		Identifying the statements that affect a table
 * 		https://www.ibm.com/support/knowledgecenter/SS6NHC/com.ibm.swg.im.dashdb.admin.mon.doc/doc/t0058654.html
 * 
 * 
 */
SELECT 
		MEMBER,
        EXECUTABLE_ID,
        NUM_REFERENCES,
        NUM_REF_WITH_METRICS,
        ROWS_READ,
        ROWS_INSERTED,
        ROWS_UPDATED,
        ROWS_DELETED

FROM TABLE
	(
		SYSPROC.MON_GET_TABLE_USAGE_LIST
		(
			  NULL -- 'SALES'
			, NULL -- 'INVENTORYUL'
			, -2
		)
		
	) tblTUL
	

ORDER BY 
		tblTUL.ROWS_READ DESC

FETCH FIRST 10 ROWS ONLY