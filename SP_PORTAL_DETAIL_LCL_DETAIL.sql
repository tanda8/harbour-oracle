create or replace PROCEDURE SP_PORTAL_DETAIL_LCL_DETAIL
(
	I_HARBOUR_NUMBER IN VARCHAR2,
	O_CURSOR OUT SYS_REFCURSOR
)
AS
BEGIN
	OPEN O_CURSOR FOR
	SELECT
		RQLD_CONT_ID CONTAINER_ID,
		PACK_CODE PACKAGE_CODE,
		RQLD_NUM_PIECES PIECE_COUNT,
		RQLD_LENGTH PIECE_LENGTH,
		RQLD_WIDTH PIECE_WIDTH,
		RQLD_HEIGHT PIECE_HEIGHT,
		RQLD_LBS PIECE_WEIGHT,
		ROUND((RQLD_NUM_PIECES * RQLD_LENGTH * RQLD_WIDTH * RQLD_HEIGHT / 1728), 2)  AS PIECE_VOLUME
	FROM
		RQBK_IDX,
		RQBK_LCL_HDR,
		RQBK_LCL_DET,
		PACKAGE_CODES
	WHERE RQI_RQBK_NUM = I_HARBOUR_NUMBER
		AND RQI_RQBK_ID = RQLH_RQBK_ID
		AND RQLH_CONT_ID = RQLD_CONT_ID
		AND RQLD_PACK_CODE = PACK_ID
	ORDER BY PACKAGE_CODE DESC;
	EXCEPTION WHEN OTHERS THEN
		RAISE;
END;