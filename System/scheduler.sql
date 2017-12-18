/*scheduler*******************************************/

-- Create chain.
BEGIN
DBMS_SCHEDULER.CREATE_PROGRAM (
  program_name      => 'PROG_CLS_ADDRESSES',
program_action     => 'u_3nf_cl.PKG_ADDRESSES_CLS.load_cls_addresses',
program_type      => 'STORED_PROCEDURE');

DBMS_SCHEDULER.CREATE_PROGRAM (
  program_name      => 'PROG_CLS_CLIENTS',
program_action     => 'u_3nf_cl.PKG_CLIENTS_CLS.load_clients_cls',
program_type      => 'STORED_PROCEDURE');

DBMS_SCHEDULER.CREATE_PROGRAM (
  program_name      => 'PROG_CLS_EMPLOYEES',
program_action     => 'u_3nf_cl.PKG_EMPLOYEES_CLS.load_employees_cls',
program_type      => 'STORED_PROCEDURE');

DBMS_SCHEDULER.CREATE_PROGRAM (
  program_name      => 'PROG_CLS_GROUP',
program_action     => 'u_3nf_cl.PKG_GROUP_CLS.load_cls_group',
program_type      => 'STORED_PROCEDURE');

DBMS_SCHEDULER.CREATE_PROGRAM (
  program_name      => 'PROG_CLS_MENU_1',
program_action     => 'u_3nf_cl.PKG_MENU_CLS.load_cls_menu',
program_type      => 'STORED_PROCEDURE');

DBMS_SCHEDULER.CREATE_PROGRAM (
  program_name      => 'PROG_3nf_employees',
program_action     => 'u_3nf_cl.PKG_MENU_CLS.load_cls_menu',
program_type      => 'STORED_PROCEDURE');




end;


exec dbms_scheduler.enable('PROG_CLS_ADDRESSES');
exec dbms_scheduler.enable('PROG_CLS_CLIENTS');
exec dbms_scheduler.enable('PROG_CLS_EMPLOYEES');
exec dbms_scheduler.enable('PROG_CLS_GROUP');
exec dbms_scheduler.enable('PROG_CLS_MENU_1');

BEGIN
DBMS_SCHEDULER.CREATE_CHAIN (
   chain_name          => 'chain_cls',
   rule_set_name       => NULL,
   evaluation_interval => NULL,
   comments            => 'My cls chain');
END;

begin
DBMS_SCHEDULER.DEFINE_CHAIN_STEP (
   chain_name      =>  'chain_cls',
   step_name       =>  'step1',
   program_name    =>  'PROG_CLS_ADDRESSES');
   
DBMS_SCHEDULER.DEFINE_CHAIN_STEP (
   chain_name      =>  'chain_cls',
   step_name       =>  'step2',
   program_name    =>  'PROG_CLS_CLIENTS');

DBMS_SCHEDULER.DEFINE_CHAIN_STEP (
   chain_name      =>  'chain_cls',
   step_name       =>  'step3',
   program_name    =>  'PROG_CLS_EMPLOYEES');

DBMS_SCHEDULER.DEFINE_CHAIN_STEP (
   chain_name      =>  'chain_cls',
   step_name       =>  'step4',
   program_name    =>  'PROG_CLS_GROUP');

DBMS_SCHEDULER.DEFINE_CHAIN_STEP (
   chain_name      =>  'chain_cls',
   step_name       =>  'step5',
   program_name    =>  'PROG_CLS_MENU_1');
end;

begin
DBMS_SCHEDULER.DEFINE_CHAIN_RULE (
   chain_name   =>   'chain_cls',
   condition    =>   'TRUE',
   action       =>   'START step1',
   rule_name    =>   'rule1',
   comments     =>   'start the chain');
DBMS_SCHEDULER.DEFINE_CHAIN_RULE (
   chain_name   =>   'chain_cls',
   condition    =>   'step1 completed',
   action       =>   'START step2',
   rule_name    =>   'rule2');
   DBMS_SCHEDULER.DEFINE_CHAIN_RULE (
   chain_name   =>   'chain_cls',
   condition    =>   'step2 completed',
   action       =>   'START step3',
   rule_name    =>   'rule3');
   DBMS_SCHEDULER.DEFINE_CHAIN_RULE (
   chain_name   =>   'chain_cls',
   condition    =>   'step3 completed',
   action       =>   'START step4',
   rule_name    =>   'rule4');
   DBMS_SCHEDULER.DEFINE_CHAIN_RULE (
   chain_name   =>   'chain_cls',
   condition    =>   'step4 completed',
   action       =>   'START step5',
   rule_name    =>   'rule5');
END;
   
begin
DBMS_SCHEDULER.ENABLE ('chain_cls');
end;

begin
DBMS_SCHEDULER.CREATE_JOB (
   job_name        => 'chain_job_cls',
   job_type        => 'CHAIN',
   job_action      => 'chain_cls',
   repeat_interval => 'freq=daily;byhour=13;byminute=0;bysecond=0',
   enabled         => TRUE);
  end;
   
   
   







