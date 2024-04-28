/*1. Listar los nombres de los productos y el nombre del modelo que posee asignado. 
Solo listar aquellos que tengan asignado algún modelo.*/
SELECT p.Name AS Producto,
       pm.Name AS Modelo
FROM Production.Product p
INNER JOIN Production.ProductModel pm ON p.ProductModelID = pm.ProductModelID;


/*2. Mostrar “todos” los productos junto con el modelo que tenga asignado. 
En el caso que no tenga asignado ningún modelo, mostrar su nulidad.*/
SELECT p.Name AS Producto,
       pm.Name AS Modelo
FROM Production.Product p
LEFT JOIN Production.ProductModel pm ON p.ProductModelID = pm.ProductModelID;


/*3. Ídem Ejercicio2, pero en lugar de mostrar nulidad, mostrar la palabra “Sin Modelo” 
para indicar que el producto no posee un modelo asignado.*/
SELECT p.Name AS Producto,
       CASE
           WHEN pm.name IS NULL THEN 'Sin Modelo'
           ELSE pm.name
       END AS Modelo
FROM Production.Product p
LEFT JOIN Production.ProductModel pm ON p.ProductModelID = pm.ProductModelID;


/*4. Contar la cantidad de Productos que poseen asignado cada uno de los modelos.*/
SELECT pm.Name,
       COUNT(*) AS Cantidad_de_productos_en_modelo
FROM Production.Product p
INNER JOIN Production.ProductModel pm ON p.ProductModelID = pm.ProductModelID
GROUP BY pm.Name;


/*5. Contar la cantidad de Productos que poseen asignado cada uno de los modelos, 
pero mostrar solo aquellos modelos que posean asignados 2 o más productos.*/
SELECT pm.Name,
       COUNT(*) AS Cantidad_de_productos_en_modelo
FROM Production.Product p
INNER JOIN Production.ProductModel pm ON p.ProductModelID = pm.ProductModelID
GROUP BY pm.Name
HAVING COUNT(*) >= 2;


/*6. Contar la cantidad de Productos que poseen asignado un modelo valido, es decir, 
que se encuentre cargado en la tabla de modelos. 
Realizar este ejercicio de 3 formas posibles: “exists” / “in” / “inner join”.*/
--EXISTS
SELECT COUNT(*) AS productos_con_modelo_valido
FROM Production.Product p
WHERE EXISTS
    (SELECT ProductModelID
     FROM Production.ProductModel
     WHERE ProductModelID = p.ProductModelID);
    
--IN
SELECT COUNT(*) AS productos_con_modelo_valido
FROM Production.Product p
WHERE p.ProductModelID IN
    (SELECT ProductModelID
     FROM Production.ProductModel);
    
--INNER JOIN
SELECT COUNT(*) AS productos_con_modelo_valido
FROM Production.Product p
INNER JOIN Production.ProductModel pm ON p.ProductModelID = pm.ProductModelID;


/*7. Contar cuantos productos poseen asignado cada uno de los modelos, es decir, 
se quiere visualizar el nombre del modelo y la cantidad de productos asignados.
Si algún modelo no posee asignado ningún producto, se quiere visualizar 0 (cero).*/
SELECT pm.Name,
       COALESCE(COUNT(p.ProductID), 0) AS Cantidad_de_productos_por_modelo
FROM Production.ProductModel pm
LEFT JOIN Production.Product p ON p.ProductModelID = pm.ProductModelID
GROUP BY pm.Name;

/*
--revisar el tema del count y coalesce
SELECT *
FROM Production.ProductModel pm
LEFT JOIN Production.Product p ON p.ProductModelID = pm.ProductModelID;
*/


/*8. Se quiere visualizar, el nombre del producto, el nombre modelo que posee asignado, 
la ilustración que posee asignada y la fecha de última modificación de dicha ilustración 
y el diagrama que tiene asignado la ilustración. 
Solo nos interesan los productos que cuesten más de $150 y que posean algún color asignado.*/
SELECT p.Name,
       pm.Name,
       i.Diagram,
       i.ModifiedDate
FROM Production.Product p
INNER JOIN Production.ProductModel pm ON p.ProductModelID = pm.ProductModelID
INNER JOIN Production.ProductModelIllustration pmi ON pm.ProductModelID = pmi.ProductModelID
INNER JOIN Production.Illustration i ON pmi.IllustrationID = i.IllustrationID
WHERE p.ListPrice > 150
  AND p.Color IS NOT NULL;


/*9. Mostrar aquellas culturas que no están asignadas a ningún producto/modelo.
(Production.ProductModelProductDescriptionCulture)*/
SELECT *
FROM Production.Culture c
WHERE c.CultureID NOT IN
    (SELECT CultureID
     FROM Production.ProductModelProductDescriptionCulture);
    

/*10. Agregar a la base de datos el tipo de contacto “Ejecutivo de Cuentas”
(Person.ContactType)*/
INSERT INTO Person.ContactType(Name)
VALUES('Ejecutivo de Cuentas');


/*11. Agregar la cultura llamada “nn” – “Cultura Moderna”.*/
INSERT INTO Production.Culture(CultureID,Name)
VALUES('nn','Cultura Moderna');


/*12. Cambiar la fecha de modificación de las culturas 
Spanish, French y Thai para indicar que fueron modificadas hoy.*/
UPDATE Production.Culture
SET ModifiedDate = GETDATE() 
WHERE Name = 'Spanish' OR Name = 'French' OR Name = 'Thai';


/*14. Al contacto con ID 10 colocarle como nombre “Juan Perez”.*/			
UPDATE Person.Person 
SET FirstName = 'Juan', LastName = 'Perez'
WHERE BusinessEntityID = 10;


/*15. Agregar la moneda “Peso Argentino” con el código “PAR”
(Sales.Currency)*/
INSERT INTO Sales.Currency(CurrencyCode,Name)
VALUES('PAR','Peso Argentino');


/*16. ¿Qué sucede si tratamos de eliminar el código ARS 
correspondiente al Peso Argentino? ¿Por qué?*/
DELETE FROM Sales.Currency 
WHERE CurrencyCode = 'ARS';

--La tabla CountryRegionCurrency tiene una FK a Currency en la columna CurrencyCode


/*17. Realice los borrados necesarios para que 
nos permita eliminar el registro de la moneda con código ARS.*/
DELETE FROM Sales.CountryRegionCurrency
WHERE CurrencyCode = 'ARS';

DELETE FROM Sales.CurrencyRate 
WHERE ToCurrencyCode = 'ARS'

DELETE FROM Sales.Currency 
WHERE CurrencyCode = 'ARS';


/*18. Eliminar aquellas culturas que no estén asignadas a ningún
producto (Production.ProductModelProductDescriptionCulture)*/
DELETE
FROM Production.Culture
WHERE CultureID NOT IN
    (SELECT CultureID
     FROM Production.ProductModelProductDescriptionCulture)