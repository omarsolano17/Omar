--SELECT * FROM NOTI
GO
CREATE OR ALTER PROCEDURE DBO.SPQ_MEMO
@JSON  NVARCHAR(MAX)
WITH   ENCRYPTION
AS
DECLARE  @PARAMETROS NVARCHAR(MAX), @MODELO   VARCHAR(100), @METODO     VARCHAR(100)
DECLARE  @USUARIO    VARCHAR(20),   @MARCO    VARCHAR(100), @FILTRO     VARCHAR(250) 
         ,@GRUPO     VARCHAR(8),    @EVENTO   VARCHAR(1024), @FECHA_EVENTO VARCHAR(20)
         ,@ID        INT,           @PERSONA  VARCHAR(256)
         
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

    IF @METODO='CRUDMEMO'
    BEGIN
        SELECT  @METODO = PROCESO , @FECHA_EVENTO = CONVERT(date,FECHA_EVENTO) , @EVENTO = EVENTO, @PERSONA = PERSONA, @ID = ID
        FROM OPENJSON (@PARAMETROS)
        WITH (
                ID              VARCHAR(20)     '$.ID',
                PROCESO         VARCHAR(20)     '$.PROCESO',
                FECHA_EVENTO    VARCHAR(20)     '$.FECHA_EVENTO',
                PERSONA         VARCHAR(20)     '$.PERSONA',
                EVENTO          VARCHAR(1024)   '$.EVENTO'
            )

        PRINT '@PROCESO     ='+COALESCE(@METODO     ,'')
        PRINT '@FECHA_EVENTO='+COALESCE(CONVERT(VARCHAR, @FECHA_EVENTO,103),'')
        PRINT '@PERSONA     ='+COALESCE(@PERSONA     ,'')
        PRINT '@EVENTO      ='+COALESCE(@EVENTO      ,'')
        --return
        IF @METODO = 'Insertar'
        BEGIN
            INSERT INTO MEMO (USUARIO_REGISTRO, FECHA_EVENTO, EVENTO, PERSONA)
            SELECT @USUARIO, REPLACE(@FECHA_EVENTO,'-',''), @EVENTO, @PERSONA
            IF @@ERROR<>0
            BEGIN
                SELECT 'KO' OK
                SELECT 'ERROR AL INSERTAR MEMORIA='
                RETURN
            END          
            SELECT 'OK' OK
            RETURN
            
        END
        IF @METODO = 'Editar'
        BEGIN
            UPDATE MEMO SET FECHA_EVENTO = @FECHA_EVENTO, EVENTO = @EVENTO, PERSONA = @PERSONA WHERE ID = @ID
            IF @@ERROR<>0
            BEGIN
                SELECT 'KO' OK
                SELECT 'ERROR AL ACTUALIZAR MEMORIA='
                RETURN
            END          
            SELECT 'OK' OK
            RETURN

        END
    END



END
