/*
 * 1a) The MON_GET_BUFFERPOOL table function returns monitor metrics for one or more buffer pools.
 *     https://www.ibm.com/support/knowledgecenter/hu/SSEPGG_9.7.0/com.ibm.db2.luw.sql.rtn.doc/doc/r0053942.html
*/

/*

db2 get snapshot for all bufferpools

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

, cteBufferPool
as
(

    SELECT 
    
            --  tblBP.MEMBER
            
              tblBP.BP_Name AS bufferPool
            
            , 
               pool_data_l_reads + pool_temp_data_l_reads +
               pool_index_l_reads + pool_temp_index_l_reads +
               pool_xda_l_reads + pool_temp_xda_l_reads 
                as logicalReads
                
            ,
               pool_data_p_reads + pool_temp_data_p_reads 
             + pool_index_p_reads + pool_temp_index_p_reads 
             + pool_xda_p_reads + pool_temp_xda_p_reads 
                as physicalReads
           

    FROM TABLE
        (
            sysproc.mon_get_bufferpool            
            ( 
            
                /* Buffer Pool */
                --null
                ''
                
                /* Specify -1 for the current database member, or -2 for all active database members */
                , -2
                
            )
            
        ) as tblBP

)

SELECT 

          cteESR.HOSTNAME AS "host"
          
        , tblEII.INST_NAME AS "instance"      
            
        , cteBP.*
        
        , ( cteBP.LogicalReads * 100.00 )
            / NULLIF
                (
                    ( cteBP.LogicalReads + cteBP.PhysicalReads)
                    , 0
                )   
            AS "Hit Ratio"
                
FROM cteBufferPool cteBP

CROSS JOIN cteESR

CROSS JOIN sysibmadm.env_inst_info tblEII

