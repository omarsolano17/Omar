IF EXISTS(SELECT NAME FROM SYSOBJECTS WHERE NAME='FNK_DESCIFRAR' AND XTYPE='FN')
BEGIN
   DROP FUNCTION FNK_DESCIFRAR
END
GO
CREATE FUNCTION dbo.FNK_DESCIFRAR (@clave varchar(100)) 
RETURNS varchar(100) 
WITH ENCRYPTION
AS
BEGIN
	DECLARE @texto varchar(100)=''
	DECLARE @posicion int
	DECLARE @longitud int
	SET @posicion = 1
	SET @longitud = LEN(@clave)

	--IF DBO.FNK_VALORVARIABLE('ENCRIPTACION')='002'
	--BEGIN
		DECLARE @ClaveEncriptado VARCHAR(100)='ixcolombia'
		DECLARE @posicionEncriptada int=1
		WHILE @posicion <= @longitud
		BEGIN
			SELECT @texto = @texto + CHAR(ASCII(SUBSTRING(@clave, @posicion, 1))^ASCII(SUBSTRING(@ClaveEncriptado, @posicionEncriptada, 1)))
			SET @posicion = @posicion + 1
			SET @posicionEncriptada=CASE WHEN LEN(@ClaveEncriptado)<@posicionEncriptada+1 THEN 1 ELSE @posicionEncriptada+1 END
		END
	--END
	--ELSE
	--BEGIN
	--	WHILE @posicion <= @longitud
	--	BEGIN
	--		SELECT @texto = @texto + CHAR(ASCII(SUBSTRING(@clave, @posicion, 1)) + 31) 
	--		SET @posicion = @posicion + 1
	--	END
	--END
	RETURN @texto
END
