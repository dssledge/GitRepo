--Updates the Banner form SFAESTS with the refund values for a given ESTS code for a given Term 
--The values for each update is based on a previous semester
--Essentially amounts to a copy from one semester to a new semester but aligns the dates to the semester
--start date.
--------------------------------
--To run, update the variables below to the correct values
--This scripts defaults to a commit
-------------------------------
declare 

nt_startdate date := to_date('06-JAN-2016','DD-MON-YYYY');
nt_term varchar2(6) := '201602';
ot_term varchar2(6) := '201502';
ests_code varchar2(2) := 'WU'; --WU, WS, WF

date_offset number;

cursor c_ot_sfbrfst is
  select SFBRFST_TERM_CODE , SFBRFST_ESTS_CODE , SFBRFST_FROM_DATE , SFBRFST_TO_DATE , SFBRFST_FEES_REFUND , SFBRFST_TUIT_REFUND from SFBRFST where
    SFBRFST_TERM_CODE = ot_term and SFBRFST_ests_code = ests_code;
    
 lv_ot c_ot_sfbrfst%rowtype;

begin 

delete sfbrfst where SFBRFST_TERM_CODE = nt_term and SFBRFST_ests_code = ests_code;

     OPEN c_ot_sfbrfst;

    LOOP
      FETCH c_ot_sfbrfst
      INTO lv_ot;
      EXIT
    WHEN(c_ot_sfbrfst % NOTFOUND);
    
    if (date_offset is null) then
      date_offset := nt_startdate - lv_ot.SFBRFST_FROM_DATE; --Number of days between the new start date and the start date from the origin semester
    end if;
    
    insert into sfbrfst (SFBRFST_TERM_CODE , SFBRFST_ESTS_CODE , SFBRFST_FROM_DATE , SFBRFST_TO_DATE , SFBRFST_FEES_REFUND , SFBRFST_TUIT_REFUND,  SFBRFST_ACTIVITY_DATE)
      values (nt_term , ests_code , lv_ot.SFBRFST_FROM_DATE + date_offset , lv_ot.SFBRFST_TO_DATE + date_offset , lv_ot.SFBRFST_FEES_REFUND, lv_ot.SFBRFST_TUIT_REFUND , sysdate);

  END LOOP;

  CLOSE c_ot_sfbrfst;

commit;

end;
/

--Updates the Banner form SFARSTS with the refund values for a given RSTS code for a given Term and Part of Term
--The values for each update is based on a previous semester
--Essentially amounts to a copy from one semester to a new semester but aligns the dates to the semester
--start date.
--------------------------------
--To run, update the variables below to the correct values
--This scripts defaults to a commit
-------------------------------
declare 

nt_startdate date := to_date('06-JAN-2016','DD-MON-YYYY');
nt_term varchar2(6) := '201602';
ot_term varchar2(6) := '201502';
rsts_code varchar2(2) := 'WU'; --WU, WS, WF
ptrm_code varchar2(3) := 'G03'; --1, A, B, E01, E02, E03, G01, G02, G03

date_offset number;

cursor c_ot_SFRRFCR is
  select SFRRFCR_TERM_CODE , SFRRFCR_RSTS_CODE , SFRRFCR_FROM_DATE , SFRRFCR_TO_DATE , SFRRFCR_FEES_REFUND , SFRRFCR_TUIT_REFUND from SFRRFCR where
    SFRRFCR_TERM_CODE = ot_term and SFRRFCR_rsts_code = rsts_code and SFRRFCR_PTRM_CODE = ptrm_code;
    
 lv_ot c_ot_SFRRFCR%rowtype;

begin 

delete SFRRFCR where SFRRFCR_TERM_CODE = nt_term and SFRRFCR_rsts_code = rsts_code and SFRRFCR_PTRM_CODE = ptrm_code;

     OPEN c_ot_SFRRFCR;

    LOOP
      FETCH c_ot_SFRRFCR
      INTO lv_ot;
      EXIT
    WHEN(c_ot_SFRRFCR % NOTFOUND);
    
    if (date_offset is null) then
      date_offset := nt_startdate - lv_ot.SFRRFCR_FROM_DATE; --Number of days between the new start date and the start date from the origin semester
    end if;
    
    insert into SFRRFCR (SFRRFCR_TERM_CODE , SFRRFCR_PTRM_CODE,  SFRRFCR_RSTS_CODE , SFRRFCR_FROM_DATE , SFRRFCR_TO_DATE , SFRRFCR_FEES_REFUND , SFRRFCR_TUIT_REFUND,  SFRRFCR_ACTIVITY_DATE)
      values (nt_term , ptrm_code , rsts_code , lv_ot.SFRRFCR_FROM_DATE + date_offset , lv_ot.SFRRFCR_TO_DATE + date_offset , lv_ot.SFRRFCR_FEES_REFUND, lv_ot.SFRRFCR_TUIT_REFUND , sysdate);

  END LOOP;

  CLOSE c_ot_SFRRFCR;

commit;

end;
/


