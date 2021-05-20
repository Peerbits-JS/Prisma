/* ACT BD EMPRESA VERSAO 61*/
--novo campo Documentos Compras Linhas
EXEC('IF Not EXISTS(SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ''tbDocumentosComprasLinhas'' AND COLUMN_NAME = ''F3MGUID'') 
Begin
ALTER TABLE tbDocumentosComprasLinhas add F3MGUID nvarchar(max)
End')

-- Novo Menu de Análises Dinâmicas
EXEC('IF NOT EXISTS(SELECT * FROM [F3MOGeral]..tbMenus WHERE Descricao = ''AnalisesDinamicas'')
BEGIN
	INSERT INTO [F3MOGeral]..tbMenus ([IDPai], [Descricao], [DescricaoAbreviada], [ToolTip], [Ordem], [Icon], [Accao], [IDTiposOpcoesMenu], [IDModulo], [btnContextoAdicionar], [btnContextoAlterar], [btnContextoConsultar], [btnContextoRemover], [btnContextoExportar], [btnContextoImprimir], [btnContextoF4], [Ativo], [Sistema], [DataCriacao], [UtilizadorCriacao], [DataAlteracao], [UtilizadorAlteracao], [btnContextoImportar], [btnContextoDuplicar], [OpenType])
	VALUES (NULL, N''AnalisesDinamicas'', N''021'', N''AnalisesDinamicas'', -50, N''f3icon-list-alt'', N''/AnalisesDinamicas/AnalisesDinamicas'', 1, 12, 1, 1, 1, 1, 1, 1, NULL, 0, 0, getdate(), N''F3M'', NULL, NULL, NULL, NULL, NULL)
END')

--atualizar vista de Rolo
EXEC('
BEGIN
update tbmapasvistas set mapaxml=''
<XtraReportsLayoutSerializer SerializerVersion="18.2.11.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.11.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="Rolo" SnapGridSize="25" ReportUnit="TenthsOfAMillimeter" Margins="0, 300, 0, 0" PaperKind="Custom" PageWidth="1000" PageHeight="80" ScriptLanguage="VisualBasic" Version="19.1" DataMember="QueryBase" DataSource="#Ref-0" Dpi="254">
  <Extensions>
    <Item1 Ref="2" Key="DataSerializationExtension" Value="DevExpress.XtraReports.Web.ReportDesigner.DefaultDataSerializer" />
  </Extensions>
  <Parameters>
    <Item1 Ref="4" Description="IDDocumento" ValueInfo="10" Name="IDDocumento" Type="#Ref-3" />
    <Item2 Ref="5" Description="IDLoja" ValueInfo="1" Name="IDLoja" Type="#Ref-3" />
    <Item3 Ref="7" Description="Culture" ValueInfo="pt-PT" Name="Culture" />
    <Item4 Ref="8" Visible="false" Description="Via" Name="Via" />
    <Item5 Ref="9" Visible="false" Description="Formas" ValueInfo="select distinct tbRecibos.ID, tbRecibosFormasPagamento.IDFormaPagamento, tbFormasPagamento.Descricao, tbRecibosFormasPagamento.Valor,  tbRecibosFormasPagamento.ValorEntregue,  tbRecibosFormasPagamento.Troco from tbRecibos inner join tbRecibosFormasPagamento on tbRecibosFormasPagamento.IDRecibo= tbRecibos.ID inner join tbFormasPagamento on tbRecibosFormasPagamento.IDFormaPagamento=tbFormasPagamento.ID where tbRecibos.ID=" Name="Formas" />
    <Item6 Ref="11" Visible="false" Description="NumeroCasasDecimais" ValueInfo="2" Name="NumeroCasasDecimais" Type="#Ref-10" />
    <Item7 Ref="12" Visible="false" Description="Observacoes" ValueInfo="select ID, Observacoes from tbRecibos where ID=" Name="Observacoes" />
    <Item8 Ref="13" Visible="false" Description="Assinatura" ValueInfo="select ID, '''''''' as Assinatura from tbRecibos where ID=" Name="Assinatura" />
    <Item9 Ref="14" Visible="false" Description="BDEmpresa" Name="BDEmpresa" />
    <Item10 Ref="15" Visible="false" Description="Entidade" Name="Entidade" />
    <Item11 Ref="16" Visible="false" Description="Parameter1" Name="SQLQuery" />
    <Item12 Ref="17" Visible="false" Description="Parameter1" Name="TabelaTemp" />
  </Parameters>
  <Bands>
    <Item1 Ref="18" ControlType="TopMarginBand" Name="TopMarginBand1" HeightF="0" Dpi="254" />
    <Item2 Ref="19" ControlType="DetailBand" Name="Detail" KeepTogetherWithDetailReports="true" KeepTogether="true" TextAlignment="TopLeft" Dpi="254" Padding="0,0,0,0,254">
      <MultiColumn Ref="20" ColumnWidth="600" Layout="AcrossThenDown" Mode="UseColumnWidth" />
      <Controls>
        <Item1 Ref="21" ControlType="XRLabel" Name="label2" CanGrow="false" Text="XrLabel1" TextAlignment="MiddleLeft" SizeF="165.06,26.9" LocationFloat="334.38, 43.95" Dpi="254" Font="Arial Black, 5.5pt" Padding="5,5,0,0,254">
          <ExpressionBindings>
            <Item1 Ref="22" Expression="[DescricaoMarca]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="23" UseFont="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="24" ControlType="XRLabel" Name="label1" CanGrow="false" Text="XrLabel1" TextAlignment="MiddleLeft" SizeF="165.06,26.9" LocationFloat="334.38, 11.75" Dpi="254" Font="Arial Black, 5.5pt" Padding="5,5,0,0,254">
          <ExpressionBindings>
            <Item1 Ref="25" Expression="[CodigoArtigo]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="26" UseFont="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="27" ControlType="XRLabel" Name="XrLabel1" CanGrow="false" Text="XrLabel1" TextAlignment="MiddleCenter" SizeF="290.42,19.7" LocationFloat="41.25, 59.27" Dpi="254" Font="Arial Black, 4.5pt" Padding="5,5,0,0,254">
          <ExpressionBindings>
            <Item1 Ref="28" Expression="[DescricaoArtigo]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="29" UseFont="false" UseTextAlignment="false" />
        </Item3>
        <Item4 Ref="30" ControlType="XRLabel" Name="fldPV1" TextFormatString="{0:0.00€}" CanGrow="false" TextAlignment="MiddleRight" SizeF="94.71,26.91" LocationFloat="498.94, 11.75" Dpi="254" Font="Arial Black, 5.5pt" Padding="5,5,0,0,254">
          <ExpressionBindings>
            <Item1 Ref="31" Expression="[ValorComIva]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="32" UseFont="false" UseTextAlignment="false" />
        </Item4>
        <Item5 Ref="33" ControlType="XRBarCode" Name="fldCodigoBarras" Module="3.5" AutoModule="true" TextAlignment="MiddleCenter" ShowText="false" Text="12345678" SizeF="303.09,40.68" LocationFloat="28.04, 17.46" Dpi="254" Font="Arial, 5.25pt, charSet=0" ForeColor="Black" Padding="0,0,0,0,254" BorderWidth="0">
          <Symbology Ref="34" Name="Code39Extended" WideNarrowRatio="3" CalcCheckSum="false" />
          <ExpressionBindings>
            <Item1 Ref="35" Expression="[CodigoBarras]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="36" UseFont="false" UseForeColor="false" UsePadding="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item5>
      </Controls>
      <StylePriority Ref="37" UsePadding="false" />
    </Item2>
    <Item3 Ref="38" ControlType="BottomMarginBand" Name="BottomMarginBand1" HeightF="0" Dpi="254" />
  </Bands>
  <ReportPrintOptions Ref="39" DetailCountOnEmptyDataSource="0" />
  <ObjectStorage>
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="3" Content="System.Int64" Type="System.Type" />
    <Item2 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="10" Content="System.Int32" Type="System.Type" />
    <Item3 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Base64="PFNxbERhdGFTb3VyY2U+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9MTAuMC4wLjU7VXNlciBJRD1GM01PO1Bhc3N3b3JkPTtJbml0aWFsIENhdGFsb2cgPTc4ODhGM01POyIgLz48UXVlcnkgVHlwZT0iQ3VzdG9tU3FsUXVlcnkiIE5hbWU9IlF1ZXJ5QmFzZSI+PFNxbD5zZWxlY3QgKiBmcm9tIHZ3QXJ0aWdvczwvU3FsPjwvUXVlcnk+PFJlc3VsdFNjaGVtYT48RGF0YVNldD48VmlldyBOYW1lPSJRdWVyeUJhc2UiPjxGaWVsZCBOYW1lPSJ0aXBvZG9jIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklERG9jdW1lbnRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iUXVhbnRpZGFkZSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJWYWxvckNvbUl2YSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvQmFycmFzIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb0JhcnJhc0Zvcm5lY2Vkb3IiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iUmVmZXJlbmNpYUZvcm5lY2Vkb3IiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVmFsb3JDb21JdmEyIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb01hcmNhIiBUeXBlPSJTdHJpbmciIC8+PC9WaWV3PjwvRGF0YVNldD48L1Jlc3VsdFNjaGVtYT48Q29ubmVjdGlvbk9wdGlvbnMgQ2xvc2VDb25uZWN0aW9uPSJ0cnVlIiAvPjwvU3FsRGF0YVNvdXJjZT4=" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>
''
where id=50
END')

--atualizar vista de documentos de stock
EXEC('
DECLARE @ptrval xml;  
DECLARE @intIDMapaSubCab as bigint;--10000
DECLARE @intIDMapaMI as bigint;--20000
DECLARE @intIDMapaD as bigint;--30000
DECLARE @intIDMapaDNV as bigint;--40000
DECLARE @intIDMapaDNVA as bigint;--50000
DECLARE @intIDMapaDVA as bigint;--60000
SELECT @intIDMapaSubCab = ID  FROM tbMapasVistas WHERE Entidade = ''DocumentosStock'' and NomeMapa=''Cabecalho Empresa Stocks''
SELECT @intIDMapaMI = ID  FROM tbMapasVistas WHERE Entidade = ''DocumentosStock'' and NomeMapa=''Motivos Isencao Stocks''
SELECT @intIDMapaD = ID  FROM tbMapasVistas WHERE Entidade = ''DocumentosStock'' and NomeMapa=''Dimensoes Stocks''
SELECT @intIDMapaDNV = ID  FROM tbMapasVistas WHERE Entidade = ''DocumentosStock'' and NomeMapa=''Dimensoes Stocks Nao Valorizado''
SELECT @intIDMapaDNVA = ID  FROM tbMapasVistas WHERE Entidade = ''DocumentosStock'' and NomeMapa=''Dimensoes Stocks Nao Valorizado Acompanha''
SELECT @intIDMapaDVA = ID  FROM tbMapasVistas WHERE Entidade = ''DocumentosStock'' and NomeMapa=''Dimensoes Stocks Valorizado Acompanha''
SET @ptrval = N''
<XtraReportsLayoutSerializer SerializerVersion="18.2.11.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.11.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="DocumentosStock" ScriptsSource="Imports System.Linq&#xD;&#xA;Imports Reporting&#xD;&#xA;Imports DevExpress.DataAccess.Native.Sql&#xD;&#xA;Imports System.ComponentModel&#xD;&#xA;&#xD;&#xA;Dim count2 As Int16 = 0&#xD;&#xA;Dim dblTransportar as Double = 0&#xD;&#xA;Dim dblTransporte as Double = 0&#xD;&#xA;&#xD;&#xA;Private Sub Documentos_de_Stocks_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;    Dim SimboloMoeda As String = String.Empty&#xD;&#xA;    Dim numeroCasasDecimaisMoeda As Int16 = 0&#xD;&#xA;    Dim numeroCasasDecimaisPercentagens As Int16 = 0&#xD;&#xA;    Dim resource As ReportTranslation = New ReportTranslation&#xD;&#xA;    Dim culture As String = Me.Parameters(&quot;Culture&quot;).Value.ToString&#xD;&#xA;    Dim rs As ResultSet = TryCast(TryCast(Me.DataSource, IListSource).GetList(), ResultSet)&#xD;&#xA;    Dim rsDV As ResultTable = rs.Tables.FirstOrDefault(Function(x) x.TableName.Equals(&quot;tbDocumentosStock&quot;))&#xD;&#xA;    Dim CMoedas As Integer&#xD;&#xA;    &#xD;&#xA;    If Not rsDV Is Nothing andalso rsDV.Count &gt; 0 Then&#xD;&#xA;        Me.lblNumVias.Text = Me.Parameters(&quot;Via&quot;).Value.ToString&#xD;&#xA;        Me.Parameters.Item(&quot;IDLinha&quot;).Value = GetCurrentColumnValue(&quot;tbDocumentosStockLinhas_ID&quot;)&#xD;&#xA;        &#xD;&#xA;         If GetCurrentColumnValue(&quot;tbMoedas_Simbolo&quot;) is DBNull.Value orelse GetCurrentColumnValue(&quot;tbMoedas_Simbolo&quot;) = &quot;&quot; then&#xD;&#xA;            Me.Parameters.Item(&quot;SimboloMoedas&quot;).Value = &quot;€&quot;&#xD;&#xA;            SimboloMoeda = &quot;€&quot;&#xD;&#xA;        Else&#xD;&#xA;            SimboloMoeda = GetCurrentColumnValue(&quot;tbMoedas_Simbolo&quot;)&#xD;&#xA;            Me.Parameters.Item(&quot;SimboloMoedas&quot;).Value = GetCurrentColumnValue(&quot;tbMoedas_Simbolo&quot;)&#xD;&#xA;        End If&#xD;&#xA;        &#xD;&#xA;        Try&#xD;&#xA;            numeroCasasDecimaisMoeda = GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;) &#xD;&#xA;        Catch ex As Exception&#xD;&#xA;            numeroCasasDecimaisMoeda = 0&#xD;&#xA;        End Try&#xD;&#xA;    &#xD;&#xA;        Try&#xD;&#xA;            CMoedas = GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;) &#xD;&#xA;        Catch ex As Exception&#xD;&#xA;            CMoedas = 0&#xD;&#xA;        End Try&#xD;&#xA;        &#xD;&#xA;        Try&#xD;&#xA;            numeroCasasDecimaisPercentagens = GetCurrentColumnValue(&quot;tbParamentrosEmpresa_CasasDecimaisPercentagem&quot;)&#xD;&#xA;        Catch ex As Exception&#xD;&#xA;            numeroCasasDecimaisPercentagens = 0&#xD;&#xA;        End Try &#xD;&#xA;        &#xD;&#xA;        Me.Parameters.Item(&quot;CasasMoedas&quot;).Value = CMoedas&#xD;&#xA;        &#xD;&#xA;        Dim tipoEstrutura = GetCurrentColumnValue(&quot;tbSistemaTiposDocumento_Tipo&quot;)&#xD;&#xA;        Dim acompanhaBens As Boolean = GetCurrentColumnValue(&quot;tbTiposDocumento_AcompanhaBensCirculacao&quot;)&#xD;&#xA;        Me.Parameters.Item(&quot;AcompanhaBens&quot;).Value = False&#xD;&#xA;        &#xD;&#xA;        If GetCurrentColumnValue(&quot;tbTiposDocumento_DocNaoValorizado&quot;) Then&#xD;&#xA;            lblCodigoMoeda.Visible = False&#xD;&#xA;            fldCodigoMoeda.Visible = False&#xD;&#xA;            Me.SubBand14.Visible = True&#xD;&#xA;            If tipoEstrutura = &quot;StkTrfArmazCTrans&quot; Then&#xD;&#xA;                If acompanhaBens Then&#xD;&#xA;                    Me.DRTransfNaoValorizaAcompanha.Visible = True&#xD;&#xA;                    Me.sbTransfNaoValorizaAcompanha.Visible = True&#xD;&#xA;                Else&#xD;&#xA;                    Me.DRTransfNaoValorizado.Visible = True&#xD;&#xA;                    Me.sbTransfNaoValoriza.Visible = True&#xD;&#xA;                End If&#xD;&#xA;                Me.ReportFooter.Visible = False&#xD;&#xA;                Me.SubBand13.Visible = False&#xD;&#xA;            ElseIf tipoEstrutura = &quot;StkEntStk&quot; Or tipoEstrutura = &quot;StkSaidaStk&quot; or tipoEstrutura = &quot;StkReserva&quot; or tipoEstrutura = &quot;StkLibertarReserva&quot; Then&#xD;&#xA;                Me.DRNaoValorizado.Visible = True&#xD;&#xA;                Me.sbNaoValoriza.Visible = True&#xD;&#xA;                Me.ReportFooter.Visible = False&#xD;&#xA;                Me.SubBand13.Visible = False&#xD;&#xA;                If tipoEstrutura = &quot;StkEntStk&quot; Then&#xD;&#xA;                    lblArmazem1.Text = resource.GetResource(&quot;Armazem&quot;, culture)&#xD;&#xA;                    lblLocalizacao1.Text = resource.GetResource(&quot;Local&quot;, culture)&#xD;&#xA;                    Me.fldArmazem1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazens1_CodigoDestino&quot;)&#xD;&#xA;                    Me.fldLocalizacao1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes1_Codigo&quot;)&#xD;&#xA;                ElseIf tipoEstrutura = &quot;StkSaidaStk&quot; or tipoEstrutura = &quot;StkReserva&quot; or tipoEstrutura = &quot;StkLibertarReserva&quot; Then&#xD;&#xA;                    lblArmazem1.Text = resource.GetResource(&quot;Armazem&quot;, culture)&#xD;&#xA;                    lblLocalizacao1.Text = resource.GetResource(&quot;Local&quot;, culture)&#xD;&#xA;                    Me.fldArmazem1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazens_Codigo&quot;)&#xD;&#xA;                    Me.fldLocalizacao1Valoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes_Codigo&quot;)&#xD;&#xA;                End If&#xD;&#xA;            End If&#xD;&#xA;        Else&#xD;&#xA;            Me.SubBand14.Visible = False&#xD;&#xA;            If tipoEstrutura = &quot;StkTrfArmazCTrans&quot; Then&#xD;&#xA;                If acompanhaBens Then&#xD;&#xA;                    Me.DRTransfValorizaAcompanha.Visible = True&#xD;&#xA;                    Me.sbTransfValorizaAcompanha.Visible = True&#xD;&#xA;                    ''''cabeçalhos das linhas - Acompanha Bens&#xD;&#xA;                    Me.lblPreco2.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;Preco&quot;, culture)&#xD;&#xA;                    Me.lblTotalFinal2.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;Total&quot;, culture)&#xD;&#xA;                Else&#xD;&#xA;                    Me.SubBand13.Visible = False&#xD;&#xA;                    Me.DRTransfValorizado.Visible = True&#xD;&#xA;                    Me.sbTransfValorizado.Visible = True&#xD;&#xA;                    ''''cabeçalhos das linhas - Nao Acompanha Bens&#xD;&#xA;                    Me.lblPreco1.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;Preco&quot;, culture)&#xD;&#xA;                    Me.lblTotalFinal1.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;Total&quot;, culture)&#xD;&#xA;                End If&#xD;&#xA;            ElseIf tipoEstrutura = &quot;StkEntStk&quot; OrElse tipoEstrutura = &quot;StkSaidaStk&quot; Then&#xD;&#xA;                Me.DRValorizado.Visible = True&#xD;&#xA;                Me.sbValoriza.Visible = True&#xD;&#xA;                ''''cabeçalhos das linhas&#xD;&#xA;                Me.lblPreco.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;Preco&quot;, culture)&#xD;&#xA;                Me.lblTotalFinal.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;Total&quot;, culture)&#xD;&#xA;                If tipoEstrutura = &quot;StkEntStk&quot; Then&#xD;&#xA;                    lblArmazem.Text = resource.GetResource(&quot;Armazem&quot;, culture)&#xD;&#xA;                    lblLocalizacao.Text = resource.GetResource(&quot;Local&quot;, culture)&#xD;&#xA;                    Me.fldArmazemValoriza.Text = GetCurrentColumnValue(&quot;tbArmazens1_CodigoDestino&quot;)&#xD;&#xA;                    Me.fldLocalizacaoValoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes1_Codigo&quot;)&#xD;&#xA;                ElseIf tipoEstrutura = &quot;StkSaidaStk&quot;  Then&#xD;&#xA;                    lblArmazem.Text = resource.GetResource(&quot;Armazem&quot;, culture)&#xD;&#xA;                    lblLocalizacao.Text = resource.GetResource(&quot;Local&quot;, culture)&#xD;&#xA;                    Me.fldArmazemValoriza.Text = GetCurrentColumnValue(&quot;tbArmazens_Codigo&quot;)&#xD;&#xA;                    Me.fldLocalizacaoValoriza.Text = GetCurrentColumnValue(&quot;tbArmazensLocalizacoes_Codigo&quot;)&#xD;&#xA;                End If&#xD;&#xA;            End If&#xD;&#xA;        End If&#xD;&#xA;        &#xD;&#xA;        ''''Assinatura&#xD;&#xA;        Dim strAssinatura As String = String.Empty&#xD;&#xA;        Dim strValor As String = String.Empty&#xD;&#xA;        Dim strCodigoAT As String  = String.Empty&#xD;&#xA;        &#xD;&#xA;        strValor = GetCurrentColumnValue(&quot;MensagemDocAT&quot;)&#xD;&#xA;&#xD;&#xA;        Dim strAss As String = String.Empty&#xD;&#xA;        Dim strMsg As String = String.Empty&#xD;&#xA;        If strValor.IndexOf(Constantes.SaftAT.CSeparadorMsgAt) &gt; 0 Then&#xD;&#xA;            strAss = strValor.Substring(0, strValor.IndexOf(Constantes.SaftAT.CSeparadorMsgAt))&#xD;&#xA;            strMsg = strValor.Substring(strValor.IndexOf(Constantes.SaftAT.CSeparadorMsgAt) + Constantes.SaftAT.CSeparadorMsgAt.Length)&#xD;&#xA;        Else&#xD;&#xA;            strAss = strValor&#xD;&#xA;        End If&#xD;&#xA;&#xD;&#xA;        strCodigoAT  = GetCurrentColumnValue(&quot;CodigoAT&quot;)&#xD;&#xA;&#xD;&#xA;        If acompanhaBens Then&#xD;&#xA;            If Me.lblNumVias.Text = &quot;Original&quot; OrElse Me.lblNumVias.Text = &quot;Duplicado&quot; OrElse Me.lblNumVias.Text = &quot;Triplicado&quot; Then&#xD;&#xA;            Else&#xD;&#xA;                Dim strCopia As String = &quot;Cópia de documento não válida para os fins previstos no regime de bens em circulação&quot;&#xD;&#xA;                strMsg = strCopia + strMsg&#xD;&#xA;            End If&#xD;&#xA;        End If&#xD;&#xA;&#xD;&#xA;        If strCodigoAT &lt;&gt; String.Empty Then&#xD;&#xA;            strMsg += &quot; | ATDocCodeId: &quot; &amp; strCodigoAT&#xD;&#xA;        End If&#xD;&#xA;&#xD;&#xA;        Me.fldAssinatura.Text = strAss&#xD;&#xA;        Me.fldAssinatura1.Text = strAss&#xD;&#xA;        Me.fldassinaturanaoval.Text = strAss&#xD;&#xA;        Me.fldMensagemDocAT.Text = strMsg&#xD;&#xA;        Me.fldMensagemDocAT1.Text = strMsg&#xD;&#xA;        Me.fldAssinatura11.Text = strMsg&#xD;&#xA;&#xD;&#xA;        Me.fldMensagemDocAT.Multiline = True&#xD;&#xA;        Me.fldMensagemDocAT1.Multiline = True&#xD;&#xA;        Me.fldAssinatura11.Multiline = True       &#xD;&#xA;        &#xD;&#xA;        If GetCurrentColumnValue(&quot;tbTiposDocumento_AcompanhaBensCirculacao&quot;) Then&#xD;&#xA;            If Me.Parameters(&quot;Via&quot;).Value.ToString &lt;&gt; &quot;Original&quot; AndAlso Me.Parameters(&quot;Via&quot;).Value.ToString &lt;&gt; &quot;Duplicado&quot; AndAlso Me.Parameters(&quot;Via&quot;).Value.ToString &lt;&gt; &quot;Triplicado&quot; Then&#xD;&#xA;                lblCopia1.Text = &quot;Cópia de documento não válida para os fins previstos no regime de bens em circulação&quot;&#xD;&#xA;                lblCopia2.Text = &quot;Cópia de documento não válida para os fins previstos no regime de bens em circulação&quot;&#xD;&#xA;                lblCopia3.Text = &quot;Cópia de documento não válida para os fins previstos no regime de bens em circulação&quot;&#xD;&#xA;            End If&#xD;&#xA;        End If&#xD;&#xA;        &#xD;&#xA;        ''''Separadores totalizadores&#xD;&#xA;        Me.lblSubTotal.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;SubTotal&quot;, culture)&#xD;&#xA;        Me.lblTotalIva.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;TotalIva&quot;, culture)&#xD;&#xA;        Me.lblTotalMoedaDocumento.Text = SimboloMoeda &amp; &quot; &quot; &amp; resource.GetResource(&quot;TotalMoedaDocumento&quot;, culture)&#xD;&#xA;        &#xD;&#xA;        ''''Identificação do documento&#xD;&#xA;        Me.lblTipoDocumento.Text = if(GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;) is DBNull.value, &quot;&quot;,  resource.GetResource(GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;), culture))&#xD;&#xA;        Me.lblTipoDocumento1.Text = if(GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;) is DBNull.value, &quot;&quot;,  resource.GetResource(GetCurrentColumnValue(&quot;tbSistemaTiposDocumentoFiscal_Descricao&quot;), culture))&#xD;&#xA;        &#xD;&#xA;        If Me.lblTipoDocumento.Text = &quot;&quot; OrElse Me.lblTipoDocumento.Text = &quot;NaoFiscal&quot; Then&#xD;&#xA;            Me.lblTipoDocumento.Text = if(GetCurrentColumnValue(&quot;tbTiposDocumento_Descricao&quot;) is DBNull.value, &quot;&quot;,  GetCurrentColumnValue(&quot;tbTiposDocumento_Descricao&quot;))&#xD;&#xA;            Me.lblTipoDocumento1.Text = if(GetCurrentColumnValue(&quot;tbTiposDocumento_Descricao&quot;) is DBNull.value, &quot;&quot;,  GetCurrentColumnValue(&quot;tbTiposDocumento_Descricao&quot;))&#xD;&#xA;        End If&#xD;&#xA;        &#xD;&#xA;        If GetCurrentColumnValue(&quot;CodigoTipoEstado&quot;) = &quot;ANL&quot; Then&#xD;&#xA;            Me.lblAnulado.Text = resource.GetResource(&quot;Anulado&quot;, culture)&#xD;&#xA;            Me.lblAnulado.Visible = True&#xD;&#xA;        End If&#xD;&#xA;        &#xD;&#xA;        If not GetCurrentColumnValue(&quot;SegundaVia&quot;) is dbnull.value andalso GetCurrentColumnValue(&quot;SegundaVia&quot;) = &quot;True&quot; Then&#xD;&#xA;            If Me.lblAnulado.Visible Then&#xD;&#xA;                Me.lblSegundaVia.Visible = False&#xD;&#xA;                Me.lblNumVias.Visible = True&#xD;&#xA;            Else&#xD;&#xA;                Me.lblSegundaVia.Text = resource.GetResource(&quot;SegundaVia&quot;, culture)&#xD;&#xA;                Me.lblSegundaVia.Visible = True&#xD;&#xA;                Me.lblNumVias.Visible = False&#xD;&#xA;            End If&#xD;&#xA;        End If&#xD;&#xA;        &#xD;&#xA;        Dim MoradaCarga As String = String.Empty&#xD;&#xA;        Dim MoradaDescarga As String = String.Empty&#xD;&#xA;        If MoradaCarga &lt;&gt; String.Empty Or MoradaDescarga &lt;&gt; String.Empty Then&#xD;&#xA;            If acompanhaBens Then&#xD;&#xA;                Me.SubBand15.Visible = True&#xD;&#xA;            Else&#xD;&#xA;                Me.SubBand15.Visible = False&#xD;&#xA;            End If&#xD;&#xA;        Else&#xD;&#xA;            Me.SubBand15.Visible = True&#xD;&#xA;        End If&#xD;&#xA;        traducoes()&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Public Sub traducoes()&#xD;&#xA;    Dim resource As ReportTranslation = New ReportTranslation&#xD;&#xA;    Dim culture As String = Me.Parameters(&quot;Culture&quot;).Value.ToString&#xD;&#xA;    ''''Artigo&#xD;&#xA;    Me.lblArtigo.Text = resource.GetResource(&quot;Artigo&quot;, culture)&#xD;&#xA;    Me.lblArtigo1.Text = resource.GetResource(&quot;Artigo&quot;, culture)&#xD;&#xA;    Me.lblArtigo2.Text = resource.GetResource(&quot;Artigo&quot;, culture)&#xD;&#xA;    Me.lblArtigo3.Text = resource.GetResource(&quot;Artigo&quot;, culture)&#xD;&#xA;    Me.lblArtigo4.Text = resource.GetResource(&quot;Artigo&quot;, culture)&#xD;&#xA;    Me.lblArtigo5.Text = resource.GetResource(&quot;Artigo&quot;, culture)&#xD;&#xA;    ''''Descrição&#xD;&#xA;    Me.lblDescricao.Text = resource.GetResource(&quot;Descricao&quot;, culture)&#xD;&#xA;    Me.lblDescricao1.Text = resource.GetResource(&quot;Descricao&quot;, culture)&#xD;&#xA;    Me.lblDescricao2.Text = resource.GetResource(&quot;Descricao&quot;, culture)&#xD;&#xA;    Me.lblDescricao3.Text = resource.GetResource(&quot;Descricao&quot;, culture)&#xD;&#xA;    Me.lblDescricao4.Text = resource.GetResource(&quot;Descricao&quot;, culture)&#xD;&#xA;    Me.lblDescricao5.Text = resource.GetResource(&quot;Descricao&quot;, culture)&#xD;&#xA;    ''''Lote&#xD;&#xA;    Me.lblLote.Text = resource.GetResource(&quot;Lote&quot;, culture)&#xD;&#xA;    Me.lblLote1.Text = resource.GetResource(&quot;Lote&quot;, culture)&#xD;&#xA;    Me.lblLote2.Text = resource.GetResource(&quot;Lote&quot;, culture)&#xD;&#xA;    Me.lblLote3.Text = resource.GetResource(&quot;Lote&quot;, culture)&#xD;&#xA;    Me.lblLote4.Text = resource.GetResource(&quot;Lote&quot;, culture)&#xD;&#xA;    Me.lblLote5.Text = resource.GetResource(&quot;Lote&quot;, culture)&#xD;&#xA;    ''''Armazens&#xD;&#xA;    Me.lblArmazemSai.Text = resource.GetResource(&quot;ArmazemSai&quot;, culture)&#xD;&#xA;    Me.lblArmazemSai1.Text = resource.GetResource(&quot;ArmazemSai&quot;, culture)&#xD;&#xA;    Me.lblArmazemEnt2.Text = resource.GetResource(&quot;ArmazemEnt&quot;, culture)&#xD;&#xA;    Me.lblArmazemEnt2.Text = resource.GetResource(&quot;ArmazemEnt&quot;, culture)&#xD;&#xA;    ''''Localizações&#xD;&#xA;    Me.lblLocalEnt.Text = resource.GetResource(&quot;LocalEnt&quot;, culture)&#xD;&#xA;    Me.lblLocalEnt1.Text = resource.GetResource(&quot;LocalEnt&quot;, culture)&#xD;&#xA;    Me.lblLocalSaida.Text = resource.GetResource(&quot;LocalSai&quot;, culture)&#xD;&#xA;    Me.lblLocalSaida.Text = resource.GetResource(&quot;LocalSai&quot;, culture)&#xD;&#xA;    Me.lblUni.Text = resource.GetResource(&quot;Unidade&quot;, culture)&#xD;&#xA;    Me.lblUni1.Text = resource.GetResource(&quot;Unidade&quot;, culture)&#xD;&#xA;    Me.lblUni2.Text = resource.GetResource(&quot;Unidade&quot;, culture)&#xD;&#xA;    Me.lblUni3.Text = resource.GetResource(&quot;Unidade&quot;, culture)&#xD;&#xA;    Me.lblUni4.Text = resource.GetResource(&quot;Unidade&quot;, culture)&#xD;&#xA;    Me.lblUni5.Text = resource.GetResource(&quot;Unidade&quot;, culture)&#xD;&#xA;    Me.lblQuantidade.Text = resource.GetResource(&quot;Qtd&quot;, culture)&#xD;&#xA;    Me.lblQuantidade1.Text = resource.GetResource(&quot;Qtd&quot;, culture)&#xD;&#xA;    Me.lblQuantidade2.Text = resource.GetResource(&quot;Qtd&quot;, culture)&#xD;&#xA;    Me.lblQuantidade3.Text = resource.GetResource(&quot;Qtd&quot;, culture)&#xD;&#xA;    Me.lblQuantidade4.Text = resource.GetResource(&quot;Qtd&quot;, culture)&#xD;&#xA;    Me.lblQuantidade5.Text = resource.GetResource(&quot;Qtd&quot;, culture)&#xD;&#xA;    Me.lblIsencao1.Text = resource.GetResource(&quot;Isencao&quot;, culture)&#xD;&#xA;    Me.lblContribuinte.Text = resource.GetResource(&quot;Contribuinte&quot;, culture)&#xD;&#xA;    Me.lblClienteCodigo.Text = resource.GetResource(&quot;ClienteCodigo&quot;, culture)&#xD;&#xA;    Me.lblCodigoMoeda.Text = resource.GetResource(&quot;CodigoMoeda&quot;, culture)&#xD;&#xA;    Me.lblDataDocumento.Text = resource.GetResource(&quot;DataDocumento&quot;, culture)&#xD;&#xA;    Me.lblCarga.Text = resource.GetResource(&quot;Carga&quot;, culture)&#xD;&#xA;    Me.lblDescarga.Text = resource.GetResource(&quot;Descarga&quot;, culture)&#xD;&#xA;    Me.lblExpedicao.Text = resource.GetResource(&quot;Matricula&quot;, culture)&#xD;&#xA;    ''''Me.lblTituloTransporte.Text = resource.GetResource(&quot;TituloTransporte&quot;, culture)&#xD;&#xA;    Me.lblTituloTransportar.Text = resource.GetResource(&quot;TituloTransportar&quot;, culture)&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub fldPreco1_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;    If Me.fldArtigo.Text = String.Empty Then&#xD;&#xA;        fldPreco1.Text = String.Empty&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;&#xD;&#xA;Private Sub fldPreco2_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;    If Me.fldArtigo4.Text = String.Empty Then&#xD;&#xA;        fldPreco2.Text = &quot;&quot;&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;&#xD;&#xA;Private Sub fldTotalFinal2_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;    If Me.fldArtigo4.Text = String.Empty Then&#xD;&#xA;        fldTotalFinal2.Text = &quot;&quot;&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;&#xD;&#xA;Private Sub fldPreco_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;    If Me.fldArtigo1.Text = String.Empty Then&#xD;&#xA;        fldPreco.Text = &quot;&quot;&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;&#xD;&#xA;Private Sub fldTotalFinal_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;    If Me.fldArtigo1.Text = String.Empty Then&#xD;&#xA;        fldTotalFinal.Text = &quot;&quot;&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;&#xD;&#xA;&#xD;&#xA;Private Sub fldTotalFinal1_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;    If Me.fldArtigo.Text = String.Empty Then&#xD;&#xA;        fldTotalFinal1.Text = &quot;&quot;&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub fldCodigoMotivoIsencaoIva_BeforePrint(ByVal sender As Object, ByVal e As System.Drawing.Printing.PrintEventArgs)&#xD;&#xA;    If (Me.fldTaxaIVA2.Text = String.Empty And fldTaxaIVA2.Visible = True) OrElse (CDbl(Me.fldTaxaIVA2.Text) = 0 And fldTaxaIVA2.Visible = True) Then&#xD;&#xA;        Me.fldCodigoMotivoIsencaoIva.Visible = True&#xD;&#xA;    Else&#xD;&#xA;        Me.fldCodigoMotivoIsencaoIva.Visible = False&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub fldTaxaIVA_AfterPrint(ByVal sender As Object, ByVal e As System.EventArgs)&#xD;&#xA;   AfterPrintValores()&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub fldUnidade_AfterPrint(ByVal sender As Object, ByVal e As System.EventArgs)&#xD;&#xA;   AfterPrintValores()&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub fldTaxaIVA1_AfterPrint(ByVal sender As Object, ByVal e As System.EventArgs)&#xD;&#xA;   AfterPrintValores()&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub XrLabel55_AfterPrint(ByVal sender As Object, ByVal e As System.EventArgs)&#xD;&#xA;    AfterPrintValores()&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub XrLabel52_AfterPrint(ByVal sender As Object, ByVal e As System.EventArgs)&#xD;&#xA;   AfterPrintValores()&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Public Sub AfterPrintValores()&#xD;&#xA;    Dim aux As Integer = 0&#xD;&#xA;    Dim coluna As ResultColumn&#xD;&#xA;    Dim rs As ResultSet = TryCast(TryCast(Me.DataSource, IListSource).GetList(), ResultSet)&#xD;&#xA;    Dim rsDV As ResultTable = rs.Tables.FirstOrDefault(Function(x) x.TableName.Equals(&quot;tbDocumentosStock&quot;))&#xD;&#xA;    ''''leitura de dados do cabeçalho&#xD;&#xA;    If rsDV IsNot Nothing Then&#xD;&#xA;        If rsDV.Count &gt; 0 Then&#xD;&#xA;            coluna = rsDV.Columns.Find(Function(col) col.Name.Equals(&quot;tbDocumentosStockLinhas_ID&quot;))&#xD;&#xA;            Dim IDLinha As Long = Convert.ToString(coluna.GetValue(DirectCast(DirectCast(rsDV, IList)(count2), ResultRow)))&#xD;&#xA;            Me.Parameters.Item(&quot;IDLinha&quot;).Value = IDLinha&#xD;&#xA;            coluna = rsDV.Columns.Find(Function(col) col.Name.Equals(&quot;NumCasasDecUnidade&quot;))&#xD;&#xA;            Dim CDecimais As Integer&#xD;&#xA;            Try&#xD;&#xA;                CDecimais = Convert.ToString(coluna.GetValue(DirectCast(DirectCast(rsDV, IList)(count2), ResultRow)))&#xD;&#xA;            Catch ex As Exception&#xD;&#xA;                CDecimais = 0&#xD;&#xA;            End Try&#xD;&#xA;            Me.Parameters.Item(&quot;CasasDecimais&quot;).Value = CDecimais&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;    count2 += 1&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub fldCodigoMotivoIsencaoIva_AfterPrint(ByVal sender As Object, ByVal e As System.EventArgs)&#xD;&#xA;   ''''AfterPrintValores()&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub fldAssinatura1_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = e.PageCount - 1 Then&#xD;&#xA;        Me.fldAssinatura1.Visible = False&#xD;&#xA;        me.lblCopia3.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        Me.fldAssinatura1.Visible = True&#xD;&#xA;        me.lblCopia3.Visible = True&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub fldAssinatura11_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = e.PageCount - 1 Then&#xD;&#xA;        Me.fldAssinatura11.Visible = False&#xD;&#xA;        me.lblCopia3.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        Me.fldAssinatura11.Visible = True&#xD;&#xA;        me.lblCopia3.Visible = True&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTransportar_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;     If e.PageIndex = e.PageCount - 1 Then&#xD;&#xA;        Me.lblTransportar.Visible = False&#xD;&#xA;        Me.lblTituloTransportar.Visible = False&#xD;&#xA;        Me.fldAssinatura1.Visible = False&#xD;&#xA;        Me.fldAssinatura11.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbTiposDocumento_DocNaoValorizado&quot;) Then&#xD;&#xA;            Me.lblTransportar.Visible = False&#xD;&#xA;            Me.lblTituloTransportar.Visible = False&#xD;&#xA;        Else&#xD;&#xA;            Me.lblTransportar.Visible = True&#xD;&#xA;            Me.lblTituloTransportar.Visible = True&#xD;&#xA;        End If&#xD;&#xA;        Me.fldAssinatura1.Visible = True&#xD;&#xA;        Me.fldAssinatura11.Visible = True&#xD;&#xA;    End If&#xD;&#xA;    Dim label as DevExpress.XtraReports.UI.XRLabel = sender&#xD;&#xA;    Dim page as DevExpress.XtraPrinting.Page = label.RootReport.Pages(e.PageIndex)     &#xD;&#xA;    Dim iterator as DevExpress.XtraPrinting.Native.NestedBrickIterator = new DevExpress.XtraPrinting.Native.NestedBrickIterator(page.InnerBricks)&#xD;&#xA;    While (iterator.MoveNext())&#xD;&#xA;        If (TypeOf iterator.CurrentBrick Is VisualBrick AndAlso (CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).BrickOwner.Name.Equals(&quot;fldTotalFinal&quot;))&#xD;&#xA;            dblTransportar += Convert.ToDecimal((CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).TextValue)&#xD;&#xA;        End If&#xD;&#xA;        If (TypeOf iterator.CurrentBrick Is VisualBrick AndAlso (CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).BrickOwner.Name.Equals(&quot;fldTotalFinal1&quot;))&#xD;&#xA;            dblTransportar += Convert.ToDecimal((CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).TextValue)&#xD;&#xA;        End If&#xD;&#xA;         If (TypeOf iterator.CurrentBrick Is VisualBrick AndAlso (CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).BrickOwner.Name.Equals(&quot;fldTotalFinal2&quot;))&#xD;&#xA;            dblTransportar += Convert.ToDecimal((CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).TextValue)&#xD;&#xA;        End If&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;) is DBNull.value Then&#xD;&#xA;                label.Text = dblTransportar.ToString()&#xD;&#xA;            Else&#xD;&#xA;                label.Text = Convert.ToDouble(dblTransportar.ToString()).ToString(&quot;F&quot; &amp; GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;))&#xD;&#xA;            End If&#xD;&#xA;    End While&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTituloTransportar_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = e.PageCount - 1 Then&#xD;&#xA;        Me.lblTituloTransportar.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbTiposDocumento_DocNaoValorizado&quot;) Then&#xD;&#xA;            Me.lblTituloTransportar.Visible = False&#xD;&#xA;        Else&#xD;&#xA;            Me.lblTituloTransportar.Visible = True&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTransporte_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;    If e.PageIndex = 0 Then&#xD;&#xA;        Me.lblTituloTransporte.Visible = False&#xD;&#xA;        Me.lblTransporte.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbTiposDocumento_DocNaoValorizado&quot;) Then&#xD;&#xA;            Me.lblTituloTransporte.Visible = False&#xD;&#xA;            Me.lblTransporte.Visible = False&#xD;&#xA;        Else&#xD;&#xA;            Me.lblTituloTransporte.Visible = True&#xD;&#xA;            Me.lblTransporte.Visible = True&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;    If e.PageIndex &gt; 0 then&#xD;&#xA;        Dim label as DevExpress.XtraReports.UI.XRLabel = sender&#xD;&#xA;        Dim page as DevExpress.XtraPrinting.Page = label.RootReport.Pages(e.PageIndex - 1)     &#xD;&#xA;        Dim iterator as DevExpress.XtraPrinting.Native.NestedBrickIterator = new DevExpress.XtraPrinting.Native.NestedBrickIterator(page.InnerBricks)&#xD;&#xA;        While (iterator.MoveNext())&#xD;&#xA;            If (TypeOf iterator.CurrentBrick Is VisualBrick AndAlso (CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).BrickOwner.Name.Equals(&quot;fldTotalFinal&quot;))&#xD;&#xA;                dblTransporte += Convert.ToDecimal((CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).TextValue)&#xD;&#xA;            End If&#xD;&#xA;            If (TypeOf iterator.CurrentBrick Is VisualBrick AndAlso (CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).BrickOwner.Name.Equals(&quot;fldTotalFinal1&quot;))&#xD;&#xA;                dblTransporte += Convert.ToDecimal((CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).TextValue)&#xD;&#xA;            End If&#xD;&#xA;            If (TypeOf iterator.CurrentBrick Is VisualBrick AndAlso (CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).BrickOwner.Name.Equals(&quot;fldTotalFinal2&quot;))&#xD;&#xA;                dblTransporte += Convert.ToDecimal((CType(iterator.CurrentBrick, DevExpress.XtraPrinting.VisualBrick)).TextValue)&#xD;&#xA;            End If&#xD;&#xA;            If GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;) is DBNull.value Then&#xD;&#xA;                label.Text = dblTransporte.ToString()&#xD;&#xA;            Else&#xD;&#xA;                label.Text = Convert.ToDouble(dblTransporte.ToString()).ToString(&quot;F&quot; &amp; GetCurrentColumnValue(&quot;tbMoedas_CasasDecimaisTotais&quot;))&#xD;&#xA;            End If&#xD;&#xA;        End While&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;Private Sub lblTituloTransporte_PrintOnPage(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs)&#xD;&#xA;     If e.PageIndex = 0 Then&#xD;&#xA;        Me.lblTituloTransporte.Visible = False&#xD;&#xA;    Else&#xD;&#xA;        If GetCurrentColumnValue(&quot;tbTiposDocumento_DocNaoValorizado&quot;) Then&#xD;&#xA;            Me.lblTituloTransporte.Visible = False&#xD;&#xA;        Else&#xD;&#xA;            Me.lblTituloTransporte.Visible = True&#xD;&#xA;        End If&#xD;&#xA;    End If&#xD;&#xA;End Sub&#xD;&#xA;&#xD;&#xA;" DrawWatermark="true" Margins="54, 23, 25, 1" PaperKind="A4" PageWidth="827" PageHeight="1169" ScriptLanguage="VisualBasic" Version="18.2" DataMember="tbDocumentosStock_Cab" DataSource="#Ref-0">
  <Extensions>
    <Item1 Ref="2" Key="DataSerializationExtension" Value="DevExpress.XtraReports.Web.ReportDesigner.DefaultDataSerializer" />
  </Extensions>
  <Parameters>
    <Item1 Ref="4" Description="IDDocumento" ValueInfo="20" Name="IDDocumento" Type="#Ref-3" />
    <Item2 Ref="6" Description="Culture" ValueInfo="pt-PT" Name="Culture" />
    <Item3 Ref="7" Visible="false" Description="Via" Name="Via" />
    <Item4 Ref="8" Visible="false" Description="BDEmpresa" ValueInfo="Teste" Name="BDEmpresa" />
    <Item5 Ref="9" Visible="false" Description="Observacoes" ValueInfo="select ID, Observacoes from tbDocumentosStock where ID=" Name="Observacoes" />
    <Item6 Ref="11" Visible="false" Description="IDLoja" ValueInfo="1" Name="IDLoja" Type="#Ref-10" />
    <Item7 Ref="12" Visible="false" Description="FraseFiscal" ValueInfo="FraseFiscal" Name="FraseFiscal" />
    <Item8 Ref="13" Description="IDEmpresa" ValueInfo="1" Name="IDEmpresa" Type="#Ref-3" />
    <Item9 Ref="15" Visible="false" Description="AcompanhaBens" ValueInfo="true" Name="AcompanhaBens" Type="#Ref-14" />
    <Item10 Ref="16" Description="IDLinha" ValueInfo="0" Name="IDLinha" Type="#Ref-3" />
    <Item11 Ref="18" Description="CasasDecimais" ValueInfo="0" Name="CasasDecimais" Type="#Ref-17" />
    <Item12 Ref="19" Description="CasasMoedas" ValueInfo="0" Name="CasasMoedas" Type="#Ref-17" />
    <Item13 Ref="20" Description="SimboloMoedas" Name="SimboloMoedas" />
    <Item14 Ref="21" Description="UrlServerPath" AllowNull="true" Name="UrlServerPath" />
    <Item15 Ref="22" Description="Utilizador" Name="Utilizador" />
  </Parameters>
  <CalculatedFields>
    <Item1 Ref="23" Name="SomaQuantidade" FieldType="Float" DisplayName="SomaQuantidade" Expression="[].Sum([Quantidade])" DataMember="tbDocumentosVendas" />
    <Item2 Ref="24" Name="SomaValorIVA" FieldType="Float" Expression="[].Sum([ValorIVA])" DataMember="tbDocumentosVendas" />
    <Item3 Ref="25" Name="SomaValorIncidencia" FieldType="Float" Expression="[].Sum([ValorIncidencia])" DataMember="tbDocumentosVendas" />
    <Item4 Ref="26" Name="SomaTotalFinal" FieldType="Double" Expression="[].Sum([TotalFinal])" DataMember="tbDocumentosVendas" />
    <Item5 Ref="27" Name="MotivoIsencao" DisplayName="MotivoIsencao" Expression="IIF([TaxaIva]=0, '''''''', [CodigoMotivoIsencaoIva])" DataMember="tbDocumentosVendas" />
  </CalculatedFields>
  <Bands>
    <Item1 Ref="28" ControlType="TopMarginBand" Name="TopMargin" HeightF="25" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item2 Ref="29" ControlType="ReportHeaderBand" Name="ReportHeader" HeightF="0" />
    <Item3 Ref="30" ControlType="PageHeaderBand" Name="PageHeader" HeightF="2.09">
      <SubBands>
        <Item1 Ref="31" ControlType="SubBand" Name="SubBand11" HeightF="107.87">
          <Scripts Ref="32" OnBeforePrint="SubBand1_BeforePrint" />
          <Controls>
            <Item1 Ref="33" ControlType="XRSubreport" Name="XrSubreport1" ReportSourceUrl="10000" SizeF="535.2748,105.7917" LocationFloat="0, 0">
              <ParameterBindings>
                <Item1 Ref="34" ParameterName="IDLoja" DataMember="tbDocumentosStock.IDLoja" />
                <Item2 Ref="36" ParameterName="" Parameter="#Ref-6" />
                <Item3 Ref="37" ParameterName="" Parameter="#Ref-8" />
                <Item4 Ref="38" ParameterName="" DataMember="tbDocumentosVendas.DesignacaoComercialLoja" />
                <Item5 Ref="39" ParameterName="" DataMember="tbDocumentosVendas.MoradaLoja" />
                <Item6 Ref="40" ParameterName="" DataMember="tbDocumentosVendas.LocalidadeLoja" />
                <Item7 Ref="41" ParameterName="" DataMember="tbDocumentosVendas.CodigoPostalLoja" />
                <Item8 Ref="42" ParameterName="" DataMember="tbDocumentosVendas.SiglaLoja" />
                <Item9 Ref="43" ParameterName="" DataMember="tbDocumentosVendas.NIFLoja" />
                <Item10 Ref="44" ParameterName="" Parameter="#Ref-13" />
                <Item11 Ref="45" ParameterName="" Parameter="#Ref-21" />
              </ParameterBindings>
              <Scripts Ref="46" OnBeforePrint="XrSubreport1_BeforePrint" />
            </Item1>
            <Item2 Ref="47" ControlType="XRLabel" Name="fldDataVencimento" TextFormatString="{0:dd-MM-yyyy}" CanGrow="false" TextAlignment="TopRight" SizeF="83.64227,20" LocationFloat="662.777, 78.02378" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
              <ExpressionBindings>
                <Item1 Ref="48" Expression="[DataDocumento]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="49" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="50" ControlType="XRLabel" Name="fldTipoDocumento" TextAlignment="TopRight" SizeF="159.7648,20.54824" LocationFloat="586.78, 33.55265" Font="Arial, 9.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="51" Expression="[tbTiposDocumento_Codigo] + '''' '''' + [CodigoSerie] + ''''/'''' + [NumeroDocumento]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="52" UseFont="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="53" ControlType="XRLabel" Name="lblDataDocumento" Text="Data" TextAlignment="TopRight" SizeF="84.06,15" LocationFloat="662.777, 63.10085" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="DataDocumento">
              <StylePriority Ref="54" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="55" ControlType="XRLabel" Name="lblNumVias" Text="Via" TextAlignment="TopRight" SizeF="160.2199,11.77632" LocationFloat="586.78, 0" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <ExpressionBindings>
                <Item1 Ref="56" Expression="?Via " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="57" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item5>
            <Item6 Ref="58" ControlType="XRLabel" Name="lblTipoDocumento" Text="Fatura" TextAlignment="TopRight" SizeF="159.7648,13.77632" LocationFloat="586.78, 19.77634" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="59" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="60" ControlType="XRLabel" Name="lblAnulado" Angle="20" Text="ANULADO" TextAlignment="MiddleCenter" SizeF="189.8313,105.7917" LocationFloat="427.3537, 0" Font="Arial, 24pt, style=Bold, charSet=0" ForeColor="Red" Padding="2,2,0,0,100" Visible="false">
              <StylePriority Ref="61" UseFont="false" UseForeColor="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="62" ControlType="XRLabel" Name="lblSegundaVia" Text="2º Via" TextAlignment="TopRight" SizeF="80.59814,13.77632" LocationFloat="665.8211, 0" Font="Arial, 9pt, style=Bold, charSet=0" ForeColor="Black" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Visible="false">
              <StylePriority Ref="63" UseFont="false" UseForeColor="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item8>
          </Controls>
          <ExpressionBindings>
            <Item1 Ref="64" Expression="(([tbSistemaTiposDocumento_Tipo] != ''''StkEntStk'''')  And&#xA;([tbSistemaTiposDocumento_Tipo] != ''''StkSaidaStk'''')) And&#xA;([tbSistemaTiposDocumento_Tipo] != ''''StkTrfArmazCTrans'''' or [TipoFiscal] != ''''NF'''')" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item1>
        <Item2 Ref="65" ControlType="SubBand" Name="SubBand1" HeightF="150.42">
          <Controls>
            <Item1 Ref="66" ControlType="XRPanel" Name="XrPanel1" SizeF="746.837,148.3334" LocationFloat="0, 0">
              <Controls>
                <Item1 Ref="67" ControlType="XRLabel" Name="fldCodigoPostal" Text="Código Postal" TextAlignment="TopRight" SizeF="296.2911,22.99999" LocationFloat="381.5468, 86" Font="Arial, 9.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="68" Expression="iif( not [tbTiposDocumento_AcompanhaBensCirculacao], False, True)" PropertyName="Visible" EventName="BeforePrint" />
                    <Item2 Ref="69" Expression="[tbCodigosPostaisCliente_Codigo] + '''' '''' + [tbCodigosPostaisCliente_Descricao]" PropertyName="Text" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="70" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item1>
                <Item2 Ref="71" ControlType="XRLabel" Name="fldCodigoMoeda" TextAlignment="TopLeft" SizeF="194.7021,13.99999" LocationFloat="103.1326, 49.00001" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="72" Expression="[tbMoedas_Codigo]" PropertyName="Text" EventName="BeforePrint" />
                    <Item2 Ref="73" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , False, true)" PropertyName="Visible" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="74" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item2>
                <Item3 Ref="75" ControlType="XRLabel" Name="lblCodigoMoeda" Text="Moeda" TextAlignment="TopLeft" SizeF="102.121,14" LocationFloat="1.010068, 49.00004" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Parentesco">
                  <ExpressionBindings>
                    <Item1 Ref="76" Expression="iif( [tbTiposDocumento_DocNaoValorizado] , False, true)" PropertyName="Visible" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="77" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item3>
                <Item4 Ref="78" ControlType="XRLabel" Name="fldMorada" Text="Morada" TextAlignment="TopRight" SizeF="296.2915,23" LocationFloat="381.5468, 63" Font="Arial, 9.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="79" Expression="[tbClientesMoradas_Morada]" PropertyName="Text" EventName="BeforePrint" />
                    <Item2 Ref="80" Expression="iif( not [tbTiposDocumento_AcompanhaBensCirculacao], False, True)" PropertyName="Visible" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="81" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item4>
                <Item5 Ref="82" ControlType="XRLabel" Name="fldNome" Text="Nome" TextAlignment="TopRight" SizeF="296.2916,23" LocationFloat="381.5467, 40" Font="Arial, 9.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="83" Expression="[tbClientes_Nome]" PropertyName="Text" EventName="BeforePrint" />
                    <Item2 Ref="84" Expression="iif( not [tbTiposDocumento_AcompanhaBensCirculacao], False, True)" PropertyName="Visible" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="85" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item5>
                <Item6 Ref="86" ControlType="XRLabel" Name="lblTitulo" Text="Exmo.(a) Sr.(a) " TextAlignment="TopRight" SizeF="296.2916,20" LocationFloat="381.5464, 20" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="87" Expression="iif( not [tbTiposDocumento_AcompanhaBensCirculacao], False, True)" PropertyName="Visible" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="88" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item6>
                <Item7 Ref="89" ControlType="XRLabel" Name="lblContribuinte" Text="Contribuinte nº" TextAlignment="TopLeft" SizeF="102.121,14" LocationFloat="1.010005, 21.00004" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Contribuinte">
                  <Scripts Ref="90" OnBeforePrint="lblContribuinte_BeforePrint" />
                  <ExpressionBindings>
                    <Item1 Ref="91" Expression="iif( not [tbTiposDocumento_AcompanhaBensCirculacao], False, True)" PropertyName="Visible" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="92" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item7>
                <Item8 Ref="93" ControlType="XRLabel" Name="lblClienteCodigo" Text="Cod. Cliente" TextAlignment="TopLeft" SizeF="102.121,14" LocationFloat="1.010036, 35.00004" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Cliente">
                  <ExpressionBindings>
                    <Item1 Ref="94" Expression="iif( not [tbTiposDocumento_AcompanhaBensCirculacao], False, True)" PropertyName="Visible" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="95" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item8>
                <Item9 Ref="96" ControlType="XRLabel" Name="fldClienteCodigo" TextAlignment="TopLeft" SizeF="194.7036,14" LocationFloat="103.131, 35.00001" Font="Arial, 8pt" Padding="2,2,0,0,100" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="97" Expression="[tbClientes_Codigo]" PropertyName="Text" EventName="BeforePrint" />
                    <Item2 Ref="98" Expression="iif( not [tbTiposDocumento_AcompanhaBensCirculacao], False, True)" PropertyName="Visible" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="99" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item9>
                <Item10 Ref="100" ControlType="XRLabel" Name="fldContribuinteFiscal" TextAlignment="TopLeft" SizeF="194.715,13.99999" LocationFloat="103.1311, 21" Font="Arial, 8pt" Padding="2,2,0,0,100" BorderWidth="0">
                  <ExpressionBindings>
                    <Item1 Ref="101" Expression="[tbClientes_NContribuinte]" PropertyName="Text" EventName="BeforePrint" />
                    <Item2 Ref="102" Expression="iif( not [tbTiposDocumento_AcompanhaBensCirculacao], False, True)" PropertyName="Visible" EventName="BeforePrint" />
                  </ExpressionBindings>
                  <StylePriority Ref="103" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
                </Item10>
              </Controls>
            </Item1>
          </Controls>
          <ExpressionBindings>
            <Item1 Ref="104" Expression="((([tbSistemaTiposDocumento_Tipo] != ''''StkEntStk'''')  And&#xA;([tbSistemaTiposDocumento_Tipo] != ''''StkSaidaStk'''') And&#xA;([tbSistemaTiposDocumento_Tipo] != ''''StkReserva'''') And&#xA;([tbSistemaTiposDocumento_Tipo] != ''''StkLibertarReserva'''')&#xA;) And&#xA;([tbSistemaTiposDocumento_Tipo] != ''''StkTrfArmazCTrans'''' or [TipoFiscal] != ''''NF'''')) " PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item2>
        <Item3 Ref="105" ControlType="SubBand" Name="SubBand5" HeightF="65" Visible="false">
          <Controls>
            <Item1 Ref="106" ControlType="XRLine" Name="line1" SizeF="746.6705,2.252249" LocationFloat="1, 60.95" />
            <Item2 Ref="107" ControlType="XRLabel" Name="label10" Multiline="true" Text="label10" TextAlignment="MiddleRight" SizeF="100,13" LocationFloat="650, 40" Font="Times New Roman, 8pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="108" Expression="?Utilizador" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="109" UseFont="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="110" ControlType="XRLabel" Name="label9" Multiline="true" Text="label9" TextAlignment="MiddleRight" SizeF="125,13" LocationFloat="625, 25" Font="Times New Roman, 8pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="111" Expression="LocalDateTimeNow() " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="112" UseFont="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="113" ControlType="XRLabel" Name="label8" Multiline="true" Text="Emitida em" TextAlignment="MiddleRight" SizeF="100,13" LocationFloat="650, 10" Font="Times New Roman, 8pt" Padding="2,2,0,0,100">
              <StylePriority Ref="114" UseFont="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="115" ControlType="XRLabel" Name="label7" Multiline="true" Text="label7" SizeF="350,20" LocationFloat="260, 40" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="116" Expression="[tbClientes_Codigo] + '''' - '''' + [NomeFiscal] " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="117" UseFont="false" />
            </Item5>
            <Item6 Ref="118" ControlType="XRLabel" Name="label6" Text="Cliente" TextAlignment="TopLeft" SizeF="85,15" LocationFloat="260, 25" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="DataDocumento">
              <StylePriority Ref="119" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="120" ControlType="XRLabel" Name="label5" TextFormatString="{0:dd-MM-yyyy}" CanGrow="false" Text="label5" TextAlignment="TopCenter" SizeF="85,20" LocationFloat="170, 40" Font="Arial, 9pt" Padding="2,2,0,0,100" BorderWidth="0">
              <ExpressionBindings>
                <Item1 Ref="121" Expression="[DataDocumento]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="122" UseFont="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="123" ControlType="XRLabel" Name="label4" Text="Data" TextAlignment="TopCenter" SizeF="85,15" LocationFloat="170, 25" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="DataDocumento">
              <StylePriority Ref="124" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item8>
            <Item9 Ref="125" ControlType="XRLabel" Name="label3" Text="label3" TextAlignment="TopRight" SizeF="160,20" LocationFloat="6, 40" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="126" Expression="[tbTiposDocumento_Codigo] + '''' '''' + [CodigoSerie] + ''''/'''' + [NumeroDocumento]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="127" UseFont="false" UseTextAlignment="false" />
            </Item9>
            <Item10 Ref="128" ControlType="XRLabel" Name="lblTipoDocumento1" Text="Fatura" TextAlignment="TopRight" SizeF="160,15" LocationFloat="6, 25" Font="Arial, 8pt, style=Bold" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="129" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item10>
            <Item11 Ref="130" ControlType="XRLabel" Name="label1" Multiline="true" Text="label1" SizeF="450,23" LocationFloat="0, 2" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="131" Expression="[tbParametrosEmpresa.DesignacaoComercial]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
            </Item11>
          </Controls>
          <ExpressionBindings>
            <Item1 Ref="132" Expression="([tbSistemaTiposDocumento_Tipo] = ''''StkEntStk'''')  Or&#xA;([tbSistemaTiposDocumento_Tipo] = ''''StkSaidaStk'''') Or&#xA;([tbSistemaTiposDocumento_Tipo] = ''''StkTrfArmazCTrans'''' and [TipoFiscal] = ''''NF'''')" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item3>
        <Item4 Ref="133" ControlType="SubBand" Name="sbTransfValorizado" HeightF="30" Visible="false">
          <Controls>
            <Item1 Ref="134" ControlType="XRLabel" Name="lblArmazemEnt3" Text="Armazem Ent" TextAlignment="TopLeft" SizeF="74.32074,13" LocationFloat="383.2186, 9.305318" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Armazem">
              <StylePriority Ref="135" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="136" ControlType="XRLabel" Name="lblLocalEnt" Text="Local Ent" TextAlignment="TopLeft" SizeF="62.65833,13" LocationFloat="457.5394, 9.305318" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Local Ent">
              <StylePriority Ref="137" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="138" ControlType="XRLabel" Name="lblLote3" Text="Lote" TextAlignment="TopLeft" SizeF="62.0444,13.00001" LocationFloat="197.0318, 9.305318" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Lote">
              <StylePriority Ref="139" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="140" ControlType="XRLabel" Name="lblUni3" Text="Uni." TextAlignment="TopRight" SizeF="43.25943,13" LocationFloat="556.1655, 9.305318" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="141" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="142" ControlType="XRLabel" Name="lblLocalSaida" Text="Local Saí" TextAlignment="TopLeft" SizeF="51.1795,13" LocationFloat="332.0391, 9.305318" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Local Saí">
              <StylePriority Ref="143" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item5>
            <Item6 Ref="144" ControlType="XRLabel" Name="lblArmazemSai" Text="Armazem Saí" TextAlignment="TopLeft" SizeF="72.6949,13" LocationFloat="259.0762, 9.305318" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Armazem">
              <StylePriority Ref="145" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="146" ControlType="XRLabel" Name="lblIvaLinha1" Text="% Iva" TextAlignment="TopRight" SizeF="47.53552,13" LocationFloat="701.1361, 9.305318" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="147" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="148" ControlType="XRLabel" Name="lblTotalFinal1" Text="Total" TextAlignment="TopRight" SizeF="50.41742,13" LocationFloat="650.7188, 9.305318" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="149" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item8>
            <Item9 Ref="150" ControlType="XRLabel" Name="lblPreco1" Text="Preço" TextAlignment="TopRight" SizeF="49.06677,13" LocationFloat="601.652, 9.305318" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="151" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item9>
            <Item10 Ref="152" ControlType="XRLabel" Name="lblQuantidade3" Text="Qtd." TextAlignment="TopRight" SizeF="35.96771,13" LocationFloat="520.1978, 9.305318" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <Scripts Ref="153" OnEvaluateBinding="lblQuantidade3_EvaluateBinding" />
              <StylePriority Ref="154" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item10>
            <Item11 Ref="155" ControlType="XRLabel" Name="lblDescricao3" Text="Descrição" TextAlignment="TopLeft" SizeF="109.9106,13" LocationFloat="87.1212, 9.305318" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="156" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item11>
            <Item12 Ref="157" ControlType="XRLabel" Name="lblArtigo3" Text="Artigo" TextAlignment="TopLeft" SizeF="85.12001,13" LocationFloat="2.00119, 9.305318" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Artigo">
              <StylePriority Ref="158" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item12>
            <Item13 Ref="159" ControlType="XRLine" Name="XrLine2" SizeF="746.6705,2.252249" LocationFloat="2.00119, 25.24776" />
          </Controls>
        </Item4>
        <Item5 Ref="160" ControlType="SubBand" Name="sbValoriza" HeightF="33.67" Visible="false">
          <Controls>
            <Item1 Ref="161" ControlType="XRLabel" Name="lblLocalizacao" Text="Local " TextAlignment="TopLeft" SizeF="62.65823,13" LocationFloat="457.5394, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Local ">
              <StylePriority Ref="162" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="163" ControlType="XRLine" Name="XrLine1" SizeF="746.6705,2.252249" LocationFloat="2.329763, 31.41446" />
            <Item3 Ref="164" ControlType="XRLabel" Name="lblIvaLinha" Text="% Iva" TextAlignment="TopRight" SizeF="47.21454,13" LocationFloat="701.1369, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="165" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="166" ControlType="XRLabel" Name="lblTotalFinal" Text="Total" TextAlignment="TopRight" SizeF="50.41748,13" LocationFloat="650.7188, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="167" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="168" ControlType="XRLabel" Name="lblPreco" Text="Preço" TextAlignment="TopRight" SizeF="49.06677,13" LocationFloat="601.652, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="169" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item5>
            <Item6 Ref="170" ControlType="XRLabel" Name="lblQuantidade" Text="Qtd." TextAlignment="TopRight" SizeF="35.96765,13" LocationFloat="520.1978, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <Scripts Ref="171" OnEvaluateBinding="lblQuantidade_EvaluateBinding" OnBeforePrint="lblQuantidade_BeforePrint" OnDraw="lblQuantidade_Draw" />
              <StylePriority Ref="172" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="173" ControlType="XRLabel" Name="lblDescricao" Text="Descrição" TextAlignment="TopLeft" SizeF="174.0349,13" LocationFloat="134.6664, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="174" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="175" ControlType="XRLabel" Name="lblArtigo" Text="Artigo" TextAlignment="TopLeft" SizeF="134.6664,13" LocationFloat="0, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Artigo">
              <StylePriority Ref="176" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item8>
            <Item9 Ref="177" ControlType="XRLabel" Name="lblLote" Text="Lote" TextAlignment="TopLeft" SizeF="74.51736,13" LocationFloat="308.7013, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Lote">
              <StylePriority Ref="178" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item9>
            <Item10 Ref="179" ControlType="XRLabel" Name="lblArmazem" Text="Armazem" TextAlignment="TopLeft" SizeF="74.32086,13" LocationFloat="383.2186, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Armazem">
              <StylePriority Ref="180" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item10>
            <Item11 Ref="181" ControlType="XRLabel" Name="lblUni" Text="Uni." TextAlignment="TopRight" SizeF="43.25943,13" LocationFloat="556.1655, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="182" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item11>
          </Controls>
        </Item5>
        <Item6 Ref="183" ControlType="SubBand" Name="sbNaoValoriza" HeightF="30.3" Visible="false">
          <Controls>
            <Item1 Ref="184" ControlType="XRLabel" Name="lblLocalizacao1" Text="Local " TextAlignment="TopLeft" SizeF="77.5675,13" LocationFloat="573.374, 9.999943" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Local ">
              <StylePriority Ref="185" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="186" ControlType="XRLine" Name="XrLine3" SizeF="746.6705,2.252249" LocationFloat="2.001254, 28.04394" />
            <Item3 Ref="187" ControlType="XRLabel" Name="lblUni1" Text="Uni." TextAlignment="TopRight" SizeF="45.84589,13.00453" LocationFloat="703.1369, 9.995429" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="188" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="189" ControlType="XRLabel" Name="lblQuantidade1" Text="Qtd." TextAlignment="TopRight" SizeF="52.19537,13" LocationFloat="650.9415, 9.999943" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <Scripts Ref="190" OnEvaluateBinding="lblQuantidade1_EvaluateBinding" />
              <StylePriority Ref="191" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="192" ControlType="XRLabel" Name="lblDescricao1" Text="Descrição" TextAlignment="TopLeft" SizeF="197.1047,13" LocationFloat="174.8755, 10.00452" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="193" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item5>
            <Item6 Ref="194" ControlType="XRLabel" Name="lblArtigo1" Text="Artigo" TextAlignment="TopLeft" SizeF="174.8755,13" LocationFloat="0, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Artigo">
              <StylePriority Ref="195" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="196" ControlType="XRLabel" Name="lblLote1" Text="Lote" TextAlignment="TopLeft" SizeF="92.41339,13" LocationFloat="371.9802, 10.00452" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Lote">
              <StylePriority Ref="197" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="198" ControlType="XRLabel" Name="lblArmazem1" Text="Armazem" TextAlignment="TopLeft" SizeF="108.9803,13" LocationFloat="464.3937, 10.00452" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Armazem">
              <StylePriority Ref="199" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item8>
          </Controls>
          <ExpressionBindings>
            <Item1 Ref="200" Expression="iif( [tbTiposDocumento_DocNaoValorizado] and ([tbSistemaTiposDocumento_Tipo] = ''''StkEntStk'''' or [tbSistemaTiposDocumento_Tipo] = ''''StkSaidaStk'''' or [tbSistemaTiposDocumento_Tipo] = ''''StkLibertarReserva'''' or [tbSistemaTiposDocumento_Tipo] = ''''StkReserva'''') , true, false)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item6>
        <Item7 Ref="201" ControlType="SubBand" Name="sbTransfNaoValoriza" HeightF="30.63" Visible="false">
          <Controls>
            <Item1 Ref="202" ControlType="XRLabel" Name="lblLote2" Text="Lote" TextAlignment="TopLeft" SizeF="79.8439,13" LocationFloat="292.1363, 10.33335" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Lote">
              <StylePriority Ref="203" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="204" ControlType="XRLabel" Name="lblLocalEnt1" Text="Local Ent" TextAlignment="TopLeft" SizeF="63.93872,13" LocationFloat="586.78, 10.0001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Local">
              <StylePriority Ref="205" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="206" ControlType="XRLabel" Name="lblArmazemEnt2" Text="Arm. Ent" TextAlignment="TopLeft" SizeF="77.14499,13" LocationFloat="509.635, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Armazem">
              <StylePriority Ref="207" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="208" ControlType="XRLine" Name="XrLine7" SizeF="747.0005,2.252262" LocationFloat="1.671219, 28.37276" />
            <Item5 Ref="209" ControlType="XRLabel" Name="lblUni2" Text="Uni." TextAlignment="TopRight" SizeF="44.66364,13" LocationFloat="703.137, 10.33338" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="210" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item5>
            <Item6 Ref="211" ControlType="XRLabel" Name="lblArtigo2" Text="Artigo" TextAlignment="TopLeft" SizeF="132.6656,13" LocationFloat="2.000809, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Artigo">
              <StylePriority Ref="212" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="213" ControlType="XRLabel" Name="lblDescricao2" Text="Descrição" TextAlignment="TopLeft" SizeF="157.4698,13" LocationFloat="134.6664, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="214" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="215" ControlType="XRLabel" Name="lblQuantidade2" Text="Qtd." TextAlignment="TopRight" SizeF="52.1955,13" LocationFloat="650.9416, 9.999974" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <Scripts Ref="216" OnEvaluateBinding="lblQuantidade2_EvaluateBinding" OnBeforePrint="lblQuantidade2_BeforePrint" />
              <StylePriority Ref="217" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item8>
            <Item9 Ref="218" ControlType="XRLabel" Name="lblArmazemSai1" Text="Arm. Saí" TextAlignment="TopLeft" SizeF="77.14505,13" LocationFloat="371.9802, 10.33335" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Armazem">
              <StylePriority Ref="219" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item9>
            <Item10 Ref="220" ControlType="XRLabel" Name="lblLocalSaida1" Text="Local Saí" TextAlignment="TopLeft" SizeF="60.50983,13" LocationFloat="449.1252, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Local Saida">
              <StylePriority Ref="221" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item10>
          </Controls>
          <ExpressionBindings>
            <Item1 Ref="222" Expression="iif( [tbTiposDocumento_DocNaoValorizado] and [tbSistemaTiposDocumento_Tipo] = ''''StkTrfArmazCTrans'''' and not [tbTiposDocumento_AcompanhaBensCirculacao] , true, false)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item7>
        <Item8 Ref="223" ControlType="SubBand" Name="sbTransfValorizaAcompanha" HeightF="30" Visible="false">
          <Controls>
            <Item1 Ref="224" ControlType="XRLine" Name="XrLine10" SizeF="746.6705,2.252249" LocationFloat="2.001254, 25.24776" />
            <Item2 Ref="225" ControlType="XRLabel" Name="lblIsencao1" Text="Ise." TextAlignment="TopRight" SizeF="45.86334,13" LocationFloat="703.1369, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="226" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="227" ControlType="XRLabel" Name="lblArtigo4" Text="Artigo" TextAlignment="TopLeft" SizeF="159.7703,13" LocationFloat="2.000809, 10.00004" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Artigo">
              <StylePriority Ref="228" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="229" ControlType="XRLabel" Name="lblDescricao4" Text="Descrição" TextAlignment="TopLeft" SizeF="193.0349,13" LocationFloat="161.7711, 10.00004" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="230" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="231" ControlType="XRLabel" Name="lblQuantidade4" Text="Qtd." TextAlignment="TopRight" SizeF="49.98245,13" LocationFloat="427.4777, 10.00004" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <Scripts Ref="232" OnEvaluateBinding="lblQuantidade4_EvaluateBinding" />
              <StylePriority Ref="233" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item5>
            <Item6 Ref="234" ControlType="XRLabel" Name="lblPreco2" Text="Preço" TextAlignment="TopRight" SizeF="56.66534,13" LocationFloat="530.1146, 10.00004" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="235" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="236" ControlType="XRLabel" Name="lblTotalFinal2" Text="Total" TextAlignment="TopRight" SizeF="60.50983,13" LocationFloat="586.78, 10.00004" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="237" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="238" ControlType="XRLabel" Name="lblIvaLinha2" Text="% Iva" TextAlignment="TopRight" SizeF="55.84705,13" LocationFloat="647.2897, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="239" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item8>
            <Item9 Ref="240" ControlType="XRLabel" Name="lblUni4" Text="Uni." TextAlignment="TopRight" SizeF="52.65445,13" LocationFloat="477.4602, 10.00004" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="241" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item9>
            <Item10 Ref="242" ControlType="XRLabel" Name="lblLote4" Text="Lote" TextAlignment="TopLeft" SizeF="72.67178,13.00001" LocationFloat="354.8059, 10.00004" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Lote">
              <StylePriority Ref="243" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item10>
          </Controls>
          <ExpressionBindings>
            <Item1 Ref="244" Expression="iif( not [tbTiposDocumento_DocNaoValorizado] and [tbSistemaTiposDocumento_Tipo] = ''''StkTrfArmazCTrans'''' and [tbTiposDocumento_AcompanhaBensCirculacao] , true, false)" PropertyName="Visible" EventName="BeforePrint" />
          </ExpressionBindings>
        </Item8>
        <Item9 Ref="245" ControlType="SubBand" Name="sbTransfNaoValorizaAcompanha" HeightF="32.19" Visible="false">
          <Controls>
            <Item1 Ref="246" ControlType="XRLabel" Name="lblQuantidade5" Text="Qtd." TextAlignment="TopRight" SizeF="73.18494,13" LocationFloat="607.9011, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <Scripts Ref="247" OnEvaluateBinding="lblQuantidade5_EvaluateBinding" />
              <StylePriority Ref="248" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="249" ControlType="XRLabel" Name="lblDescricao5" Text="Descrição" TextAlignment="TopLeft" SizeF="260.4917,13" LocationFloat="203.1386, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="250" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="251" ControlType="XRLabel" Name="lblArtigo5" Text="Artigo" TextAlignment="TopLeft" SizeF="201.7876,13" LocationFloat="1.351039, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Artigo">
              <StylePriority Ref="252" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="253" ControlType="XRLabel" Name="lblUni5" Text="Uni." TextAlignment="TopRight" SizeF="66.30356,13" LocationFloat="682.6966, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Estado">
              <StylePriority Ref="254" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="255" ControlType="XRLine" Name="XrLine11" SizeF="747.0005,2.252262" LocationFloat="1.022466, 29.93523" />
            <Item6 Ref="256" ControlType="XRLabel" Name="lblLote5" Text="Lote" TextAlignment="TopLeft" SizeF="142.0505,13" LocationFloat="465.2977, 10.00001" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Lote">
              <StylePriority Ref="257" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item6>
          </Controls>
        </Item9>
        <Item10 Ref="258" ControlType="SubBand" Name="SubBand9" HeightF="14.50005">
          <Controls>
            <Item1 Ref="259" ControlType="XRLabel" Name="lblTransporte" TextFormatString="{0:0.00}" TextAlignment="MiddleLeft" SizeF="187.58,12" LocationFloat="561.38, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <Scripts Ref="260" OnSummaryGetResult="lblTransporte_SummaryGetResult" OnPrintOnPage="lblTransporte_PrintOnPage" />
              <Summary Ref="261" Running="Page" IgnoreNullValues="true" />
              <StylePriority Ref="262" UseFont="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="263" ControlType="XRLabel" Name="lblTituloTransporte" Text="Transporte" TextAlignment="MiddleRight" SizeF="78.96,12" LocationFloat="479.42, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <Scripts Ref="264" OnPrintOnPage="lblTituloTransporte_PrintOnPage" />
              <StylePriority Ref="265" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
          </Controls>
        </Item10>
      </SubBands>
    </Item3>
    <Item4 Ref="266" ControlType="DetailBand" Name="Detail" KeepTogetherWithDetailReports="true" SnapLinePadding="0,0,0,0,100" HeightF="0" KeepTogether="true" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item5 Ref="267" ControlType="DetailReportBand" Name="DRTransfValorizado" Level="0" FilterString="[ID] = ?IDDocumento" DataMember="tbDocumentosStock" DataSource="#Ref-0" Visible="false">
      <Bands>
        <Item1 Ref="268" ControlType="DetailBand" Name="Detail1" HeightF="21.61" KeepTogether="true">
          <SubBands>
            <Item1 Ref="269" ControlType="SubBand" Name="SubBand6" HeightF="3.125">
              <Controls>
                <Item1 Ref="270" ControlType="XRSubreport" Name="XrSubreport6" ReportSourceUrl="30000" CanShrink="true" SizeF="747.0002,2.083333" LocationFloat="0.8004506, 0">
                  <ParameterBindings>
                    <Item1 Ref="271" ParameterName="IDDocumento" Parameter="#Ref-4" />
                    <Item2 Ref="272" ParameterName="IDLinha" DataMember="tbDocumentosStock.tbDocumentosStockLinhas_ID" />
                    <Item3 Ref="273" ParameterName="CasasDecimais" Parameter="#Ref-18" />
                    <Item4 Ref="274" ParameterName="CasasMoedas" Parameter="#Ref-19" />
                    <Item5 Ref="275" ParameterName="SimboloMoedas" Parameter="#Ref-20" />
                    <Item6 Ref="276" ParameterName="BDEmpresa" Parameter="#Ref-8" />
                  </ParameterBindings>
                </Item1>
              </Controls>
            </Item1>
          </SubBands>
          <MultiColumn Ref="277" Mode="UseColumnCount" />
          <Controls>
            <Item1 Ref="278" ControlType="XRLabel" Name="XrLabel7" Text="XrLabel7" SizeF="74.32074,17.16668" LocationFloat="383.2187, 2.36" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="279" Expression="[tbArmazens_Codigo]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="280" UseFont="false" />
            </Item1>
            <Item2 Ref="281" ControlType="XRLabel" Name="XrLabel8" Text="XrLabel8" SizeF="62.65829,17.16668" LocationFloat="457.5393, 2.36" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="282" Expression="[tbArmazensLocalizacoes_Codigo]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="283" UseFont="false" />
            </Item2>
            <Item3 Ref="284" ControlType="XRLabel" Name="XrLabel59" Text="XrLabel39" SizeF="62.04439,17.16668" LocationFloat="197.0318, 2.36" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="285" Expression="[CodigoLote]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="286" UseFont="false" />
            </Item3>
            <Item4 Ref="287" ControlType="XRLabel" Name="XrLabel53" Text="XrLabel40" TextAlignment="TopRight" SizeF="43.2594,17.16668" LocationFloat="558.3927, 2.36" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="288" Expression="[CodigoUnidade]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="289" UseFont="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="290" ControlType="XRLabel" Name="fldTotalFinal1" TextFormatString="{0:0.00}" TextAlignment="TopRight" SizeF="49.41748,17.16668" LocationFloat="650.7188, 2.36" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <Scripts Ref="291" OnBeforePrint="fldTotalFinal1_BeforePrint" />
              <ExpressionBindings>
                <Item1 Ref="292" Expression="Iif(IsNullOrEmpty( [tbMoedas_CasasDecimaisTotais]   ), 0 , FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisTotais]    + ''''}'''', [PrecoTotal])) " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="293" UseFont="false" UseTextAlignment="false" />
            </Item5>
            <Item6 Ref="294" ControlType="XRLabel" Name="XrLabel2" SizeF="109.9105,17.16668" LocationFloat="87.12129, 2.36" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="295" Expression="[Descricao]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="296" UseFont="false" />
            </Item6>
            <Item7 Ref="297" ControlType="XRLabel" Name="XrLabel9" Text="XrLabel9" SizeF="72.69498,17.16668" LocationFloat="259.0762, 2.36" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="298" Expression="[tbArmazens1_CodigoDestino]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="299" UseFont="false" />
            </Item7>
            <Item8 Ref="300" ControlType="XRLabel" Name="XrLabel10" Text="XrLabel10" SizeF="51.17957,17.16668" LocationFloat="332.0391, 2.36" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="301" Expression="[tbArmazensLocalizacoes1_Descricao]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="302" UseFont="false" />
            </Item8>
            <Item9 Ref="303" ControlType="XRLabel" Name="fldQuantidade1" TextAlignment="TopRight" SizeF="35.96777,17.16668" LocationFloat="520.1978, 2.36" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <Scripts Ref="304" OnBeforePrint="fldQuantidade1_BeforePrint" />
              <ExpressionBindings>
                <Item1 Ref="305" Expression="Iif(IsNullOrEmpty( [NumCasasDecUnidade]    ), 0 , FormatString(''''{0:n'''' +  [NumCasasDecUnidade]     + ''''}'''', [Quantidade])) " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="306" UseFont="false" UseTextAlignment="false" />
            </Item9>
            <Item10 Ref="307" ControlType="XRLabel" Name="fldPreco1" TextFormatString="{0:0.00}" TextAlignment="TopRight" SizeF="49.06677,17.16668" LocationFloat="601.652, 2.36" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <Scripts Ref="308" OnBeforePrint="fldPreco1_BeforePrint" />
              <ExpressionBindings>
                <Item1 Ref="309" Expression="Iif(IsNullOrEmpty( [tbMoedas_CasasDecimaisTotais]   ), 0 , FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisTotais]    + ''''}'''', [PrecoUnitario])) " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="310" UseFont="false" UseTextAlignment="false" />
            </Item10>
            <Item11 Ref="311" ControlType="XRLabel" Name="fldArtigo" Text="fldArtigo" SizeF="87.1212,17.16668" LocationFloat="0, 2.36" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="312" Expression="[tbArtigos_Codigo]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="313" UseFont="false" />
            </Item11>
            <Item12 Ref="314" ControlType="XRLabel" Name="fldTaxaIVA1" TextFormatString="{0:0.00}" TextAlignment="TopRight" SizeF="49.86389,17.16668" LocationFloat="700.1362, 2.36" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <Scripts Ref="315" OnAfterPrint="fldTaxaIVA1_AfterPrint" />
              <ExpressionBindings>
                <Item1 Ref="316" Expression="Iif(IsNullOrEmpty( [tbParamentrosEmpresa_CasasDecimaisPercentagem]   ), 0 , FormatString(''''{0:n'''' + [tbParamentrosEmpresa_CasasDecimaisPercentagem]     + ''''}'''', [TaxaIva])) " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="317" UseFont="false" UseTextAlignment="false" />
            </Item12>
          </Controls>
        </Item1>
      </Bands>
    </Item5>
    <Item6 Ref="318" ControlType="DetailReportBand" Name="DRValorizado" Level="1" FilterString="[ID] = ?IDDocumento" DataMember="tbDocumentosStock" DataSource="#Ref-0" Visible="false">
      <Bands>
        <Item1 Ref="319" ControlType="DetailBand" Name="Detail2" HeightF="17.79" KeepTogether="true">
          <SubBands>
            <Item1 Ref="320" ControlType="SubBand" Name="SubBand2" HeightF="2.083333">
              <Controls>
                <Item1 Ref="321" ControlType="XRSubreport" Name="XrSubreport2" ReportSourceUrl="30000" CanShrink="true" SizeF="747.0002,2.083333" LocationFloat="0, 0">
                  <ParameterBindings>
                    <Item1 Ref="322" ParameterName="IDDocumento" Parameter="#Ref-4" />
                    <Item2 Ref="323" ParameterName="IDLinha" DataMember="tbDocumentosStock.tbDocumentosStockLinhas_ID" />
                    <Item3 Ref="324" ParameterName="CasasDecimais" Parameter="#Ref-18" />
                    <Item4 Ref="325" ParameterName="CasasMoedas" Parameter="#Ref-19" />
                    <Item5 Ref="326" ParameterName="SimboloMoedas" Parameter="#Ref-20" />
                    <Item6 Ref="327" ParameterName="BDEmpresa" Parameter="#Ref-8" />
                  </ParameterBindings>
                </Item1>
              </Controls>
            </Item1>
          </SubBands>
          <Controls>
            <Item1 Ref="328" ControlType="XRLabel" Name="fldLocalizacaoValoriza" Text="Local" SizeF="62.65823,12.99998" LocationFloat="457.5394, 2.7" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="329" Expression="iif ([tbSistemaTiposDocumento_Tipo] != ''''StkEntStk'''', [tbArmazensLocalizacoes_Codigo] , [tbArmazensLocalizacoes1_Codigo])" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="330" UseFont="false" />
            </Item1>
            <Item2 Ref="331" ControlType="XRLabel" Name="fldArmazemValoriza" Text="Armazem" SizeF="74.32086,12.99998" LocationFloat="383.2186, 2.7" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="332" Expression="iif ([tbSistemaTiposDocumento_Tipo] != ''''StkEntStk'''', [tbArmazens_Codigo], [tbArmazens1_CodigoDestino])" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="333" UseFont="false" />
            </Item2>
            <Item3 Ref="334" ControlType="XRLabel" Name="XrLabel40" Text="XrLabel40" TextAlignment="TopRight" SizeF="43.2594,12.99998" LocationFloat="556.1656, 2.7" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="335" Expression="[CodigoUnidade]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="336" UseFont="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="337" ControlType="XRLabel" Name="XrLabel39" Text="XrLabel39" SizeF="74.51736,12.99998" LocationFloat="308.7013, 2.7" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="338" Expression="[CodigoLote]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="339" UseFont="false" />
            </Item4>
            <Item5 Ref="340" ControlType="XRLabel" Name="fldTaxaIVA" TextFormatString="{0:0.00}" TextAlignment="TopRight" SizeF="49.8631,12.99998" LocationFloat="700.137, 2.7" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <Scripts Ref="341" OnAfterPrint="fldTaxaIVA_AfterPrint" />
              <ExpressionBindings>
                <Item1 Ref="342" Expression="Iif(IsNullOrEmpty( [tbParamentrosEmpresa_CasasDecimaisPercentagem]   ), 0 , FormatString(''''{0:n'''' + [tbParamentrosEmpresa_CasasDecimaisPercentagem]     + ''''}'''', [TaxaIva])) " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="343" UseFont="false" UseTextAlignment="false" />
            </Item5>
            <Item6 Ref="344" ControlType="XRLabel" Name="fldPreco" TextFormatString="{0:0.00}" TextAlignment="TopRight" SizeF="49.06677,12.99998" LocationFloat="601.652, 2.7" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <Scripts Ref="345" OnBeforePrint="fldPreco_BeforePrint" />
              <ExpressionBindings>
                <Item1 Ref="346" Expression="Iif(IsNullOrEmpty( [tbMoedas_CasasDecimaisTotais]   ), 0 , FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisTotais]    + ''''}'''', [PrecoUnitario])) " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="347" UseFont="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="348" ControlType="XRLabel" Name="fldTotalFinal" TextFormatString="{0:0.00}" TextAlignment="TopRight" SizeF="49.41748,12.99998" LocationFloat="650.7188, 2.7" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <Scripts Ref="349" OnBeforePrint="fldTotalFinal_BeforePrint" />
              <ExpressionBindings>
                <Item1 Ref="350" Expression="Iif(IsNullOrEmpty( [tbMoedas_CasasDecimaisTotais]   ), 0 , FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisTotais]    + ''''}'''', [PrecoTotal])) &#xA;" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="351" UseFont="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="352" ControlType="XRLabel" Name="fldQuantidade" TextAlignment="TopRight" SizeF="35.96777,12.99998" LocationFloat="520.1978, 2.7" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="353" Expression="Iif(IsNullOrEmpty( [NumCasasDecUnidade]    ), 0 , FormatString(''''{0:n'''' +  [NumCasasDecUnidade]     + ''''}'''', [Quantidade])) " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="354" UseFont="false" UseTextAlignment="false" />
            </Item8>
            <Item9 Ref="355" ControlType="XRLabel" Name="fldDescricao" SizeF="174.0349,12.99998" LocationFloat="134.6664, 2.7" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="356" Expression="[Descricao]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="357" UseFont="false" />
            </Item9>
            <Item10 Ref="358" ControlType="XRLabel" Name="fldArtigo1" Text="XrLabel1" SizeF="133.6451,12.99998" LocationFloat="1.02129, 2.7" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="359" Expression="[tbArtigos_Codigo]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="360" UseFont="false" />
            </Item10>
          </Controls>
        </Item1>
      </Bands>
    </Item6>
    <Item7 Ref="361" ControlType="DetailReportBand" Name="DRNaoValorizado" Level="2" FilterString="[ID] = ?IDDocumento" DataMember="tbDocumentosStock" DataSource="#Ref-0" Visible="false">
      <Bands>
        <Item1 Ref="362" ControlType="DetailBand" Name="Detail3" HeightF="19.24" KeepTogether="true">
          <SubBands>
            <Item1 Ref="363" ControlType="SubBand" Name="SubBand4" HeightF="2.083333">
              <Controls>
                <Item1 Ref="364" ControlType="XRSubreport" Name="XrSubreport4" ReportSourceUrl="40000" CanShrink="true" SizeF="747.0002,2.083333" LocationFloat="1.351293, 0">
                  <ParameterBindings>
                    <Item1 Ref="365" ParameterName="IDDocumento" Parameter="#Ref-4" />
                    <Item2 Ref="366" ParameterName="IDLinha" DataMember="tbDocumentosStock.tbDocumentosStockLinhas_ID" />
                    <Item3 Ref="367" ParameterName="CasasDecimais" Parameter="#Ref-18" />
                    <Item4 Ref="368" ParameterName="CasasMoedas" Parameter="#Ref-19" />
                    <Item5 Ref="369" ParameterName="SimboloMoedas" Parameter="#Ref-20" />
                    <Item6 Ref="370" ParameterName="BDEmpresa" Parameter="#Ref-8" />
                  </ParameterBindings>
                </Item1>
              </Controls>
            </Item1>
          </SubBands>
          <Controls>
            <Item1 Ref="371" ControlType="XRLabel" Name="fldLocalizacao1Valoriza" Text="XrLabel8" SizeF="77.34473,14.04165" LocationFloat="573.374, 3.12" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="372" Expression="iif ([tbSistemaTiposDocumento_Tipo] != ''''StkEntStk'''', [tbArmazensLocalizacoes_Codigo] , [tbArmazensLocalizacoes1_Codigo])" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="373" UseFont="false" />
            </Item1>
            <Item2 Ref="374" ControlType="XRLabel" Name="fldArtigo2" Text="XrLabel1" SizeF="174.8755,14.04165" LocationFloat="0, 3.12" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="375" Expression="[tbArtigos_Codigo]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="376" UseFont="false" />
            </Item2>
            <Item3 Ref="377" ControlType="XRLabel" Name="XrLabel5" SizeF="197.1047,14.04165" LocationFloat="174.8755, 3.12" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="378" Expression="[Descricao]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="379" UseFont="false" />
            </Item3>
            <Item4 Ref="380" ControlType="XRLabel" Name="fldQuantidade2" Text="XrLabel3" TextAlignment="TopRight" SizeF="52.41803,14.04165" LocationFloat="650.7188, 3.12" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="381" Expression="Iif(IsNullOrEmpty( [NumCasasDecUnidade]    ), 0 , FormatString(''''{0:n'''' +  [NumCasasDecUnidade]     + ''''}'''', [Quantidade])) " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="382" UseFont="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="383" ControlType="XRLabel" Name="XrLabel12" Text="XrLabel39" SizeF="92.41357,14.04165" LocationFloat="371.9803, 3.12" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="384" Expression="[CodigoLote]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="385" UseFont="false" />
            </Item5>
            <Item6 Ref="386" ControlType="XRLabel" Name="fldUnidade" Text="XrLabel40" TextAlignment="TopRight" SizeF="45.86334,14.04165" LocationFloat="704.1367, 3.12" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <Scripts Ref="387" OnAfterPrint="fldUnidade_AfterPrint" />
              <ExpressionBindings>
                <Item1 Ref="388" Expression="[CodigoUnidade]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="389" UseFont="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="390" ControlType="XRLabel" Name="fldArmazem1Valoriza" Text="XrLabel33" SizeF="108.9803,14.04165" LocationFloat="464.3937, 3.12" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="391" Expression="iif ([tbSistemaTiposDocumento_Tipo] != ''''StkEntStk'''', [tbArmazens_Codigo], [tbArmazens1_CodigoDestino])" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="392" UseFont="false" />
            </Item7>
          </Controls>
        </Item1>
      </Bands>
      <ExpressionBindings>
        <Item1 Ref="393" Expression="iif( [tbTiposDocumento_DocNaoValorizado] and ([tbSistemaTiposDocumento_Tipo] = ''''StkEntStk'''' or [tbSistemaTiposDocumento_Tipo] = ''''StkSaidaStk'''' or [tbSistemaTiposDocumento_Tipo] = ''''StkLibertarReserva'''' or [tbSistemaTiposDocumento_Tipo] = ''''StkReserva'''') , true, false)" PropertyName="Visible" EventName="BeforePrint" />
      </ExpressionBindings>
    </Item7>
    <Item8 Ref="394" ControlType="DetailReportBand" Name="DRTransfNaoValorizado" Level="3" FilterString="[ID] = ?IDDocumento" DataMember="tbDocumentosStock" DataSource="#Ref-0" Visible="false">
      <Bands>
        <Item1 Ref="395" ControlType="DetailBand" Name="Detail4" HeightF="23.68" KeepTogether="true">
          <SubBands>
            <Item1 Ref="396" ControlType="SubBand" Name="SubBand7" HeightF="3.125">
              <Controls>
                <Item1 Ref="397" ControlType="XRSubreport" Name="XrSubreport7" ReportSourceUrl="40000" CanShrink="true" SizeF="747.0002,2.083333" LocationFloat="0, 0">
                  <ParameterBindings>
                    <Item1 Ref="398" ParameterName="IDDocumento" Parameter="#Ref-4" />
                    <Item2 Ref="399" ParameterName="IDLinha" DataMember="tbDocumentosStock.tbDocumentosStockLinhas_ID" />
                    <Item3 Ref="400" ParameterName="CasasDecimais" Parameter="#Ref-18" />
                    <Item4 Ref="401" ParameterName="CasasMoedas" Parameter="#Ref-19" />
                    <Item5 Ref="402" ParameterName="SimboloMoedas" Parameter="#Ref-20" />
                    <Item6 Ref="403" ParameterName="BDEmpresa" Parameter="#Ref-8" />
                  </ParameterBindings>
                </Item1>
              </Controls>
            </Item1>
          </SubBands>
          <Controls>
            <Item1 Ref="404" ControlType="XRLabel" Name="XrLabel61" Text="XrLabel39" SizeF="79.8439,19.24998" LocationFloat="292.1363, 2.35" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="405" Expression="[CodigoLote]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="406" UseFont="false" />
            </Item1>
            <Item2 Ref="407" ControlType="XRLabel" Name="XrLabel50" Text="XrLabel7" SizeF="77.1449,19.24998" LocationFloat="509.6351, 2.35" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="408" Expression="[tbArmazens_Codigo]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="409" UseFont="false" />
            </Item2>
            <Item3 Ref="410" ControlType="XRLabel" Name="XrLabel49" Text="XrLabel8" SizeF="63.93872,19.24998" LocationFloat="586.78, 2.35" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="411" Expression="[tbArmazensLocalizacoes_Codigo]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="412" UseFont="false" />
            </Item3>
            <Item4 Ref="413" ControlType="XRLabel" Name="XrLabel55" Text="XrLabel40" TextAlignment="TopRight" SizeF="45.86346,19.24998" LocationFloat="704.1368, 2.35" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <Scripts Ref="414" OnAfterPrint="XrLabel55_AfterPrint" />
              <ExpressionBindings>
                <Item1 Ref="415" Expression="[CodigoUnidade]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="416" UseFont="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="417" ControlType="XRLabel" Name="fldArtigo3" Text="XrLabel1" SizeF="134.6664,19.24998" LocationFloat="0, 2.35" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="418" Expression="[tbArtigos_Codigo]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="419" UseFont="false" />
            </Item5>
            <Item6 Ref="420" ControlType="XRLabel" Name="fldQuantidade3" TextAlignment="TopRight" SizeF="52.1955,19.24998" LocationFloat="650.9416, 2.35" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <Scripts Ref="421" OnBeforePrint="fldQuantidade3_BeforePrint" />
              <ExpressionBindings>
                <Item1 Ref="422" Expression="Iif(IsNullOrEmpty( [NumCasasDecUnidade]    ), 0 , FormatString(''''{0:n'''' +  [NumCasasDecUnidade]     + ''''}'''', [Quantidade])) " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="423" UseFont="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="424" ControlType="XRLabel" Name="XrLabel47" Text="XrLabel10" SizeF="60.50983,19.24998" LocationFloat="449.1251, 2.35" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="425" Expression="[tbArmazensLocalizacoes1_Codigo]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="426" UseFont="false" />
            </Item7>
            <Item8 Ref="427" ControlType="XRLabel" Name="XrLabel48" Text="XrLabel9" SizeF="77.14499,19.24998" LocationFloat="371.9803, 2.35" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="428" Expression="[tbArmazens1_CodigoDestino]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="429" UseFont="false" />
            </Item8>
            <Item9 Ref="430" ControlType="XRLabel" Name="XrLabel51" SizeF="157.4699,19.24998" LocationFloat="134.6664, 2.35" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="431" Expression="[Descricao]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="432" UseFont="false" />
            </Item9>
          </Controls>
        </Item1>
      </Bands>
      <ExpressionBindings>
        <Item1 Ref="433" Expression="iif( [tbTiposDocumento_DocNaoValorizado] and [tbSistemaTiposDocumento_Tipo] = ''''StkTrfArmazCTrans'''' and not [tbTiposDocumento_AcompanhaBensCirculacao] , true, false)" PropertyName="Visible" EventName="BeforePrint" />
      </ExpressionBindings>
    </Item8>
    <Item9 Ref="434" ControlType="DetailReportBand" Name="DRTransfValorizaAcompanha" Level="4" FilterString="[ID] = ?IDDocumento" DataMember="tbDocumentosStock" DataSource="#Ref-0" Visible="false">
      <Bands>
        <Item1 Ref="435" ControlType="DetailBand" Name="Detail5" HeightF="20.12" KeepTogether="true">
          <SubBands>
            <Item1 Ref="436" ControlType="SubBand" Name="SubBand8" HeightF="3.125">
              <Controls>
                <Item1 Ref="437" ControlType="XRSubreport" Name="XrSubreport8" ReportSourceUrl="60000" CanShrink="true" SizeF="747.0002,2.083333" LocationFloat="1.351357, 0">
                  <ParameterBindings>
                    <Item1 Ref="438" ParameterName="IDDocumento" Parameter="#Ref-4" />
                    <Item2 Ref="439" ParameterName="IDLinha" DataMember="tbDocumentosStock.tbDocumentosStockLinhas_ID" />
                    <Item3 Ref="440" ParameterName="CasasDecimais" Parameter="#Ref-18" />
                    <Item4 Ref="441" ParameterName="CasasMoedas" Parameter="#Ref-19" />
                    <Item5 Ref="442" ParameterName="SimboloMoedas" Parameter="#Ref-20" />
                    <Item6 Ref="443" ParameterName="BDEmpresa" Parameter="#Ref-8" />
                  </ParameterBindings>
                </Item1>
              </Controls>
            </Item1>
          </SubBands>
          <Controls>
            <Item1 Ref="444" ControlType="XRLabel" Name="fldRunningSum" TextFormatString="{0:0.00}" CanGrow="false" CanShrink="true" SizeF="2,2" LocationFloat="2.32, 2.58" ForeColor="Black" Padding="0,0,0,0,100">
              <Scripts Ref="445" OnSummaryCalculated="fldRunningSum_SummaryCalculated" />
              <Summary Ref="446" Running="Page" IgnoreNullValues="true" />
              <ExpressionBindings>
                <Item1 Ref="447" Expression="sumRunningSum([PrecoTotal])" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="448" UseForeColor="false" UsePadding="false" />
            </Item1>
            <Item2 Ref="449" ControlType="XRLabel" Name="fldCodigoMotivoIsencaoIva" Text="fldCodigoMotivoIsencaoIva" TextAlignment="TopRight" SizeF="45.86346,15.00003" LocationFloat="704.1368, 2.04" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <Scripts Ref="450" OnAfterPrint="fldCodigoMotivoIsencaoIva_AfterPrint" OnBeforePrint="fldCodigoMotivoIsencaoIva_BeforePrint" />
              <ExpressionBindings>
                <Item1 Ref="451" Expression="[tbSistemaCodigosIVA.Codigo] " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="452" UseFont="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="453" ControlType="XRLabel" Name="fldTaxaIVA2" TextFormatString="{0:0.00}" TextAlignment="TopRight" SizeF="55.84692,15.00003" LocationFloat="647.2899, 2.04" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="454" Expression="Iif(IsNullOrEmpty( [tbParamentrosEmpresa_CasasDecimaisPercentagem]   ), 0 , FormatString(''''{0:n'''' + [tbParamentrosEmpresa_CasasDecimaisPercentagem]     + ''''}'''', [TaxaIva])) " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="455" UseFont="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="456" ControlType="XRLabel" Name="fldArtigo4" Text="XrLabel1" SizeF="160.42,15.00003" LocationFloat="1.351039, 3.04" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="457" Expression="[tbArtigos_Codigo]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="458" UseFont="false" />
            </Item4>
            <Item5 Ref="459" ControlType="XRLabel" Name="fldPreco2" TextFormatString="{0:0.00}" TextAlignment="TopRight" SizeF="56.66541,13.00004" LocationFloat="530.1146, 3.04" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <Scripts Ref="460" OnBeforePrint="fldPreco2_BeforePrint" />
              <ExpressionBindings>
                <Item1 Ref="461" Expression="Iif(IsNullOrEmpty( [tbMoedas_CasasDecimaisTotais]   ), 0 , FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisTotais]    + ''''}'''', [PrecoUnitario])) " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="462" UseFont="false" UseTextAlignment="false" />
            </Item5>
            <Item6 Ref="463" ControlType="XRLabel" Name="XrLabel32" TextAlignment="TopRight" SizeF="52.6543,13.00004" LocationFloat="477.4603, 3.04" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="464" Expression="[CodigoUnidade]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="465" UseFont="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="466" ControlType="XRLabel" Name="XrLabel35" SizeF="193.0349,15.00003" LocationFloat="161.7711, 3.04" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="467" Expression="[Descricao]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="468" UseFont="false" />
            </Item7>
            <Item8 Ref="469" ControlType="XRLabel" Name="fldTotalFinal2" TextFormatString="{0:0.00}" TextAlignment="TopRight" SizeF="60.50983,15.00003" LocationFloat="586.78, 2.04" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <Scripts Ref="470" OnBeforePrint="fldTotalFinal2_BeforePrint" />
              <ExpressionBindings>
                <Item1 Ref="471" Expression="Iif(IsNullOrEmpty( [tbMoedas_CasasDecimaisTotais]   ), 0 , FormatString(''''{0:n'''' + [tbMoedas_CasasDecimaisTotais]    + ''''}'''', [PrecoTotal])) " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="472" UseFont="false" UseTextAlignment="false" />
            </Item8>
            <Item9 Ref="473" ControlType="XRLabel" Name="fldQuantidade4" Text="XrLabel40" TextAlignment="TopRight" SizeF="49.98245,15.00003" LocationFloat="427.4778, 3.04" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <Scripts Ref="474" OnBeforePrint="fldQuantidade4_BeforePrint" />
              <ExpressionBindings>
                <Item1 Ref="475" Expression="Iif(IsNullOrEmpty( [NumCasasDecUnidade]    ), 0 , FormatString(''''{0:n'''' +  [NumCasasDecUnidade]     + ''''}'''', [Quantidade])) " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="476" UseFont="false" UseTextAlignment="false" />
            </Item9>
            <Item10 Ref="477" ControlType="XRLabel" Name="XrLabel38" Text="XrLabel39" SizeF="72.67172,15.00003" LocationFloat="354.8058, 3.04" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="478" Expression="[CodigoLote]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="479" UseFont="false" />
            </Item10>
          </Controls>
        </Item1>
      </Bands>
    </Item9>
    <Item10 Ref="480" ControlType="DetailReportBand" Name="DRTransfNaoValorizaAcompanha" Level="5" FilterString="[ID] = ?IDDocumento" DataMember="tbDocumentosStock" DataSource="#Ref-0" Visible="false">
      <Bands>
        <Item1 Ref="481" ControlType="DetailBand" Name="Detail6" HeightF="20.89" KeepTogether="true">
          <SubBands>
            <Item1 Ref="482" ControlType="SubBand" Name="SubBand10" HeightF="3.125">
              <Controls>
                <Item1 Ref="483" ControlType="XRSubreport" Name="XrSubreport9" ReportSourceUrl="50000" CanShrink="true" SizeF="747.0002,2.083333" LocationFloat="0.8004506, 0">
                  <ParameterBindings>
                    <Item1 Ref="484" ParameterName="IDDocumento" Parameter="#Ref-4" />
                    <Item2 Ref="485" ParameterName="IDLinha" DataMember="tbDocumentosStock.tbDocumentosStockLinhas_ID" />
                    <Item3 Ref="486" ParameterName="CasasDecimais" Parameter="#Ref-18" />
                    <Item4 Ref="487" ParameterName="CasasMoedas" Parameter="#Ref-19" />
                    <Item5 Ref="488" ParameterName="SimboloMoedas" Parameter="#Ref-20" />
                    <Item6 Ref="489" ParameterName="BDEmpresa" Parameter="#Ref-8" />
                  </ParameterBindings>
                </Item1>
              </Controls>
            </Item1>
          </SubBands>
          <Controls>
            <Item1 Ref="490" ControlType="XRLabel" Name="XrLabel33" SizeF="258.8868,16.04166" LocationFloat="204.7212, 2.78" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="491" Expression="[Descricao]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="492" UseFont="false" />
            </Item1>
            <Item2 Ref="493" ControlType="XRLabel" Name="fldQuantidade5" TextAlignment="TopRight" SizeF="73.18494,16.04166" LocationFloat="607.9011, 2.78" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <Scripts Ref="494" OnBeforePrint="fldQuantidade5_BeforePrint" />
              <ExpressionBindings>
                <Item1 Ref="495" Expression="Iif(IsNullOrEmpty( [NumCasasDecUnidade]    ), 0 , FormatString(''''{0:n'''' +  [NumCasasDecUnidade]     + ''''}'''', [Quantidade])) " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="496" UseFont="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="497" ControlType="XRLabel" Name="fldArtigo5" Text="XrLabel1" SizeF="202.0943,16.04166" LocationFloat="1.022021, 2.78" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="498" Expression="[tbArtigos_Codigo]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="499" UseFont="false" />
            </Item3>
            <Item4 Ref="500" ControlType="XRLabel" Name="XrLabel52" Text="XrLabel40" TextAlignment="TopRight" SizeF="66.30359,16.04166" LocationFloat="682.6967, 2.78" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <Scripts Ref="501" OnAfterPrint="XrLabel52_AfterPrint" />
              <ExpressionBindings>
                <Item1 Ref="502" Expression="[CodigoUnidade]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="503" UseFont="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="504" ControlType="XRLabel" Name="XrLabel57" Text="XrLabel39" SizeF="142.0504,16.04166" LocationFloat="465.2977, 2.78" Font="Arial, 6.75pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="505" Expression="[CodigoLote]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="506" UseFont="false" />
            </Item5>
          </Controls>
        </Item1>
      </Bands>
      <ExpressionBindings>
        <Item1 Ref="507" Expression="iif( [tbTiposDocumento_DocNaoValorizado] and [tbSistemaTiposDocumento_Tipo] = ''''StkTrfArmazCTrans'''' and [tbTiposDocumento_AcompanhaBensCirculacao] , true, false)" PropertyName="Visible" EventName="BeforePrint" />
      </ExpressionBindings>
    </Item10>
    <Item11 Ref="508" ControlType="ReportFooterBand" Name="ReportFooter" PrintAtBottom="true" HeightF="2.09" KeepTogether="true">
      <SubBands>
        <Item1 Ref="509" ControlType="SubBand" Name="SubBand13" HeightF="140.19" KeepTogether="true">
          <Controls>
            <Item1 Ref="510" ControlType="XRLabel" Name="lblCopia1" TextAlignment="MiddleRight" SizeF="437.7181,13" LocationFloat="307.34, 0" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="511" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="512" ControlType="XRLabel" Name="fldMensagemDocAT1" TextAlignment="MiddleRight" SizeF="437.7181,13" LocationFloat="307.34, 12.5" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="513" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="514" ControlType="XRLabel" Name="fldAssinatura" TextAlignment="MiddleLeft" SizeF="606.5347,13" LocationFloat="0, 12.5" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="515" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="516" ControlType="XRLine" Name="XrLine5" SizeF="747.0004,2" LocationFloat="0, 26.54" />
            <Item5 Ref="517" ControlType="XRLabel" Name="lblTotalIva" TextAlignment="TopRight" SizeF="88.75003,16" LocationFloat="367.42, 32.96" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Visible="false">
              <StylePriority Ref="518" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item5>
            <Item6 Ref="519" ControlType="XRLabel" Name="fldTotalIva" TextFormatString="{0:€0.00}" TextAlignment="TopRight" SizeF="88.75003,20.9583" LocationFloat="367.42, 48.96" Font="Arial, 6.75pt" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Visible="false">
              <ExpressionBindings>
                <Item1 Ref="520" Expression="Iif(IsNullOrEmpty( [tbMoedas_CasasDecimaisTotais]   ), 0 , FormatString(''''{0:n'''' +  [tbMoedas_CasasDecimaisTotais]    + ''''}'''', [ValorImposto])) &#xA;" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="521" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item6>
            <Item7 Ref="522" ControlType="XRLabel" Name="lblTotalMoedaDocumento" TextAlignment="TopRight" SizeF="121.383,17" LocationFloat="617.56, 31.96" Font="Arial, 8.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="523" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item7>
            <Item8 Ref="524" ControlType="XRLabel" Name="fldSubTotal" TextFormatString="{0:€0.00}" TextAlignment="TopRight" SizeF="88.75003,20.9583" LocationFloat="459.32, 48.96" Font="Arial, 6.75pt" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <ExpressionBindings>
                <Item1 Ref="525" Expression="Iif(IsNullOrEmpty( [tbMoedas_CasasDecimaisTotais]   ), 0 , FormatString(''''{0:n'''' +  [tbMoedas_CasasDecimaisTotais]    + ''''}'''', [SubTotal])) " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="526" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item8>
            <Item9 Ref="527" ControlType="XRLabel" Name="lblSubTotal" TextAlignment="TopRight" SizeF="88.75003,16" LocationFloat="459.32, 32.96" Font="Arial, 8.25pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="528" UseFont="false" UseBackColor="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item9>
            <Item10 Ref="529" ControlType="XRLabel" Name="fldTotalMoedaDocumento" TextAlignment="TopRight" SizeF="176.209,25.59814" LocationFloat="562.75, 48.93" Font="Arial, 14.25pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <ExpressionBindings>
                <Item1 Ref="530" Expression="Iif(IsNullOrEmpty( [tbMoedas_CasasDecimaisTotais]   ), 0 , FormatString(''''{0:n'''' +  [tbMoedas_CasasDecimaisTotais]    + ''''}'''', [TotalMoedaDocumento])) &#xA;" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="531" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item10>
            <Item11 Ref="532" ControlType="XRLabel" Name="XrLabel4" SizeF="190,46" LocationFloat="555.06, 28.54" BackColor="Gainsboro" Padding="2,2,0,0,100" Borders="None" BorderWidth="1">
              <StylePriority Ref="533" UseBackColor="false" UseBorders="false" UseBorderWidth="false" />
            </Item11>
            <Item12 Ref="534" ControlType="XRLine" Name="XrLine4" SizeF="747.0004,2.041214" LocationFloat="0, 75" />
            <Item13 Ref="535" ControlType="XRSubreport" Name="XrSubreport3" ReportSourceUrl="20000" SizeF="433.1161,60.00002" LocationFloat="0, 78.11">
              <ParameterBindings>
                <Item1 Ref="536" ParameterName="IDDocumento" Parameter="#Ref-4" />
                <Item2 Ref="537" ParameterName="Culture" Parameter="#Ref-6" />
                <Item3 Ref="538" ParameterName="BDEmpresa" Parameter="#Ref-8" />
              </ParameterBindings>
            </Item13>
          </Controls>
        </Item1>
        <Item2 Ref="539" ControlType="SubBand" Name="SubBand14" HeightF="27.58" KeepTogether="true">
          <Controls>
            <Item1 Ref="540" ControlType="XRLabel" Name="lblCopia2" TextAlignment="MiddleRight" SizeF="437.7181,13" LocationFloat="306.36, 0" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="541" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="542" ControlType="XRLabel" Name="fldassinaturanaoval" TextAlignment="MiddleLeft" SizeF="606.5347,13" LocationFloat="0, 12.5" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="543" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="544" ControlType="XRLabel" Name="fldMensagemDocAT" TextAlignment="MiddleRight" SizeF="437.7181,13" LocationFloat="306.37, 12.5" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
              <StylePriority Ref="545" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item3>
          </Controls>
        </Item2>
        <Item3 Ref="546" ControlType="SubBand" Name="SubBand15" HeightF="53.2" KeepTogether="true">
          <Controls>
            <Item1 Ref="547" ControlType="XRLine" Name="XrLine9" SizeF="746.67,2" LocationFloat="0, 0" />
            <Item2 Ref="548" ControlType="XRLabel" Name="lblCarga" Text="Carga" TextAlignment="TopLeft" SizeF="200,12" LocationFloat="0, 2.07" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Carga">
              <StylePriority Ref="549" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="550" ControlType="XRLabel" Name="lblDescarga" Text="Descarga" TextAlignment="TopLeft" SizeF="200,12" LocationFloat="203.75, 2.07" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Descarga">
              <StylePriority Ref="551" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item3>
            <Item4 Ref="552" ControlType="XRLabel" Name="lblExpedicao" Text="Matrícula" TextAlignment="TopLeft" SizeF="121.83,12" LocationFloat="406.04, 2.07" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Espedicao">
              <StylePriority Ref="553" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item4>
            <Item5 Ref="554" ControlType="XRLabel" Name="XrLabel30" Text="XrLabel12" SizeF="121.83,12" LocationFloat="406.04, 14.07" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="555" Expression="[Matricula]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="556" UseFont="false" />
            </Item5>
            <Item6 Ref="557" ControlType="XRLabel" Name="XrLabel41" Text="XrLabel11" SizeF="200,12" LocationFloat="203.75, 14.07" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="558" Expression="[MoradaDescarga]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="559" UseFont="false" />
            </Item6>
            <Item7 Ref="560" ControlType="XRLabel" Name="XrLabel42" Text="XrLabel5" SizeF="200,12" LocationFloat="0, 14.07" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="561" Expression="[MoradaCarga]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="562" UseFont="false" />
            </Item7>
            <Item8 Ref="563" ControlType="XRLabel" Name="fldCodigoPostalCarga" Text="fldCodigoPostalCarga" SizeF="200,12" LocationFloat="0, 26.07" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="564" Expression="[tbCodigosPostaisCarga_Codigo] + '''' '''' + [tbCodigosPostaisCarga_Descricao]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="565" UseFont="false" />
            </Item8>
            <Item9 Ref="566" ControlType="XRLabel" Name="fldCodigoPostalDescarga" Text="fldCodigoPostalDescarga" SizeF="200,12" LocationFloat="203.76, 26.07" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="567" Expression="[tbCodigosPostaisDescarga_Codigo] + '''' '''' + [tbCodigosPostaisDescarga_Descricao]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="568" UseFont="false" />
            </Item9>
            <Item10 Ref="569" ControlType="XRLabel" Name="fldDataCarga" TextFormatString="{0:dd-MM-yyyy HH:mm}" SizeF="200,12" LocationFloat="0, 39.11" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="570" Expression="[DataCarga]" PropertyName="Text" EventName="BeforePrint" />
                <Item2 Ref="571" Expression="not IsNullOrEmpty([tbCodigosPostaisCarga_Codigo])" PropertyName="Visible" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="572" UseFont="false" />
            </Item10>
            <Item11 Ref="573" ControlType="XRLabel" Name="fldDataDescarga" TextFormatString="{0:dd-MM-yyyy HH:mm}" SizeF="200,12" LocationFloat="203.75, 39.11" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="574" Expression="[DataDescarga]" PropertyName="Text" EventName="BeforePrint" />
                <Item2 Ref="575" Expression="not IsNullOrEmpty([tbCodigosPostaisDescarga_Codigo])" PropertyName="Visible" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="576" UseFont="false" />
            </Item11>
          </Controls>
        </Item3>
        <Item4 Ref="577" ControlType="SubBand" Name="SubBand16" HeightF="43.74" KeepTogether="true">
          <Controls>
            <Item1 Ref="578" ControlType="XRLine" Name="XrLine8" SizeF="747.0001,3.000001" LocationFloat="0, 0" />
            <Item2 Ref="579" ControlType="XRLabel" Name="lblObservacoes" Text="Observações" TextAlignment="MiddleLeft" SizeF="90.12,12" LocationFloat="0, 3.1" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Observacoes">
              <StylePriority Ref="580" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item2>
            <Item3 Ref="581" ControlType="XRLabel" Name="fldObservacoes" Multiline="true" TextAlignment="TopLeft" SizeF="742.9999,27.03" LocationFloat="0, 14.62" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0" Tag_type="System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" Tag="Observacoes">
              <ExpressionBindings>
                <Item1 Ref="582" Expression="[Observacoes] " PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="583" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
            </Item3>
          </Controls>
        </Item4>
      </SubBands>
      <ExpressionBindings>
        <Item1 Ref="584" Expression="iif( [tbTiposDocumento_DocNaoValorizado] and [tbSistemaTiposDocumento_Tipo] = ''''StkTrfArmazCTrans'''' , false, true) or iif([tbTiposDocumento_DocNaoValorizado] and ([tbSistemaTiposDocumento_Tipo] = ''''StkEntStk'''' or [tbSistemaTiposDocumento_Tipo] = ''''StkSaidaStk'''') , false, true)" PropertyName="Visible" EventName="BeforePrint" />
      </ExpressionBindings>
    </Item11>
    <Item12 Ref="585" ControlType="PageFooterBand" Name="PageFooter" HeightF="39.78">
      <SubBands>
        <Item1 Ref="586" ControlType="SubBand" Name="SubBand3" HeightF="19.08">
          <Controls>
            <Item1 Ref="587" ControlType="XRLine" Name="XrLine6" LineWidth="2" SizeF="746.6705,4" LocationFloat="0, 0" BorderWidth="3">
              <StylePriority Ref="588" UseBorderWidth="false" />
            </Item1>
            <Item2 Ref="589" ControlType="XRPageInfo" Name="XrPageInfo2" TextFormatString="Página {0} de {1}" TextAlignment="MiddleRight" SizeF="121,13" LocationFloat="625.4193, 4.000028" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100">
              <StylePriority Ref="590" UseFont="false" UseTextAlignment="false" />
            </Item2>
          </Controls>
        </Item1>
      </SubBands>
      <Controls>
        <Item1 Ref="591" ControlType="XRLabel" Name="lblCopia3" TextAlignment="MiddleRight" SizeF="445.7733,13" LocationFloat="300.64, 11.6" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <Scripts Ref="592" OnPrintOnPage="fldAssinatura11_PrintOnPage" />
          <StylePriority Ref="593" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="594" ControlType="XRLabel" Name="lblTransportar" TextFormatString="{0:0.00}" TextAlignment="MiddleLeft" SizeF="187.58,12" LocationFloat="561.38, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <Scripts Ref="595" OnSummaryGetResult="lblTransportar_SummaryGetResult" OnPrintOnPage="lblTransportar_PrintOnPage" />
          <Summary Ref="596" Running="Page" IgnoreNullValues="true" />
          <StylePriority Ref="597" UseFont="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="598" ControlType="XRLabel" Name="lblTituloTransportar" Text="Transportar" TextAlignment="MiddleRight" SizeF="78.96,12" LocationFloat="479.42, 0" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <Scripts Ref="599" OnPrintOnPage="lblTituloTransportar_PrintOnPage" />
          <StylePriority Ref="600" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item3>
        <Item4 Ref="601" ControlType="XRLabel" Name="fldAssinatura11" TextAlignment="MiddleRight" SizeF="445.7733,13" LocationFloat="300.646, 24.7" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <Scripts Ref="602" OnPrintOnPage="fldAssinatura11_PrintOnPage" />
          <StylePriority Ref="603" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item4>
        <Item5 Ref="604" ControlType="XRLabel" Name="fldAssinatura1" TextAlignment="MiddleLeft" SizeF="445.7733,13" LocationFloat="1.351039, 24.7" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100" Borders="None" BorderWidth="0">
          <Scripts Ref="605" OnPrintOnPage="fldAssinatura1_PrintOnPage" />
          <StylePriority Ref="606" UseFont="false" UseBorders="false" UseBorderWidth="false" UseTextAlignment="false" />
        </Item5>
      </Controls>
    </Item12>
    <Item13 Ref="607" ControlType="BottomMarginBand" Name="BottomMargin" HeightF="1" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
  </Bands>
  <Scripts Ref="608" OnBeforePrint="Documentos_de_Stocks_BeforePrint" />
  <ExportOptions Ref="609">
    <Html Ref="610" ExportMode="SingleFilePageByPage" />
  </ExportOptions>
  <Watermark Ref="611" ShowBehind="false" Font="Arial, 96pt" />
  <ObjectStorage>
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="3" Content="System.Int64" Type="System.Type" />
    <Item2 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="10" Content="System.Int32" Type="System.Type" />
    <Item3 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="14" Content="System.Boolean" Type="System.Type" />
    <Item4 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="17" Content="System.Int16" Type="System.Type" />
    <Item5 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Name="SqlDataSource" Base64="PFNxbERhdGFTb3VyY2UgTmFtZT0iU3FsRGF0YVNvdXJjZSI+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9RjNNLVBDMTQzXGYzbTIwMTc7VXNlciBJRD1GM01PO1Bhc3N3b3JkPTtJbml0aWFsIENhdGFsb2cgPTMwMjRGM01POyIgLz48UXVlcnkgVHlwZT0iQ3VzdG9tU3FsUXVlcnkiIE5hbWU9InRiRG9jdW1lbnRvc1N0b2NrIj48UGFyYW1ldGVyIE5hbWU9IklERG9jdW1lbnRvIiBUeXBlPSJEZXZFeHByZXNzLkRhdGFBY2Nlc3MuRXhwcmVzc2lvbiI+KFN5c3RlbS5JbnQ2NCwgbXNjb3JsaWIsIFZlcnNpb249NC4wLjAuMCwgQ3VsdHVyZT1uZXV0cmFsLCBQdWJsaWNLZXlUb2tlbj1iNzdhNWM1NjE5MzRlMDg5KShbUGFyYW1ldGVycy5JRERvY3VtZW50b10pPC9QYXJhbWV0ZXI+PFNxbD5zZWxlY3QgZGlzdGluY3QgICJ0YkRvY3VtZW50b3NTdG9jayIuIklEIiwNCiAgICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJJRFRpcG9Eb2N1bWVudG8iLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iTnVtZXJvRG9jdW1lbnRvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIkRhdGFEb2N1bWVudG8iLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iT2JzZXJ2YWNvZXMiLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iSURNb2VkYSIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJUYXhhQ29udmVyc2FvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIlRvdGFsTW9lZGFEb2N1bWVudG8iLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iVG90YWxNb2VkYVJlZmVyZW5jaWEiLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iTG9jYWxDYXJnYSIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJEYXRhQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iSG9yYUNhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIk1vcmFkYUNhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIklEQ29kaWdvUG9zdGFsQ2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iSURDb25jZWxob0NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIklERGlzdHJpdG9DYXJnYSIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJMb2NhbERlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIkRhdGFEZXNjYXJnYSIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJIb3JhRGVzY2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iTW9yYWRhRGVzY2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iSURDb2RpZ29Qb3N0YWxEZXNjYXJnYSIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJJRENvbmNlbGhvRGVzY2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iSUREaXN0cml0b0Rlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIk5vbWVEZXN0aW5hdGFyaW8iLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iTW9yYWRhRGVzdGluYXRhcmlvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIklEQ29kaWdvUG9zdGFsRGVzdGluYXRhcmlvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIklEQ29uY2VsaG9EZXN0aW5hdGFyaW8iLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iSUREaXN0cml0b0Rlc3RpbmF0YXJpbyIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJTZXJpZURvY01hbnVhbCIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJOdW1lcm9Eb2NNYW51YWwiLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iTnVtZXJvTGluaGFzIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIlBvc3RvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIklERXN0YWRvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIlV0aWxpemFkb3JFc3RhZG8iLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iRGF0YUhvcmFFc3RhZG8iLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iQXNzaW5hdHVyYSIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJWZXJzYW9DaGF2ZVByaXZhZGEiLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iTm9tZUZpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJNb3JhZGFGaXNjYWwiLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iSURDb2RpZ29Qb3N0YWxGaXNjYWwiLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iSURDb25jZWxob0Zpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJJRERpc3RyaXRvRmlzY2FsIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIkNvbnRyaWJ1aW50ZUZpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJTaWdsYVBhaXNGaXNjYWwiLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iSURMb2phIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIkltcHJlc3NvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIlZhbG9ySW1wb3N0byIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJQZXJjZW50YWdlbURlc2NvbnRvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIlZhbG9yRGVzY29udG8iLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iVmFsb3JQb3J0ZXMiLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iSURUYXhhSXZhUG9ydGVzIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIlRheGFJdmFQb3J0ZXMiLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iTW90aXZvSXNlbmNhb0l2YSIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJNb3Rpdm9Jc2VuY2FvUG9ydGVzIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIklERXNwYWNvRmlzY2FsUG9ydGVzIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIkVzcGFjb0Zpc2NhbFBvcnRlcyIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJJRFJlZ2ltZUl2YVBvcnRlcyIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJSZWdpbWVJdmFQb3J0ZXMiLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iQ3VzdG9zQWRpY2lvbmFpcyIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJTaXN0ZW1hIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIkF0aXZvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIkRhdGFDcmlhY2FvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIlV0aWxpemFkb3JDcmlhY2FvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIkRhdGFBbHRlcmFjYW8iLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iVXRpbGl6YWRvckFsdGVyYWNhbyIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJGM01NYXJjYWRvciIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJJREZvcm1hRXhwZWRpY2FvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIklEVGlwb3NEb2N1bWVudG9TZXJpZXMiLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iTnVtZXJvSW50ZXJubyIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJJREVudGlkYWRlIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIklEVGlwb0VudGlkYWRlIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIklEQ29uZGljYW9QYWdhbWVudG8iLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iSURMb2NhbE9wZXJhY2FvIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIkNvZGlnb0FUIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIklEUGFpc0NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIklEUGFpc0Rlc2NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIk1hdHJpY3VsYSIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJJRFBhaXNGaXNjYWwiLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iQ29kaWdvUG9zdGFsRmlzY2FsIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIkRlc2NyaWNhb0NvZGlnb1Bvc3RhbEZpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJEZXNjcmljYW9Db25jZWxob0Zpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJEZXNjcmljYW9EaXN0cml0b0Zpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJJREVzcGFjb0Zpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJJRFJlZ2ltZUl2YSIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJDb2RpZ29BVEludGVybm8iLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iVGlwb0Zpc2NhbCIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJEb2N1bWVudG8iLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iQ29kaWdvVGlwb0VzdGFkbyIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJDb2RpZ29Eb2NPcmlnZW0iLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iRGlzdHJpdG9DYXJnYSIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJDb25jZWxob0NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIkNvZGlnb1Bvc3RhbENhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIlNpZ2xhUGFpc0NhcmdhIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIkRpc3RyaXRvRGVzY2FyZ2EiLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iQ29uY2VsaG9EZXNjYXJnYSIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJDb2RpZ29Qb3N0YWxEZXNjYXJnYSIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJTaWdsYVBhaXNEZXNjYXJnYSIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJDb2RpZ29FbnRpZGFkZSIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJDb2RpZ29Nb2VkYSIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJNZW5zYWdlbURvY0FUIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIklEU2lzVGlwb3NEb2NQVSIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJDb2RpZ29TaXNUaXBvc0RvY1BVIiwNCiAgICAgICJ0YkRvY3VtZW50b3NTdG9jayIuIkRvY01hbnVhbCIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2siLiJEb2NSZXBvc2ljYW8iLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iRGF0YUFzc2luYXR1cmEiLA0KICAgICAgInRiRG9jdW1lbnRvc1N0b2NrIi4iRGF0YUNvbnRyb2xvSW50ZXJubyIsDQoJInRiRG9jdW1lbnRvc1N0b2NrIi4iU2VndW5kYVZpYSIsDQoJInRiRG9jdW1lbnRvc1N0b2NrIi4iRGF0YURvY3VtZW50byIsDQogICAgICAidGJEb2N1bWVudG9zU3RvY2tMaW5oYXMiLiJJRCIgYXMgInRiRG9jdW1lbnRvc1N0b2NrTGluaGFzX0lEIiwNCgkidGJEb2N1bWVudG9zU3RvY2tMaW5oYXMiLiJPcmRlbSIsDQogICAgICAgInRiRG9jdW1lbnRvc1N0b2NrTGluaGFzIi4iSUREb2N1bWVudG9TdG9jayIsDQogICAgICAgInRiRG9jdW1lbnRvc1N0b2NrTGluaGFzIi4iSURBcnRpZ28iLA0KICAgICAgICJ0YkRvY3VtZW50b3NTdG9ja0xpbmhhcyIuIkRlc2NyaWNhbyIsDQogICAgICAgInRiRG9jdW1lbnRvc1N0b2NrTGluaGFzIi4iSURVbmlkYWRlIiwNCiAgICAgICAidGJEb2N1bWVudG9zU3RvY2tMaW5oYXMiLiJOdW1DYXNhc0RlY1VuaWRhZGUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NTdG9ja0xpbmhhcyIuIlF1YW50aWRhZGUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NTdG9ja0xpbmhhcyIuIlByZWNvVW5pdGFyaW8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NTdG9ja0xpbmhhcyIuIlByZWNvVW5pdGFyaW9FZmV0aXZvIiwNCiAgICAgICAidGJEb2N1bWVudG9zU3RvY2tMaW5oYXMiLiJQcmVjb1RvdGFsIiwNCiAgICAgICAidGJEb2N1bWVudG9zU3RvY2tMaW5oYXMiLiJPYnNlcnZhY29lcyIgYXMgInRiRG9jdW1lbnRvc1N0b2NrTGluaGFzX09ic2VydmFjb2VzIiwNCiAgICAgICAidGJEb2N1bWVudG9zU3RvY2tMaW5oYXMiLiJJRExvdGUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NTdG9ja0xpbmhhcyIuIkNvZGlnb0xvdGUiLA0KCSAgICJ0YkRvY3VtZW50b3NTdG9ja0xpbmhhcyIuIkNvZGlnb1VuaWRhZGUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NTdG9ja0xpbmhhcyIuIkRlc2NyaWNhb0xvdGUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NTdG9ja0xpbmhhcyIuIkRhdGFGYWJyaWNvTG90ZSIsDQogICAgICAgInRiRG9jdW1lbnRvc1N0b2NrTGluaGFzIi4iRGF0YVZhbGlkYWRlTG90ZSIsDQogICAgICAgInRiRG9jdW1lbnRvc1N0b2NrTGluaGFzIi4iSURBcnRpZ29OdW1TZXJpZSIsDQogICAgICAgInRiRG9jdW1lbnRvc1N0b2NrTGluaGFzIi4iQXJ0aWdvTnVtU2VyaWUiLA0KICAgICAgICJ0YkRvY3VtZW50b3NTdG9ja0xpbmhhcyIuIklEQXJtYXplbSIsDQogICAgICAgInRiRG9jdW1lbnRvc1N0b2NrTGluaGFzIi4iSURBcm1hemVtTG9jYWxpemFjYW8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NTdG9ja0xpbmhhcyIuIklEQXJtYXplbURlc3Rpbm8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NTdG9ja0xpbmhhcyIuIklEQXJtYXplbUxvY2FsaXphY2FvRGVzdGlubyIsDQogICAgICAgInRiRG9jdW1lbnRvc1N0b2NrTGluaGFzIi4iTnVtTGluaGFzRGltZW5zb2VzIiwNCiAgICAgICAidGJEb2N1bWVudG9zU3RvY2tMaW5oYXMiLiJEZXNjb250bzEiLA0KICAgICAgICJ0YkRvY3VtZW50b3NTdG9ja0xpbmhhcyIuIkRlc2NvbnRvMiIsDQogICAgICAgInRiRG9jdW1lbnRvc1N0b2NrTGluaGFzIi4iSURUYXhhSXZhIiwNCiAgICAgICAidGJEb2N1bWVudG9zU3RvY2tMaW5oYXMiLiJUYXhhSXZhIiwNCiAgICAgICAidGJEb2N1bWVudG9zU3RvY2tMaW5oYXMiLiJNb3Rpdm9Jc2VuY2FvSXZhIiBhcyAidGJEb2N1bWVudG9zU3RvY2tMaW5oYXNfTW90aXZvSXNlbmNhb0l2YSIsDQogICAgICAgInRiRG9jdW1lbnRvc1N0b2NrTGluaGFzIi4iSURFc3BhY29GaXNjYWwiLA0KICAgICAgICJ0YkRvY3VtZW50b3NTdG9ja0xpbmhhcyIuIkVzcGFjb0Zpc2NhbCIsDQogICAgICAgInRiRG9jdW1lbnRvc1N0b2NrTGluaGFzIi4iSURSZWdpbWVJdmEiLA0KICAgICAgICJ0YkRvY3VtZW50b3NTdG9ja0xpbmhhcyIuIlJlZ2ltZUl2YSIsDQogICAgICAgInRiRG9jdW1lbnRvc1N0b2NrTGluaGFzIi4iU2lnbGFQYWlzIiwNCiAgICAgICAidGJEb2N1bWVudG9zU3RvY2tMaW5oYXMiLiJPcmRlbSIsDQogICAgICAgInRiRG9jdW1lbnRvc1N0b2NrTGluaGFzIi4iU2lzdGVtYSIgYXMgInRiRG9jdW1lbnRvc1N0b2NrTGluaGFzX1Npc3RlbWEiLA0KICAgICAgICJ0YkRvY3VtZW50b3NTdG9ja0xpbmhhcyIuIkF0aXZvIiBhcyAidGJEb2N1bWVudG9zU3RvY2tMaW5oYXNfQXRpdm8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NTdG9ja0xpbmhhcyIuIkRhdGFDcmlhY2FvIiBhcyAidGJEb2N1bWVudG9zU3RvY2tMaW5oYXNfRGF0YUNyaWFjYW8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NTdG9ja0xpbmhhcyIuIlV0aWxpemFkb3JDcmlhY2FvIiBhcyAidGJEb2N1bWVudG9zU3RvY2tMaW5oYXNfVXRpbGl6YWRvckNyaWFjYW8iLA0KICAgICAgICJ0YkRvY3VtZW50b3NTdG9ja0xpbmhhcyIuIkRhdGFBbHRlcmFjYW8iIGFzICJ0YkRvY3VtZW50b3NTdG9ja0xpbmhhc19EYXRhQWx0ZXJhY2FvIiwNCiAgICAgICAidGJEb2N1bWVudG9zU3RvY2tMaW5oYXMiLiJVdGlsaXphZG9yQWx0ZXJhY2FvIiBhcyAidGJEb2N1bWVudG9zU3RvY2tMaW5oYXNfVXRpbGl6YWRvckFsdGVyYWNhbyIsDQogICAgICAgInRiRG9jdW1lbnRvc1N0b2NrTGluaGFzIi4iRjNNTWFyY2Fkb3IiIGFzICJ0YkRvY3VtZW50b3NTdG9ja0xpbmhhc19GM01NYXJjYWRvciIsDQogICAgICAgInRiRG9jdW1lbnRvc1N0b2NrTGluaGFzIi4iVmFsb3JJbmNpZGVuY2lhIiwNCiAgICAgICAidGJEb2N1bWVudG9zU3RvY2tMaW5oYXMiLiJWYWxvcklWQSIsDQoJICAgInRiQ2xpZW50ZXMiLiJOb21lIiBhcyAidGJDbGllbnRlc19Ob21lIiwNCgkgICAidGJDbGllbnRlcyIuIkNvZGlnbyIgYXMgInRiQ2xpZW50ZXNfQ29kaWdvIiwNCgkgICAidGJDbGllbnRlcyIuIk5Db250cmlidWludGUiIGFzICJ0YkNsaWVudGVzX05Db250cmlidWludGUiLA0KCSAgICJ0YkNsaWVudGVzTW9yYWRhcyIuIk1vcmFkYSIgYXMgInRiQ2xpZW50ZXNNb3JhZGFzX01vcmFkYSIsDQoJICAgInRiQ29kaWdvc1Bvc3RhaXMiLiJDb2RpZ28iIGFzICJ0YkNvZGlnb3NQb3N0YWlzQ2xpZW50ZV9Db2RpZ28iLA0KCSAgICJ0YkNvZGlnb3NQb3N0YWlzIi4iRGVzY3JpY2FvIiBhcyAidGJDb2RpZ29zUG9zdGFpc0NsaWVudGVfRGVzY3JpY2FvIiwNCiAgICAgICAidGJFc3RhZG9zIi4iQ29kaWdvIiBhcyAidGJFc3RhZG9zX0NvZGlnbyIsDQogICAgICAgInRiRXN0YWRvcyIuIkRlc2NyaWNhbyIgYXMgInRiRXN0YWRvc19EZXNjcmljYW8iLA0KICAgICAgICJ0YlRpcG9zRG9jdW1lbnRvIi4iQ29kaWdvIiBhcyAidGJUaXBvc0RvY3VtZW50b19Db2RpZ28iLA0KICAgICAgICJ0YlRpcG9zRG9jdW1lbnRvIi4iRGVzY3JpY2FvIiBhcyAidGJUaXBvc0RvY3VtZW50b19EZXNjcmljYW8iLA0KCSAgICJ0YlRpcG9zRG9jdW1lbnRvIi4iRG9jTmFvVmFsb3JpemFkbyIgYXMgInRiVGlwb3NEb2N1bWVudG9fRG9jTmFvVmFsb3JpemFkbyIsDQoJICAgInRiVGlwb3NEb2N1bWVudG8iLiJBY29tcGFuaGFCZW5zQ2lyY3VsYWNhbyIgYXMgInRiVGlwb3NEb2N1bWVudG9fQWNvbXBhbmhhQmVuc0NpcmN1bGFjYW8iLA0KICAgICAgICJ0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIi4iQ29kaWdvU2VyaWUiLA0KICAgICAgICJ0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIi4iRGVzY3JpY2FvU2VyaWUiLA0KICAgICAgICJ0YkFydGlnb3MiLiJDb2RpZ28iIGFzICJ0YkFydGlnb3NfQ29kaWdvIiwNCiAgICAgICAidGJBcnRpZ29zIi4iRGVzY3JpY2FvQWJyZXZpYWRhIiwNCiAgICAgICAidGJBcnRpZ29zIi4iRGVzY3JpY2FvIiBhcyAidGJBcnRpZ29zX0Rlc2NyaWNhbyIsDQogICAgICAgInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIi4iRGVzY3JpY2FvIiBhcyAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWxfRGVzY3JpY2FvIiwNCgkgICAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8iLiJUaXBvIiBhcyAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9fVGlwbyIsDQoJICAgInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIi4iRGVzY3JpY2FvIiBhcyAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9fRGVzY3JpY2FvIiwNCiAgICAgICAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiLiJUaXBvIiwNCiAgICAgICAidGJDb2RpZ29zUG9zdGFpczEiLiJDb2RpZ28iIGFzICJ0YkNvZGlnb3NQb3N0YWlzX0NvZGlnbyIsDQogICAgICAgInRiQ29kaWdvc1Bvc3RhaXMxIi4iRGVzY3JpY2FvIiBhcyAidGJDb2RpZ29zUG9zdGFpc19EZXNjcmljYW8iLA0KICAgICAgICJ0YkNvZGlnb3NQb3N0YWlzMiIuIkNvZGlnbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNDYXJnYV9Db2RpZ28iLA0KICAgICAgICJ0YkNvZGlnb3NQb3N0YWlzMiIuIkRlc2NyaWNhbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNDYXJnYV9EZXNjcmljYW8iLA0KICAgICAgICJ0YkNvZGlnb3NQb3N0YWlzMyIuIkNvZGlnbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNEZXNjYXJnYV9Db2RpZ28iLA0KICAgICAgICJ0YkNvZGlnb3NQb3N0YWlzMyIuIkRlc2NyaWNhbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNEZXNjYXJnYV9EZXNjcmljYW8iLA0KICAgICAgICJ0Yk1vZWRhcyIuIkNvZGlnbyIgYXMgInRiTW9lZGFzX0NvZGlnbyIsDQogICAgICAgInRiTW9lZGFzIi4iRGVzY3JpY2FvIiBhcyAidGJNb2VkYXNfRGVzY3JpY2FvIiwNCiAgICAgICAidGJNb2VkYXMiLiJTaW1ib2xvIiBhcyAidGJNb2VkYXNfU2ltYm9sbyIsDQoJICAgInRiQXJtYXplbnMiLiJEZXNjcmljYW8iIGFzICJ0YkFybWF6ZW5zX0Rlc2NyaWNhbyIsDQoJICAgInRiQXJtYXplbnMiLiJDb2RpZ28iIGFzICJ0YkFybWF6ZW5zX0NvZGlnbyIsDQoJICAgInRiQXJtYXplbnNMb2NhbGl6YWNvZXMiLiJEZXNjcmljYW8iIGFzICJ0YkFybWF6ZW5zTG9jYWxpemFjb2VzX0Rlc2NyaWNhbyIsDQoJICAgInRiQXJtYXplbnNMb2NhbGl6YWNvZXMiLiJDb2RpZ28iIGFzICJ0YkFybWF6ZW5zTG9jYWxpemFjb2VzX0NvZGlnbyIsDQoJICAgInRiQXJtYXplbnMxIi4iRGVzY3JpY2FvIiBhcyAidGJBcm1hemVuczFfRGVzY3JpY2FvRGVzdGlubyIsDQoJICAgInRiQXJtYXplbnMxIi4iQ29kaWdvIiBhcyAidGJBcm1hemVuczFfQ29kaWdvRGVzdGlubyIsDQoJICAgInRiQXJtYXplbnNMb2NhbGl6YWNvZXMxIi4iRGVzY3JpY2FvIiBhcyAidGJBcm1hemVuc0xvY2FsaXphY29lczFfRGVzY3JpY2FvIiwNCgkgICAidGJBcm1hemVuc0xvY2FsaXphY29lczEiLiJDb2RpZ28iIGFzICJ0YkFybWF6ZW5zTG9jYWxpemFjb2VzMV9Db2RpZ28iLA0KICAgICAgICJ0Yk1vZWRhcyIuIkNhc2FzRGVjaW1haXNUb3RhaXMiIGFzICJ0Yk1vZWRhc19DYXNhc0RlY2ltYWlzVG90YWlzIiwNCgkgICAidGJTaXN0ZW1hQ29kaWdvc0lWQSIuIkNvZGlnbyIgYXMgInRiU2lzdGVtYUNvZGlnb3NJVkEuQ29kaWdvIiwgDQogICAgICAgInRiU2lzdGVtYU1vZWRhcyIuIkNvZGlnbyIgYXMgInRiU2lzdGVtYU1vZWRhc19Db2RpZ28iLA0KCSAgICJ0YkRvY3VtZW50b3NTdG9jayIuIlRvdGFsTW9lZGFEb2N1bWVudG8iIC0gInRiRG9jdW1lbnRvc1N0b2NrIi4iVmFsb3JJbXBvc3RvIiBhcyAiU3ViVG90YWwiLA0KCSAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iQ2FzYXNEZWNpbWFpc1BlcmNlbnRhZ2VtIiBhcyAidGJQYXJhbWVudHJvc0VtcHJlc2FfQ2FzYXNEZWNpbWFpc1BlcmNlbnRhZ2VtIg0KICBmcm9tICJkYm8iLiJ0YkRvY3VtZW50b3NTdG9jayINCiAgICAgICAidGJEb2N1bWVudG9zU3RvY2siDQogIGxlZnQgam9pbiAiZGJvIi4idGJEb2N1bWVudG9zU3RvY2tMaW5oYXMiDQogICAgICAgInRiRG9jdW1lbnRvc1N0b2NrTGluaGFzIg0KICAgICAgIG9uICJ0YkRvY3VtZW50b3NTdG9ja0xpbmhhcyIuIklERG9jdW1lbnRvU3RvY2siID0gInRiRG9jdW1lbnRvc1N0b2NrIi4iSUQiDQogIGxlZnQgam9pbiAiZGJvIi4idGJJVkEiICJ0YklWQSIgb24gInRiSVZBIi4iSUQiID0gInRiRG9jdW1lbnRvc1N0b2NrTGluaGFzIi4iSURUYXhhSXZhIg0KICBsZWZ0IGpvaW4gdGJTaXN0ZW1hQ29kaWdvc0lWQSBvbiB0YklWQS5JRENvZGlnb0lWQSA9IHRiU2lzdGVtYUNvZGlnb3NJVkEuSUQNCiAgbGVmdCBqb2luICJkYm8iLiJ0YlNpc3RlbWFUaXBvc0lWQSIgInRiU2lzdGVtYVRpcG9zSVZBIiBvbiAidGJTaXN0ZW1hVGlwb3NJVkEiLiJJRCIgPSAidGJJVkEiLiJJRFRpcG9JdmEiDQogIGxlZnQgam9pbiAiZGJvIi4idGJDbGllbnRlcyIgInRiQ2xpZW50ZXMiDQogICAgICAgb24gInRiQ2xpZW50ZXMiLiJJRCIgPSAidGJEb2N1bWVudG9zU3RvY2siLiJJREVudGlkYWRlIg0KICBsZWZ0IGpvaW4gImRibyIuICJ0YkNsaWVudGVzTW9yYWRhcyIgInRiQ2xpZW50ZXNNb3JhZGFzIg0KCSAgIG9uICJ0YkNsaWVudGVzTW9yYWRhcyIuIklEQ2xpZW50ZSIgPSAidGJEb2N1bWVudG9zU3RvY2siLiJJREVudGlkYWRlIiBhbmQgInRiQ2xpZW50ZXNNb3JhZGFzIi4iT3JkZW0iPTENCiAgbGVmdCBqb2luICJkYm8iLiJ0YkNvZGlnb3NQb3N0YWlzIiAidGJDb2RpZ29zUG9zdGFpcyINCiAgICAgICBvbiAidGJDb2RpZ29zUG9zdGFpcyIuIklEIiA9ICJ0YkNsaWVudGVzTW9yYWRhcyIuIklEQ29kaWdvUG9zdGFsIg0KICBsZWZ0IGpvaW4gImRibyIuInRiRXN0YWRvcyIgInRiRXN0YWRvcyINCiAgICAgICBvbiAidGJFc3RhZG9zIi4iSUQiID0gInRiRG9jdW1lbnRvc1N0b2NrIi4iSURFc3RhZG8iDQogIGxlZnQgam9pbiAiZGJvIi4idGJUaXBvc0RvY3VtZW50byINCiAgICAgICAidGJUaXBvc0RvY3VtZW50byINCiAgICAgICBvbiAidGJUaXBvc0RvY3VtZW50byIuIklEIiA9ICJ0YkRvY3VtZW50b3NTdG9jayIuIklEVGlwb0RvY3VtZW50byINCiAgbGVmdCBqb2luICJkYm8iLiJ0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIg0KICAgICAgICJ0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIg0KICAgICAgIG9uICJ0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIi4iSUQiID0gInRiRG9jdW1lbnRvc1N0b2NrIi4iSURUaXBvc0RvY3VtZW50b1NlcmllcyINCgkgICAgbGVmdCBqb2luICJkYm8iLiJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50byINCiAgICAgICAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8iDQogICAgICAgb24gInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIi4iSUQiID0gInRiVGlwb3NEb2N1bWVudG8iLiJJRFNpc3RlbWFUaXBvc0RvY3VtZW50byINCiAgbGVmdCBqb2luICJkYm8iLiJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCINCiAgICAgICAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiDQogICAgICAgb24gInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIi4iSUQiID0gInRiVGlwb3NEb2N1bWVudG8iLiJJRFNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkFydGlnb3MiICJ0YkFydGlnb3MiDQogICAgICAgb24gInRiQXJ0aWdvcyIuIklEIiA9ICJ0YkRvY3VtZW50b3NTdG9ja0xpbmhhcyIuIklEQXJ0aWdvIg0KICBsZWZ0IGpvaW4gImRibyIuInRiQ29kaWdvc1Bvc3RhaXMiICJ0YkNvZGlnb3NQb3N0YWlzMSINCiAgICAgICBvbiAidGJDb2RpZ29zUG9zdGFpczEiLiJJRCIgPSAidGJEb2N1bWVudG9zU3RvY2siLiJJRENvZGlnb1Bvc3RhbEZpc2NhbCINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkNvZGlnb3NQb3N0YWlzIiAidGJDb2RpZ29zUG9zdGFpczIiDQogICAgICAgb24gInRiQ29kaWdvc1Bvc3RhaXMyIi4iSUQiID0gInRiRG9jdW1lbnRvc1N0b2NrIi4iSURDb2RpZ29Qb3N0YWxDYXJnYSINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkNvZGlnb3NQb3N0YWlzIiAidGJDb2RpZ29zUG9zdGFpczMiDQogICAgICAgb24gInRiQ29kaWdvc1Bvc3RhaXMzIi4iSUQiID0gInRiRG9jdW1lbnRvc1N0b2NrIi4iSURDb2RpZ29Qb3N0YWxEZXNjYXJnYSINCiAgbGVmdCBqb2luICJkYm8iLiJ0Yk1vZWRhcyIgInRiTW9lZGFzIg0KICAgICAgIG9uICJ0Yk1vZWRhcyIuIklEIiA9ICJ0YkRvY3VtZW50b3NTdG9jayIuIklETW9lZGEiDQogIGxlZnQgam9pbiAidGJQYXJhbWV0cm9zRW1wcmVzYSIgDQogICAgICAgb24gInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJJRE1vZWRhRGVmZWl0byIgPSAidGJNb2VkYXMiLiJJRCIgDQogIGxlZnQgam9pbiAiZGJvIi4idGJTaXN0ZW1hTW9lZGFzIiAidGJTaXN0ZW1hTW9lZGFzIg0KICAgICAgIG9uICJ0YlNpc3RlbWFNb2VkYXMiLiJJRCIgPSAidGJNb2VkYXMiLiJJRFNpc3RlbWFNb2VkYSINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkFybWF6ZW5zIiAidGJBcm1hemVucyINCiAgICAgICBvbiAidGJBcm1hemVucyIuIklEIiA9ICJ0YkRvY3VtZW50b3NTdG9ja0xpbmhhcyIuIklEQXJtYXplbSINCiAgbGVmdCBqb2luICJkYm8iLiJ0YkFybWF6ZW5zTG9jYWxpemFjb2VzIiAidGJBcm1hemVuc0xvY2FsaXphY29lcyINCiAgICAgICBvbiAidGJBcm1hemVuc0xvY2FsaXphY29lcyIuIklEIiA9ICJ0YkRvY3VtZW50b3NTdG9ja0xpbmhhcyIuIklEQXJtYXplbUxvY2FsaXphY2FvIg0KICBsZWZ0IGpvaW4gImRibyIuInRiQXJtYXplbnMiICJ0YkFybWF6ZW5zMSINCiAgICAgICBvbiAidGJBcm1hemVuczEiLiJJRCIgPSAidGJEb2N1bWVudG9zU3RvY2tMaW5oYXMiLiJJREFybWF6ZW1EZXN0aW5vIg0KICBsZWZ0IGpvaW4gImRibyIuInRiQXJtYXplbnNMb2NhbGl6YWNvZXMiICJ0YkFybWF6ZW5zTG9jYWxpemFjb2VzMSINCiAgICAgICBvbiAidGJBcm1hemVuc0xvY2FsaXphY29lczEiLiJJRCIgPSAidGJEb2N1bWVudG9zU3RvY2tMaW5oYXMiLiJJREFybWF6ZW1Mb2NhbGl6YWNhb0Rlc3Rpbm8iDQp3aGVyZSAidGJEb2N1bWVudG9zU3RvY2siLiJJRCI9IEBJRERvY3VtZW50bw0KT3JkZXIgYnkgInRiRG9jdW1lbnRvc1N0b2NrTGluaGFzIi4iT3JkZW0iPC9TcWw+PC9RdWVyeT48UXVlcnkgVHlwZT0iQ3VzdG9tU3FsUXVlcnkiIE5hbWU9InRiRG9jdW1lbnRvc1N0b2NrX0NhYiI+PFBhcmFtZXRlciBOYW1lPSJJZERvYyIgVHlwZT0iRGV2RXhwcmVzcy5EYXRhQWNjZXNzLkV4cHJlc3Npb24iPihTeXN0ZW0uSW50NjQsIG1zY29ybGliLCBWZXJzaW9uPTQuMC4wLjAsIEN1bHR1cmU9bmV1dHJhbCwgUHVibGljS2V5VG9rZW49Yjc3YTVjNTYxOTM0ZTA4OSkoP0lERG9jdW1lbnRvKTwvUGFyYW1ldGVyPjxTcWw+c2VsZWN0IGRpc3RpbmN0ICJ0YkRvY3VtZW50b3NTdG9jayIuIklEIiwidGJEb2N1bWVudG9zU3RvY2siLiJJRFRpcG9Eb2N1bWVudG8iLCJ0YkRvY3VtZW50b3NTdG9jayIuIk51bWVyb0RvY3VtZW50byIsInRiRG9jdW1lbnRvc1N0b2NrIi4iRGF0YURvY3VtZW50byIsInRiRG9jdW1lbnRvc1N0b2NrIi4iT2JzZXJ2YWNvZXMiLCJ0YkRvY3VtZW50b3NTdG9jayIuIklETW9lZGEiLCJ0YkRvY3VtZW50b3NTdG9jayIuIlRheGFDb252ZXJzYW8iLCJ0YkRvY3VtZW50b3NTdG9jayIuIlRvdGFsTW9lZGFEb2N1bWVudG8iLCJ0YkRvY3VtZW50b3NTdG9jayIuIlRvdGFsTW9lZGFSZWZlcmVuY2lhIiwidGJEb2N1bWVudG9zU3RvY2siLiJMb2NhbENhcmdhIiwidGJEb2N1bWVudG9zU3RvY2siLiJEYXRhQ2FyZ2EiLCJ0YkRvY3VtZW50b3NTdG9jayIuIkhvcmFDYXJnYSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iTW9yYWRhQ2FyZ2EiLCJ0YkRvY3VtZW50b3NTdG9jayIuIklEQ29kaWdvUG9zdGFsQ2FyZ2EiLCJ0YkRvY3VtZW50b3NTdG9jayIuIklEQ29uY2VsaG9DYXJnYSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iSUREaXN0cml0b0NhcmdhIiwidGJEb2N1bWVudG9zU3RvY2siLiJMb2NhbERlc2NhcmdhIiwidGJEb2N1bWVudG9zU3RvY2siLiJEYXRhRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NTdG9jayIuIkhvcmFEZXNjYXJnYSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iTW9yYWRhRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NTdG9jayIuIklEQ29kaWdvUG9zdGFsRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NTdG9jayIuIklEQ29uY2VsaG9EZXNjYXJnYSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iSUREaXN0cml0b0Rlc2NhcmdhIiwidGJEb2N1bWVudG9zU3RvY2siLiJOb21lRGVzdGluYXRhcmlvIiwidGJEb2N1bWVudG9zU3RvY2siLiJNb3JhZGFEZXN0aW5hdGFyaW8iLCJ0YkRvY3VtZW50b3NTdG9jayIuIklEQ29kaWdvUG9zdGFsRGVzdGluYXRhcmlvIiwidGJEb2N1bWVudG9zU3RvY2siLiJJRENvbmNlbGhvRGVzdGluYXRhcmlvIiwidGJEb2N1bWVudG9zU3RvY2siLiJJRERpc3RyaXRvRGVzdGluYXRhcmlvIiwidGJEb2N1bWVudG9zU3RvY2siLiJTZXJpZURvY01hbnVhbCIsInRiRG9jdW1lbnRvc1N0b2NrIi4iTnVtZXJvRG9jTWFudWFsIiwidGJEb2N1bWVudG9zU3RvY2siLiJOdW1lcm9MaW5oYXMiLCJ0YkRvY3VtZW50b3NTdG9jayIuIlBvc3RvIiwidGJEb2N1bWVudG9zU3RvY2siLiJJREVzdGFkbyIsInRiRG9jdW1lbnRvc1N0b2NrIi4iVXRpbGl6YWRvckVzdGFkbyIsInRiRG9jdW1lbnRvc1N0b2NrIi4iRGF0YUhvcmFFc3RhZG8iLCJ0YkRvY3VtZW50b3NTdG9jayIuIkFzc2luYXR1cmEiLCJ0YkRvY3VtZW50b3NTdG9jayIuIlZlcnNhb0NoYXZlUHJpdmFkYSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iTm9tZUZpc2NhbCIsInRiRG9jdW1lbnRvc1N0b2NrIi4iTW9yYWRhRmlzY2FsIiwidGJEb2N1bWVudG9zU3RvY2siLiJJRENvZGlnb1Bvc3RhbEZpc2NhbCIsInRiRG9jdW1lbnRvc1N0b2NrIi4iSURDb25jZWxob0Zpc2NhbCIsInRiRG9jdW1lbnRvc1N0b2NrIi4iSUREaXN0cml0b0Zpc2NhbCIsInRiRG9jdW1lbnRvc1N0b2NrIi4iQ29udHJpYnVpbnRlRmlzY2FsIiwidGJEb2N1bWVudG9zU3RvY2siLiJTaWdsYVBhaXNGaXNjYWwiLCJ0YkRvY3VtZW50b3NTdG9jayIuIklETG9qYSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iSW1wcmVzc28iLCJ0YkRvY3VtZW50b3NTdG9jayIuIlZhbG9ySW1wb3N0byIsInRiRG9jdW1lbnRvc1N0b2NrIi4iUGVyY2VudGFnZW1EZXNjb250byIsInRiRG9jdW1lbnRvc1N0b2NrIi4iVmFsb3JEZXNjb250byIsInRiRG9jdW1lbnRvc1N0b2NrIi4iVmFsb3JQb3J0ZXMiLCJ0YkRvY3VtZW50b3NTdG9jayIuIklEVGF4YUl2YVBvcnRlcyIsInRiRG9jdW1lbnRvc1N0b2NrIi4iVGF4YUl2YVBvcnRlcyIsInRiRG9jdW1lbnRvc1N0b2NrIi4iTW90aXZvSXNlbmNhb0l2YSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iTW90aXZvSXNlbmNhb1BvcnRlcyIsInRiRG9jdW1lbnRvc1N0b2NrIi4iSURFc3BhY29GaXNjYWxQb3J0ZXMiLCJ0YkRvY3VtZW50b3NTdG9jayIuIkVzcGFjb0Zpc2NhbFBvcnRlcyIsInRiRG9jdW1lbnRvc1N0b2NrIi4iSURSZWdpbWVJdmFQb3J0ZXMiLCJ0YkRvY3VtZW50b3NTdG9jayIuIlJlZ2ltZUl2YVBvcnRlcyIsInRiRG9jdW1lbnRvc1N0b2NrIi4iQ3VzdG9zQWRpY2lvbmFpcyIsInRiRG9jdW1lbnRvc1N0b2NrIi4iU2lzdGVtYSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iQXRpdm8iLCJ0YkRvY3VtZW50b3NTdG9jayIuIkRhdGFDcmlhY2FvIiwidGJEb2N1bWVudG9zU3RvY2siLiJVdGlsaXphZG9yQ3JpYWNhbyIsInRiRG9jdW1lbnRvc1N0b2NrIi4iRGF0YUFsdGVyYWNhbyIsInRiRG9jdW1lbnRvc1N0b2NrIi4iVXRpbGl6YWRvckFsdGVyYWNhbyIsInRiRG9jdW1lbnRvc1N0b2NrIi4iRjNNTWFyY2Fkb3IiLCJ0YkRvY3VtZW50b3NTdG9jayIuIklERm9ybWFFeHBlZGljYW8iLCJ0YkRvY3VtZW50b3NTdG9jayIuIklEVGlwb3NEb2N1bWVudG9TZXJpZXMiLCJ0YkRvY3VtZW50b3NTdG9jayIuIk51bWVyb0ludGVybm8iLCJ0YkRvY3VtZW50b3NTdG9jayIuIklERW50aWRhZGUiLCJ0YkRvY3VtZW50b3NTdG9jayIuIklEVGlwb0VudGlkYWRlIiwidGJEb2N1bWVudG9zU3RvY2siLiJJRENvbmRpY2FvUGFnYW1lbnRvIiwidGJEb2N1bWVudG9zU3RvY2siLiJJRExvY2FsT3BlcmFjYW8iLCJ0YkRvY3VtZW50b3NTdG9jayIuIkNvZGlnb0FUIiwidGJEb2N1bWVudG9zU3RvY2siLiJJRFBhaXNDYXJnYSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iSURQYWlzRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NTdG9jayIuIk1hdHJpY3VsYSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iSURQYWlzRmlzY2FsIiwidGJEb2N1bWVudG9zU3RvY2siLiJDb2RpZ29Qb3N0YWxGaXNjYWwiLCJ0YkRvY3VtZW50b3NTdG9jayIuIkRlc2NyaWNhb0NvZGlnb1Bvc3RhbEZpc2NhbCIsInRiRG9jdW1lbnRvc1N0b2NrIi4iRGVzY3JpY2FvQ29uY2VsaG9GaXNjYWwiLCJ0YkRvY3VtZW50b3NTdG9jayIuIkRlc2NyaWNhb0Rpc3RyaXRvRmlzY2FsIiwidGJEb2N1bWVudG9zU3RvY2siLiJJREVzcGFjb0Zpc2NhbCIsInRiRG9jdW1lbnRvc1N0b2NrIi4iSURSZWdpbWVJdmEiLCJ0YkRvY3VtZW50b3NTdG9jayIuIkNvZGlnb0FUSW50ZXJubyIsInRiRG9jdW1lbnRvc1N0b2NrIi4iVGlwb0Zpc2NhbCIsInRiRG9jdW1lbnRvc1N0b2NrIi4iRG9jdW1lbnRvIiwidGJEb2N1bWVudG9zU3RvY2siLiJDb2RpZ29UaXBvRXN0YWRvIiwidGJEb2N1bWVudG9zU3RvY2siLiJDb2RpZ29Eb2NPcmlnZW0iLCJ0YkRvY3VtZW50b3NTdG9jayIuIkRpc3RyaXRvQ2FyZ2EiLCJ0YkRvY3VtZW50b3NTdG9jayIuIkNvbmNlbGhvQ2FyZ2EiLCJ0YkRvY3VtZW50b3NTdG9jayIuIkNvZGlnb1Bvc3RhbENhcmdhIiwidGJEb2N1bWVudG9zU3RvY2siLiJTaWdsYVBhaXNDYXJnYSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iRGlzdHJpdG9EZXNjYXJnYSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iQ29uY2VsaG9EZXNjYXJnYSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iQ29kaWdvUG9zdGFsRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NTdG9jayIuIlNpZ2xhUGFpc0Rlc2NhcmdhIiwidGJEb2N1bWVudG9zU3RvY2siLiJDb2RpZ29FbnRpZGFkZSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iQ29kaWdvTW9lZGEiLCJ0YkRvY3VtZW50b3NTdG9jayIuIk1lbnNhZ2VtRG9jQVQiLCJ0YkRvY3VtZW50b3NTdG9jayIuIklEU2lzVGlwb3NEb2NQVSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iQ29kaWdvU2lzVGlwb3NEb2NQVSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iRG9jTWFudWFsIiwidGJEb2N1bWVudG9zU3RvY2siLiJEb2NSZXBvc2ljYW8iLCJ0YkRvY3VtZW50b3NTdG9jayIuIkRhdGFBc3NpbmF0dXJhIiwidGJEb2N1bWVudG9zU3RvY2siLiJEYXRhQ29udHJvbG9JbnRlcm5vIiwidGJEb2N1bWVudG9zU3RvY2siLiJTdWJUb3RhbCIsInRiRG9jdW1lbnRvc1N0b2NrIi4iVm9zc29OdW1lcm9Eb2N1bWVudG8iLCJ0YkRvY3VtZW50b3NTdG9jayIuIkRhdGFWZW5jaW1lbnRvIiwidGJEb2N1bWVudG9zU3RvY2siLiJTZWd1bmRhVmlhIiwidGJEb2N1bWVudG9zU3RvY2siLiJEYXRhVWx0aW1hSW1wcmVzc2FvIiwidGJEb2N1bWVudG9zU3RvY2siLiJOdW1lcm9JbXByZXNzb2VzIiwidGJEb2N1bWVudG9zU3RvY2siLiJJRExvamFVbHRpbWFJbXByZXNzYW8iLCJ0YkRvY3VtZW50b3NTdG9jayIuIlNhdGlzZmVpdG8iLCJ0YkRvY3VtZW50b3NTdG9jayIuIklERG9jUmVzZXJ2YSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iRGF0YUVudHJlZ2EiLCJ0YkRvY3VtZW50b3NTdG9jayIuIlJhemFvRXN0YWRvIiwidGJDbGllbnRlcyIuIkNvZGlnbyIgYXMgInRiQ2xpZW50ZXNfQ29kaWdvIiwidGJDbGllbnRlcyIuIk5vbWUiIGFzICJ0YkNsaWVudGVzX05vbWUiLCJ0YkNsaWVudGVzIi4iTkNvbnRyaWJ1aW50ZSIgYXMgInRiQ2xpZW50ZXNfTkNvbnRyaWJ1aW50ZSIsInRiQ2xpZW50ZXNNb3JhZGFzIi4iTW9yYWRhIiBhcyAidGJDbGllbnRlc01vcmFkYXNfTW9yYWRhIiwidGJDb2RpZ29zUG9zdGFpcyIuIkNvZGlnbyIgYXMgInRiQ29kaWdvc1Bvc3RhaXNDbGllbnRlX0NvZGlnbyIsInRiQ29kaWdvc1Bvc3RhaXMiLiJEZXNjcmljYW8iIGFzICJ0YkNvZGlnb3NQb3N0YWlzQ2xpZW50ZV9EZXNjcmljYW8iLCJ0YkVzdGFkb3MiLiJDb2RpZ28iIGFzICJ0YkVzdGFkb3NfQ29kaWdvIiwidGJFc3RhZG9zIi4iRGVzY3JpY2FvIiBhcyAidGJFc3RhZG9zX0Rlc2NyaWNhbyIsInRiVGlwb3NEb2N1bWVudG8iLiJDb2RpZ28iIGFzICJ0YlRpcG9zRG9jdW1lbnRvX0NvZGlnbyIsInRiVGlwb3NEb2N1bWVudG8iLiJEZXNjcmljYW8iIGFzICJ0YlRpcG9zRG9jdW1lbnRvX0Rlc2NyaWNhbyIsInRiVGlwb3NEb2N1bWVudG8iLiJEb2NOYW9WYWxvcml6YWRvIiBhcyAidGJUaXBvc0RvY3VtZW50b19Eb2NOYW9WYWxvcml6YWRvIiwidGJUaXBvc0RvY3VtZW50byIuIkFjb21wYW5oYUJlbnNDaXJjdWxhY2FvIiBhcyAidGJUaXBvc0RvY3VtZW50b19BY29tcGFuaGFCZW5zQ2lyY3VsYWNhbyIsInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiLiJDb2RpZ29TZXJpZSIsInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiLiJEZXNjcmljYW9TZXJpZSIsInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvRmlzY2FsIi4iRGVzY3JpY2FvIiBhcyAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWxfRGVzY3JpY2FvIiwidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8iLiJUaXBvIiBhcyAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9fVGlwbyIsInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIi4iRGVzY3JpY2FvIiBhcyAidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9fRGVzY3JpY2FvIiwidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiLiJUaXBvIiwidGJDb2RpZ29zUG9zdGFpczIiLiJDb2RpZ28iIGFzICJ0YkNvZGlnb3NQb3N0YWlzQ2FyZ2FfQ29kaWdvIiwidGJDb2RpZ29zUG9zdGFpczIiLiJEZXNjcmljYW8iIGFzICJ0YkNvZGlnb3NQb3N0YWlzQ2FyZ2FfRGVzY3JpY2FvIiwidGJDb2RpZ29zUG9zdGFpczMiLiJDb2RpZ28iIGFzICJ0YkNvZGlnb3NQb3N0YWlzRGVzY2FyZ2FfQ29kaWdvIiwidGJDb2RpZ29zUG9zdGFpczMiLiJEZXNjcmljYW8iIGFzICJ0YkNvZGlnb3NQb3N0YWlzRGVzY2FyZ2FfRGVzY3JpY2FvIiwidGJDb2RpZ29zUG9zdGFpczEiLiJDb2RpZ28iIGFzICJ0YkNvZGlnb3NQb3N0YWlzX0NvZGlnbyIsInRiQ29kaWdvc1Bvc3RhaXMxIi4iRGVzY3JpY2FvIiBhcyAidGJDb2RpZ29zUG9zdGFpc19EZXNjcmljYW8iLCJ0Yk1vZWRhcyIuIkRlc2NyaWNhbyIgYXMgInRiTW9lZGFzX0Rlc2NyaWNhbyIsInRiTW9lZGFzIi4iU2ltYm9sbyIgYXMgInRiTW9lZGFzX1NpbWJvbG8iLCJ0Yk1vZWRhcyIuIkNvZGlnbyIgYXMgInRiTW9lZGFzX0NvZGlnbyIsInRiTW9lZGFzIi4iQ2FzYXNEZWNpbWFpc1RvdGFpcyIgYXMgInRiTW9lZGFzX0Nhc2FzRGVjaW1haXNUb3RhaXMiLCJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iQ2FzYXNEZWNpbWFpc1BlcmNlbnRhZ2VtIiBhcyAidGJQYXJhbWVudHJvc0VtcHJlc2FfQ2FzYXNEZWNpbWFpc1BlcmNlbnRhZ2VtIiwidGJTaXN0ZW1hTW9lZGFzIi4iQ29kaWdvIiBhcyAidGJTaXN0ZW1hTW9lZGFzX0NvZGlnbyIsc3VtKCJ0YkRvY3VtZW50b3NTdG9ja0xpbmhhcyIuIlByZWNvVG90YWwiKSBhcyAiUHJlY29Ub3RhbCIgZnJvbSAoKCgoKCgoKCgoKCgoKCgoImRibyIuInRiRG9jdW1lbnRvc1N0b2NrIiAidGJEb2N1bWVudG9zU3RvY2siDQogbGVmdCBqb2luICJkYm8iLiJ0YkNsaWVudGVzIiAidGJDbGllbnRlcyIgb24gKCJ0YkNsaWVudGVzIi4iSUQiID0gInRiRG9jdW1lbnRvc1N0b2NrIi4iSURFbnRpZGFkZSIpKQ0KIGxlZnQgam9pbiAiZGJvIi4idGJDbGllbnRlc01vcmFkYXMiICJ0YkNsaWVudGVzTW9yYWRhcyIgb24gKCJ0YkNsaWVudGVzTW9yYWRhcyIuIklEQ2xpZW50ZSIgPSAidGJEb2N1bWVudG9zU3RvY2siLiJJREVudGlkYWRlIiBhbmQgInRiQ2xpZW50ZXNNb3JhZGFzIi4iT3JkZW0iPTEpKQ0KIGxlZnQgam9pbiAiZGJvIi4idGJDb2RpZ29zUG9zdGFpcyIgInRiQ29kaWdvc1Bvc3RhaXMiIG9uICgidGJDb2RpZ29zUG9zdGFpcyIuIklEIiA9ICJ0YkNsaWVudGVzTW9yYWRhcyIuIklEQ29kaWdvUG9zdGFsIikpDQogbGVmdCBqb2luICJkYm8iLiJ0YkVzdGFkb3MiICJ0YkVzdGFkb3MiIG9uICgidGJFc3RhZG9zIi4iSUQiID0gInRiRG9jdW1lbnRvc1N0b2NrIi4iSURFc3RhZG8iKSkNCiBsZWZ0IGpvaW4gImRibyIuInRiVGlwb3NEb2N1bWVudG8iICJ0YlRpcG9zRG9jdW1lbnRvIiBvbiAoInRiVGlwb3NEb2N1bWVudG8iLiJJRCIgPSAidGJEb2N1bWVudG9zU3RvY2siLiJJRFRpcG9Eb2N1bWVudG8iKSkNCiBsZWZ0IGpvaW4gImRibyIuInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiICJ0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIiBvbiAoInRiVGlwb3NEb2N1bWVudG9TZXJpZXMiLiJJRCIgPSAidGJEb2N1bWVudG9zU3RvY2siLiJJRFRpcG9zRG9jdW1lbnRvU2VyaWVzIikpDQogbGVmdCBqb2luICJkYm8iLiJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50byIgInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIiBvbiAoInRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIi4iSUQiID0gInRiVGlwb3NEb2N1bWVudG8iLiJJRFNpc3RlbWFUaXBvc0RvY3VtZW50byIpKQ0KIGxlZnQgam9pbiAiZGJvIi4idGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiICJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIgb24gKCJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIuIklEIiA9ICJ0YlRpcG9zRG9jdW1lbnRvIi4iSURTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWwiKSkNCiBsZWZ0IGpvaW4gImRibyIuInRiQ29kaWdvc1Bvc3RhaXMiICJ0YkNvZGlnb3NQb3N0YWlzMSIgb24gKCJ0YkNvZGlnb3NQb3N0YWlzMSIuIklEIiA9ICJ0YkRvY3VtZW50b3NTdG9jayIuIklEQ29kaWdvUG9zdGFsRmlzY2FsIikpDQogbGVmdCBqb2luICJkYm8iLiJ0YkNvZGlnb3NQb3N0YWlzIiAidGJDb2RpZ29zUG9zdGFpczIiIG9uICgidGJDb2RpZ29zUG9zdGFpczIiLiJJRCIgPSAidGJEb2N1bWVudG9zU3RvY2siLiJJRENvZGlnb1Bvc3RhbENhcmdhIikpDQogbGVmdCBqb2luICJkYm8iLiJ0YkNvZGlnb3NQb3N0YWlzIiAidGJDb2RpZ29zUG9zdGFpczMiIG9uICgidGJDb2RpZ29zUG9zdGFpczMiLiJJRCIgPSAidGJEb2N1bWVudG9zU3RvY2siLiJJRENvZGlnb1Bvc3RhbERlc2NhcmdhIikpDQogbGVmdCBqb2luICJkYm8iLiJ0Yk1vZWRhcyIgInRiTW9lZGFzIiBvbiAoInRiTW9lZGFzIi4iSUQiID0gInRiRG9jdW1lbnRvc1N0b2NrIi4iSURNb2VkYSIpKQ0KIGxlZnQgam9pbiAiZGJvIi4idGJQYXJhbWV0cm9zRW1wcmVzYSIgInRiUGFyYW1ldHJvc0VtcHJlc2EiIG9uICgidGJQYXJhbWV0cm9zRW1wcmVzYSIuIklETW9lZGFEZWZlaXRvIiA9ICJ0Yk1vZWRhcyIuIklEIikpDQogbGVmdCBqb2luICJkYm8iLiJ0YlNpc3RlbWFNb2VkYXMiICJ0YlNpc3RlbWFNb2VkYXMiIG9uICgidGJTaXN0ZW1hTW9lZGFzIi4iSUQiID0gInRiTW9lZGFzIi4iSURTaXN0ZW1hTW9lZGEiKSkNCiBsZWZ0IGpvaW4gImRibyIuInRiRG9jdW1lbnRvc1N0b2NrTGluaGFzIiAidGJEb2N1bWVudG9zU3RvY2tMaW5oYXMiIG9uICgidGJEb2N1bWVudG9zU3RvY2tMaW5oYXMiLiJJRERvY3VtZW50b1N0b2NrIiA9ICJ0YkRvY3VtZW50b3NTdG9jayIuIklEIikpDQogbGVmdCBqb2luICJkYm8iLiJ0YkRvY3VtZW50b3NTdG9ja0xpbmhhc0RpbWVuc29lcyIgInRiRG9jdW1lbnRvc1N0b2NrTGluaGFzRGltZW5zb2VzIiBvbiAoInRiRG9jdW1lbnRvc1N0b2NrTGluaGFzRGltZW5zb2VzIi4iSUREb2N1bWVudG9TdG9ja0xpbmhhIiA9ICJ0YkRvY3VtZW50b3NTdG9ja0xpbmhhcyIuIklEIikpDQp3aGVyZSAoInRiRG9jdW1lbnRvc1N0b2NrIi4iSUQiID0gQElkRG9jKQ0KZ3JvdXAgYnkgInRiRG9jdW1lbnRvc1N0b2NrIi4iSUQiLCJ0YkRvY3VtZW50b3NTdG9jayIuIklEVGlwb0RvY3VtZW50byIsInRiRG9jdW1lbnRvc1N0b2NrIi4iTnVtZXJvRG9jdW1lbnRvIiwidGJEb2N1bWVudG9zU3RvY2siLiJEYXRhRG9jdW1lbnRvIiwidGJEb2N1bWVudG9zU3RvY2siLiJPYnNlcnZhY29lcyIsInRiRG9jdW1lbnRvc1N0b2NrIi4iSURNb2VkYSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iVGF4YUNvbnZlcnNhbyIsInRiRG9jdW1lbnRvc1N0b2NrIi4iVG90YWxNb2VkYURvY3VtZW50byIsInRiRG9jdW1lbnRvc1N0b2NrIi4iVG90YWxNb2VkYVJlZmVyZW5jaWEiLCJ0YkRvY3VtZW50b3NTdG9jayIuIkxvY2FsQ2FyZ2EiLCJ0YkRvY3VtZW50b3NTdG9jayIuIkRhdGFDYXJnYSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iSG9yYUNhcmdhIiwidGJEb2N1bWVudG9zU3RvY2siLiJNb3JhZGFDYXJnYSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iSURDb2RpZ29Qb3N0YWxDYXJnYSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iSURDb25jZWxob0NhcmdhIiwidGJEb2N1bWVudG9zU3RvY2siLiJJRERpc3RyaXRvQ2FyZ2EiLCJ0YkRvY3VtZW50b3NTdG9jayIuIkxvY2FsRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NTdG9jayIuIkRhdGFEZXNjYXJnYSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iSG9yYURlc2NhcmdhIiwidGJEb2N1bWVudG9zU3RvY2siLiJNb3JhZGFEZXNjYXJnYSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iSURDb2RpZ29Qb3N0YWxEZXNjYXJnYSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iSURDb25jZWxob0Rlc2NhcmdhIiwidGJEb2N1bWVudG9zU3RvY2siLiJJRERpc3RyaXRvRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NTdG9jayIuIk5vbWVEZXN0aW5hdGFyaW8iLCJ0YkRvY3VtZW50b3NTdG9jayIuIk1vcmFkYURlc3RpbmF0YXJpbyIsInRiRG9jdW1lbnRvc1N0b2NrIi4iSURDb2RpZ29Qb3N0YWxEZXN0aW5hdGFyaW8iLCJ0YkRvY3VtZW50b3NTdG9jayIuIklEQ29uY2VsaG9EZXN0aW5hdGFyaW8iLCJ0YkRvY3VtZW50b3NTdG9jayIuIklERGlzdHJpdG9EZXN0aW5hdGFyaW8iLCJ0YkRvY3VtZW50b3NTdG9jayIuIlNlcmllRG9jTWFudWFsIiwidGJEb2N1bWVudG9zU3RvY2siLiJOdW1lcm9Eb2NNYW51YWwiLCJ0YkRvY3VtZW50b3NTdG9jayIuIk51bWVyb0xpbmhhcyIsInRiRG9jdW1lbnRvc1N0b2NrIi4iUG9zdG8iLCJ0YkRvY3VtZW50b3NTdG9jayIuIklERXN0YWRvIiwidGJEb2N1bWVudG9zU3RvY2siLiJVdGlsaXphZG9yRXN0YWRvIiwidGJEb2N1bWVudG9zU3RvY2siLiJEYXRhSG9yYUVzdGFkbyIsInRiRG9jdW1lbnRvc1N0b2NrIi4iQXNzaW5hdHVyYSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iVmVyc2FvQ2hhdmVQcml2YWRhIiwidGJEb2N1bWVudG9zU3RvY2siLiJOb21lRmlzY2FsIiwidGJEb2N1bWVudG9zU3RvY2siLiJNb3JhZGFGaXNjYWwiLCJ0YkRvY3VtZW50b3NTdG9jayIuIklEQ29kaWdvUG9zdGFsRmlzY2FsIiwidGJEb2N1bWVudG9zU3RvY2siLiJJRENvbmNlbGhvRmlzY2FsIiwidGJEb2N1bWVudG9zU3RvY2siLiJJRERpc3RyaXRvRmlzY2FsIiwidGJEb2N1bWVudG9zU3RvY2siLiJDb250cmlidWludGVGaXNjYWwiLCJ0YkRvY3VtZW50b3NTdG9jayIuIlNpZ2xhUGFpc0Zpc2NhbCIsInRiRG9jdW1lbnRvc1N0b2NrIi4iSURMb2phIiwidGJEb2N1bWVudG9zU3RvY2siLiJJbXByZXNzbyIsInRiRG9jdW1lbnRvc1N0b2NrIi4iVmFsb3JJbXBvc3RvIiwidGJEb2N1bWVudG9zU3RvY2siLiJQZXJjZW50YWdlbURlc2NvbnRvIiwidGJEb2N1bWVudG9zU3RvY2siLiJWYWxvckRlc2NvbnRvIiwidGJEb2N1bWVudG9zU3RvY2siLiJWYWxvclBvcnRlcyIsInRiRG9jdW1lbnRvc1N0b2NrIi4iSURUYXhhSXZhUG9ydGVzIiwidGJEb2N1bWVudG9zU3RvY2siLiJUYXhhSXZhUG9ydGVzIiwidGJEb2N1bWVudG9zU3RvY2siLiJNb3Rpdm9Jc2VuY2FvSXZhIiwidGJEb2N1bWVudG9zU3RvY2siLiJNb3Rpdm9Jc2VuY2FvUG9ydGVzIiwidGJEb2N1bWVudG9zU3RvY2siLiJJREVzcGFjb0Zpc2NhbFBvcnRlcyIsInRiRG9jdW1lbnRvc1N0b2NrIi4iRXNwYWNvRmlzY2FsUG9ydGVzIiwidGJEb2N1bWVudG9zU3RvY2siLiJJRFJlZ2ltZUl2YVBvcnRlcyIsInRiRG9jdW1lbnRvc1N0b2NrIi4iUmVnaW1lSXZhUG9ydGVzIiwidGJEb2N1bWVudG9zU3RvY2siLiJDdXN0b3NBZGljaW9uYWlzIiwidGJEb2N1bWVudG9zU3RvY2siLiJTaXN0ZW1hIiwidGJEb2N1bWVudG9zU3RvY2siLiJBdGl2byIsInRiRG9jdW1lbnRvc1N0b2NrIi4iRGF0YUNyaWFjYW8iLCJ0YkRvY3VtZW50b3NTdG9jayIuIlV0aWxpemFkb3JDcmlhY2FvIiwidGJEb2N1bWVudG9zU3RvY2siLiJEYXRhQWx0ZXJhY2FvIiwidGJEb2N1bWVudG9zU3RvY2siLiJVdGlsaXphZG9yQWx0ZXJhY2FvIiwidGJEb2N1bWVudG9zU3RvY2siLiJGM01NYXJjYWRvciIsInRiRG9jdW1lbnRvc1N0b2NrIi4iSURGb3JtYUV4cGVkaWNhbyIsInRiRG9jdW1lbnRvc1N0b2NrIi4iSURUaXBvc0RvY3VtZW50b1NlcmllcyIsInRiRG9jdW1lbnRvc1N0b2NrIi4iTnVtZXJvSW50ZXJubyIsInRiRG9jdW1lbnRvc1N0b2NrIi4iSURFbnRpZGFkZSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iSURUaXBvRW50aWRhZGUiLCJ0YkRvY3VtZW50b3NTdG9jayIuIklEQ29uZGljYW9QYWdhbWVudG8iLCJ0YkRvY3VtZW50b3NTdG9jayIuIklETG9jYWxPcGVyYWNhbyIsInRiRG9jdW1lbnRvc1N0b2NrIi4iQ29kaWdvQVQiLCJ0YkRvY3VtZW50b3NTdG9jayIuIklEUGFpc0NhcmdhIiwidGJEb2N1bWVudG9zU3RvY2siLiJJRFBhaXNEZXNjYXJnYSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iTWF0cmljdWxhIiwidGJEb2N1bWVudG9zU3RvY2siLiJJRFBhaXNGaXNjYWwiLCJ0YkRvY3VtZW50b3NTdG9jayIuIkNvZGlnb1Bvc3RhbEZpc2NhbCIsInRiRG9jdW1lbnRvc1N0b2NrIi4iRGVzY3JpY2FvQ29kaWdvUG9zdGFsRmlzY2FsIiwidGJEb2N1bWVudG9zU3RvY2siLiJEZXNjcmljYW9Db25jZWxob0Zpc2NhbCIsInRiRG9jdW1lbnRvc1N0b2NrIi4iRGVzY3JpY2FvRGlzdHJpdG9GaXNjYWwiLCJ0YkRvY3VtZW50b3NTdG9jayIuIklERXNwYWNvRmlzY2FsIiwidGJEb2N1bWVudG9zU3RvY2siLiJJRFJlZ2ltZUl2YSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iQ29kaWdvQVRJbnRlcm5vIiwidGJEb2N1bWVudG9zU3RvY2siLiJUaXBvRmlzY2FsIiwidGJEb2N1bWVudG9zU3RvY2siLiJEb2N1bWVudG8iLCJ0YkRvY3VtZW50b3NTdG9jayIuIkNvZGlnb1RpcG9Fc3RhZG8iLCJ0YkRvY3VtZW50b3NTdG9jayIuIkNvZGlnb0RvY09yaWdlbSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iRGlzdHJpdG9DYXJnYSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iQ29uY2VsaG9DYXJnYSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iQ29kaWdvUG9zdGFsQ2FyZ2EiLCJ0YkRvY3VtZW50b3NTdG9jayIuIlNpZ2xhUGFpc0NhcmdhIiwidGJEb2N1bWVudG9zU3RvY2siLiJEaXN0cml0b0Rlc2NhcmdhIiwidGJEb2N1bWVudG9zU3RvY2siLiJDb25jZWxob0Rlc2NhcmdhIiwidGJEb2N1bWVudG9zU3RvY2siLiJDb2RpZ29Qb3N0YWxEZXNjYXJnYSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iU2lnbGFQYWlzRGVzY2FyZ2EiLCJ0YkRvY3VtZW50b3NTdG9jayIuIkNvZGlnb0VudGlkYWRlIiwidGJEb2N1bWVudG9zU3RvY2siLiJDb2RpZ29Nb2VkYSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iTWVuc2FnZW1Eb2NBVCIsInRiRG9jdW1lbnRvc1N0b2NrIi4iSURTaXNUaXBvc0RvY1BVIiwidGJEb2N1bWVudG9zU3RvY2siLiJDb2RpZ29TaXNUaXBvc0RvY1BVIiwidGJEb2N1bWVudG9zU3RvY2siLiJEb2NNYW51YWwiLCJ0YkRvY3VtZW50b3NTdG9jayIuIkRvY1JlcG9zaWNhbyIsInRiRG9jdW1lbnRvc1N0b2NrIi4iRGF0YUFzc2luYXR1cmEiLCJ0YkRvY3VtZW50b3NTdG9jayIuIkRhdGFDb250cm9sb0ludGVybm8iLCJ0YkRvY3VtZW50b3NTdG9jayIuIlN1YlRvdGFsIiwidGJEb2N1bWVudG9zU3RvY2siLiJWb3Nzb051bWVyb0RvY3VtZW50byIsInRiRG9jdW1lbnRvc1N0b2NrIi4iRGF0YVZlbmNpbWVudG8iLCJ0YkRvY3VtZW50b3NTdG9jayIuIlNlZ3VuZGFWaWEiLCJ0YkRvY3VtZW50b3NTdG9jayIuIkRhdGFVbHRpbWFJbXByZXNzYW8iLCJ0YkRvY3VtZW50b3NTdG9jayIuIk51bWVyb0ltcHJlc3NvZXMiLCJ0YkRvY3VtZW50b3NTdG9jayIuIklETG9qYVVsdGltYUltcHJlc3NhbyIsInRiRG9jdW1lbnRvc1N0b2NrIi4iU2F0aXNmZWl0byIsInRiRG9jdW1lbnRvc1N0b2NrIi4iSUREb2NSZXNlcnZhIiwidGJEb2N1bWVudG9zU3RvY2siLiJEYXRhRW50cmVnYSIsInRiRG9jdW1lbnRvc1N0b2NrIi4iUmF6YW9Fc3RhZG8iLCJ0YkNsaWVudGVzIi4iQ29kaWdvIiwidGJDbGllbnRlcyIuIk5vbWUiLCJ0YkNsaWVudGVzIi4iTkNvbnRyaWJ1aW50ZSIsInRiQ2xpZW50ZXNNb3JhZGFzIi4iTW9yYWRhIiwidGJDb2RpZ29zUG9zdGFpcyIuIkNvZGlnbyIsInRiQ29kaWdvc1Bvc3RhaXMiLiJEZXNjcmljYW8iLCJ0YkVzdGFkb3MiLiJDb2RpZ28iLCJ0YkVzdGFkb3MiLiJEZXNjcmljYW8iLCJ0YlRpcG9zRG9jdW1lbnRvIi4iQ29kaWdvIiwidGJUaXBvc0RvY3VtZW50byIuIkRlc2NyaWNhbyIsInRiVGlwb3NEb2N1bWVudG8iLiJBY29tcGFuaGFCZW5zQ2lyY3VsYWNhbyIsInRiVGlwb3NEb2N1bWVudG8iLiJEb2NOYW9WYWxvcml6YWRvIiwidGJUaXBvc0RvY3VtZW50b1NlcmllcyIuIkNvZGlnb1NlcmllIiwidGJUaXBvc0RvY3VtZW50b1NlcmllcyIuIkRlc2NyaWNhb1NlcmllIiwidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8iLiJUaXBvIiwidGJTaXN0ZW1hVGlwb3NEb2N1bWVudG8iLiJEZXNjcmljYW8iLCJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIuIlRpcG8iLCJ0YlNpc3RlbWFUaXBvc0RvY3VtZW50b0Zpc2NhbCIuIkRlc2NyaWNhbyIsInRiQ29kaWdvc1Bvc3RhaXMxIi4iQ29kaWdvIiwidGJDb2RpZ29zUG9zdGFpczEiLiJEZXNjcmljYW8iLCJ0YkNvZGlnb3NQb3N0YWlzMiIuIkNvZGlnbyIsInRiQ29kaWdvc1Bvc3RhaXMyIi4iRGVzY3JpY2FvIiwidGJDb2RpZ29zUG9zdGFpczMiLiJDb2RpZ28iLCJ0YkNvZGlnb3NQb3N0YWlzMyIuIkRlc2NyaWNhbyIsInRiTW9lZGFzIi4iQ29kaWdvIiwidGJNb2VkYXMiLiJEZXNjcmljYW8iLCJ0Yk1vZWRhcyIuIkNhc2FzRGVjaW1haXNUb3RhaXMiLCJ0Yk1vZWRhcyIuIlNpbWJvbG8iLCJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iQ2FzYXNEZWNpbWFpc1BlcmNlbnRhZ2VtIiwidGJTaXN0ZW1hTW9lZGFzIi4iQ29kaWdvIjwvU3FsPjwvUXVlcnk+PFF1ZXJ5IFR5cGU9IlNlbGVjdFF1ZXJ5IiBOYW1lPSJ0YlBhcmFtZXRyb3NFbXByZXNhIj48VGFibGVzPjxUYWJsZSBOYW1lPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiAvPjwvVGFibGVzPjxDb2x1bW5zPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IklEIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IklETW9lZGFEZWZlaXRvIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9Ik1vcmFkYSIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJGb3RvIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkZvdG9DYW1pbmhvIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkRlc2lnbmFjYW9Db21lcmNpYWwiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iQ29kaWdvUG9zdGFsIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkxvY2FsaWRhZGUiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iQ29uY2VsaG8iIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iRGlzdHJpdG8iIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iSURQYWlzIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IlRlbGVmb25lIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkZheCIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJFbWFpbCIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJXZWJTaXRlIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9Ik5JRiIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJDb25zZXJ2YXRvcmlhUmVnaXN0b0NvbWVyY2lhbCIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJOdW1lcm9SZWdpc3RvQ29tZXJjaWFsIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkNhcGl0YWxTb2NpYWwiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iSURJZGlvbWFCYXNlIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IlNpc3RlbWEiIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iQXRpdm8iIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iRGF0YUNyaWFjYW8iIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iVXRpbGl6YWRvckNyaWFjYW8iIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iRGF0YUFsdGVyYWNhbyIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJVdGlsaXphZG9yQWx0ZXJhY2FvIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IkYzTU1hcmNhZG9yIiAvPjxDb2x1bW4gVGFibGU9InRiUGFyYW1ldHJvc0VtcHJlc2EiIE5hbWU9IklERW1wcmVzYSIgLz48Q29sdW1uIFRhYmxlPSJ0YlBhcmFtZXRyb3NFbXByZXNhIiBOYW1lPSJDYXNhc0RlY2ltYWlzUGVyY2VudGFnZW0iIC8+PENvbHVtbiBUYWJsZT0idGJQYXJhbWV0cm9zRW1wcmVzYSIgTmFtZT0iSURQYWlzZXNEZXNjIiAvPjwvQ29sdW1ucz48L1F1ZXJ5PjxSZXN1bHRTY2hlbWE+PERhdGFTZXQgTmFtZT0iU3FsRGF0YVNvdXJjZSI+PFZpZXcgTmFtZT0idGJEb2N1bWVudG9zU3RvY2tfQ2FiIj48RmllbGQgTmFtZT0iSUQiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9Eb2N1bWVudG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJOdW1lcm9Eb2N1bWVudG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJEYXRhRG9jdW1lbnRvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iT2JzZXJ2YWNvZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURNb2VkYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlRheGFDb252ZXJzYW8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVG90YWxNb2VkYURvY3VtZW50byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJUb3RhbE1vZWRhUmVmZXJlbmNpYSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJMb2NhbENhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRhdGFDYXJnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkhvcmFDYXJnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYUNhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEQ29kaWdvUG9zdGFsQ2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmNlbGhvQ2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERpc3RyaXRvQ2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJMb2NhbERlc2NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRhdGFEZXNjYXJnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkhvcmFEZXNjYXJnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYURlc2NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEQ29kaWdvUG9zdGFsRGVzY2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmNlbGhvRGVzY2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERpc3RyaXRvRGVzY2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJOb21lRGVzdGluYXRhcmlvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYURlc3RpbmF0YXJpbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRENvZGlnb1Bvc3RhbERlc3RpbmF0YXJpbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQ29uY2VsaG9EZXN0aW5hdGFyaW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERpc3RyaXRvRGVzdGluYXRhcmlvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iU2VyaWVEb2NNYW51YWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTnVtZXJvRG9jTWFudWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik51bWVyb0xpbmhhcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlBvc3RvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklERXN0YWRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckVzdGFkbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhSG9yYUVzdGFkbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IkFzc2luYXR1cmEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVmVyc2FvQ2hhdmVQcml2YWRhIiBUeXBlPSJJbnQzMiIgLz48RmllbGQgTmFtZT0iTm9tZUZpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJNb3JhZGFGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURDb2RpZ29Qb3N0YWxGaXNjYWwiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmNlbGhvRmlzY2FsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSUREaXN0cml0b0Zpc2NhbCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNvbnRyaWJ1aW50ZUZpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTaWdsYVBhaXNGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURMb2phIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSW1wcmVzc28iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IlZhbG9ySW1wb3N0byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJQZXJjZW50YWdlbURlc2NvbnRvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlZhbG9yRGVzY29udG8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVmFsb3JQb3J0ZXMiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iSURUYXhhSXZhUG9ydGVzIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iVGF4YUl2YVBvcnRlcyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJNb3Rpdm9Jc2VuY2FvSXZhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik1vdGl2b0lzZW5jYW9Qb3J0ZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURFc3BhY29GaXNjYWxQb3J0ZXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJFc3BhY29GaXNjYWxQb3J0ZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURSZWdpbWVJdmFQb3J0ZXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJSZWdpbWVJdmFQb3J0ZXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ3VzdG9zQWRpY2lvbmFpcyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJTaXN0ZW1hIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJBdGl2byIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iRGF0YUNyaWFjYW8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJVdGlsaXphZG9yQ3JpYWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhQWx0ZXJhY2FvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iVXRpbGl6YWRvckFsdGVyYWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGM01NYXJjYWRvciIgVHlwZT0iQnl0ZUFycmF5IiAvPjxGaWVsZCBOYW1lPSJJREZvcm1hRXhwZWRpY2FvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURUaXBvc0RvY3VtZW50b1NlcmllcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik51bWVyb0ludGVybm8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJREVudGlkYWRlIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURUaXBvRW50aWRhZGUiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRENvbmRpY2FvUGFnYW1lbnRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURMb2NhbE9wZXJhY2FvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ29kaWdvQVQiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURQYWlzQ2FyZ2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFBhaXNEZXNjYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik1hdHJpY3VsYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFBhaXNGaXNjYWwiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Qb3N0YWxGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvQ29kaWdvUG9zdGFsRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb0NvbmNlbGhvRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb0Rpc3RyaXRvRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklERXNwYWNvRmlzY2FsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURSZWdpbWVJdmEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29BVEludGVybm8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVGlwb0Zpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEb2N1bWVudG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvVGlwb0VzdGFkbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Eb2NPcmlnZW0iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGlzdHJpdG9DYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb25jZWxob0NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1Bvc3RhbENhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlNpZ2xhUGFpc0NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRpc3RyaXRvRGVzY2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29uY2VsaG9EZXNjYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Qb3N0YWxEZXNjYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTaWdsYVBhaXNEZXNjYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29FbnRpZGFkZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Nb2VkYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJNZW5zYWdlbURvY0FUIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEU2lzVGlwb3NEb2NQVSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1Npc1RpcG9zRG9jUFUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRG9jTWFudWFsIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJEb2NSZXBvc2ljYW8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkRhdGFBc3NpbmF0dXJhIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iRGF0YUNvbnRyb2xvSW50ZXJubyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IlN1YlRvdGFsIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlZvc3NvTnVtZXJvRG9jdW1lbnRvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRhdGFWZW5jaW1lbnRvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iU2VndW5kYVZpYSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iRGF0YVVsdGltYUltcHJlc3NhbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9Ik51bWVyb0ltcHJlc3NvZXMiIFR5cGU9IkludDMyIiAvPjxGaWVsZCBOYW1lPSJJRExvamFVbHRpbWFJbXByZXNzYW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJTYXRpc2ZlaXRvIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJJRERvY1Jlc2VydmEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJEYXRhRW50cmVnYSIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IlJhemFvRXN0YWRvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ2xpZW50ZXNfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ2xpZW50ZXNfTm9tZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNsaWVudGVzX05Db250cmlidWludGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDbGllbnRlc01vcmFkYXNfTW9yYWRhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ29kaWdvc1Bvc3RhaXNDbGllbnRlX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzQ2xpZW50ZV9EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJFc3RhZG9zX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkVzdGFkb3NfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiVGlwb3NEb2N1bWVudG9fQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiVGlwb3NEb2N1bWVudG9fRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiVGlwb3NEb2N1bWVudG9fRG9jTmFvVmFsb3JpemFkbyIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0idGJUaXBvc0RvY3VtZW50b19BY29tcGFuaGFCZW5zQ2lyY3VsYWNhbyIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iQ29kaWdvU2VyaWUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvU2VyaWUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWxfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvX1RpcG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9fRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlRpcG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0NhcmdhX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzQ2FyZ2FfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ29kaWdvc1Bvc3RhaXNEZXNjYXJnYV9Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0Rlc2NhcmdhX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0Yk1vZWRhc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfU2ltYm9sbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0Yk1vZWRhc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfQ2FzYXNEZWNpbWFpc1RvdGFpcyIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0idGJQYXJhbWVudHJvc0VtcHJlc2FfQ2FzYXNEZWNpbWFpc1BlcmNlbnRhZ2VtIiBUeXBlPSJCeXRlIiAvPjxGaWVsZCBOYW1lPSJ0YlNpc3RlbWFNb2VkYXNfQ29kaWdvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlByZWNvVG90YWwiIFR5cGU9IkRvdWJsZSIgLz48L1ZpZXc+PFZpZXcgTmFtZT0idGJEb2N1bWVudG9zU3RvY2siPjxGaWVsZCBOYW1lPSJJRCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEVGlwb0RvY3VtZW50byIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik51bWVyb0RvY3VtZW50byIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkRhdGFEb2N1bWVudG8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJPYnNlcnZhY29lcyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRE1vZWRhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iVGF4YUNvbnZlcnNhbyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJUb3RhbE1vZWRhRG9jdW1lbnRvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlRvdGFsTW9lZGFSZWZlcmVuY2lhIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IkxvY2FsQ2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YUNhcmdhIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iSG9yYUNhcmdhIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iTW9yYWRhQ2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURDb2RpZ29Qb3N0YWxDYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQ29uY2VsaG9DYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklERGlzdHJpdG9DYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkxvY2FsRGVzY2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGF0YURlc2NhcmdhIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iSG9yYURlc2NhcmdhIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iTW9yYWRhRGVzY2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURDb2RpZ29Qb3N0YWxEZXNjYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQ29uY2VsaG9EZXNjYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklERGlzdHJpdG9EZXNjYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik5vbWVEZXN0aW5hdGFyaW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTW9yYWRhRGVzdGluYXRhcmlvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEQ29kaWdvUG9zdGFsRGVzdGluYXRhcmlvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURDb25jZWxob0Rlc3RpbmF0YXJpbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklERGlzdHJpdG9EZXN0aW5hdGFyaW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJTZXJpZURvY01hbnVhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOdW1lcm9Eb2NNYW51YWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTnVtZXJvTGluaGFzIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iUG9zdG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURFc3RhZG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJVdGlsaXphZG9yRXN0YWRvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRhdGFIb3JhRXN0YWRvIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iQXNzaW5hdHVyYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJWZXJzYW9DaGF2ZVByaXZhZGEiIFR5cGU9IkludDMyIiAvPjxGaWVsZCBOYW1lPSJOb21lRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik1vcmFkYUZpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRENvZGlnb1Bvc3RhbEZpc2NhbCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQ29uY2VsaG9GaXNjYWwiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRERpc3RyaXRvRmlzY2FsIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ29udHJpYnVpbnRlRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlNpZ2xhUGFpc0Zpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRExvamEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJbXByZXNzbyIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iVmFsb3JJbXBvc3RvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlBlcmNlbnRhZ2VtRGVzY29udG8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVmFsb3JEZXNjb250byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJWYWxvclBvcnRlcyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJJRFRheGFJdmFQb3J0ZXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJUYXhhSXZhUG9ydGVzIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9Ik1vdGl2b0lzZW5jYW9JdmEiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTW90aXZvSXNlbmNhb1BvcnRlcyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJREVzcGFjb0Zpc2NhbFBvcnRlcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkVzcGFjb0Zpc2NhbFBvcnRlcyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFJlZ2ltZUl2YVBvcnRlcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlJlZ2ltZUl2YVBvcnRlcyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDdXN0b3NBZGljaW9uYWlzIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlNpc3RlbWEiIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkF0aXZvIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJEYXRhQ3JpYWNhbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IlV0aWxpemFkb3JDcmlhY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRhdGFBbHRlcmFjYW8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJVdGlsaXphZG9yQWx0ZXJhY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkYzTU1hcmNhZG9yIiBUeXBlPSJCeXRlQXJyYXkiIC8+PEZpZWxkIE5hbWU9IklERm9ybWFFeHBlZGljYW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9zRG9jdW1lbnRvU2VyaWVzIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTnVtZXJvSW50ZXJubyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklERW50aWRhZGUiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFRpcG9FbnRpZGFkZSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQ29uZGljYW9QYWdhbWVudG8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRExvY2FsT3BlcmFjYW8iIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29BVCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFBhaXNDYXJnYSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEUGFpc0Rlc2NhcmdhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTWF0cmljdWxhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEUGFpc0Zpc2NhbCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1Bvc3RhbEZpc2NhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW9Db2RpZ29Qb3N0YWxGaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvQ29uY2VsaG9GaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvRGlzdHJpdG9GaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURFc3BhY29GaXNjYWwiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJRFJlZ2ltZUl2YSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkNvZGlnb0FUSW50ZXJubyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJUaXBvRmlzY2FsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRvY3VtZW50byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29UaXBvRXN0YWRvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb0RvY09yaWdlbSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEaXN0cml0b0NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvbmNlbGhvQ2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29kaWdvUG9zdGFsQ2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iU2lnbGFQYWlzQ2FyZ2EiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGlzdHJpdG9EZXNjYXJnYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb25jZWxob0Rlc2NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1Bvc3RhbERlc2NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlNpZ2xhUGFpc0Rlc2NhcmdhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb0VudGlkYWRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb01vZWRhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9Ik1lbnNhZ2VtRG9jQVQiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURTaXNUaXBvc0RvY1BVIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iQ29kaWdvU2lzVGlwb3NEb2NQVSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEb2NNYW51YWwiIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkRvY1JlcG9zaWNhbyIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iRGF0YUFzc2luYXR1cmEiIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJEYXRhQ29udHJvbG9JbnRlcm5vIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iU2VndW5kYVZpYSIgVHlwZT0iQm9vbGVhbiIgLz48RmllbGQgTmFtZT0iRGF0YURvY3VtZW50b18xIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0idGJEb2N1bWVudG9zU3RvY2tMaW5oYXNfSUQiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJPcmRlbSIgVHlwZT0iSW50MzIiIC8+PEZpZWxkIE5hbWU9IklERG9jdW1lbnRvU3RvY2siIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJJREFydGlnbyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFVuaWRhZGUiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJOdW1DYXNhc0RlY1VuaWRhZGUiIFR5cGU9IkludDE2IiAvPjxGaWVsZCBOYW1lPSJRdWFudGlkYWRlIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlByZWNvVW5pdGFyaW8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUHJlY29Vbml0YXJpb0VmZXRpdm8iIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iUHJlY29Ub3RhbCIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJ0YkRvY3VtZW50b3NTdG9ja0xpbmhhc19PYnNlcnZhY29lcyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRExvdGUiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Mb3RlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1VuaWRhZGUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvTG90ZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEYXRhRmFicmljb0xvdGUiIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJEYXRhVmFsaWRhZGVMb3RlIiBUeXBlPSJEYXRlVGltZSIgLz48RmllbGQgTmFtZT0iSURBcnRpZ29OdW1TZXJpZSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkFydGlnb051bVNlcmllIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEQXJtYXplbSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQXJtYXplbUxvY2FsaXphY2FvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iSURBcm1hemVtRGVzdGlubyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklEQXJtYXplbUxvY2FsaXphY2FvRGVzdGlubyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9Ik51bUxpbmhhc0RpbWVuc29lcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IkRlc2NvbnRvMSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJEZXNjb250bzIiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iSURUYXhhSXZhIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iVGF4YUl2YSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJ0YkRvY3VtZW50b3NTdG9ja0xpbmhhc19Nb3Rpdm9Jc2VuY2FvSXZhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklERXNwYWNvRmlzY2FsXzEiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJFc3BhY29GaXNjYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iSURSZWdpbWVJdmFfMSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlJlZ2ltZUl2YSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTaWdsYVBhaXMiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iT3JkZW1fMSIgVHlwZT0iSW50MzIiIC8+PEZpZWxkIE5hbWU9InRiRG9jdW1lbnRvc1N0b2NrTGluaGFzX1Npc3RlbWEiIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9InRiRG9jdW1lbnRvc1N0b2NrTGluaGFzX0F0aXZvIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJ0YkRvY3VtZW50b3NTdG9ja0xpbmhhc19EYXRhQ3JpYWNhbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9InRiRG9jdW1lbnRvc1N0b2NrTGluaGFzX1V0aWxpemFkb3JDcmlhY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRG9jdW1lbnRvc1N0b2NrTGluaGFzX0RhdGFBbHRlcmFjYW8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJ0YkRvY3VtZW50b3NTdG9ja0xpbmhhc19VdGlsaXphZG9yQWx0ZXJhY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRG9jdW1lbnRvc1N0b2NrTGluaGFzX0YzTU1hcmNhZG9yIiBUeXBlPSJCeXRlQXJyYXkiIC8+PEZpZWxkIE5hbWU9IlZhbG9ySW5jaWRlbmNpYSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJWYWxvcklWQSIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJ0YkNsaWVudGVzX05vbWUiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDbGllbnRlc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDbGllbnRlc19OQ29udHJpYnVpbnRlIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ2xpZW50ZXNNb3JhZGFzX01vcmFkYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzQ2xpZW50ZV9Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0NsaWVudGVfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiRXN0YWRvc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJFc3RhZG9zX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlRpcG9zRG9jdW1lbnRvX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlRpcG9zRG9jdW1lbnRvX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YlRpcG9zRG9jdW1lbnRvX0RvY05hb1ZhbG9yaXphZG8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9InRiVGlwb3NEb2N1bWVudG9fQWNvbXBhbmhhQmVuc0NpcmN1bGFjYW8iIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkNvZGlnb1NlcmllIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRlc2NyaWNhb1NlcmllIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQXJ0aWdvc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzY3JpY2FvQWJyZXZpYWRhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQXJ0aWdvc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9GaXNjYWxfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvX1RpcG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hVGlwb3NEb2N1bWVudG9fRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlRpcG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0NhcmdhX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkNvZGlnb3NQb3N0YWlzQ2FyZ2FfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQ29kaWdvc1Bvc3RhaXNEZXNjYXJnYV9Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJDb2RpZ29zUG9zdGFpc0Rlc2NhcmdhX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0Yk1vZWRhc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfRGVzY3JpY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiTW9lZGFzX1NpbWJvbG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJBcm1hemVuc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJBcm1hemVuc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJBcm1hemVuc0xvY2FsaXphY29lc19EZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJBcm1hemVuc0xvY2FsaXphY29lc19Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJBcm1hemVuczFfRGVzY3JpY2FvRGVzdGlubyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkFybWF6ZW5zMV9Db2RpZ29EZXN0aW5vIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9InRiQXJtYXplbnNMb2NhbGl6YWNvZXMxX0Rlc2NyaWNhbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJ0YkFybWF6ZW5zTG9jYWxpemFjb2VzMV9Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJNb2VkYXNfQ2FzYXNEZWNpbWFpc1RvdGFpcyIgVHlwZT0iQnl0ZSIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hQ29kaWdvc0lWQS5Db2RpZ28iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0idGJTaXN0ZW1hTW9lZGFzX0NvZGlnbyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJTdWJUb3RhbCIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJ0YlBhcmFtZW50cm9zRW1wcmVzYV9DYXNhc0RlY2ltYWlzUGVyY2VudGFnZW0iIFR5cGU9IkJ5dGUiIC8+PC9WaWV3PjxWaWV3IE5hbWU9InRiUGFyYW1ldHJvc0VtcHJlc2EiPjxGaWVsZCBOYW1lPSJJRCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklETW9lZGFEZWZlaXRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTW9yYWRhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkZvdG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRm90b0NhbWluaG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzaWduYWNhb0NvbWVyY2lhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Qb3N0YWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTG9jYWxpZGFkZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb25jZWxobyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEaXN0cml0byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJRFBhaXMiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJUZWxlZm9uZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJGYXgiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRW1haWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iV2ViU2l0ZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOSUYiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iQ29uc2VydmF0b3JpYVJlZ2lzdG9Db21lcmNpYWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTnVtZXJvUmVnaXN0b0NvbWVyY2lhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDYXBpdGFsU29jaWFsIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklESWRpb21hQmFzZSIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlNpc3RlbWEiIFR5cGU9IkJvb2xlYW4iIC8+PEZpZWxkIE5hbWU9IkF0aXZvIiBUeXBlPSJCb29sZWFuIiAvPjxGaWVsZCBOYW1lPSJEYXRhQ3JpYWNhbyIgVHlwZT0iRGF0ZVRpbWUiIC8+PEZpZWxkIE5hbWU9IlV0aWxpemFkb3JDcmlhY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkRhdGFBbHRlcmFjYW8iIFR5cGU9IkRhdGVUaW1lIiAvPjxGaWVsZCBOYW1lPSJVdGlsaXphZG9yQWx0ZXJhY2FvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkYzTU1hcmNhZG9yIiBUeXBlPSJVbmtub3duIiAvPjxGaWVsZCBOYW1lPSJJREVtcHJlc2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJDYXNhc0RlY2ltYWlzUGVyY2VudGFnZW0iIFR5cGU9IkJ5dGUiIC8+PEZpZWxkIE5hbWU9IklEUGFpc2VzRGVzYyIgVHlwZT0iSW50NjQiIC8+PC9WaWV3PjwvRGF0YVNldD48L1Jlc3VsdFNjaGVtYT48Q29ubmVjdGlvbk9wdGlvbnMgQ2xvc2VDb25uZWN0aW9uPSJ0cnVlIiBEYkNvbW1hbmRUaW1lb3V0PSIxODAwIiAvPjwvU3FsRGF0YVNvdXJjZT4=" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>
''
--Mapa de documentos de stocks
--tratar subreports
Set @ptrval.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item3/SubBands/Item1/Controls/Item1/@ReportSourceUrl)[.=10000][1] with sql:variable("@intIDMapaSubCab")'')
Set @ptrval.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item5/Bands/Item1/SubBands/Item1/Controls/Item1/@ReportSourceUrl)[.=30000][1] with sql:variable("@intIDMapaD")'')
Set @ptrval.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item6/Bands/Item1/SubBands/Item1/Controls/Item1/@ReportSourceUrl)[.=30000][1] with sql:variable("@intIDMapaD")'')
Set @ptrval.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item7/Bands/Item1/SubBands/Item1/Controls/Item1/@ReportSourceUrl)[.=40000][1] with sql:variable("@intIDMapaDNV")'')
Set @ptrval.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item8/Bands/Item1/SubBands/Item1/Controls/Item1/@ReportSourceUrl)[.=40000][1] with sql:variable("@intIDMapaDNV")'')
Set @ptrval.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item9/Bands/Item1/SubBands/Item1/Controls/Item1/@ReportSourceUrl)[.=60000][1] with sql:variable("@intIDMapaDVA")'')
Set @ptrval.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item10/Bands/Item1/SubBands/Item1/Controls/Item1/@ReportSourceUrl)[.=50000][1] with sql:variable("@intIDMapaDNVA")'')
Set @ptrval.modify(''replace value of (/XtraReportsLayoutSerializer/Bands/Item11/SubBands/Item1/Controls/Item13/@ReportSourceUrl)[.=20000][1] with sql:variable("@intIDMapaMI")'')
UPDATE tbMapasVistas SET MapaXML= @ptrval, NomeMapa = ''Documentos Stock'' WHERE Entidade = ''DocumentosStock'' and sistema = 1 and subreport = 0
')

--mapa de vendas
EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwMapaRankingVendas'')) drop view vwMapaRankingVendas')

EXEC('create view [dbo].[vwMapaRankingVendas] as
select 
tbClientes.Codigo as CodigoCliente,
tbClientes.Nome as NomeFiscal,
tbLojas.Codigo as CodigoLoja,
tbLojas.Descricao as DescricaoLoja,
tbMarcas.Codigo as CodigoMarca,
tbMarcas.Descricao as DescricaoMarca,
tbTiposArtigos.Codigo as CodigoTipoArtigo,
tbTiposArtigos.Descricao as DescricaoTipoArtigo,
tbArtigos.Codigo as CodigoArtigo,
tbArtigos.Descricao as DescricaoArtigo,
tbArtigosLotes.Codigo as CodigoLote,
tbArtigosLotes.Descricao as DescricaoLote,
tbFornecedores.Codigo as CodigoFornecedor,
tbFornecedores.Nome as DescricaoFornecedor,
tbCampanhas.Codigo as CodigoCampanha, 
tbdocumentosVendas.DataDocumento,
tbdocumentosVendas.UtilizadorCriacao as Utilizador,
tbDocumentosVendas.IDMoeda, 
tbDocumentosVendas.TaxaConversao, 
tbMoedas.Simbolo as tbMoedas_Simbolo, 
tbMoedas.CasasDecimaisTotais as tbMoedas_CasasDecimaisTotais,
Sum((case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) as Quantidade,
Sum(isnull(tbdocumentosVendaslinhas.PrecoUnitarioMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) as Valor,
Sum((isnull(tbdocumentosVendaslinhas.PrecoUnitarioMoedaRef,0)-isnull(tbdocumentosVendaslinhas.PrecoUnitarioEfetivo,0))*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end))  as Desconto,
Sum(isnull(tbdocumentosVendaslinhas.PrecoUnitarioEfetivoMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) as Liquido,
Sum(isnull(tbdocumentosVendaslinhas.PrecoUnitarioEfetivoMoedaRef,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) as TotalValor,
Sum(isnull(tbartigos.medio,0)*(case when tbSistemaNaturezas.codigo=''R'' then tbdocumentosVendaslinhas.Quantidade else -(tbdocumentosVendaslinhas.Quantidade) end)) as TotalCustoMedio,
tbMoedas.CasasDecimaisTotais as Valornumcasasdecimais,
tbMoedas.CasasDecimaisTotais as Descontonumcasasdecimais,
tbMoedas.CasasDecimaisTotais as Liquidonumcasasdecimais,
tbMoedas.CasasDecimaisTotais as TotalValornumcasasdecimais,
tbMoedas.CasasDecimaisTotais as TotalCustoMedionumcasasdecimais
FROM tbdocumentosVendas AS tbdocumentosVendas with (nolock) 
LEFT JOIN tbdocumentosVendaslinhas AS tbdocumentosVendaslinhas with (nolock) ON tbdocumentosVendaslinhas.iddocumentoVenda=tbdocumentosVendas.ID
LEFT JOIN tbArtigos AS tbArtigos with (nolock) ON tbArtigos.id=tbdocumentosVendaslinhas.IDArtigo
LEFT JOIN tbArtigosFornecedores AS tbArtigosFornecedores with (nolock) ON tbArtigos.id=tbArtigosFornecedores.IDArtigo and tbArtigosFornecedores.Ordem=1
LEFT JOIN tbFornecedores AS tbFornecedores with (nolock) ON tbFornecedores.id=tbArtigosFornecedores.IDFornecedor and tbArtigosFornecedores.Ordem=1
LEFT JOIN tbMarcas as tbMarcas with (nolock) ON tbMarcas.ID=tbArtigos.IDMarca
LEFT JOIN tbLojas as tbLojas with (nolock) ON tbLojas.ID=tbdocumentosVendas.IDLoja
LEFT JOIN tbEstados as tbEstados with (nolock) ON tbEstados.ID=tbdocumentosVendas.IDEstado
LEFT JOIN tbCampanhas with (nolock) ON tbDocumentosVendasLinhas.IDCampanha=tbCampanhas.ID
LEFT JOIN tbsistematiposestados as tbsistematiposestados with (nolock) ON tbsistematiposestados.ID=tbEstados.IDtipoEstado
LEFT JOIN tbUnidades as tbUnidades with (nolock) ON tbUnidades.ID=tbArtigos.IDUnidade
LEFT JOIN tbTiposDocumento AS tbTiposDocumento with (nolock) ON tbTiposDocumento.ID=tbdocumentosVendas.IDTipoDocumento
LEFT JOIN tbSistemaTiposDocumento AS tbSistemaTiposDocumento with (nolock) ON tbSistemaTiposDocumento.ID=tbTiposDocumento.IDSistemaTiposDocumento
LEFT JOIN tbSistemaTiposDocumentoFiscal AS tbSistemaTiposDocumentoFiscal with (nolock) ON tbSistemaTiposDocumentoFiscal.ID=tbTiposDocumento.IDSistemaTiposDocumentoFiscal
LEFT JOIN tbSistemaNaturezas AS tbSistemaNaturezas with (nolock) ON tbSistemaNaturezas.ID=tbTiposDocumento.IDSistemaNaturezas
LEFT JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeries with (nolock) ON tbTiposDocumentoSeries.ID=tbdocumentosVendas.IDTiposDocumentoSeries
LEFT JOIN tbArtigosLotes AS tbArtigosLotes with (nolock) ON tbArtigosLotes.ID = tbdocumentosVendaslinhas.IDLote
LEFT JOIN tbClientes AS tbClientes with (nolock) ON tbClientes.ID = tbdocumentosVendas.IDEntidade
LEFT JOIN tbtiposartigos AS tbtiposartigos with (nolock) ON tbtiposartigos.ID = tbArtigos.IDtipoartigo
LEFT JOIN tbParametrosEmpresa as P with (nolock) ON 1 = 1
LEFT JOIN tbMoedas as tbMoedas with (nolock) ON tbMoedas.ID=P.IDMoedaDefeito
where tbsistematiposestados.codigo=''EFT'' and tbsistematiposdocumento.tipo=''VndFinanceiro'' and tbSistemaTiposDocumentoFiscal.Tipo<>''NF'' and isnull(OrigemEntidade2,0)=0
group by tbArtigos.Codigo,tbArtigos.Descricao,tbArtigosLotes.Codigo ,tbArtigosLotes.Descricao ,tbTiposArtigos.Codigo ,tbTiposArtigos.Descricao ,tbLojas.Codigo ,tbLojas.Descricao ,
tbClientes.Codigo ,tbClientes.Nome ,tbMarcas.Codigo,tbMarcas.Descricao,tbFornecedores.Codigo ,tbFornecedores.Nome ,tbCampanhas.Codigo, tbdocumentosVendas.UtilizadorCriacao, tbDocumentosVendas.IDMoeda, tbDocumentosVendas.TaxaConversao, tbMoedas.Simbolo, tbMoedas.CasasDecimaisTotais, tbdocumentosVendas.DataDocumento')
