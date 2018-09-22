SELECT

		  tblSI.TABSCHEMA
		  
		, tblSI.TABNAME
		
		, tblSI.INDNAME
		
		, tblSI.AVGLEAFKEYSIZE AS "leafLen"
		
		, tblSI.AVGNLEAFKEYSIZE AS "NleafLen"
		
		, tbl.IID AS "indexID"
		
		, tbl.INDEX_OBJECT_L_SIZE
		  
		, tbl.INDEX_OBJECT_P_SIZE
		
		, tbl.INDEX_COMPRESSED AS "compressed"
		
		, tbl.INDEX_REQUIRES_REBUILD AS "rebuild Req"
		
		--, tbl.LARGE_RIDS AS "largeRIDS"
           
		--, tbl.*
		
		--	, tblI.INDEX_COMPRESSED
	
		
FROM SYSCAT.TABLES tblT

INNER JOIN SYSCAT.INDEXES tblSI

	ON  tblT.TABSCHEMA = tblSI.TABSCHEMA
	
	AND tblT.TABNAME = tblSI.TABNAME


INNER JOIN TABLE
      (
              
         sysproc.admin_get_index_info
         (
         
         	  'I'
			, null
            , null
             
         )
                
     ) AS tbl 

	ON  tblSI.TABSCHEMA = tbl.TABSCHEMA
	
	AND tblSI.TABNAME = tbl.TABNAME
	
	AND tblSI.INDNAME = tbl.INDNAME
	
	
WHERE tblT.OWNERTYPE = 'U'
 
AND   tblT.TABNAME NOT LIKE 'ADVISE%'

AND   tblT.TABNAME NOT LIKE 'EXPLAIN%'


AND   tblSI.TABSCHEMA NOT IN
		(
			  'SYSIBM'
			, 'SYSTOOLS'
		)
		

ORDER BY

		  tblSI.TABSCHEMA
		  
		, tblSI.TABNAME
		
		, tblSI.INDNAME
		
					

//