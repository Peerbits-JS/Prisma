/* ACT BD EMPRESA VERSAO 63*/
--novo campo na tabela tbF3MRecalculo
EXEC('IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ''tbF3MRecalculo'' AND COLUMN_NAME = ''MarcadoRetificaPreco'')
BEGIN
ALTER TABLE tbF3MRecalculo ADD MarcadoRetificaPreco bit
END')

--novo campo na tabela tbSistemaTiposDocumentoFiscal
EXEC('IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ''tbSistemaTiposDocumentoFiscal'' AND COLUMN_NAME = ''Codigo'')
BEGIN
ALTER TABLE  tbSistemaTiposDocumentoFiscal ADD Codigo nvarchar(10)
END')

--atualizar coluna saldo da lista de clientes
EXEC('update [F3MOGeral].dbo.tbcolunasListasPersonalizadas set TipoColuna=3 where IDListaPersonalizada in (25,65,66) and colunavista=''Saldo''')

--nova vista vendas resumo 
EXEC('
update  tbmapasvistas set mapaxml=''
<XtraReportsLayoutSerializer SerializerVersion="18.2.11.0" Ref="1" ControlType="DevExpress.XtraReports.UI.XtraReport, DevExpress.XtraReports.v18.2, Version=18.2.11.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Name="Vendas Resumo" Margins="26, 0, 25, 25" PaperKind="A4" PageWidth="827" PageHeight="1169" ScriptLanguage="VisualBasic" Version="18.2" DataMember="QueryParam" DataSource="#Ref-0" TextAlignment="MiddleRight">
  <Extensions>
    <Item1 Ref="2" Key="DataSerializationExtension" Value="DevExpress.XtraReports.Web.ReportDesigner.DefaultDataSerializer" />
  </Extensions>
  <Parameters>
    <Item1 Ref="4" Description="IDDocumento" ValueInfo="1" Name="IDDocumento" Type="#Ref-3" />
    <Item2 Ref="5" Description="IDLoja" ValueInfo="1" Name="IDLoja" Type="#Ref-3" />
    <Item3 Ref="7" Description="Culture" ValueInfo="pt-PT" Name="Culture" />
    <Item4 Ref="8" Visible="false" Description="Via" Name="Via" />
    <Item5 Ref="9" Visible="false" Description="BDEmpresa" Name="BDEmpresa" />
    <Item6 Ref="10" Description="Utilizador" Name="Utilizador" />
    <Item7 Ref="11" Description="Titulo" Name="Titulo" />
    <Item8 Ref="12" AllowNull="true" Name="UrlServerPath" />
  </Parameters>
  <CalculatedFields>
    <Item1 Ref="13" Name="CalculatedField2" Expression="iif(IsNullOrEmpty([IDDim2]),[DescDim1],[DescDim2])" DataMember="QueryBase.QueryBaseQueryDistOutputs.QueryDistOutputsQueryDistOutputArtigo" />
    <Item2 Ref="14" Name="Dim2" Expression="iif(IsNullOrEmpty([IDDim2]),[DescDim1],[DescDim2])" DataMember="QueryBase.QueryBaseQueryDistOutputArtigo" />
  </CalculatedFields>
  <Bands>
    <Item1 Ref="15" ControlType="TopMarginBand" Name="TopMargin" HeightF="25" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item2 Ref="16" ControlType="ReportHeaderBand" Name="ReportHeader" Expanded="false" HeightF="0" />
    <Item3 Ref="17" ControlType="PageHeaderBand" Name="PageHeader" HeightF="87.51">
      <SubBands>
        <Item1 Ref="18" ControlType="SubBand" Name="SubBand3" HeightF="0" />
      </SubBands>
      <Controls>
        <Item1 Ref="19" ControlType="XRLabel" Name="label14" Multiline="true" Text="%" TextAlignment="MiddleCenter" SizeF="46.04,23" LocationFloat="721.87, 62.41" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="20" UseFont="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="21" ControlType="XRLabel" Name="label13" Multiline="true" Text="Valor Liquido" TextAlignment="MiddleRight" SizeF="93.66,23" LocationFloat="621.87, 62.41" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="22" UseFont="false" UseTextAlignment="false" />
        </Item2>
        <Item3 Ref="23" ControlType="XRLabel" Name="label12" Multiline="true" Text="Descontos" TextAlignment="MiddleRight" SizeF="96.84,23" LocationFloat="523.95, 62.41" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="24" UseFont="false" UseTextAlignment="false" />
        </Item3>
        <Item4 Ref="25" ControlType="XRLabel" Name="label11" Multiline="true" Text="Valor Bruto" TextAlignment="MiddleRight" SizeF="98.92,23" LocationFloat="421.87, 62.41" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="26" UseFont="false" UseTextAlignment="false" />
        </Item4>
        <Item5 Ref="27" ControlType="XRLabel" Name="label10" Multiline="true" Text="Qtd." TextAlignment="MiddleRight" SizeF="101,23" LocationFloat="319.79, 62.41" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="28" UseFont="false" UseTextAlignment="false" />
        </Item5>
        <Item6 Ref="29" ControlType="XRLabel" Name="label9" Multiline="true" Text="Grupo" TextAlignment="MiddleLeft" SizeF="100,23" LocationFloat="17.7, 62.41" Font="Arial, 9pt, style=Bold" Padding="2,2,0,0,100">
          <StylePriority Ref="30" UseFont="false" UseTextAlignment="false" />
        </Item6>
        <Item7 Ref="31" ControlType="XRLine" Name="line1" SizeF="750.21,6.02" LocationFloat="17.7, 81.47" />
        <Item8 Ref="32" ControlType="XRPageInfo" Name="XrPageInfo1" PageInfo="DateTime" TextFormatString="{0:dd/MM/yyyy HH:mm}" TextAlignment="TopRight" SizeF="132.77,10" LocationFloat="638.36, 14.57" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="33" UseFont="false" UseTextAlignment="false" />
        </Item8>
        <Item9 Ref="34" ControlType="XRLabel" Name="fldDesignacaoComercial" TextAlignment="TopLeft" SizeF="373.1997,19.14" LocationFloat="2.583885, 0" Font="Arial, 12pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="35" Expression="[QueryParam.DesignacaoComercial]" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="36" UseFont="false" UseTextAlignment="false" />
        </Item9>
        <Item10 Ref="37" ControlType="XRLine" Name="XrLine1" LineWidth="2" SizeF="768.43,6.910007" LocationFloat="2.7, 37.77" />
        <Item11 Ref="38" ControlType="XRLabel" Name="XrLabel7" TextAlignment="TopRight" SizeF="289.02,10" LocationFloat="482.11, 25" Font="Arial, 6.75pt, charSet=0" Padding="2,2,0,0,100">
          <ExpressionBindings>
            <Item1 Ref="39" Expression="?Utilizador" PropertyName="Text" EventName="BeforePrint" />
          </ExpressionBindings>
          <StylePriority Ref="40" UseFont="false" UseTextAlignment="false" />
        </Item11>
        <Item12 Ref="41" ControlType="XRLabel" Name="XrLabel6" Text="Vendas Resumo" TextAlignment="MiddleLeft" SizeF="373.1997,18.62502" LocationFloat="2.583885, 19.15" Font="Arial, 11.25pt" Padding="2,2,0,0,100">
          <StylePriority Ref="42" UseFont="false" UseTextAlignment="false" />
        </Item12>
        <Item13 Ref="43" ControlType="XRLabel" Name="XrLabel3" Text="Emissão" TextAlignment="TopRight" SizeF="132.77,10" LocationFloat="638.36, 5" Font="Arial, 6.75pt, style=Bold, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="44" UseFont="false" UseTextAlignment="false" />
        </Item13>
      </Controls>
    </Item3>
    <Item4 Ref="45" ControlType="DetailBand" Name="Detail" HeightF="0" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
    <Item5 Ref="46" ControlType="DetailReportBand" Name="DetailReport1" Level="0" DataMember="QueryBase" DataSource="#Ref-0">
      <Bands>
        <Item1 Ref="47" ControlType="DetailBand" Name="Detail1" HeightF="25.09" KeepTogether="true">
          <Controls>
            <Item1 Ref="48" ControlType="XRLabel" Name="label2" Multiline="true" Text="label2" TextAlignment="MiddleLeft" SizeF="302.96,23" LocationFloat="17.7, 0" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="49" Expression="[Grupo]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="50" UseFont="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="51" ControlType="XRLabel" Name="label7" TextFormatString="{0:# ### ##0.00 €}" Multiline="true" Text="label7" SizeF="96.84,23" LocationFloat="523.95, 0" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="52" Expression="[Descontos]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="53" UseFont="false" />
            </Item2>
            <Item3 Ref="54" ControlType="XRLabel" Name="label6" TextFormatString="{0:# ### ##0.00 €}" Multiline="true" Text="label6" SizeF="95.75,23" LocationFloat="621.87, 0" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="55" Expression="[ValorLiquido]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="56" UseFont="false" />
            </Item3>
            <Item4 Ref="57" ControlType="XRLabel" Name="label5" TextFormatString="{0:0.00}" Multiline="true" Text="label5" SizeF="45,23" LocationFloat="722.91, 0" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="58" Expression="[Percentagem]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="59" UseFont="false" />
            </Item4>
            <Item5 Ref="60" ControlType="XRLabel" Name="label4" TextFormatString="{0:# ### ##0.00 €}" Multiline="true" Text="label4" SizeF="98.97,23" LocationFloat="421.87, 0" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="61" Expression="[ValorBruto]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="62" UseFont="false" />
            </Item5>
            <Item6 Ref="63" ControlType="XRLabel" Name="label3" TextFormatString="{0:# ### ##0.00}" Multiline="true" Text="label3" SizeF="100,23" LocationFloat="320.8, 0" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="64" Expression="[Quantidade]" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="65" UseFont="false" />
            </Item6>
          </Controls>
        </Item1>
        <Item2 Ref="66" ControlType="GroupFooterBand" Name="GroupFooter3" HeightF="39.58">
          <Controls>
            <Item1 Ref="67" ControlType="XRLabel" Name="label23" Multiline="true" Text="Total Global:" TextAlignment="MiddleLeft" SizeF="154.13,23" LocationFloat="17.7, 12.51" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <StylePriority Ref="68" UseFont="false" UseTextAlignment="false" />
            </Item1>
            <Item2 Ref="69" ControlType="XRLine" Name="line4" SizeF="750.22,6.02" LocationFloat="17.7, 6.5" />
            <Item3 Ref="70" ControlType="XRLabel" Name="label22" TextFormatString="{0:# ### ##0.00 €}" Multiline="true" Text="label15" SizeF="95.8,23" LocationFloat="621.84, 12.5" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="71" Expression="&#xA;&#xA;[].Sum( [ValorLiquido]  )" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="72" UseFont="false" />
            </Item3>
            <Item4 Ref="73" ControlType="XRLabel" Name="label21" TextFormatString="{0:# ### ##0.00 €}" Multiline="true" Text="label15" SizeF="96.84,23" LocationFloat="523.95, 12.5" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="74" Expression="&#xA;&#xA;[].Sum( [Descontos]   )" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="75" UseFont="false" />
            </Item4>
            <Item5 Ref="76" ControlType="XRLabel" Name="label20" TextFormatString="{0:# ### ##0.00 €}" Multiline="true" Text="label15" SizeF="98.95,23" LocationFloat="421.87, 12.5" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="77" Expression="&#xA;&#xA;[].Sum(  [ValorBruto]  )" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="78" UseFont="false" />
            </Item5>
            <Item6 Ref="79" ControlType="XRLabel" Name="label19" TextFormatString="{0:# ### ##0.00}" Multiline="true" Text="label15" SizeF="100,23" LocationFloat="320.81, 12.5" Font="Arial, 9pt" Padding="2,2,0,0,100">
              <ExpressionBindings>
                <Item1 Ref="80" Expression="&#xA;&#xA;[].Sum( [Quantidade] )" PropertyName="Text" EventName="BeforePrint" />
              </ExpressionBindings>
              <StylePriority Ref="81" UseFont="false" />
            </Item6>
          </Controls>
        </Item2>
      </Bands>
    </Item5>
    <Item6 Ref="82" ControlType="GroupFooterBand" Name="GroupFooter1" PrintAtBottom="true" RepeatEveryPage="true" PageBreak="AfterBand" HeightF="31.21">
      <Controls>
        <Item1 Ref="83" ControlType="XRPageInfo" Name="XrPageInfo2" TextFormatString="Página {0} de {1}" TextAlignment="MiddleRight" SizeF="121,13" LocationFloat="650.13, 11.32" Font="Arial, 6pt, charSet=0" Padding="2,2,0,0,100">
          <StylePriority Ref="84" UseFont="false" UseTextAlignment="false" />
        </Item1>
        <Item2 Ref="85" ControlType="XRLine" Name="XrLine6" LineWidth="2" SizeF="768.43,4.000028" LocationFloat="2.7, 7.41" BorderWidth="1">
          <StylePriority Ref="86" UseBorderWidth="false" />
        </Item2>
      </Controls>
    </Item6>
    <Item7 Ref="87" ControlType="ReportFooterBand" Name="ReportFooter" HeightF="23" />
    <Item8 Ref="88" ControlType="PageFooterBand" Name="PageFooter" HeightF="1.583354">
      <SubBands>
        <Item1 Ref="89" ControlType="SubBand" Name="SubBand1" HeightF="23" Visible="false" />
      </SubBands>
    </Item8>
    <Item9 Ref="90" ControlType="BottomMarginBand" Name="BottomMargin" HeightF="25" TextAlignment="TopLeft" Padding="0,0,0,0,100" />
  </Bands>
  <ObjectStorage>
    <Item1 ObjectType="DevExpress.XtraReports.Serialization.ObjectStorageInfo, DevExpress.XtraReports.v18.2" Ref="3" Content="System.Int64" Type="System.Type" />
    <Item2 Ref="0" ObjectType="DevExpress.DataAccess.Sql.SqlDataSource,DevExpress.DataAccess.v18.2" Base64="PFNxbERhdGFTb3VyY2U+PENvbm5lY3Rpb24gTmFtZT0iQ29ubmVjdGlvbiIgQ29ubmVjdGlvblN0cmluZz0iRGF0YSBTb3VyY2U9UFJJU01BLUxBQi1WTVxDNDtVc2VyIElEPUYzTU87UGFzc3dvcmQ9O0luaXRpYWwgQ2F0YWxvZyA9MjgxNEYzTU87IiAvPjxRdWVyeSBUeXBlPSJDdXN0b21TcWxRdWVyeSIgTmFtZT0iUXVlcnlCYXNlIj48U3FsPg0KU0VMRUNUICAgICAgICAgICAgICBDQVNFICAgV0hFTiBudWxsID0gJ0xvamEnIFRIRU4gdGJMb2phcy5EZXNjcmljYW8gICBXSEVOIG51bGwgPSAnTWFyY2EnIFRIRU4gdGJNYXJjYXMuRGVzY3JpY2FvICAgV0hFTiBudWxsID0gJ1RpcG8gQXJ0aWdvJyBUaGVuIHRiVGlwb3NBcnRpZ29zLkRlc2NyaWNhbyAgV0hFTiBudWxsID0gJ0Zvcm5lY2Vkb3InIFRIRU4gdGJGb3JuZWNlZG9yZXMuTm9tZSAgV0hFTiBudWxsID0gJ0NhbXBhbmhhJyBUSEVOIHRiQ2FtcGFuaGFzLkRlc2NyaWNhbyAgICAgICAgIEVMU0UgdGJMb2phcy5EZXNjcmljYW8gIEVORCBhcyBHcnVwbywgICAgU1VNKChDQVNFIFdIRU4gdGJTaXN0ZW1hTmF0dXJlemFzLmNvZGlnbyA9ICdSJyBUSEVOIHRiZG9jdW1lbnRvc1ZlbmRhc2xpbmhhcy5RdWFudGlkYWRlIEVMU0UgLSAodGJkb2N1bWVudG9zVmVuZGFzbGluaGFzLlF1YW50aWRhZGUpIEVORCkpICAgIEFTIFF1YW50aWRhZGUsICAgIHJvdW5kKFNVTSgoSVNOVUxMKHRiZG9jdW1lbnRvc1ZlbmRhc2xpbmhhcy5QcmVjb1VuaXRhcmlvRWZldGl2b1NlbUl2YSAsIDApICsgSVNOVUxMKHRiZG9jdW1lbnRvc1ZlbmRhc2xpbmhhcy5WYWxvckRlc2NvbnRvRWZldGl2b1NlbUl2YSAgLCAwKSkgKiAoQ0FTRSBXSEVOIHRiU2lzdGVtYU5hdHVyZXphcy5jb2RpZ28gPSAnUicgICAgVEhFTiB0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMuUXVhbnRpZGFkZSBFTFNFIC0gKHRiZG9jdW1lbnRvc1ZlbmRhc2xpbmhhcy5RdWFudGlkYWRlKSBFTkQpKSwyKSAgICBBUyBWYWxvckJydXRvLCAgIHJvdW5kKFNVTShJU05VTEwodGJkb2N1bWVudG9zVmVuZGFzbGluaGFzLlZhbG9yRGVzY29udG9FZmV0aXZvU2VtSXZhICAsIDApICogKENBU0UgV0hFTiB0YlNpc3RlbWFOYXR1cmV6YXMuY29kaWdvID0gJ1InIFRIRU4gdGJkb2N1bWVudG9zVmVuZGFzbGluaGFzLlF1YW50aWRhZGUgRUxTRSAtICh0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMuUXVhbnRpZGFkZSkgRU5EKSksMikgICAgQVMgRGVzY29udG9zLCAgIHJvdW5kKFNVTShJU05VTEwodGJkb2N1bWVudG9zVmVuZGFzbGluaGFzLlByZWNvVW5pdGFyaW9FZmV0aXZvU2VtSXZhICwgMCkgKiAoQ0FTRSBXSEVOIHRiU2lzdGVtYU5hdHVyZXphcy5jb2RpZ28gPSAnUicgVEhFTiB0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMuUXVhbnRpZGFkZSBFTFNFIC0gKHRiZG9jdW1lbnRvc1ZlbmRhc2xpbmhhcy5RdWFudGlkYWRlKSBFTkQpKSwyKSAgICBBUyBbVmFsb3JMaXF1aWRvXSwgICByb3VuZChTVU0oSVNOVUxMKHRiZG9jdW1lbnRvc1ZlbmRhc2xpbmhhcy5QcmVjb1VuaXRhcmlvRWZldGl2b1NlbUl2YSAsIDApICogKENBU0UgV0hFTiB0YlNpc3RlbWFOYXR1cmV6YXMuY29kaWdvID0gJ1InIFRIRU4gdGJkb2N1bWVudG9zVmVuZGFzbGluaGFzLlF1YW50aWRhZGUgRUxTRSAtICh0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMuUXVhbnRpZGFkZSkgRU5EKSkgLyAgICAgIChzZWxlY3QgICByb3VuZChTVU0oSVNOVUxMKHRiZG9jdW1lbnRvc1ZlbmRhc2xpbmhhczIuUHJlY29Vbml0YXJpb0VmZXRpdm9TZW1JdmEgLCAwKSAqIChDQVNFIFdIRU4gdGJTaXN0ZW1hTmF0dXJlemFzMi5jb2RpZ28gPSAnUicgVEhFTiB0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMyLlF1YW50aWRhZGUgRUxTRSAtICh0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMyLlF1YW50aWRhZGUpIEVORCkpLDIpICAgICAgIGZyb20gICBkYm8udGJEb2N1bWVudG9zVmVuZGFzIEFTIHRiZG9jdW1lbnRvc1ZlbmRhczIgV0lUSCAobm9sb2NrKSBMRUZUIE9VVEVSIEpPSU4gIGRiby50YkRvY3VtZW50b3NWZW5kYXNMaW5oYXMgQVMgdGJkb2N1bWVudG9zVmVuZGFzbGluaGFzMiBXSVRIIChub2xvY2spIE9OIHRiZG9jdW1lbnRvc1ZlbmRhc2xpbmhhczIuSUREb2N1bWVudG9WZW5kYSA9IHRiZG9jdW1lbnRvc1ZlbmRhczIuSUQgTEVGVCBPVVRFUiBKT0lOICBkYm8udGJBcnRpZ29zIEFTIHRiQXJ0aWdvczIgV0lUSCAobm9sb2NrKSBPTiB0YkFydGlnb3MyLklEID0gdGJkb2N1bWVudG9zVmVuZGFzbGluaGFzMi5JREFydGlnbyBMRUZUIE9VVEVSIEpPSU4gIGRiby50YkFydGlnb3NGb3JuZWNlZG9yZXMgQVMgdGJBcnRpZ29zRm9ybmVjZWRvcmVzMiBXSVRIIChub2xvY2spIE9OIHRiQXJ0aWdvczIuSUQgPSB0YkFydGlnb3NGb3JuZWNlZG9yZXMyLklEQXJ0aWdvIEFORCB0YkFydGlnb3NGb3JuZWNlZG9yZXMyLk9yZGVtID0gMSBMRUZUIE9VVEVSIEpPSU4gIGRiby50YkZvcm5lY2Vkb3JlcyBBUyB0YkZvcm5lY2Vkb3JlczIgV0lUSCAobm9sb2NrKSBPTiB0YkZvcm5lY2Vkb3JlczIuSUQgPSB0YkFydGlnb3NGb3JuZWNlZG9yZXMyLklERm9ybmVjZWRvciBBTkQgdGJBcnRpZ29zRm9ybmVjZWRvcmVzMi5PcmRlbSA9IDEgTEVGVCBPVVRFUiBKT0lOICBkYm8udGJNYXJjYXMgQVMgdGJNYXJjYXMyIFdJVEggKG5vbG9jaykgT04gdGJNYXJjYXMyLklEID0gdGJBcnRpZ29zMi5JRE1hcmNhIExFRlQgT1VURVIgSk9JTiAgZGJvLnRiTG9qYXMgQVMgdGJMb2phczIgV0lUSCAobm9sb2NrKSBPTiB0YkxvamFzMi5JRCA9IHRiZG9jdW1lbnRvc1ZlbmRhczIuSURMb2phIExFRlQgT1VURVIgSk9JTiAgZGJvLnRiRXN0YWRvcyBBUyB0YkVzdGFkb3MyIFdJVEggKG5vbG9jaykgT04gdGJFc3RhZG9zMi5JRCA9IHRiZG9jdW1lbnRvc1ZlbmRhczIuSURFc3RhZG8gTEVGVCBPVVRFUiBKT0lOICBkYm8udGJDYW1wYW5oYXMgQVMgdGJDYW1wYW5oYXMyIFdJVEggKG5vbG9jaykgT04gdGJkb2N1bWVudG9zVmVuZGFzbGluaGFzMi5JRENhbXBhbmhhID0gdGJDYW1wYW5oYXMyLklEIExFRlQgT1VURVIgSk9JTiAgZGJvLnRiU2lzdGVtYVRpcG9zRXN0YWRvcyBBUyB0YnNpc3RlbWF0aXBvc2VzdGFkb3MyIFdJVEggKG5vbG9jaykgT04gdGJzaXN0ZW1hdGlwb3Nlc3RhZG9zMi5JRCA9IHRiRXN0YWRvczIuSURUaXBvRXN0YWRvIExFRlQgT1VURVIgSk9JTiAgZGJvLnRiVW5pZGFkZXMgQVMgdGJVbmlkYWRlczIgV0lUSCAobm9sb2NrKSBPTiB0YlVuaWRhZGVzMi5JRCA9IHRiQXJ0aWdvczIuSURVbmlkYWRlIExFRlQgT1VURVIgSk9JTiAgZGJvLnRiVGlwb3NEb2N1bWVudG8gQVMgdGJUaXBvc0RvY3VtZW50bzIgV0lUSCAobm9sb2NrKSBPTiB0YlRpcG9zRG9jdW1lbnRvMi5JRCA9IHRiZG9jdW1lbnRvc1ZlbmRhczIuSURUaXBvRG9jdW1lbnRvIExFRlQgT1VURVIgSk9JTiAgZGJvLnRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvIEFTIHRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvMiBXSVRIIChub2xvY2spIE9OIHRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvMi5JRCA9IHRiVGlwb3NEb2N1bWVudG8yLklEU2lzdGVtYVRpcG9zRG9jdW1lbnRvIExFRlQgT1VURVIgSk9JTiAgZGJvLnRiU2lzdGVtYU5hdHVyZXphcyBBUyB0YlNpc3RlbWFOYXR1cmV6YXMyIFdJVEggKG5vbG9jaykgT04gdGJTaXN0ZW1hTmF0dXJlemFzMi5JRCA9IHRiVGlwb3NEb2N1bWVudG8yLklEU2lzdGVtYU5hdHVyZXphcyBMRUZUIE9VVEVSIEpPSU4gIGRiby50YlRpcG9zRG9jdW1lbnRvU2VyaWVzIEFTIHRiVGlwb3NEb2N1bWVudG9TZXJpZXMyIFdJVEggKG5vbG9jaykgT04gdGJUaXBvc0RvY3VtZW50b1NlcmllczIuSUQgPSB0YmRvY3VtZW50b3NWZW5kYXMyLklEVGlwb3NEb2N1bWVudG9TZXJpZXMgTEVGVCBPVVRFUiBKT0lOICBkYm8udGJBcnRpZ29zTG90ZXMgQVMgdGJBcnRpZ29zTG90ZXMyIFdJVEggKG5vbG9jaykgT04gdGJBcnRpZ29zTG90ZXMyLklEID0gdGJkb2N1bWVudG9zVmVuZGFzbGluaGFzMi5JRExvdGUgTEVGVCBPVVRFUiBKT0lOICBkYm8udGJDbGllbnRlcyBBUyB0YkNsaWVudGVzMiBXSVRIIChub2xvY2spIE9OIHRiQ2xpZW50ZXMyLklEID0gdGJkb2N1bWVudG9zVmVuZGFzMi5JREVudGlkYWRlIExFRlQgT1VURVIgSk9JTiAgZGJvLnRiVGlwb3NBcnRpZ29zIEFTIHRidGlwb3NhcnRpZ29zMiBXSVRIIChub2xvY2spIE9OIHRidGlwb3NhcnRpZ29zMi5JRCA9IHRiQXJ0aWdvczIuSURUaXBvQXJ0aWdvIExFRlQgT1VURVIgSk9JTiAgZGJvLnRiUGFyYW1ldHJvc0VtcHJlc2EgQVMgUDIgV0lUSCAobm9sb2NrKSBPTiAxID0gMSBMRUZUIE9VVEVSIEpPSU4gIGRiby50Yk1vZWRhcyBBUyB0Yk1vZWRhczIgV0lUSCAobm9sb2NrKSBPTiB0Yk1vZWRhczIuSUQgPSBQMi5JRE1vZWRhRGVmZWl0byAgV2hlcmUgICh0YnNpc3RlbWF0aXBvc2VzdGFkb3MyLkNvZGlnbyA9ICdFRlQnKSBBTkQgKHRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvMi5UaXBvID0gJ1ZuZEZpbmFuY2Vpcm8nKSBhbmQgdGJkb2N1bWVudG9zVmVuZGFzbGluaGFzMi5Db2RpZ29BcnRpZ28gaXMgbm90IG51bGwgKSAqMTAwICwyKSBhcyBQZXJjZW50YWdlbSBGUk9NICAgICAgICAgICAgICBkYm8udGJEb2N1bWVudG9zVmVuZGFzIEFTIHRiZG9jdW1lbnRvc1ZlbmRhcyBXSVRIIChub2xvY2spIExFRlQgT1VURVIgSk9JTiAgZGJvLnRiRG9jdW1lbnRvc1ZlbmRhc0xpbmhhcyBBUyB0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMgV0lUSCAobm9sb2NrKSBPTiB0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMuSUREb2N1bWVudG9WZW5kYSA9IHRiZG9jdW1lbnRvc1ZlbmRhcy5JRCBMRUZUIE9VVEVSIEpPSU4gIGRiby50YkFydGlnb3MgQVMgdGJBcnRpZ29zIFdJVEggKG5vbG9jaykgT04gdGJBcnRpZ29zLklEID0gdGJkb2N1bWVudG9zVmVuZGFzbGluaGFzLklEQXJ0aWdvIExFRlQgT1VURVIgSk9JTiAgZGJvLnRiQXJ0aWdvc0Zvcm5lY2Vkb3JlcyBBUyB0YkFydGlnb3NGb3JuZWNlZG9yZXMgV0lUSCAobm9sb2NrKSBPTiB0YkFydGlnb3MuSUQgPSB0YkFydGlnb3NGb3JuZWNlZG9yZXMuSURBcnRpZ28gQU5EIHRiQXJ0aWdvc0Zvcm5lY2Vkb3Jlcy5PcmRlbSA9IDEgTEVGVCBPVVRFUiBKT0lOICBkYm8udGJGb3JuZWNlZG9yZXMgQVMgdGJGb3JuZWNlZG9yZXMgV0lUSCAobm9sb2NrKSBPTiB0YkZvcm5lY2Vkb3Jlcy5JRCA9IHRiQXJ0aWdvc0Zvcm5lY2Vkb3Jlcy5JREZvcm5lY2Vkb3IgQU5EIHRiQXJ0aWdvc0Zvcm5lY2Vkb3Jlcy5PcmRlbSA9IDEgTEVGVCBPVVRFUiBKT0lOICBkYm8udGJNYXJjYXMgQVMgdGJNYXJjYXMgV0lUSCAobm9sb2NrKSBPTiB0Yk1hcmNhcy5JRCA9IHRiQXJ0aWdvcy5JRE1hcmNhIExFRlQgT1VURVIgSk9JTiAgZGJvLnRiTG9qYXMgQVMgdGJMb2phcyBXSVRIIChub2xvY2spIE9OIHRiTG9qYXMuSUQgPSB0YmRvY3VtZW50b3NWZW5kYXMuSURMb2phIExFRlQgT1VURVIgSk9JTiAgZGJvLnRiRXN0YWRvcyBBUyB0YkVzdGFkb3MgV0lUSCAobm9sb2NrKSBPTiB0YkVzdGFkb3MuSUQgPSB0YmRvY3VtZW50b3NWZW5kYXMuSURFc3RhZG8gTEVGVCBPVVRFUiBKT0lOICBkYm8udGJDYW1wYW5oYXMgV0lUSCAobm9sb2NrKSBPTiB0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMuSURDYW1wYW5oYSA9IGRiby50YkNhbXBhbmhhcy5JRCBMRUZUIE9VVEVSIEpPSU4gIGRiby50YlNpc3RlbWFUaXBvc0VzdGFkb3MgQVMgdGJzaXN0ZW1hdGlwb3Nlc3RhZG9zIFdJVEggKG5vbG9jaykgT04gdGJzaXN0ZW1hdGlwb3Nlc3RhZG9zLklEID0gdGJFc3RhZG9zLklEVGlwb0VzdGFkbyBMRUZUIE9VVEVSIEpPSU4gIGRiby50YlVuaWRhZGVzIEFTIHRiVW5pZGFkZXMgV0lUSCAobm9sb2NrKSBPTiB0YlVuaWRhZGVzLklEID0gdGJBcnRpZ29zLklEVW5pZGFkZSBMRUZUIE9VVEVSIEpPSU4gIGRiby50YlRpcG9zRG9jdW1lbnRvIEFTIHRiVGlwb3NEb2N1bWVudG8gV0lUSCAobm9sb2NrKSBPTiB0YlRpcG9zRG9jdW1lbnRvLklEID0gdGJkb2N1bWVudG9zVmVuZGFzLklEVGlwb0RvY3VtZW50byBMRUZUIE9VVEVSIEpPSU4gIGRiby50YlNpc3RlbWFUaXBvc0RvY3VtZW50byBBUyB0YlNpc3RlbWFUaXBvc0RvY3VtZW50byBXSVRIIChub2xvY2spIE9OIHRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvLklEID0gdGJUaXBvc0RvY3VtZW50by5JRFNpc3RlbWFUaXBvc0RvY3VtZW50byBMRUZUIE9VVEVSIEpPSU4gIGRiby50YlNpc3RlbWFOYXR1cmV6YXMgQVMgdGJTaXN0ZW1hTmF0dXJlemFzIFdJVEggKG5vbG9jaykgT04gdGJTaXN0ZW1hTmF0dXJlemFzLklEID0gdGJUaXBvc0RvY3VtZW50by5JRFNpc3RlbWFOYXR1cmV6YXMgTEVGVCBPVVRFUiBKT0lOICBkYm8udGJUaXBvc0RvY3VtZW50b1NlcmllcyBBUyB0YlRpcG9zRG9jdW1lbnRvU2VyaWVzIFdJVEggKG5vbG9jaykgT04gdGJUaXBvc0RvY3VtZW50b1Nlcmllcy5JRCA9IHRiZG9jdW1lbnRvc1ZlbmRhcy5JRFRpcG9zRG9jdW1lbnRvU2VyaWVzIExFRlQgT1VURVIgSk9JTiAgZGJvLnRiQXJ0aWdvc0xvdGVzIEFTIHRiQXJ0aWdvc0xvdGVzIFdJVEggKG5vbG9jaykgT04gdGJBcnRpZ29zTG90ZXMuSUQgPSB0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMuSURMb3RlIExFRlQgT1VURVIgSk9JTiAgZGJvLnRiQ2xpZW50ZXMgQVMgdGJDbGllbnRlcyBXSVRIIChub2xvY2spIE9OIHRiQ2xpZW50ZXMuSUQgPSB0YmRvY3VtZW50b3NWZW5kYXMuSURFbnRpZGFkZSBMRUZUIE9VVEVSIEpPSU4gIGRiby50YlRpcG9zQXJ0aWdvcyBBUyB0YnRpcG9zYXJ0aWdvcyBXSVRIIChub2xvY2spIE9OIHRidGlwb3NhcnRpZ29zLklEID0gdGJBcnRpZ29zLklEVGlwb0FydGlnbyBMRUZUIE9VVEVSIEpPSU4gIGRiby50YlBhcmFtZXRyb3NFbXByZXNhIEFTIFAgV0lUSCAobm9sb2NrKSBPTiAxID0gMSBMRUZUIE9VVEVSIEpPSU4gIGRiby50Yk1vZWRhcyBBUyB0Yk1vZWRhcyBXSVRIIChub2xvY2spIE9OIHRiTW9lZGFzLklEID0gUC5JRE1vZWRhRGVmZWl0byBXSEVSRSAgICAgICAgICAodGJzaXN0ZW1hdGlwb3Nlc3RhZG9zLkNvZGlnbyA9ICdFRlQnKSBBTkQgKHRiU2lzdGVtYVRpcG9zRG9jdW1lbnRvLlRpcG8gPSAnVm5kRmluYW5jZWlybycpIGFuZCB0YmRvY3VtZW50b3NWZW5kYXNsaW5oYXMuQ29kaWdvQXJ0aWdvIGlzIG5vdCBudWxsICAgICAgICAgIGFuZCB0YkRvY3VtZW50b3NWZW5kYXMuZGF0YWRvY3VtZW50byAmZ3Q7PSBjYXNlIHdoZW4gbnVsbCA9ICcnIHRoZW4gJzE5MDAtMDEtMDEnIGVsc2UgIG51bGwgRU5EICAgICAgICAgYW5kIHRiRG9jdW1lbnRvc1ZlbmRhcy5kYXRhZG9jdW1lbnRvICZsdDs9IGNhc2Ugd2hlbiBudWxsID0nJyB0aGVuICc5OTk5LTEyLTMxJyBlbHNlIG51bGwgRU5EICAgICAgICAgIGFuZCAodGJEb2N1bWVudG9zVmVuZGFzLklETG9qYSA9IG51bGwgb3IgbnVsbCA9ICcnKSAgICAgICAgICBhbmQgMT0xICBHUk9VUCBCWSAgIENBU0UgICBXSEVOIG51bGwgPSAnTG9qYXMnIFRIRU4gdGJMb2phcy5EZXNjcmljYW8gICBXSEVOIG51bGwgPSAnTWFyY2EnIFRIRU4gdGJNYXJjYXMuRGVzY3JpY2FvICAgV0hFTiBudWxsID0gJ1RpcG8gQXJ0aWdvJyBUaGVuIHRiVGlwb3NBcnRpZ29zLkRlc2NyaWNhbyAgV0hFTiBudWxsID0gJ0Zvcm5lY2Vkb3InIFRIRU4gdGJGb3JuZWNlZG9yZXMuTm9tZSAgV0hFTiBudWxsID0gJ0NhbXBhbmhhJyBUSEVOIHRiQ2FtcGFuaGFzLkRlc2NyaWNhbyAgICAgICAgIEVMU0UgdGJMb2phcy5EZXNjcmljYW8gRU5EIG9yZGVyIGJ5ICBwZXJjZW50YWdlbSBkZXNjIC8qR3J1cG86IExvamE7VGlwbyBBcnRpZ287TWFyY2E7Q2FtcGFuaGE7Rm9ybmVjZWRvciovDQo8L1NxbD48L1F1ZXJ5PjxRdWVyeSBUeXBlPSJDdXN0b21TcWxRdWVyeSIgTmFtZT0iUXVlcnlQYXJhbSI+PFNxbD5zZWxlY3QgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJJRCIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJJRE1vZWRhRGVmZWl0byIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJNb3JhZGEiLCAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIkZvdG8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iRm90b0NhbWluaG8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iRGVzaWduYWNhb0NvbWVyY2lhbCIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJDb2RpZ29Qb3N0YWwiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iTG9jYWxpZGFkZSIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJDb25jZWxobyIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJEaXN0cml0byIsDQogICAgICAgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJJREVtcHJlc2EiLA0KICAgICAgICJ0YlNpc3RlbWFTaWdsYXNQYWlzZXMiLiJTaWdsYSIsICJ0Yk1vZWRhcyIuIkRlc2NyaWNhbyIsDQogICAgICAgInRiTW9lZGFzIi4iVGF4YUNvbnZlcnNhbyIsICJ0Yk1vZWRhcyIuIlNpbWJvbG8iLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iSURQYWlzIiwNCiAgICAgICAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIlRlbGVmb25lIiwgInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJGYXgiLA0KICAgICAgICJ0YlBhcmFtZXRyb3NFbXByZXNhIi4iRW1haWwiLCAidGJQYXJhbWV0cm9zRW1wcmVzYSIuIk5JRiINCiAgZnJvbSAoKCJkYm8iLiJ0YlBhcmFtZXRyb3NFbXByZXNhIiAidGJQYXJhbWV0cm9zRW1wcmVzYSINCiAgaW5uZXIgam9pbiAiZGJvIi4idGJTaXN0ZW1hU2lnbGFzUGFpc2VzIiAidGJTaXN0ZW1hU2lnbGFzUGFpc2VzIg0KICAgICAgIG9uICgidGJTaXN0ZW1hU2lnbGFzUGFpc2VzIi4iSUQiID0gInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJJRFBhaXMiKSkNCiAgaW5uZXIgam9pbiAiZGJvIi4idGJNb2VkYXMiICJ0Yk1vZWRhcyINCiAgICAgICBvbiAoInRiTW9lZGFzIi4iSUQiID0gInRiUGFyYW1ldHJvc0VtcHJlc2EiLiJJRE1vZWRhRGVmZWl0byIpKTwvU3FsPjxNZXRhIFg9IjQwIiBZPSIyMCIgV2lkdGg9IjEwMCIgSGVpZ2h0PSI1MDciIC8+PC9RdWVyeT48UmVzdWx0U2NoZW1hPjxEYXRhU2V0PjxWaWV3IE5hbWU9IlF1ZXJ5QmFzZSI+PEZpZWxkIE5hbWU9IkdydXBvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IlF1YW50aWRhZGUiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVmFsb3JCcnV0byIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJEZXNjb250b3MiIFR5cGU9IkRvdWJsZSIgLz48RmllbGQgTmFtZT0iVmFsb3JMaXF1aWRvIiBUeXBlPSJEb3VibGUiIC8+PEZpZWxkIE5hbWU9IlBlcmNlbnRhZ2VtIiBUeXBlPSJEb3VibGUiIC8+PC9WaWV3PjxWaWV3IE5hbWU9IlF1ZXJ5UGFyYW0iPjxGaWVsZCBOYW1lPSJJRCIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IklETW9lZGFEZWZlaXRvIiBUeXBlPSJJbnQ2NCIgLz48RmllbGQgTmFtZT0iTW9yYWRhIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkZvdG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRm90b0NhbWluaG8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iRGVzaWduYWNhb0NvbWVyY2lhbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb2RpZ29Qb3N0YWwiIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iTG9jYWxpZGFkZSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJDb25jZWxobyIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEaXN0cml0byIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJJREVtcHJlc2EiIFR5cGU9IkludDY0IiAvPjxGaWVsZCBOYW1lPSJTaWdsYSIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJEZXNjcmljYW8iIFR5cGU9IlN0cmluZyIgLz48RmllbGQgTmFtZT0iVGF4YUNvbnZlcnNhbyIgVHlwZT0iRG91YmxlIiAvPjxGaWVsZCBOYW1lPSJTaW1ib2xvIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IklEUGFpcyIgVHlwZT0iSW50NjQiIC8+PEZpZWxkIE5hbWU9IlRlbGVmb25lIiBUeXBlPSJTdHJpbmciIC8+PEZpZWxkIE5hbWU9IkZheCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJFbWFpbCIgVHlwZT0iU3RyaW5nIiAvPjxGaWVsZCBOYW1lPSJOSUYiIFR5cGU9IlN0cmluZyIgLz48L1ZpZXc+PC9EYXRhU2V0PjwvUmVzdWx0U2NoZW1hPjxDb25uZWN0aW9uT3B0aW9ucyBDbG9zZUNvbm5lY3Rpb249InRydWUiIERiQ29tbWFuZFRpbWVvdXQ9IjE4MDAiIC8+PC9TcWxEYXRhU291cmNlPg==" />
  </ObjectStorage>
</XtraReportsLayoutSerializer>
''
where descricao=''Vendas Resumo'' and sistema =1')

--mapa de iva de vendas
EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwMapaIvaVendas'')) drop view vwMapaIvaVendas')

EXEC('create view [dbo].[vwMapaIvaVendas] as
select 
tbDocumentosVendas.ID, 
tbDocumentosVendas.IDLoja, 
tbDocumentosVendas.NomeFiscal, 
tbDocumentosVendas.IDEntidade, 
tbDocumentosVendas.IDTipoDocumento, 
tbDocumentosVendas.IDTiposDocumentoSeries, 
tbDocumentosVendas.NumeroDocumento, 
tbDocumentosVendas.DataDocumento,
tbDocumentosVendas.UtilizadorCriacao as Utilizador,
tbDocumentosVendas.Documento, 
tbDocumentosVendas.IDMoeda, 
tbDocumentosVendas.TaxaConversao, 
tbDocumentosVendas.Ativo as Ativo, 
tbDocumentosVendasLinhas.TaxaIva, 
tbDocumentosVendasLinhas.IDTaxaIva, 
tbLojas.Codigo as CodigoLoja, 
tbLojas.Descricao as DescricaoLoja,
tbClientes.Codigo as CodigoCliente, 
tbClientes.NContribuinte as NContribuinte, 
tbTiposDocumento.Codigo as CodigoTipoDocumento, 
tbTiposDocumento.Descricao as DescricaoTipoDocumento,
tbsistematiposiva.Codigo as CodigoIva, 
tbCampanhas.Codigo as CodigoCampanha, 
tbsistematiposestados.codigo as CodigoEstado,
tbsistematiposestados.descricao as DescricaoEstado,
(case when tbSistemaNaturezas.Codigo=''P'' then ''Crédito'' else ''Débito'' end) as Natureza,
(case when tbsistematiposestados.codigo=''EFT'' then 1 else 0 end)*(case when tbSistemaNaturezas.Codigo=''P'' then -1 else 1 end)*sum(tbDocumentosVendasLinhas.ValorIncidencia) as ValorIncidencia,
(case when tbsistematiposestados.codigo=''EFT'' then 1 else 0 end)*(case when tbSistemaNaturezas.Codigo=''P'' then -1 else 1 end)*sum(tbDocumentosVendasLinhas.ValorIVA) as ValorIVA,
(case when tbsistematiposestados.codigo=''EFT'' then 1 else 0 end)*(case when tbSistemaNaturezas.Codigo=''P'' then -1 else 1 end)*sum(tbDocumentosVendasLinhas.ValorIncidencia + tbDocumentosVendasLinhas.ValorIVA) as Valor,
tbMoedas.Simbolo as tbMoedas_Simbolo, 
tbMoedas.CasasDecimaisTotais as tbMoedas_CasasDecimaisTotais
FROM tbDocumentosVendas AS tbDocumentosVendas
INNER JOIN tbDocumentosVendasLinhas AS tbDocumentosVendasLinhas ON tbDocumentosVendas.id=tbDocumentosVendasLinhas.IDDocumentoVenda
INNER JOIN tbClientes AS tbClientes with (nolock) ON tbClientes.id=tbDocumentosVendas.IDentidade
INNER JOIN tbLojas AS tbLojas with (nolock) ON tbLojas.id=tbDocumentosVendas.IDLoja
INNER JOIN tbEstados as tbEstados with (nolock) ON tbEstados.ID=tbdocumentosVendas.IDEstado
INNER JOIN tbsistematiposestados as tbsistematiposestados with (nolock) ON tbsistematiposestados.ID=tbEstados.IDtipoEstado
INNER JOIN tbMoedas as tbMoedas with (nolock) ON tbMoedas.ID=tbDocumentosVendas.IDMoeda
INNER JOIN tbTiposDocumento AS tbTiposDocumento with (nolock) ON tbTiposDocumento.ID=tbDocumentosVendas.IDTipoDocumento AND not tbTiposDocumento.idsistematiposdocumentofiscal is null 
INNER JOIN tbSistemaNaturezas AS tbSistemaNaturezas with (nolock) ON tbTiposDocumento.IDSistemaNaturezas=tbSistemaNaturezas.ID
INNER JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeries with (nolock) ON tbTiposDocumentoSeries.ID=tbDocumentosVendas.IDTiposDocumentoSeries
INNER JOIN tbSistemaTiposDocumento AS tbSistemaTiposDocumento with (nolock) ON tbTiposDocumento.IDSistemaTiposDocumento=tbSistemaTiposDocumento.ID
LEFT JOIN tbSistemaTiposDocumentoFiscal AS tbSistemaTiposDocumentoFiscal with (nolock) ON tbSistemaTiposDocumentoFiscal.ID=tbTiposDocumento.IDSistemaTiposDocumentoFiscal
INNER JOIN tbIVA AS tbIVA  with (nolock) ON tbDocumentosVendasLinhas.IDtaxaiva=tbIVA.ID
LEFT JOIN tbCampanhas with (nolock) ON tbDocumentosVendasLinhas.IDCampanha=tbCampanhas.ID
LEFT JOIN tbsistematiposiva as tbsistematiposiva on tbDocumentosVendasLinhas.IDTipoIva=tbsistematiposiva.id
WHERE tbsistematiposestados.codigo<>''RSC'' and tbSistemaTiposDocumento.Tipo=''VndFinanceiro'' and tbSistemaTiposDocumentoFiscal.Tipo<>''NF''
GROUP BY tbDocumentosVendas.ID, tbDocumentosVendas.IDLoja, tbDocumentosVendas.NomeFiscal, tbDocumentosVendas.IDEntidade, tbDocumentosVendas.IDTipoDocumento, tbDocumentosVendas.IDTiposDocumentoSeries, tbDocumentosVendas.NumeroDocumento,
tbDocumentosVendas.DataDocumento, tbDocumentosVendas.Documento, tbDocumentosVendas.IDMoeda, tbDocumentosVendas.TaxaConversao, tbDocumentosVendas.Ativo, tbDocumentosVendasLinhas.TaxaIva, tbDocumentosVendasLinhas.IDTaxaIva,
tbLojas.Codigo, tbLojas.Descricao, tbClientes.Codigo, tbClientes.Nome, tbClientes.NContribuinte, tbTiposDocumento.Codigo, tbDocumentosVendas.UtilizadorCriacao, 
(case when tbSistemaNaturezas.Codigo=''P'' then ''Crédito'' else ''Débito'' end), 
tbSistemaNaturezas.Codigo, tbCampanhas.Codigo, tbsistematiposestados.codigo,tbsistematiposestados.Descricao, tbTiposDocumento.Codigo, tbTiposDocumento.Descricao, tbsistematiposiva.Codigo, tbMoedas.Descricao, tbMoedas.Simbolo, tbMoedas.CasasDecimaisTotais, tbMoedas.TaxaConversao
ORDER BY tbDocumentosVendas.ID OFFSET 0 ROWS ')

--mapa de iva de compras
EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwMapaIvaCompras'')) drop view vwMapaIvaCompras')

EXEC('create view [dbo].[vwMapaIvaCompras] as
select top 100 percent
tbDocumentosCompras.ID, 
tbDocumentosCompras.IDLoja, 
tbDocumentosCompras.NomeFiscal, 
tbDocumentosCompras.IDEntidade, 
tbDocumentosCompras.IDTipoDocumento, 
tbDocumentosCompras.IDTiposDocumentoSeries, 
tbDocumentosCompras.NumeroDocumento, 
tbDocumentosCompras.DataDocumento,
tbDocumentosCompras.UtilizadorCriacao as Utilizador,
tbDocumentosCompras.Documento, 
tbDocumentosCompras.IDMoeda, 
tbDocumentosCompras.TaxaConversao, 
tbDocumentosCompras.Ativo as Ativo, 
tbDocumentosComprasLinhas.TaxaIva, 
tbDocumentosComprasLinhas.IDTaxaIva, 
tbLojas.Codigo as CodigoLoja, 
tbLojas.Descricao as DescricaoLoja,
tbFornecedores.Codigo as CodigoFornecedor, 
tbFornecedores.NContribuinte as NContribuinte, 
tbTiposDocumento.Codigo as CodigoTipoDocumento, 
tbTiposDocumento.Descricao as DescricaoTipoDocumento,
(case when tbsistematiposiva.Codigo =''OUT'' then ''NOR'' else  tbsistematiposiva.Codigo end) as CodigoIva, 
tbSistemaTiposEstados.Codigo as Estado,
tbsistematiposestados.descricao as DescricaoEstado,
(case when tbSistemaNaturezas.Codigo=''P'' then ''Crédito'' else ''Débito'' end) as Natureza,
(case when tbsistematiposestados.codigo=''EFT'' then 1 else 0 end)*(case when tbSistemaTiposEstados.Codigo=''ANL'' then 0 when tbSistemaNaturezas.Codigo=''R'' then -1 else 1 end)*sum(tbDocumentosComprasLinhas.ValorIncidencia) as ValorIncidencia,
(case when tbsistematiposestados.codigo=''EFT'' then 1 else 0 end)*(case when tbSistemaTiposEstados.Codigo=''ANL'' then 0 when tbSistemaNaturezas.Codigo=''R'' then -1 else 1 end)*sum(tbDocumentosComprasLinhas.ValorIVA) as ValorIVA,
(case when tbsistematiposestados.codigo=''EFT'' then 1 else 0 end)*(case when tbSistemaTiposEstados.Codigo=''ANL'' then 0 when tbSistemaNaturezas.Codigo=''R'' then -1 else 1 end)*sum(tbDocumentosComprasLinhas.ValorIncidencia + tbDocumentosComprasLinhas.ValorIVA) as Valor,
tbMoedas.Simbolo as tbMoedas_Simbolo, 
tbMoedas.CasasDecimaisTotais as tbMoedas_CasasDecimaisTotais
FROM tbDocumentosCompras AS tbDocumentosCompras
INNER JOIN tbDocumentosComprasLinhas AS tbDocumentosComprasLinhas ON tbDocumentosCompras.id=tbDocumentosComprasLinhas.IDDocumentoCompra
INNER JOIN tbFornecedores AS tbFornecedores with (nolock) ON tbFornecedores.id=tbDocumentosCompras.IDentidade
INNER JOIN tbLojas AS tbLojas with (nolock) ON tbLojas.id=tbDocumentosCompras.IDLoja
INNER JOIN tbMoedas as tbMoedas with (nolock) ON tbMoedas.ID=tbDocumentosCompras.IDMoeda
INNER JOIN tbTiposDocumento AS tbTiposDocumento with (nolock) ON tbTiposDocumento.ID=tbDocumentosCompras.IDTipoDocumento AND not tbTiposDocumento.idsistematiposdocumentofiscal is null 
INNER JOIN tbSistemaNaturezas AS tbSistemaNaturezas with (nolock) ON tbTiposDocumento.IDSistemaNaturezas=tbSistemaNaturezas.ID
INNER JOIN tbTiposDocumentoSeries AS tbTiposDocumentoSeries with (nolock) ON tbTiposDocumentoSeries.ID=tbDocumentosCompras.IDTiposDocumentoSeries
INNER JOIN tbSistemaTiposDocumento AS tbSistemaTiposDocumento with (nolock) ON tbTiposDocumento.IDSistemaTiposDocumento=tbSistemaTiposDocumento.ID
INNER JOIN tbIVA AS tbIVA  with (nolock) ON tbDocumentosComprasLinhas.IDtaxaiva=tbIVA.ID
INNER JOIN tbestados AS tbestados with (nolock) ON tbDocumentosCompras.IDEstado=tbEstados.ID
INNER JOIN tbSistemaTiposEstados AS tbSistemaTiposEstados with (nolock) ON tbEstados.IDTipoEstado=tbSistemaTiposEstados.ID
LEFT JOIN tbsistematiposiva as tbsistematiposiva on tbDocumentosComprasLinhas.IDTipoIva=tbsistematiposiva.id
WHERE tbsistematiposestados.codigo=''EFT'' and tbSistemaTiposDocumento.Tipo=''CmpFinanceiro''
GROUP BY tbDocumentosCompras.ID, tbDocumentosCompras.IDLoja, tbDocumentosCompras.NomeFiscal, tbDocumentosCompras.IDEntidade, tbDocumentosCompras.IDTipoDocumento, tbDocumentosCompras.IDTiposDocumentoSeries, tbDocumentosCompras.NumeroDocumento,
tbDocumentosCompras.DataDocumento, tbDocumentosCompras.Documento, tbDocumentosCompras.IDMoeda, tbDocumentosCompras.TaxaConversao, tbDocumentosCompras.Ativo, tbDocumentosComprasLinhas.TaxaIva, tbDocumentosComprasLinhas.IDTaxaIva,
tbLojas.Codigo, tbLojas.Descricao, tbFornecedores.Codigo, tbFornecedores.Nome, tbFornecedores.NContribuinte, tbTiposDocumento.Codigo,tbDocumentosCompras.UtilizadorCriacao,
(case when tbSistemaNaturezas.Codigo=''P'' then ''Crédito'' else ''Débito'' end), tbSistemaTiposEstados.Codigo, tbSistemaNaturezas.Codigo, tbsistematiposestados.codigo, tbsistematiposestados.Descricao, tbTiposDocumento.Codigo, tbTiposDocumento.Descricao, 
tbsistematiposiva.Codigo,tbMoedas.Descricao, tbMoedas.Simbolo, tbMoedas.CasasDecimaisTotais, tbMoedas.TaxaConversao
ORDER BY tbDocumentosCompras.ID ')

--mapa de conta corrente de clientes
EXEC('IF (EXISTS (SELECT 1 FROM sys.views WHERE name = ''vwCCClientes'')) drop view vwCCClientes')

EXEC('create view [dbo].[vwCCClientes] as
select top 100 percent
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
ORDER BY tbCCEntidades.DataDocumento, tbCCEntidades.DataCriacao, tbCCEntidades.IDTipoDocumento ')

--atualização do sp_atualizastock
EXEC('IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[sp_AtualizaStock]'') AND type in (N''P'', N''PC'')) DROP PROCEDURE [sp_AtualizaStock]')

EXEC('CREATE PROCEDURE [dbo].[sp_AtualizaStock]  
	@lngidDocumento AS bigint = NULL,
	@lngidTipoDocumento AS bigint = NULL,
	@intAccao AS int = 0,
	@strTabelaCabecalho AS nvarchar(250) = '''', 
	@strTabelaLinhas AS nvarchar(250) = '''',
	@strTabelaLinhasDist AS nvarchar(250) = '''',
	@strCampoRelTabelaLinhasCab AS nvarchar(100) = '''',
	@strCampoRelTabelaLinhasDistLinhas AS nvarchar(100) = '''',
	@strUtilizador AS nvarchar(256) = '''',
	@inValidaStock AS bit,
	@inRecalculoTotal AS bit=0
AS  BEGIN
SET NOCOUNT ON

DECLARE @strSqlQuery AS varchar(max),--variavel para query''s dinamicos
	@strSqlQueryAux AS varchar(max),--variavel para query''s dinamicos
	@strSqlQueryUpdates AS varchar(max),--variavel para query''s dinamicos
	@strSqlQueryInsert AS varchar(max),--varivale para a parte do insert
	@paramList AS nvarchar(max),--variavel para usar quando necessitamos de carregar para as variaveis parametros/colunas comquery''s dinamicas
	@strNatureza AS nvarchar(15) = NULL,
	@strNaturezaStock AS nvarchar(15) = NULL,
	@strNaturezaaux AS nvarchar(15) = NULL,
	@strNaturezaBase AS nvarchar(15) = ''[#F3MNAT#]'',
	@strModulo AS nvarchar(50),
	@strTipoDocInterno AS nvarchar(50),
	@cModuloStocks AS nvarchar(3) =''001'',
	@strCodMovStock AS nvarchar(10) = NULL,
	@strQueryQuantidades AS nvarchar(2500) = NULL,
	@strQueryPrecoUnitarios AS nvarchar(2500) = NULL,
	@strQueryLeftJoinDist AS nvarchar(256) = '' '',
	@strQueryLeftJoinDistUpdates AS nvarchar(256) = '' '',
	@strQueryWhereDistUpdates AS nvarchar(max) = '''',
	@strQueryCamposDistUpdates AS nvarchar(1024) = '''',
	@strQueryWhereDistUpdates1 AS nvarchar(1024) = '''',
	@strQueryCamposDistUpdates1 AS nvarchar(1024) = '''',
	@strQueryGroupbyDistUpdates AS nvarchar(1024) = '''',
	@strQueryONDist AS nvarchar(1024) = '''',
	@strQueryDocsAtras AS nvarchar(4000) = '''',
	@strQueryDocsAFrente AS nvarchar(4000) = '''',
	@strQueryDocsUpdates AS varchar(max),
	@strQueryDocsUpdatesaux AS varchar(max),
	@strQueryWhereFrente AS nvarchar(1024) = '''',
	@strArmazensCodigo AS nvarchar(100) = ''[#F3M-TRANSF-F3M#]'',
	@strArmazem AS nvarchar(200) = ''Linhas.IDArmazem, Linhas.IDArmazemLocalizacao, '',
	@strArmazensDestino AS nvarchar(200) = ''Linhas.IDArmazemDestino, Linhas.IDArmazemLocalizacaoDestino, '',
	@strTransFControlo AS nvarchar(256) = ''[#F3M-QTDSTRANSF-F3M#]'',
	@strTransFSaida AS nvarchar(1024) = '''',
	@strTransFEntrada AS nvarchar(1024) = '''',
    @strArtigoDimensao AS nvarchar(100) = ''NULL AS IDArtigoDimensao, '',
	@inLimitMax as tinyint,--1 ignora, 2 avisa, 3 bloqueia
    @inLimitMin as tinyint,
    @inRutura as tinyint,
	@inLimitMaxDel as tinyint,--1 ignora, 2 avisa, 3 bloqueia
    @inLimitMinDel as tinyint,
    @inRuturaDel as tinyint,
	@ErrorMessage   varchar(2000),
	@ErrorSeverity  tinyint,
	@ErrorState     tinyint,
	@rowcount INT,
	@strQueryOrdenacao AS nvarchar(1024) = '''',
	@strWhereQuantidades AS nvarchar(1500) = NULL

BEGIN TRY
	--Verificar se o tipo de documento gere Stock, caso não gere stock não faz nada
	IF EXISTS(SELECT ID FROM tbTiposDocumento WHERE ISNULL(GereStock,0)<>0 AND ID=@lngidTipoDocumento)
		BEGIN
		  	--Calcular a Natureza do stock a registar, para tal carregar o Modulo e o Tipo Doc para vermos o tipo de movimento , se é S ou E ou NM-não movimenta
			SELECT @strModulo = M.Codigo,  @strTipoDocInterno = STD.Tipo, @strCodMovStock = TDMS.Codigo,  
			       @inRutura = Cast(AcaoRutura.Codigo as tinyint), @inLimitMax = CAST(AcaoLimiteMax.Codigo as tinyint), @inLimitMin = CAST(AcaoLimiteMin.Codigo AS tinyint)
			FROM tbTiposDocumento TD
			LEFT JOIN tbSistemaModulos M ON M.ID = TD.IDModulo
			LEFT JOIN tbSistemaTiposDocumento STD ON STD.ID = TD.IDSistemaTiposDocumento
			LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TD.IDSistemaTiposDocumentoMovStock
			LEFT JOIN tbSistemaAcoes as AcaoRutura ON AcaoRutura.id=TD.IDSistemaAcoesRupturaStock
			LEFT JOIN tbSistemaAcoes as AcaoLimiteMax ON AcaoLimiteMax.id=TD.IDSistemaAcoesStockMaximo
			LEFT JOIN tbSistemaAcoes as AcaoLimiteMin ON AcaoLimiteMin.id=TD.IDSistemaAcoesStockMinimo
			WHERE ISNULL(TD.GereStock,0)<>0 AND TD.ID=@lngidTipoDocumento
			IF NOT @strCodMovStock IS NULL	--qtds positivas	
				BEGIN
					SET @strNatureza =
					CASE @strCodMovStock
						WHEN ''001'' THEN NULL --não movimenta
						WHEN ''002'' THEN ''E''
						WHEN ''003'' THEN ''S''
						WHEN ''004'' THEN ''[#F3MN#F3M]''--transferencia ??? so deve existir nos stocks para os tipos StkTrfArmazCTrans,StkTrfArmazSTrans e StkTransfArtComp
						WHEN ''005'' THEN NULL--?vazio
						WHEN ''006'' THEN ''R''
						WHEN ''007'' THEN ''LR''
					END
				END
			IF NOT @strNatureza IS NULL --se a natureza <> NULL então entra para tratar ccstock
				BEGIN
				    SET @strNaturezaStock = @strNatureza
				    --apaga registos caso existam da de validação de stock
				    DELETE FROM tbControloValidacaoStock WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento
					--atualiza variaveis de validação de stock do apagar e trata de acordo com a natureza as var do adiccionar e alterar
					SET @inRuturaDel = @inRutura
					SET @inLimitMinDel = @inLimitMin
					SET @inLimitMaxDel = @inLimitMax
					IF  @strNatureza = ''E'' OR @strNatureza = ''LR''
						BEGIN
							SET @inRutura = 1--ignora
							SET @inLimitMin = 1--ignora
						END
					IF  @strNatureza = ''S'' OR @strNatureza = ''R''
						BEGIN
							SET @inLimitMax = 1--ignora
						END
					--verificar se é apagar a acao e atribuir as var do delete e retirar os do insert/update e delete
					IF (@intAccao = 2) 
						BEGIN
						    SET @inRutura = 1--ignora
							SET @inLimitMin = 1--ignora
							SET @inLimitMax = 1--ignora
							IF  @strNatureza = ''E'' OR @strNatureza = ''LR''
								BEGIN
								    SET @inLimitMaxDel = 1--ignora
								
								END
							IF  @strNatureza = ''S'' OR @strNatureza = ''R''
								BEGIN
							    	SET @inRuturaDel = 1--ignora
									SET @inLimitMinDel = 1--ignora
								END

					    END
					

					SET @strNaturezaaux = @strNatureza
					IF  @strNaturezaaux IS NULL 
						BEGIN
							SET @strNaturezaaux=''''
						END
					--Prepara variaveis a concatenar à query das quantidades / Preços, pois se tem dist, teremos de estar preparados para registos na dist
					IF  len(@strTabelaLinhasDist)>0
						BEGIN
						    
						    SET @strQueryOrdenacao ='' ORDER BY Linhas.Ordem asc, LinhasDist.Ordem asc ''
							
							IF  @strNaturezaaux = ''R''  OR  @strNaturezaaux = ''LR''
								BEGIN
									SET @strQueryQuantidades = ''0 AS Quantidade, 
																 0 as QuantidadeStock, 
																 0 as QuantidadeStock2, 
																 ABS(Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QuantidadeStock,0) ELSE ISNULL(LinhasDist.QuantidadeStock,0) END) AS QtdStockReserva, 
																 ABS(Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QuantidadeStock2,0) ELSE ISNULL(LinhasDist.QuantidadeStock2,0) END) AS QtdStockReserva2Uni, 
														'' + @strTransFControlo + '' 
														,ABS(Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QtdAfetacaoStock,0) ELSE ISNULL(LinhasDist.QtdAfetacaoStock,0) END) as QtdAfetacaoStock, 
														ABS(Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QtdAfetacaoStock2,0) ELSE ISNULL(LinhasDist.QtdAfetacaoStock2,0) END) as QtdAfetacaoStock2, ''
								END
							ELSE
								BEGIN
								--depois aqui nos campos --StockReserva, StockReserva2Uni será o valor da linha, mas como ainda não colocaste fica 0-QtdStockReserva, QtdStockReserva2Uni
									SET @strQueryQuantidades = ''ABS(Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.Quantidade,0) ELSE ISNULL(LinhasDist.Quantidade,0) END) AS Quantidade, 
														ABS(Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QuantidadeStock,0) ELSE ISNULL(LinhasDist.QuantidadeStock,0) END) as QuantidadeStock, 
													    ABS(Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QuantidadeStock2,0) ELSE ISNULL(LinhasDist.QuantidadeStock2,0) END) as QuantidadeStock2, 
														ABS(Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QtdStockReserva,0) ELSE ISNULL(LinhasDist.QtdStockReserva,0) END) AS QtdStockReserva, 
														ABS(Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QtdStockReserva2Uni,0) ELSE ISNULL(LinhasDist.QtdStockReserva2Uni,0) END) AS QtdStockReserva2Uni, 
														'' + @strTransFControlo + '' 
														,ABS(Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QtdAfetacaoStock,0) ELSE ISNULL(LinhasDist.QtdAfetacaoStock,0) END) as QtdAfetacaoStock, 
														ABS(Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QtdAfetacaoStock2,0) ELSE ISNULL(LinhasDist.QtdAfetacaoStock2,0) END) as QtdAfetacaoStock2, ''
								END
													
													     
							SET @strTransFSaida  = ''Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QtdStockAnterior,0) ELSE ISNULL(LinhasDist.QtdStockAnterior,0) END as QtdStockAnterior, Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QtdStockAtual,0) ELSE ISNULL(LinhasDist.QtdStockAtual,0) END as QtdStockAtual ''
							SET @strTransFEntrada = ''Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QtdStockAnterior,0) - ISNULL(Linhas.QuantidadeStock,0)  ELSE ISNULL(LinhasDist.QtdStockAnterior,0) - ISNULL(LinhasDist.QuantidadeStock,0) END as QtdStockAnterior, Case WHEN LinhasDist.ID IS NULL THEN ISNULL(Linhas.QtdStockAtual,0) + ISNULL(Linhas.QuantidadeStock,0) ELSE ISNULL(LinhasDist.QtdStockAtual,0) + ISNULL(LinhasDist.QuantidadeStock,0) END as QtdStockAtual ''


							SET @strQueryPrecoUnitarios = ''Case WHEN LinhasDist.ID IS NULL THEN Linhas.PrecoUnitario ELSE LinhasDist.PrecoUnitario END AS PrecoUnitario, 
															Case WHEN LinhasDist.ID IS NULL THEN Linhas.PrecoUnitarioEfetivo ELSE LinhasDist.PrecoUnitarioEfetivo END AS PrecoUnitarioEfetivo, 
															Case WHEN LinhasDist.ID IS NULL THEN Linhas.PrecoUnitarioMoedaRef ELSE LinhasDist.PrecoUnitarioMoedaRef END AS PrecoUnitarioMoedaRef, 
															Case WHEN LinhasDist.ID IS NULL THEN Linhas.PrecoUnitarioEfetivoMoedaRef ELSE LinhasDist.PrecoUnitarioEfetivoMoedaRef END AS PrecoUnitarioEfetivoMoedaRef, 
															Case WHEN LinhasDist.ID IS NULL THEN Linhas.UPCMoedaRef ELSE LinhasDist.UPCMoedaRef END AS UPCMoedaRef, 
															Case WHEN LinhasDist.ID IS NULL THEN Linhas.PCMAnteriorMoedaRef ELSE LinhasDist.PCMAnteriorMoedaRef END AS PCMAnteriorMoedaRef, 
															Case WHEN LinhasDist.ID IS NULL THEN Linhas.PCMAtualMoedaRef ELSE LinhasDist.PCMAtualMoedaRef END AS PCMAtualMoedaRef, 
															Case WHEN LinhasDist.ID IS NULL THEN Linhas.PVMoedaRef ELSE LinhasDist.PVMoedaRef END AS PVMoedaRef, 
															Case WHEN LinhasDist.ID IS NULL THEN Linhas.UPCompraMoedaRef ELSE LinhasDist.UPCompraMoedaRef END AS UPCompraMoedaRef, 
															Case WHEN LinhasDist.ID IS NULL THEN Linhas.UltCustosAdicionaisMoedaRef ELSE LinhasDist.UltCustosAdicionaisMoedaRef END AS UltCustosAdicionaisMoedaRef, 
															Case WHEN LinhasDist.ID IS NULL THEN Linhas.UltDescComerciaisMoedaRef ELSE LinhasDist.UltDescComerciaisMoedaRef END AS UltDescComerciaisMoedaRef, 
															''
							
							SET @strQueryLeftJoinDist = '' LEFT JOIN '' + QUOTENAME(@strTabelaLinhasDist) + '' AS LinhasDist ON LinhasDist.'' + @strCampoRelTabelaLinhasDistLinhas + '' = Linhas.ID ''
							SET @strArtigoDimensao = ''LinhasDist.IDArtigoDimensao AS IDArtigoDimensao, ''
						END
					ELSE
						BEGIN
						    SET @strQueryOrdenacao ='' ORDER BY Linhas.Ordem asc ''
							
								IF  @strNaturezaaux = ''R''  OR  @strNaturezaaux = ''LR''
									BEGIN
										SET @strQueryQuantidades = ''0 AS Quantidade, 0 AS QuantidadeStock, 0 AS QuantidadeStock2, ABS(ISNULL(Linhas.QuantidadeStock,0)) AS QtdStockReserva, ABS(ISNULL(Linhas.QuantidadeStock2,0)) AS QtdStockReserva2Uni, 
														'' + @strTransFControlo + '' , ABS(ISNULL(Linhas.QtdAfetacaoStock,0)) AS QtdAfetacaoStock, ABS(ISNULL(Linhas.QtdAfetacaoStock2,0)) AS QtdAfetacaoStock2, ''
									
									END
								else
									BEGIN
										SET @strQueryQuantidades = ''ABS(ISNULL(Linhas.Quantidade,0)) AS Quantidade, ABS(ISNULL(Linhas.QuantidadeStock,0)) AS QuantidadeStock, ABS(ISNULL(Linhas.QuantidadeStock2,0)) AS QuantidadeStock2, ABS(ISNULL(Linhas.QtdStockReserva,0)) AS QtdStockReserva, ABS(ISNULL(Linhas.QtdStockReserva2Uni,0)) AS QtdStockReserva2Uni, 
														'' + @strTransFControlo + '' , ABS(ISNULL(Linhas.QtdAfetacaoStock,0)) AS QtdAfetacaoStock, ABS(ISNULL(Linhas.QtdAfetacaoStock2,0)) AS QtdAfetacaoStock2, ''
									END
							
							
							


							SET @strTransFSaida  = ''ISNULL(Linhas.QtdStockAnterior,0) AS QtdStockAnterior, ISNULL(Linhas.QtdStockAtual,0) AS QtdStockAtual ''
							SET @strTransFEntrada = ''ISNULL(Linhas.QtdStockAnterior,0) - ISNULL(Linhas.QuantidadeStock,0) AS QtdStockAnterior, ISNULL(Linhas.QtdStockAtual,0) + ISNULL(Linhas.QuantidadeStock,0) AS QtdStockAtual ''
														
							
							
							SET @strQueryPrecoUnitarios = ''Linhas.PrecoUnitario AS PrecoUnitario, Linhas.PrecoUnitarioEfetivo AS PrecoUnitarioEfetivo, Linhas.PrecoUnitarioMoedaRef AS PrecoUnitarioMoedaRef,
													    Linhas.PrecoUnitarioEfetivoMoedaRef AS PrecoUnitarioEfetivoMoedaRef, Linhas.UPCMoedaRef AS UPCMoedaRef, 
														Linhas.PCMAnteriorMoedaRef AS PCMAnteriorMoedaRef, Linhas.PCMAtualMoedaRef AS PCMAtualMoedaRef, Linhas.PVMoedaRef AS PVMoedaRef, 
														Linhas.UPCompraMoedaRef AS UPCompraMoedaRef, Linhas.UltCustosAdicionaisMoedaRef AS UltCustosAdicionaisMoedaRef, Linhas.UltDescComerciaisMoedaRef AS UltDescComerciaisMoedaRef, 
														 ''
						
						END
					--Preparação das Query''s para adicionar e só interessa se ação for adicionar ou alterar na parte seguinte
					IF (@intAccao = 0 OR @intAccao = 1) 
						BEGIN 
							IF (@strTipoDocInterno = ''StkContagemStock'')
								BEGIN 
									SET @strQueryQuantidades = '' ABS(ISNULL(Linhas.QuantidadeDiferenca,0)) AS Quantidade, ABS(ISNULL(Linhas.QuantidadeDiferenca,0)) AS QuantidadeStock, 0 AS QuantidadeStock2, 0 AS QtdStockReserva, 0 AS QtdStockReserva2Uni, 
													 0 AS QtdStockAnterior, 0 AS QtdStockAtual, 0 AS QtdAfetacaoStock, 0 AS QtdAfetacaoStock2, ''

									SET @strTransFSaida  = ''0 AS QtdStockAnterior, 0 AS QtdStockAtual ''
									SET @strTransFEntrada = ''0 AS QtdStockAnterior, 0 AS QtdStockAtual ''

									SET @strQueryPrecoUnitarios = ''Linhas.PrecoUnitario AS PrecoUnitario, Linhas.PrecoUnitario AS PrecoUnitarioEfetivo, Linhas.PrecoUnitario AS PrecoUnitarioMoedaRef,
													    Linhas.PrecoUnitario AS PrecoUnitarioEfetivoMoedaRef, Linhas.PrecoUnitario AS UPCMoedaRef, 
														Linhas.PrecoUnitario AS PCMAnteriorMoedaRef, Linhas.PrecoUnitario AS PCMAtualMoedaRef, 0 AS PVMoedaRef, 
														Linhas.PrecoUnitario AS UPCompraMoedaRef, 0 AS UltCustosAdicionaisMoedaRef, 0 AS UltDescComerciaisMoedaRef, 
														 ''
									SET @strArmazem = ''CAB.IDArmazem, CAB.IDLocalizacao, ''

									SET @paramList = N''@lngidDocumento1 bigint''
									SET @strWhereQuantidades = '' ABS(ISNULL(Linhas.QuantidadeDiferenca,0))>0 and (TDQPos.Codigo=''''002'''' OR TDQPos.Codigo=''''003'''' OR TDQPos.Codigo=''''004'''' OR TDQPos.Codigo=''''006'''' OR TDQPos.Codigo=''''007'''') ''
									SET @strSqlQueryInsert = ''INSERT INTO tbCCStockArtigos (Natureza, IDArtigo, IDArtigoPA, IDArtigoPara, Descricao, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie,
															IDArtigoDimensao, IDMoeda, IDTipoEntidade, IDEntidade, IDTipoDocumento, IDDocumento, IDLinhaDocumento, NumeroDocumento, DataControloInterno, IDTipoDocumentoOrigem,
															IDDocumentoOrigem, IDLinhaDocumentoOrigem, IDTipoDocumentoOrigemInicial, IDDocumentoOrigemInicial, IDLinhaDocumentoOrigemInicial, DocumentoOrigemInicial, 
															Quantidade, QuantidadeStock, QuantidadeStock2, QtdStockReserva, QtdStockReserva2Uni, QtdStockAnterior, QtdStockAtual, QtdAfetacaoStock, QtdAfetacaoStock2, PrecoUnitario, PrecoUnitarioEfetivo, PrecoUnitarioMoedaRef, PrecoUnitarioEfetivoMoedaRef, UPCMoedaRef, 
															PCMAnteriorMoedaRef, PCMAtualMoedaRef, PVMoedaRef, UPCompraMoedaRef, UltCustosAdicionaisMoedaRef, UltDescComerciaisMoedaRef, Recalcular, DataDocumento, TaxaConversao, Ativo, Sistema, DataCriacao, UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao, VossoNumeroDocumento, VossoNumeroDocumentoOrigem, NumeroDocumentoOrigem, IDTiposDocumentoSeries, IDTiposDocumentoSeriesOrigem) ''
									SELECT @strSqlQuery = @strSqlQueryInsert + ''
															SELECT (case when Linhas.QuantidadeDiferenca>0 then ''''E'''' when Linhas.QuantidadeDiferenca<0 then ''''S'''' else '''''''' end) AS Natureza, Linhas.IDArtigo, NULL as IDArtigoPA, NULL as IDArtigoPara, Linhas.DescricaoArtigo, Cab.IDLoja, '' + @strArmazem + '' Linhas.IDLote AS IDArtigoLote, 
															NULL AS IDArtigoNumeroSerie, '' + @strArtigoDimensao + '' 
															Cab.IDMoeda, NULL as IDTipoEntidade, NULL as IDEntidade, Cab.IDTipoDocumento, Cab.ID as IDDocumento, Linhas.id as IDLinhaDocumento, Cab.NumeroDocumento, dateadd(d, datediff(d, 0, Cab.DataDocumento), cast(''''23:59:59'''' as datetime)) AS DataControloInterno, 
															NULL as IDTipoDocumentoOrigem, NULL as IDDocumentoOrigem, NULL as IDLinhaDocumentoOrigem,
															NULL as IDTipoDocumentoOrigemInicial, NULL as IDDocumentoOrigemInicial, NULL as IDLinhaDocumentoOrigemInicial, NULL as DocumentoOrigemInicial,  
															'' + @strQueryQuantidades + @strQueryPrecoUnitarios + ''isnull(Linhas.Alterada,0) AS Recalcular, dateadd(d, datediff(d, 0, Cab.DataDocumento), cast(''''23:59:59'''' as datetime)) AS DataDocumento, Cab.TaxaConversao, 1 AS Ativo, 1 AS Sistema, Cab.DataCriacao, '''''' + @strUtilizador + '''''' AS UtilizadorCriacao,
															Cab.DataAlteracao, '''''' + @strUtilizador + '''''' AS UtilizadorAlteracao, NULL as VossoNumeroDocumento, NULL as VossoNumeroDocumentoOrigem, NULL as NumeroDocumentoOrigem, Cab.IDTiposDocumentoSeries, NULL as IDTiposDocumentoSeriesOrigem
															FROM '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab 
															LEFT JOIN '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas ON Linhas.'' + @strCampoRelTabelaLinhasCab + '' = Cab.ID 
															LEFT JOIN tbArtigos AS Art ON Art.ID = Linhas.IDArtigo '' + 
															@strQueryLeftJoinDist + 
															''LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  Cab.IDTipoDocumento
															LEFT JOIN tbSistemaTiposDocumentoMovStock TDQPos ON TDQPos.id=TpDoc.IDSistemaTiposDocumentoMovStock
															WHERE Cab.ID='' + Convert(nvarchar,@lngidDocumento) + '' AND ISNULL(Art.GereStock,0) <> 0 AND NOT Linhas.IDArtigo IS NULL
															AND '' +
															@strWhereQuantidades  + @strQueryOrdenacao

									print @strSqlQuery
								END

							ELSE IF (@strTipoDocInterno = ''SubstituicaoArtigos'')
								BEGIN

									--entrada de artigos
									SET @strQueryQuantidades = '' ABS(ISNULL(Linhas.Quantidade,0)) AS Quantidade, ABS(ISNULL(LinhasSub.Quantidade,0)) AS QuantidadeStock, 0 AS QuantidadeStock2, 0 AS QtdStockReserva, 0 AS QtdStockReserva2Uni, 
													 0 AS QtdStockAnterior, 0 AS QtdStockAtual, 0 AS QtdAfetacaoStock, 0 AS QtdAfetacaoStock2, ''

									SET @strTransFSaida  = ''0 AS QtdStockAnterior, 0 AS QtdStockAtual ''
									SET @strTransFEntrada = ''0 AS QtdStockAnterior, 0 AS QtdStockAtual ''

									SET @strQueryPrecoUnitarios = ''isnull(Art.Medio,0) AS PrecoUnitario, isnull(Art.Medio,0) AS PrecoUnitarioEfetivo, isnull(Art.Medio,0) AS PrecoUnitarioMoedaRef,
													    isnull(Art.Medio,0) AS PrecoUnitarioEfetivoMoedaRef, isnull(Art.Medio,0) AS UPCMoedaRef, 
														isnull(Art.Medio,0) AS PCMAnteriorMoedaRef, isnull(Art.Medio,0) AS PCMAtualMoedaRef, 0 AS PVMoedaRef, 
														isnull(Art.Medio,0) AS UPCompraMoedaRef, 0 AS UltCustosAdicionaisMoedaRef, 0 AS UltDescComerciaisMoedaRef, 
														 ''
									SET @strArmazem = ''LinhasSub.IDArmazem, LinhasSub.IDArmazemLocalizacao,''

									SET @paramList = N''@lngidDocumento1 bigint''
									
									SET @strWhereQuantidades = '' (TDQPos.Codigo=''''002'''' OR TDQPos.Codigo=''''003'''' OR TDQPos.Codigo=''''004'''' OR TDQPos.Codigo=''''006'''' OR TDQPos.Codigo=''''007'''') ''

									SET @strSqlQueryInsert = ''INSERT INTO tbCCStockArtigos (Natureza, IDArtigo, IDArtigoPA, IDArtigoPara, Descricao, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie,
															IDArtigoDimensao, IDMoeda, IDTipoEntidade, IDEntidade, IDTipoDocumento, IDDocumento, IDLinhaDocumento, NumeroDocumento, DataControloInterno, IDTipoDocumentoOrigem,
															IDDocumentoOrigem, IDLinhaDocumentoOrigem, IDTipoDocumentoOrigemInicial, IDDocumentoOrigemInicial, IDLinhaDocumentoOrigemInicial, DocumentoOrigemInicial, 
															Quantidade, QuantidadeStock, QuantidadeStock2, QtdStockReserva, QtdStockReserva2Uni, QtdStockAnterior, QtdStockAtual, QtdAfetacaoStock, QtdAfetacaoStock2, PrecoUnitario, PrecoUnitarioEfetivo, PrecoUnitarioMoedaRef, PrecoUnitarioEfetivoMoedaRef, UPCMoedaRef, 
															PCMAnteriorMoedaRef, PCMAtualMoedaRef, PVMoedaRef, UPCompraMoedaRef, UltCustosAdicionaisMoedaRef, UltDescComerciaisMoedaRef, Recalcular, DataDocumento, TaxaConversao, Ativo, Sistema, DataCriacao, UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao, VossoNumeroDocumento, VossoNumeroDocumentoOrigem, NumeroDocumentoOrigem, IDTiposDocumentoSeries, IDTiposDocumentoSeriesOrigem) ''
									SELECT @strSqlQuery = @strSqlQueryInsert + ''
															SELECT ''''E'''' AS Natureza, Linhas.IDArtigo, NULL as IDArtigoPA, NULL as IDArtigoPara, Linhas.Descricao, Cab.IDLoja, '' + @strArmazem + '' Linhas.IDLote AS IDArtigoLote, 
															NULL AS IDArtigoNumeroSerie, '' + @strArtigoDimensao + '' 
															Cab.IDMoeda, cab.IDTipoEntidade, cab.IDEntidade, Cab.IDTipoDocumento, Cab.ID as IDDocumento, Linhas.id as IDLinhaDocumento, Cab.NumeroDocumento, dateadd(d, datediff(d, 0, Cab.DataDocumento), cast(''''23:59:59'''' as datetime)) AS DataControloInterno, 
															NULL as IDTipoDocumentoOrigem, NULL as IDDocumentoOrigem, NULL as IDLinhaDocumentoOrigem,
															NULL as IDTipoDocumentoOrigemInicial, NULL as IDDocumentoOrigemInicial, NULL as IDLinhaDocumentoOrigemInicial, NULL as DocumentoOrigemInicial,  
															'' + @strQueryQuantidades + @strQueryPrecoUnitarios + ''isnull(Linhas.Alterada,0) AS Recalcular, dateadd(d, datediff(d, 0, Cab.DataDocumento), cast(''''23:59:59'''' as datetime)) AS DataDocumento, Cab.TaxaConversao, 1 AS Ativo, 1 AS Sistema, Cab.DataCriacao, '''''' + @strUtilizador + '''''' AS UtilizadorCriacao,
															Cab.DataAlteracao, '''''' + @strUtilizador + '''''' AS UtilizadorAlteracao, NULL as VossoNumeroDocumento, NULL as VossoNumeroDocumentoOrigem, NULL as NumeroDocumentoOrigem, Cab.IDTiposDocumentoSeries, NULL as IDTiposDocumentoSeriesOrigem
															FROM '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab 
															LEFT JOIN '' + QUOTENAME(@strTabelaLinhas) + '' AS LinhasSub ON LinhasSub.'' + @strCampoRelTabelaLinhasCab + '' = Cab.ID 
															LEFT JOIN '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas ON LinhasSub.IDLinhaDocumentoOrigemInicial = Linhas.ID 
															LEFT JOIN tbArtigos AS Art ON Art.ID = Linhas.IDArtigo '' + 
															@strQueryLeftJoinDist + 
															''LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  Cab.IDTipoDocumento
															LEFT JOIN tbSistemaTiposDocumentoMovStock TDQPos ON TDQPos.id=TpDoc.IDSistemaTiposDocumentoMovStock
															WHERE Cab.ID='' + Convert(nvarchar,@lngidDocumento) + '' AND ISNULL(Art.GereStock,0) <> 0 AND NOT Linhas.IDArtigo IS NULL
															AND '' +
															@strWhereQuantidades  + @strQueryOrdenacao


									--saida de artigos
									SET @strQueryQuantidades = '' ABS(ISNULL(Linhas.Quantidade,0)) AS Quantidade, ABS(ISNULL(Linhas.Quantidade,0)) AS QuantidadeStock, 0 AS QuantidadeStock2, 0 AS QtdStockReserva, 0 AS QtdStockReserva2Uni, 
													 0 AS QtdStockAnterior, 0 AS QtdStockAtual, 0 AS QtdAfetacaoStock, 0 AS QtdAfetacaoStock2, ''

									SET @strTransFSaida  = ''0 AS QtdStockAnterior, 0 AS QtdStockAtual ''
									SET @strTransFEntrada = ''0 AS QtdStockAnterior, 0 AS QtdStockAtual ''

									SET @strQueryPrecoUnitarios = ''Linhas.PrecoUnitario AS PrecoUnitario, Linhas.PrecoUnitario AS PrecoUnitarioEfetivo, Linhas.PrecoUnitario AS PrecoUnitarioMoedaRef,
													    Linhas.PrecoUnitario AS PrecoUnitarioEfetivoMoedaRef, Linhas.PrecoUnitario AS UPCMoedaRef, 
														Linhas.PrecoUnitario AS PCMAnteriorMoedaRef, Linhas.PrecoUnitario AS PCMAtualMoedaRef, 0 AS PVMoedaRef, 
														Linhas.PrecoUnitario AS UPCompraMoedaRef, 0 AS UltCustosAdicionaisMoedaRef, 0 AS UltDescComerciaisMoedaRef, 
														 ''
									SET @strArmazem = ''Linhas.IDArmazem, linhas.IDArmazemLocalizacao,''

									SET @paramList = N''@lngidDocumento1 bigint''
									
									SET @strWhereQuantidades = '' (TDQPos.Codigo=''''002'''' OR TDQPos.Codigo=''''003'''' OR TDQPos.Codigo=''''004'''' OR TDQPos.Codigo=''''006'''' OR TDQPos.Codigo=''''007'''') ''

									SET @strSqlQueryInsert = ''INSERT INTO tbCCStockArtigos (Natureza, IDArtigo, IDArtigoPA, IDArtigoPara, Descricao, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie,
															IDArtigoDimensao, IDMoeda, IDTipoEntidade, IDEntidade, IDTipoDocumento, IDDocumento, IDLinhaDocumento, NumeroDocumento, DataControloInterno, IDTipoDocumentoOrigem,
															IDDocumentoOrigem, IDLinhaDocumentoOrigem, IDTipoDocumentoOrigemInicial, IDDocumentoOrigemInicial, IDLinhaDocumentoOrigemInicial, DocumentoOrigemInicial, 
															Quantidade, QuantidadeStock, QuantidadeStock2, QtdStockReserva, QtdStockReserva2Uni, QtdStockAnterior, QtdStockAtual, QtdAfetacaoStock, QtdAfetacaoStock2, PrecoUnitario, PrecoUnitarioEfetivo, PrecoUnitarioMoedaRef, PrecoUnitarioEfetivoMoedaRef, UPCMoedaRef, 
															PCMAnteriorMoedaRef, PCMAtualMoedaRef, PVMoedaRef, UPCompraMoedaRef, UltCustosAdicionaisMoedaRef, UltDescComerciaisMoedaRef, Recalcular, DataDocumento, TaxaConversao, Ativo, Sistema, DataCriacao, UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao, VossoNumeroDocumento, VossoNumeroDocumentoOrigem, NumeroDocumentoOrigem, IDTiposDocumentoSeries, IDTiposDocumentoSeriesOrigem) ''
									SELECT @strSqlQuery = @strSqlQuery + '';'' + @strSqlQueryInsert + ''
															SELECT ''''S'''' AS Natureza, Linhas.IDArtigo, NULL as IDArtigoPA, NULL as IDArtigoPara, Linhas.Descricao, Cab.IDLoja, '' + @strArmazem + '' Linhas.IDLote AS IDArtigoLote, 
															NULL AS IDArtigoNumeroSerie, '' + @strArtigoDimensao + '' 
															Cab.IDMoeda, cab.IDTipoEntidade, cab.IDEntidade, Cab.IDTipoDocumento, Cab.ID as IDDocumento, Linhas.id as IDLinhaDocumento, Cab.NumeroDocumento, dateadd(d, datediff(d, 0, Cab.DataDocumento), cast(''''23:59:59'''' as datetime)) AS DataControloInterno, 
															NULL as IDTipoDocumentoOrigem, NULL as IDDocumentoOrigem, NULL as IDLinhaDocumentoOrigem,
															NULL as IDTipoDocumentoOrigemInicial, NULL as IDDocumentoOrigemInicial, NULL as IDLinhaDocumentoOrigemInicial, NULL as DocumentoOrigemInicial,  
															'' + @strQueryQuantidades + @strQueryPrecoUnitarios + ''isnull(Linhas.Alterada,0) AS Recalcular, dateadd(d, datediff(d, 0, Cab.DataDocumento), cast(''''23:59:59'''' as datetime)) AS DataDocumento, Cab.TaxaConversao, 1 AS Ativo, 1 AS Sistema, Cab.DataCriacao, '''''' + @strUtilizador + '''''' AS UtilizadorCriacao,
															Cab.DataAlteracao, '''''' + @strUtilizador + '''''' AS UtilizadorAlteracao, NULL as VossoNumeroDocumento, NULL as VossoNumeroDocumentoOrigem, NULL as NumeroDocumentoOrigem, Cab.IDTiposDocumentoSeries, NULL as IDTiposDocumentoSeriesOrigem
															FROM '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab 
															LEFT JOIN '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas ON Linhas.'' + @strCampoRelTabelaLinhasCab + '' = Cab.ID 
															LEFT JOIN tbArtigos AS Art ON Art.ID = Linhas.IDArtigo '' + 
															@strQueryLeftJoinDist + 
															''LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  Cab.IDTipoDocumento
															LEFT JOIN tbSistemaTiposDocumentoMovStock TDQPos ON TDQPos.id=TpDoc.IDSistemaTiposDocumentoMovStock
															WHERE Cab.ID='' + Convert(nvarchar,@lngidDocumento) + '' AND ISNULL(Art.GereStock,0) <> 0 AND NOT Linhas.IDArtigo IS NULL
															AND '' +
															@strWhereQuantidades  + @strQueryOrdenacao 

									print @strSqlQuery
									EXEC(@strSqlQuery) 
									SET @strSqlQuery = ''''
								END

							ELSE
								BEGIN
									SET @paramList = N''@lngidDocumento1 bigint''
									SET @strWhereQuantidades = '' (TDQPos.Codigo=''''002'''' OR TDQPos.Codigo=''''003'''' OR TDQPos.Codigo=''''004'''' OR TDQPos.Codigo=''''006'''' OR TDQPos.Codigo=''''007'''') ''
									SET @strSqlQueryInsert = ''INSERT INTO tbCCStockArtigos (Natureza, IDArtigo, IDArtigoPA, IDArtigoPara, Descricao, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie,
															IDArtigoDimensao, IDMoeda, IDTipoEntidade, IDEntidade, IDTipoDocumento, IDDocumento, IDLinhaDocumento, NumeroDocumento, DataControloInterno, IDTipoDocumentoOrigem,
															IDDocumentoOrigem, IDLinhaDocumentoOrigem, IDTipoDocumentoOrigemInicial, IDDocumentoOrigemInicial, IDLinhaDocumentoOrigemInicial, DocumentoOrigemInicial, 
															Quantidade, QuantidadeStock, QuantidadeStock2, QtdStockReserva, QtdStockReserva2Uni, QtdStockAnterior, QtdStockAtual, QtdAfetacaoStock, QtdAfetacaoStock2, PrecoUnitario, PrecoUnitarioEfetivo, PrecoUnitarioMoedaRef, PrecoUnitarioEfetivoMoedaRef, UPCMoedaRef, 
															PCMAnteriorMoedaRef, PCMAtualMoedaRef, PVMoedaRef, UPCompraMoedaRef, UltCustosAdicionaisMoedaRef, UltDescComerciaisMoedaRef, Recalcular, DataDocumento, TaxaConversao, Ativo, Sistema, DataCriacao, UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao, VossoNumeroDocumento, VossoNumeroDocumentoOrigem, NumeroDocumentoOrigem, IDTiposDocumentoSeries, IDTiposDocumentoSeriesOrigem) ''
									SELECT @strSqlQuery = @strSqlQueryInsert + ''
															SELECT '''''' + @strNaturezaaux + '''''' AS Natureza, Linhas.IDArtigo, Linhas.IDArtigoPA,Linhas.IDArtigoPara,Linhas.Descricao, Cab.IDLoja, '' + @strArmazensCodigo + '' Linhas.IDLote AS IDArtigoLote, 
															Linhas.IDArtigoNumSerie AS IDArtigoNumeroSerie, '' + @strArtigoDimensao + '' 
															Cab.IDMoeda,Cab.IDTipoEntidade, Cab.IDEntidade, Cab.IDTipoDocumento,Cab.ID as IDDocumento, Linhas.id as IDLinhaDocumento, Cab.NumeroDocumento, Cab.DataControloInterno, 
															Linhas.IDTipoDocumentoOrigem as IDTipoDocumentoOrigem, Linhas.IDDocumentoOrigem as IDDocumentoOrigem,Linhas.IDLinhaDocumentoOrigem as IDLinhaDocumentoOrigem,
															Linhas.IDTipoDocumentoOrigemInicial, Linhas.IDDocumentoOrigemInicial, Linhas.IDLinhaDocumentoOrigemInicial, Linhas.DocumentoOrigemInicial,  
															'' + @strQueryQuantidades + @strQueryPrecoUnitarios + ''isnull(Linhas.Alterada,0) AS Recalcular, Cab.DataDocumento AS DataDocumento, Cab.TaxaConversao, 1 AS Ativo, 1 AS Sistema, Cab.DataCriacao, '''''' + @strUtilizador + '''''' AS UtilizadorCriacao,
															Cab.DataAlteracao, '''''' + @strUtilizador + '''''' AS UtilizadorAlteracao, Cab.VossoNumeroDocumento, Linhas.VossoNumeroDocumentoOrigem, Linhas.NumeroDocumentoOrigem, Cab.IDTiposDocumentoSeries, Linhas.IDTiposDocumentoSeriesOrigem
															FROM '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab 
															LEFT JOIN '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas ON Linhas.'' + @strCampoRelTabelaLinhasCab + '' = Cab.ID 
															LEFT JOIN tbArtigos AS Art ON Art.ID = Linhas.IDArtigo '' + 
															@strQueryLeftJoinDist + 
															''LEFT JOIN tbTiposDocumento AS TpDocOrigem ON TpDocOrigem.ID =  Linhas.IDTipoDocumentoOrigem 
															LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDocOrigem.IDSistemaTiposDocumentoMovStock
															LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  Cab.IDTipoDocumento
															LEFT JOIN tbSistemaTiposDocumentoMovStock TDQPos ON TDQPos.id=TpDoc.IDSistemaTiposDocumentoMovStock
															WHERE Cab.ID='' + Convert(nvarchar,@lngidDocumento) + '' AND ISNULL(Art.GereStock,0) <> 0 AND NOT Linhas.IDArtigo IS NULL
															AND (TpDocOrigem.ID IS NULL OR (NOT TpDocOrigem.ID IS NULL AND (ISNULL(TpDocOrigem.GereStock,0) = 0 OR (ISNULL(TpDocOrigem.GereStock,0) <> 0 AND NOT TDMS.Codigo is NULL AND TDMS.Codigo<>TDQPos.Codigo)))) AND '' +
															@strWhereQuantidades  + @strQueryOrdenacao
								END

							IF (@intAccao = 1) --se é alterar
								BEGIN
									--1) marcar as linhas no documento como alterada, se a mesma já existe na CCartigos e o custo ou a quantidade ou a data mudou,
									--para depois se marcar para recalcular ao inserir registos. Nas saidas marcar se mudou data e stock apenas - transferencias sao ignoradas
									IF  len(@strTabelaLinhasDist)>0
										BEGIN
											SET @strQueryLeftJoinDistUpdates = '' LEFT JOIN '' + QUOTENAME(@strTabelaLinhasDist) + '' AS LinhaDist ON (LinhaDist.'' + @strCampoRelTabelaLinhasDistLinhas + '' = CCartigos.IDLinhaDocumento AND isnull(LinhaDist.IDArtigoDimensao,0) = isnull(CCartigos.IDArtigoDimensao,0)) ''
											SET @strQueryWhereDistUpdates = '' AND ((ISNULL(TDMS.Codigo,0) = ''''002'''' AND ((isnull(LinhaDist.IDArtigoDimensao,0)<>0 
																			AND (Round(Convert(float,isnull(LinhaDist.UPCMoedaRef,0)),6) <> Round(Convert(float,isnull(CCartigos.UPCMoedaRef,0)),6) OR (isnull(LinhaDist.QuantidadeStock,0) <> isnull(CCartigos.QuantidadeStock,0))) 
																			) OR (CCartigos.DataControloInterno<>Cab1.DataControloInterno) OR (isnull(LinhaDist.IDArtigoDimensao,0) = 0 
																			AND  (Round(Convert(float,isnull(Linhas.UPCMoedaRef,0)),6) <> Round(Convert(float,isnull(CCartigos.UPCMoedaRef,0)),6) OR (isnull(Linhas.QuantidadeStock,0) <> isnull(CCartigos.QuantidadeStock,0)))
																			))) OR ((ISNULL(TDMS.Codigo,0) = ''''003'''' AND ((isnull(LinhaDist.IDArtigoDimensao,0)<>0 
																			AND isnull(LinhaDist.QuantidadeStock,0) <> isnull(CCartigos.QuantidadeStock,0)
																			) OR (CCartigos.DataControloInterno<>Cab1.DataControloInterno) OR (isnull(LinhaDist.IDArtigoDimensao,0) = 0 
																			AND  isnull(Linhas.QuantidadeStock,0) <> isnull(CCartigos.QuantidadeStock,0))
																			)))) ''														
																			  
										END
									ELSE
										BEGIN
											SET @strQueryLeftJoinDistUpdates = ''''
											SET @strQueryWhereDistUpdates = '' AND ((ISNULL(TDMS.Codigo,0) = ''''002'''' AND (CCartigos.DataControloInterno<>Cab1.DataControloInterno OR Round(Convert(float,isnull(Linhas.UPCMoedaRef,0)),6) <> Round(Convert(float,isnull(CCartigos.UPCMoedaRef,0)),6) OR (isnull(Linhas.QuantidadeStock,0) <> isnull(CCartigos.QuantidadeStock,0))) OR (
											(ISNULL(TDMS.Codigo,0) = ''''003'''' AND (CCartigos.DataControloInterno<>Cab1.DataControloInterno OR (isnull(Linhas.QuantidadeStock,0) <> isnull(CCartigos.QuantidadeStock,0))))
											))) ''
																			
										END
									SET @strSqlQueryUpdates = '' UPDATE '' + QUOTENAME(@strTabelaLinhas) + '' SET Alterada=1 FROM '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas 
																LEFT JOIN '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab1 ON (Cab1.id=Linhas.'' + @strCampoRelTabelaLinhasCab + '')
																LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  Cab1.IDTipoDocumento
																LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
																LEFT JOIN tbArtigos AS Art ON Art.ID = Linhas.IDArtigo 
															    INNER JOIN tbCCStockArtigos AS CCartigos ON (Linhas.'' + @strCampoRelTabelaLinhasCab + '' = CCartigos.IDDocumento AND CCartigos.IDLinhaDocumento=Linhas.id AND Linhas.IDArtigo = CCartigos.IDArtigo) '' 
																+ @strQueryLeftJoinDistUpdates +
																''WHERE NOT CCartigos.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND ISNULL(TpDoc.GereStock,0) <> 0 AND CCartigos.IDDocumento='' + Convert(nvarchar,@lngidDocumento) + '' AND CCartigos.IDTipoDocumento='' + Convert(nvarchar,@lngidTipoDocumento) 
																+ @strQueryWhereDistUpdates
								EXEC(@strSqlQueryUpdates)
								
								END

								IF (@intAccao = 0 OR @intAccao = 1) 
									BEGIN
									--2) Linhas novas que nao estavam no documento e agora passar a existir nele, marcar tb como alterada a propria da CCartigos , caso 
									---- exista à frente ja artigo.
									IF  len(@strTabelaLinhasDist)>0
										BEGIN
											SET @strQueryLeftJoinDistUpdates = '' LEFT JOIN '' + QUOTENAME(@strTabelaLinhasDist) + '' AS LinhaDist ON (LinhaDist.'' + @strCampoRelTabelaLinhasDistLinhas + '' = Linhas.id) ''
											SET @strQueryWhereDistUpdates = '' and isnull(LinhaDist.IDArtigoDimensao,0) = isnull(LinhasFrente.IDArtigoDimensao,0) '' 
											SET @strQueryCamposDistUpdates ='',isnull(LinhaDist.IDArtigoDimensao,0) as IdDimensao ''
											SET @strQueryWhereDistUpdates1 = '' AND isnull(CC.IDArtigoDimensao,0) = isnull(LinhasNovas.IdDimensao,0) '' 
											SET @strQueryCamposDistUpdates1 =''isnull(CC.IDArtigoDimensao,0) as IDArtigoDimensao, ''
											SET @strQueryGroupbyDistUpdates = '', isnull(CC.IDArtigoDimensao,0)''
											SET @strQueryONDist = '' AND isnull(CCartigos.IDArtigoDimensao,0)=isnull(LinhaDist.IDArtigoDimensao,0) ''
										END
									ELSE
										BEGIN
											SET @strQueryLeftJoinDistUpdates = '' ''
											SET @strQueryWhereDistUpdates = '' ''
											SET @strQueryCamposDistUpdates ='' ''
											SET @strQueryWhereDistUpdates1 = '' '' 
											SET @strQueryCamposDistUpdates1 ='' ''
											SET @strQueryGroupbyDistUpdates = '' ''
											SET @strQueryONDist = '' ''
										END

									SET @strSqlQueryUpdates ='' Update '' + QUOTENAME(@strTabelaLinhas) + '' SET Alterada=1 FROM '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas 
													LEFT JOIN '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab1 ON (Cab1.id=Linhas.'' + @strCampoRelTabelaLinhasCab + '')''
													+ @strQueryLeftJoinDistUpdates +
													''LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  Cab1.IDTipoDocumento
													LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
													LEFT JOIN tbArtigos AS Art ON Art.ID = Linhas.IDArtigo 
													LEFT JOIN	(
													SELECT CC.IDArtigo, '' + @strQueryCamposDistUpdates1 + '' Count(CC.ID) as Num FROM tbCCStockArtigos AS CC
													LEFT JOIN tbTiposDocumento AS TpDoc1 ON TpDoc1.ID =  CC.IDTipoDocumento
													LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS1 ON TDMS1.id=TpDoc1.IDSistemaTiposDocumentoMovStock
													LEFT JOIN		
													(SELECT distinct Linhas.IDArtigo, Cab.DataControloInterno'' + @strQueryCamposDistUpdates + '' FROM  '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas 
													LEFT JOIN '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab ON (Cab.id=Linhas.'' + @strCampoRelTabelaLinhasCab + '')''
													+ @strQueryLeftJoinDistUpdates +
													'' LEFT JOIN tbCCStockArtigos AS CCartigos ON (Linhas.'' + @strCampoRelTabelaLinhasCab + '' = CCartigos.IDDocumento AND CCartigos.IDLinhaDocumento=Linhas.id AND Linhas.IDArtigo = CCartigos.IDArtigo '' + @strQueryONDist + '')	
													WHERE Cab.ID='' + Convert(nvarchar,@lngidDocumento) + '' AND Cab.IDTipoDocumento='' + Convert(nvarchar,@lngidTipoDocumento) + '' AND CCartigos.IDDocumento IS NULL) AS LinhasNovas
													ON 	(CC.IDArtigo = LinhasNovas.IDArtigo '' + @strQueryWhereDistUpdates1 + '')
													WHERE CC.DataControloInterno > LinhasNovas.DataControloInterno AND (CC.Natureza=''''E'''' OR CC.Natureza=''''S'''') AND (ISNULL(TDMS1.Codigo,0) = ''''002'''' OR ISNULL(TDMS1.Codigo,0) = ''''003'''')									
													GROUP BY 	CC.IDArtigo '' + @strQueryGroupbyDistUpdates + '') AS LinhasFrente	
													ON Linhas.IDArtigo = LinhasFrente.IDArtigo '' + @strQueryWhereDistUpdates +
													''WHERE  NOT Linhas.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND ISNULL(TpDoc.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''') AND NOT LinhasFrente.IDArtigo IS NULL AND Cab1.ID='' + Convert(nvarchar,@lngidDocumento) + '' AND Cab1.IDTipoDocumento='' + Convert(nvarchar,@lngidTipoDocumento) 

									EXEC(@strSqlQueryUpdates)
									--2.1) Linhas novas que nao estavam no documento e agora passam a existir, mas com artigo repetido e nestes casos, marcar essas linhas de artigos 
									        
									SET @strSqlQueryUpdates = '' Update '' + QUOTENAME(@strTabelaLinhas) + '' SET Alterada=1 FROM '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas 
											                  LEFT JOIN '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab1 ON (Cab1.id=Linhas.'' + @strCampoRelTabelaLinhasCab + '') 
											LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  Cab1.IDTipoDocumento
											LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
											INNER JOIN (
												select Linhas.IDArtigo, Linhas.'' + @strCampoRelTabelaLinhasCab + '' FROM  '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas 
												LEFT JOIN '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab1 ON (Cab1.id=Linhas.'' + @strCampoRelTabelaLinhasCab + '')
												LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  Cab1.IDTipoDocumento
												LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
												where Linhas.'' + @strCampoRelTabelaLinhasCab + '' = '' + Convert(nvarchar,@lngidDocumento) + '' and Cab1.IDTipoDocumento='' + Convert(nvarchar,@lngidTipoDocumento) + '' and (TDMS.Codigo=''''002'''' OR TDMS.Codigo=''''003'''')
												group by Linhas.'' + @strCampoRelTabelaLinhasCab + '', Linhas.IDArtigo
												having count(*) > 1
												) as COM2
												ON COM2.IDArtigo=Linhas.IDArtigo and COM2.'' + @strCampoRelTabelaLinhasCab + ''=linhas.'' + @strCampoRelTabelaLinhasCab + ''
											LEFT JOIN tbCCStockArtigos AS CC ON Linhas.'' + @strCampoRelTabelaLinhasCab + '' = CC.IDDocumento and linhas.IDArtigo =cc.IDArtigo and cc.IDLinhaDocumento = linhas.id and CC.IDTipoDocumento = TpDoc.ID
											where Linhas.'' + @strCampoRelTabelaLinhasCab + ''= '' + Convert(nvarchar,@lngidDocumento) + '' and Cab1.IDTipoDocumento='' + Convert(nvarchar,@lngidTipoDocumento) + '' and (TDMS.Codigo=''''002'''' OR TDMS.Codigo=''''003'''') 
											and CC.IDLinhaDocumento is null	'' 


									EXEC(@strSqlQueryUpdates)
									
									END
								IF (@intAccao = 1) --se é alterar
									BEGIN
									--3) Linhas que existiam e agora deixaram de existir no documento, para essas, marcar a linha à frente desse artigo para recalcular a partir daí
									---  caso não existe nenhum para à frente não marcar nenhuma
									IF  len(@strTabelaLinhasDist)>0
										BEGIN
											SET @strQueryLeftJoinDistUpdates = '' LEFT JOIN '' + QUOTENAME(@strTabelaLinhasDist) + '' AS LinhaDist ON (LinhaDist.'' + @strCampoRelTabelaLinhasDistLinhas + '' = CCartigos.IDLinhaDocumento AND isnull(CCartigos.IDArtigoDimensao,0) = isnull(LinhaDist.IDArtigoDimensao,0)) ''
											SET @strQueryWhereDistUpdates = '' AND isnull(CCART.IDArtigoDimensao,0) = isnull(Docs.IDArtigoDimensao,0) '' 
											SET @strQueryCamposDistUpdates =''isnull(CCartigos.IDArtigoDimensao,0) as IDArtigoDimensao, ''
											SET @strQueryWhereDistUpdates1 = '' AND isnull(CCA.IDArtigoDimensao,0) = isnull(Doc.IDArtigoDimensao,0) '' 
											SET @strQueryCamposDistUpdates1 =''isnull(CCART.IDArtigoDimensao,0) as IDArtigoDimensao, ''
											SET @strQueryGroupbyDistUpdates = '', isnull(CCART.IDArtigoDimensao,0)''
											SET @strQueryWhereFrente = '' AND isnull(CCA.IDArtigoDimensao,0) = isnull(Frente.IDArtigoDimensao,0) ''
											SET @strQueryONDist = '' OR (LinhaDist.ID IS NULL AND isnull(CCartigos.IDArtigoDimensao,0) <> 0) ''
										END
									ELSE
										BEGIN
											SET @strQueryLeftJoinDistUpdates = '' ''
											SET @strQueryWhereDistUpdates = ''''
											SET @strQueryCamposDistUpdates ='' ''
											SET @strQueryWhereDistUpdates1 = '' '' 
											SET @strQueryCamposDistUpdates1 ='' ''
											SET @strQueryGroupbyDistUpdates = '' ''	
											SET @strQueryWhereFrente = '' ''
											SET @strQueryONDist = '' ''
										END
									SET @strQueryDocsUpdates = ''LEFT JOIN 
													(SELECT distinct CCartigos.IDArtigo,'' + @strQueryCamposDistUpdates + '' CCartigos.DataControloInterno  FROM  tbCCStockArtigos AS CCartigos
													LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCartigos.IDTipoDocumento
													LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
													LEFT JOIN '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas ON (Linhas.'' + @strCampoRelTabelaLinhasCab + '' = CCartigos.IDDocumento AND CCartigos.IDLinhaDocumento=Linhas.id AND Linhas.IDArtigo = CCartigos.IDArtigo) 
													'' + @strQueryLeftJoinDistUpdates + ''
													LEFT JOIN tbArtigos AS Art ON Art.ID = CCartigos.IDArtigo 
													WHERE CCartigos.IDDocumento='' + Convert(nvarchar,@lngidDocumento) + '' AND CCartigos.IDTipoDocumento='' + Convert(nvarchar,@lngidTipoDocumento) + '' 
												    AND (CCartigos.Natureza=''''E'''' OR CCartigos.Natureza=''''S'''')
													AND (Linhas.ID IS NULL '' + @strQueryONDist + '')
													AND NOT CCartigos.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND ISNULL(TpDoc.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''')
													) AS Docs
													ON (Docs.IDArtigo = CCART.IDArtigo '' + @strQueryWhereDistUpdates + '')''
									
									SET @strQueryDocsAFrente ='' (SELECT CCART.IDArtigo, '' + @strQueryCamposDistUpdates1 + '' Min(CCART.DataControloInterno) as Data FROM tbCCStockArtigos AS CCART
											LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCART.IDTipoDocumento
											LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
											LEFT JOIN tbArtigos AS Art ON Art.ID = CCART.IDArtigo ''
											+ @strQueryDocsUpdates +
											'' WHERE CCART.DataControloInterno > Docs.DataControloInterno and (CCART.IDDocumento<>'' + Convert(nvarchar,@lngidDocumento) + '' OR CCART.IDTipoDocumento<>'' + Convert(nvarchar,@lngidTipoDocumento) + '') and (CCART.Natureza=''''E'''' OR CCART.Natureza=''''S'''')
											AND NOT CCART.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND ISNULL(TpDoc.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''')
											GROUP BY  CCART.IDArtigo'' + @strQueryGroupbyDistUpdates + '') AS Frente
											ON (Frente.IDArtigo = CCA.IDArtigo '' + @strQueryWhereFrente + '' AND Frente.Data = CCA.DataControloInterno) ''

										SET @strSqlQueryUpdates ='' UPDATE tbCCStockArtigos SET Recalcular = 1 FROM tbCCStockArtigos AS CCA
											LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCA.IDTipoDocumento
											LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
											LEFT JOIN tbArtigos AS Art ON Art.ID = CCA.IDArtigo
											INNER JOIN ''
											+ @strQueryDocsAFrente + 
											'' WHERE (CCA.IDDocumento<>'' + Convert(nvarchar,@lngidDocumento) + '' OR CCA.IDTipoDocumento<>'' + Convert(nvarchar,@lngidTipoDocumento) + '') and (CCA.Natureza=''''E'''' OR CCA.Natureza=''''S'''')
											AND NOT CCA.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND ISNULL(TpDoc.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''')
											AND NOT Frente.IDArtigo IS NULL ''
											
									EXEC(@strSqlQueryUpdates)
																		
								 	--retirar as quantidades dos totais as quantidades para as chaves dos artigos do documento
									UPDATE tbStockArtigos SET Quantidade = Round(Quantidade - ArtigosAntigos.Qtd, 6), 
									QuantidadeStock = Round(QuantidadeStock - ArtigosAntigos.QtdStock, 6), 
									QuantidadeStock2 = Round(QuantidadeStock2 - ArtigosAntigos.QtdStock2,6),
									QuantidadeReservada = Round(isnull(QuantidadeReservada,0) - ArtigosAntigos.QtdStockReservado, 6), 
									QuantidadeReservada2 = Round(isnull(QuantidadeReservada2,0) - ArtigosAntigos.QtdStock2Reservado, 6) FROM tbStockArtigos AS CCART
									INNER JOIN (
									SELECT IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDArtigoDimensao, 
									SUM(Case Natureza WHEN ''S'' Then isnull(Quantidade,0)*-1 ELSE CASE Natureza WHEN ''E'' THEN isnull(Quantidade,0) ELSE 0 END END) as Qtd,
									SUM(Case Natureza WHEN ''S'' Then isnull(QuantidadeStock,0)*-1 ELSE CASE Natureza WHEN ''E'' THEN isnull(QuantidadeStock,0) ELSE 0 END END) as QtdStock,
									SUM(Case Natureza WHEN ''S'' Then isnull(QuantidadeStock2,0)*-1 ELSE CASE Natureza WHEN ''E'' THEN isnull(QuantidadeStock2,0) ELSE 0 END END) as QtdStock2,
									SUM(Case WHEN isnull(Natureza,'''') = ''R'' OR isnull(Natureza,'''') = ''E'' Then isnull(QtdStockReserva,0) ELSE isnull(QtdStockReserva,0)*-1 END) as QtdStockReservado,
									SUM(Case WHEN isnull(Natureza,'''') = ''R'' OR isnull(Natureza,'''') = ''E'' Then isnull(QtdStockReserva2Uni,0) ELSE isnull(QtdStockReserva2Uni,0)*-1 END) as QtdStock2Reservado
									FROM tbCCStockArtigos  WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento 
									GROUP BY IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDArtigoDimensao
									) AS ArtigosAntigos
									ON (isnull(ArtigosAntigos.IDLoja,0) = isnull(CCART.IDLoja,0) AND ArtigosAntigos.IDArtigo = CCART.IDArtigo AND isnull(ArtigosAntigos.IDArmazem,0) = isnull(CCART.IDArmazem,0) AND
									isnull(ArtigosAntigos.IDArmazemLocalizacao,0) = isnull(CCART.IDArmazemLocalizacao,0) AND isnull(ArtigosAntigos.IDArtigoLote,0) = isnull(CCART.IDArtigoLote,0)
									AND  isnull(ArtigosAntigos.IDArtigoNumeroSerie,0) = isnull(CCART.IDArtigoNumeroSerie,0) AND isnull(ArtigosAntigos.IDArtigoDimensao,0) = ISNULL(CCART.IDArtigoDimensao,0))
															
								--chama o de stocknecessidades
								  Execute sp_AtualizaStockNecessidades @lngidDocumento, @lngidTipoDocumento,2,@strUtilizador
								  
								--CHAMAR AQUI O OUTRO STORED PROCEDURE COM O ESTADO APAGAR
								
								  Execute sp_AtualizaArtigos @lngidDocumento, @lngidTipoDocumento,2,@strTabelaCabecalho,@strTabelaLinhas,@strTabelaLinhasDist,@strCampoRelTabelaLinhasCab,@strCampoRelTabelaLinhasDistLinhas,@strUtilizador
									--apagar aqui se estiverem a zero
									DELETE tbStockArtigos FROM tbStockArtigos AS CCART
									INNER JOIN (
									SELECT distinct IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDArtigoDimensao
									 FROM tbCCStockArtigos  WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento
									) AS ArtigosAntigos
									ON (isnull(ArtigosAntigos.IDLoja,0) = isnull(CCART.IDLoja,0) AND ArtigosAntigos.IDArtigo = CCART.IDArtigo AND isnull(ArtigosAntigos.IDArmazem,0) = isnull(CCART.IDArmazem,0) AND
											isnull(ArtigosAntigos.IDArmazemLocalizacao,0) = isnull(CCART.IDArmazemLocalizacao,0) AND isnull(ArtigosAntigos.IDArtigoLote,0) = isnull(CCART.IDArtigoLote,0)
											AND  isnull(ArtigosAntigos.IDArtigoNumeroSerie,0) = isnull(CCART.IDArtigoNumeroSerie,0) AND isnull(ArtigosAntigos.IDArtigoDimensao,0) = ISNULL(CCART.IDArtigoDimensao,0))
											AND isnull(CCART.Quantidade,0) = 0 AND isnull(CCART.QuantidadeStock,0) = 0 AND isnull(CCART.QuantidadeStock2,0) = 0 AND isnull(CCART.QuantidadeReservada,0) = 0 AND isnull(CCART.QuantidadeReservada2,0) = 0
									--apagar registos da ccartigos
									--aqui faz os deletes
									
									IF @inValidaStock<>0
										BEGIN
											SET @strQueryCamposDistUpdates =''CCartigos.IDArtigoDimensao as IDArtigoDimensao, CCartigos.IDLoja, CCartigos.IDArmazem, CCartigos.IDArmazemLocalizacao, CCartigos.IDArtigoLote, CCartigos.IDArtigoNumeroSerie, 0 as LimiteMax, 0 as LimiteMaxMsgBlq, 0 as LimiteMin,0 as LimiteMinMsgBlq, 0 as RuturaUnd1,	0 as RuturaUnd1MsgBlq, 0 as RuturaUnd2, 0 as RuturaUnd2MsgBlq,	1 as Ativo, 1 as Sistema, getdate() as DataCriacao, '''''' + @strUtilizador + '''''' as UtilizadorCriacao ''
								
											IF  len(@strTabelaLinhasDist)>0
												BEGIN
													SET @strQueryLeftJoinDistUpdates = '' LEFT JOIN '' + QUOTENAME(@strTabelaLinhasDist) + '' AS LinhaDist ON (LinhaDist.'' + @strCampoRelTabelaLinhasDistLinhas + '' = CCartigos.IDLinhaDocumento AND isnull(CCartigos.IDArtigoDimensao,0) = isnull(LinhaDist.IDArtigoDimensao,0)) ''
													SET @strQueryWhereDistUpdates = '' OR (LinhaDist.ID IS NULL AND isnull(CCartigos.IDArtigoDimensao,0) <> 0) '' 
											
												END
											ELSE
												BEGIN
													SET @strQueryLeftJoinDistUpdates = '' ''
													SET @strQueryWhereDistUpdates = ''''
													
												END
											SET @strQueryDocsUpdates = '' INSERT INTO tbControloValidacaoStock(IDTipoDocumento, IDDocumento, IDArtigo, IDArtigoDimensao, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, LimiteMax, LimiteMaxMsgBlq, LimiteMin, LimiteMinMsgBlq,	RuturaUnd1,	RuturaUnd1MsgBlq, RuturaUnd2, RuturaUnd2MsgBlq,	Ativo, Sistema, DataCriacao, UtilizadorCriacao)   
															SELECT distinct TpDoc.ID AS IDTipoDocumento, CCartigos.IDDocumento AS IDDocumento, CCartigos.IDArtigo,'' + @strQueryCamposDistUpdates + ''  FROM  tbCCStockArtigos AS CCartigos
															LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCartigos.IDTipoDocumento
															LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
															LEFT JOIN '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas ON (Linhas.'' + @strCampoRelTabelaLinhasCab + '' = CCartigos.IDDocumento AND CCartigos.IDLinhaDocumento=Linhas.id AND Linhas.IDArtigo = CCartigos.IDArtigo) 
															'' + @strQueryLeftJoinDistUpdates + ''
															LEFT JOIN tbArtigos AS Art ON Art.ID = CCartigos.IDArtigo 
															WHERE '' + @strNaturezaBase + ''  CCartigos.IDDocumento='' + Convert(nvarchar,@lngidDocumento) + '' AND CCartigos.IDTipoDocumento='' + Convert(nvarchar,@lngidTipoDocumento) + '' 
															AND (Linhas.ID IS NULL '' + @strQueryWhereDistUpdates + '' )
															AND NOT CCartigos.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND ISNULL(TpDoc.GereStock,0) <> 0 ''
											
											IF @strNaturezaStock <> ''[#F3MN#F3M]''
												BEGIN
													 SET @strQueryDocsUpdatesaux = REPLACE(@strQueryDocsUpdates, @strNaturezaBase, '' '')
													 EXEC(@strQueryDocsUpdatesaux)
													 IF Exists(SELECT IDArtigo FROM tbControloValidacaoStock WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento AND isnull(LimiteMax,0) = 0 AND isnull(LimiteMin,0) = 0 AND isnull(RuturaUnd1,0) = 0 AND isnull(RuturaUnd2,0) = 0 )
														BEGIN
															IF  @strNaturezaStock = ''E'' OR  @strNaturezaStock = ''LR''
																BEGIN
																	SET @inLimitMaxDel = 1--ignora
								
																END
															IF  @strNaturezaStock = ''S'' OR  @strNaturezaStock = ''R''
																BEGIN
							    									SET @inRuturaDel = 1--ignora
																	SET @inLimitMinDel = 1--ignora
																END

															Execute sp_ValidaStock @lngidDocumento, @lngidTipoDocumento, @strTabelaLinhasDist, @strUtilizador, 1, 1, 1, @inLimitMaxDel, @inLimitMinDel, @inRuturaDel , @strNaturezaStock 
														END
												END
											ELSE
												BEGIN
												     --Entrada
													 SET @strQueryDocsUpdatesaux = REPLACE(@strQueryDocsUpdates, @strNaturezaBase, ''CCartigos.Natureza=''''E'''' AND '')
													 EXEC(@strQueryDocsUpdatesaux)

												      IF Exists(SELECT IDArtigo FROM tbControloValidacaoStock WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento AND isnull(LimiteMax,0) = 0 AND isnull(LimiteMin,0) = 0 AND isnull(RuturaUnd1,0) = 0 AND isnull(RuturaUnd2,0) = 0 )
													  BEGIN
														Execute sp_ValidaStock @lngidDocumento, @lngidTipoDocumento, @strTabelaLinhasDist, @strUtilizador, 1, 1, 1, 1, @inLimitMinDel, @inRuturaDel , ''E''
													  END

													  --saída
													 SET @strQueryDocsUpdatesaux = REPLACE(@strQueryDocsUpdates, @strNaturezaBase, ''CCartigos.Natureza=''''S'''' AND '')
	  												 EXEC(@strQueryDocsUpdatesaux)

												      IF Exists(SELECT IDArtigo FROM tbControloValidacaoStock WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento AND isnull(LimiteMax,0) = 0 AND isnull(LimiteMin,0) = 0 AND isnull(RuturaUnd1,0) = 0 AND isnull(RuturaUnd2,0) = 0 )
													  BEGIN
														Execute sp_ValidaStock @lngidDocumento, @lngidTipoDocumento, @strTabelaLinhasDist, @strUtilizador, 1, 1, 1, @inLimitMaxDel, 1, 1 , ''S'' 
													  END
												END
										END

									DELETE FROM tbCCStockArtigos WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento
								END

								--verifica se tem de marcar a Linha como alterada
								if (@strTipoDocInterno = ''CmpFinanceiro'')
									BEGIN
										Execute sp_RegistaCCRetCompras @lngidDocumento, @lngidTipoDocumento, 1, @strUtilizador
									END

								IF (@intAccao = 1) --se é alterar
									BEGIN
										DELETE FROM tbCCStockArtigos WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento
									END

								IF  @strNaturezaaux = ''[#F3MN#F3M]''--só existe transferencia para os stocks
									BEGIN
										SET @strSqlQueryAux = REPLACE(@strSqlQuery, @strArmazensCodigo, @strArmazem)
										SET @strSqlQueryAux = REPLACE(@strSqlQueryAux, @strNaturezaaux, ''S'')
										SET @strSqlQueryAux = REPLACE(@strSqlQueryAux, @strTransFControlo, @strTransFSaida)
									    EXEC(@strSqlQueryAux)--registo do armazem de saída
										SET @strSqlQueryAux = REPLACE(@strSqlQuery, @strArmazensCodigo, @strArmazensDestino)
										SET @strSqlQueryAux = REPLACE(@strSqlQueryAux, @strNaturezaaux, ''E'')
										SET @strSqlQueryAux = REPLACE(@strSqlQueryAux, @strTransFControlo, @strTransFEntrada )
										EXEC(@strSqlQueryAux)--registo do armazem de entrada
									END
								ELSE
									BEGIN
									    SET @strSqlQueryAux = REPLACE(@strSqlQuery, @strTransFControlo, @strTransFSaida)
										IF @strNaturezaaux = ''E'' OR  @strNaturezaaux = ''LR''
											BEGIN
												SET @strSqlQueryAux = REPLACE(@strSqlQueryAux, @strArmazensCodigo, @strArmazensDestino)
											END
										ELSE
											BEGIN
												SET @strSqlQueryAux = REPLACE(@strSqlQueryAux, @strArmazensCodigo, @strArmazem)
											END
								    	EXEC(@strSqlQueryAux) --registo das linhas diferentes de armazéns
									END

								--regista ret compras
								if (@strTipoDocInterno = ''CmpFinanceiro'')
									BEGIN
										Execute sp_RegistaCCRetCompras @lngidDocumento, @lngidTipoDocumento, 0, @strUtilizador
									END
								
								--inserir a zero os registos que nao existem das chaves nos totais
								INSERT INTO tbStockArtigos(IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao,IDArtigoLote,IDArtigoNumeroSerie, IDArtigoDimensao, Quantidade, QuantidadeStock, QuantidadeStock2,
								Ativo, Sistema, DataCriacao, UtilizadorCriacao, DataAlteracao, UtilizadorAlteracao) 
								SELECT CCART.IDArtigo, CCART.IDLoja, CCART.IDArmazem, CCART.IDArmazemLocalizacao, CCART.IDArtigoLote, CCART.IDArtigoNumeroSerie, CCART.IDArtigoDimensao,
								CCART.Quantidade, CCART.QuantidadeStock,CCART.QuantidadeStock2,
									CCART.Ativo,CCART.Sistema, CCART.DataCriacao, CCART.UtilizadorCriacao, CCART.DataAlteracao,CCART.UtilizadorAlteracao
									FROM (
								SELECT IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDArtigoDimensao, 0 as Quantidade,
								0 as QuantidadeStock,
								0 as QuantidadeStock2,1 as Ativo,1 as Sistema, getdate() AS DataCriacao , @strUtilizador as UtilizadorCriacao, getdate() as DataAlteracao, @strUtilizador as UtilizadorAlteracao
								FROM tbCCStockArtigos  WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento 
								GROUP BY IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDArtigoDimensao
								) AS CCART
								LEFT JOIN tbStockArtigos AS ArtigosAntigos
								ON (isnull(ArtigosAntigos.IDLoja,0) = isnull(CCART.IDLoja,0) AND ArtigosAntigos.IDArtigo = CCART.IDArtigo AND isnull(ArtigosAntigos.IDArmazem,0) = isnull(CCART.IDArmazem,0) AND
									isnull(ArtigosAntigos.IDArmazemLocalizacao,0) = isnull(CCART.IDArmazemLocalizacao,0) AND isnull(ArtigosAntigos.IDArtigoLote,0) = isnull(CCART.IDArtigoLote,0)
									AND  isnull(ArtigosAntigos.IDArtigoNumeroSerie,0) = isnull(CCART.IDArtigoNumeroSerie,0) AND isnull(ArtigosAntigos.IDArtigoDimensao,0) = ISNULL(CCART.IDArtigoDimensao,0))
									WHERE ArtigosAntigos.IDArtigo is NULL and ArtigosAntigos.IDArmazem is NULL AND
									ArtigosAntigos.IDArmazemLocalizacao is NULL and ArtigosAntigos.IDArtigoLote is NULL and
									ArtigosAntigos.IDArtigoNumeroSerie is NULL and ArtigosAntigos.IDArtigoDimensao is NULL and ArtigosAntigos.IDLoja is NULL
								
								--update a somar para os totais das quantidades
								UPDATE tbStockArtigos SET Quantidade =  Round(Quantidade + ArtigosAntigos.Qtd,6), 
								QuantidadeStock = Round(QuantidadeStock + ArtigosAntigos.QtdStock,6), 
								QuantidadeStock2 = Round(QuantidadeStock2 + ArtigosAntigos.QtdStock2,6),
								QuantidadeReservada = Round(isnull(QuantidadeReservada,0) + ArtigosAntigos.QtdStockReservado, 6), 
								QuantidadeReservada2 = Round(isnull(QuantidadeReservada2,0) + ArtigosAntigos.QtdStock2Reservado, 6) FROM tbStockArtigos AS CCART
								INNER JOIN (
								SELECT IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDArtigoDimensao, 
								SUM(Case Natureza WHEN ''S'' Then isnull(Quantidade,0)*-1 ELSE CASE Natureza WHEN ''E'' THEN isnull(Quantidade,0) ELSE 0 END END) as Qtd,
								SUM(Case Natureza WHEN ''S'' Then isnull(QuantidadeStock,0)*-1 ELSE CASE Natureza WHEN ''E'' THEN isnull(QuantidadeStock,0) ELSE 0 END END) as QtdStock,
								SUM(Case Natureza WHEN ''S'' Then isnull(QuantidadeStock2,0)*-1 ELSE CASE Natureza WHEN ''E'' THEN isnull(QuantidadeStock2,0) ELSE 0 END END) as QtdStock2,
								SUM(Case WHEN isnull(Natureza,'''') = ''R'' OR isnull(Natureza,'''') = ''E'' Then isnull(QtdStockReserva,0) ELSE isnull(QtdStockReserva,0)*-1 END) as QtdStockReservado,
								SUM(Case WHEN isnull(Natureza,'''') = ''R'' OR isnull(Natureza,'''') = ''E'' Then isnull(QtdStockReserva2Uni,0) ELSE isnull(QtdStockReserva2Uni,0)*-1 END) as QtdStock2Reservado
								FROM tbCCStockArtigos  WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento
								GROUP BY IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDArtigoDimensao
								) AS ArtigosAntigos
								ON (isnull(ArtigosAntigos.IDLoja,0) = isnull(CCART.IDLoja,0) AND ArtigosAntigos.IDArtigo = CCART.IDArtigo AND isnull(ArtigosAntigos.IDArmazem,0) = isnull(CCART.IDArmazem,0) AND
									isnull(ArtigosAntigos.IDArmazemLocalizacao,0) = isnull(CCART.IDArmazemLocalizacao,0) AND isnull(ArtigosAntigos.IDArtigoLote,0) = isnull(CCART.IDArtigoLote,0)
									AND  isnull(ArtigosAntigos.IDArtigoNumeroSerie,0) = isnull(CCART.IDArtigoNumeroSerie,0) AND isnull(ArtigosAntigos.IDArtigoDimensao,0) = ISNULL(CCART.IDArtigoDimensao,0))
								

								--colocar o campo a false nas linhas dos documentos
								SET @strSqlQueryUpdates = '' UPDATE '' + QUOTENAME(@strTabelaLinhas) + '' SET Alterada=0 FROM '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas 
															LEFT JOIN '' + QUOTENAME(@strTabelaCabecalho) + '' AS Cab1 ON (Cab1.id=Linhas.'' + @strCampoRelTabelaLinhasCab + '')'' +  
															'' WHERE Cab1.ID='' + Convert(nvarchar,@lngidDocumento) + '' AND Cab1.IDTipoDocumento='' + Convert(nvarchar,@lngidTipoDocumento) 
																
								EXEC(@strSqlQueryUpdates)	
								--CHAMAR AQUI O OUTRO STORED PROCEDURE COM O ESTADO inserir		
								 Execute sp_AtualizaArtigos @lngidDocumento, @lngidTipoDocumento,0,@strTabelaCabecalho,@strTabelaLinhas,@strTabelaLinhasDist,@strCampoRelTabelaLinhasCab,@strCampoRelTabelaLinhasDistLinhas,@strUtilizador

								--chama aqui o stock de necessidades
								Execute sp_AtualizaStockNecessidades @lngidDocumento, @lngidTipoDocumento,0,@strUtilizador

								IF  @strNaturezaaux = ''[#F3MN#F3M]''--só existe transferencia para os stocks
									BEGIN
										IF @inValidaStock<>0
											BEGIN
												--entrada
												Execute sp_ValidaStock @lngidDocumento, @lngidTipoDocumento, @strTabelaLinhasDist, @strUtilizador, @inLimitMax, 1, 1, 1 , 1, 1 , ''E'' 
										
												--saída
												Execute sp_ValidaStock @lngidDocumento, @lngidTipoDocumento, @strTabelaLinhasDist, @strUtilizador, 1, @inLimitMin, @inRutura, 1 , 1, 1 , ''S'' 
											END
									END
								ELSE
									BEGIN
									   IF @inValidaStock<>0
											BEGIN
											   Execute sp_ValidaStock @lngidDocumento, @lngidTipoDocumento, @strTabelaLinhasDist, @strUtilizador, @inLimitMax, @inLimitMin, @inRutura, 1, 1, 1, @strNaturezaaux 
											END
									END
						END
					ELSE --apagar
						BEGIN
							--3) Linhas que existiam e agora deixaram de existir no documento, para essas, marcar a linha à frente desse artigo para recalcular a partir daí
							---  caso não existe nenhum para à frente não marcar nenhuma
							IF  len(@strTabelaLinhasDist)>0
								BEGIN
									SET @strQueryLeftJoinDistUpdates = '' LEFT JOIN '' + QUOTENAME(@strTabelaLinhasDist) + '' AS LinhaDist ON (LinhaDist.'' + @strCampoRelTabelaLinhasDistLinhas + '' = CCartigos.IDLinhaDocumento AND isnull(CCartigos.IDArtigoDimensao,0) = isnull(LinhaDist.IDArtigoDimensao,0)) ''
									SET @strQueryWhereDistUpdates = '' AND isnull(CCART.IDArtigoDimensao,0) = isnull(Docs.IDArtigoDimensao,0) '' 
									SET @strQueryCamposDistUpdates =''isnull(CCartigos.IDArtigoDimensao,0) as IDArtigoDimensao, ''
									SET @strQueryWhereDistUpdates1 = '' AND isnull(CCA.IDArtigoDimensao,0) = isnull(Doc.IDArtigoDimensao,0) '' 
									SET @strQueryCamposDistUpdates1 =''isnull(CCART.IDArtigoDimensao,0) as IDArtigoDimensao, ''
									SET @strQueryGroupbyDistUpdates = '', isnull(CCART.IDArtigoDimensao,0)''
									SET @strQueryWhereFrente = '' AND isnull(CCA.IDArtigoDimensao,0) = isnull(Frente.IDArtigoDimensao,0) ''
									SET @strQueryONDist = '' OR (LinhaDist.ID IS NULL AND isnull(CCartigos.IDArtigoDimensao,0) <> 0) ''
								END
							ELSE
								BEGIN
									SET @strQueryLeftJoinDistUpdates = '' ''
									SET @strQueryWhereDistUpdates = ''''
									SET @strQueryCamposDistUpdates ='' ''
									SET @strQueryWhereDistUpdates1 = '' '' 
									SET @strQueryCamposDistUpdates1 ='' ''
									SET @strQueryGroupbyDistUpdates = '' ''	
									SET @strQueryWhereFrente = '' ''	
									SET @strQueryONDist = '' ''
								END
							SET @strQueryDocsUpdates = ''LEFT JOIN 
											(SELECT distinct CCartigos.IDArtigo,'' + @strQueryCamposDistUpdates + '' CCartigos.DataControloInterno  FROM  tbCCStockArtigos AS CCartigos
											LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCartigos.IDTipoDocumento
											LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
											LEFT JOIN '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas ON (Linhas.'' + @strCampoRelTabelaLinhasCab + '' = CCartigos.IDDocumento AND CCartigos.IDLinhaDocumento=Linhas.id AND Linhas.IDArtigo = CCartigos.IDArtigo) 
											'' + @strQueryLeftJoinDistUpdates + ''
											LEFT JOIN tbArtigos AS Art ON Art.ID = CCartigos.IDArtigo 
											WHERE CCartigos.IDDocumento='' + Convert(nvarchar,@lngidDocumento) + '' AND CCartigos.IDTipoDocumento='' + Convert(nvarchar,@lngidTipoDocumento) + '' 
											AND (CCartigos.Natureza=''''E'''' OR CCartigos.Natureza=''''S'''')
											AND (Linhas.ID IS NULL '' + @strQueryONDist + '')
											AND NOT CCartigos.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND ISNULL(TpDoc.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''')
											) AS Docs
											ON (Docs.IDArtigo = CCART.IDArtigo '' + @strQueryWhereDistUpdates + '')''
									

								SET @strQueryDocsAFrente ='' (SELECT CCART.IDArtigo, '' + @strQueryCamposDistUpdates1 + '' Min(CCART.DataControloInterno) as Data FROM tbCCStockArtigos AS CCART
										LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCART.IDTipoDocumento
										LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
										LEFT JOIN tbArtigos AS Art ON Art.ID = CCART.IDArtigo ''
										+ @strQueryDocsUpdates +
										'' WHERE CCART.DataControloInterno > Docs.DataControloInterno and (CCART.IDDocumento<>'' + Convert(nvarchar,@lngidDocumento) + '' OR CCART.IDTipoDocumento<>'' + Convert(nvarchar,@lngidTipoDocumento) + '') and (CCART.Natureza=''''E'''' OR CCART.Natureza=''''S'''')
										AND NOT CCART.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND ISNULL(TpDoc.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''')
										GROUP BY  CCART.IDArtigo'' + @strQueryGroupbyDistUpdates + '') AS Frente
										ON (Frente.IDArtigo = CCA.IDArtigo '' + @strQueryWhereFrente + '' AND Frente.Data = CCA.DataControloInterno) ''

								SET @strSqlQueryUpdates ='' UPDATE tbCCStockArtigos SET Recalcular = 1 FROM tbCCStockArtigos AS CCA
									LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCA.IDTipoDocumento
									LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
									LEFT JOIN tbArtigos AS Art ON Art.ID = CCA.IDArtigo
									INNER JOIN ''
									+ @strQueryDocsAFrente + 
									'' WHERE (CCA.IDDocumento<>'' + Convert(nvarchar,@lngidDocumento) + '' OR CCA.IDTipoDocumento<>'' + Convert(nvarchar,@lngidTipoDocumento) + '') and (CCA.Natureza=''''E'''' OR CCA.Natureza=''''S'''')
									AND NOT CCA.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND ISNULL(TpDoc.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''')
									AND NOT Frente.IDArtigo IS NULL ''

							EXEC(@strSqlQueryUpdates)
							
						   --retirar as quantidades dos totais para as chaves dos artigos do documento
							UPDATE tbStockArtigos SET Quantidade = Round(Quantidade - ArtigosAntigos.Qtd,6), 
							QuantidadeStock = Round(QuantidadeStock - ArtigosAntigos.QtdStock,6), 
							QuantidadeStock2 = Round(QuantidadeStock2 - ArtigosAntigos.QtdStock2,6),
							QuantidadeReservada = Round(isnull(QuantidadeReservada,0) - ArtigosAntigos.QtdStockReservado, 6), 
							QuantidadeReservada2 = Round(isnull(QuantidadeReservada2,0) - ArtigosAntigos.QtdStock2Reservado, 6) FROM tbStockArtigos AS CCART
							INNER JOIN (
							SELECT IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDArtigoDimensao, 
							SUM(Case Natureza WHEN ''S'' Then isnull(Quantidade,0)*-1 ELSE CASE Natureza WHEN ''E'' THEN isnull(Quantidade,0) ELSE 0 END END) as Qtd,
							SUM(Case Natureza WHEN ''S'' Then isnull(QuantidadeStock,0)*-1 ELSE CASE Natureza WHEN ''E'' THEN isnull(QuantidadeStock,0) ELSE 0 END END) as QtdStock,
							SUM(Case Natureza WHEN ''S'' Then isnull(QuantidadeStock2,0)*-1 ELSE CASE Natureza WHEN ''E'' THEN isnull(QuantidadeStock2,0) ELSE 0 END END) as QtdStock2,
							SUM(Case WHEN isnull(Natureza,'''') = ''R'' OR isnull(Natureza,'''') = ''E'' Then isnull(QtdStockReserva,0) ELSE isnull(QtdStockReserva,0)*-1 END) as QtdStockReservado,
							SUM(Case WHEN isnull(Natureza,'''') = ''R'' OR isnull(Natureza,'''') = ''E'' Then isnull(QtdStockReserva2Uni,0) ELSE isnull(QtdStockReserva2Uni,0)*-1 END) as QtdStock2Reservado
							FROM tbCCStockArtigos  WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento 
							GROUP BY IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDArtigoDimensao
							) AS ArtigosAntigos
							ON (isnull(ArtigosAntigos.IDLoja,0) = isnull(CCART.IDLoja,0) AND ArtigosAntigos.IDArtigo = CCART.IDArtigo AND isnull(ArtigosAntigos.IDArmazem,0) = isnull(CCART.IDArmazem,0) AND
									isnull(ArtigosAntigos.IDArmazemLocalizacao,0) = isnull(CCART.IDArmazemLocalizacao,0) AND isnull(ArtigosAntigos.IDArtigoLote,0) = isnull(CCART.IDArtigoLote,0)
									AND  isnull(ArtigosAntigos.IDArtigoNumeroSerie,0) = isnull(CCART.IDArtigoNumeroSerie,0) AND isnull(ArtigosAntigos.IDArtigoDimensao,0) = ISNULL(CCART.IDArtigoDimensao,0))
							
							--chama aqui o stock de necessidades
							  Execute sp_AtualizaStockNecessidades @lngidDocumento, @lngidTipoDocumento,2,@strUtilizador

							--CHAMAR AQUI O OUTRO STORED PROCEDURE COM O ESTADO APAGAR
							Execute sp_AtualizaArtigos @lngidDocumento, @lngidTipoDocumento,2,@strTabelaCabecalho,@strTabelaLinhas,@strTabelaLinhasDist,@strCampoRelTabelaLinhasCab,@strCampoRelTabelaLinhasDistLinhas,@strUtilizador
							--apagar aqui se estiverem a zero
							
							IF @inValidaStock<>0
							BEGIN	
							
								IF @strNaturezaStock <> ''[#F3MN#F3M]''
									BEGIN
										INSERT INTO tbControloValidacaoStock(IDTipoDocumento, IDDocumento, IDArtigo, IDArtigoDimensao, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, LimiteMax, LimiteMaxMsgBlq, LimiteMin, LimiteMinMsgBlq,	RuturaUnd1,	RuturaUnd1MsgBlq, RuturaUnd2, RuturaUnd2MsgBlq,	Ativo, Sistema, DataCriacao, UtilizadorCriacao)
										SELECT distinct CCartigos.IDTipoDocumento AS IDTipoDocumento, CCartigos.IDDocumento AS IDDocumento, CCartigos.IDArtigo,
										CCartigos.IDArtigoDimensao as IDArtigoDimensao, CCartigos.IDLoja, CCartigos.IDArmazem, CCartigos.IDArmazemLocalizacao, CCartigos.IDArtigoLote, CCartigos.IDArtigoNumeroSerie, 0 as LimiteMax, 0 as LimiteMaxMsgBlq, 0 as LimiteMin,0 as LimiteMinMsgBlq, 0 as RuturaUnd1,	0 as RuturaUnd1MsgBlq, 0 as RuturaUnd2, 0 as RuturaUnd2MsgBlq,	1 as Ativo, 1 as Sistema, getdate() as DataCriacao, @strUtilizador as UtilizadorCriacao 
										FROM tbCCStockArtigos  as CCartigos WHERE CCartigos.IDTipoDocumento = @lngidTipoDocumento AND CCartigos.IDDocumento = @lngidDocumento 	
										Execute sp_ValidaStock @lngidDocumento, @lngidTipoDocumento, @strTabelaLinhasDist, @strUtilizador, @inLimitMax, @inLimitMin, @inRutura, @inLimitMaxDel, @inLimitMinDel, @inRuturaDel , @strNaturezaStock 
									END
								ELSE
									BEGIN
										 SET @inRutura = 1--ignora
										 SET @inLimitMin = 1--ignora
										 SET @inLimitMax = 1--ignora
								 
								        --Entrada
										INSERT INTO tbControloValidacaoStock(IDTipoDocumento, IDDocumento, IDArtigo, IDArtigoDimensao, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, LimiteMax, LimiteMaxMsgBlq, LimiteMin, LimiteMinMsgBlq,	RuturaUnd1,	RuturaUnd1MsgBlq, RuturaUnd2, RuturaUnd2MsgBlq,	Ativo, Sistema, DataCriacao, UtilizadorCriacao)
										SELECT distinct CCartigos.IDTipoDocumento AS IDTipoDocumento, CCartigos.IDDocumento AS IDDocumento, CCartigos.IDArtigo,
										CCartigos.IDArtigoDimensao as IDArtigoDimensao, CCartigos.IDLoja, CCartigos.IDArmazem, CCartigos.IDArmazemLocalizacao, CCartigos.IDArtigoLote, CCartigos.IDArtigoNumeroSerie, 0 as LimiteMax, 0 as LimiteMaxMsgBlq, 0 as LimiteMin,0 as LimiteMinMsgBlq, 0 as RuturaUnd1,	0 as RuturaUnd1MsgBlq, 0 as RuturaUnd2, 0 as RuturaUnd2MsgBlq,	1 as Ativo, 1 as Sistema, getdate() as DataCriacao, @strUtilizador as UtilizadorCriacao 
										FROM tbCCStockArtigos  as CCartigos WHERE CCartigos.IDTipoDocumento = @lngidTipoDocumento AND CCartigos.IDDocumento = @lngidDocumento AND CCartigos.Natureza = ''E''
										Execute sp_ValidaStock @lngidDocumento, @lngidTipoDocumento, @strTabelaLinhasDist, @strUtilizador, @inLimitMax, @inLimitMin, @inRutura, 1 , @inLimitMinDel, @inRuturaDel , ''E'' 

										--Saída
										INSERT INTO tbControloValidacaoStock(IDTipoDocumento, IDDocumento, IDArtigo, IDArtigoDimensao, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, LimiteMax, LimiteMaxMsgBlq, LimiteMin, LimiteMinMsgBlq,	RuturaUnd1,	RuturaUnd1MsgBlq, RuturaUnd2, RuturaUnd2MsgBlq,	Ativo, Sistema, DataCriacao, UtilizadorCriacao)
										SELECT distinct CCartigos.IDTipoDocumento AS IDTipoDocumento, CCartigos.IDDocumento AS IDDocumento, CCartigos.IDArtigo,
										CCartigos.IDArtigoDimensao as IDArtigoDimensao, CCartigos.IDLoja, CCartigos.IDArmazem, CCartigos.IDArmazemLocalizacao, CCartigos.IDArtigoLote, CCartigos.IDArtigoNumeroSerie, 0 as LimiteMax, 0 as LimiteMaxMsgBlq, 0 as LimiteMin,0 as LimiteMinMsgBlq, 0 as RuturaUnd1,	0 as RuturaUnd1MsgBlq, 0 as RuturaUnd2, 0 as RuturaUnd2MsgBlq,	1 as Ativo, 1 as Sistema, getdate() as DataCriacao, @strUtilizador as UtilizadorCriacao 
										FROM tbCCStockArtigos  as CCartigos WHERE CCartigos.IDTipoDocumento = @lngidTipoDocumento AND CCartigos.IDDocumento = @lngidDocumento AND CCartigos.Natureza = ''S''
										Execute sp_ValidaStock @lngidDocumento, @lngidTipoDocumento, @strTabelaLinhasDist, @strUtilizador, @inLimitMax, @inLimitMin, @inRutura, @inLimitMaxDel, 1, 1 , ''S'' 
									END
							END
							
							DELETE tbStockArtigos FROM tbStockArtigos AS CCART
							INNER JOIN (
							SELECT distinct IDArtigo, IDLoja, IDArmazem, IDArmazemLocalizacao, IDArtigoLote, IDArtigoNumeroSerie, IDArtigoDimensao
							 FROM tbCCStockArtigos  WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento
							) AS ArtigosAntigos
							ON (isnull(ArtigosAntigos.IDLoja,0) = isnull(CCART.IDLoja,0) AND ArtigosAntigos.IDArtigo = CCART.IDArtigo AND isnull(ArtigosAntigos.IDArmazem,0) = isnull(CCART.IDArmazem,0) AND
									isnull(ArtigosAntigos.IDArmazemLocalizacao,0) = isnull(CCART.IDArmazemLocalizacao,0) AND isnull(ArtigosAntigos.IDArtigoLote,0) = isnull(CCART.IDArtigoLote,0)
									AND  isnull(ArtigosAntigos.IDArtigoNumeroSerie,0) = isnull(CCART.IDArtigoNumeroSerie,0) AND isnull(ArtigosAntigos.IDArtigoDimensao,0) = ISNULL(CCART.IDArtigoDimensao,0))
									AND isnull(CCART.Quantidade,0) = 0 AND isnull(CCART.QuantidadeStock,0) = 0 AND isnull(CCART.QuantidadeStock2,0) = 0  AND isnull(CCART.QuantidadeReservada,0) = 0 AND isnull(CCART.QuantidadeReservada2,0) = 0
							
							-- apagar CCartigos
							DELETE FROM tbCCStockArtigos WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento
						END

						
				END	
			SET @strSqlQueryUpdates ='' update c set c.IDLoja=a.idloja from  tbArmazens a inner join tbCCStockArtigos c on a.id=c.IDArmazem where  a.idloja<>c.IDLoja ''
			EXEC(@strSqlQueryUpdates) 
			SET @strSqlQueryUpdates ='' update c set c.IDLoja=a.idloja from  tbArmazens a inner join tbStockArtigos c on a.id=c.IDArmazem where  a.idloja<>c.IDLoja ''
			EXEC(@strSqlQueryUpdates) 


			SET @strSqlQueryUpdates ='' update a set a.quantidade=b.quantidade,a.quantidadestock=b.quantidadestock, a.quantidadestock2=b.quantidadestock2, a.quantidadereservada=b.quantidadereservada, a.quantidadereservada2=b.quantidadereservada2
									from tbStockArtigos a inner join (select idartigo, idloja, idarmazem, idarmazemlocalizacao, idartigolote, IDArtigoNumeroSerie,IDArtigoDimensao, sum(quantidade) as quantidade, sum(quantidadestock) as quantidadestock, sum(quantidadestock2) as quantidadestock2, sum(quantidadereservada) as quantidadereservada, sum(quantidadereservada2) as quantidadereservada2 from tbStockArtigos group by idartigo, idloja, idarmazem, idarmazemlocalizacao, idartigolote, IDArtigoNumeroSerie,IDArtigoDimensao having count(id)>1) b 
									on a.IDArtigo=b.IDArtigo and a.idloja=b.idloja and a.idarmazem=b.idarmazem and a.idarmazemlocalizacao=b.IDArmazemLocalizacao and isnull(a.idartigolote,0)=isnull(b.idartigolote,0) and isnull(a.IDArtigoNumeroSerie,0)=isnull(b.IDArtigoNumeroSerie,0) and isnull(a.IDArtigoDimensao,0)=isnull(b.IDArtigoDimensao,0) ''
			EXEC(@strSqlQueryUpdates) 

			SET @strSqlQueryUpdates ='' delete a from tbStockArtigos a inner join (select min(id) as id, idartigo, idloja, idarmazem, idarmazemlocalizacao, idartigolote, IDArtigoNumeroSerie,IDArtigoDimensao, sum(quantidade) as quantidade, sum(quantidadestock) as quantidadestock, sum(quantidadestock2) as quantidadestock2, sum(quantidadereservada) as quantidadereservada, sum(quantidadereservada2) as quantidadereservada2
									from tbStockArtigos group by idartigo, idloja, idarmazem, idarmazemlocalizacao, idartigolote, IDArtigoNumeroSerie,IDArtigoDimensao having count(id)>1) b 
									on a.IDArtigo=b.IDArtigo and a.idloja=b.idloja and a.idarmazem=b.idarmazem and a.idarmazemlocalizacao=b.IDArmazemLocalizacao and a.id=b.id and isnull(a.idartigolote,0)=isnull(b.idartigolote,0) ''
			EXEC(@strSqlQueryUpdates) 

		END


	ELSE--copiar a partir daqui
		BEGIN
			SELECT @strModulo = M.Codigo,  @strTipoDocInterno = STD.Tipo, @strCodMovStock = TDMS.Codigo
			FROM tbTiposDocumento TD
			LEFT JOIN tbSistemaModulos M ON M.ID = TD.IDModulo
			LEFT JOIN tbSistemaTiposDocumento STD ON STD.ID = TD.IDSistemaTiposDocumento
			LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TD.IDSistemaTiposDocumentoMovStock
			LEFT JOIN tbSistemaAcoes as AcaoRutura ON AcaoRutura.id=TD.IDSistemaAcoesRupturaStock
			LEFT JOIN tbSistemaAcoes as AcaoLimiteMax ON AcaoLimiteMax.id=TD.IDSistemaAcoesStockMaximo
			LEFT JOIN tbSistemaAcoes as AcaoLimiteMin ON AcaoLimiteMin.id=TD.IDSistemaAcoesStockMinimo
			WHERE ISNULL(TD.GereStock,0) = 0 AND TD.ID=@lngidTipoDocumento

			if (@strTipoDocInterno = ''CmpFinanceiro'')
				 BEGIN
					IF (@intAccao = 0 OR @intAccao = 1) 
						BEGIN
							--3) Linhas que existiam e agora deixaram de existir no documento, para essas, marcar a linha à frente desse artigo para recalcular a partir daí
							---  caso não existe nenhum para à frente não marcar nenhuma
							IF (@intAccao = 1) --se é alterar
								BEGIN
									IF  len(@strTabelaLinhasDist)>0
										BEGIN
											SET @strQueryLeftJoinDistUpdates = '' LEFT JOIN '' + QUOTENAME(@strTabelaLinhasDist) + '' AS LinhaDist ON (LinhaDist.'' + @strCampoRelTabelaLinhasDistLinhas + '' = CCartigos.IDLinhaDocumento AND isnull(CCartigos.IDArtigoDimensao,0) = isnull(LinhaDist.IDArtigoDimensao,0)) ''
											SET @strQueryWhereDistUpdates = '' AND isnull(CCART.IDArtigoDimensao,0) = isnull(Docs.IDArtigoDimensao,0) '' 
											SET @strQueryCamposDistUpdates =''isnull(CCartigos.IDArtigoDimensao,0) as IDArtigoDimensao, ''
											SET @strQueryWhereDistUpdates1 = '' AND isnull(CCA.IDArtigoDimensao,0) = isnull(Doc.IDArtigoDimensao,0) '' 
											SET @strQueryCamposDistUpdates1 =''isnull(CCART.IDArtigoDimensao,0) as IDArtigoDimensao, ''
											SET @strQueryGroupbyDistUpdates = '', isnull(CCART.IDArtigoDimensao,0)''
											SET @strQueryWhereFrente = '' AND isnull(CCA.IDArtigoDimensao,0) = isnull(Frente.IDArtigoDimensao,0) ''
											SET @strQueryONDist = '' OR (LinhaDist.ID IS NULL AND isnull(CCartigos.IDArtigoDimensao,0) <> 0) ''
										END
									ELSE
										BEGIN
											SET @strQueryLeftJoinDistUpdates = '' ''
											SET @strQueryWhereDistUpdates = ''''
											SET @strQueryCamposDistUpdates ='' ''
											SET @strQueryWhereDistUpdates1 = '' '' 
											SET @strQueryCamposDistUpdates1 ='' ''
											SET @strQueryGroupbyDistUpdates = '' ''	
											SET @strQueryWhereFrente = '' ''	
											SET @strQueryONDist = '' ''
										END
										SET @strQueryDocsUpdates = ''LEFT JOIN 
													(SELECT distinct CCartigos.IDArtigo,'' + @strQueryCamposDistUpdates + '' CCartigos.DataControloInterno  FROM  tbCCStockArtigos AS CCartigos
													LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCartigos.IDTipoDocumento
													LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
													LEFT JOIN '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas ON (Linhas.'' + @strCampoRelTabelaLinhasCab + '' = CCartigos.IDDocumento AND CCartigos.IDLinhaDocumento=Linhas.id AND Linhas.IDArtigo = CCartigos.IDArtigo) 
													'' + @strQueryLeftJoinDistUpdates + ''
													LEFT JOIN tbArtigos AS Art ON Art.ID = CCartigos.IDArtigo 
													WHERE CCartigos.IDDocumento='' + Convert(nvarchar,@lngidDocumento) + '' AND CCartigos.IDTipoDocumento='' + Convert(nvarchar,@lngidTipoDocumento) + ''
													AND (CCartigos.Natureza=''''E'''' OR CCartigos.Natureza=''''S'''')
													AND (Linhas.ID IS NULL '' + @strQueryONDist + '')
													AND NOT CCartigos.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''')
													) AS Docs
													ON (Docs.IDArtigo = CCART.IDArtigo '' + @strQueryWhereDistUpdates + '')''
									

										SET @strQueryDocsAFrente ='' (SELECT CCART.IDArtigo, '' + @strQueryCamposDistUpdates1 + '' Min(CCART.DataControloInterno) as Data FROM tbCCStockArtigos AS CCART
												LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCART.IDTipoDocumento
												LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
												LEFT JOIN tbArtigos AS Art ON Art.ID = CCART.IDArtigo ''
												+ @strQueryDocsUpdates +
												'' WHERE CCART.DataControloInterno >= Docs.DataControloInterno and (CCART.IDDocumento<>'' + Convert(nvarchar,@lngidDocumento) + '' OR CCART.IDTipoDocumento<>'' + Convert(nvarchar,@lngidTipoDocumento) + '') and (CCART.Natureza=''''E'''' OR CCART.Natureza=''''S'''')
												AND NOT CCART.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''')
												GROUP BY  CCART.IDArtigo'' + @strQueryGroupbyDistUpdates + '') AS Frente
												ON (Frente.IDArtigo = CCA.IDArtigo '' + @strQueryWhereFrente + '' AND Frente.Data = CCA.DataControloInterno) ''

										SET @strSqlQueryUpdates ='' UPDATE tbCCStockArtigos SET Recalcular = 1 FROM tbCCStockArtigos AS CCA
											LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCA.IDTipoDocumento
											LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
											LEFT JOIN tbArtigos AS Art ON Art.ID = CCA.IDArtigo
											INNER JOIN ''
											+ @strQueryDocsAFrente + 
											'' WHERE (CCA.IDDocumento<>'' + Convert(nvarchar,@lngidDocumento) + '' OR CCA.IDTipoDocumento<>'' + Convert(nvarchar,@lngidTipoDocumento) + '') and (CCA.Natureza=''''E'''' OR CCA.Natureza=''''S'''')
											AND NOT CCA.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''')
											AND NOT Frente.IDArtigo IS NULL ''

									EXEC(@strSqlQueryUpdates)
								END
							Execute sp_RegistaCCRetCompras @lngidDocumento, @lngidTipoDocumento, 1, @strUtilizador ---verifica
							DELETE FROM tbCCStockArtigos WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento ---apaga
							Execute sp_RegistaCCRetCompras @lngidDocumento, @lngidTipoDocumento, 0, @strUtilizador ---adiciona
						END
					else
						BEGIN
							--3) Linhas que existiam e agora deixaram de existir no documento, para essas, marcar a linha à frente desse artigo para recalcular a partir daí
							---  caso não existe nenhum para à frente não marcar nenhuma
							IF  len(@strTabelaLinhasDist)>0
								BEGIN
									SET @strQueryLeftJoinDistUpdates = '' LEFT JOIN '' + QUOTENAME(@strTabelaLinhasDist) + '' AS LinhaDist ON (LinhaDist.'' + @strCampoRelTabelaLinhasDistLinhas + '' = CCartigos.IDLinhaDocumento AND isnull(CCartigos.IDArtigoDimensao,0) = isnull(LinhaDist.IDArtigoDimensao,0)) ''
									SET @strQueryWhereDistUpdates = '' AND isnull(CCART.IDArtigoDimensao,0) = isnull(Docs.IDArtigoDimensao,0) '' 
									SET @strQueryCamposDistUpdates =''isnull(CCartigos.IDArtigoDimensao,0) as IDArtigoDimensao, ''
									SET @strQueryWhereDistUpdates1 = '' AND isnull(CCA.IDArtigoDimensao,0) = isnull(Doc.IDArtigoDimensao,0) '' 
									SET @strQueryCamposDistUpdates1 =''isnull(CCART.IDArtigoDimensao,0) as IDArtigoDimensao, ''
									SET @strQueryGroupbyDistUpdates = '', isnull(CCART.IDArtigoDimensao,0)''
									SET @strQueryWhereFrente = '' AND isnull(CCA.IDArtigoDimensao,0) = isnull(Frente.IDArtigoDimensao,0) ''
									SET @strQueryONDist = '' OR (LinhaDist.ID IS NULL AND isnull(CCartigos.IDArtigoDimensao,0) <> 0) ''
								END
							ELSE
								BEGIN
									SET @strQueryLeftJoinDistUpdates = '' ''
									SET @strQueryWhereDistUpdates = ''''
									SET @strQueryCamposDistUpdates ='' ''
									SET @strQueryWhereDistUpdates1 = '' '' 
									SET @strQueryCamposDistUpdates1 ='' ''
									SET @strQueryGroupbyDistUpdates = '' ''	
									SET @strQueryWhereFrente = '' ''	
									SET @strQueryONDist = '' ''
								END
								SET @strQueryDocsUpdates = ''LEFT JOIN 
											(SELECT distinct CCartigos.IDArtigo,'' + @strQueryCamposDistUpdates + '' CCartigos.DataControloInterno  FROM  tbCCStockArtigos AS CCartigos
											LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCartigos.IDTipoDocumento
											LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
											LEFT JOIN '' + QUOTENAME(@strTabelaLinhas) + '' AS Linhas ON (Linhas.'' + @strCampoRelTabelaLinhasCab + '' = CCartigos.IDDocumento AND CCartigos.IDLinhaDocumento=Linhas.id AND Linhas.IDArtigo = CCartigos.IDArtigo) 
											'' + @strQueryLeftJoinDistUpdates + ''
											LEFT JOIN tbArtigos AS Art ON Art.ID = CCartigos.IDArtigo 
											WHERE CCartigos.IDDocumento='' + Convert(nvarchar,@lngidDocumento) + '' AND CCartigos.IDTipoDocumento='' + Convert(nvarchar,@lngidTipoDocumento) + '' 
											AND (CCartigos.Natureza=''''E'''' OR CCartigos.Natureza=''''S'''')
											AND (Linhas.ID IS NULL '' + @strQueryONDist + '')
											AND NOT CCartigos.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''')
											) AS Docs
											ON (Docs.IDArtigo = CCART.IDArtigo '' + @strQueryWhereDistUpdates + '')''
									

								SET @strQueryDocsAFrente ='' (SELECT CCART.IDArtigo, '' + @strQueryCamposDistUpdates1 + '' Min(CCART.DataControloInterno) as Data FROM tbCCStockArtigos AS CCART
										LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCART.IDTipoDocumento
										LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
										LEFT JOIN tbArtigos AS Art ON Art.ID = CCART.IDArtigo ''
										+ @strQueryDocsUpdates +
										'' WHERE CCART.DataControloInterno >= Docs.DataControloInterno and (CCART.IDDocumento<>'' + Convert(nvarchar,@lngidDocumento) + '' OR CCART.IDTipoDocumento<>'' + Convert(nvarchar,@lngidTipoDocumento) + '') and (CCART.Natureza=''''E'''' OR CCART.Natureza=''''S'''')
										AND NOT CCART.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''')
										GROUP BY  CCART.IDArtigo'' + @strQueryGroupbyDistUpdates + '') AS Frente
										ON (Frente.IDArtigo = CCA.IDArtigo '' + @strQueryWhereFrente + '' AND Frente.Data = CCA.DataControloInterno) ''

								SET @strSqlQueryUpdates ='' UPDATE tbCCStockArtigos SET Recalcular = 1 FROM tbCCStockArtigos AS CCA
									LEFT JOIN tbTiposDocumento AS TpDoc ON TpDoc.ID =  CCA.IDTipoDocumento
									LEFT JOIN tbSistemaTiposDocumentoMovStock TDMS ON TDMS.id=TpDoc.IDSistemaTiposDocumentoMovStock
									LEFT JOIN tbArtigos AS Art ON Art.ID = CCA.IDArtigo
									INNER JOIN ''
									+ @strQueryDocsAFrente + 
									'' WHERE (CCA.IDDocumento<>'' + Convert(nvarchar,@lngidDocumento) + '' OR CCA.IDTipoDocumento<>'' + Convert(nvarchar,@lngidTipoDocumento) + '') and (CCA.Natureza=''''E'''' OR CCA.Natureza=''''S'''')
									AND NOT CCA.IDArtigo IS NULL AND ISNULL(Art.GereStock,0) <> 0 AND (ISNULL(TDMS.Codigo,0) = ''''002'''' OR ISNULL(TDMS.Codigo,0) = ''''003'''')
									AND NOT Frente.IDArtigo IS NULL ''

							EXEC(@strSqlQueryUpdates)

							DELETE FROM tbCCStockArtigos WHERE IDTipoDocumento = @lngidTipoDocumento AND IDDocumento = @lngidDocumento ---apaga
						END
				 END
		END


END TRY
BEGIN CATCH
	SET @ErrorMessage  = ERROR_MESSAGE()
    SET @ErrorSeverity = ERROR_SEVERITY()
    SET @ErrorState    = ERROR_STATE()
	RAISERROR(@ErrorMessage, @ErrorSeverity,@ErrorState)
END CATCH
END')
