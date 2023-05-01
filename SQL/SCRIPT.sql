--SCRIPT COMPLEMENTADOR DE PROYECTO SOLANO
--SELECT * FROM USPRO
--SELECT * FROM USPROH
----Region permisos
INSERT INTO USPROH (IDPROCEDIMIENTO,IDCONTROL,TIPO,DESCRIPCION,WEB,RUTA,ICONO,CODIGOPADRE,AUTOMATICO,SEPARADOR,ORDEN,SUBLABEL,CODIGO)
SELECT 'MENUQ_CENTRAL','utilidad','M', 'Utilidad',1,'util',NULL,NULL,1,0,1,'Utilidades varias', 20


INSERT INTO USPRO (IDPROCEDIMIENTO,DESCPROCEDIMIENTO,WEB)
SELECT 'MENUQ_UTILIDADES','Menu central UTILIDADES',1
INSERT INTO USPROH (IDPROCEDIMIENTO,IDCONTROL,TIPO,DESCRIPCION,WEB,RUTA,ICONO,CODIGOPADRE,AUTOMATICO,SEPARADOR,ORDEN,SUBLABEL,CODIGO)
SELECT 'MENUQ_UTILIDADES','notificacion','M', 'Notificaciones',1,'util.notificaciones',NULL,NULL,1,0,1,'Notificaciones Varias', 30



----region tablas
--NOTI
--IF NOT EXISTS (SELECT 1 FROM UTIL)
DROP TABLE NOTI
CREATE TABLE NOTI
  (ID INT IDENTITY (1,1), FECHA_REGISTRO DATETIME DEFAULT GETDATE(), USUARIO_REGISTRO VARCHAR (20)
  ,FECHA_NOTIFICA DATETIME, NOTIFICACION VARCHAR(1024)
  ,SMS BIT, WHATSAPP BIT, CORREO BIT, NUMERO VARCHAR(20)
  ,EMAIL VARCHAR(50)
  ,FECHA_ENVIA DATETIME
  ,ESTADO SMALLINT DEFAULT 0
  ,AVISARDESDE SMALLINT
  ,TIPOAVISO VARCHAR(20)
  ,FRECUENCIA SMALLINT
  ,TIPOFRECUENCIA VARCHAR(20)
  ,API_WHATSAPP VARCHAR(256)
  )

  --UPDATE USUSU SET CELULAR='3205825363', EMAIL='omaryesidsolano@outlook.com'


