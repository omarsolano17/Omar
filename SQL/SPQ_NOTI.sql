--SELECT * FROM NOTI
GO
CREATE OR ALTER PROCEDURE DBO.SPQ_NOTI
@JSON  NVARCHAR(MAX)
WITH   ENCRYPTION
AS
DECLARE  @PARAMETROS NVARCHAR(MAX), @MODELO   VARCHAR(100), @METODO     VARCHAR(100)
DECLARE  @USUARIO    VARCHAR(20),   @MARCO    VARCHAR(100), @FILTRO     VARCHAR(250) 
         ,@GRUPO     VARCHAR(8),    @NOTIFICACION VARCHAR(1024), @FECHA_NOTIFICACION VARCHAR(20)
         ,@SMS       BIT         ,  @WHATSAPP   BIT,      @CORREO    BIT
         ,@NUMERO    VARCHAR (20),  @EMAIL      VARCHAR (50)
         ,@API_WHATSAPP1 VARCHAR(256), @AVISARDESDE SMALLINT
         ,@TIPOAVISO VARCHAR(20),  @HORA_NOTIFICACION VARCHAR(20),  @FECHA_NOTI DATETIME
BEGIN
    SELECT  @MODELO = MODELO , @METODO = METODO , @USUARIO = USUARIO, @PARAMETROS = PARAMETROS
    FROM OPENJSON (@json)
    WITH (
        MODELO         VARCHAR(100)     '$.MODELO',
        METODO         VARCHAR(100)     '$.METODO',
        USUARIO        VARCHAR(12)      '$.USUARIO',
		    PARAMETROS     NVARCHAR(MAX)  AS JSON
    )
    --SELECT @MODELO = MODELO , @METODO = METODO , @USUARIO = USUARIO
    --FROM #JSON

    SELECT @GRUPO = DBO.FNK_DESCIFRAR(GRUPO) FROM USUSU WHERE USUARIO = @USUARIO

    IF @METODO='CRUDNOTI'
    BEGIN
        SELECT  @METODO = PROCESO , @FECHA_NOTIFICACION = FECHA_NOTIFICACION , @NOTIFICACION = NOTIFICACION
                ,@SMS      = COALESCE(SMS     ,0),@WHATSAPP = COALESCE(WHATSAPP,0),@CORREO   = COALESCE(CORREO  ,0)
                ,@NUMERO  = COALESCE(NUMERO,''),@EMAIL    = COALESCE(EMAIL  ,''), @API_WHATSAPP1 = API_WHATSAPP
                ,@AVISARDESDE = AVISARDESDE ,@TIPOAVISO = TIPOAVISO, @HORA_NOTIFICACION = HORA_NOTIFICACION
        FROM OPENJSON (@PARAMETROS)
        WITH (
                PROCESO               VARCHAR(20)     '$.PROCESO',
                FECHA_NOTIFICACION    VARCHAR(20)     '$.FECHA_NOTIFICA',
                HORA_NOTIFICACION     VARCHAR(20)     '$.HORA_NOTIFICA',
                NOTIFICACION          VARCHAR(1024)   '$.NOTIFICACION',
                SMS                   BIT             '$.SMS',
                WHATSAPP              BIT             '$.WHATSAPP',
                CORREO                BIT             '$.CORREO',
                NUMERO                VARCHAR(20)     '$.CELULAR',
                EMAIL                 VARCHAR(50)     '$.EMAIL',
                API_WHATSAPP          VARCHAR(256)    '$.API_WHATSAPP',
                AVISARDESDE           SMALLINT        '$.AVISARDESDE',
                TIPOAVISO             VARCHAR(20)     '$.TIPOAVISO'
            )
        IF COALESCE(@FECHA_NOTIFICACION,'')=''
        BEGIN
          SELECT @FECHA_NOTI=GETDATE()
        END
        ELSE
        BEGIN
          SELECT @FECHA_NOTI=CONVERT(DATETIME, REPLACE(@FECHA_NOTIFICACION,'-','')+' '+COALESCE(@HORA_NOTIFICACION,'') )
        END
        IF @METODO = 'Insertar'
        BEGIN
            PRINT '@FECHA_NOTIFICACION='+CONVERT(VARCHAR, @FECHA_NOTI, 120)

            INSERT INTO NOTI (FECHA_REGISTRO, USUARIO_REGISTRO, FECHA_NOTIFICA, NOTIFICACION, SMS, WHATSAPP, CORREO, NUMERO, EMAIL, API_WHATSAPP, AVISARDESDE, TIPOAVISO)
            SELECT GETDATE(), @USUARIO, @FECHA_NOTI , @NOTIFICACION, @SMS, @WHATSAPP, @CORREO, @NUMERO, @EMAIL, @API_WHATSAPP1, @AVISARDESDE, @TIPOAVISO
            
            IF @@ERROR = 0
            BEGIN
                SELECT 'OK' OK
                IF @SMS=1
                BEGIN
                    EXEC SP_SENDSMS @NUMERO, @NOTIFICACION, 'GET'
                END

                IF @WHATSAPP=1
                BEGIN
                  EXEC DBO.SP_SEND_WHATSAPP @NUMERO = @NUMERO, @MENSAJE = @NOTIFICACION, @API_WHATSAPP = @API_WHATSAPP1
                END
            END
        END
    END



END
