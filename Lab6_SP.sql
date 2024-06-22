USE AdventureWorks2014;

/* 1- sp_InsCulture(id,name,date): Este sp debe permitir dar de alta un nuevo registro 
 * en la tabla Production.Culture. Los tipos de datos de los parámetros deben corresponderse 
 * con la tabla. Para ayudarse, se podrá ejecutar el procedimiento sp_help“<esquema.objeto>”
 */

CREATE PROCEDURE Production.sp_InsCulture(@id NCHAR(6),@name NVARCHAR(50),@date DATETIME)
AS
BEGIN
	INSERT INTO Production.Culture(CultureID,Name,ModifiedDate)
	VALUES(@id,@name,@date);
END;

EXECUTE Production.sp_InsCulture 'zy', 'Zamensey', '2024-06-21';


/*2- sp_SelCuture(id): Este sp devolverá el registro completo según el id enviado*/

CREATE PROCEDURE Production.sp_SelCuture(@id NCHAR(6))
AS
BEGIN
	SELECT *
	FROM Production.Culture c
	WHERE c.CultureID = @id
END;

EXECUTE Production.sp_SelCuture 'ze';

/*3- sp_DelCulture(id): Este sp debe borrar el id enviado por parámetro 
de la tabla Production.Culture.*/

CREATE PROCEDURE Production.sp_DelCulture(@id NCHAR(6))
AS
BEGIN
	DELETE FROM Production.Culture 
	WHERE CultureID = @id
END;

EXECUTE Production.sp_DelCulture 'ze'

/*4- sp_UpdCulture(id): Dado un id debe permitirme cambiar el campo name del registro.*/

CREATE PROCEDURE Production.sp_UpdCulture(@id NCHAR(6),@name NVARCHAR(50))
AS
BEGIN
	UPDATE Production.Culture
	SET Name = @name
	WHERE CultureID = @id
END;

EXECUTE Production.sp_UpdCulture 'ze','Yappanese';

/*5- sp_CantCulture (cant out): Realizar un sp que devuelva la cantidad de registros en Culture. 
El resultado deberá colocarlo en una variable de salida.*/

CREATE PROCEDURE Production.sp_CantCulture 
@cant SMALLINT OUTPUT
AS
BEGIN
	SELECT @cant = COUNT(*)
	FROM Production.Culture
END;

DECLARE @cantidad SMALLINT;
EXECUTE Production.sp_CantCulture @cantidad OUTPUT;
SELECT @cantidad;

/*6- sp_CultureAsignadas : Realizar un sp que devuelva solamente las Culture’s 
que estén siendo utilizadas en las tablas (Verificar qué tabla/s la están referenciando). 
Sólo debemos devolver id y nombre de la Cultura.*/

CREATE PROCEDURE Production.sp_CultureAsignadas
AS
BEGIN
	SELECT DISTINCT c.CultureID, c.Name
	FROM Production.Culture c
	INNER JOIN Production.ProductModelProductDescriptionCulture pmc
	ON c.CultureID = pmc.CultureID
END;

EXECUTE Production.sp_CultureAsignadas;


/*7- sp_ValCulture(id,name,date,operación, valida out): 
Este sp permitirá validar los datos enviados por parámetro. 
En el caso que el registro sea válido devolverá un 1 en el parámetro de salida valida ó 0 en caso contrario.
El parámetro operación puede ser “U” (Update), “I” (Insert) ó “D” (Delete). 
Lo que se debe validar es:
- Si se está insertando no se podrá agregar un registro con un id existente, ya que arrojará un error.
- Tampoco se puede agregar dos registros Cultura con el mismo Name, ya que el campo Name es un unique index.
- Ninguno de los campos debería estar vacío.
- La fecha ingresada no puede ser menor a la fecha actual.*/

-- CREATE PROCEDURE sp_ValCulture
