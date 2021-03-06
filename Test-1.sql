SELECT DISTINCT
  CY_ID,
  CY_CODE,
  CY_DESC
FROM
  RQBK_IDX,
  RQBK_SH_CS,
  CITY,
  AIRPORTS,
  COUNTRY
WHERE RQBK_IDX.RQI_COMPLETE = -1
  AND RQBK_IDX.RQI_ACTIVE = -1
  AND RQBK_IDX.RQI_RQBK = 2
  AND RQBK_IDX.RQI_RQBK_ID = RQBK_SH_CS.RQSC_RQBK_ID
  
  --AND DECODE(i_COMPANY_TYPE, 1, RQBK_SH_CS.RQSC_SH_ID, 2, RQBK_SH_CS.RQSC_CS_ID) = v_COMPANY_ID  -- Original
  AND DECODE(1, 1, RQBK_SH_CS.RQSC_SH_ID, 2, RQBK_SH_CS.RQSC_CS_ID) = 809  -- Shipper: moen 
  --AND DECODE(2, 1, RQBK_SH_CS.RQSC_SH_ID, 2, RQBK_SH_CS.RQSC_CS_ID) = 2396  -- Consignee: bpkorea
  --AND DECODE(2, 1, RQBK_SH_CS.RQSC_SH_ID, 2, RQBK_SH_CS.RQSC_CS_ID) = 1129  -- Consignee: scjargentina
  
  --AND (RQBK_SH_CS.RQSC_POD = CITY.CT_ID OR RQBK_SH_CS.RQSC_POD_AIR = AIRPORTS.AP_ID)  -- Original
  --AND RQBK_SH_CS.RQSC_POD = CITY.CT_ID
  AND (RQBK_SH_CS.RQSC_POD_AIR != NULL AND RQBK_SH_CS.RQSC_POD_AIR = AIRPORTS.AP_ID)
  
  AND CITY.CT_COUNTRY_ID = COUNTRY.CY_ID
  AND COUNTRY.CY_CODE IS NOT NULL
ORDER BY COUNTRY.CY_CODE ASC;
