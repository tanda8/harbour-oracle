create or replace PROCEDURE SP_PORTAL_SEARCH_TERMS
(
	i_COMPANY_ID IN VARCHAR2,
	i_COMPANY_TYPE IN VARCHAR2,
	i_SEARCH_TYPE IN VARCHAR2,
	o_CURSOR OUT SYS_REFCURSOR
)
AS

	v_COMPANY_ID CONSTANT NUMBER := TO_NUMBER(i_COMPANY_ID);   -- Cast required due to .NET EF bug

BEGIN

  IF (i_COMPANY_TYPE != 1 AND i_COMPANY_TYPE != 2) THEN  -- Bypass if not Shipper or Consignee
    RETURN;
  END IF;

  IF (i_SEARCH_TYPE = 'HN') THEN  -- Harbour Number (Booking / Rate Quote)
    OPEN o_CURSOR FOR
    SELECT DISTINCT
      RQBK_IDX.RQI_RQBK_NUM SEARCH_TERM
    FROM
      RQBK_IDX,
      RQBK_SH_CS
    WHERE RQBK_IDX.RQI_COMPLETE = -1   -- Completed Transaction
      AND RQBK_IDX.RQI_ACTIVE = -1     -- Active Transaction
      AND RQBK_IDX.RQI_RQBK = 2        -- Booking Type
      AND RQBK_IDX.RQI_RQBK_ID = RQBK_SH_CS.RQSC_RQBK_ID
      AND DECODE(i_COMPANY_TYPE, 1, RQBK_SH_CS.RQSC_SH_ID, 2, RQBK_SH_CS.RQSC_CS_ID) = v_COMPANY_ID   -- Decode: Shipper = 1, Consignee = 2      
    ORDER BY RQBK_IDX.RQI_RQBK_NUM ASC;
  END IF;

  IF (i_SEARCH_TYPE = 'CBN') THEN  -- Carrier Booking Number
    OPEN o_CURSOR FOR
    SELECT DISTINCT
      RQBK_OC_CARRIER.RQOC_BK_NUM SEARCH_TERM
    FROM
      RQBK_IDX,
      RQBK_SH_CS,
      RQBK_OC_CARRIER
    WHERE RQBK_IDX.RQI_COMPLETE = -1
      AND RQBK_IDX.RQI_ACTIVE = -1
      AND RQBK_IDX.RQI_RQBK = 2
      AND RQBK_IDX.RQI_RQBK_ID = RQBK_SH_CS.RQSC_RQBK_ID
      AND DECODE(i_COMPANY_TYPE, 1, RQBK_SH_CS.RQSC_SH_ID, 2, RQBK_SH_CS.RQSC_CS_ID) = v_COMPANY_ID
      AND RQBK_IDX.RQI_RQBK_ID = RQBK_OC_CARRIER.RQOC_RQBK_ID (+)
      AND RQBK_OC_CARRIER.RQOC_BK_NUM IS NOT NULL
    ORDER BY RQBK_OC_CARRIER.RQOC_BK_NUM ASC;
  END IF;

  IF (i_SEARCH_TYPE = 'SR') THEN  -- Shipper Reference Number
    OPEN o_CURSOR FOR 
    SELECT DISTINCT
      RQBK_REF.RQR_REF_NUM SEARCH_TERM
    FROM
      RQBK_IDX,
      RQBK_SH_CS,
      RQBK_REF
    WHERE RQBK_IDX.RQI_COMPLETE = -1
      AND RQBK_IDX.RQI_ACTIVE = -1
      AND RQBK_IDX.RQI_RQBK = 2
      AND RQBK_IDX.RQI_RQBK_ID = RQBK_SH_CS.RQSC_RQBK_ID
      AND DECODE(i_COMPANY_TYPE, 1, RQBK_SH_CS.RQSC_SH_ID, 2, RQBK_SH_CS.RQSC_CS_ID) = v_COMPANY_ID
      AND RQBK_IDX.RQI_RQBK_ID = RQBK_REF.RQR_RQBK_ID (+)
      AND RQBK_REF.RQR_REF_TYPE = 1   -- Shipper Reference
      AND RQBK_REF.RQR_REF_NUM IS NOT NULL
    ORDER BY RQBK_REF.RQR_REF_NUM ASC;
  END IF;

  IF (i_SEARCH_TYPE = 'CR') THEN  -- Consignee Reference Number
    OPEN o_CURSOR FOR 
    SELECT DISTINCT
      RQBK_REF.RQR_REF_NUM SEARCH_TERM
    FROM
      RQBK_IDX,
      RQBK_SH_CS,
      RQBK_REF 
    WHERE RQBK_IDX.RQI_COMPLETE = -1
      AND RQBK_IDX.RQI_ACTIVE = -1
      AND RQBK_IDX.RQI_RQBK = 2
      AND RQBK_IDX.RQI_RQBK_ID = RQBK_SH_CS.RQSC_RQBK_ID
      AND DECODE(i_COMPANY_TYPE, 1, RQBK_SH_CS.RQSC_SH_ID, 2, RQBK_SH_CS.RQSC_CS_ID) = v_COMPANY_ID
      AND RQBK_IDX.RQI_RQBK_ID = RQBK_REF.RQR_RQBK_ID (+)
      AND RQBK_REF.RQR_REF_TYPE = 2   -- Consignee Reference
      AND RQBK_REF.RQR_REF_NUM IS NOT NULL
    ORDER BY RQBK_REF.RQR_REF_NUM ASC;
  END IF;

  IF (i_SEARCH_TYPE = 'AWN') THEN  -- Air Waybill Number
    OPEN o_CURSOR FOR
    SELECT DISTINCT
      RQBK_AIR_CARRIER.RQAC_AWB_NUM SEARCH_TERM
    FROM
      RQBK_IDX,
      RQBK_SH_CS,
      RQBK_AIR_CARRIER 
    WHERE RQBK_IDX.RQI_COMPLETE = -1
      AND RQBK_IDX.RQI_ACTIVE = -1
      AND RQBK_IDX.RQI_RQBK = 2
      AND RQBK_IDX.RQI_RQBK_ID = RQBK_SH_CS.RQSC_RQBK_ID
      AND DECODE(i_COMPANY_TYPE, 1, RQBK_SH_CS.RQSC_SH_ID, 2, RQBK_SH_CS.RQSC_CS_ID) = v_COMPANY_ID
      AND RQBK_IDX.RQI_RQBK_ID = RQBK_AIR_CARRIER.RQAC_RQBK_ID (+)
      AND RQBK_AIR_CARRIER.RQAC_AWB_NUM IS NOT NULL
    ORDER BY RQBK_AIR_CARRIER.RQAC_AWB_NUM ASC;
  END IF;

  IF (i_SEARCH_TYPE = 'NBN') THEN  -- NVO Booking Number
    OPEN o_CURSOR FOR 
    SELECT DISTINCT
      RQBK_OC_CARRIER.RQOC_NVO_NUM SEARCH_TERM
    FROM
      RQBK_IDX, 
      RQBK_SH_CS,
      RQBK_OC_CARRIER 
    WHERE RQBK_IDX.RQI_COMPLETE = -1
      AND RQBK_IDX.RQI_ACTIVE = -1
      AND RQBK_IDX.RQI_RQBK = 2
      AND RQBK_IDX.RQI_RQBK_ID = RQBK_SH_CS.RQSC_RQBK_ID
      AND DECODE(i_COMPANY_TYPE, 1, RQBK_SH_CS.RQSC_SH_ID, 2, RQBK_SH_CS.RQSC_CS_ID) = v_COMPANY_ID
      AND RQBK_IDX.RQI_RQBK_ID = RQBK_OC_CARRIER.RQOC_RQBK_ID (+)
      AND RQBK_OC_CARRIER.RQOC_NVO_NUM IS NOT NULL
    ORDER BY RQBK_OC_CARRIER.RQOC_NVO_NUM ASC;
  END IF;

  IF (i_SEARCH_TYPE = 'POD-Ci') THEN  -- Place of Deleivery [City]
    OPEN o_CURSOR FOR 
    SELECT DISTINCT
      CITY.CT_DESC SEARCH_TERM
    FROM
      RQBK_IDX,
      RQBK_SH_CS,
      CITY
    WHERE RQBK_IDX.RQI_COMPLETE = -1
      AND RQBK_IDX.RQI_ACTIVE = -1
      AND RQBK_IDX.RQI_RQBK = 2
      AND RQBK_IDX.RQI_RQBK_ID = RQBK_SH_CS.RQSC_RQBK_ID
      AND DECODE(i_COMPANY_TYPE, 1, RQBK_SH_CS.RQSC_SH_ID, 2, RQBK_SH_CS.RQSC_CS_ID) = v_COMPANY_ID
      AND RQBK_SH_CS.RQSC_POD = CITY.CT_ID
      AND CITY.CT_DESC IS NOT NULL
    ORDER BY CITY.CT_DESC ASC;
  END IF;

  IF (i_SEARCH_TYPE = 'POD-A') THEN  -- Place of Deleivery [Airport]
    OPEN o_CURSOR FOR 
    SELECT DISTINCT
      AIRPORTS.AP_DESC SEARCH_TERM
    FROM
      RQBK_IDX,
      RQBK_SH_CS,
      AIRPORTS
    WHERE RQBK_IDX.RQI_COMPLETE = -1
      AND RQBK_IDX.RQI_ACTIVE = -1
      AND RQBK_IDX.RQI_RQBK = 2
      AND RQBK_IDX.RQI_RQBK_ID = RQBK_SH_CS.RQSC_RQBK_ID
      AND DECODE(i_COMPANY_TYPE, 1, RQBK_SH_CS.RQSC_SH_ID, 2, RQBK_SH_CS.RQSC_CS_ID) = v_COMPANY_ID
      AND RQBK_SH_CS.RQSC_POD_AIR = AIRPORTS.AP_ID (+)
      AND AIRPORTS.AP_DESC IS NOT NULL
    ORDER BY AIRPORTS.AP_DESC ASC;
  END IF;

  IF (i_SEARCH_TYPE = 'POD-AC') THEN  -- Place of Deleivery [Airport Code]
    OPEN o_CURSOR FOR 
    SELECT DISTINCT
      AIRPORTS.AP_CODE SEARCH_TERM
    FROM
      RQBK_IDX,
      RQBK_SH_CS,
      AIRPORTS
    WHERE RQBK_IDX.RQI_COMPLETE = -1
      AND RQBK_IDX.RQI_ACTIVE = -1
      AND RQBK_IDX.RQI_RQBK = 2
      AND RQBK_IDX.RQI_RQBK_ID = RQBK_SH_CS.RQSC_RQBK_ID
      AND DECODE(i_COMPANY_TYPE, 1, RQBK_SH_CS.RQSC_SH_ID, 2, RQBK_SH_CS.RQSC_CS_ID) = v_COMPANY_ID
      AND RQBK_SH_CS.RQSC_POD_AIR = AIRPORTS.AP_ID (+)
      AND AIRPORTS.AP_CODE IS NOT NULL
    ORDER BY AIRPORTS.AP_CODE ASC;
  END IF;

  IF (i_SEARCH_TYPE = 'POD-Co') THEN  -- Place of Deleivery [Country]
    OPEN o_CURSOR FOR 
    SELECT DISTINCT
      COUNTRY.CY_DESC SEARCH_TERM
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
      AND DECODE(i_COMPANY_TYPE, 1, RQBK_SH_CS.RQSC_SH_ID, 2, RQBK_SH_CS.RQSC_CS_ID) = v_COMPANY_ID
      --AND (RQBK_SH_CS.RQSC_POD = CITY.CT_ID OR RQBK_SH_CS.RQSC_POD_AIR = AIRPORTS.AP_ID)  -- Broken: RQBK_SH_CS.RQSC_POD_AIR column is null
      AND RQBK_SH_CS.RQSC_POD = CITY.CT_ID
      AND CITY.CT_COUNTRY_ID = COUNTRY.CY_ID
      AND COUNTRY.CY_DESC IS NOT NULL
    ORDER BY COUNTRY.CY_DESC ASC;
  END IF;

  IF (i_SEARCH_TYPE = 'CN') THEN  -- Company Name
    OPEN o_CURSOR FOR
    SELECT DISTINCT
      INITCAP(COMPANY.CO_NAME) SEARCH_TERM
    FROM
      RQBK_IDX,
      RQBK_SH_CS,
      COMPANY
    WHERE RQBK_IDX.RQI_COMPLETE = -1
      AND RQBK_IDX.RQI_ACTIVE = -1
      AND RQBK_IDX.RQI_RQBK = 2
      AND RQBK_IDX.RQI_RQBK_ID = RQBK_SH_CS.RQSC_RQBK_ID
      AND DECODE(i_COMPANY_TYPE, 1, RQBK_SH_CS.RQSC_SH_ID, 2, RQBK_SH_CS.RQSC_CS_ID) = v_COMPANY_ID
      AND DECODE(i_COMPANY_TYPE, 2, RQBK_SH_CS.RQSC_SH_ID, 1, RQBK_SH_CS.RQSC_CS_ID) = COMPANY.CO_ID
      AND COMPANY.CO_NAME IS NOT NULL
    ORDER BY SEARCH_TERM ASC;
  END IF;
  
  IF (i_SEARCH_TYPE = 'CT') THEN  -- Commodity Type
    OPEN o_CURSOR FOR 
    SELECT DISTINCT
      RQBK_MC.RQM_COMM_NAME SEARCH_TERM
    FROM
      RQBK_IDX,
      RQBK_SH_CS,
      RQBK_MC
    WHERE RQBK_IDX.RQI_COMPLETE = -1
      AND RQBK_IDX.RQI_ACTIVE = -1
      AND RQBK_IDX.RQI_RQBK = 2
      AND RQBK_IDX.RQI_RQBK_ID = RQBK_SH_CS.RQSC_RQBK_ID
      AND DECODE(i_COMPANY_TYPE, 1, RQBK_SH_CS.RQSC_SH_ID, 2, RQBK_SH_CS.RQSC_CS_ID) = v_COMPANY_ID
      AND RQBK_IDX.RQI_RQBK_ID = RQBK_MC.RQM_RQBK_ID (+)      
      AND RQBK_MC.RQM_COMM_NAME IS NOT NULL
    ORDER BY RQBK_MC.RQM_COMM_NAME ASC;
  END IF;
  
	EXCEPTION WHEN OTHERS THEN
		RAISE;
END;