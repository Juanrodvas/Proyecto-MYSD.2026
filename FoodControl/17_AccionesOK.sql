-----------------
--AccionesOK--
--1--
INSERT INTO Empleados(id_empleado, nombre, salario)
VALUES(99, 'jhojan', 2000);

INSERT INTO Cocineros(id_empleado, Especialidad)
VALUES(99, 'reposteria');

SELECT * FROM Cocineros WHERE id_empleado=99;

DELETE FROM Empleados WHERE id_empleado=99;

SELECT * FROM Cocineros WHERE id_empleado=99;

--2--
INSERT INTO Empleados(id_empleado, nombre, salario)
VALUES(109, 'JUAN', 4000);

INSERT INTO Meseros(id_empleado, turno)
VALUES(109, 'Noche');

SELECT * FROM Meseros WHERE id_empleado=109;

DELETE FROM Empleados WHERE id_empleado=109;

SELECT * FROM Meseros WHERE id_empleado=109;

--3--
INSERT INTO Ingredientes(id_ingrediente, nombre, Fecha_vencimiento)
VALUES(00099, 'Azúcar', '2030-07-17');

INSERT INTO Inventarios(id_ingrediente, cantidad_disponible)
VALUES(00099, 150);

SELECT * FROM Inventarios WHERE id_ingrediente=00099;

DELETE FROM Ingredientes WHERE id_ingrediente=00099;

SELECT * FROM Inventarios WHERE id_ingrediente=00099;
