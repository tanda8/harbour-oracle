create or replace PROCEDURE SP_PORTAL_DETAIL_AIR_DETAIL
(
	I_HARBOUR_NUMBER IN VARCHAR2,
	O_CURSOR OUT SYS_REFCURSOR
)
AS
BEGIN
	OPEN O_CURSOR FOR
	SELECT
		RQAD_CONT_ID CONTAINER_ID,
		PACK_CODE PACKAGE_CODE,
		RQAD_NUM_PIECES PIECE_COUNT,
		RQAD_LENGTH PIECE_LENGTH,
		RQAD_WIDTH PIECE_WIDTH,
		RQAD_HEIGHT PIECE_HEIGHT,
		RQAD_LBS PIECE_WEIGHT
	FROM
		RQBK_IDX,
		RQBK_AIR_HDR,
		RQBK_AIR_DET,
		PACKAGE_CODES
	WHERE RQI_RQBK_NUM = I_HARBOUR_NUMBER
		AND RQI_RQBK_ID = RQAH_RQBK_ID
		AND RQAH_CONT_ID = RQAD_CONT_ID
		AND RQAD_PACK_CODE = PACK_ID
	ORDER BY PACKAGE_CODE DESC;
	EXCEPTION WHEN OTHERS THEN
		RAISE;
END;