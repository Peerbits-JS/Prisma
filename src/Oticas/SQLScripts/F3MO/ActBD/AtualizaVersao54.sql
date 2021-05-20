/* ACT BD EMPRESA VERSAO 54*/
EXEC('IF Not EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE  TABLE_NAME = ''tbContabilidadeExportacao'' AND COLUMN_NAME = ''CentroCusto'') 
Begin
	alter table tbContabilidadeExportacao add CentroCusto bit null
End')

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
Delete c from tbccentidades c inner join tbdocumentosvendas d on c.IDDocumento=d.id and c.IDTipoDocumento=d.IDTipoDocumento inner join tbtiposdocumento td on d.idtipodocumento=td.id where td.codigo=''VD'' and d.CodigoDocOrigem=''002''
Update tbclientes set saldo=0 where abs(saldo)<0.01 and saldo<>0
Update c set c.saldo=0 from tbclientes c left join tbCCEntidades cc on cc.identidade=c.id where cc.id is null and c.saldo<>0
')