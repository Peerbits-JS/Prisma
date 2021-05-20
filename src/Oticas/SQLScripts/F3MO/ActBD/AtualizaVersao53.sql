/* ACT BD EMPRESA VERSAO 53*/
EXEC('delete from tbArtigosFornecedores where referencia is null and CodigoBarras is null')

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
')


--contas correntes
EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwCCClientes'')) drop view vwCCClientes')

EXEC('create view [dbo].[vwCCClientes] as
select 
tbClientes.Codigo as CodigoCliente,
tbCCEntidades.NomeFiscal,
tbCCEntidades.IDEntidade,
tbCCEntidades.IDLoja,
tbCCEntidades.IDTipoDocumento,
tbCCEntidades.IDTipoDocumentoSeries,
tbCCEntidades.NumeroDocumento,
tbCCEntidades.DataDocumento,
tbCCEntidades.Descricao as Documento,
tbCCEntidades.IDMoeda,
tbCCEntidades.Ativo as Ativo,
(case when tbCCEntidades.Natureza=''P'' then ''Crédito'' else ''Débito'' end) as Natureza,  
(case when tbCCEntidades.Natureza=''R'' then tbCCEntidades.TotalMoeda else -(tbCCEntidades.TotalMoeda) end) as TotalMoeda,
(case when tbCCEntidades.Natureza=''R'' then tbCCEntidades.TotalMoedaReferencia else -(tbCCEntidades.TotalMoedaReferencia) end) as Valor,
(case when tbCCEntidades.Natureza=''R'' then tbCCEntidades.TotalMoedaReferencia else -(tbCCEntidades.TotalMoedaReferencia) end) as TotalMoedaReferencia,
Round(isnull((
select Sum((Case tbCCSaldoAgreg.Natureza when ''R'' then 1 else -1 end) * tbCCSaldoAgreg.TotalMoedaReferencia) FROM tbCCEntidades as tbCCSaldoAgreg
WHERE tbCCSaldoAgreg.IDEntidade= tbCCEntidades.IDEntidade
AND (tbCCSaldoAgreg.Natureza =''P'' OR tbCCSaldoAgreg.Natureza =''R'')
AND tbCCSaldoAgreg.DataCriacao <= tbCCEntidades.DataCriacao
AND ((tbCCSaldoAgreg.IDTipoDocumento<>tbCCEntidades.IDTipoDocumento OR tbCCSaldoAgreg.IDDocumento <> tbCCEntidades.IDDocumento
       ) OR (tbCCSaldoAgreg.IDTipoDocumento = tbCCEntidades.IDTipoDocumento AND tbCCSaldoAgreg.IDDocumento = tbCCEntidades.IDDocumento
                     AND tbCCSaldoAgreg.ID<=tbCCEntidades.ID
                     )
       )
),0),isnull(tbMoedasRef.CasasDecimaisTotais,0)) as Saldo,
tbMoedasRef.descricao as tbMoedas_Descricao, 
tbMoedasRef.Simbolo as tbMoedas_Simbolo, 
tbMoedasRef.CasasDecimaisTotais as tbMoedas_CasasDecimaisTotais,
tbMoedasRef.CasasDecimaisTotais as Saldonumcasasdecimais,
tbMoedasRef.CasasDecimaisTotais as Valornumcasasdecimais,
tblojas.Codigo as CodigoLoja,
tblojas.Descricao as DescricaoLoja,
tbTiposDocumento.Codigo as CodigoTipoDocumento, 
tbTiposDocumento.Descricao as DescricaoTipoDocumento
FROM tbCCEntidades AS tbCCEntidades
LEFT JOIN tbClientes AS tbClientes ON tbClientes.id=tbCCEntidades.IDentidade
LEFT JOIN tbLojas AS tbLojas ON tbLojas.id=tbCCEntidades.IDLoja
LEFT JOIN tbMoedas as tbMoedas ON tbMoedas.ID=tbccentidades.IDMoeda
LEFT JOIN tbParametrosEmpresa as P ON 1 = 1
LEFT JOIN tbMoedas as tbMoedasRef ON tbMoedasRef.ID=P.IDMoedaDefeito
LEFT JOIN tbTiposDocumento AS tbTiposDocumento ON tbTiposDocumento.ID=tbCCEntidades.IDTipoDocumento
LEFT JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeries ON tbTiposDocumentoSeries.ID=tbCCEntidades.IDTipoDocumentoSeries
ORDER BY tbCCEntidades.DataDocumento, tbCCEntidades.DataCriacao, tbCCEntidades.IDTipoDocumento OFFSET 0 ROWS ')


--aviso de versão 1.23
EXEC('
BEGIN
DELETE [F3MOGeral].dbo.tbNotificacoes Where versao=''1.23.0''
insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
values (''Prisma'', ''1.23.0'', ''A'', ''2019-12-14 00:00'', ''2019-12-19 08:00'', ''Próxima atualização:'', ''O serviço poderá estar inativo durante breves minutos. Agradecemos a sua compreensão.'', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
insert into [F3MOGeral].dbo.tbNotificacoes (Produto, Versao, Tipo, DataInicio, DataFim, Titulo, Texto, Link, Ordem, Visto, IdLoja, Ativo, Sistema, DataCriacao, UtilizadorCriacao) 
values (''Prisma'', ''1.23.0'', ''V'', ''2019-12-19 08:00'', ''2019-12-19 08:00'', ''Funcionalidades da versão'', ''
<li>Serviços</li>
		&emsp;Validação das graduações<br>
		&emsp;Ajuste das formas de pagamento<br>
<li>Documentos de conferência</li>
		&emsp;Incluir a data e hora de emissão<br>
		&emsp;Incluir no ficheiro saf-t<br>
<li>Documentos de Venda</li>
		&emsp;Emissão documentos importados<br>
<li>Catálogo de lentes</li>
		&emsp;Novas tabelas Shamir e Zeiss<br>
'', ''MaisValias.pdf'', 2, 0, 1, 1, 0, getdate(), ''F3M'' ) 
END')


--vista de documentos de venda
EXEC('update [F3MOGeral].dbo.tbListasPersonalizadas set query=''
select d.IDLoja as IDLoja, d.ID as ID, l.Descricao as DescricaoLoja, d.Documento as Documento, d.IDTipoDocumento, d.IDTiposDocumentoSeries, DataDocumento, c.Codigo as CodigoCliente, NomeFiscal, TotalMoedaDocumento, TotalEntidade1, TotalClienteMoedaDocumento, d.IDEntidade, d.Assinatura, c.nome as DescricaoEntidade, d.Documento as DescricaoSplitterLadoDireito, d.IDEstado,
(isnull(d.TotalClienteMoedaDocumento,0)-isnull(d.valorpago,0)) as ValorPendente, s.Descricao as DescricaoEstado, e1.Descricao as DescricaoEntidade1, e2.Descricao as DescricaoEntidade2, TD.IDSistemaTiposDocumento, cast(1 as bit) as FazTestesRptStkMinMax, d.CodigoTipoEstado as CodigoTipoEstado, TD.Adiantamento as Adiantamento
from tbDocumentosVendas d 
inner join tbLojas l on d.IDloja=l.id and d.idloja=''''[%%IDLojaDoc%%]''''
left join tbClientes c on d.IDEntidade=c.id
inner join tbTiposDocumento TD on d.IDTipoDocumento=td.ID
inner join tbSistemaTiposDocumento STD on TD.IDSistemaTiposDocumento=STD.ID and STD.Tipo<>''''VndServico'''' and STD.Tipo<>''''SubstituicaoArtigos''''
left join tbTiposDocumentoSeries TDS on D.IDTiposDocumentoSeries=TDS.ID
left join tbEstados s on d.IDEstado=s.ID
left join tbentidades e1 on d.IDEntidade1=e1.ID
left join tbentidades e2 on d.IDEntidade2=e2.ID
''where id in (58)')


--mapa de compras
EXEC('
DECLARE @ptrval xml;  
DECLARE @intIDMapaSubCab as bigint;--10000
DECLARE @intIDMapaMI as bigint;--20000
DECLARE @intIDMapaD as bigint;--30000
DECLARE @intIDMapaDNV as bigint;--40000
SELECT @intIDMapaSubCab = ID FROM tbMapasVistas WHERE Entidade = ''DocumentosCompras'' and NomeMapa = ''Cabecalho Empresa Compras''
SELECT @intIDMapaMI = ID FROM tbMapasVistas WHERE Entidade = ''DocumentosCompras'' and NomeMapa = ''Motivos Isencao Compras''
SELECT @intIDMapaD = ID FROM tbMapasVistas WHERE Entidade = ''DocumentosCompras'' and NomeMapa = ''Dimensoes Compras''
SELECT @intIDMapaDNV = ID FROM tbMapasVistas WHERE Entidade = ''DocumentosCompras'' and NomeMapa = ''Dimensoes Compras Nao Valorizado''
SET @ptrval = N''<XtraReportsLayoutSerializer SerializerVersion="18.2.7.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.7.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="DocumentosCompras" ScriptsSource="Imports Reporting&#xD;&#xA;Imports Constantes&#xD;&#xA;&#xD;&#xA;Private dblTransportar as Double = 0&#xD;&#xA;Private dblTransporte as Double = 0&#xD;&#xA;&#xD;&#xA;Private Sub Documentos_Compras_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;    Dim SimboloMoeda As String = String.Empty&#xD;&#xA;    Dim resource As ReportTranslation = New ReportTranslation&#xD;&#xA;    Parameters.Item(&quot;AcompanhaBens&quot;).Value = False&#xD;&#xA;    Parameters.Item(&quot;IDLinha&quot;).Value = GetCurrentColumnValue(&quot;tbDocumentosComprasLinhas_ID&quot;)        &#xD;&#xA;    Parameters.Item(&quot;CasasMoedas&quot;).Value = GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisIva&quot;)&#xD;&#xA;        &#xD;&#xA;    SimboloMoeda = GetCurrentColumnValue(&quot;tbMoedas_Simbolo&quot;)&#xD;&#xA;    If SimboloMoeda = &quot;&quot; Then&#xD;&#xA;        Parameters.Item(&quot;SimboloMoedas&quot;).Value = &quot;€&quot;&#xD;&#xA;        SimboloMoeda = &quot;€&quot;&#xD;&#xA;    Else&#xD;&#xA;        Me.Parameters.Item(&quot;SimboloMoedas&quot;).Value = SimboloMoeda&#xD;&#xA;    End If&#xD;&#xA;    If not GetCurrentColumnValue(&quot;tbTiposDocumento_DocNaoValorizado&quot;) then&#xD;&#xA;        lblPreco.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;Preco&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblTotalFinal.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;Total&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDesconto1.Text = resource.GetResource(&quot;Desconto1&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDesconto2.Text = resource.GetResource(&quot;Desconto2&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDescontosLinha.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;DescontoLinha&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDescontoGlobal.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;DescontoGlobal&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblTotalIva.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;TotalIva&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    End If&#xD;&#xA;    Select Case GetCurrentColumnValue(&quot;tbSistemaTiposDocumento_Tipo&quot;)&#xD;&#xA;        Case &quot;CmpOrcamento&quot;, &quot;CmpTransporte&quot;, &quot;CmpFinanceiro&quot;&#xD;&#xA;            If GetCurrentColumnValue(&quot;tbSistemaNaturezas_Codigo&quot;) = &quot;P&quot; Then&#xD;&#xA;                lblArmazem.Text = resource.GetResource(&quot;Armz.&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                lblLocalizacao.Text = resource.GetResource(&quot;Local&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                lblArmazem1.Text = resource.GetResource(&quot;Armz.&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                lblLocalizacao1.Text = resource.GetResource(&quot;Local&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                fldArmazemValoriza.Text = GetCurrentColumnValue(&quot;tbArmazens1_CodigoDestino&quot;)&#xD;&#xA;                fldArmazem1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazens1_CodigoDestino&quot;)&#xD;&#xA;                fldLocalizacaoValoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes1_Codigo&quot;)&#xD;&#xA;                fldLocalizacao1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes1_Codigo&quot;)&#xD;&#xA;            ElseIf GetCurrentColumnValue(&quot;tbSistemaNaturezas_Codigo&quot;) = &quot;R&quot; Then&#xD;&#xA;                lblArmazem1.Text = resource.GetResource(&quot;Armz.&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                lblLocalizacao1.Text = resource.GetResource(&quot;Local&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                lblArmazem.Text = resource.GetResource(&quot;Armz.&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                lblLocalizacao.Text = resource.GetResource(&quot;Local&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;                fldArmazemValoriza.Text = GetCurrentColumnValue(&quot;tbArmazens_Codigo&quot;)&#xD;&#xA;                fldArmazem1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazens_Codigo&quot;)&#xD;&#xA;                fldLocalizacaoValoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes_Codigo&quot;)&#xD;&#xA;                fldLocalizacao1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes_Codigo&quot;)&#xD;&#xA;            End If&#xD;&#xA;        Case &quot;CmpEncomenda&quot;&#xD;&#xA;            lblArmazem1.Text = resource.GetResource(&quot;Armz.&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;            lblLocalizacao1.Text = resource.GetResource(&quot;Local&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;            lblArmazem.Text = resource.GetResource(&quot;Armz.&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;            lblLocalizacao.Text = resource.GetResource(&quot;Local&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;            fldArmazemValoriza.Text = GetCurrentColumnValue(&quot;tbArmazens_Codigo&quot;)&#xD;&#xA;            fldArmazem1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazens_Codigo&quot;)&#xD;&#xA;            fldLocalizacaoValoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes_Codigo&quot;)&#xD;&#xA;            fldLocalizacao1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes_Codigo&quot;)&#xD;&#xA;    End Select&#xD;&#xA;    ''''Assinatura&#xD;&#xA;    Dim strAssinatura As String = String.Empty&#xD;&#xA;    Dim strAss As String = String.Empty&#xD;&#xA;    Dim strMsg As String = String.Empty&#xD;&#xA;    If GetCurrentColumnValue(&quot;MensagemDocAT&quot;).IndexOf(Constantes.SaftAT.CSeparadorMsgAt) &gt; 0 Then&#xD;&#xA;        strAss = GetCurrentColumnValue(&quot;MensagemDocAT&quot;).Substring(0, GetCurrentColumnValue(&quot;MensagemDocAT&quot;).IndexOf(Constantes.SaftAT.CSeparadorMsgAt))&#xD;&#xA;        strMsg = GetCurrentColumnValue(&quot;MensagemDocAT&quot;).Substring(GetCurrentColumnValue(&quot;MensagemDocAT&quot;).IndexOf(Constantes.SaftAT.CSeparadorMsgAt) + Constantes.SaftAT.CSeparadorMsgAt.Length)&#xD;&#xA;    Else&#xD;&#xA;        strAss = GetCurrentColumnValue(&quot;MensagemDocAT&quot;)&#xD;&#xA;    End If&#xD;&#xA;    If GetCurrentColumnValue(&quot;CodigoAT&quot;) &lt;&gt; String.Empty Then&#xD;&#xA;        strMsg += &quot; | ATDocCodeId: &quot; &amp; GetCurrentColumnValue(&quot;CodigoAT&quot;)&#xD;&#xA;    End If&#xD;&#xA;    fldMensagemDocAT.Text = strMsg&#xD;&#xA;    fldMensagemDocAT1.Text = strMsg&#xD;&#xA;    fldAssinatura11.Text = strMsg&#xD;&#xA;    fldAssinatura.Text = strAss&#xD;&#xA;    fldAssinatura1.Text = strAss&#xD;&#xA;    fldassinaturanaoval.Text = strAss&#xD;&#xA;    &#xD;&#xA;    If GetCurrentColumnValue(&quot;tbTiposDocumento_AcompanhaBensCirculacao&quot;) Then&#xD;&#xA;        If Me.Parameters(&quot;Via&quot;).Value.ToString &lt;&gt; &quot;Original&quot; AndAlso Me.Parameters(&quot;Via&quot;).Value.ToString &lt;&gt; &quot;Duplicado&quot; AndAlso Me.Parameters(&quot;Via&quot;).Value.ToString &lt;&gt; &quot;Triplicado&quot; Then&#xD;&#xA;            lblCopia1.Text = &quot;Cópia de documento não válida para os fins previstos no regime de bens em circulação&quot;&#xD;&#xA;            lblCopia2.Text = &quot;Cópia de documento não válida para os fins previstos no regime de bens em circulação&quot;&#xD;&#xA;            lblCopia3.Text = &quot;Cópia de documento não válida para os fins previstos no regime de bens em circulação&quot;&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;    &#xD;&#xA;     ''''Separadores totalizadores&#xD;&#xA;    lblSubTotal.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;SubTotal&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    lblTotalIva.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;TotalIva&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    lblTotalMoedaDocumento.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;TotalMoedaDocumento&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    ''''Identificação do documento&#xD;&#xA;    If not GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;) is dbnull.value then&#xD;&#xA;        lblTipoDocumento.Text = resource.GetResource(GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;), Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblTipoDocumento1.Text = resource.GetResource(GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;), Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    end if&#xD;&#xA;    If GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;) is dbnull.value Orelse GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;) = String.Empty Orelse GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;) = &quot;NaoFiscal&quot; Then&#xD;&#xA;        lblTipoDocumento.Text = resource.GetResource(GetCurrentColumnValue(&quot;tbTiposDocumento_Descricao&quot;), Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblTipoDocumento1.Text = resource.GetResource(GetCurrentColumnValue(&quot;tbTiposDocumento_Descricao&quot;), Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;    End If&#xD;&#xA;    If GetCurrentColumnValue(&quot;CodigoTipoEstado&quot;) = &quot;ANL&quot; Then&#xD;&#xA;        lblAnulado.Text = resource.GetResource(&quot;Anulado&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblAnulado.Visible = True&#xD;&#xA;    End If&#xD;&#xA;    If not GetCurrentColumnValue(&quot;SegundaVia&quot;) is dbnull.value andalso GetCurrentColumnValue(&quot;SegundaVia&quot;) = &quot;True&quot; Then&#xD;&#xA;        If lblAnulado.Visible Then&#xD;&#xA;            lblSegundaVia.Visible = False&#xD;&#xA;            lblNumVias.Visible = True&#xD;&#xA;        Else&#xD;&#xA;            lblSegundaVia.Text = resource.GetResource(&quot;SegundaVia&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;            lblSegundaVia.Visible = True&#xD;&#xA;            lblNumVias.Visible = False&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;    If not GetCurrentColumnValue(&quot;tbCodigosPostaisCarga_Codigo&quot;) is dbnull.value andalso GetCurrentColumnValue(&quot;tbCodigosPostaisCarga_Codigo&quot;) = String.Empty Then&#xD;&#xA;        fldDataCarga.Visible = False&#xD;&#xA;    End If&#xD;&#xA;    If not GetCurrentColumnValue(&quot;tbCodigosPostaisDescarga_Codigo&quot;) is dbnull.value andalso GetCurrentColumnValue(&quot;tbCodigosPostaisDescarga_Codigo&quot;) = String.Empty Then&#xD;&#xA;        fldDataDescarga.Visible = False&#xD;&#xA;    End If&#xD;&#xA;    If GetCurrentColumnValue(&quot;MoradaCarga&quot;) &lt;&gt; String.Empty Or GetCurrentColumnValue(&quot;MoradaDescarga&quot;) &lt;&gt; String.Empty Then&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbTiposDocumento_AcompanhaBensCirculacao&quot;) Then&#xD;&#xA;            SubBand6.Visible = True&#xD;&#xA;        Else&#xD;&#xA;            SubBand6.Visible = False&#xD;&#xA;        End If&#xD;&#xA;    Else&#xD;&#xA;        SubBand6.Visible = False&#xD;&#xA;    End If&#xD;&#xA;    TraducaoDocumento()   &#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA; Private Sub TraducaoDocumento()&#xD;&#xA;        Dim resource As ReportTranslation = New ReportTranslation&#xD;&#xA;        ''''Doc.Origem&#xD;&#xA;        lblDocOrigem.Text = resource.GetResource(&quot;Origem&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDocOrigem1.Text = resource.GetResource(&quot;Origem&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        ''''Descrição&#xD;&#xA;        lblDescricao.Text = resource.GetResource(&quot;Descricao&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDescricao1.Text = resource.GetResource(&quot;Descricao&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        ''''Lote&#xD;&#xA;        lblLote.Text = resource.GetResource(&quot;Lote&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblLote1.Text = resource.GetResource(&quot;Lote&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        ''''Armazens&#xD;&#xA;        ''''Localizações&#xD;&#xA;        ''''Unidades&#xD;&#xA;        lblUni.Text = resource.GetResource(&quot;Unidade&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblUni1.Text = resource.GetResource(&quot;Unidade&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        ''''Quantidade&#xD;&#xA;        lblQuantidade.Text = resource.GetResource(&quot;Qtd&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblQuantidade1.Text = resource.GetResource(&quot;Qtd&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblContribuinte.Text = resource.GetResource(&quot;Contribuinte&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblFornecedorCodigo.Text = resource.GetResource(&quot;FornecedorCodigo&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblCodigoMoeda.Text = resource.GetResource(&quot;CodigoMoeda&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDataDocumento.Text = resource.GetResource(&quot;DataDocumento&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblCarga.Text = resource.GetResource(&quot;Carga&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblDescarga.Text = resource.GetResource(&quot;Descarga&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblExpedicao.Text = resource.GetResource(&quot;Matricula&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblTituloTransporte.Text = resource.GetResource(&quot;TituloTransporte&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;        lblTituloTransportar.Text = resource.GetResource(&quot;TituloTransportar&quot;, Parameters(&quot;Culture&quot;).Value.ToString)&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub fldAssinatura11_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = e.PageCount - 1 Then&#xD;&#xA;        fldAssinatura11.Visible = False&#xD;&#xA;        me.lblCopia3.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        fldAssinatura11.Visible = True&#xD;&#xA;        me.lblCopia3.Visible = True&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub fldAssinatura1_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = e.PageCount - 1 Then&#xD;&#xA;        fldAssinatura1.Visible = False&#xD;&#xA;        me.lblCopia3.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        fldAssinatura1.Visible = True&#xD;&#xA;        me.lblCopia3.Visible = True&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTransportar_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;     If e.PageIndex = e.PageCount - 1 Then&#xD;&#xA;        Me.lblTransportar.Visible = False&#xD;&#xA;        Me.lblTituloTransportar.Visible = False&#xD;&#xA;        Me.fldAssinatura1.Visible = False&#xD;&#xA;        Me.fldAssinatura11.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbTiposDocumento_DocNaoValorizado&quot;) Then&#xD;&#xA;            Me.lblTransportar.Visible = False&#xD;&#xA;            Me.lblTituloTransportar.Visible = False&#xD;&#xA;        Else&#xD;&#xA;            Me.lblTransportar.Visible = True&#xD;&#xA;            Me.lblTituloTransportar.Visible = True&#xD;&#xA;        End If&#xD;&#xA;        Me.fldAssinatura1.Visible = True&#xD;&#xA;        Me.fldAssinatura11.Visible = True&#xD;&#xA;    End If&#xD;&#xA;    Dim label as DevExpress.XtraReports.UI.XRLabel = sender&#xD;&#xA;    Dim page as DevExpress.XtraPrinting.Page = label.RootReport.Pages(e.PageIndex)     &#xD;&#xA;    Dim iterator as DevExpress.XtraPrinting.Native.NestedBrickIterator = new DevExpress.XtraPrinting.Native.NestedBrickIterator(page.InnerBricks)&#xD;&#xA;    While (iterator.MoveNext())&#xD;&#xA;        If (TypeOf iterator.CurrentBrick Is VisualBrick AndAlso (CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).BrickOwner.Name.Equals(&quot;fldTotalFinal&quot;))&#xD;&#xA;            dblTransportar += Convert.ToDecimal((CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).TextValue)&#xD;&#xA;        End If&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;) is DBNull.value Then&#xD;&#xA;            label.Text = dblTransportar.ToString()&#xD;&#xA;        Else&#xD;&#xA;            label.Text = Convert.ToDouble(dblTransportar.ToString()).ToString(&quot;F&quot; &amp; GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;))&#xD;&#xA;        End If&#xD;&#xA;    End While&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTituloTransportar_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = e.PageCount - 1 Then&#xD;&#xA;        Me.lblTituloTransportar.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbTiposDocumento_DocNaoValorizado&quot;) Then&#xD;&#xA;            Me.lblTituloTransportar.Visible = False&#xD;&#xA;        Else&#xD;&#xA;            Me.lblTituloTransportar.Visible = True&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTransporte_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;     If e.PageIndex = 0 Then&#xD;&#xA;        Me.lblTituloTransporte.Visible = False&#xD;&#xA;        Me.lblTransporte.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbTiposDocumento_DocNaoValorizado&quot;) Then&#xD;&#xA;            Me.lblTituloTransporte.Visible = False&#xD;&#xA;            Me.lblTransporte.Visible = False&#xD;&#xA;        Else&#xD;&#xA;            Me.lblTituloTransporte.Visible = True&#xD;&#xA;            Me.lblTransporte.Visible = True&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;    If e.PageIndex &gt; 0 then&#xD;&#xA;        Dim label as DevExpress.XtraReports.UI.XRLabel = sender&#xD;&#xA;        Dim page as DevExpress.XtraPrinting.Page = label.RootReport.Pages(e.PageIndex - 1)     &#xD;&#xA;        Dim iterator as DevExpress.XtraPrinting.Native.NestedBrickIterator = new DevExpress.XtraPrinting.Native.NestedBrickIterator(page.InnerBricks)&#xD;&#xA;        While (iterator.MoveNext())&#xD;&#xA;             if (TypeOf iterator.CurrentBrick Is VisualBrick AndAlso (CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).BrickOwner.Name.Equals(&quot;fldTotalFinal&quot;))&#xD;&#xA;                dblTransporte += Convert.ToDecimal((CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).TextValue)&#xD;&#xA;            End If&#xD;&#xA;            If GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;) is DBNull.value Then&#xD;&#xA;                label.Text = dblTransporte.ToString()&#xD;&#xA;            Else&#xD;&#xA;                label.Text = Convert.ToDouble(dblTransporte.ToString()).ToString(&quot;F&quot; &amp; GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;))&#xD;&#xA;            End If&#xD;&#xA;        End While&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTituloTransporte_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = 0 Then&#xD;&#xA;        Me.lblTituloTransporte.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbTiposDocumento_DocNaoValorizado&quot;) Then&#xD;&#xA;            Me.lblTituloTransporte.Visible = False&#xD;&#xA;        Else&#xD;&#xA;            Me.lblTituloTransporte.Visible = True&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;" DrawWatermark="true" Margins="54, 18, 25, 1" PaperKind="A4" PageWidth="827" PageHeight="1169" ScriptLanguage="VisualBasic" Version="18.2" FilterString="[ID] = ?IDDocumento" DataMember="tbDocumentosCompras_Cab" DataSource="#Ref-0">
  <Extensions>
    <Item1 Ref="2" Key="DataSerializationExtension" Value="DevExpress.XtraReports.Web.ReportDesigner.DefaultDataSerializer" />
  </Extensions>
  <Parameters>
    <Item1 Ref="4" Description="IDDocumento" ValueInfo="40026" Name="IDDocumento" Type="#Ref-3" />
    <Item2 Ref="6" Description="Culture" ValueInfo="pt-PT" Name="Culture" />
    <Item3 Ref="7" Visible="false" Description="Via" Name="Via" />
    <Item4 Ref="8" Visible="false" Description="BDEmpresa" ValueInfo="Teste" Name="BDEmpresa" />
    <Item5 Ref="9" Visible="false" Description="Observacoes" ValueInfo="select ID, Observacoes from tbDocumentosCompras where ID=" Name="Observacoes" />
    <Item6 Ref="11" Visible="false" Description="IDLoja" ValueInfo="1" Name="IDLoja" Type="#Ref-10" />
    <Item7 Ref="12" Visible="false" Description="FraseFiscal" ValueInfo="FraseFiscal" Name="FraseFiscal" />
    <Item8 Ref="13" Description="IDEmpresa" ValueInfo="1" Name="IDEmpresa" Type="#Ref-3" />
    <Item9 Ref="15" Visible="false" Description="AcompanhaBens" ValueInfo="true" Name="AcompanhaBens" Type="#Ref-14" />
    <Item10 Ref="16" Description="IDLinha" ValueInfo="0" Name="IDLinha" Type="#Ref-3" />
    <Item11 Ref="18" Description="CasasDecimais" ValueInfo="0" Name="CasasDecimais" Type="#Ref-17" />
    <Item12 Ref="19" Description="CasasMoedas" ValueInfo="0" Name="CasasMoedas" Type="#Ref-17" />
    <Item13 Ref="20" Description="SimboloMoedas" Name="SimboloMoedas" />
    <Item14 Ref="21" Description="UrlServerPath" ValueInfo="http:\\localhost" AllowNull="true" Name="UrlServerPath" />
    <Item15 Ref="22" Description="Utilizador" ValueInfo="f3m" Name="Utilizador" />
  </Parameters>
  <CalculatedFields>
    <Item1 Ref="23" Name="SomaQuantidade" FieldType="Float" DisplayName="SomaQuantidade" Expression="[].Sum([Quantidade])" DataMember="tbDocumentosVendas" />
    <Item2 Ref="24" Name="SomaValorIVA" FieldType="Float" Expression="[].Sum([ValorIVA])" DataMember="tbDocumentosVendas" />
    <Item3 Ref="25" Name="SomaValorIncidencia" FieldType="Float" Expression="[].Sum([ValorIncidencia])" DataMember="tbDocumentosVendas" />
    <Item4 Ref="26" Name="SomaTotalFinal" FieldType="Double" Expression="[].Sum([TotalFinal])" DataMember="tbDocumentosVendas" />
    <Item5 Ref="27" Name="MotivoIsencao" DisplayName="MotivoIsencao" Expression="IIF([TaxaIva]=0, '''''''', [CodigoMotivoIsencaoIva])" DataMember="tbDocumentosVendas" />
    <Item6 Ref="28" Name="SubTotal" FieldType="Double" Expression="[TotalMoedaDocumento] - [ValorImposto] " DataMember="tbDocumentosCompras_Cab" />
  </CalculatedFields>
  <Bands>
    <Item1 Ref="29" ControlType="TopMarginBand" Name="TopMargin" HeightF="25" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item2 Ref="30" ControlType="ReportHeaderBand" Name="ReportHeader" Expanded="false" HeightF="0" />
    <Item3 Ref="31" ControlType="PageHeaderBand" Name="PageHeader" Expanded="false" HeightF="2.09">
      <SubBands>
        <Item1 Ref="32" ControlType="SubBand" Name="SubBand5" HeightF="107.87">
          <Controls>
            <Item1 Ref="33" ControlType="XRSubreport" Name="XrSubreport2" ReportSourceUrl="10000" SizeF="535.2748,105.7917" LocationFloat="0, 0">
              <ParameterBindings>
                <Item1 Ref="34" ParameterName="" DataMember="tbDocumentosCompras.IDLoja" />
                <Item2 Ref="36" ParameterName="Culture" Parameter="#Ref-6" />
                <Item3 Ref="37" ParameterName="BDEmpresa" Parameter="#Ref-8" />
                <Item4 Ref="38" ParameterName="" DataMember="tbParametrosLojas.DesignacaoComercial" />
                <Item5 Ref="39" ParameterName="" DataMember="tbParametrosLojas.Morada" />
                <Item6 Ref="40" ParameterName="" DataMember="tbParametrosLojas.Localidade" />
                <Item7 Ref="41" ParameterName="" DataMember="tbParametrosLojas.CodigoPostal" />
                <Item8 Ref="42" ParameterName="" DataMember="tbParametrosLojas.Sigla" />
                <Item9 Ref="43" ParameterName="" DataMember="tbParametrosLojas.NIF" />
                <Item10 Ref="44" ParameterName="UrlServerPath" Parameter="#Ref-21" />
              </ParameterBindings>
            </Item1>
            <Item2 Ref="45" ControlType="XRLabel" Name="fldDataVencimento" TextFormatString="{0:dd-MM-yyyy}" CanGrow="false" TextAlignment="TopRight" SizeF="83.64227,20" LocationFloat="662.777, 78.02378" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
              <ExpressionBindings>
                <Item1 Ref="46" Expression="[DataDocumento]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="47" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="48" ControlType="XRLabel" Name="fldTipoDocumento" TextAlignment="TopRight" SizeF="159.7648,20.54824" LocationFloat="586.78, 33.55265" Font="Arial, 9.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="49" Expression="[tbTiposDocumento_Codigo] + '''' '''' + [CodigoSerie] + ''''/'''' + [NumeroDocumento] " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="50" UseFont="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="51" ControlType="XRLabel" Name="lblDataDocumento" Text="Data" TextAlignment="TopRight" SizeF="84.06,15" LocationFloat="662.777, 63.10085" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="DataDocumento">
              <StylePriority Ref="52" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="53" ControlType="XRLabel" Name="lblNumVias" Text="Via" TextAlignment="TopRight" SizeF="160.2199,11.77632" LocationFloat="586.78, 0" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <ExpressionBindings>
                <Item1 Ref="54" Expression="?Via " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="55" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item5>
            <Item6 Ref="56" ControlType="XRLabel" Name="lblTipoDocumento" Text="Fatura" TextAlignment="TopRight" SizeF="159.7648,13.77632" LocationFloat="586.78, 19.77634" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="57" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="58" ControlType="XRLabel" Name="lblAnulado" Angle="20" Text="ANULADO" TextAlignment="MiddleCenter" SizeF="189.8313,105.7917" LocationFloat="427.3537, 0" Font="Arial, 24pt, style=Bold, charSet=0" ForeColor="Red" Padding="2,2,0,0,100" Visible="false">
              <StylePriority Ref="59" UseFont="false" UseForeColor="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="60" ControlType="XRLabel" Name="lblSegundaVia" Text="2º Via" TextAlignment="TopRight" SizeF="80.59814,13.77632" LocationFloat="665.8211, 0" Font="Arial, 9pt, style=Bold, charSet=0" ForeColor="Black" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Visible="false">
              <StylePriority Ref="61" UseFont="false" UseForeColor="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item8>
          </Controls>
          <ExpressionBindings>
            <Item1 Ref="62" Expression="not(([tbSistemaTiposDocumento_Tipo] = ''''CmpFinanceiro'''' or &#xA;[tbSistemaTiposDocumento_Tipo] = ''''CmpTransporte'''') And&#xA;([TipoFiscal] = ''''FT'''' Or [TipoFiscal] = ''''FR'''' Or &#xA;[TipoFiscal] = ''''FS'''' Or [TipoFiscal] = ''''NC'''' Or &#xA;[TipoFiscal] = ''''ND'''' Or [TipoFiscal] = ''''NF'''' Or &#xA;[TipoFiscal] = ''''GR'''' Or [TipoFiscal] = ''''GT''''))" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item1>
        <Item2 Ref="63" ControlType="SubBand" Name="SubBand1" HeightF="150.42">
          <Controls>
            <Item1 Ref="64" ControlType="XRPanel" Name="XrPanel1" SizeF="746.837,148.3334" LocationFloat="2.91, 0">
              <Controls>
                <Item1 Ref="65" ControlType="XRLabel" Name="fldCodigoPostal" Text="Código Postal" TextAlignment="TopRight" SizeF="296.2911,22.99999" LocationFloat="381.5468, 86" Font="Arial, 9.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="66" Expression="[tbCodigosPostaisCliente_Codigo] + '''' '''' + [tbCodigosPostaisCliente_Descricao] " PropertyName="Text" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="67" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item1>
                <Item2 Ref="68" ControlType="XRLabel" Name="fldCodigoMoeda" TextAlignment="TopLeft" SizeF="194.7021,13.99999" LocationFloat="103.1326, 49.00001" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="69" Expression="[tbMoedas_Codigo]" PropertyName="Text" EventName="BeforePrint" />
                    <Item2 Ref="70" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="71" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item2>
                <Item3 Ref="72" ControlType="XRLabel" Name="lblCodigoMoeda" Text="Moeda" TextAlignment="TopLeft" SizeF="102.121,14" LocationFloat="1.010068, 49.00004" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Parentesco">
                  <ExpressionBindings>
                    <Item1 Ref="73" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="74" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item3>
                <Item4 Ref="75" ControlType="XRLabel" Name="fldMorada" TextAlignment="TopRight" SizeF="296.2915,23" LocationFloat="381.5468, 63" Font="Arial, 9.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="76" Expression="[MoradaFiscal]" PropertyName="Text" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="77" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item4>
                <Item5 Ref="78" ControlType="XRLabel" Name="fldNome" TextAlignment="TopRight" SizeF="296.2916,23" LocationFloat="381.5467, 40" Font="Arial, 9.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="79" Expression="[NomeFiscal]" PropertyName="Text" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="80" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item5>
                <Item6 Ref="81" ControlType="XRLabel" Name="lblTitulo" Text="Exmo.(a) Sr.(a) " TextAlignment="TopRight" SizeF="296.2916,20" LocationFloat="381.5464, 20" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="82" Expression="iif( not [tbTiposDocumento_AcompanhaBensCirculacao] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="83" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item6>
                <Item7 Ref="84" ControlType="XRLabel" Name="lblContribuinte" Text="Contribuinte nº" TextAlignment="TopLeft" SizeF="102.121,14" LocationFloat="1.010005, 21.00004" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Contribuinte">
                  <StylePriority Ref="85" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item7>
                <Item8 Ref="86" ControlType="XRLabel" Name="lblFornecedorCodigo" Text="Cod. Fornecedor" TextAlignment="TopLeft" SizeF="102.121,14" LocationFloat="1.010036, 35.00004" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Cliente">
                  <StylePriority Ref="87" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item8>
                <Item9 Ref="88" ControlType="XRLabel" Name="fldFornecedorCodigo" TextAlignment="TopLeft" SizeF="194.7036,14" LocationFloat="103.131, 35.00001" Font="Arial, 8pt" Padding="2,2,0,0,100" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="89" Expression="[tbFornecedores_Codigo]" PropertyName="Text" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="90" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item9>
                <Item10 Ref="91" ControlType="XRLabel" Name="fldContribuinteFiscal" TextAlignment="TopLeft" SizeF="194.715,13.99999" LocationFloat="103.1311, 21" Font="Arial, 8pt" Padding="2,2,0,0,100" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="92" Expression="[ContribuinteFiscal]" PropertyName="Text" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="93" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item10>
              </Controls>
            </Item1>
          </Controls>
          <ExpressionBindings>
            <Item1 Ref="94" Expression="not(([tbSistemaTiposDocumento_Tipo] = ''''CmpFinanceiro'''' or &#xA;[tbSistemaTiposDocumento_Tipo] = ''''CmpTransporte'''') And&#xA;([TipoFiscal] = ''''FT'''' Or [TipoFiscal] = ''''FR'''' Or &#xA;[TipoFiscal] = ''''FS'''' Or [TipoFiscal] = ''''NC'''' Or &#xA;[TipoFiscal] = ''''ND'''' Or [TipoFiscal] = ''''NF'''' Or &#xA;[TipoFiscal] = ''''GR'''' Or [TipoFiscal] = ''''GT''''))" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item2>
        <Item3 Ref="95" ControlType="SubBand" Name="SubBand8" HeightF="65">
          <Controls>
            <Item1 Ref="96" ControlType="XRLine" Name="line1" SizeF="745.41,2.252249" LocationFloat="1, 61.07" />
            <Item2 Ref="97" ControlType="XRLabel" Name="label6" Text="Fornecedor" TextAlignment="TopLeft" SizeF="85,15" LocationFloat="260, 25" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="DataDocumento">
              <StylePriority Ref="98" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="99" ControlType="XRLabel" Name="label10" Multiline="true" Text="label10" SizeF="350,20" LocationFloat="260, 40" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="100" Expression="[CodigoEntidade] + '''' - '''' + [NomeFiscal] " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="101" UseFont="false" />
            </Item3>
            <Item4 Ref="102" ControlType="XRLabel" Name="label9" Multiline="true" Text="label9" TextAlignment="MiddleRight" SizeF="100,13" LocationFloat="650, 40" Font="Times New Roman, 8pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="103" Expression="?Utilizador" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="104" UseFont="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="105" ControlType="XRLabel" Name="label8" Multiline="true" Text="label8" TextAlignment="MiddleRight" SizeF="125,13" LocationFloat="625, 25" Font="Times New Roman, 8pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="106" Expression="LocalDateTimeNow() " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="107" UseFont="false" UseTextAlignment="false" />
            </Item5>
            <Item6 Ref="108" ControlType="XRLabel" Name="label7" Multiline="true" Text="Emitido em" TextAlignment="MiddleRight" SizeF="100,13" LocationFloat="650, 10" Font="Times New Roman, 8pt" Padding="2,2,0,0,100">
              <StylePriority Ref="109" UseFont="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="110" ControlType="XRLabel" Name="label5" TextFormatString="{0:dd-MM-yyyy}" CanGrow="false" Text="label5" TextAlignment="TopCenter" SizeF="85,20" LocationFloat="170, 40" Font="Arial, 9pt" Padding="2,2,0,0,100" BorderWidth="0">
              <ExpressionBindings>
                <Item1 Ref="111" Expression="[DataDocumento]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="112" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="113" ControlType="XRLabel" Name="label4" Text="Data" TextAlignment="TopCenter" SizeF="85,15" LocationFloat="170, 25" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="DataDocumento">
              <StylePriority Ref="114" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item8>
            <Item9 Ref="115" ControlType="XRLabel" Name="label3" Text="label3" TextAlignment="TopRight" SizeF="160,20" LocationFloat="6, 40" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="116" Expression="[VossoNumeroDocumento]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="117" UseFont="false" UseTextAlignment="false" />
            </Item9>
            <Item10 Ref="118" ControlType="XRLabel" Name="lblTipoDocumento1" Text="Fatura" TextAlignment="TopRight" SizeF="160,15" LocationFloat="6, 25" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="119" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item10>
            <Item11 Ref="120" ControlType="XRLabel" Name="label1" Multiline="true" Text="label1" SizeF="450,23" LocationFloat="0, 2" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="121" Expression="[tbParametrosEmpresa.DesignacaoComercial]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
            </Item11>
          </Controls>
          <ExpressionBindings>
            <Item1 Ref="122" Expression="(([tbSistemaTiposDocumento_Tipo] = ''''CmpFinanceiro'''' or &#xA;[tbSistemaTiposDocumento_Tipo] = ''''CmpTransporte'''') And&#xA;([TipoFiscal] = ''''FT'''' Or [TipoFiscal] = ''''FR'''' Or &#xA;[TipoFiscal] = ''''FS'''' Or [TipoFiscal] = ''''NC'''' Or &#xA;[TipoFiscal] = ''''ND'''' Or [TipoFiscal] = ''''NF'''' Or &#xA;[TipoFiscal] = ''''GR'''' Or [TipoFiscal] = ''''GT''''))" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item3>
        <Item4 Ref="123" ControlType="SubBand" Name="sbValoriza" HeightF="26" Visible="false">
          <Controls>
            <Item1 Ref="124" ControlType="XRLabel" Name="lblArtigo" Text="Artigo" TextAlignment="TopLeft" SizeF="52.09093,13" LocationFloat="0, 9.999974" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Artigo">
              <StylePriority Ref="125" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="126" ControlType="XRLabel" Name="lblDesconto1" Text="% D1" TextAlignment="TopRight" SizeF="39.16687,13" LocationFloat="568.7189, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="127" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="128" ControlType="XRLabel" Name="lblDesconto2" Text="% D2" TextAlignment="TopRight" SizeF="39.02051,13" LocationFloat="609.921, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="129" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="130" ControlType="XRLabel" Name="lblLocalizacao" Text="Local " TextAlignment="TopLeft" SizeF="51.64383,13" LocationFloat="395.4805, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Local ">
              <StylePriority Ref="131" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="132" ControlType="XRLine" Name="XrLine1" SizeF="745.41,2.252249" LocationFloat="1, 23.41446" />
            <Item6 Ref="133" ControlType="XRLabel" Name="lblIvaLinha" Text="% Iva" TextAlignment="TopRight" SizeF="42.28259,13" LocationFloat="704.1368, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="134" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="135" ControlType="XRLabel" Name="lblTotalFinal" Text="Total" TextAlignment="TopRight" SizeF="51.19525,13" LocationFloat="649.9416, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="136" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="137" ControlType="XRLabel" Name="lblPreco" Text="Preço" TextAlignment="TopRight" SizeF="49.06677,13" LocationFloat="519.652, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="138" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item8>
            <Item9 Ref="139" ControlType="XRLabel" Name="lblQuantidade" Text="Qtd." TextAlignment="TopRight" SizeF="40.20905,13" LocationFloat="452.9174, 9.999978" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="140" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item9>
            <Item10 Ref="141" ControlType="XRLabel" Name="lblDescricao" Text="Descrição" TextAlignment="TopLeft" SizeF="178.8246,13" LocationFloat="52.09093, 10" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="142" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item10>
            <Item11 Ref="143" ControlType="XRLabel" Name="lblDocOrigem" Text="D.Origem" TextAlignment="TopLeft" SizeF="46.62386,13" LocationFloat="230.9156, 10.41446" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Artigo">
              <StylePriority Ref="144" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item11>
            <Item12 Ref="145" ControlType="XRLabel" Name="lblLote" Text="Lote" TextAlignment="TopLeft" SizeF="53.84052,13" LocationFloat="286.9375, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Lote">
              <StylePriority Ref="146" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item12>
            <Item13 Ref="147" ControlType="XRLabel" Name="lblArmazem" Text="Armz." TextAlignment="TopLeft" SizeF="50.43265,13" LocationFloat="341.778, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Armazem">
              <StylePriority Ref="148" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item13>
            <Item14 Ref="149" ControlType="XRLabel" Name="lblUni" Text="Uni." TextAlignment="TopRight" SizeF="26.29852,13" LocationFloat="493.1264, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="150" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item14>
          </Controls>
          <ExpressionBindings>
            <Item1 Ref="151" Expression="iif( not [tbTiposDocumento_DocNaoValorizado] , true, false)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item4>
        <Item5 Ref="152" ControlType="SubBand" Name="sbNaoValoriza" HeightF="31" Visible="false">
          <Controls>
            <Item1 Ref="153" ControlType="XRLabel" Name="lblDocOrigem1" Text="D.Origem" TextAlignment="TopLeft" SizeF="51.04167,13" LocationFloat="344.4388, 10.00454" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Artigo">
              <StylePriority Ref="154" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="155" ControlType="XRLabel" Name="lblArtigo1" Text="Artigo" TextAlignment="TopLeft" SizeF="52.09093,13" LocationFloat="0, 10.00455" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Artigo">
              <StylePriority Ref="156" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="157" ControlType="XRLabel" Name="lblLocalizacao1" Text="Local " TextAlignment="TopLeft" SizeF="82.2226,13" LocationFloat="566.7189, 9.999935" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Local ">
              <StylePriority Ref="158" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="159" ControlType="XRLine" Name="XrLine3" SizeF="743.06,2.89" LocationFloat="2.001254, 28.04394" />
            <Item5 Ref="160" ControlType="XRLabel" Name="lblUni1" Text="Uni." TextAlignment="TopRight" SizeF="45.84589,13.00453" LocationFloat="703.1369, 9.995429" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="161" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item5>
            <Item6 Ref="162" ControlType="XRLabel" Name="lblQuantidade1" Text="Qtd." TextAlignment="TopRight" SizeF="52.19537,13" LocationFloat="650.9415, 9.999943" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="163" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="164" ControlType="XRLabel" Name="lblDescricao1" Text="Descrição" TextAlignment="TopLeft" SizeF="267.3478,13" LocationFloat="77.09093, 10.00455" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="165" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="166" ControlType="XRLabel" Name="lblLote1" Text="Lote" TextAlignment="TopLeft" SizeF="83.68509,13" LocationFloat="395.4805, 9.99543" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Lote">
              <StylePriority Ref="167" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item8>
            <Item9 Ref="168" ControlType="XRLabel" Name="lblArmazem1" Text="Armazem" TextAlignment="TopLeft" SizeF="81.96033,13" LocationFloat="482.4602, 9.995436" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Armazem">
              <StylePriority Ref="169" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item9>
          </Controls>
          <ExpressionBindings>
            <Item1 Ref="170" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , true, false)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item5>
        <Item6 Ref="171" ControlType="SubBand" Name="SubBand9" HeightF="23">
          <Controls>
            <Item1 Ref="172" ControlType="XRLabel" Name="lblTransporte" TextFormatString="{0:0.00}" TextAlignment="MiddleLeft" SizeF="187.58,12" LocationFloat="552.2, 5" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <Scripts Ref="173" OnSummaryGetResult="lblTransporte_SummaryGetResult" OnPrintOnPage="lblTransporte_PrintOnPage" />
              <Summary Ref="174" Running="Page" IgnoreNullValues="true" />
              <StylePriority Ref="175" UseFont="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="176" ControlType="XRLabel" Name="lblTituloTransporte" Text="Transporte" TextAlignment="MiddleRight" SizeF="78.96,12" LocationFloat="472.2, 5" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <Scripts Ref="177" OnPrintOnPage="lblTituloTransporte_PrintOnPage" />
              <StylePriority Ref="178" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
          </Controls>
        </Item6>
      </SubBands>
    </Item3>
    <Item4 Ref="179" ControlType="DetailBand" Name="Detail" KeepTogetherWithDetailReports="true" SnapLinePadding="0,0,0,0,100" HeightF="0" KeepTogether="true" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item5 Ref="180" ControlType="DetailReportBand" Name="DRValorizado" Level="0" FilterString="[ID] = ?IDDocumento" DataMember="tbDocumentosCompras" DataSource="#Ref-0" Visible="false">
      <Bands>
        <Item1 Ref="181" ControlType="DetailBand" Name="Detail2" HeightF="13.87496" KeepTogether="true">
          <SubBands>
            <Item1 Ref="182" ControlType="SubBand" Name="SubBandValorizado" HeightF="2.083333">
              <Controls>
                <Item1 Ref="183" ControlType="XRSubreport" Name="sbrValorizado" ReportSourceUrl="30000" CanShrink="true" SizeF="747.0002,2.083333" LocationFloat="0, 0">
                  <ParameterBindings>
                    <Item1 Ref="184" ParameterName="IDDocumento" Parameter="#Ref-4" />
                    <Item2 Ref="185" ParameterName="IDLinha" DataMember="tbDocumentosCompras.tbDocumentosComprasLinhas_ID" />
                    <Item3 Ref="186" ParameterName="CasasDecimais" DataMember="tbDocumentosCompras.NumCasasDecUnidade" />
                    <Item4 Ref="187" ParameterName="CasasMoedas" DataMember="tbDocumentosCompras.tbMoedas_CasasDecimaisTotais" />
                    <Item5 Ref="188" ParameterName="SimboloMoedas" Parameter="#Ref-20" />
                    <Item6 Ref="189" ParameterName="BDEmpresa" Parameter="#Ref-8" />
                    <Item7 Ref="190" ParameterName="CasasDecimaisPrecosUnit" DataMember="tbDocumentosCompras.tbMoedas_CasasDecimaisPrecosUnitarios" />
                  </ParameterBindings>
                </Item1>
              </Controls>
            </Item1>
          </SubBands>
          <Controls>
            <Item1 Ref="191" ControlType="XRLabel" Name="fldRunningSum" TextFormatString="{0:0.00}" CanGrow="false" CanShrink="true" SizeF="2,2" LocationFloat="0, 0" ForeColor="Black" Padding="0,0,0,0,100">
              <Scripts Ref="192" OnSummaryCalculated="fldRunningSum_SummaryCalculated" />
              <Summary Ref="193" Running="Page" IgnoreNullValues="true" />
              <ExpressionBindings>
                <Item1 Ref="194" Expression="sumRunningSum([PrecoTotal])" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="195" UseForeColor="false" UsePadding="false" />
            </Item1>
            <Item2 Ref="196" ControlType="XRLabel" Name="XrLabel8" Text="XrLabel8" SizeF="55.0218,11.99999" LocationFloat="231.9156, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="197" Expression="[DocumentoOrigem]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="198" UseFont="false" />
            </Item2>
            <Item3 Ref="199" ControlType="XRLabel" Name="fldDesconto2" Text="fldDesconto2" TextAlignment="TopRight" SizeF="39.11041,12.1827" LocationFloat="609.8311, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="200" Expression="FormatString(''''{0:n'''' + 2 + ''''}'''', [Desconto2])&#xA;" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="201" UseFont="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="202" ControlType="XRLabel" Name="fldDesconto1" Text="fldDesconto1" TextAlignment="TopRight" SizeF="40.16681,12.1827" LocationFloat="568.7189, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="203" Expression="FormatString(''''{0:n'''' + 2 + ''''}'''', [Desconto1])" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="204" UseFont="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="205" ControlType="XRLabel" Name="XrLabel1" Text="XrLabel1" SizeF="179.8247,12.99998" LocationFloat="52.09093, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="206" Expression="[Descricao]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="207" UseFont="false" />
            </Item5>
            <Item6 Ref="208" ControlType="XRLabel" Name="fldLocalizacaoValoriza" TextAlignment="TopLeft" SizeF="51.64383,12.99998" LocationFloat="395.4805, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="209" Expression="Iif( IsNullOrEmpty([tbArmazensLocalizacoes_Codigo]) , [tbArmazensLocalizacoes1_Codigo] , [tbArmazensLocalizacoes_Codigo]) " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="210" UseFont="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="211" ControlType="XRLabel" Name="fldArmazemValoriza" TextAlignment="TopLeft" SizeF="50.43265,12.99998" LocationFloat="341.778, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="212" Expression="Iif (IsNullOrEmpty([tbArmazens_Codigo]), [tbArmazens1_CodigoDestino] , [tbArmazens_Codigo])" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="213" UseFont="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="214" ControlType="XRLabel" Name="XrLabel40" Text="XrLabel40" TextAlignment="TopRight" SizeF="26.29852,12.99998" LocationFloat="493.1264, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="215" Expression="[CodigoUnidade]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="216" UseFont="false" UseTextAlignment="false" />
            </Item8>
            <Item9 Ref="217" ControlType="XRLabel" Name="fldCodigoLote" Text="fldCodigoLote" SizeF="54.84055,12.99998" LocationFloat="286.9375, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="218" Expression="[CodigoLote]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="219" UseFont="false" />
            </Item9>
            <Item10 Ref="220" ControlType="XRLabel" Name="fldTaxaIVA" TextFormatString="{0:0.00}" TextAlignment="TopRight" SizeF="49.53473,12.99998" LocationFloat="699.09, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="221" Expression="Iif(IsNullOrEmpty( [tbMoedas_CasasDecimaisIva] ), 0 , FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisIva]  + ''''}'''', [TaxaIva])) " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="222" UseFont="false" UseTextAlignment="false" />
            </Item10>
            <Item11 Ref="223" ControlType="XRLabel" Name="fldPreco" TextFormatString="{0:0.00}" TextAlignment="TopRight" SizeF="48.06677,12.99998" LocationFloat="518.652, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="224" Expression="Iif(IsNullOrEmpty([tbMoedas_CasasDecimaisPrecosUnitarios]), 0 , FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisPrecosUnitarios] + ''''}'''', [PrecoUnitario])) " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="225" UseFont="false" UseTextAlignment="false" />
            </Item11>
            <Item12 Ref="226" ControlType="XRLabel" Name="fldTotalFinal" TextFormatString="{0:0.00}" TextAlignment="TopRight" SizeF="50.41821,12.99998" LocationFloat="649.7188, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="227" Expression="Iif(IsNullOrEmpty( [tbMoedas_CasasDecimaisTotais] ), 0 , FormatString(''''{0:n'''' +  [tbMoedas_CasasDecimaisTotais]  + ''''}'''', [PrecoTotal])) &#xA;" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="228" UseFont="false" UseTextAlignment="false" />
            </Item12>
            <Item13 Ref="229" ControlType="XRLabel" Name="fldQuantidade" TextAlignment="TopRight" SizeF="46.00211,12.99998" LocationFloat="447.1243, 0" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="230" Expression="[Quantidade]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="231" UseFont="false" UseTextAlignment="false" />
            </Item13>
            <Item14 Ref="232" ControlType="XRLabel" Name="fldArtigo" Text="XrLabel1" SizeF="51.06964,12.99998" LocationFloat="1.02129, 0" Font="Arial, 6.75pt" ForeColor="Black" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="233" Expression="[tbArtigos_Codigo]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="234" UseFont="false" UseForeColor="false" />
            </Item14>
          </Controls>
        </Item1>
      </Bands>
      <ExpressionBindings>
        <Item1 Ref="235" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
      </ExpressionBindings>
    </Item5>
    <Item6 Ref="236" ControlType="DetailReportBand" Name="DRNaoValorizado" Level="1" FilterString="[ID] = ?IDDocumento" DataMember="tbDocumentosCompras" DataSource="#Ref-0" Visible="false">
      <Bands>
        <Item1 Ref="237" ControlType="DetailBand" Name="Detail3" HeightF="17.12497" KeepTogether="true">
          <SubBands>
            <Item1 Ref="238" ControlType="SubBand" Name="SubBandNaoValorizado" HeightF="2.083333">
              <Controls>
                <Item1 Ref="239" ControlType="XRSubreport" Name="sbrNaoValorizado" ReportSourceUrl="40000" CanShrink="true" SizeF="747.0002,2.083333" LocationFloat="1.351293, 0">
                  <ParameterBindings>
                    <Item1 Ref="240" ParameterName="IDDocumento" Parameter="#Ref-4" />
                    <Item2 Ref="241" ParameterName="IDLinha" DataMember="tbDocumentosCompras.tbDocumentosComprasLinhas_ID" />
                    <Item3 Ref="242" ParameterName="CasasDecimais" DataMember="tbDocumentosCompras.NumCasasDecUnidade" />
                    <Item4 Ref="243" ParameterName="CasasMoedas" DataMember="tbDocumentosCompras.tbMoedas_CasasDecimaisTotais" />
                    <Item5 Ref="244" ParameterName="SimboloMoedas" Parameter="#Ref-20" />
                    <Item6 Ref="245" ParameterName="BDEmpresa" Parameter="#Ref-8" />
                  </ParameterBindings>
                </Item1>
              </Controls>
            </Item1>
          </SubBands>
          <Controls>
            <Item1 Ref="246" ControlType="XRLabel" Name="XrLabel9" Text="XrLabel8" SizeF="51.04166,12.99994" LocationFloat="355.2106, 2.04168" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="247" Expression="[DocumentoOrigem]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="248" UseFont="false" />
            </Item1>
            <Item2 Ref="249" ControlType="XRLabel" Name="fldCodigoLote1" Text="fldCodigoLote" SizeF="71.91321,12.99998" LocationFloat="406.2523, 2.041681" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="250" Expression="[CodigoLote]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="251" UseFont="false" />
            </Item2>
            <Item3 Ref="252" ControlType="XRLabel" Name="XrLabel2" Text="XrLabel2" SizeF="278.1197,13.04158" LocationFloat="77.09093, 2.000046" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="253" Expression="[Descricao]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="254" UseFont="false" />
            </Item3>
            <Item4 Ref="255" ControlType="XRLabel" Name="fldLocalizacao1Valoriza" SizeF="82.2226,14.04165" LocationFloat="566.7189, 1.999977" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="256" Expression="Iif( IsNullOrEmpty([tbArmazensLocalizacoes_Codigo]) , [tbArmazensLocalizacoes1_Codigo] , [tbArmazensLocalizacoes_Codigo]) " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="257" UseFont="false" />
            </Item4>
            <Item5 Ref="258" ControlType="XRLabel" Name="fldArtigo1" Text="XrLabel1" SizeF="76.0909,14.04165" LocationFloat="1.000023, 1.999982" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="259" Expression="[tbArtigos_Codigo]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="260" UseFont="false" />
            </Item5>
            <Item6 Ref="261" ControlType="XRLabel" Name="fldQuantidade2" Text="XrLabel3" TextAlignment="TopRight" SizeF="52.41803,14.04165" LocationFloat="650.7188, 2" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="262" Expression="[Quantidade]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="263" UseFont="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="264" ControlType="XRLabel" Name="fldUnidade" Text="XrLabel40" TextAlignment="TopRight" SizeF="45.86334,14.04165" LocationFloat="704.1367, 2" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="265" Expression="[CodigoUnidade]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="266" UseFont="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="267" ControlType="XRLabel" Name="fldArmazem1Valoriza" SizeF="81.96033,14.04165" LocationFloat="482.4602, 1.999977" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="268" Expression="Iif (IsNullOrEmpty([tbArmazens_Codigo]), [tbArmazens1_CodigoDestino] , [tbArmazens_Codigo])" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="269" UseFont="false" />
            </Item8>
          </Controls>
        </Item1>
      </Bands>
      <ExpressionBindings>
        <Item1 Ref="270" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , true, false)" PropertyName="Visible" EventName="BeforePrint" />
      </ExpressionBindings>
    </Item6>
    <Item7 Ref="271" ControlType="ReportFooterBand" Name="ReportFooter" PrintAtBottom="true" HeightF="77.63" KeepTogether="true">
      <SubBands>
        <Item1 Ref="272" ControlType="SubBand" Name="SubBand2" HeightF="66.25" KeepTogether="true">
          <Controls>
            <Item1 Ref="273" ControlType="XRLine" Name="XrLine4" SizeF="746.98,2.041214" LocationFloat="0, 0" />
            <Item2 Ref="274" ControlType="XRSubreport" Name="XrSubreport3" ReportSourceUrl="20000" SizeF="445.76,60.00002" LocationFloat="2.32, 4.16">
              <ParameterBindings>
                <Item1 Ref="275" ParameterName="IDDocumento" Parameter="#Ref-4" />
                <Item2 Ref="276" ParameterName="Culture" Parameter="#Ref-6" />
                <Item3 Ref="277" ParameterName="BDEmpresa" Parameter="#Ref-8" />
              </ParameterBindings>
            </Item2>
          </Controls>
          <ExpressionBindings>
            <Item1 Ref="278" Expression="iif([tbTiposDocumento_DocNaoValorizado], false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item1>
        <Item2 Ref="279" ControlType="SubBand" Name="SubBand4" HeightF="27.58" KeepTogether="true">
          <Controls>
            <Item1 Ref="280" ControlType="XRLabel" Name="lblCopia2" TextAlignment="MiddleRight" SizeF="433.068,13" LocationFloat="310.99, 0" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="281" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="282" ControlType="XRLabel" Name="fldMensagemDocAT" TextAlignment="MiddleRight" SizeF="433.068,13" LocationFloat="311, 12.5" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="283" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="284" ControlType="XRLabel" Name="fldassinaturanaoval" TextAlignment="MiddleLeft" SizeF="517.0739,13" LocationFloat="0, 12.5" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="285" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item3>
          </Controls>
          <ExpressionBindings>
            <Item1 Ref="286" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , true, false)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item2>
        <Item3 Ref="287" ControlType="SubBand" Name="SubBand6" HeightF="53.52" KeepTogether="true">
          <Controls>
            <Item1 Ref="288" ControlType="XRLine" Name="XrLine9" SizeF="738.94,2.08" LocationFloat="0, 0" Padding="0,0,0,0,100">
              <StylePriority Ref="289" UsePadding="false" />
            </Item1>
            <Item2 Ref="290" ControlType="XRLabel" Name="lblCarga" Text="Carga" TextAlignment="TopLeft" SizeF="200,12" LocationFloat="1.34, 3.44" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Carga">
              <StylePriority Ref="291" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="292" ControlType="XRLabel" Name="lblDescarga" Text="Descarga" TextAlignment="TopLeft" SizeF="200,12" LocationFloat="201.96, 3.44" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Descarga">
              <StylePriority Ref="293" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="294" ControlType="XRLabel" Name="lblExpedicao" Text="Matrícula" TextAlignment="TopLeft" SizeF="121.83,12" LocationFloat="403.21, 3.44" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Espedicao">
              <StylePriority Ref="295" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="296" ControlType="XRLabel" Name="XrLabel30" Text="XrLabel12" SizeF="121.83,12" LocationFloat="403.21, 15.44" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="297" Expression="[Matricula]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="298" UseFont="false" />
            </Item5>
            <Item6 Ref="299" ControlType="XRLabel" Name="XrLabel41" Text="XrLabel11" SizeF="200,12" LocationFloat="201.96, 15.44" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="300" Expression="[MoradaDescarga]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="301" UseFont="false" />
            </Item6>
            <Item7 Ref="302" ControlType="XRLabel" Name="XrLabel42" Text="XrLabel5" SizeF="200,12" LocationFloat="1.34, 15.44" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="303" Expression="[MoradaCarga]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="304" UseFont="false" />
            </Item7>
            <Item8 Ref="305" ControlType="XRLabel" Name="fldCodigoPostalCarga" Text="fldCodigoPostalCarga" SizeF="200,12" LocationFloat="1.34, 27.44" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="306" Expression="[tbCodigosPostaisCarga_Codigo] + '''' '''' + [tbCodigosPostaisCarga_Descricao] " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="307" UseFont="false" />
            </Item8>
            <Item9 Ref="308" ControlType="XRLabel" Name="fldDataCarga" TextFormatString="{0:dd-MM-yyyy HH:mm}" SizeF="200,12" LocationFloat="1.34, 39.44" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="309" Expression="[DataCarga]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="310" UseFont="false" />
            </Item9>
            <Item10 Ref="311" ControlType="XRLabel" Name="fldCodigoPostalDescarga" Text="fldCodigoPostalDescarga" SizeF="200,12" LocationFloat="201.97, 27.44" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="312" Expression="[tbCodigosPostaisDescarga_Codigo] + '''' '''' + [tbCodigosPostaisDescarga_Descricao] " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="313" UseFont="false" />
            </Item10>
            <Item11 Ref="314" ControlType="XRLabel" Name="fldDataDescarga" TextFormatString="{0:dd-MM-yyyy HH:mm}" SizeF="200,12" LocationFloat="201.96, 39.44" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="315" Expression="[DataDescarga]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="316" UseFont="false" />
            </Item11>
          </Controls>
          <ExpressionBindings>
            <Item1 Ref="317" Expression="iif( not [tbTiposDocumento_AcompanhaBensCirculacao] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item3>
        <Item4 Ref="318" ControlType="SubBand" Name="SubBand7" HeightF="36.96" KeepTogether="true">
          <Controls>
            <Item1 Ref="319" ControlType="XRLine" Name="XrLine8" SizeF="738.94,2.08" LocationFloat="0, 3.17" />
            <Item2 Ref="320" ControlType="XRLabel" Name="lblObservacoes" Text="Observações" TextAlignment="MiddleLeft" SizeF="90.12,12" LocationFloat="0, 5.17" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Observacoes">
              <StylePriority Ref="321" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="322" ControlType="XRLabel" Name="fldObservacoes" Multiline="true" TextAlignment="TopLeft" SizeF="742.9999,18.19" LocationFloat="0, 16.69" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Observacoes">
              <ExpressionBindings>
                <Item1 Ref="323" Expression="[Observacoes] " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="324" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item3>
          </Controls>
        </Item4>
      </SubBands>
      <Controls>
        <Item1 Ref="325" ControlType="XRLabel" Name="lblCopia1" TextAlignment="MiddleRight" SizeF="433.068,13" LocationFloat="310.99, 1.75" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="326" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="327" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="328" ControlType="XRLabel" Name="lblTotalMoedaDocumento" TextAlignment="TopRight" SizeF="121.383,17" LocationFloat="617.57, 31.95" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="329" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="330" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="331" ControlType="XRLabel" Name="fldDescontosLinha" TextAlignment="TopRight" SizeF="87.00002,20.9583" LocationFloat="288.18, 48.95" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="332" Expression="Iif(IsNullOrEmpty([tbMoedas_CasasDecimaisTotais] ), 0 , FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisTotais]  + ''''}'''', [ValorDescontoLinha_Sum])) &#xA;" PropertyName="Text" EventName="BeforePrint" />
            <Item2 Ref="333" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="334" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item3>
        <Item4 Ref="335" ControlType="XRLabel" Name="fldDescontoGlobal" TextAlignment="TopRight" SizeF="87.00002,20.96" LocationFloat="376.18, 48.95" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="336" Expression="Iif(IsNullOrEmpty( [tbMoedas_CasasDecimaisTotais] ), 0 , FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisTotais]  + ''''}'''', [ValorDesconto])) &#xA;" PropertyName="Text" EventName="BeforePrint" />
            <Item2 Ref="337" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="338" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item4>
        <Item5 Ref="339" ControlType="XRLabel" Name="fldTotalIva" TextFormatString="{0:€0.00}" TextAlignment="TopRight" SizeF="85.80151,20.9583" LocationFloat="465.38, 48.95" Font="Arial, 6.75pt" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="340" Expression="Iif(IsNullOrEmpty([tbMoedas_CasasDecimaisIva]), 0 , FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisIva] + ''''}'''', [ValorImposto])) " PropertyName="Text" EventName="BeforePrint" />
            <Item2 Ref="341" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="342" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item5>
        <Item6 Ref="343" ControlType="XRLabel" Name="fldTotalMoedaDocumento" TextAlignment="TopRight" SizeF="176.209,25.59814" LocationFloat="562.75, 48.95" Font="Arial, 14.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="344" Expression="Iif(IsNullOrEmpty([tbMoedas_CasasDecimaisTotais]), 0 , FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisTotais] + ''''}'''', [TotalMoedaDocumento])) " PropertyName="Text" EventName="BeforePrint" />
            <Item2 Ref="345" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="346" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item6>
        <Item7 Ref="347" ControlType="XRLabel" Name="fldSubTotal" TextFormatString="{0:€0.00}" TextAlignment="TopRight" SizeF="87.25985,20.95646" LocationFloat="199.92, 54.16" Font="Arial, 6.75pt" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="348" Expression="Iif(IsNullOrEmpty([tbMoedas_CasasDecimaisTotais]), 0 , FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisTotais] + ''''}'''', [SubTotal])) " PropertyName="Text" EventName="BeforePrint" />
            <Item2 Ref="349" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="350" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item7>
        <Item8 Ref="351" ControlType="XRLabel" Name="XrLabel4" SizeF="190,46" LocationFloat="555.07, 29.55" BackColor="Gainsboro" Padding="2,2,0,0,100" Borders="None" BorderWidth="1">
          <ExpressionBindings>
            <Item1 Ref="352" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="353" UseBackColor="false" UseBorders="false" UseBorderWidth="false" />
        </Item8>
        <Item9 Ref="354" ControlType="XRLabel" Name="lblDescontosLinha" TextAlignment="TopRight" SizeF="87.25985,16" LocationFloat="287.92, 31.95" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="355" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="356" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item9>
        <Item10 Ref="357" ControlType="XRLabel" Name="lblDescontoGlobal" TextAlignment="TopRight" SizeF="87.25984,16" LocationFloat="375.92, 31.95" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="358" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="359" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item10>
        <Item11 Ref="360" ControlType="XRLabel" Name="lblTotalIva" TextAlignment="TopRight" SizeF="86.80161,15.99816" LocationFloat="464.38, 31.95" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="361" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="362" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item11>
        <Item12 Ref="363" ControlType="XRLabel" Name="lblSubTotal" TextAlignment="TopRight" SizeF="87.75003,16" LocationFloat="199.43, 37.16" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="364" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="365" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item12>
        <Item13 Ref="366" ControlType="XRLine" Name="XrLine5" SizeF="747.0004,2" LocationFloat="0, 27.56">
          <ExpressionBindings>
            <Item1 Ref="367" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item13>
        <Item14 Ref="368" ControlType="XRLabel" Name="fldMensagemDocAT1" TextAlignment="MiddleRight" SizeF="433.068,13" LocationFloat="311.99, 14.56" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="369" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="370" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item14>
        <Item15 Ref="371" ControlType="XRLabel" Name="fldAssinatura" TextAlignment="MiddleLeft" SizeF="433.1161,13" LocationFloat="0, 14.56" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <ExpressionBindings>
            <Item1 Ref="372" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , false, true)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="373" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item15>
      </Controls>
    </Item7>
    <Item8 Ref="374" ControlType="PageFooterBand" Name="PageFooter" HeightF="38.33">
      <SubBands>
        <Item1 Ref="375" ControlType="SubBand" Name="SubBand3" HeightF="19.08">
          <Controls>
            <Item1 Ref="376" ControlType="XRLine" Name="XrLine6" LineWidth="2" SizeF="742.98,4" LocationFloat="0, 0" BorderWidth="3">
              <StylePriority Ref="377" UseBorderWidth="false" />
            </Item1>
            <Item2 Ref="378" ControlType="XRPageInfo" Name="XrPageInfo2" TextFormatString="Página {0} de {1}" TextAlignment="MiddleRight" SizeF="121,13" LocationFloat="625.4193, 4.000028" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100">
              <StylePriority Ref="379" UseFont="false" UseTextAlignment="false" />
            </Item2>
          </Controls>
        </Item1>
      </SubBands>
      <Controls>
        <Item1 Ref="380" ControlType="XRLabel" Name="lblCopia3" TextAlignment="MiddleRight" SizeF="445.7733,13" LocationFloat="300.64, 11.61" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <Scripts Ref="381" OnPrintOnPage="fldAssinatura11_PrintOnPage" />
          <StylePriority Ref="382" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="383" ControlType="XRLabel" Name="lblTransportar" TextFormatString="{0:0.00}" TextAlignment="MiddleLeft" SizeF="187.58,12" LocationFloat="552.2, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <Scripts Ref="384" OnSummaryGetResult="lblTransportar_SummaryGetResult" OnPrintOnPage="lblTransportar_PrintOnPage" />
          <Summary Ref="385" Running="Page" IgnoreNullValues="true" />
          <StylePriority Ref="386" UseFont="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="387" ControlType="XRLabel" Name="lblTituloTransportar" Text="Transportar" TextAlignment="MiddleRight" SizeF="78.96,12" LocationFloat="472.2, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <Scripts Ref="388" OnPrintOnPage="lblTituloTransportar_PrintOnPage" />
          <StylePriority Ref="389" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item3>
        <Item4 Ref="390" ControlType="XRLabel" Name="fldAssinatura11" TextAlignment="MiddleRight" SizeF="445.7733,13" LocationFloat="300.646, 24.7" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <Scripts Ref="391" OnPrintOnPage="fldAssinatura11_PrintOnPage" />
          <StylePriority Ref="392" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item4>
        <Item5 Ref="393" ControlType="XRLabel" Name="fldAssinatura1" TextAlignment="MiddleLeft" SizeF="445.7733,13" LocationFloat="1.351039, 24.7" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <Scripts Ref="394" OnPrintOnPage="fldAssinatura1_PrintOnPage" />
          <StylePriority Ref="395" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item5>
      </Controls>
    </Item8>
    <Item9 Ref="396" ControlType="BottomMarginBand" Name="BottomMargin" HeightF="1" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
  </Bands>
  <Scripts Ref="397" OnBeforePrint="Documentos_Compras_BeforePrint" />
  <ExportOptions Ref="398">
    <Html Ref="399" ExportMode="SingleFilePageByPage" />
  </ExportOptions>
  <Watermark Ref="400" ShowBehind="false" Text="CONFIDENTIAL" Font="Arial, 96pt" />
  <ExpressionBindings>
    <Item1 Ref="401" Expression="([tbSistemaTiposDocumento_Tipo] != ''''CmpFinanceiro''''  And &#xA;([TipoFiscal] != ''''FT'''' Or [TipoFiscal] != ''''FR'''' Or &#xA;[TipoFiscal] != ''''FS'''' Or [TipoFiscal] != ''''NC'''' Or &#xA;[TipoFiscal] != ''''ND'''')) Or &#xA;([tbSistemaTiposDocumento_Tipo] != ''''CmpTransporte''''  And &#xA;([TipoFiscal] != ''''NF'''' Or [TipoFiscal] != ''''GR'''' Or &#xA;[TipoFiscal] != ''''GT''''))" PropertyName="Visible" EventName="BeforePrint" />
  </ExpressionBindings>
  <ObjectStorage>
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="3" Content="System.Int64" Type="System.Type" />
    <Item2 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="10" Content="System.Int32" Type="System.Type" />
    <Item3 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="14" Content="System.Boolean" Type="System.Type" />
    <Item4 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="17" Content="System.Int16" Type="System.Type" />
    <Item5 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Name="SqlDataSource" Base64="PFNxbERhdGFTb3VyY2UgTmFtZT0iU3FsRGF0YVNvdXJjZSI+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9RjNNLVBDMTQzXEYzTTIwMTc7VXNlciBJRD1GM01PO1Bhc3N3b3JkPTtJbml0aWFsIENhdGFsb2cgPTI4MTRGM01POyIgLz48UXVlcnkgVHlwZT0iQ3VzdG9tU3FsUXVlcnkiIE5hbWU9InRiRG9jdW1lbnRvc0NvbXByYXMiPjxQYXJhbWV0ZXIgTmFtZT0iSUREb2N1bWVudG8iIFR5cGU9IkRldkV4cHJlc3MuRGF0YUFjY2Vzcy5FeHByZXNzaW9uIj4oU3lzdGVtLkludDY0LCBtc2NvcmxpYiwgVmVyc2lvbj00LjAuMC4wLCBDdWx0dXJlPW5ldXRyYWwsIFB1YmxpY0tleVRva2VuPWI3N2E1YzU2MTkzNGUwODkpKD9JRERvY3VtZW50byk8L1BhcmFtZXRlcj48U3FsPnNlbGVjdCBkaXN0aW5jdCAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRCIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFRpcG9Eb2N1bWVudG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJOdW1lcm9Eb2N1bWVudG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhRG9jdW1lbnRvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iT2JzZXJ2YWNvZXMiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRE1vZWRhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVGF4YUNvbnZlcnNhbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIlRvdGFsTW9lZGFEb2N1bWVudG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJUb3RhbE1vZWRhUmVmZXJlbmNpYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkxvY2FsQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJIb3JhQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJNb3JhZGFDYXJnYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29kaWdvUG9zdGFsQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvbmNlbGhvQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRERpc3RyaXRvQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJMb2NhbERlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YURlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSG9yYURlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTW9yYWRhRGVzY2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvZGlnb1Bvc3RhbERlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb25jZWxob0Rlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSUREaXN0cml0b0Rlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTm9tZURlc3RpbmF0YXJpbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1vcmFkYURlc3RpbmF0YXJpbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29kaWdvUG9zdGFsRGVzdGluYXRhcmlvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb25jZWxob0Rlc3RpbmF0YXJpbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERGlzdHJpdG9EZXN0aW5hdGFyaW8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJTZXJpZURvY01hbnVhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIk51bWVyb0RvY01hbnVhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIk51bWVyb0xpbmhhcyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIlBvc3RvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURFc3RhZG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJVdGlsaXphZG9yRXN0YWRvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YUhvcmFFc3RhZG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJBc3NpbmF0dXJhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVmVyc2FvQ2hhdmVQcml2YWRhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTm9tZUZpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1vcmFkYUZpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29kaWdvUG9zdGFsRmlzY2FsIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb25jZWxob0Zpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERGlzdHJpdG9GaXNjYWwiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb250cmlidWludGVGaXNjYWwiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJTaWdsYVBhaXNGaXNjYWwiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRExvamEiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJbXByZXNzbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIlZhbG9ySW1wb3N0byIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIlBlcmNlbnRhZ2VtRGVzY29udG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJWYWxvckRlc2NvbnRvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVmFsb3JQb3J0ZXMiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFRheGFJdmFQb3J0ZXMiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJUYXhhSXZhUG9ydGVzIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTW90aXZvSXNlbmNhb0l2YSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1vdGl2b0lzZW5jYW9Qb3J0ZXMiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJREVzcGFjb0Zpc2NhbFBvcnRlcyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkVzcGFjb0Zpc2NhbFBvcnRlcyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEUmVnaW1lSXZhUG9ydGVzIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iUmVnaW1lSXZhUG9ydGVzIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ3VzdG9zQWRpY2lvbmFpcyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIlNpc3RlbWEiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJBdGl2byIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRhdGFDcmlhY2FvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVXRpbGl6YWRvckNyaWFjYW8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhQWx0ZXJhY2FvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVXRpbGl6YWRvckFsdGVyYWNhbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkYzTU1hcmNhZG9yIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURGb3JtYUV4cGVkaWNhbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEVGlwb3NEb2N1bWVudG9TZXJpZXMiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJOdW1lcm9JbnRlcm5vIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURFbnRpZGFkZSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEVGlwb0VudGlkYWRlIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb25kaWNhb1BhZ2FtZW50byIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklETG9jYWxPcGVyYWNhbyIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb0FUIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURQYWlzQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFBhaXNEZXNjYXJnYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1hdHJpY3VsYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEUGFpc0Zpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1Bvc3RhbEZpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRlc2NyaWNhb0NvZGlnb1Bvc3RhbEZpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRlc2NyaWNhb0NvbmNlbGhvRmlzY2FsIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGVzY3JpY2FvRGlzdHJpdG9GaXNjYWwiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJREVzcGFjb0Zpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEUmVnaW1lSXZhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29kaWdvQVRJbnRlcm5vIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVGlwb0Zpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRvY3VtZW50byIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1RpcG9Fc3RhZG8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29Eb2NPcmlnZW0iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEaXN0cml0b0NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29uY2VsaG9DYXJnYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1Bvc3RhbENhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iU2lnbGFQYWlzQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEaXN0cml0b0Rlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29uY2VsaG9EZXNjYXJnYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1Bvc3RhbERlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iU2lnbGFQYWlzRGVzY2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29FbnRpZGFkZSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb01vZWRhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTWVuc2FnZW1Eb2NBVCIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEU2lzVGlwb3NEb2NQVSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1Npc1RpcG9zRG9jUFUiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEb2NNYW51YWwiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEb2NSZXBvc2ljYW8iLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhQXNzaW5hdHVyYSIsDQogICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRhdGFDb250cm9sb0ludGVybm8iLA0KCSJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YURvY3VtZW50byIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29UaXBvRXN0YWRvIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyIuIlNlZ3VuZGFWaWEiLA0KICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJJRCIgYXMgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNfSUQiLA0KCSAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIk9yZGVtIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklERG9jdW1lbnRvQ29tcHJhIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEQXJ0aWdvIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIkRlc2NyaWNhbyIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJJRFVuaWRhZGUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iTnVtQ2FzYXNEZWNVbmlkYWRlIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIlF1YW50aWRhZGUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iUHJlY29Vbml0YXJpbyIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJQcmVjb1VuaXRhcmlvRWZldGl2byIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJQcmVjb1RvdGFsIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIk9ic2VydmFjb2VzIiBhcyAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19PYnNlcnZhY29lcyIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJJRExvdGUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iQ29kaWdvTG90ZSIsDQoJICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iQ29kaWdvVW5pZGFkZSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJEZXNjcmljYW9Mb3RlIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIkRhdGFGYWJyaWNvTG90ZSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJEYXRhVmFsaWRhZGVMb3RlIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEQXJ0aWdvTnVtU2VyaWUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iQXJ0aWdvTnVtU2VyaWUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSURBcm1hemVtIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEQXJtYXplbUxvY2FsaXphY2FvIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEQXJtYXplbURlc3Rpbm8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSURBcm1hemVtTG9jYWxpemFjYW9EZXN0aW5vIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIk51bUxpbmhhc0RpbWVuc29lcyIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJEZXNjb250bzEiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iRGVzY29udG8yIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEVGF4YUl2YSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJUYXhhSXZhIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIk1vdGl2b0lzZW5jYW9JdmEiIGFzICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzX01vdGl2b0lzZW5jYW9JdmEiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSURFc3BhY29GaXNjYWwiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iRXNwYWNvRmlzY2FsIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEUmVnaW1lSXZhIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIlJlZ2ltZUl2YSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJTaWdsYVBhaXMiLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iT3JkZW0iLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iU2lzdGVtYSIgYXMgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNfU2lzdGVtYSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJBdGl2byIgYXMgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNfQXRpdm8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iRGF0YUNyaWFjYW8iIGFzICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzX0RhdGFDcmlhY2FvIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIlV0aWxpemFkb3JDcmlhY2FvIiBhcyAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19VdGlsaXphZG9yQ3JpYWNhbyIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJEYXRhQWx0ZXJhY2FvIiBhcyAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19EYXRhQWx0ZXJhY2FvIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIlV0aWxpemFkb3JBbHRlcmFjYW8iIGFzICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzX1V0aWxpemFkb3JBbHRlcmFjYW8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iRjNNTWFyY2Fkb3IiIGFzICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzX0YzTU1hcmNhZG9yIiwNCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIlZhbG9ySW5jaWRlbmNpYSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJWYWxvcklWQSIsDQogICAgICAgInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJEb2N1bWVudG9PcmlnZW0iLA0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iRGF0YUVudHJlZ2EiLA0KCSAidGJGb3JuZWNlZG9yZXMiLiJOb21lIiBhcyAidGJGb3JuZWNlZG9yZXNfTm9tZSIsDQoJICJ0YkZvcm5lY2Vkb3JlcyIuIkNvZGlnbyIgYXMgInRiRm9ybmVjZWRvcmVzX0NvZGlnbyIsDQoJICJ0YkZvcm5lY2Vkb3JlcyIuIk5Db250cmlidWludGUiIGFzICJ0YkZvcm5lY2Vkb3Jlc19OQ29udHJpYnVpbnRlIiwNCgkgInRiRm9ybmVjZWRvcmVzTW9yYWRhcyIuIk1vcmFkYSIgYXMgInRiRm9ybmVjZWRvcmVzTW9yYWRhc19Nb3JhZGEiLA0KCSAidGJDb2RpZ29zUG9zdGFpcyIuIkNvZGlnbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNDbGllbnRlX0NvZGlnbyIsDQoJICJ0YkNvZGlnb3NQb3N0YWlzIi4iRGVzY3JpY2FvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0NsaWVudGVfRGVzY3JpY2FvIiwNCiAgICAgICAidGJFc3RhZG9zIi4iQ29kaWdvIiBhcyAidGJFc3RhZG9zX0NvZGlnbyIsDQogICAgICAgInRiRXN0YWRvcyIuIkRlc2NyaWNhbyIgYXMgInRiRXN0YWRvc19EZXNjcmljYW8iLA0KICAgICAgICJ0YlRpcG9zRG9jdW1lbnRvIi4iQ29kaWdvIiBhcyAidGJUaXBvc0RvY3VtZW50b19Db2RpZ28iLA0KICAgICAgICJ0YlRpcG9zRG9jdW1lbnRvIi4iRGVzY3JpY2FvIiBhcyAidGJUaXBvc0RvY3VtZW50b19EZXNjcmljYW8iLA0KCSAidGJUaXBvc0RvY3VtZW50byIuIkRvY05hb1ZhbG9yaXphZG8iIGFzICJ0YlRpcG9zRG9jdW1lbnRvX0RvY05hb1ZhbG9yaXphZG8iLA0KCSAidGJUaXBvc0RvY3VtZW50byIuIkFjb21wYW5oYUJlbnNDaXJjdWxhY2FvIiBhcyAidGJUaXBvc0RvY3VtZW50b19BY29tcGFuaGFCZW5zQ2lyY3VsYWNhbyIsDQogICAgICAgInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiLiJDb2RpZ29TZXJpZSIsDQogICAgICAgInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiLiJEZXNjcmljYW9TZXJpZSIsDQogICAgICAgInRiQXJ0aWdvcyIuIkNvZGlnbyIgYXMgInRiQXJ0aWdvc19Db2RpZ28iLA0KICAgICAgICJ0YkFydGlnb3MiLiJEZXNjcmljYW9BYnJldmlhZGEiLA0KICAgICAgICJ0YkFydGlnb3MiLiJEZXNjcmljYW8iIGFzICJ0YkFydGlnb3NfRGVzY3JpY2FvIiwNCiAgICAgICAidGJBcnRpZ29zIi4iR2VyZUxvdGVzIiBhcyAidGJBcnRpZ29zX0dlcmVMb3RlcyIsDQogICAgICAgInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIi4iRGVzY3JpY2FvIiBhcyAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWxfRGVzY3JpY2FvIiwNCgkgInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIi4iVGlwbyIgYXMgInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvX1RpcG8iLA0KCSAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8iLiJEZXNjcmljYW8iIGFzICJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b19EZXNjcmljYW8iLA0KICAgICAgICJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIuIlRpcG8iLA0KICAgICAgICJ0YkNvZGlnb3NQb3N0YWlzMSIuIkNvZGlnbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNfQ29kaWdvIiwNCiAgICAgICAidGJDb2RpZ29zUG9zdGFpczEiLiJEZXNjcmljYW8iIGFzICJ0YkNvZGlnb3NQb3N0YWlzX0Rlc2NyaWNhbyIsDQogICAgICAgInRiQ29kaWdvc1Bvc3RhaXMyIi4iQ29kaWdvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0NhcmdhX0NvZGlnbyIsDQogICAgICAgInRiQ29kaWdvc1Bvc3RhaXMyIi4iRGVzY3JpY2FvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0NhcmdhX0Rlc2NyaWNhbyIsDQogICAgICAgInRiQ29kaWdvc1Bvc3RhaXMzIi4iQ29kaWdvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0Rlc2NhcmdhX0NvZGlnbyIsDQogICAgICAgInRiQ29kaWdvc1Bvc3RhaXMzIi4iRGVzY3JpY2FvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0Rlc2NhcmdhX0Rlc2NyaWNhbyIsDQogICAgICAgInRiTW9lZGFzIi4iQ29kaWdvIiBhcyAidGJNb2VkYXNfQ29kaWdvIiwNCiAgICAgICAidGJNb2VkYXMiLiJEZXNjcmljYW8iIGFzICJ0Yk1vZWRhc19EZXNjcmljYW8iLA0KICAgICAgICJ0Yk1vZWRhcyIuIlNpbWJvbG8iIGFzICJ0Yk1vZWRhc19TaW1ib2xvIiwNCgkgInRiQXJtYXplbnMiLiJEZXNjcmljYW8iIGFzICJ0YkFybWF6ZW5zX0Rlc2NyaWNhbyIsDQoJICJ0YkFybWF6ZW5zIi4iQ29kaWdvIiBhcyAidGJBcm1hemVuc19Db2RpZ28iLA0KCSAidGJBcm1hemVuc0xvY2FsaXphY29lcyIuIkRlc2NyaWNhbyIgYXMgInRiQXJtYXplbnNMb2NhbGl6YWNvZXNfRGVzY3JpY2FvIiwNCgkgInRiQXJtYXplbnNMb2NhbGl6YWNvZXMiLiJDb2RpZ28iIGFzICJ0YkFybWF6ZW5zTG9jYWxpemFjb2VzX0NvZGlnbyIsDQoJICJ0YkFybWF6ZW5zMSIuIkRlc2NyaWNhbyIgYXMgInRiQXJtYXplbnMxX0Rlc2NyaWNhb0Rlc3Rpbm8iLA0KCSAidGJBcm1hemVuczEiLiJDb2RpZ28iIGFzICJ0YkFybWF6ZW5zMV9Db2RpZ29EZXN0aW5vIiwNCgkgInRiQXJtYXplbnNMb2NhbGl6YWNvZXMxIi4iRGVzY3JpY2FvIiBhcyAidGJBcm1hemVuc0xvY2FsaXphY29lczFfRGVzY3JpY2FvIiwNCgkgInRiQXJtYXplbnNMb2NhbGl6YWNvZXMxIi4iQ29kaWdvIiBhcyAidGJBcm1hemVuc0xvY2FsaXphY29lczFfQ29kaWdvIiwNCiAgICAgICAidGJNb2VkYXMiLiJDYXNhc0RlY2ltYWlzVG90YWlzIiBhcyAidGJNb2VkYXNfQ2FzYXNEZWNpbWFpc1RvdGFpcyIsDQoJICAgInRiTW9lZGFzIi4iQ2FzYXNEZWNpbWFpc1ByZWNvc1VuaXRhcmlvcyIgYXMgInRiTW9lZGFzX0Nhc2FzRGVjaW1haXNQcmVjb3NVbml0YXJpb3MiLA0KCSAgICJ0Yk1vZWRhcyIuIkNhc2FzRGVjaW1haXNJdmEiIGFzICJ0Yk1vZWRhc19DYXNhc0RlY2ltYWlzSXZhIiwNCgkgInRiU2lzdGVtYUNvZGlnb3NJVkEiLiJDb2RpZ28iIGFzICJ0YlNpc3RlbWFDb2RpZ29zSVZBLkNvZGlnbyIsIA0KICAgICAgICJ0YlNpc3RlbWFNb2VkYXMiLiJDb2RpZ28iIGFzICJ0YlNpc3RlbWFNb2VkYXNfQ29kaWdvIiwNCgkgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJUb3RhbE1vZWRhRG9jdW1lbnRvIiAtICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVmFsb3JJbXBvc3RvIiBhcyAiU3ViVG90YWwiLA0KCSAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkNhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIgYXMgInRiUGFyYW1lbnRyb3NFbXByZXNhX0Nhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIsDQoJICJ0YlNpc3RlbWFOYXR1cmV6YXMiLkNvZGlnbyBhcyAidGJTaXN0ZW1hTmF0dXJlemFzX0NvZGlnbyINCiAgZnJvbSAiZGJvIi4idGJEb2N1bWVudG9zQ29tcHJhcyINCiAgICAgICAidGJEb2N1bWVudG9zQ29tcHJhcyINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIg0KICAgICAgICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIg0KICAgICAgIG9uICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSUREb2N1bWVudG9Db21wcmEiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRCINCiAgbGVmdCBqb2luICJkYm8iLiJ0YklWQSIgInRiSVZBIiBvbiAidGJJVkEiLiJJRCIgPSAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEVGF4YUl2YSINCiAgbGVmdCBqb2luIHRiU2lzdGVtYUNvZGlnb3NJVkEgb24gdGJJVkEuSURDb2RpZ29JVkEgPSB0YlNpc3RlbWFDb2RpZ29zSVZBLklEDQogIGxlZnQgam9pbiAiZGJvIi4idGJTaXN0ZW1hVGlwb3NJVkEiICJ0YlNpc3RlbWFUaXBvc0lWQSIgb24gInRiU2lzdGVtYVRpcG9zSVZBIi4iSUQiID0gInRiSVZBIi4iSURUaXBvSXZhIg0KICBsZWZ0IGpvaW4gImRibyIuInRiRm9ybmVjZWRvcmVzIiAidGJGb3JuZWNlZG9yZXMiDQogICAgICAgb24gInRiRm9ybmVjZWRvcmVzIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJREVudGlkYWRlIg0KICBsZWZ0IGpvaW4gImRibyIuICJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXMiICJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXMiDQoJICAgb24gInRiRm9ybmVjZWRvcmVzTW9yYWRhcyIuIklERm9ybmVjZWRvciIgPSAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERW50aWRhZGUiIGFuZCAidGJGb3JuZWNlZG9yZXNNb3JhZGFzIi4iT3JkZW0iPTENCiAgbGVmdCBqb2luICJkYm8iLiJ0YkNvZGlnb3NQb3N0YWlzIiAidGJDb2RpZ29zUG9zdGFpcyINCiAgICAgICBvbiAidGJDb2RpZ29zUG9zdGFpcyIuIklEIiA9ICJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXMiLiJJRENvZGlnb1Bvc3RhbCINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkVzdGFkb3MiICJ0YkVzdGFkb3MiDQogICAgICAgb24gInRiRXN0YWRvcyIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURFc3RhZG8iDQogIGxlZnQgam9pbiAiZGJvIi4idGJUaXBvc0RvY3VtZW50byINCiAgICAgICAidGJUaXBvc0RvY3VtZW50byINCiAgICAgICBvbiAidGJUaXBvc0RvY3VtZW50byIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURUaXBvRG9jdW1lbnRvIg0KICBsZWZ0IGpvaW4gImRibyIuInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiICJ0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIg0KICAgICAgIG9uICJ0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFRpcG9zRG9jdW1lbnRvU2VyaWVzIg0KCSAgICBsZWZ0IGpvaW4gImRibyIuInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIiAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8iDQogICAgICAgb24gInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIi4iSUQiID0gInRiVGlwb3NEb2N1bWVudG8iLiJJRFNpc3RlbWFUaXBvc0RvY3VtZW50byINCiAgbGVmdCBqb2luICJkYm8iLiJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIgInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIg0KICAgICAgIG9uICJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIuIklEIiA9ICJ0YlRpcG9zRG9jdW1lbnRvIi4iSURTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiDQogIGxlZnQgam9pbiAiZGJvIi4idGJTaXN0ZW1hTmF0dXJlemFzIiAidGJTaXN0ZW1hTmF0dXJlemFzIg0KICAgICAgIG9uICJ0YlNpc3RlbWFOYXR1cmV6YXMiLiJJRCIgPSAidGJUaXBvc0RvY3VtZW50byIuIklEU2lzdGVtYU5hdHVyZXphcyINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkFydGlnb3MiICJ0YkFydGlnb3MiDQogICAgICAgb24gInRiQXJ0aWdvcyIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSURBcnRpZ28iDQogIGxlZnQgam9pbiAiZGJvIi4idGJDb2RpZ29zUG9zdGFpcyIgInRiQ29kaWdvc1Bvc3RhaXMxIg0KICAgICAgIG9uICJ0YkNvZGlnb3NQb3N0YWlzMSIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb2RpZ29Qb3N0YWxGaXNjYWwiDQogIGxlZnQgam9pbiAiZGJvIi4idGJDb2RpZ29zUG9zdGFpcyIgInRiQ29kaWdvc1Bvc3RhaXMyIg0KICAgICAgIG9uICJ0YkNvZGlnb3NQb3N0YWlzMiIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb2RpZ29Qb3N0YWxDYXJnYSINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkNvZGlnb3NQb3N0YWlzIiAidGJDb2RpZ29zUG9zdGFpczMiDQogICAgICAgb24gInRiQ29kaWdvc1Bvc3RhaXMzIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvZGlnb1Bvc3RhbERlc2NhcmdhIg0KICBsZWZ0IGpvaW4gImRibyIuInRiTW9lZGFzIiAidGJNb2VkYXMiDQogICAgICAgb24gInRiTW9lZGFzIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRE1vZWRhIg0KICBsZWZ0IGpvaW4gInRiUGFyYW1ldHJvc0VtcHJlc2EiIA0KICAgICAgIG9uICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iSURNb2VkYURlZmVpdG8iID0gInRiTW9lZGFzIi4iSUQiIA0KICBsZWZ0IGpvaW4gImRibyIuInRiU2lzdGVtYU1vZWRhcyIgInRiU2lzdGVtYU1vZWRhcyINCiAgICAgICBvbiAidGJTaXN0ZW1hTW9lZGFzIi4iSUQiID0gInRiTW9lZGFzIi4iSURTaXN0ZW1hTW9lZGEiDQogIGxlZnQgam9pbiAiZGJvIi4idGJBcm1hemVucyIgInRiQXJtYXplbnMiDQogICAgICAgb24gInRiQXJtYXplbnMiLiJJRCIgPSAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklEQXJtYXplbSINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkFybWF6ZW5zTG9jYWxpemFjb2VzIiAidGJBcm1hemVuc0xvY2FsaXphY29lcyINCiAgICAgICBvbiAidGJBcm1hemVuc0xvY2FsaXphY29lcyIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSURBcm1hemVtTG9jYWxpemFjYW8iDQogIGxlZnQgam9pbiAiZGJvIi4idGJBcm1hemVucyIgInRiQXJtYXplbnMxIg0KICAgICAgIG9uICJ0YkFybWF6ZW5zMSIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iSURBcm1hemVtRGVzdGlubyINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkFybWF6ZW5zTG9jYWxpemFjb2VzIiAidGJBcm1hemVuc0xvY2FsaXphY29lczEiDQogICAgICAgb24gInRiQXJtYXplbnNMb2NhbGl6YWNvZXMxIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXMiLiJJREFybWF6ZW1Mb2NhbGl6YWNhb0Rlc3Rpbm8iDQp3aGVyZSAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEIj0gQElERG9jdW1lbnRvDQpPcmRlciBieSAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIk9yZGVtIjwvU3FsPjwvUXVlcnk+PFF1ZXJ5IFR5cGU9IkN1c3RvbVNxbFF1ZXJ5IiBOYW1lPSJ0YkRvY3VtZW50b3NDb21wcmFzX0NhYiI+PFBhcmFtZXRlciBOYW1lPSJJZERvYyIgVHlwZT0iRGV2RXhwcmVzcy5EYXRhQWNjZXNzLkV4cHJlc3Npb24iPihTeXN0ZW0uSW50NjQsIG1zY29ybGliLCBWZXJzaW9uPTQuMC4wLjAsIEN1bHR1cmU9bmV1dHJhbCwgUHVibGljS2V5VG9rZW49Yjc3YTVjNTYxOTM0ZTA4OSkoP0lERG9jdW1lbnRvKTwvUGFyYW1ldGVyPjxTcWw+c2VsZWN0IGRpc3RpbmN0ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSUQiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURUaXBvRG9jdW1lbnRvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk51bWVyb0RvY3VtZW50byIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhRG9jdW1lbnRvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk9ic2VydmFjb2VzIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklETW9lZGEiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVGF4YUNvbnZlcnNhbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJUb3RhbE1vZWRhRG9jdW1lbnRvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlRvdGFsTW9lZGFSZWZlcmVuY2lhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkxvY2FsQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YUNhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkhvcmFDYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJNb3JhZGFDYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvZGlnb1Bvc3RhbENhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29uY2VsaG9DYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRERpc3RyaXRvQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTG9jYWxEZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSG9yYURlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1vcmFkYURlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29kaWdvUG9zdGFsRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb25jZWxob0Rlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERGlzdHJpdG9EZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJOb21lRGVzdGluYXRhcmlvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29kaWdvUG9zdGFsRGVzdGluYXRhcmlvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29uY2VsaG9EZXN0aW5hdGFyaW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSUREaXN0cml0b0Rlc3RpbmF0YXJpbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJTZXJpZURvY01hbnVhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJOdW1lcm9Eb2NNYW51YWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTnVtZXJvTGluaGFzIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlBvc3RvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERXN0YWRvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlV0aWxpemFkb3JFc3RhZG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YUhvcmFFc3RhZG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQXNzaW5hdHVyYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJWZXJzYW9DaGF2ZVByaXZhZGEiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTm9tZUZpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJNb3JhZGFGaXNjYWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb2RpZ29Qb3N0YWxGaXNjYWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSUREaXN0cml0b0Zpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvbmNlbGhvRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvbnRyaWJ1aW50ZUZpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJTaWdsYVBhaXNGaXNjYWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURMb2phIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkltcHJlc3NvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlZhbG9ySW1wb3N0byIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJQZXJjZW50YWdlbURlc2NvbnRvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlZhbG9yRGVzY29udG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVmFsb3JQb3J0ZXMiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURUYXhhSXZhUG9ydGVzIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlRheGFJdmFQb3J0ZXMiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTW90aXZvSXNlbmNhb0l2YSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJNb3Rpdm9Jc2VuY2FvUG9ydGVzIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERXNwYWNvRmlzY2FsUG9ydGVzIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkVzcGFjb0Zpc2NhbFBvcnRlcyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFJlZ2ltZUl2YVBvcnRlcyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJSZWdpbWVJdmFQb3J0ZXMiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ3VzdG9zQWRpY2lvbmFpcyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJTaXN0ZW1hIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkF0aXZvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRhdGFDcmlhY2FvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlV0aWxpemFkb3JDcmlhY2FvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRhdGFBbHRlcmFjYW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRjNNTWFyY2Fkb3IiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVXRpbGl6YWRvckFsdGVyYWNhbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJREZvcm1hRXhwZWRpY2FvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEVGlwb3NEb2N1bWVudG9TZXJpZXMiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTnVtZXJvSW50ZXJubyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFRpcG9FbnRpZGFkZSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJREVudGlkYWRlIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29uZGljYW9QYWdhbWVudG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURMb2NhbE9wZXJhY2FvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb0FUIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEUGFpc0NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEUGFpc0Rlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1hdHJpY3VsYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFBhaXNGaXNjYWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29kaWdvUG9zdGFsRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRlc2NyaWNhb0NvZGlnb1Bvc3RhbEZpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEZXNjcmljYW9Db25jZWxob0Zpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEZXNjcmljYW9EaXN0cml0b0Zpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJREVzcGFjb0Zpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFJlZ2ltZUl2YSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29BVEludGVybm8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVGlwb0Zpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEb2N1bWVudG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29kaWdvVGlwb0VzdGFkbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29Eb2NPcmlnZW0iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGlzdHJpdG9DYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb25jZWxob0NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1Bvc3RhbENhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlNpZ2xhUGFpc0NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRpc3RyaXRvRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29uY2VsaG9EZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29Qb3N0YWxEZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJTaWdsYVBhaXNEZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29FbnRpZGFkZSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29Nb2VkYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJNZW5zYWdlbURvY0FUIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEU2lzVGlwb3NEb2NQVSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29TaXNUaXBvc0RvY1BVIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRvY01hbnVhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEb2NSZXBvc2ljYW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YUFzc2luYXR1cmEiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YUNvbnRyb2xvSW50ZXJubyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJTZWd1bmRhVmlhIiwidGJGb3JuZWNlZG9yZXMiLiJOb21lIiBhcyAidGJGb3JuZWNlZG9yZXNfTm9tZSIsInRiRm9ybmVjZWRvcmVzIi4iQ29kaWdvIiBhcyAidGJGb3JuZWNlZG9yZXNfQ29kaWdvIiwidGJGb3JuZWNlZG9yZXMiLiJOQ29udHJpYnVpbnRlIiBhcyAidGJGb3JuZWNlZG9yZXNfTkNvbnRyaWJ1aW50ZSIsInRiRm9ybmVjZWRvcmVzTW9yYWRhcyIuIk1vcmFkYSIgYXMgInRiRm9ybmVjZWRvcmVzTW9yYWRhc19Nb3JhZGEiLCJ0YkNvZGlnb3NQb3N0YWlzIi4iQ29kaWdvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0NsaWVudGVfQ29kaWdvIiwidGJDb2RpZ29zUG9zdGFpcyIuIkRlc2NyaWNhbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNDbGllbnRlX0Rlc2NyaWNhbyIsInRiRXN0YWRvcyIuIkNvZGlnbyIgYXMgInRiRXN0YWRvc19Db2RpZ28iLCJ0YkVzdGFkb3MiLiJEZXNjcmljYW8iIGFzICJ0YkVzdGFkb3NfRGVzY3JpY2FvIiwidGJUaXBvc0RvY3VtZW50byIuIkNvZGlnbyIgYXMgInRiVGlwb3NEb2N1bWVudG9fQ29kaWdvIiwidGJUaXBvc0RvY3VtZW50byIuIkRlc2NyaWNhbyIgYXMgInRiVGlwb3NEb2N1bWVudG9fRGVzY3JpY2FvIiwidGJUaXBvc0RvY3VtZW50byIuIkFjb21wYW5oYUJlbnNDaXJjdWxhY2FvIiBhcyAidGJUaXBvc0RvY3VtZW50b19BY29tcGFuaGFCZW5zQ2lyY3VsYWNhbyIsInRiVGlwb3NEb2N1bWVudG8iLiJEb2NOYW9WYWxvcml6YWRvIiBhcyAidGJUaXBvc0RvY3VtZW50b19Eb2NOYW9WYWxvcml6YWRvIiwidGJUaXBvc0RvY3VtZW50b1NlcmllcyIuIkNvZGlnb1NlcmllIiwidGJUaXBvc0RvY3VtZW50b1NlcmllcyIuIkRlc2NyaWNhb1NlcmllIiwidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiLiJEZXNjcmljYW8iIGFzICJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbF9EZXNjcmljYW8iLCJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50byIuIlRpcG8iIGFzICJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b19UaXBvIiwidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8iLiJEZXNjcmljYW8iIGFzICJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b19EZXNjcmljYW8iLCJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIuIlRpcG8iLCJ0YkNvZGlnb3NQb3N0YWlzMyIuIkNvZGlnbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNEZXNjYXJnYV9Db2RpZ28iLCJ0YkNvZGlnb3NQb3N0YWlzMyIuIkRlc2NyaWNhbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNEZXNjYXJnYV9EZXNjcmljYW8iLCJ0YkNvZGlnb3NQb3N0YWlzMSIuIkNvZGlnbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNfQ29kaWdvIiwidGJDb2RpZ29zUG9zdGFpczEiLiJEZXNjcmljYW8iIGFzICJ0YkNvZGlnb3NQb3N0YWlzX0Rlc2NyaWNhbyIsInRiQ29kaWdvc1Bvc3RhaXMyIi4iQ29kaWdvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0NhcmdhX0NvZGlnbyIsInRiQ29kaWdvc1Bvc3RhaXMyIi4iRGVzY3JpY2FvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0NhcmdhX0Rlc2NyaWNhbyIsInRiTW9lZGFzIi4iQ29kaWdvIiBhcyAidGJNb2VkYXNfQ29kaWdvIiwidGJNb2VkYXMiLiJEZXNjcmljYW8iIGFzICJ0Yk1vZWRhc19EZXNjcmljYW8iLCJ0Yk1vZWRhcyIuIkNhc2FzRGVjaW1haXNUb3RhaXMiIGFzICJ0Yk1vZWRhc19DYXNhc0RlY2ltYWlzVG90YWlzIiwidGJNb2VkYXMiLiJDYXNhc0RlY2ltYWlzSXZhIiBhcyAidGJNb2VkYXNfQ2FzYXNEZWNpbWFpc0l2YSIsInRiTW9lZGFzIi4iQ2FzYXNEZWNpbWFpc1ByZWNvc1VuaXRhcmlvcyIgYXMgInRiTW9lZGFzX0Nhc2FzRGVjaW1haXNQcmVjb3NVbml0YXJpb3MiLCJ0Yk1vZWRhcyIuIlNpbWJvbG8iIGFzICJ0Yk1vZWRhc19TaW1ib2xvIiwidGJTaXN0ZW1hTW9lZGFzIi4iQ29kaWdvIiBhcyAidGJTaXN0ZW1hTW9lZGFzX0NvZGlnbyIsInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJDYXNhc0RlY2ltYWlzUGVyY2VudGFnZW0iIGFzICJ0YlBhcmFtZW50cm9zRW1wcmVzYV9DYXNhc0RlY2ltYWlzUGVyY2VudGFnZW0iLCJ0YlNpc3RlbWFOYXR1cmV6YXMiLiJDb2RpZ28iIGFzICJ0YlNpc3RlbWFOYXR1cmV6YXNfQ29kaWdvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1vcmFkYURlc3RpbmF0YXJpbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJWb3Nzb051bWVyb0RvY3VtZW50byIsc3VtKCJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIi4iVmFsb3JEZXNjb250b0xpbmhhIikgYXMgIlZhbG9yRGVzY29udG9MaW5oYV9TdW0iIGZyb20gKCgoKCgoKCgoKCgoKCgoKCJkYm8iLiJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzIiAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyINCiBsZWZ0IGpvaW4gImRibyIuInRiRG9jdW1lbnRvc0NvbXByYXMiICJ0YkRvY3VtZW50b3NDb21wcmFzIiBvbiAoInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRCIgPSAidGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhcyIuIklERG9jdW1lbnRvQ29tcHJhIikpDQogbGVmdCBqb2luICJkYm8iLiJ0YkZvcm5lY2Vkb3JlcyIgInRiRm9ybmVjZWRvcmVzIiBvbiAoInRiRm9ybmVjZWRvcmVzIi4iSUQiID0gInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJREVudGlkYWRlIikpDQogbGVmdCBqb2luICJkYm8iLiJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXMiICJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXMiIG9uICgidGJGb3JuZWNlZG9yZXNNb3JhZGFzIi4iSURGb3JuZWNlZG9yIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURFbnRpZGFkZSIgYW5kICJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXMiLiJPcmRlbSI9MSApKQ0KIGxlZnQgam9pbiAiZGJvIi4idGJDb2RpZ29zUG9zdGFpcyIgInRiQ29kaWdvc1Bvc3RhaXMiIG9uICgidGJDb2RpZ29zUG9zdGFpcyIuIklEIiA9ICJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXMiLiJJRENvZGlnb1Bvc3RhbCIpKQ0KIGxlZnQgam9pbiAiZGJvIi4idGJFc3RhZG9zIiAidGJFc3RhZG9zIiBvbiAoInRiRXN0YWRvcyIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURFc3RhZG8iKSkNCiBsZWZ0IGpvaW4gImRibyIuInRiVGlwb3NEb2N1bWVudG8iICJ0YlRpcG9zRG9jdW1lbnRvIiBvbiAoInRiVGlwb3NEb2N1bWVudG8iLiJJRCIgPSAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEVGlwb0RvY3VtZW50byIpKQ0KIGxlZnQgam9pbiAiZGJvIi4idGJUaXBvc0RvY3VtZW50b1NlcmllcyIgInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiIG9uICgidGJUaXBvc0RvY3VtZW50b1NlcmllcyIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURUaXBvc0RvY3VtZW50b1NlcmllcyIpKQ0KIGxlZnQgam9pbiAiZGJvIi4idGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8iICJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50byIgb24gKCJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50byIuIklEIiA9ICJ0YlRpcG9zRG9jdW1lbnRvIi4iSURTaXN0ZW1hVGlwb3NEb2N1bWVudG8iKSkNCiBsZWZ0IGpvaW4gImRibyIuInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIiAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiIG9uICgidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiLiJJRCIgPSAidGJUaXBvc0RvY3VtZW50byIuIklEU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIikpDQogbGVmdCBqb2luICJkYm8iLiJ0YkNvZGlnb3NQb3N0YWlzIiAidGJDb2RpZ29zUG9zdGFpczEiIG9uICgidGJDb2RpZ29zUG9zdGFpczEiLiJJRCIgPSAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29kaWdvUG9zdGFsRmlzY2FsIikpDQogbGVmdCBqb2luICJkYm8iLiJ0YkNvZGlnb3NQb3N0YWlzIiAidGJDb2RpZ29zUG9zdGFpczIiIG9uICgidGJDb2RpZ29zUG9zdGFpczIiLiJJRCIgPSAidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29kaWdvUG9zdGFsQ2FyZ2EiKSkNCiBsZWZ0IGpvaW4gImRibyIuInRiQ29kaWdvc1Bvc3RhaXMiICJ0YkNvZGlnb3NQb3N0YWlzMyIgb24gKCJ0YkNvZGlnb3NQb3N0YWlzMyIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb2RpZ29Qb3N0YWxEZXNjYXJnYSIpKQ0KIGxlZnQgam9pbiAiZGJvIi4idGJNb2VkYXMiICJ0Yk1vZWRhcyIgb24gKCJ0Yk1vZWRhcyIuIklEIiA9ICJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURNb2VkYSIpKQ0KIGxlZnQgam9pbiAiZGJvIi4idGJQYXJhbWV0cm9zRW1wcmVzYSIgInRiUGFyYW1ldHJvc0VtcHJlc2EiIG9uICgidGJQYXJhbWV0cm9zRW1wcmVzYSIuIklETW9lZGFEZWZlaXRvIiA9ICJ0Yk1vZWRhcyIuIklEIikpDQogbGVmdCBqb2luICJkYm8iLiJ0YlNpc3RlbWFOYXR1cmV6YXMiICJ0YlNpc3RlbWFOYXR1cmV6YXMiIG9uICgidGJTaXN0ZW1hTmF0dXJlemFzIi4iSUQiID0gInRiVGlwb3NEb2N1bWVudG8iLiJJRFNpc3RlbWFOYXR1cmV6YXMiKSkNCiBsZWZ0IGpvaW4gImRibyIuInRiU2lzdGVtYU1vZWRhcyIgInRiU2lzdGVtYU1vZWRhcyIgb24gKCJ0YlNpc3RlbWFNb2VkYXMiLiJJRCIgPSAidGJNb2VkYXMiLiJJRFNpc3RlbWFNb2VkYSIpKQ0Kd2hlcmUgKCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSUQiID0gQElkRG9jKQ0KZ3JvdXAgYnkgInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFRpcG9Eb2N1bWVudG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTnVtZXJvRG9jdW1lbnRvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRhdGFEb2N1bWVudG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iT2JzZXJ2YWNvZXMiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURNb2VkYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJUYXhhQ29udmVyc2FvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlRvdGFsTW9lZGFEb2N1bWVudG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVG90YWxNb2VkYVJlZmVyZW5jaWEiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTG9jYWxDYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEYXRhQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSG9yYUNhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1vcmFkYUNhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29kaWdvUG9zdGFsQ2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb25jZWxob0NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERGlzdHJpdG9DYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJMb2NhbERlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRhdGFEZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJIb3JhRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTW9yYWRhRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb2RpZ29Qb3N0YWxEZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRENvbmNlbGhvRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSUREaXN0cml0b0Rlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk5vbWVEZXN0aW5hdGFyaW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTW9yYWRhRGVzdGluYXRhcmlvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29kaWdvUG9zdGFsRGVzdGluYXRhcmlvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29uY2VsaG9EZXN0aW5hdGFyaW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSUREaXN0cml0b0Rlc3RpbmF0YXJpbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJTZXJpZURvY01hbnVhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJOdW1lcm9Eb2NNYW51YWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTnVtZXJvTGluaGFzIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlBvc3RvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERXN0YWRvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlV0aWxpemFkb3JFc3RhZG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YUhvcmFFc3RhZG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQXNzaW5hdHVyYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJWZXJzYW9DaGF2ZVByaXZhZGEiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTm9tZUZpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJNb3JhZGFGaXNjYWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb2RpZ29Qb3N0YWxGaXNjYWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURDb25jZWxob0Zpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRERpc3RyaXRvRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvbnRyaWJ1aW50ZUZpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJTaWdsYVBhaXNGaXNjYWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURMb2phIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkltcHJlc3NvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlZhbG9ySW1wb3N0byIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJQZXJjZW50YWdlbURlc2NvbnRvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlZhbG9yRGVzY29udG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVmFsb3JQb3J0ZXMiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURUYXhhSXZhUG9ydGVzIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlRheGFJdmFQb3J0ZXMiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTW90aXZvSXNlbmNhb0l2YSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJNb3Rpdm9Jc2VuY2FvUG9ydGVzIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklERXNwYWNvRmlzY2FsUG9ydGVzIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkVzcGFjb0Zpc2NhbFBvcnRlcyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFJlZ2ltZUl2YVBvcnRlcyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJSZWdpbWVJdmFQb3J0ZXMiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ3VzdG9zQWRpY2lvbmFpcyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJTaXN0ZW1hIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkF0aXZvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRhdGFDcmlhY2FvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlV0aWxpemFkb3JDcmlhY2FvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRhdGFBbHRlcmFjYW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVXRpbGl6YWRvckFsdGVyYWNhbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJGM01NYXJjYWRvciIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJREZvcm1hRXhwZWRpY2FvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEVGlwb3NEb2N1bWVudG9TZXJpZXMiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iTnVtZXJvSW50ZXJubyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJREVudGlkYWRlIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEVGlwb0VudGlkYWRlIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEQ29uZGljYW9QYWdhbWVudG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iSURMb2NhbE9wZXJhY2FvIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb0FUIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEUGFpc0NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEUGFpc0Rlc2NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIk1hdHJpY3VsYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFBhaXNGaXNjYWwiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29kaWdvUG9zdGFsRmlzY2FsIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRlc2NyaWNhb0NvZGlnb1Bvc3RhbEZpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEZXNjcmljYW9Db25jZWxob0Zpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEZXNjcmljYW9EaXN0cml0b0Zpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJREVzcGFjb0Zpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJJRFJlZ2ltZUl2YSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29BVEludGVybm8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVGlwb0Zpc2NhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEb2N1bWVudG8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29kaWdvVGlwb0VzdGFkbyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29Eb2NPcmlnZW0iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGlzdHJpdG9DYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb25jZWxob0NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkNvZGlnb1Bvc3RhbENhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIlNpZ2xhUGFpc0NhcmdhIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRpc3RyaXRvRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iQ29uY2VsaG9EZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29Qb3N0YWxEZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJTaWdsYVBhaXNEZXNjYXJnYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29FbnRpZGFkZSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29Nb2VkYSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJNZW5zYWdlbURvY0FUIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIklEU2lzVGlwb3NEb2NQVSIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJDb2RpZ29TaXNUaXBvc0RvY1BVIiwidGJEb2N1bWVudG9zQ29tcHJhcyIuIkRvY01hbnVhbCIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJEb2NSZXBvc2ljYW8iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YUFzc2luYXR1cmEiLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iRGF0YUNvbnRyb2xvSW50ZXJubyIsInRiRG9jdW1lbnRvc0NvbXByYXMiLiJTZWd1bmRhVmlhIiwidGJGb3JuZWNlZG9yZXMiLiJDb2RpZ28iLCJ0YkZvcm5lY2Vkb3JlcyIuIk5vbWUiLCJ0YkZvcm5lY2Vkb3JlcyIuIk5Db250cmlidWludGUiLCJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXMiLiJNb3JhZGEiLCJ0YkNvZGlnb3NQb3N0YWlzIi4iQ29kaWdvIiwidGJDb2RpZ29zUG9zdGFpcyIuIkRlc2NyaWNhbyIsInRiRXN0YWRvcyIuIkNvZGlnbyIsInRiRXN0YWRvcyIuIkRlc2NyaWNhbyIsInRiVGlwb3NEb2N1bWVudG8iLiJDb2RpZ28iLCJ0YlRpcG9zRG9jdW1lbnRvIi4iRGVzY3JpY2FvIiwidGJUaXBvc0RvY3VtZW50byIuIkFjb21wYW5oYUJlbnNDaXJjdWxhY2FvIiwidGJUaXBvc0RvY3VtZW50byIuIkRvY05hb1ZhbG9yaXphZG8iLCJ0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIi4iQ29kaWdvU2VyaWUiLCJ0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIi4iRGVzY3JpY2FvU2VyaWUiLCJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50byIuIlRpcG8iLCJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50byIuIkRlc2NyaWNhbyIsInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIi4iVGlwbyIsInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIi4iRGVzY3JpY2FvIiwidGJDb2RpZ29zUG9zdGFpczEiLiJDb2RpZ28iLCJ0YkNvZGlnb3NQb3N0YWlzMSIuIkRlc2NyaWNhbyIsInRiQ29kaWdvc1Bvc3RhaXMyIi4iQ29kaWdvIiwidGJDb2RpZ29zUG9zdGFpczIiLiJEZXNjcmljYW8iLCJ0YkNvZGlnb3NQb3N0YWlzMyIuIkNvZGlnbyIsInRiQ29kaWdvc1Bvc3RhaXMzIi4iRGVzY3JpY2FvIiwidGJNb2VkYXMiLiJDb2RpZ28iLCJ0Yk1vZWRhcyIuIkRlc2NyaWNhbyIsInRiTW9lZGFzIi4iQ2FzYXNEZWNpbWFpc1RvdGFpcyIsInRiTW9lZGFzIi4iQ2FzYXNEZWNpbWFpc0l2YSIsInRiTW9lZGFzIi4iQ2FzYXNEZWNpbWFpc1ByZWNvc1VuaXRhcmlvcyIsInRiTW9lZGFzIi4iU2ltYm9sbyIsInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJDYXNhc0RlY2ltYWlzUGVyY2VudGFnZW0iLCJ0YlNpc3RlbWFOYXR1cmV6YXMiLiJDb2RpZ28iLCJ0YlNpc3RlbWFNb2VkYXMiLiJDb2RpZ28iLCJ0YkRvY3VtZW50b3NDb21wcmFzIi4iVm9zc29OdW1lcm9Eb2N1bWVudG8iPC9TcWw+PC9RdWVyeT48UXVlcnkgVHlwZT0iU2VsZWN0UXVlcnkiIE5hbWU9InRiUGFyYW1ldHJvc0VtcHJlc2EiPjxUYWJsZXM+PFRhYmxlIE5hbWU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIC8+PC9UYWJsZXM+PENvbHVtbnM+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iSUQiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iSURNb2VkYURlZmVpdG8iIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iTW9yYWRhIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkZvdG8iIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iRm90b0NhbWluaG8iIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iRGVzaWduYWNhb0NvbWVyY2lhbCIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJDb2RpZ29Qb3N0YWwiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iTG9jYWxpZGFkZSIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJDb25jZWxobyIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJEaXN0cml0byIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJJRFBhaXMiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iVGVsZWZvbmUiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iRmF4IiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkVtYWlsIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IldlYlNpdGUiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iTklGIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkNvbnNlcnZhdG9yaWFSZWdpc3RvQ29tZXJjaWFsIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9Ik51bWVyb1JlZ2lzdG9Db21lcmNpYWwiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iQ2FwaXRhbFNvY2lhbCIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJJRElkaW9tYUJhc2UiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iU2lzdGVtYSIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJBdGl2byIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJEYXRhQ3JpYWNhbyIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJVdGlsaXphZG9yQ3JpYWNhbyIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJEYXRhQWx0ZXJhY2FvIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IlV0aWxpemFkb3JBbHRlcmFjYW8iIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iRjNNTWFyY2Fkb3IiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iSURFbXByZXNhIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkNhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJJRFBhaXNlc0Rlc2MiIC8+PC9Db2x1bW5zPjwvUXVlcnk+PFJlc3VsdFNjaGVtYT48RGF0YVNldCBOYW1lPSJTcWxEYXRhU291cmNlIj48VmlldyBOYW1lPSJ0YkRvY3VtZW50b3NDb21wcmFzX0NhYiI+PEZpZWxkIE5hbWU9IklEIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURUaXBvRG9jdW1lbnRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTnVtZXJvRG9jdW1lbnRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iRGF0YURvY3VtZW50byIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9Ik9ic2VydmFjb2VzIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklETW9lZGEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJUYXhhQ29udmVyc2FvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlRvdGFsTW9lZGFEb2N1bWVudG8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVG90YWxNb2VkYVJlZmVyZW5jaWEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iTG9jYWxDYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhQ2FyZ2EiIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJIb3JhQ2FyZ2EiIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJNb3JhZGFDYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRENvZGlnb1Bvc3RhbENhcmdhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURDb25jZWxob0NhcmdhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSUREaXN0cml0b0NhcmdhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTG9jYWxEZXNjYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhRGVzY2FyZ2EiIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJIb3JhRGVzY2FyZ2EiIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJNb3JhZGFEZXNjYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRENvZGlnb1Bvc3RhbERlc2NhcmdhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURDb25jZWxob0Rlc2NhcmdhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSUREaXN0cml0b0Rlc2NhcmdhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTm9tZURlc3RpbmF0YXJpbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRENvZGlnb1Bvc3RhbERlc3RpbmF0YXJpbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQ29uY2VsaG9EZXN0aW5hdGFyaW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERpc3RyaXRvRGVzdGluYXRhcmlvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iU2VyaWVEb2NNYW51YWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTnVtZXJvRG9jTWFudWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik51bWVyb0xpbmhhcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlBvc3RvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklERXN0YWRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckVzdGFkbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhSG9yYUVzdGFkbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkFzc2luYXR1cmEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVmVyc2FvQ2hhdmVQcml2YWRhIiBUeXBlPSJJbnQzMiIgLz48RmllbGQgTmFtZT0iTm9tZUZpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJNb3JhZGFGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURDb2RpZ29Qb3N0YWxGaXNjYWwiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERpc3RyaXRvRmlzY2FsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURDb25jZWxob0Zpc2NhbCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNvbnRyaWJ1aW50ZUZpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTaWdsYVBhaXNGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURMb2phIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSW1wcmVzc28iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IlZhbG9ySW1wb3N0byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQZXJjZW50YWdlbURlc2NvbnRvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlZhbG9yRGVzY29udG8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVmFsb3JQb3J0ZXMiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iSURUYXhhSXZhUG9ydGVzIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iVGF4YUl2YVBvcnRlcyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJNb3Rpdm9Jc2VuY2FvSXZhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik1vdGl2b0lzZW5jYW9Qb3J0ZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURFc3BhY29GaXNjYWxQb3J0ZXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJFc3BhY29GaXNjYWxQb3J0ZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURSZWdpbWVJdmFQb3J0ZXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJSZWdpbWVJdmFQb3J0ZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ3VzdG9zQWRpY2lvbmFpcyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJTaXN0ZW1hIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJBdGl2byIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iRGF0YUNyaWFjYW8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJVdGlsaXphZG9yQ3JpYWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhQWx0ZXJhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iRjNNTWFyY2Fkb3IiIFR5cGU9IkJ5dGVBcnJheSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckFsdGVyYWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJREZvcm1hRXhwZWRpY2FvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURUaXBvc0RvY3VtZW50b1NlcmllcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik51bWVyb0ludGVybm8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9FbnRpZGFkZSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklERW50aWRhZGUiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmRpY2FvUGFnYW1lbnRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURMb2NhbE9wZXJhY2FvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ29kaWdvQVQiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURQYWlzQ2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFBhaXNEZXNjYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik1hdHJpY3VsYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFBhaXNGaXNjYWwiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Qb3N0YWxGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvQ29kaWdvUG9zdGFsRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb0NvbmNlbGhvRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb0Rpc3RyaXRvRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklERXNwYWNvRmlzY2FsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURSZWdpbWVJdmEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29BVEludGVybm8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVGlwb0Zpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEb2N1bWVudG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvVGlwb0VzdGFkbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Eb2NPcmlnZW0iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGlzdHJpdG9DYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb25jZWxob0NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1Bvc3RhbENhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlNpZ2xhUGFpc0NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRpc3RyaXRvRGVzY2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29uY2VsaG9EZXNjYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Qb3N0YWxEZXNjYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTaWdsYVBhaXNEZXNjYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29FbnRpZGFkZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Nb2VkYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJNZW5zYWdlbURvY0FUIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEU2lzVGlwb3NEb2NQVSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1Npc1RpcG9zRG9jUFUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRG9jTWFudWFsIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJEb2NSZXBvc2ljYW8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkRhdGFBc3NpbmF0dXJhIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iRGF0YUNvbnRyb2xvSW50ZXJubyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IlNlZ3VuZGFWaWEiIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9InRiRm9ybmVjZWRvcmVzX05vbWUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJGb3JuZWNlZG9yZXNfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRm9ybmVjZWRvcmVzX05Db250cmlidWludGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJGb3JuZWNlZG9yZXNNb3JhZGFzX01vcmFkYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzQ2xpZW50ZV9Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0NsaWVudGVfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRXN0YWRvc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJFc3RhZG9zX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlRpcG9zRG9jdW1lbnRvX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlRpcG9zRG9jdW1lbnRvX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlRpcG9zRG9jdW1lbnRvX0Fjb21wYW5oYUJlbnNDaXJjdWxhY2FvIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJ0YlRpcG9zRG9jdW1lbnRvX0RvY05hb1ZhbG9yaXphZG8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1NlcmllIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb1NlcmllIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b19UaXBvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJUaXBvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ29kaWdvc1Bvc3RhaXNEZXNjYXJnYV9Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0Rlc2NhcmdhX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzQ2FyZ2FfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ29kaWdvc1Bvc3RhaXNDYXJnYV9EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiTW9lZGFzX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0Yk1vZWRhc19DYXNhc0RlY2ltYWlzVG90YWlzIiBUeXBlPSJCeXRlIiAvPjxGaWVsZCBOYW1lPSJ0Yk1vZWRhc19DYXNhc0RlY2ltYWlzSXZhIiBUeXBlPSJCeXRlIiAvPjxGaWVsZCBOYW1lPSJ0Yk1vZWRhc19DYXNhc0RlY2ltYWlzUHJlY29zVW5pdGFyaW9zIiBUeXBlPSJCeXRlIiAvPjxGaWVsZCBOYW1lPSJ0Yk1vZWRhc19TaW1ib2xvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiU2lzdGVtYU1vZWRhc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJQYXJhbWVudHJvc0VtcHJlc2FfQ2FzYXNEZWNpbWFpc1BlcmNlbnRhZ2VtIiBUeXBlPSJCeXRlIiAvPjxGaWVsZCBOYW1lPSJ0YlNpc3RlbWFOYXR1cmV6YXNfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYURlc3RpbmF0YXJpbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJWb3Nzb051bWVyb0RvY3VtZW50byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJWYWxvckRlc2NvbnRvTGluaGFfU3VtIiBUeXBlPSJEb3VibGUiIC8+PC9WaWV3PjxWaWV3IE5hbWU9InRiRG9jdW1lbnRvc0NvbXByYXMiPjxGaWVsZCBOYW1lPSJJRCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEVGlwb0RvY3VtZW50byIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik51bWVyb0RvY3VtZW50byIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkRhdGFEb2N1bWVudG8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJPYnNlcnZhY29lcyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRE1vZWRhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iVGF4YUNvbnZlcnNhbyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJUb3RhbE1vZWRhRG9jdW1lbnRvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlRvdGFsTW9lZGFSZWZlcmVuY2lhIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkxvY2FsQ2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUNhcmdhIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iSG9yYUNhcmdhIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iTW9yYWRhQ2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURDb2RpZ29Qb3N0YWxDYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQ29uY2VsaG9DYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklERGlzdHJpdG9DYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkxvY2FsRGVzY2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YURlc2NhcmdhIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iSG9yYURlc2NhcmdhIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iTW9yYWRhRGVzY2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURDb2RpZ29Qb3N0YWxEZXNjYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQ29uY2VsaG9EZXNjYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklERGlzdHJpdG9EZXNjYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik5vbWVEZXN0aW5hdGFyaW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTW9yYWRhRGVzdGluYXRhcmlvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEQ29kaWdvUG9zdGFsRGVzdGluYXRhcmlvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURDb25jZWxob0Rlc3RpbmF0YXJpbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklERGlzdHJpdG9EZXN0aW5hdGFyaW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJTZXJpZURvY01hbnVhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOdW1lcm9Eb2NNYW51YWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTnVtZXJvTGluaGFzIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iUG9zdG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURFc3RhZG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJVdGlsaXphZG9yRXN0YWRvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRhdGFIb3JhRXN0YWRvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iQXNzaW5hdHVyYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJWZXJzYW9DaGF2ZVByaXZhZGEiIFR5cGU9IkludDMyIiAvPjxGaWVsZCBOYW1lPSJOb21lRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYUZpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRENvZGlnb1Bvc3RhbEZpc2NhbCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQ29uY2VsaG9GaXNjYWwiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERpc3RyaXRvRmlzY2FsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ29udHJpYnVpbnRlRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlNpZ2xhUGFpc0Zpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRExvamEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJbXByZXNzbyIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iVmFsb3JJbXBvc3RvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlBlcmNlbnRhZ2VtRGVzY29udG8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVmFsb3JEZXNjb250byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJWYWxvclBvcnRlcyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJJRFRheGFJdmFQb3J0ZXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJUYXhhSXZhUG9ydGVzIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9Ik1vdGl2b0lzZW5jYW9JdmEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTW90aXZvSXNlbmNhb1BvcnRlcyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJREVzcGFjb0Zpc2NhbFBvcnRlcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkVzcGFjb0Zpc2NhbFBvcnRlcyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFJlZ2ltZUl2YVBvcnRlcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlJlZ2ltZUl2YVBvcnRlcyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDdXN0b3NBZGljaW9uYWlzIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlNpc3RlbWEiIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkF0aXZvIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJEYXRhQ3JpYWNhbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IlV0aWxpemFkb3JDcmlhY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRhdGFBbHRlcmFjYW8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJVdGlsaXphZG9yQWx0ZXJhY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkYzTU1hcmNhZG9yIiBUeXBlPSJCeXRlQXJyYXkiIC8+PEZpZWxkIE5hbWU9IklERm9ybWFFeHBlZGljYW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9zRG9jdW1lbnRvU2VyaWVzIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTnVtZXJvSW50ZXJubyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklERW50aWRhZGUiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9FbnRpZGFkZSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQ29uZGljYW9QYWdhbWVudG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRExvY2FsT3BlcmFjYW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29BVCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFBhaXNDYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEUGFpc0Rlc2NhcmdhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTWF0cmljdWxhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEUGFpc0Zpc2NhbCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1Bvc3RhbEZpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW9Db2RpZ29Qb3N0YWxGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvQ29uY2VsaG9GaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvRGlzdHJpdG9GaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURFc3BhY29GaXNjYWwiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFJlZ2ltZUl2YSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNvZGlnb0FUSW50ZXJubyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJUaXBvRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRvY3VtZW50byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29UaXBvRXN0YWRvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb0RvY09yaWdlbSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEaXN0cml0b0NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvbmNlbGhvQ2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvUG9zdGFsQ2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iU2lnbGFQYWlzQ2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGlzdHJpdG9EZXNjYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb25jZWxob0Rlc2NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1Bvc3RhbERlc2NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlNpZ2xhUGFpc0Rlc2NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb0VudGlkYWRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb01vZWRhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik1lbnNhZ2VtRG9jQVQiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURTaXNUaXBvc0RvY1BVIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ29kaWdvU2lzVGlwb3NEb2NQVSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEb2NNYW51YWwiIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkRvY1JlcG9zaWNhbyIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iRGF0YUFzc2luYXR1cmEiIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJEYXRhQ29udHJvbG9JbnRlcm5vIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iRGF0YURvY3VtZW50b18xIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iQ29kaWdvVGlwb0VzdGFkb18xIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlNlZ3VuZGFWaWEiIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9InRiRG9jdW1lbnRvc0NvbXByYXNMaW5oYXNfSUQiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJPcmRlbSIgVHlwZT0iSW50MzIiIC8+PEZpZWxkIE5hbWU9IklERG9jdW1lbnRvQ29tcHJhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURBcnRpZ28iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURVbmlkYWRlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTnVtQ2FzYXNEZWNVbmlkYWRlIiBUeXBlPSJJbnQxNiIgLz48RmllbGQgTmFtZT0iUXVhbnRpZGFkZSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQcmVjb1VuaXRhcmlvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlByZWNvVW5pdGFyaW9FZmV0aXZvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlByZWNvVG90YWwiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19PYnNlcnZhY29lcyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRExvdGUiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Mb3RlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1VuaWRhZGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvTG90ZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhRmFicmljb0xvdGUiIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJEYXRhVmFsaWRhZGVMb3RlIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iSURBcnRpZ29OdW1TZXJpZSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkFydGlnb051bVNlcmllIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEQXJtYXplbSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQXJtYXplbUxvY2FsaXphY2FvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURBcm1hemVtRGVzdGlubyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQXJtYXplbUxvY2FsaXphY2FvRGVzdGlubyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik51bUxpbmhhc0RpbWVuc29lcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkRlc2NvbnRvMSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJEZXNjb250bzIiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iSURUYXhhSXZhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iVGF4YUl2YSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzX01vdGl2b0lzZW5jYW9JdmEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURFc3BhY29GaXNjYWxfMSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkVzcGFjb0Zpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFJlZ2ltZUl2YV8xIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iUmVnaW1lSXZhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlNpZ2xhUGFpcyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJPcmRlbV8xIiBUeXBlPSJJbnQzMiIgLz48RmllbGQgTmFtZT0idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19TaXN0ZW1hIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzX0F0aXZvIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzX0RhdGFDcmlhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19VdGlsaXphZG9yQ3JpYWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzX0RhdGFBbHRlcmFjYW8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJ0YkRvY3VtZW50b3NDb21wcmFzTGluaGFzX1V0aWxpemFkb3JBbHRlcmFjYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJEb2N1bWVudG9zQ29tcHJhc0xpbmhhc19GM01NYXJjYWRvciIgVHlwZT0iQnl0ZUFycmF5IiAvPjxGaWVsZCBOYW1lPSJWYWxvckluY2lkZW5jaWEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVmFsb3JJVkEiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iRG9jdW1lbnRvT3JpZ2VtIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRhdGFFbnRyZWdhIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0idGJGb3JuZWNlZG9yZXNfTm9tZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkZvcm5lY2Vkb3Jlc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJGb3JuZWNlZG9yZXNfTkNvbnRyaWJ1aW50ZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkZvcm5lY2Vkb3Jlc01vcmFkYXNfTW9yYWRhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ29kaWdvc1Bvc3RhaXNDbGllbnRlX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzQ2xpZW50ZV9EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJFc3RhZG9zX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkVzdGFkb3NfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiVGlwb3NEb2N1bWVudG9fQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiVGlwb3NEb2N1bWVudG9fRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiVGlwb3NEb2N1bWVudG9fRG9jTmFvVmFsb3JpemFkbyIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0idGJUaXBvc0RvY3VtZW50b19BY29tcGFuaGFCZW5zQ2lyY3VsYWNhbyIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iQ29kaWdvU2VyaWUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvU2VyaWUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJBcnRpZ29zX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW9BYnJldmlhZGEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJBcnRpZ29zX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkFydGlnb3NfR2VyZUxvdGVzIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbF9EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9fVGlwbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVGlwbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzQ2FyZ2FfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ29kaWdvc1Bvc3RhaXNDYXJnYV9EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0Rlc2NhcmdhX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzRGVzY2FyZ2FfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiTW9lZGFzX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0Yk1vZWRhc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfU2ltYm9sbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkFybWF6ZW5zX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkFybWF6ZW5zX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkFybWF6ZW5zTG9jYWxpemFjb2VzX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkFybWF6ZW5zTG9jYWxpemFjb2VzX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkFybWF6ZW5zMV9EZXNjcmljYW9EZXN0aW5vIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQXJtYXplbnMxX0NvZGlnb0Rlc3Rpbm8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJBcm1hemVuc0xvY2FsaXphY29lczFfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQXJtYXplbnNMb2NhbGl6YWNvZXMxX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0Yk1vZWRhc19DYXNhc0RlY2ltYWlzVG90YWlzIiBUeXBlPSJCeXRlIiAvPjxGaWVsZCBOYW1lPSJ0Yk1vZWRhc19DYXNhc0RlY2ltYWlzUHJlY29zVW5pdGFyaW9zIiBUeXBlPSJCeXRlIiAvPjxGaWVsZCBOYW1lPSJ0Yk1vZWRhc19DYXNhc0RlY2ltYWlzSXZhIiBUeXBlPSJCeXRlIiAvPjxGaWVsZCBOYW1lPSJ0YlNpc3RlbWFDb2RpZ29zSVZBLkNvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlNpc3RlbWFNb2VkYXNfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlN1YlRvdGFsIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9InRiUGFyYW1lbnRyb3NFbXByZXNhX0Nhc2FzRGVjaW1haXNQZXJjZW50YWdlbSIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hTmF0dXJlemFzX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjwvVmlldz48VmlldyBOYW1lPSJ0YlBhcmFtZXRyb3NFbXByZXNhIj48RmllbGQgTmFtZT0iSUQiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRE1vZWRhRGVmZWl0byIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGb3RvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkZvdG9DYW1pbmhvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2lnbmFjYW9Db21lcmNpYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvUG9zdGFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkxvY2FsaWRhZGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29uY2VsaG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGlzdHJpdG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURQYWlzIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iVGVsZWZvbmUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRmF4IiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkVtYWlsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IldlYlNpdGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTklGIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvbnNlcnZhdG9yaWFSZWdpc3RvQ29tZXJjaWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik51bWVyb1JlZ2lzdG9Db21lcmNpYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ2FwaXRhbFNvY2lhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRElkaW9tYUJhc2UiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJTaXN0ZW1hIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJBdGl2byIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iRGF0YUNyaWFjYW8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJVdGlsaXphZG9yQ3JpYWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhQWx0ZXJhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckFsdGVyYWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGM01NYXJjYWRvciIgVHlwZT0iVW5rbm93biIgLz48RmllbGQgTmFtZT0iSURFbXByZXNhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ2FzYXNEZWNpbWFpc1BlcmNlbnRhZ2VtIiBUeXBlPSJCeXRlIiAvPjxGaWVsZCBOYW1lPSJJRFBhaXNlc0Rlc2MiIFR5cGU9IkludDY0IiAvPjwvVmlldz48L0RhdGFTZXQ+PC9SZXN1bHRTY2hlbWE+PENvbm5lY3Rpb25PcHRpb25zIENsb3NlQ29ubmVjdGlvbj0idHJ1ZSIgLz48L1NxbERhdGFTb3VyY2U+" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>''
--Mapa de documentos de compras 
---tratar subreports
Set @ptrval.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item3/SubBands/Item1/Controls/Item1/@ReportSourceUrl)[.=10000][1] with sql:variable("@intIDMapaSubCab")'')
Set @ptrval.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item7/SubBands/Item1/Controls/Item2/@ReportSourceUrl)[.=20000][1] with sql:variable("@intIDMapaMI")'')
Set @ptrval.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item5/Bands/Item1/SubBands/Item1/Controls/Item1/@ReportSourceUrl)[.=30000][1] with sql:variable("@intIDMapaD")'')
Set @ptrval.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item6/Bands/Item1/SubBands/Item1/Controls/Item1/@ReportSourceUrl)[.=40000][1] with sql:variable("@intIDMapaDNV")'')
UPDATE tbMapasVistas SET MapaXML = @ptrval , NomeMapa = ''DocumentosCompras'' Where Entidade = ''DocumentosCompras'' and NomeMapa = ''rptDocumentosCompras''
')