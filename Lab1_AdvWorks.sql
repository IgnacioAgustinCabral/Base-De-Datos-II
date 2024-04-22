/*1- Listar los c�digos y descripciones de todos los productos
(Ayuda: Production.Product)*/
SELECT p.ProductID,
       pd.Description
FROM Production.Product p
INNER JOIN Production.ProductDescription pd ON p.ProductID = pd.ProductDescriptionID;


/*2- Listar los datos de la subcategor�a n�mero 17 (Ayuda:
Production.ProductSubCategory)*/
SELECT *
FROM Production.ProductSubcategory ps
INNER JOIN Production.Product p ON p.ProductSubcategoryID = ps.ProductSubcategoryID
WHERE ps.ProductSubcategoryID = 17;


/*3-Listar los productos cuya descripci�n comience con D (Ayuda:
like �D%�)*/
SELECT pd.Description
FROM Production.Product p
INNER JOIN Production.ProductDescription pd ON p.ProductID = pd.ProductDescriptionID
WHERE pd.Description LIKE 'D%';


/*4- Listar las descripciones de los productos cuyo n�mero finalice
con 8 (Ayuda: ProductNumber like �%8�)*/
SELECT p.ProductNumber,
       pd.Description
FROM Production.Product p
INNER JOIN Production.ProductDescription pd ON p.ProductID = pd.ProductDescriptionID
WHERE p.ProductNumber LIKE '%8';


/*5- Listar aquellos productos que posean un color asignado. Se
deber�n excluir todos aquellos que no posean ning�n valor
(Ayuda: is not null)*/
SELECT *
FROM Production.Product p
WHERE p.Color IS NOT NULL;


/*6- Listar el c�digo y descripci�n de los productos de color Black
(Negro) y que posean el nivel de stock en 500. (Ayuda:
SafetyStockLevel = 500)*/
SELECT p.ProductID,
       pd.Description
FROM Production.Product p
INNER JOIN Production.ProductDescription pd ON p.ProductID = pd.ProductDescriptionID
WHERE p.Color = 'Black'
  AND p.SafetyStockLevel = 500;


/*7- Listar los productos que sean de color Black (Negro) � Silver
(Plateado).*/
SELECT *
FROM Production.Product p
WHERE p.Color = 'Black'
  OR p.Color = 'Silver';


/*8- Listar los diferentes colores que posean asignados los
productos. S�lo se deben listar los colores. (Ayuda: distinct)*/
SELECT DISTINCT(p.Color)
FROM Production.Product p
WHERE p.Color IS NOT NULL;


/*9- Contar la cantidad de categorías que se encuentren cargadas
en la base. (Ayuda: count)*/
SELECT COUNT(*)
FROM Production.ProductCategory pc;


/*10- Contar la cantidad de subcategorías que posee asignada la
categoría 2.*/
SELECT COUNT(*)
FROM Production.ProductSubcategory ps 
WHERE ps.ProductCategoryID = 2;


/*11- Listar la cantidad de productos que existan por cada uno de los
colores.*/
SELECT p.Color , COUNT(*) AS Cantidad
FROM Production.Product p 
WHERE p.Color IS NOT NULL
GROUP BY p.Color
ORDER BY Cantidad DESC;


/*12- Sumar todos los niveles de stocks aceptables que deben existir
para los productos con color Black. (Ayuda: sum)*/
SELECT SUM(p.SafetyStockLevel) AS Suma_Nivel_Stock_Aceptable
FROM Production.Product p 
WHERE p.Color = 'Black';


/*13- Calcular el promedio de stock que se debe tener de todos los
productos cuyo código se encuentre entre el 316 y 320.
(Ayuda: avg)*/
SELECT AVG(p.SafetyStockLevel) AS Promedio_De_Stock
FROM Production.Product p 
WHERE p.ProductID BETWEEN 316 AND 320;


/*14- Listar el nombre del producto y descripción de la subcategoría
que posea asignada. (Ayuda: inner join)*/
SELECT p.Name as Nombre_Producto , ps.Name AS Descripcion_Subcategoria
FROM Production.Product p 
INNER JOIN Production.ProductSubcategory ps 
ON p.ProductSubcategoryID  = ps.ProductSubcategoryID; 


/*15- Listar todas las categorías que poseen asignado al menos una
subcategoría. Se deberán excluir aquellas que no posean
ninguna.*/
SELECT pc.Name , COUNT(*) AS Cantidad_Subcategorias_Asignadas
FROM Production.ProductCategory pc 
INNER JOIN Production.ProductSubcategory ps 
ON pc.ProductCategoryID  = ps.ProductCategoryID
GROUP BY pc.Name 
HAVING COUNT(*) > 1
ORDER BY Cantidad_Subcategorias_Asignadas DESC;


/*16- Listar el código y descripción de los productos que posean fotos
asignadas. (Ayuda: Production.ProductPhoto)*/
SELECT p.ProductID , p.Name 
FROM Production.Product p 
INNER JOIN Production.ProductProductPhoto ppp 
ON p.ProductID = ppp.ProductID;


/*17- Listar la cantidad de productos que existan por cada una de las
Clases (Ayuda: campo Class)*/
SELECT p.Class ,COUNT(*) AS Cantidad
FROM Production.Product p
WHERE p.Class IS NOT NULL
GROUP BY p.Class;


/*18- Listar la descripción de los productos y su respectivo color. Sólo
nos interesa caracterizar al color con los valores: Black, Silver
u Otro. Por lo cual si no es ni silver ni black se debe indicar
Otro. (Ayuda: utilizar case).*/
SELECT p.Name ,
CASE 
	WHEN p.Color = 'Black' THEN 'Black'
	WHEN p.Color = 'Silver' THEN 'Silver'
	ELSE 'Otro'
END AS Color
FROM Production.Product p;


/*19- Listar el nombre de la categoría, el nombre de la subcategoría
y la descripción del producto. (Ayuda: join)*/
SELECT pc.Name AS Categoria, ps.Name AS Subcategoria, p.Name AS Producto, pd.Description AS Descripcion
FROM Production.Product p 
INNER JOIN Production.ProductSubcategory ps 
ON p.ProductSubcategoryID = ps.ProductSubcategoryID 
INNER JOIN Production.ProductCategory pc 
ON pc.ProductCategoryID = ps.ProductCategoryID
INNER JOIN Production.ProductModelProductDescriptionCulture pmpdc 
ON p.ProductModelID = pmpdc.ProductModelID 
INNER JOIN Production.ProductDescription pd 
ON pmpdc.ProductDescriptionID = pd.ProductDescriptionID;


/*20- Listar la cantidad de subcategorías que posean asignado los
productos. (Ayuda: distinct).*/
SELECT COUNT(DISTINCT ProductSubcategoryID) AS CantidadSubcategorias
FROM Production.Product;

