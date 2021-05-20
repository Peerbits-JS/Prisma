Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Repositorio.Comum

Namespace Repositorio.Documentos
    Public Class RepositorioDocumentosStock
        Inherits RepositorioDocumentos(Of BD.Dinamica.Aplicacao, tbDocumentosStock, DocumentosStock)

        Private Shared codigoAcesso As String = "015.005.003"

#Region "CONTRUTORES"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of Oticas.DocumentosStock)
            Dim result As IQueryable(Of DocumentosStock) = AplicaQueryListaPersonalizada(inFiltro)

            If Not ClsF3MSessao.TemAcesso(AcoesFormulario.Consultar, codigoAcesso) Then
                result = result.Where(Function(f) f.IDLoja = ClsF3MSessao.RetornaLojaID)
            End If

            'If Not ClsF3MSessao.TemAcesso(AcoesFormulario.Consultar, "014.004.031") Then
            '    result = result.Where(Function(w) w.DocNaoValorizado)
            'End If

            Return result
        End Function

        Protected Overrides Function ListaCamposTodos(inQuery As IQueryable(Of tbDocumentosStock)) As IQueryable(Of Oticas.DocumentosStock)
            Dim funcSel As Func(Of tbDocumentosStock, Oticas.DocumentosStock) = Function(s) MapeiaEsp(s)
            Return inQuery.Select(funcSel).AsQueryable
        End Function

        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of Oticas.DocumentosStock)
            Using repD As New RepositorioDocumentos
                Return repD.ListaDocs(Of tbDocumentosStock, Oticas.DocumentosStock, tbSistemaTiposDocumentoColunasAutomaticas, tbDocumentosStockLinhas, Oticas.DocumentosStockLinhas)(BDContexto, inFiltro, True, True)
            End Using
        End Function

        Protected Overrides Function ListaCamposCombo(inQuery As IQueryable(Of tbDocumentosStock)) As IQueryable(Of Oticas.DocumentosStock)
            Using repD As New RepositorioDocumentos
                Return repD.MapeiaLista(Of tbDocumentosStock, Oticas.DocumentosStock, tbSistemaTiposDocumentoColunasAutomaticas, tbDocumentosStockLinhas, Oticas.DocumentosStockLinhas)(inQuery, True)
            End Using
        End Function

        Public Function MapeiaEsp(inDocBD As tbDocumentosStock) As Oticas.DocumentosStock
            If inDocBD IsNot Nothing Then
                Dim docMOD As New Oticas.DocumentosStock
                Dim docMODCA As New tbSistemaTiposDocumentoColunasAutomaticas
                ' Mapeia Generico
                RepositorioDocumentos.MapeiaCamposGen(Of tbDocumentosStock, Oticas.DocumentosStock, tbSistemaTiposDocumentoColunasAutomaticas, tbDocumentosStockLinhas, Oticas.DocumentosStockLinhas)(inDocBD, docMOD, docMODCA)
                ' Mapeia Especifico
                With docMOD
                    .RegistoBloqueado = RepositorioDocumentos.RegistoBloqueadoStock(BDContexto, inDocBD.ID, inDocBD.IDTipoDocumento)
                    .DocNaoValorizado = inDocBD.tbTiposDocumento.DocNaoValorizado
                End With

                Return docMOD
            End If
            Return Nothing
        End Function

#End Region

#Region "ESCRITA"
        '' ADICIONA POR OBJETO
        Public Overrides Sub AdicionaObj(ByRef o As Oticas.DocumentosStock, inFiltro As ClsF3MFiltro)
            RepositorioDocumentos.AdicionaDoc(
                Of Oticas.BD.Dinamica.Aplicacao, tbTiposDocumento, tbTiposDocumentoSeries, tbDocumentosStock, DocumentosStock,
                tbDocumentosStockLinhas, DocumentosStockLinhas, tbDocumentosStockLinhasDimensoes, DocumentosStockLinhasDimensoes,
                tbEstados, tbStockArtigos, tbArtigos, tbArtigosStock, tbArtigosDimensoes, tbSemafroGereStock, tbParametrosCamposContexto,
                tbSistemaTiposDocumentoComunicacao, tbATEstadoComunicacao, tbSistemaEspacoFiscal, tbSistemaRegimeIVA, Object,
                tbSistemaTiposDocumentoImportacao, tbControloValidacaoStock, tbTiposArtigos,
                 Object, DocumentosStock, Object, DocumentosStockLinhas, Object, DocumentosStockLinhasDimensoes, tbStockArtigosNecessidades)(
                    o, inFiltro, CamposGenericos.IDDocStock, CamposGenericos.IDDocStockLin)
        End Sub

        ' EDITA POR OBJETO
        Public Overrides Sub EditaObj(ByRef o As Oticas.DocumentosStock, inFiltro As ClsF3MFiltro)
            RepositorioDocumentos.EditaDoc(
                Of Oticas.BD.Dinamica.Aplicacao, tbTiposDocumento, tbTiposDocumentoSeries, tbDocumentosStock, tbDocumentosStockLinhas,
                tbDocumentosStockLinhasDimensoes, DocumentosStock, DocumentosStockLinhas, DocumentosStockLinhasDimensoes, tbEstados,
                tbStockArtigos, tbArtigos, tbArtigosStock, tbArtigosDimensoes, tbSemafroGereStock, tbParametrosCamposContexto,
                tbSistemaTiposDocumentoComunicacao, tbATEstadoComunicacao, tbSistemaEspacoFiscal, tbSistemaRegimeIVA, Object,
                tbSistemaTiposDocumentoImportacao, tbControloValidacaoStock, tbTiposArtigos,
                 Object, DocumentosStock, Object, DocumentosStockLinhas, Object, DocumentosStockLinhasDimensoes, tbStockArtigosNecessidades)(
                    o, inFiltro, CamposGenericos.IDDocStock, CamposGenericos.IDDocStockLin)
        End Sub

        ' REMOVE POR OBJETO
        Public Overrides Sub RemoveObj(ByRef o As Oticas.DocumentosStock, inFiltro As ClsF3MFiltro)
            RepositorioDocumentos.RemoveDoc(
                Of Oticas.BD.Dinamica.Aplicacao, tbTiposDocumento, tbTiposDocumentoSeries, tbDocumentosStock, tbDocumentosStockLinhas,
                tbDocumentosStockLinhasDimensoes, DocumentosStockLinhas, DocumentosStockLinhasDimensoes, tbEstados,
                tbStockArtigos, tbArtigos, tbArtigosDimensoes, DocumentosStock, Object, tbControloValidacaoStock,
                 Object, DocumentosStock, Object, DocumentosStockLinhas, Object, DocumentosStockLinhasDimensoes, tbStockArtigosNecessidades, tbSistemaTiposDocumentoImportacao)(
                    o, inFiltro, CamposGenericos.IDDocStock, CamposGenericos.IDDocStockLin)
        End Sub
#End Region

        Public Sub PreencheDadosLoja(modelo As DocumentosStock)
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

        Public Sub DefineCamposEvitaMapear(modelo As DocumentosStock)
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