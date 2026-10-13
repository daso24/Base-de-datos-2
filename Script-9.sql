--act 3 parte 3 examen
begin

update estudiantes set telefono = '6121112233'
where id_estudiante = 2 and id_periodo = 2;

insert into pagos 
(id_estudiante,id_periodo,concepto,monto,metodo_pago,referencia)
values 
(2,2,'regularizacion academica',1200.00,'transferencia','REG2026-002'),

savepoint sp_regularizacion;

update estudiantes set estado = 'BAJA';

rollback to savepoint sp_regularizacion;

commit;
select*from estudiantes e 

