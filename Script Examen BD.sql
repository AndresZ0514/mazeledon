--Crea dispositivo de almacenamiento
EXEC sp_addumpdevice 'disk', 'AdventureWorks2019_BDExamen',   
'C:\Bases de Datos\SQL\BACKUP\AdventureWorks2019_BDExamen.bak';  
GO

--Crear el backup full
BACKUP DATABASE AdventureWorks2019   
 TO DISK = 'C:\Bases de Datos\SQL\BACKUP\AdventureWorks2019_BDExamen.bak'  
   WITH NOFORMAT, NOINIT, NAME = N'AdventureWorks2019 – Full Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10;  
GO

--Crear el primer backup diferencial
BACKUP DATABASE AdventureWorks2019   
 TO DISK = 'C:\Bases de Datos\SQL\BACKUP\AdventureWorks2019_BDExamen.bak'
   WITH DIFFERENTIAL, NOFORMAT, NOINIT, NAME = N'AdventureWorks2019 – Differential Backup_1', SKIP, NOREWIND, NOUNLOAD,  STATS = 10 ;  
GO

--Crear el segundo backup diferencial
BACKUP DATABASE AdventureWorks2019   
 TO DISK = 'C:\Bases de Datos\SQL\BACKUP\AdventureWorks2019_BDExamen.bak'
   WITH DIFFERENTIAL, NOFORMAT, NOINIT, NAME = N'AdventureWorks2019 – Differential Backup_2', SKIP, NOREWIND, NOUNLOAD,  STATS = 10 ;  
GO

--Crear el tercero backup diferencial
BACKUP DATABASE AdventureWorks2019   
 TO DISK = 'C:\Bases de Datos\SQL\BACKUP\AdventureWorks2019_BDExamen.bak'
   WITH DIFFERENTIAL, NOFORMAT, NOINIT, NAME = N'AdventureWorks2019 – Differential Backup_3', SKIP, NOREWIND, NOUNLOAD,  STATS = 10 ;  
GO

--Crear el cuarto backup diferencial
BACKUP DATABASE AdventureWorks2019   
 TO DISK = 'C:\Bases de Datos\SQL\BACKUP\AdventureWorks2019_BDExamen.bak'
   WITH DIFFERENTIAL, NOFORMAT, NOINIT, NAME = N'AdventureWorks2019 – Differential Backup_4', SKIP, NOREWIND, NOUNLOAD,  STATS = 10 ;  
GO

RESTORE FILELISTONLY FROM DISK = 'C:\Bases de Datos\SQL\BACKUP\AdventureWorks2019_BDExamen.bak'
GO

RESTORE HEADERONLY FROM DISK = 'C:\Bases de Datos\SQL\BACKUP\AdventureWorks2019_BDExamen.bak'
GO

--Restaurar base de datos completa
RESTORE DATABASE [AwExamenBDII] 
FROM  DISK = N'C:\Bases de Datos\SQL\BACKUP\AdventureWorks2019_BDExamen.bak' 
WITH  FILE = 1,  
MOVE N'AdventureWorks2017' TO N'C:\Bases de Datos\SQL\DATA\AwExamenBDII_Data.mdf',
MOVE N'AdventureWorks2017_log' TO N'C:\Bases de Datos\SQL\LOG\AwExamenBDII_log.ldf', 
NORECOVERY,  NOUNLOAD,  STATS = 5

--Restaurar base de datos diferencial de una de los backups hechos antes
RESTORE DATABASE [AwExamenBDII] 
FROM DISK = N'C:\Bases de Datos\SQL\BACKUP\AdventureWorks2019_BDExamen.bak'
WITH  FILE = 2,  
MOVE N'AdventureWorks2017' TO N'C:\Bases de Datos\SQL\DATA\AwExamenBDII_Data.mdf',
MOVE N'AdventureWorks2017_log' TO N'C:\Bases de Datos\SQL\LOG\AwExamenBDII_log.ldf', 
NOUNLOAD,  STATS = 5

--Importar datos JSON
SELECT BulkColumn
 FROM OPENROWSET (BULK 'C:\Users\Lenovo\Documents\Universidad\Base de Datos II\Archivos JSON\dataMay-10-2021.json', SINGLE_CLOB) as j;

 SELECT value
 FROM OPENROWSET (BULK 'C:\Users\Lenovo\Documents\Universidad\Base de Datos II\Archivos JSON\dataMay-10-2021.json', SINGLE_CLOB) as j
 CROSS APPLY OPENJSON(BulkColumn)

 SELECT Person.*
 FROM OPENROWSET (BULK 'C:\Users\Lenovo\Documents\Universidad\Base de Datos II\Archivos JSON\dataMay-10-2021.json', SINGLE_CLOB) as j
 CROSS APPLY OPENJSON(BulkColumn)
 WITH( ContactTypeID int, Name nvarchar(50), ModifiedDate datetime) AS Person


 SELECT Person.* INTO Person.ContactType
 FROM OPENROWSET (BULK 'C:\Users\Lenovo\Documents\Universidad\Base de Datos II\Archivos JSON\dataMay-10-2021.json', SINGLE_CLOB) as j
 CROSS APPLY OPENJSON(BulkColumn)
 WITH( ContactTypeID int, Name nvarchar(50), ModifiedDate datetime) AS Person

 use AwExamenBDII