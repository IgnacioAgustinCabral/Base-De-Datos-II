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

CREATE PROCEDURE PRODUCTION.sp_ValCulture (@id NCHAR(6), @name NVARCHAR(50), @date DATETIME, @operacion CHAR(1), @valida BIT OUTPUT)
AS
BEGIN
    SET @valida = 1;
    IF @operacion = 'I'
    BEGIN
        IF EXISTS (SELECT * FROM Production.Culture WHERE CultureID = @id)
        BEGIN
            SET @valida = 0;
        END
        IF EXISTS (SELECT * FROM Production.Culture WHERE Name = @name)
        BEGIN
            SET @valida = 0;
        END
    END
    IF @operacion = 'U'
    BEGIN
        IF EXISTS (SELECT * FROM Production.Culture WHERE Name = @name)
        BEGIN
            SET @valida = 0
        END
    END
    IF @operacion = 'D'
    BEGIN
        IF NOT EXISTS (SELECT * FROM Production.Culture WHERE CultureID = @id)
        BEGIN
            SET @valida = 0;
        END
    END
    IF @id = '' OR @name = '' OR @date IS NULL
    BEGIN
        SET @valida = 0;
    END
    IF @date < GETDATE()
    BEGIN
        SET @valida = 0;
    END
END;

DECLARE @valida BIT;
-- EXECUTE Production.sp_ValCulture 'zy', 'Zamensey', '2024-06-21', 'I', @valida OUTPUT; --YA EXISTE DEVUELVE 0
EXECUTE Production.sp_ValCulture 'bb', 'Zarazenb', '2024-06-23', 'I', @valida OUTPUT; --FECHA MAYOR QUE ACTUAL DEVUELVE 1
SELECT @valida;


/*8- sp_SelCulture2(id out, name out, date out): A diferencia del sp del punto 2, este debe emitir todos los datos en sus parámetros de salida. ¿Cómo se debe realizar la llamada del sp para testear este sp?*/

CREATE PROCEDURE Production.sp_SelCulture2 (@idSeleccionado NCHAR(6), @id NCHAR(6) OUTPUT, @name NVARCHAR(50) OUTPUT, @date DATETIME OUTPUT)
AS
BEGIN
    SELECT TOP 1 @id = CultureID, @name = Name, @date = ModifiedDate
    FROM Production.Culture
    WHERE CultureID = @idSeleccionado
END;

DECLARE @idSeleccionado NCHAR(6), @id NCHAR(6), @name NVARCHAR(50), @date DATETIME;
EXECUTE Production.sp_SelCulture2 'en', @id OUTPUT, @name OUTPUT, @date OUTPUT;
SELECT @id, @name, @date;


/*9- Realizar una modificación al sp sp_InsCulture para que valide los registros ingresados. Por lo cual, deberá invocar al sp p_ValCulture. Sólo se insertará si la validación es correcta.*/

ALTER PROCEDURE Production.sp_InsCulture(@id NCHAR(6),@name NVARCHAR(50),@date DATETIME)
AS
BEGIN
    DECLARE @valida BIT;
    EXECUTE Production.sp_ValCulture @id, @name, @date, 'I', @valida OUTPUT;
    IF @valida = 1
    BEGIN
        INSERT INTO Production.Culture(CultureID,Name,ModifiedDate)
        VALUES(@id,@name,@date);
        PRINT 'Registro insertado correctamente';
    END
    IF @valida = 0
    BEGIN
        PRINT 'No se pudo insertar el registro';
    END
END;

EXECUTE Production.sp_InsCulture 'gg', 'Galapaguiano', '2024-06-23';


/*10- Idem con el sp sp_UpdCulture. Validar los datos a actualizar.*/

ALTER PROCEDURE Production.sp_UpdCulture(@id NCHAR(6),@name NVARCHAR(50),@date DATETIME)
AS
BEGIN
    DECLARE @valida BIT;
    EXECUTE Production.sp_ValCulture @id,@name,@date, 'U', @valida OUTPUT
    IF @valida = 1
    BEGIN
        UPDATE Production.Culture
        SET Name = @name , ModifiedDate = @date
        WHERE CultureID = @id
        PRINT 'Registro actualizado correctamente';
    END
    IF @valida = 0
    BEGIN
        PRINT 'No se pudo actualizar el registro';
    END
END;

EXECUTE Production.sp_UpdCulture 'gg', 'Galapaguianox', '2024-06-24';


/*11- En sp_DelCulture se deberá modificar para que valide que no posea registros relacionados en la tabla que lo referencia. Investigar cuál es la tabla referenciada e incluir esta validación. Si se está utilizando, emitir un mensaje que no se podrá eliminar.*/
ALTER PROCEDURE Production.sp_DelCulture(@id NCHAR(6))
AS
BEGIN
    DECLARE @existe BIT;
    SET @existe = 0;
    IF EXISTS (SELECT * FROM Production.ProductModelProductDescriptionCulture WHERE CultureID = @id)
    BEGIN
        SET @existe = 1;
        PRINT 'No se puede eliminar el registro ya que está siendo utilizado';
    END
    IF @existe = 0
    BEGIN
        DELETE FROM Production.Culture
        WHERE CultureID = @id;
        PRINT 'Registro eliminado correctamente';
    END
END;

EXECUTE Production.sp_DelCulture 'en'; --No se borra porque esta en uso


/*12- sp_CrearCultureHis: Realizar un sp que permita crear la siguiente tabla histórica de Cultura. Si existe deberá eliminarse. Ejecutar el procedimiento para que se pueda crear:
CREATE TABLE Production.CultureHis( CultureID nchar(6) NOT NULL,
Name [dbo].[Name] NOT NULL,
ModifiedDate datetime NOT NULL CONSTRAINT
DF_CultureHis_ModifiedDate DEFAULT (getdate()), CONSTRAINT PK_CultureHis_IDDate PRIMARY KEY CLUSTERED (CultureID,
ModifiedDate)
)
- ¿Qué tipo de datos posee asignado el campo Name?
- ¿Qué sucede si no se inserta el campo ModifiedDate?*/
CREATE PROCEDURE Production.sp_CrearCultureHis
AS
BEGIN
    IF OBJECT_ID('Production.CultureHis') IS NOT NULL
    BEGIN
        DROP TABLE Production.CultureHis
    END
    BEGIN
        CREATE TABLE Production.CultureHis(
            CultureID nchar(6) NOT NULL,
            Name [dbo].[Name] NOT NULL,
            ModifiedDate datetime NOT NULL CONSTRAINT DF_CultureHis_ModifiedDate DEFAULT (getdate()),
            CONSTRAINT PK_CultureHis_IDDate PRIMARY KEY CLUSTERED (CultureID, ModifiedDate)
        )
    END
END;

EXECUTE Production.sp_CrearCultureHis;

/*13- Dada la tabla histórica creada en el punto 12, se desea modificar el procedimiento p_UpdCulture creado en el punto 4. La modificación consiste en que cada vez que se cambia algún valor de la tabla Culture se desea enviar el registro anterior a una tabla histórica. De esta forma, en la tabla Culture siempre tendremos el último registro y en la tabla CutureHis cada una de las modificaciones realizadas.*/
ALTER PROCEDURE Production.sp_UpdCulture(@id NCHAR(6),@name NVARCHAR(50))
AS
BEGIN
    DECLARE @valida BIT;
    EXECUTE Production.sp_ValCulture @id,@name,GETDATE, 'U', @valida OUTPUT
    IF @valida = 1
    BEGIN
        DECLARE @nameAnterior NVARCHAR(50);
        SELECT @nameAnterior = Name
        FROM Production.Culture
        WHERE CultureID = @id
        INSERT INTO Production.CultureHis(CultureID,Name,ModifiedDate)
        VALUES(@id,@nameAnterior,GETDATE());
        UPDATE Production.Culture
        SET Name = @name , ModifiedDate = GETDATE()
        WHERE CultureID = @id
        PRINT 'Registro actualizado correctamente';
    END
    IF @valida = 0
    BEGIN
        PRINT 'No se pudo actualizar el registro';
    END
END;


/*14- sp_UserTables(opcional esquema): Realizar un procedimiento que liste las tablas que hayan sido creadas dentro de la base de datos con su nombre, esquema y fecha de creación. En el caso que se ingrese por parámetro el esquema, entonces mostrar únicamente dichas tablas, de lo contrario, mostrar todos los esquemas de la base.*/
CREATE PROCEDURE dbo.sp_UserTables(@esquema NVARCHAR(50) = NULL)
AS
BEGIN
    IF @esquema IS NULL
    BEGIN
        SELECT t.name AS NombreTabla, s.name AS Esquema, t.create_date AS FechaCreacion
        FROM sys.tables t
        INNER JOIN sys.schemas s
        ON t.schema_id = s.schema_id
    END
    ELSE
    BEGIN
        SELECT t.name AS NombreTabla, s.name AS Esquema, t.create_date AS FechaCreacion
        FROM sys.tables t
        INNER JOIN sys.schemas s
        ON t.schema_id = s.schema_id
        WHERE s.name = @esquema
    END
END;

EXECUTE dbo.sp_UserTables 'Production';


/*15- sp_GenerarProductoxColor(): Generar un procedimiento que divida los productos según el color que poseen. Los mismos deben ser insertados en diferentes tablas según el color del producto. Por ejemplo, las tablas podrían ser Product_Black, Product_Silver, etc… Estas tablas deben ser generadas dinámicamente según los colores que existan en los productos, es decir, si genero un nuevo producto con un nuevo color, al ejecutar el procedimiento debe generar dicho color. Cada vez que se ejecute este procedimiento se recrearán las tablas de colores. Los productos que no posean color asignados, no se tendrán en cuenta para la generación de tablas y no se insertarán en ninguna tabla de color.*/
CREATE PROCEDURE Production.sp_GenerarProductoxColor
AS
BEGIN
    CREATE TABLE #Colores(Color NVARCHAR(50));

    INSERT INTO #Colores(Color)
    SELECT DISTINCT p.Color
    FROM Production.Product p
    WHERE p.Color IS NOT NULL;

    DECLARE @color NVARCHAR(50);
    DECLARE @sql NVARCHAR(MAX);
    DECLARE @rowCount INT;

    SELECT @rowCount = COUNT(*) FROM #Colores;

    WHILE @rowCount > 0
    BEGIN
        SELECT TOP 1 @color = Color
        FROM #Colores;

        SET @sql = 'CREATE TABLE Product_' + @color + ' AS SELECT * FROM Production.Product WHERE Color = ''' + @color + '''';

        EXECUTE sp_executesql @sql;

        DELETE FROM #Colores WHERE Color = @color;

        SELECT @rowCount = COUNT(*) FROM #Colores;
    END;

    DROP TABLE #Colores;
END;

EXECUTE Production.sp_GenerarProductoxColor;


/*16- sp_UltimoProducto(param): Realizar un procedimiento que devuelva en sus parámetros (output), el último producto ingresado.*/
CREATE PROCEDURE Production.sp_UltimoProducto
@id INT OUTPUT, @name NVARCHAR(50) OUTPUT, @color NVARCHAR(50) OUTPUT, @listPrice MONEY OUTPUT
AS
BEGIN
    SELECT TOP 1 @id = ProductID, @name = Name, @color = Color, @listPrice = ListPrice
    FROM Production.Product
    ORDER BY ProductID DESC
END;

DECLARE @id INT, @name NVARCHAR(50), @color NVARCHAR(50), @listPrice MONEY;
EXECUTE Production.sp_UltimoProducto @id OUTPUT, @name OUTPUT, @color OUTPUT, @listPrice OUTPUT;
SELECT @id, @name, @color, @listPrice;


/*17- sp_TotalVentas(fecha): Realizar un procedimiento que devuelva el total facturado en un día dado. El procedimiento, simplemente debe devolver el total monetario de lo facturado (Sales).*/
CREATE PROCEDURE Sales.sp_TotalVentas(@fecha DATETIME,@total FLOAT OUTPUT)
AS
BEGIN
    SELECT @total = SUM(so.TotalDue)
    FROM Sales.SalesOrderHeader so
    WHERE OrderDate = @fecha
END;

DECLARE @fecha DATETIME,@total FLOAT;
SET @fecha = '2011-05-31';
EXECUTE Sales.sp_TotalVentas @fecha, @total OUTPUT;
SELECT @total;