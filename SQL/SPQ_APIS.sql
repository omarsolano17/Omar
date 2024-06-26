CREATE OR ALTER PROCEDURE DBO.SPQ_APIS
	@JSON  NVARCHAR(MAX)
WITH
ENCRYPTION
AS
DECLARE @PARAMETROS NVARCHAR(MAX) ,@MODELO           VARCHAR(100)    ,@METODO        VARCHAR(100) ,@USUARIO   VARCHAR(12)
		,@GRUPO      VARCHAR(8)    ,@SYS_COMPUTERNAME VARCHAR(254)    ,@SEDE          VARCHAR(5)	  ,@A         INT
		,@IDAFILIADO VARCHAR(20)	 ,@TIPO_DOC         VARCHAR(3)      ,@DOCIDAFILIADO VARCHAR(20)  ,@ESTADO    VARCHAR(12)
		,@WHERES     VARCHAR(2000) ,@QUERY            VARCHAR(8000)
BEGIN
	SET LANGUAGE Spanish; 
	SELECT @A = ISJSON(@JSON)
	IF @A = 0 
	BEGIN
		RAISERROR('Json: Formato Erroneo',16,1)
		RETURN
	END
	--PRINT 'INGRESE A '
	SELECT *
	INTO #JSON
	FROM OPENJSON (@json)
	WITH (
		MODELO         VARCHAR(100)     '$.MODELO',
		METODO         VARCHAR(100)     '$.METODO',
		USUARIO        VARCHAR(12)      '$.USUARIO',
		PARAMETROS     NVARCHAR(MAX)     AS JSON
	)

	SELECT @MODELO = MODELO , @METODO = METODO , @PARAMETROS = PARAMETROS , @USUARIO = USUARIO
	FROM #JSON
	--DEFINICION DE TABLA DE ERRORES
	DECLARE @TBLERRORES TABLE(ERROR VARCHAR(200));
	-- TOMA DEL GRUPO, SYS_COMPUTERNAME, SEDE   DE ACUERDO AL USUARIO
	PRINT 'USUARIO:'+@USUARIO
	SELECT @GRUPO = DBO.FNK_DESCIFRAR(GRUPO) FROM USUSU WHERE USUARIO = @USUARIO
	SELECT @SYS_COMPUTERNAME = SYS_COMPUTERNAME FROM USUSU WHERE USUARIO = @USUARIO
	IF @METODO = 'INSERTAR' OR @METODO='EDITAR'
	BEGIN
		IF @USUARIO<>'OSOLANO' AND @METODO='INSERTAR'
		BEGIN
			SELECT 'KO' OK
			SELECT ERROR = 'Usuario no tiene permiso para insertar el ENDPOINT'
			RETURN
		END
		SELECT *
		INTO #APIS
		FROM OPENJSON (@PARAMETROS)
		WITH (
		   ID INT		 '$.ID'
		  ,IDSEDE VARCHAR (5)		 '$.IDSEDE'
		  ,[ENDPOINT] VARCHAR(100)	 '$.ENDPOINT'
		  ,NUMERO VARCHAR(15)		 '$.NUMERO'
		  ,DESCRIPCION VARCHAR (100) '$.DESCRIPCION'
		  ,ACTIVO BIT				 '$.ACTIVO'
		)

		BEGIN TRY
			IF @METODO ='INSERTAR'
			BEGIN
				INSERT INTO APIS (USUARIO_REGISTRO, IDSEDE, [ENDPOINT], NUMERO, DESCRIPCION, ACTIVO)
				SELECT @USUARIO, A.IDSEDE, A.[ENDPOINT], A.NUMERO, A.DESCRIPCION, A.ACTIVO
				FROM #APIS A
			END
			ELSE IF @METODO ='EDITAR'
			BEGIN
				UPDATE APIS SET IDSEDE=A.IDSEDE, [ENDPOINT]=A.[ENDPOINT], NUMERO=A.NUMERO, DESCRIPCION = A.DESCRIPCION, ACTIVO=A.ACTIVO
				FROM APIS INNER JOIN #APIS A ON A.ID=APIS.ID
			END
		END TRY
		BEGIN CATCH
			SELECT 'KO' OK
			SELECT ERROR = 'Error al procesar la edicion o insercion del ENDPOINT, error:'+ERROR_MESSAGE()
			RETURN
		END CATCH
		SELECT 'OK' OK
    SELECT ID, APIS.IDSEDE, SED.DESCRIPCION DESCRIPCION_SEDE, [ENDPOINT], NUMERO, APIS.DESCRIPCION, CAST(ACTIVO AS bit) ACTIVO
    FROM APIS LEFT JOIN SED ON SED.IDSEDE = APIS.IDSEDE
		RETURN
	END
  IF @METODO='CONSULTAR'
  BEGIN    
		SELECT 'OK' OK
    SELECT ID, APIS.IDSEDE, SED.DESCRIPCION DESCRIPCION_SEDE, [ENDPOINT], NUMERO, APIS.DESCRIPCION, CAST(ACTIVO AS bit) ACTIVO
    FROM APIS LEFT JOIN SED ON SED.IDSEDE = APIS.IDSEDE
  END
END
SELECT TOP 10 * FROM API_LOG ORDER BY 1 DESC
SELECT TOP 10 * FROM SMSL ORDER BY 1 DESC
update apis set [ENDPOINT]='http://190.145.19.14:3010/lead' WHERE ID=4
