create or replace PROCEDURE SP_PORTAL_TRACE_AIR
(
  I_HARBOUR_NUMBER IN VARCHAR2,  
  O_CURSOR OUT SYS_REFCURSOR
)
AS   
BEGIN    
	OPEN O_CURSOR FOR
  SELECT 
    RQI_RQBK_NUM HARBOUR_NUMBER,
		RQAC_AWB_NUM AIRWAYBILL_NUMBER,    
		RQAH_TOT_PIECES TOTAL_PIECES,
    RQAH_ACT_LBS TOTAL_WEIGHT,		
    RQAH_VOL_LBS TOTAL_VOLUME		
	FROM 
    RQBK_IDX,
		RQBK_AIR_CARRIER,
		RQBK_AIR_HDR	 
	WHERE RQI_RQBK_NUM = I_HARBOUR_NUMBER
		AND RQI_RQBK_ID = RQAH_RQBK_ID (+)
		AND RQI_RQBK_ID = RQAC_RQBK_ID (+);
	EXCEPTION WHEN OTHERS THEN    
		RAISE;
END;