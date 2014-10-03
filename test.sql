SELECT 
--  RQSC_RQBK_ID,
--  RQSC_SH_ID,
--  RQSC_SH_NAME,
--  RQSC_SH_ADDR1,
--  RQSC_SH_ADDR2,
--  RQSC_SH_ADDR3,
--  RQSC_SH_CITY,
--  RQSC_SH_STATE,
--  RQSC_SH_ZIP,
--  RQSC_SH_COUNTRY,
--  RQSC_AIR_WHSE,
--  RQSC_POR_TYPE,
--  RQSC_POR,
--  RQSC_POD_TYPE,
--  RQSC_POD,
--  RQSC_DEST_COUNTRY,
--  RQSC_CS_ID,
--  RQSC_CS_NAME,
--  RQSC_CS_ADDR1,
--  RQSC_CS_ADDR2,
--  RQSC_CS_ADDR3,
--  RQSC_CS_CITY,
--  RQSC_CS_STATE,
--  RQSC_CS_ZIP,
--  RQSC_CS_COUNTRY,
--  RQSC_NOTIFY_ID,
--  RQSC_NOTIFY_NAME,
--  RQSC_NOTIFY_ADDR1,
--  RQSC_NOTIFY_ADDR2,
--  RQSC_NOTIFY_ADDR3,
--  RQSC_NOTIFY_CITY,
--  RQSC_NOTIFY_STATE,
--  RQSC_NOTIFY_ZIP,
--  RQSC_NOTIFY_COUNTRY,
--  RQSC_CR_WAYBILL_NUM,
--  RQSC_SH_LOAD_ADDR,
--  RQSC_POR_NAME,
--  RQSC_POD_NAME,
  RQSC_POR_AIR,
  RQSC_POD_AIR
FROM RQBK_SH_CS
WHERE RQSC_POD_AIR != NULL;