
GO
CREATE OR ALTER PROCEDURE DBO.SPQ_MENUQ_COL
@JSON  NVARCHAR(MAX)
WITH   ENCRYPTION
AS
DECLARE  @PARAMETROS NVARCHAR(MAX), @MODELO   VARCHAR(100), @METODO     VARCHAR(100)
DECLARE  @USUARIO    VARCHAR(20),   @MARCO    VARCHAR(100), @FILTRO     VARCHAR(250), 
         @GRUPO      VARCHAR(8)
BEGIN
   SELECT  @MODELO = MODELO , @METODO = METODO , @USUARIO = USUARIO
   FROM OPENJSON (@json)
	WITH (
	   MODELO         VARCHAR(100)     '$.MODELO',
	   METODO         VARCHAR(100)     '$.METODO',
      USUARIO        VARCHAR(12)      '$.USUARIO'
	)
   --SELECT @MODELO = MODELO , @METODO = METODO , @USUARIO = USUARIO
   --FROM #JSON

   SELECT @GRUPO = DBO.FNK_DESCIFRAR(GRUPO) FROM USUSU WHERE USUARIO = @USUARIO

   SET @MODELO = 'MENUQ'

   SELECT OK = 'OK', GRUPO = @GRUPO

   -- Menus agrupados
   SELECT USPROH.IDCONTROL, USPROH.DESCRIPCION [LABEL], COALESCE(SUBLABEL,USPROH.DESCRIPCION) [SUBLABEL], USPROH.RUTA, USPROH.ICONO, USPROH.CODIGO, USPROH.CODIGOPADRE
   FROM   USGRUH INNER JOIN USPROH ON USGRUH.IDPROCEDIMIENTO = USPROH.IDPROCEDIMIENTO
                                  AND USGRUH.IDCONTROL       = USPROH.IDCONTROL
   WHERE  USGRUH.IDPROCEDIMIENTO = @MODELO+'_'+@METODO
   AND    USPROH.WEB     = 1
   AND    USGRUH.GRUPO   = @GRUPO
   AND    COALESCE(USGRUH.PERMISO,0) = 1
   AND	  COALESCE(RUTA,'')=''
   AND	  COALESCE(CODIGOPADRE,0)<=0
   ORDER BY USPROH.ORDEN
   --GROUP BY USPROH.IDCONTROL,USPROH.DESCRIPCION,USPROH.RUTA,USPROH.ICONO,USPROH.CODIGO,USPROH.CODIGOPADRE

   -- Submenus
   SELECT USPROH.IDCONTROL, USPROH.DESCRIPCION [LABEL], COALESCE(SUBLABEL,USPROH.DESCRIPCION) [SUBLABEL], USPROH.RUTA, USPROH.ICONO, USPROH.CODIGO, USPROH.CODIGOPADRE, COALESCE(USPROH.SEPARADOR,0) SEPARADOR, ORDEN
   FROM   USGRUH INNER JOIN USPROH ON USGRUH.IDPROCEDIMIENTO = USPROH.IDPROCEDIMIENTO
                                  AND USGRUH.IDCONTROL       = USPROH.IDCONTROL
   WHERE  USGRUH.IDPROCEDIMIENTO = @MODELO+'_'+@METODO
   AND    USPROH.WEB     = 1
   AND    USGRUH.GRUPO   = @GRUPO
   AND    COALESCE(USGRUH.PERMISO, 0) = 1
   AND	  COALESCE(USPROH.CODIGOPADRE,0)>0
   ORDER BY USPROH.ORDEN

   -- Men� sin agrupamientos
   SELECT USGRUH.PERMISO,USPROH.IDCONTROL, USPROH.DESCRIPCION [LABEL], COALESCE(SUBLABEL,USPROH.DESCRIPCION) [SUBLABEL], USPROH.RUTA, USPROH.ICONO, USPROH.CODIGO, USPROH.CODIGOPADRE
   FROM   USGRUH INNER JOIN USPROH ON USGRUH.IDPROCEDIMIENTO = USPROH.IDPROCEDIMIENTO AND USGRUH.IDCONTROL=USPROH.IDCONTROL
   WHERE  USGRUH.IDPROCEDIMIENTO = @MODELO+'_'+@METODO
   AND    USPROH.WEB     = 1
   AND    USGRUH.GRUPO   = @GRUPO
   AND    COALESCE(USGRUH.PERMISO,0) = 1
   AND	  COALESCE(USPROH.CODIGOPADRE,0)<=0
   AND	  COALESCE(USPROH.RUTA,'')<>''
   ORDER BY COALESCE(USPROH.ORDEN,0)
END