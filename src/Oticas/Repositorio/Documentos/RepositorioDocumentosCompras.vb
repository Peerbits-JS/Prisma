Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Repositorio.Comum
Imports F3M.Modelos.Autenticacao

Namespace Repositorio.Documentos
    Public Class RepositorioDocumentosCompras
        Inherits RepositorioDocumentos(Of BD.Dinamica.Aplicacao, tbDocumentosCompras, DocumentosCompras)

        Private Shared codigoAcesso As String = "015.005.003"

#Region "CONTRUTORES"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of Oticas.DocumentosCompras)
            Dim result As IQueryable(Of DocumentosCompras) = AplicaQueryListaPersonalizada(inFiltro)

            If Not ClsF3MSessao.TemAcesso(AcoesFormulario.Consultar, codigoAcesso) Then
                result = result.Where(Function(f) f.IDLoja = ClsF3MSessao.RetornaLojaID)
            End If

            'If Not ClsF3MSessao.TemAcesso(AcoesFormulario.Consultar, "014.004.031") Then
            '    result = result.Where(Function(w) w.DocNaoValorizado)
            'End If

            Return result
        End Function

        Protected Overrides Function ListaCamposTodos(inQuery As IQueryable(Of tbDocumentosCompras)) As IQueryable(Of Oticas.DocumentosCompras)
            Dim funcSel As Func(Of tbDocumentosCompras, Oticas.DocumentosCompras) = Function(s) MapeiaEsp(s)
            Return inQuery.Select(funcSel).AsQueryable
        End Function

        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of Oticas.DocumentosCompras)
            Using repD As New RepositorioDocumentos
                Return repD.ListaDocs(Of tbDocumentosCompras,
                    Oticas.DocumentosCompras,
                    tbSistemaTiposDocumentoColunasAutomaticas,
                    tbDocumentosComprasLinhas,
                    Oticas.DocumentosComprasLinhas)(BDContexto, inFiltro, True, True)
            End Using
        End Function

        Protected Overrides Function ListaCamposCombo(inQuery As IQueryable(Of tbDocumentosCompras)) As IQueryable(Of Oticas.DocumentosCompras)
            Using repD As New RepositorioDocumentos
                Return repD.MapeiaLista(Of tbDocumentosCompras,
                    Oticas.DocumentosCompras,
                    tbSistemaTiposDocumentoColunasAutomaticas,
                    tbDocumentosComprasLinhas,
                    Oticas.DocumentosComprasLinhas)(inQuery, True)
            End Using
        End Function

        Public Function MapeiaEsp(inDocBD As tbDocumentosCompras) As Oticas.DocumentosCompras
            If inDocBD IsNot Nothing Then
                Dim docMOD As New Oticas.DocumentosCompras
                Dim docMODCA As New tbSistemaTiposDocumentoColunasAutomaticas
                ' Mapeia Generico
                RepositorioDocumentos.MapeiaCamposGen(Of tbDocumentosCompras,
                    Oticas.DocumentosCompras,
                    tbSistemaTiposDocumentoColunasAutomaticas,
                    tbDocumentosComprasLinhas,
                    Oticas.DocumentosComprasLinhas)(inDocBD, docMOD, docMODCA)
                ' Mapeia Especifico
                With docMOD
                    .RegistoBloqueado = RepositorioDocumentos.RegistoBloqueadoCompras(BDContexto, inDocBD.ID, inDocBD.IDTipoDocumento)
                    .DocNaoValorizado = inDocBD.tbTiposDocumento.DocNaoValorizado
                End With

                Return docMOD
            End If
            Return Nothing
        End Function

        Public Overrides Function ObtemPorObjID(idDocCompra As Object) As DocumentosCompras
            Dim idDocumentoCompra As Long = CLng(idDocCompra)

            Dim queryCompras = tabela.AsNoTracking _
                .Include("tbDocumentosComprasLinhas") _
                .Include("tbDocumentosComprasLinhas.tbArtigos") _
                .Include("tbDocumentosComprasLinhas.tbArmazens") _
                .Include("tbDocumentosComprasLinhas.tbArmazensLocalizacoes") _
                .Include("tbDocumentosComprasLinhas.tbArmazens1") _
                .Include("tbDocumentosComprasLinhas.tbArmazensLocalizacoes1") _
                .Include("tbDocumentosComprasLinhas.tbIVA") _
                .Include("tbDocumentosComprasLinhas.tbUnidades") _
                .Include("tbDocumentosComprasLinhas.tbUnidades1") _
                .Include("tbDocumentosComprasLinhas.tbArtigos.tbTiposArtigos") _
                .Include("tbDocumentosComprasLinhas.tbDocumentosComprasLinhasDimensoes") _
                .Where(Function(dc) dc.ID = idDocumentoCompra)

            Return ListaCamposTodos(queryCompras).FirstOrDefault
        End Function


#End Region

#Region "ESCRITA"
        Public Overrides Sub AdicionaObj(ByRef o As Oticas.DocumentosCompras, inFiltro As ClsF3MFiltro)
            RepositorioDocumentos.AdicionaDoc(
                                Of Oticas.BD.Dinamica.Aplicacao, tbTiposDocumento, tbTiposDocumentoSeries, tbDocumentosCompras, DocumentosCompras,
                tbDocumentosComprasLinhas, DocumentosComprasLinhas, tbDocumentosComprasLinhasDimensoes, DocumentosComprasLinhasDimensoes,
                tbEstados, tbStockArtigos, tbArtigos, tbArtigosStock, tbArtigosDimensoes, tbSemafroGereStock, tbParametrosCamposContexto,
                tbSistemaTiposDocumentoComunicacao, tbATEstadoComunicacao, tbSistemaEspacoFiscal, tbSistemaRegimeIVA,
                tbDocumentosComprasPendentes, tbSistemaTiposDocumentoImportacao, tbControloValidacaoStock, tbTiposArtigos,
                 tbDocumentosStock, DocumentosStock, tbDocumentosStockLinhas, DocumentosStockLinhas, tbDocumentosStockLinhasDimensoes, DocumentosStockLinhasDimensoes,
                 tbStockArtigosNecessidades)(
                    o, inFiltro, CamposGenericos.IDDocCompra, CamposGenericos.IDDocCompraLin)
        End Sub

        Public Overrides Sub EditaObj(ByRef o As Oticas.DocumentosCompras, inFiltro As ClsF3MFiltro)
            RepositorioDocumentos.EditaDoc(
                Of Oticas.BD.Dinamica.Aplicacao, tbTiposDocumento, tbTiposDocumentoSeries, tbDocumentosCompras,
                tbDocumentosComprasLinhas, tbDocumentosComprasLinhasDimensoes, DocumentosCompras, DocumentosComprasLinhas,
                DocumentosComprasLinhasDimensoes, tbEstados, tbStockArtigos, tbArtigos, tbArtigosStock, tbArtigosDimensoes,
                tbSemafroGereStock, tbParametrosCamposContexto, tbSistemaTiposDocumentoComunicacao, tbATEstadoComunicacao,
                tbSistemaEspacoFiscal, tbSistemaRegimeIVA, tbDocumentosComprasPendentes, tbSistemaTiposDocumentoImportacao,
                tbControloValidacaoStock, tbTiposArtigos,
                 tbDocumentosStock, DocumentosStock, tbDocumentosStockLinhas, DocumentosStockLinhas, tbDocumentosStockLinhasDimensoes, DocumentosStockLinhasDimensoes,
                 tbStockArtigosNecessidades)(o, inFiltro, CamposGenericos.IDDocCompra, CamposGenericos.IDDocCompraLin)
        End Sub

        Public Overrides Sub RemoveObj(ByRef o As Oticas.DocumentosCompras, inFiltro As ClsF3MFiltro)
            RepositorioDocumentos.RemoveDoc(
                Of Oticas.BD.Dinamica.Aplicacao, tbTiposDocumento, tbTiposDocumentoSeries, tbDocumentosCompras, tbDocumentosComprasLinhas,
                tbDocumentosComprasLinhasDimensoes, DocumentosComprasLinhas, DocumentosComprasLinhasDimensoes, tbEstados,
                tbStockArtigos, tbArtigos, tbArtigosDimensoes, DocumentosCompras, tbDocumentosComprasPendentes, tbControloValidacaoStock,
                 tbDocumentosStock, DocumentosStock, tbDocumentosStockLinhas, DocumentosStockLinhas, tbDocumentosStockLinhasDimensoes, DocumentosStockLinhasDimensoes,
                 tbStockArtigosNecessidades, tbSistemaTiposDocumentoImportacao)(
                    o, inFiltro, CamposGenericos.IDDocCompra, CamposGenericos.IDDocCompraLin)
        End Sub
#End Region

        Public Sub PreencheDadosLoja(modelo As DocumentosCompras)
            Try
                Dim IDLoja As Long = ClsF3MSessao.RetornaLojaID
                Dim IDLojaSede As Long = ClsF3MSessao.RetornaIDLojaSede

                modelo.IDLojaSede = IDLojaSede

                If IDLoja <> IDLojaSede Then
                    Dim ParamLojaSede As ParametrosLoja = (From x In BDContexto.tbParametrosLoja
                                                           Where x.IDLoja = IDLojaSede
                                                           Select New ParametrosLoja With {
                                                 .ID = x.ID,
                                                 .Morada = x.Morada,
                                                 .CodigoPostal = x.CodigoPostal,
                                                 .Localidade = x.Localidade,
                                                 .NIF = x.NIF,
                                                 .DesignacaoComercial = x.DesignacaoComercial,
                                                .Telefone = x.Telefone}).FirstOrDefault()

                    modelo.MoradaSede = ParamLojaSede.Morada
                    modelo.CodigoPostalSede = ParamLojaSede.CodigoPostal
                    modelo.LocalidadeSede = ParamLojaSede.Localidade
                    modelo.TelefoneSede = ParamLojaSede.Telefone
                End If
            Catch ex As Exception
                Throw
            End Try
        End Sub

        Public Sub DefineCamposEvitaMapear(modelo As DocumentosCompras)
            Try
                modelo.ListaCamposEvitaMapear.Add("IDLojaSede")
                modelo.ListaCamposEvitaMapear.Add("MoradaSede")
                modelo.ListaCamposEvitaMapear.Add("CodigoPostalSede")
                modelo.ListaCamposEvitaMapear.Add("LocalidadeSede")
                modelo.ListaCamposEvitaMapear.Add("TelefoneSede")
            Catch ex As Exception
                Throw
            End Try
        End Sub

#Region "COPY"
        Public Function RetornaModSelectTipoDocDuplica(ByVal idDocumento As Long) As F3M.DocumentosSelectTipoDocDuplicar
            Return tabela.
                AsNoTracking().
                Where(Function(entity) entity.ID = idDocumento).
                Select(Function(entity) New F3M.DocumentosSelectTipoDocDuplicar With {
                .IDDuplicar = entity.ID, .DocumentoDuplicar = entity.Documento,
                .DescricaoDocumentoDuplicar = entity.tbTiposDocumento.Descricao & " " & entity.Documento,
                .IDSistemaTipoEntidadeDuplicar = entity.IDTipoEntidade,
                .IDTipoDocumentoDuplicar = entity.tbTiposDocumento.ID, .DescricaoTipoDocumentoDuplicar = entity.tbTiposDocumento.Descricao,
                .IDModuloDuplicar = entity.tbTiposDocumento.IDModulo, .CodigoTipoDocumentoDuplicar = entity.tbTiposDocumento.Codigo,
                .IDTiposDocumentoSeriesDuplicar = entity.tbTiposDocumentoSeries.ID, .DescricaoTiposDocumentoSeriesDuplicar = entity.tbTiposDocumentoSeries.DescricaoSerie,
                .CodigoTipoDocumentoSeriesDuplicar = entity.tbTiposDocumentoSeries.CodigoSerie}).
                FirstOrDefault()
        End Function
#End Region


    End Class
End Namespace