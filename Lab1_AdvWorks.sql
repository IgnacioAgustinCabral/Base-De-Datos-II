/*1- Listar los códigos y descripciones de todos los productos
(Ayuda: Production.Product)*/
SELECT p.ProductID,
       pd.Description
FROM Production.Product p
INNER JOIN Production.ProductDescription pd ON p.ProductID = pd.ProductDescriptionID;


/*2- Listar los datos de la subcategoría número 17 (Ayuda:
Production.ProductSubCategory)*/
SELECT *
FROM Production.ProductSubcategory ps
INNER JOIN Production.Product p ON p.ProductSubcategoryID = ps.ProductSubcategoryID
WHERE ps.ProductSubcategoryID = 17;


/*3-Listar los productos cuya descripción comience con D (Ayuda:
like ‘D%’)*/
SELECT pd.Description
FROM Production.Product p
INNER JOIN Production.ProductDescription pd ON p.ProductID = pd.ProductDescriptionID
WHERE pd.Description LIKE 'D%';


/*4- Listar las descripciones de los productos cuyo número finalice
con 8 (Ayuda: ProductNumber like ‘%8’)*/
SELECT p.ProductNumber,
       pd.Description
FROM Production.Product p
INNER JOIN Production.ProductDescription pd ON p.ProductID = pd.ProductDescriptionID
WHERE p.ProductNumber LIKE '%8';


/*5- Listar aquellos productos que posean un color asignado. Se
deberán excluir todos aquellos que no posean ningún valor
(Ayuda: is not null)*/
SELECT *
FROM Production.Product p
WHERE p.Color IS NOT NULL;


/*6- Listar el código y descripción de los productos de color Black
(Negro) y que posean el nivel de stock en 500. (Ayuda:
SafetyStockLevel = 500)*/
SELECT p.ProductID,
       pd.Description
FROM Production.Product p
INNER JOIN Production.ProductDescription pd ON p.ProductID = pd.ProductDescriptionID
WHERE p.Color = 'Black'
  AND p.SafetyStockLevel = 500;


/*7- Listar los productos que sean de color Black (Negro) ó Silver
(Plateado).*/
SELECT *
FROM Production.Product p
WHERE p.Color = 'Black'
  OR p.Color = 'Silver';


/*8- Listar los diferentes colores que posean asignados los
productos. Sólo se deben listar los colores. (Ayuda: distinct)*/
SELECT DISTINCT(p.Color)
FROM Production.Product p
WHERE p.Color IS NOT NULL;