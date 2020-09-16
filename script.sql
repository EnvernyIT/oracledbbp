create table klanten
(
klanten_id number(11) not null primary key,
klanten_naam varchar2(60),
klanten_adress varchar2(60),
klanten_city varchar2(60),
klanten_birthdate date
);
/
create table chequing_account
(
chequing_id number(11) not null primary key,
chequing_rekening_nummer number(11) not null
);
alter table chequing_account
add check (chequing_rekening_nummer >= 10000000000)
add unique (chequing_rekening_nummer);
/
create table savings_account
(
savings_id number(11) not null primary key,
savings_rekening_nummer number(11) not null
);
alter table savings_account
add check (savings_rekening_nummer >= 10000000000)
add unique (savings_rekening_nummer);
/
create table klanten_chequing
(
klanten_account_id number(11) not null primary key,
klanten_id number(11),
chequing_id number(11),
constraint fk_kc_link foreign key (klanten_id) references klanten(klanten_id),
constraint fk_ck_link foreign key (chequing_id) references chequing_account(chequing_id)
);
create table klanten_savings
(
klanten_account_id number(11) not null primary key,
klanten_id number(11),
savings_id number(11),
constraint fk_ks_link foreign key (klanten_id) references klanten(klanten_id),
constraint fk_sk_link foreign key (savings_id) references savings_account(savings_id)
);
/
create table chequing_balans
(
balans_id number(11) not null primary key,
klanten_account_id number(11),
amount number(20),
interest number(3),
last_interaction date,
constraint fk_ch foreign key (klanten_account_id) references klanten_savings(klanten_account_id)
);
create table savings_balans
(
balans_id number(11) not null primary key,
klanten_account_id number(11),
amount number(20),
interest number(3),
last_interaction date,
constraint fk_sa foreign key (klanten_account_id) references klanten_savings(klanten_account_id)
);
/
create table klanten_jn as select * from klanten where 1=0;
/
alter table klanten_jn
add dml_actie varchar2(50);
/
/*insert trigger*/
create or replace trigger klanten_after_insert
after insert
    on klanten
    for each row
begin

    insert into klanten_jn
    (klanten_id,
     klanten_naam,
     klanten_adress,
     klanten_city,
     klanten_birthdate,
     klanten_registration_age,
     dml_actie
     )
     values
     (:new.klanten_id,
      :new.klanten_naam,
      :new.klanten_adress,
      :new.klanten_city,
      :new.klanten_birthdate,
      'I');
      
end;
/
/*insert statement*/
/
/*delete trigger*/
create or replace trigger klanten_after_delete
after delete
    on klanten
    for each row
begin

    insert into klanten_jn
    (klanten_id,
     klanten_naam,
     klanten_adress,
     klanten_city,
     klanten_birthdate,
     dml_actie
     )
     values
     (:new.klanten_id,
      :new.klanten_naam,
      :new.klanten_adress,
      :new.klanten_city,
      :new.klanten_birthdate,
      'D');
      
end;
/
/*delete statement*/
/
create or replace trigger klanten_after_update
after update
    on klanten
    for each row
begin

    insert into klanten_jn
    (klanten_id,
     klanten_naam,
     klanten_adress,
     klanten_city,
     klanten_birthdate,
     dml_actie
     )
     values
     (:new.klanten_id,
      :new.klanten_naam,
      :new.klanten_adress,
      :new.klanten_city,
      :new.klanten_birthdate,
      'U');
      
end;
/
create or replace procedure calculation_interest
is
begin
    update savings_balans set interest = (0.01*amount) where last_interaction >= SYSDATE;
    commit;
    
end;
/
begin
    DBMS_SCHEDULER.create_job (
        job_name => 'interest_calculation',
        job_type => 'PL/SQL BLOCK',
        job_action => 'begin calculation_interest; end;',
        start_date => systimestamp,
        repeat_interval => 'FREQ=MONTHLY; BYMONTHDAY=-1',
        enable => true);
 end;
