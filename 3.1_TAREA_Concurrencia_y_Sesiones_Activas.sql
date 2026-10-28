--sesion 35
select pg_backend_pid()

select * from pg_stat_activity
select * from estudiantes e where e.id_estudiante=3 ; 
select * from calificaciones c; 

--Actualizar las calificaciones, en la sesion A (35) serealizara un Rollback y luego se vera en B
begin;
update calificaciones c  set calificacion = 40 
where c.id_calificacion  = 11;
select calificacion from calificaciones c where c.id_calificacion = 11;
rollback;

--actualizar monto
begin;
select monto from pagos p where p.id_pago  = 5;
update pagos p set monto = 2000 where p.id_pago = 5;
rollback;

select * from grupos g 
where id_grupo = 5;

select monto from pagos where id_pago = 5;
for update;


rollback;
