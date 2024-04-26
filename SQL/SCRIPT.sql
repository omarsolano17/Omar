--SCRIPT COMPLEMENTADOR DE PROYECTO SOLANO

----Region permisos
IF NOT EXISTS(SELECT 1 FROM USPRO WHERE IDPROCEDIMIENTO='MENUQ_CENTRAL')
BEGIN
  INSERT INTO USPRO (IDPROCEDIMIENTO,DESCPROCEDIMIENTO,WEB)
  SELECT 'MENUQ_CENTRAL','Menu central o Menu principal',1
END

IF NOT EXISTS(SELECT 1 FROM USPROH WHERE IDPROCEDIMIENTO='MENUQ_CENTRAL' AND IDCONTROL='utilidad')
BEGIN
  INSERT INTO USPROH (IDPROCEDIMIENTO,IDCONTROL,TIPO,DESCRIPCION,WEB,RUTA,ICONO,CODIGOPADRE,AUTOMATICO,SEPARADOR,ORDEN,SUBLABEL,CODIGO)
  SELECT 'MENUQ_CENTRAL','utilidad','M', 'Utilidad',1,'util',NULL,NULL,1,0,1,'Utilidades varias', 20
END

IF NOT EXISTS(SELECT 1 FROM USPRO WHERE IDPROCEDIMIENTO='MENUQ_UTILIDADES')
BEGIN
  INSERT INTO USPRO (IDPROCEDIMIENTO,DESCPROCEDIMIENTO,WEB)
  SELECT 'MENUQ_UTILIDADES','Menu central UTILIDADES',1
END

IF NOT EXISTS(SELECT 1 FROM USPROH WHERE IDPROCEDIMIENTO='MENUQ_UTILIDADES' AND IDCONTROL='notificacion')
BEGIN
  INSERT INTO USPROH (IDPROCEDIMIENTO,IDCONTROL,TIPO,DESCRIPCION,WEB,RUTA,ICONO,CODIGOPADRE,AUTOMATICO,SEPARADOR,ORDEN,SUBLABEL,CODIGO)
  SELECT 'MENUQ_UTILIDADES','notificacion','M', 'Notificaciones',1,'util.notificaciones',NULL,NULL,1,0,1,'Notificaciones Varias', 30
END


IF NOT EXISTS(SELECT 1 FROM USPROH WHERE IDPROCEDIMIENTO='MENUQ_UTILIDADES' AND IDCONTROL='memoria')
BEGIN
  INSERT INTO USPROH (IDPROCEDIMIENTO,IDCONTROL,TIPO,DESCRIPCION,WEB,RUTA,ICONO,CODIGOPADRE,AUTOMATICO,SEPARADOR,ORDEN,SUBLABEL,CODIGO)
  SELECT 'MENUQ_UTILIDADES','memoria','M', 'Memoria',1,'util.memoria',NULL,NULL,1,0,2,'Memoria o registro de eventos', 40
END

IF NOT EXISTS(SELECT 1 FROM USPROH WHERE IDPROCEDIMIENTO='MENUQ_UTILIDADES' AND IDCONTROL='turnero')
BEGIN
  INSERT INTO USPROH (IDPROCEDIMIENTO,IDCONTROL,TIPO,DESCRIPCION,WEB,RUTA,ICONO,CODIGOPADRE,AUTOMATICO,SEPARADOR,ORDEN,SUBLABEL,CODIGO)
  SELECT 'MENUQ_UTILIDADES','turnero','M', 'Turnero',1,'util.turnero',NULL,NULL,1,0,3,'Registro de llamados a pacientes', 50
END

----region tablas
--NOTI
IF NOT EXISTS (SELECT * FROM sys.sysobjects WHERE NAME='NOTI' AND type='U')
BEGIN
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
END

--MEMO
IF NOT EXISTS (SELECT * FROM sys.sysobjects WHERE NAME='MEMO' AND type='U')
BEGIN
    CREATE TABLE MEMO
      (ID INT IDENTITY (1,1), FECHA_REGISTRO DATETIME DEFAULT GETDATE(), USUARIO_REGISTRO VARCHAR (20)
      ,FECHA_EVENTO DATETIME
      ,EVENTO VARCHAR(1024)
      ,PERSONA VARCHAR (1024)
      )
END
--TURNERO
IF NOT EXISTS (SELECT * FROM sys.sysobjects WHERE NAME='TURNERO' AND type='U')
BEGIN
    CREATE TABLE TURNERO
      (ID INT IDENTITY (1,1), FECHA_REGISTRO DATETIME DEFAULT GETDATE(), USUARIO_REGISTRO VARCHAR (20)
      ,CONSECUTIVOCIT VARCHAR (20)
      ,IDMEDICO VARCHAR(20)
      ,FECHA_CITA DATETIME
      ,FECHA_LLEGA DATETIME
      ,FECHA_LLAMA DATETIME
      ,ESTADO DATETIME
      )
END


IF NOT EXISTS (SELECT * FROM SYS.sysobjects WHERE type='U' AND NAME='SED')
BEGIN
	CREATE TABLE [dbo].[SED](
		[IDSEDE] [varchar](5) NOT NULL,
		[DESCRIPCION] [varchar](250) NULL,
		[DIRECCION] [varchar](60) NULL,
		[TELEFONOS] [varchar](35) NULL,
		[CIUDAD] [varchar](5) NULL,
	 CONSTRAINT [SEDIDSEDE] PRIMARY KEY CLUSTERED
	(
		[IDSEDE] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
END


IF NOT EXISTS(SELECT 1 FROM sys.sysobjects WHERE type='U' AND name='UBEQ')
BEGIN
	CREATE TABLE [dbo].[UBEQ](
		[COMPANIA] [varchar](2) NULL,
		[ComputerName] [varchar](254) NOT NULL,
		[Descripcion] [varchar](254) NOT NULL,
		[IDAREA] [varchar](20) NULL,
		[CCOSTO] [varchar](20) NULL,
		[SUBCCOSTO] [varchar](4) NULL,
		[ESCAJA] [smallint] NULL,
		[CAJA] [varchar](4) NULL,
		[TIPOMANEJOBODEGA] [varchar](20) NULL,
		[MBODEGA] [smallint] NULL,
		[IDBODEGA] [varchar](20) NULL,
		[IDBODEGA2] [varchar](20) NULL,
		[IDBODEGANOCHE] [varchar](20) NULL,
		[IDSEDE] [varchar](5) NULL,
		[TIPOIMPRESORA] [varchar](10) NULL,
		[IDAREAH] [varchar](20) NULL,
		[MCAJAPREFIJO] [smallint] NULL,
		[CAJAENVIO] [varchar](4) NULL,
		[IDBODEGACONSUMO] [varchar](20) NULL,
		[CODUNG] [varchar](5) NULL,
		[MCAJAENVIO] [smallint] NULL,
		[ESCAJAMENOR] [smallint] NULL,
		[CODCAJAMENOR] [varchar](4) NULL,
		[F_VERSION] [date] NULL,
	 CONSTRAINT [UBEQCOMPUTERNAME] PRIMARY KEY CLUSTERED
	(
		[ComputerName] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
	) ON [PRIMARY]
END

--APIS
IF NOT EXISTS (SELECT 1 FROM sys.sysobjects WHERE NAME='APIS' AND type='U')
BEGIN
    CREATE TABLE APIS
      (ID INT IDENTITY (1,1)
	  ,FECHA_REGISTRO DATETIME DEFAULT GETDATE()
	  ,USUARIO_REGISTRO VARCHAR (20)
	  ,IDSEDE VARCHAR (5)
      ,[ENDPOINT] VARCHAR(100)
      ,NUMERO VARCHAR(15)
      ,DESCRIPCION VARCHAR (100)
      ,ACTIVO BIT
      )
END
--Aumento tamaño 
IF (SELECT COL_LENGTH('SMSL','VARIABLE_API'))<1024
BEGIN
	ALTER TABLE SMSL ALTER COLUMN VARIABLE_API  VARCHAR(1024)
END


