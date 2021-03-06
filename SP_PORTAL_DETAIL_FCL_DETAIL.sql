create or replace PROCEDURE SP_PORTAL_DETAIL_FCL_DETAIL
(
	I_HARBOUR_NUMBER IN VARCHAR2,
	O_CURSOR OUT SYS_REFCURSOR
)
AS
BEGIN
	OPEN O_CURSOR FOR
	SELECT
		RQFH_CONT_ID CONTAINER_ID,
		CONT_CODE CONTAINER_CODE,
		RQFH_LBS WEIGHT,
		RQFH_LOAD_DATE LOAD_DATE,
		RQFH_PICKUP_NUM PICKUP_NUMBER,
		RQFH_CONT_NUM CONTAINER_NUMBER,
		RQFH_SEAL_NUM SEAL_NUMBER
	FROM
		RQBK_IDX,
		RQBK_FCL_HDR,
		CONTAINERS
	WHERE RQI_RQBK_NUM = I_HARBOUR_NUMBER
		AND RQI_RQBK_ID = RQFH_RQBK_ID
		AND RQFH_CONT_CODE = CONT_ID
	ORDER BY CONTAINER_NUMBER DESC;
	EXCEPTION WHEN OTHERS THEN
		RAISE;
END;