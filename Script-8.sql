--script de act 1 parte 3 examen
begin;

update estudiantes set telefono = '6121112233'
where id_estudiante = 2;

savepoint telefono_ok;

update estudiantes set estado = 'BAJA'
where id_estudiante = 2;

rollback to savepoint telefono_ok;

commit;

select * from estudiantes

