
create or alter function dbo.FN_LIMPIATEXTO(
   @text  varchar(max), 
   @regex varchar(100)
)
returns varchar(max)
as
begin
   declare 
       @replace   varchar(max), 
       @replaceTo varchar(max), 
       @fix       int 
   
   set @replace   = 'ñáéíóúàèìòùãõâêîôûäëïöüç'
   set @replaceTo = 'naeiouaeiouaoaeiooaeiouc'
   set @fix       = 1
   
   -- Si la expresión regular no son solo números entrará, sino evitará entrar ahorrando tiempo de proceso
   if replace(@regex,space(1),space(0))<>'0-9'
   begin
      -- Si no se asigno expresión regular, asignará una por defecto
      if isnull(@regex,space(0))=space(0)
         set @regex = 'a-z 0-9'

      -- Si la expresión regular tiene ñ se quita de los replace: @regex like '%ñ%'
      if lower(@regex) like '%ñ%'
      begin
         set @replace   = replace(@replace  ,'ñ',space(0))
         set @replaceTo = replace(@replaceTo,'n',space(0))
      end
      
      -- Se agregan minusculas y mayusculas a los replace
      set @replace   = lower(@replace  )+upper(@replace  )
      set @replaceTo = lower(@replaceTo)+upper(@replaceTo)
      
      -- Limpia acentuaciones y tildes desde los replace; COLLATE CS -> Case Sensitive
      while @fix <= len(@replace)
      begin
         set @text = replace(@text collate Modern_Spanish_CS_AS, substring(@replace,@fix,1), substring(@replaceTo,@fix,1))
         set @fix += 1
      end
   end  --Cierre para cuando contiene caracteres

   -- Se configura expresión regular
   set @regex = stuff('%[^]%',4,0,@regex)
   
   -- Se quitan todo lo que no este incluido en la expresión regular
   while patindex(@regex, @text) > 0
	begin
		set @text = replace(@text, substring(@text,patindex(@regex, @text),1), space(0))
	end

   -- Se quitan espacios dobles: @text like '%  %'
   while @text like '%'+space(2)+'%'
	begin
		set @text = replace(@text, space(2), space(1))
	end
   
   -- Se quitan espacios sobrantes a los lados
   set @text = ltrim(rtrim(@text))

	return @text
end