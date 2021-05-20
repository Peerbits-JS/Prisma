/* ACT BD EMPRESA VERSAO 52*/
EXEC('IF NOT EXISTS(SELECT * FROM [tbSistemaTiposDocumentoOrigem] WHERE ID=2)
BEGIN
	INSERT [dbo].[tbSistemaTiposDocumentoOrigem] ([ID], [Codigo], [Descricao], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao]) VALUES (2, N''002'', N''OutroSistema'', 0, 1, CAST(N''2016-05-25 00:00:00.000'' AS DateTime), N''F3M'', CAST(N''2016-05-25 09:31:44.997'' AS DateTime), NULL)
END')

EXEC('IF EXISTS (SELECT * FROM  sys.objects WHERE  object_id = OBJECT_ID(N''[dbo].[NExtenso_Extenso]'') AND type IN ( N''FN'')) DROP FUNCTION [dbo].[NExtenso_Extenso]')

EXEC('CREATE FUNCTION [dbo].[NExtenso_Extenso](@Num INTEGER)
	RETURNS VARCHAR(50)
AS
BEGIN 
	RETURN CASE @Num 
		WHEN 1000 THEN ''Mil'' WHEN 1000000 THEN ''Milhões'' WHEN 1000000000 THEN ''Bilhões''
		WHEN 100 THEN ''Cento'' WHEN 200 THEN ''Duzentos'' WHEN 300 THEN ''Trezentos'' WHEN 400 THEN ''Quatrocentos'' WHEN 500 THEN ''Quinhentos'' WHEN 600 THEN ''Seiscentos'' WHEN 700 THEN ''Setecentos'' WHEN 800 THEN ''Oitocentos'' WHEN 900 THEN ''Novecentos''
		WHEN 10 THEN ''Dez'' WHEN 11 THEN ''Onze'' WHEN 12 THEN ''Doze'' WHEN 13 THEN ''Treze'' WHEN 14 THEN ''Quartorze'' WHEN 15 THEN ''Quinze'' WHEN 16 THEN ''Dezesseis'' WHEN 17 THEN ''Dezesete'' WHEN 18 THEN ''Dezoito'' WHEN 19 THEN ''Dezenove''
		WHEN 20 THEN ''Vinte'' WHEN 30 THEN ''Trinta'' WHEN 40 THEN ''Quarenta'' WHEN 50 THEN ''Cinquenta'' WHEN 60 THEN ''Sessenta'' WHEN 70 THEN ''Setenta'' WHEN 80 THEN ''Oitenta'' WHEN 90 THEN ''Noventa'' 
		WHEN 1 THEN ''Um'' WHEN 2 THEN ''Dois'' WHEN 3 THEN ''Tres'' WHEN 4 THEN ''Quatro'' WHEN 5 THEN ''Cinco'' WHEN 6 THEN ''Seis'' WHEN 7 THEN ''Sete'' WHEN 8 THEN ''Oito'' WHEN 9 THEN ''Nove'' 
		ELSE NULL END
END')
 
EXEC('IF EXISTS (SELECT * FROM  sys.objects WHERE  object_id = OBJECT_ID(N''[dbo].[NExtenso_Fator]'') AND type IN ( N''FN'')) DROP FUNCTION [dbo].[NExtenso_Fator]')

EXEC('CREATE FUNCTION [dbo].[NExtenso_Fator](@Num INTEGER)
	RETURNS INTEGER
AS
BEGIN 
	IF @Num < 10 RETURN 1
	ELSE IF @Num < 100 RETURN 10
	ELSE IF @Num < 1000 RETURN 100
	ELSE IF @Num < 1000000 RETURN 1000
	ELSE IF @Num < 1000000000 RETURN 1000000
	ELSE IF @Num < 1000000000000 RETURN 1000000000
	RETURN NULL
END')
 
EXEC('IF EXISTS (SELECT * FROM  sys.objects WHERE  object_id = OBJECT_ID(N''[dbo].[NExtenso_Convert]'') AND type IN ( N''FN'')) DROP FUNCTION [dbo].[NExtenso_Convert]')

EXEC('CREATE FUNCTION [dbo].[NExtenso_Convert](@Num DECIMAL(18, 6), @Fat DECIMAL(18, 6))
	RETURNS VARCHAR(1000)
AS 
BEGIN 
	DECLARE @Ret VARCHAR(1000), @_Num DECIMAL(18, 6)
	SET @Ret = ''''
	SET @_Num = 0
 
	IF @Fat > 0 BEGIN 
		IF @Num = 1000000000 BEGIN 
			SET @Ret = @Ret + '' Um Bilhão''
		END ELSE IF @Num = 1000000 BEGIN 
			SET @Ret = @Ret + '' Um Milhão''
		END ELSE IF @Num = 1000 BEGIN 
			SET @Ret = @Ret + '' Um Mil''
		END ELSE IF @Num = 100 BEGIN 
			SET @Ret = @Ret + ''Cem''
		END ELSE IF @Num > 10 AND @Num < 20 BEGIN
			SET @Ret = @Ret + ISNULL(dbo.NExtenso_Extenso(@Num) + '' e '', '''')
		END ELSE BEGIN 
			IF @Fat >= 1000 BEGIN 
				SET @_Num = CAST((@Num - (@Num % @Fat)) * (CAST(1 AS DECIMAL(18, 6)) / @Fat) AS INTEGER)
 
				IF @_Num = 1 BEGIN 
					SET @Ret = @Ret + ISNULL(dbo.NExtenso_Convert(@Fat, @Fat * .1), '''')
				END ELSE BEGIN 
					SET @Ret = @Ret + ISNULL(dbo.NExtenso_Convert(@_Num, dbo.NExtenso_Fator(@_Num)), '''') + '' '' + ISNULL(dbo.NExtenso_Extenso(@Fat), '''')
				END 
 
				SET @_Num = @Num - (@_Num * @Fat)
 
				SET @Fat = dbo.NExtenso_Fator(@_Num)
 
				SET @Ret = @Ret + CASE WHEN (@Fat > 100 OR @Fat < 100) AND CAST((@_Num - (@_Num % @Fat)) * (CAST(1 AS DECIMAL(18, 6)) / @Fat) AS INTEGER) < 100 THEN '' e '' ELSE '', '' END + ISNULL(dbo.NExtenso_Convert(@_Num, @Fat), '''')
			END ELSE BEGIN 
				SET @_Num = @Num - (@Num % @Fat)
				SET @Ret = @Ret + ISNULL(dbo.NExtenso_Extenso(@_Num) + '' e '', '''') + dbo.NExtenso_Convert(@Num - @_Num, @Fat * .1)
			END 
		END
	END 
	RETURN REPLACE(REPLACE(@Ret + ''.'', '' e .'', ''''), ''.'', '''')
END')
 
EXEC('IF EXISTS (SELECT * FROM  sys.objects WHERE  object_id = OBJECT_ID(N''[dbo].[NExtenso]'') AND type IN ( N''FN'')) DROP FUNCTION [dbo].[NExtenso]')

EXEC('CREATE FUNCTION [dbo].[NExtenso](@Num DECIMAL(15, 2))
	RETURNS VARCHAR(1000)
AS 
BEGIN 
	DECLARE @Ret VARCHAR(500)
	IF @Num > 0 BEGIN 
		
		SET @Ret = ''''
		SET @Ret = dbo.NExtenso_Convert(@Num, dbo.NExtenso_Fator(@Num)) + 
			CASE FLOOR(@Num) WHEN 0 THEN '''' WHEN 1 THEN '' Euro'' ELSE '' Euros'' END + 
			CASE FLOOR(@Num) WHEN 0 THEN '''' ELSE '' e '' END
	 
		SET @Num = @Num - FLOOR(@Num) 
		IF @Num > 0 BEGIN 
			SET @Num = REPLACE(CAST(@Num AS VARCHAR(20)), ''0.'', '''')
			
			SET @Ret = @Ret + dbo.NExtenso_Convert(@Num, dbo.NExtenso_Fator(@Num)) + CASE @Num WHEN 1 THEN '' Cêntimo'' ELSE '' Cêntimos'' END
		END
	END ELSE BEGIN
		SET @Ret = ''Zero Euros''
	END
	RETURN @Ret
END') 


EXEC('IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[sp_AtualizaDocumentosVendas]'') AND type in (N''P'', N''PC'')) DROP PROCEDURE [sp_AtualizaDocumentosVendas]')

EXEC('CREATE PROCEDURE [dbo].[sp_AtualizaDocumentosVendas] 

AS
DECLARE db_cursor CURSOR FOR 

SELECT D.ID, D.IDTipoDocumento, D.IDTiposDocumentoSeries, D.UtilizadorCriacao, D.IDEntidade, d.DataCriacao
from tbDocumentosVendas D with (nolock) 
left join tbTiposDocumento TD with (nolock) on D.IDTipoDocumento=TD.id 
left join tbSistemaTiposDocumento STD with (nolock) on TD.IDSistemaTiposDocumento=STD.id
where CodigoDocOrigem=''002'' and d.CodigoTipoEstado=''EFT'' and (d.IDTipoDocumento<>6 or d.ValorPago>0)

DECLARE @IDDocumento bigint;
DECLARE @IDTipoDocumento bigint;
DECLARE @IDTiposDocumentoSeries bigint;
DECLARE @IDEntidade bigint;
DECLARE @Utilizador varchar(200); 
DECLARE @Data datetime;

OPEN db_cursor;

FETCH NEXT FROM db_cursor INTO @IDDocumento, @IDTipoDocumento, @IDTiposDocumentoSeries, @Utilizador, @IDEntidade, @Data
WHILE @@FETCH_STATUS = 0  
BEGIN 

EXEC sp_ControloDocumentos  @IDDocumento, @IDTipoDocumento, @IDTiposDocumentoSeries, 0, ''tbDocumentosVendas'', @Utilizador 
EXEC sp_AtualizaCCEntidades @IDDocumento, @IDTipoDocumento, 0, @Utilizador, @IDEntidade 

FETCH NEXT FROM db_cursor INTO @IDDocumento, @IDTipoDocumento, @IDTiposDocumentoSeries, @Utilizador, @IDEntidade, @Data;
END;
CLOSE db_cursor;
DEALLOCATE db_cursor;
Delete c from tbccentidades c inner join tbdocumentosvendas d on c.IDDocumento=d.id and c.IDTipoDocumento=d.IDTipoDocumento where c.IDEntidade=1 and d.CodigoDocOrigem=''002''
Update c set c.TotalMoedaReferencia=d.totalclientemoedadocumento from tbccentidades c inner join tbdocumentosvendas d on c.IDDocumento=d.id and c.IDTipoDocumento=d.IDTipoDocumento where d.totalmoedadocumento<>d.totalclientemoedadocumento  and d.totalentidade1>0 and d.CodigoDocOrigem=''002''
')

EXEC('IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[sp_AtualizaDocumentosVendasRC]'') AND type in (N''P'', N''PC'')) DROP PROCEDURE [sp_AtualizaDocumentosVendasRC]')

EXEC('CREATE PROCEDURE [dbo].[sp_AtualizaDocumentosVendasRC] 

AS
DECLARE db_cursor CURSOR FOR 

SELECT D.ID, D.IDTipoDocumento, D.IDTiposDocumentoSeries, D.UtilizadorCriacao, D.IDEntidade,d.DataCriacao
from tbrecibos D with (nolock) 
left join tbTiposDocumento TD with (nolock) on D.IDTipoDocumento=TD.id 
left join tbSistemaTiposDocumento STD with (nolock) on TD.IDSistemaTiposDocumento=STD.id
where CodigoDocOrigem=''002'' and d.CodigoTipoEstado=''EFT''
order by d.DataCriacao, d.ID; 

DECLARE @IDDocumento bigint;
DECLARE @IDTipoDocumento bigint;
DECLARE @IDTiposDocumentoSeries bigint;
DECLARE @IDEntidade bigint;
DECLARE @Utilizador varchar(200); 
DECLARE @Data datetime;

OPEN db_cursor;

FETCH NEXT FROM db_cursor INTO @IDDocumento, @IDTipoDocumento, @IDTiposDocumentoSeries, @Utilizador, @IDEntidade, @Data
WHILE @@FETCH_STATUS = 0  
BEGIN 

EXEC sp_ControloDocumentos  @IDDocumento, @IDTipoDocumento, @IDTiposDocumentoSeries, 0, ''tbRecibos'', @Utilizador 
EXEC sp_AtualizaCCEntidades @IDDocumento, @IDTipoDocumento, 0, @Utilizador, @IDEntidade 

FETCH NEXT FROM db_cursor INTO @IDDocumento, @IDTipoDocumento, @IDTiposDocumentoSeries, @Utilizador, @IDEntidade, @Data;
END;
CLOSE db_cursor;
DEALLOCATE db_cursor;
')