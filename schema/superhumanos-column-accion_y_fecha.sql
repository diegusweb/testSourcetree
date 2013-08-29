/* 	superhumanos-column-accion_y_fecha.sql
	script de instalación de columnas fehca y acción
	fecha: 16/05/2012
*/ 
ALTER TABLE dbo.thc_superhumanos_afichesUsuarios ADD
	accion varchar(30) NULL,
	fecha timestamp NULL DEFAULT getDate()
GO