declare 

nt_startdate date := to_date('06-JAN-2016','DD-MON-YYYY');
nt_term varchar2(6) := '201602';
ot_term varchar2(6) := '201502';
ests_code varchar2(2) := 'WU';

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


end;
/

rollback;
select * from SFBRFST where SFBRFST_term_code = '201602' and SFBRFST_ests_code = 'WU';
commit;
/*

