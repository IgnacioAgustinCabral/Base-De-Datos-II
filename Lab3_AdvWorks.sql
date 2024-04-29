/*1. Realizar una consulta que permita devolver la fecha y hora actual*/
SELECT GETDATE();


/*2. Realizar una consulta que permita devolver únicamente el año y mes actual:*/
SELECT YEAR(GETDATE()) AS Anio, MONTH(GETDATE()) AS Mes;


/*3. Realizar una consulta que permita saber cuántos días faltan para el día de la primavera (21-Sep)*/
DECLARE @Primavera DATE = '2024-09-21';
DECLARE @Hoy DATE = GETDATE();

SELECT DATEDIFF(DAY,@Hoy,@Primavera) AS Dias_Hasta_Primavera;


/*4. Realizar una consulta que permita redondear el número 385,86 con únicamente 1 decimal.*/
DECLARE @Num FLOAT = 385.86;
DECLARE @NumRedondeado VARCHAR(10) = STR(@Num,5,1);

SELECT @NumRedondeado AS Redondeo;


/*5. Realizar una consulta permita saber cuánto es el mes actual al cuadrado.
Por ejemplo, si estamos en Junio, sería 6^2*/
DECLARE @MesActual INT = MONTH(GETDATE());

SELECT POWER(@MesActual,2) AS Mes_al_Cuadrado;


/*6. Devolver cuál es el usuario que se encuentra conectado a la base de datos*/
SELECT ORIGINAL_LOGIN() AS UsuarioConectado;


/*7. Realizar una consulta que permita conocer la edad de cada empleado
(Ayuda: HumanResources.Employee)*/
SELECT DATEDIFF(YEAR,e.BirthDate ,GETDATE()) AS Edad_Empleado
FROM HumanResources.Employee e;


/*8. Realizar una consulta que retorne la longitud de cada apellido de los Contactos, ordenados por apellido. 
En el caso que se repita el apellido devolver únicamente uno de ellos.*/
SELECT LEN(p.LastName) AS Longitud_Apellido
FROM Person.Person p 
GROUP BY p.LastName 
ORDER BY p.LastName ASC;


/*9. Realizar una consulta que permita encontrar el apellido con mayor longitud.*/
SELECT TOP 1 p.LastName AS Apellido_mas_largo , LEN(p.LastName) AS Longitud_Apellido
FROM Person.Person p 
GROUP BY p.LastName 
ORDER BY LEN(p.LastName) DESC;


/*10. Realizar una consulta que devuelva los nombres y apellidos de los contactos 
que hayan sido modificados en los últimos 3 años.*/
SELECT p.FirstName ,p.LastName
FROM Person.Person p
WHERE DATEDIFF(YEAR,p.ModifiedDate,GETDATE()) <= 3;


/*11. Se quiere obtener los emails de todos los contactos, pero en mayúscula.*/
SELECT UPPER(p.LastName) 
FROM Person.Person p
INNER JOIN Person.EmailAddress ea 
ON p.BusinessEntityID = ea.BusinessEntityID;


/*12. Realizar una consulta que permita particionar el mail de cada contacto en 
ID,email,nombre,dominio*/
SELECT ea.BusinessEntityID AS ID,
       ea.EmailAddress AS Email,
       LEFT(ea.EmailAddress, CHARINDEX('@', ea.EmailAddress, 1) - 1) AS Nombre,
       SUBSTRING(
		       ea.EmailAddress, 
		       CHARINDEX('@', ea.EmailAddress, 1) + 1, 
		       CHARINDEX('.', ea.EmailAddress, CHARINDEX('@', ea.EmailAddress)) - CHARINDEX('@', ea.EmailAddress) - 1
       ) AS Dominio
FROM Person.EmailAddress ea;

/*13. Devolver los últimos 3 dígitos del NationalIDNumber de cada empleado*/
SELECT RIGHT(e.NationalIDNumber,3) AS Ultimos_Tres_Numero_DNI
FROM HumanResources.Employee e;


/*14. Se desea enmascarar el NationalIDNumbre de cada empleado,
de la siguiente forma ###-####-##:*/
SELECT e.BusinessEntityID AS ID,e.NationalIDNumber AS Numero,
    CASE
        WHEN LEN(e.NationalIDNumber) = 5 THEN CONCAT(SUBSTRING(e.NationalIDNumber, 1, 3), '-', SUBSTRING(e.NationalIDNumber, 4, 2))
        WHEN LEN(e.NationalIDNumber) = 6 THEN CONCAT(SUBSTRING(e.NationalIDNumber, 1, 3), '-', SUBSTRING(e.NationalIDNumber, 4, 3))
        WHEN LEN(e.NationalIDNumber) = 7 THEN CONCAT(SUBSTRING(e.NationalIDNumber, 1, 3), '-', SUBSTRING(e.NationalIDNumber, 4, 4))
        WHEN LEN(e.NationalIDNumber) = 8 THEN CONCAT(SUBSTRING(e.NationalIDNumber, 1, 3), '-', SUBSTRING(e.NationalIDNumber, 4, 4), '-', SUBSTRING(e.NationalIDNumber, 8, 1))
        WHEN LEN(e.NationalIDNumber) = 9 THEN CONCAT(SUBSTRING(e.NationalIDNumber, 1, 3), '-', SUBSTRING(e.NationalIDNumber, 4, 4), '-', SUBSTRING(e.NationalIDNumber, 8, 2))
    END AS Enmascarado
FROM HumanResources.Employee e;


/*15. Listar la dirección de cada empleado “supervisor” que haya nacido hace más de 30 años.
Listar todos los datos en mayúscula. Los datos a visualizar son:
nombre y apellido del empleado, dirección y ciudad*/
SELECT CONCAT(UPPER(p.FirstName), ' ', UPPER(p.LastName)) AS Nombre_Y_Apellido,
       CONCAT(UPPER(a.AddressLine1), ' ', UPPER(a.City)) AS Direccion_Y_Ciudad
FROM HumanResources.Employee e
INNER JOIN Person.Person p 
ON p.BusinessEntityID = e.BusinessEntityID
INNER JOIN Person.BusinessEntityAddress bea 
ON p.BusinessEntityID = bea.BusinessEntityID
INNER JOIN Person.Address a 
ON bea.AddressID = a.AddressID
WHERE e.JobTitle LIKE '%supervisor%'
  AND DATEDIFF(YEAR, e.BirthDate, GETDATE()) > 30;

 
/*16. Listar la cantidad de empleados hombres y mujeres, de la siguiente forma*/
SELECT CASE
           WHEN e.Gender = 'M' THEN 'Masculino'
           ELSE 'Femenino'
       END AS Sexo,
       COUNT(*) AS Cantidad
FROM HumanResources.Employee e
GROUP BY CASE
             WHEN e.Gender = 'M' THEN 'Masculino'
             ELSE 'Femenino'
         END;
         

/*17. Categorizar a los empleados según la cantidad de horas de vacaciones, según el siguiente formato:
Alto = más de 50 / medio= entre 20 y 50 / bajo = menos de 20*/
SELECT CONCAT(p.FirstName, ' ', p.LastName) AS Empleado,
       CASE
           WHEN e.VacationHours > 50 THEN 'Alto'
           WHEN e.VacationHours >= 20
                AND e.VacationHours <=50 THEN 'Medio'
           ELSE 'Bajo'
       END AS Horas
FROM HumanResources.Employee e
INNER JOIN Person.Person p 
ON p.BusinessEntityID = e.BusinessEntityID;
