
CREATE OR ALTER PROCEDURE DBO.SP_SEND_WHATSAPP
(
	@NUMERO VARCHAR(13),
	@MENSAJE VARCHAR(max),
	@ENDPOINT VARCHAR(100) = 'sendMessage', -- sendFile, sendPTT, sendLink, sendContact, sendLocation, sendVCard, forwardMessage, 
	@NOMBREARCHIVO VARCHAR(100) = 'Archivo.pdf', 
	@LINK VARCHAR(1000) = NULL,
   @PROCEDENCIA VARCHAR(100) = NULL
)
WITH ENCRYPTION
AS
DECLARE @VARIABLE VARCHAR(20)
DECLARE @sUrl VARCHAR(3096) 
DECLARE @obj INT
DECLARE @valorDeRegreso INT
DECLARE @response VARCHAR(max)
DECLARE @src VARCHAR(255)
DECLARE @desc VARCHAR(255)
DECLARE @Body VARCHAR(max) 
BEGIN
   -------------
	IF DBO.FNK_VALORVARIABLE('WHATSAPP_HABILITADO')<>'SI' 
	BEGIN
		PRINT 'Envíos por WhatsApp deshabilitado (USVGS => WHATSAPP_HABILITADO)'
		SELECT 'KO' OK, ERROR='Envíos por WhatsApp deshabilitado (USVGS => WHATSAPP_HABILITADO)'
		RETURN
	END
  
	IF (SELECT COUNT(*) FROM TGEN WHERE TABLA='General' AND CAMPO='EXCLUYE_CELULAR' AND CODIGO=@NUMERO)>0 
	BEGIN
		PRINT 'NUMERO EXCLUIDO'
		RETURN
	END
	SELECT @sUrl = OBSERVACION FROM USVGS WHERE IDVARIABLE = 'URL_API_WHATSAPP'

	IF ISNULL(@sUrl,'')=''
	BEGIN
		  RAISERROR('VARIABLE DE SISTEMA (URL_API_WHATSAPP) NO CONFIGURADA',16,1) 
		  RETURN
	END
	
	IF ISNULL(@MENSAJE,'')=''
	BEGIN
      PRINT 'MENSAJE VACIO'
		  RETURN
	END
		
	IF LEN(@NUMERO)<=8
	BEGIN
		PRINT 'LONGITUD DEL NUMERO <= 8'
		RETURN
	END

  IF 1=2
  BEGIN
	  SELECT @sUrl = REPLACE(@sUrl,'ENDPOINT',COALESCE(@ENDPOINT,'sendMessage'))
	  EXEC sys.sp_OACreate 'MSXML2.ServerXMLHttp', @obj OUT
	  IF DBO.FNK_VALORVARIABLE('IXCOUNTRY') = 'PERU'
	  BEGIN
		  SET @Body ='{"body": "'+@MENSAJE+'","phone": '+RIGHT('51'+@NUMERO,11)+'}' 
		  IF @ENDPOINT = 'sendFile' SET @Body ='{"body": "'+@MENSAJE+'", "phone": '+RIGHT('51'+@NUMERO,11)+', "filename": "'+@NOMBREARCHIVO+'"}' 
	  END
	  ELSE
	  BEGIN
		  SET @Body ='{"body": "'+@MENSAJE+'","phone": '+RIGHT('57'+@NUMERO,12)+'}' 
		  IF @ENDPOINT = 'sendFile' SET @Body ='{"body": "'+@MENSAJE+'", "phone": '+RIGHT('51'+@NUMERO,12)+', "filename": "'+@NOMBREARCHIVO+'"}' 
	  END
	  EXEC sys.sp_OAMethod @obj, 'Open', NULL, 'POST', @sUrl, false
	  EXEC sys.sp_OAMethod @Obj, 'setRequestHeader', null, 'Content-Type', 'application/json'
	  EXEC SYS.sp_OAMethod @obj, 'send', null, @Body
	  EXEC sys.sp_OAMethod @obj, 'responseText', @response OUTPUT

	  IF @response IS NULL
	  BEGIN
		  DECLARE @TABLA_TMP1 AS TABLE (ITEM INT IDENTITY(1,1), RESPONSE VARCHAR(MAX))
		  INSERT INTO @TABLA_TMP1(RESPONSE)
		  EXEC sys.sp_OAGetProperty @obj, 'responseText'
		  SELECT @response=RESPONSE FROM @TABLA_TMP1
	  END

	  EXEC sys.sp_OADestroy @obj

     IF DBO.FNK_VALORVARIABLE('IXCOUNTRY') = 'PERU'
     BEGIN
        INSERT INTO SMSL(VIA,CONTACTO,MENSAJE,METHOD,RESPONSE,VARIABLE_API)
	     SELECT 'WHATSAPP',@NUMERO,@MENSAJE,'POST', @response [response],@VARIABLE
     END
  END
  ELSE
  BEGIN
    SELECT @sUrl = REPLACE(@sUrl,'ENDPOINT',COALESCE(@ENDPOINT,'sendMessage'))
	  EXEC sys.sp_OACreate 'MSXML2.ServerXMLHttp', @obj OUT
		SET @Body ='{"message":"'+@MENSAJE+'", "phone":"'+RIGHT('57'+@NUMERO,12)+'"}' 
	  EXEC sys.sp_OAMethod @obj, 'Open', NULL, 'POST', @sUrl, false
	  EXEC sys.sp_OAMethod @Obj, 'setRequestHeader', null, 'Content-Type', 'application/json'
	  EXEC SYS.sp_OAMethod @obj, 'send', null, @Body
	  EXEC sys.sp_OAMethod @obj, 'responseText', @response OUTPUT

	  IF @response IS NULL
	  BEGIN
		  DECLARE @TABLA_TMP AS TABLE (ITEM INT IDENTITY(1,1), RESPONSE VARCHAR(MAX))
		  INSERT INTO @TABLA_TMP(RESPONSE)
		  EXEC sys.sp_OAGetProperty @obj, 'responseText'
		  SELECT @response=RESPONSE FROM @TABLA_TMP
	  END

    EXEC sys.sp_OADestroy @obj
    BEGIN
      INSERT INTO SMSL(VIA,CONTACTO,MENSAJE,METHOD,RESPONSE,VARIABLE_API)
      SELECT 'WHATSAPP',@NUMERO,@MENSAJE,'POST', @response [response],@VARIABLE
    END
  END
END


