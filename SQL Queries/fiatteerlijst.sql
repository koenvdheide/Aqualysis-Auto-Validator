SELECT AA.OPMERKING SAMPLE_OPMERKING, AA.SAMPLE_ID, AA.LABNUMMER, AA.MONSTERNAMEDATUM, AA.OMSCHRIJVING, AA.MONSTERPUNTCODE, AA.HOEDNHD, AA.SOORTWATER, AA.STATUS, AB.CODE KLANT, AA.FIATGROEP, AA.SMPL_PRIO, 'd' ||LIMS.F_WORKDAYS (TO_CHAR(SYSDATE, 'DD-MM-YYYY' ), TO_CHAR(AA.PRIOFINISHDATE, 'DD-MM-YYYY' )) WORKDAY, AA.PRIOFINISHDATE 
  FROM SAMPLE, ( SELECT DISTINCT A.CODE LABNUMMER, SUBSTR(A.SAMPLINGDATE, 1, 10) MONSTERNAMEDATUM, A.ID SAMPLE_ID, A.NAME OMSCHRIJVING, B.SMPLLC_CODE MONSTERPUNTCODE, B.HOEDANIGHEID HOEDNHD,F.CODE SOORTWATER, A.STATUS, D.CODE FIATGROEP, MIN(C.STATUS) TEST_STATUS, E.CODE SMPL_PRIO, A.PRIOFINISHDATE , LISTAGG(DISTINCT G.TEXTLINE, ' ') WITHIN GROUP(ORDER BY G.LINENUMBER) AS OPMERKING
  FROM SAMPLE A     
    LEFT JOIN QMP.NOTE K 
    ON (K.objectclassname  = 'Sample' AND K.OBJECTID = A.ID)
        LEFT JOIN QMP.NOTELINE G ON K.ID = G.NOTE_ID, 
    SAMPLE_FL B, SAMPLETEST C, V_ANALYSISGROUP D, PRIORITYTYPE E, SAMPLETYPE F,
  ( SELECT 200 AS GROUPNR   FROM DUAL) AA 
  WHERE A.ID = B.ID 
    AND A.ID = C.SAMPLE_ID 
    AND C.CODE = D.TESTCODE 
    AND A.PRIOTP_ID = E.ID 
    AND A.SMPTP_ID = F.ID
    AND A.ISCTRLSAMPLE = 0 
    AND A.CODE NOT LIKE 'T%' 
    AND A.STATUS > 10 
    AND A.STATUS < 300 
    AND NVL(B.WGSSTATUS, 0) <> 294 
    AND D.CODE BETWEEN DECODE(GROUPNR, '' , 0, GROUPNR) 
    AND DECODE(GROUPNR, '' , 10000, GROUPNR) 
 GROUP BY A.CODE, SUBSTR(A.SAMPLINGDATE, 1, 10), A.SAMPLINGDATE, 1, 10, 
A.SAMPLINGDATE, 1, 10, A.NAME, B.SMPLLC_CODE, 
B.HOEDANIGHEID, A.STATUS, D.CODE, E.CODE, A.PRIOFINISHDATE, 
F.CODE, A.ID, G.TEXTLINE, K.ID) AA, CUSTOMER AB 
  WHERE SAMPLE.CODE = AA.LABNUMMER 
    AND SAMPLE.CUST_ID = AB.ID 
    AND (AA.TEST_STATUS > 210 
    AND AA.TEST_STATUS <= 270) ORDER BY AA.LABNUMMER