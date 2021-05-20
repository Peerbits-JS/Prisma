Imports System.Data.Entity
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports F3M.Repositorios.Administracao

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioTiposDocumentoSeries
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbTiposDocumentoSeries, TiposDocumentoSeries)

        Dim EMultiEmpresa As Boolean = ClsF3MSessao.VerificaSessaoObjeto().Licenciamento.ExisteModulo(ModulosLicenciamento.Prisma.MultiEmpresa)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbTiposDocumentoSeries)) As IQueryable(Of TiposDocumentoSeries)

            Dim listaAux As List(Of tbTiposDocumentoSeries) = query.ToList

            Dim funcSel As Func(Of tbTiposDocumentoSeries, TiposDocumentoSeries) =
              Function(e) New TiposDocumentoSeries With {
                .ID = e.ID, .IDTiposDocumento = e.IDTiposDocumento, .CodigoSerie = e.CodigoSerie, .DescricaoSerie = e.DescricaoSerie, .SugeridaPorDefeito = e.SugeridaPorDefeito, .AtivoSerie = e.AtivoSerie, .Sistema = e.Sistema,
                .CalculaComissoesSerie = e.CalculaComissoesSerie, .AnalisesEstatisticasSerie = e.AnalisesEstatisticasSerie, .IVAIncluido = e.IVAIncluido, .IVARegimeCaixa = e.IVARegimeCaixa,
                .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao, .Ordem = e.Ordem, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador, .Ativo = e.AtivoSerie,
                .DataInicial = e.DataInicial, .DataFinal = e.DataFinal, .IDSistemaTiposDocumentoOrigem = e.IDSistemaTiposDocumentoOrigem, .NumeroVias = e.NumeroVias, .IDSistemaTiposDocumentoComunicacao = e.IDSistemaTiposDocumentoComunicacao,
                .IDMapasVistas = e.IDMapasVistas, .MapaBin = If(e.tbMapasVistas.MapaBin IsNot Nothing, True, False), .MapaXml = If(e.tbMapasVistas.MapaXML IsNot Nothing, True, False),
                .CodigoSistemaTiposDocumentoOrigem = If(e.tbSistemaTiposDocumentoOrigem IsNot Nothing, e.tbSistemaTiposDocumentoOrigem.Codigo, Nothing),
                .DescricaoMapasVistas = If(e.tbMapasVistas IsNot Nothing, e.tbMapasVistas.Descricao, String.Empty),
                .Certificado = If(e.tbMapasVistas IsNot Nothing, e.tbMapasVistas.Certificado, Nothing),
                .Entidade = If(e.tbMapasVistas IsNot Nothing, e.tbMapasVistas.Entidade, String.Empty),
                .IDParametrosEmpresaCAE = If(e.tbParametrosEmpresaCAE IsNot Nothing, e.tbParametrosEmpresaCAE.ID, Nothing),
                .DescricaoSistemaTiposDocumentoOrigem = If(e.tbSistemaTiposDocumentoOrigem IsNot Nothing, e.tbSistemaTiposDocumentoOrigem.Descricao, String.Empty),
                .DescricaoSistemaTiposDocumentoComunicacao = If(e.tbSistemaTiposDocumentoComunicacao IsNot Nothing, e.tbSistemaTiposDocumentoComunicacao.Descricao, String.Empty),
                .CodigoSistemaTiposDocumentoComunicacao = If(e.tbSistemaTiposDocumentoComunicacao IsNot Nothing, e.tbSistemaTiposDocumentoComunicacao.Codigo, String.Empty),
                .IDLoja = e.IDLoja, .ATCodValidacaoSerie = e.ATCodValidacaoSerie,
                .DescricaoLoja = If(e.tbLojas IsNot Nothing, e.tbLojas.Descricao, String.Empty),
                .NumUltimoDoc = RetornaNumUltimoDocF(e),
                .DataUltimoDoc = RetornaDataUltimoDoc(e),
                .DescricaoParametrosEmpresaCAE = RetornaParametrosEmpresaCAE(e),
                .BlnTemDocAssoc = RetornaTemDocAssoc(e)}

            Dim list = listaAux.Select(funcSel).AsQueryable
            Return list

            'Return query.Select(Function(e) New TiposDocumentoSeries With {
            '    .ID = e.ID, .IDTiposDocumento = e.IDTiposDocumento, .CodigoSerie = e.CodigoSerie, .DescricaoSerie = e.DescricaoSerie,
            '    .SugeridaPorDefeito = e.SugeridaPorDefeito, .AtivoSerie = e.AtivoSerie, .Sistema = e.Sistema,
            '    .CalculaComissoesSerie = e.CalculaComissoesSerie, .AnalisesEstatisticasSerie = e.AnalisesEstatisticasSerie, .IVAIncluido = e.IVAIncluido, .IVARegimeCaixa = e.IVARegimeCaixa,
            '    .DataInicial = e.DataInicial, .DataFinal = e.DataFinal, .NumUltimoDoc = If(e.tbControloDocumentos.Where(Function(r) r.NumeroDocumento <> 0).Count > 0, e.tbControloDocumentos.Where(Function(r) r.NumeroDocumento <> 0).Max(Function(s) s.NumeroDocumento), e.NumUltimoDoc), .DataUltimoDoc = If(e.tbControloDocumentos.Where(Function(r) r.NumeroDocumento <> 0).Count > 0, e.tbControloDocumentos.Where(Function(r) r.NumeroDocumento <> 0).Max(Function(s) s.DataDocumento), e.DataUltimoDoc),
            '    .IDSistemaTiposDocumentoOrigem = e.IDSistemaTiposDocumentoOrigem, .DescricaoSistemaTiposDocumentoOrigem = e.tbSistemaTiposDocumentoOrigem.Descricao,
            '    .NumeroVias = e.NumeroVias, .IDSistemaTiposDocumentoComunicacao = e.IDSistemaTiposDocumentoComunicacao,
            '    .IDMapasVistas = e.IDMapasVistas, .DescricaoMapasVistas = e.tbMapasVistas.Descricao, .Certificado = e.tbMapasVistas.Certificado, .MapaBin = If(e.tbMapasVistas.MapaBIN IsNot Nothing, True, False), .MapaXml = If(e.tbMapasVistas.MapaXML IsNot Nothing, True, False), .Entidade = e.tbMapasVistas.Entidade,
            '    .DescricaoSistemaTiposDocumentoComunicacao = e.tbSistemaTiposDocumentoComunicacao.Descricao,
            '    .CodigoSistemaTiposDocumentoComunicacao = e.tbSistemaTiposDocumentoComunicacao.Codigo,
            '    .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao, .Ordem = e.Ordem,
            '    .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador, .Ativo = e.AtivoSerie,
            '    .IDParametrosEmpresaCAE = e.tbParametrosEmpresaCAE.ID,
            '    .DescricaoParametrosEmpresaCAE = String.Concat(e.tbParametrosEmpresaCAE.Codigo, " - ", e.tbParametrosEmpresaCAE.Descricao),
            '    .CodigoSistemaTiposDocumentoOrigem = If(e.tbSistemaTiposDocumentoOrigem IsNot Nothing, e.tbSistemaTiposDocumentoOrigem.Codigo, Nothing)})
        End Function
        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbTiposDocumentoSeries)) As IQueryable(Of TiposDocumentoSeries)
            Return ListaCamposTodos(query).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of TiposDocumentoSeries)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of TiposDocumentoSeries)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' LISTA ESPECIFICO PARA SERIES EDITADAS
        Public Function ListaEsp(IDTipoDoc As Long) As List(Of TiposDocumentoSeries)
            Dim query As IQueryable(Of tbTiposDocumentoSeries) = tabela.Where(Function(w) w.IDTiposDocumento = IDTipoDoc).AsQueryable
            Dim dataSeries As List(Of TiposDocumentoSeries) = ListaCamposTodos(query).ToList()
            Dim lstSeries As New List(Of TiposDocumentoSeries)
            For Each item In dataSeries
                Dim objSerie As New TiposDocumentoSeries
                With objSerie
                    .AcaoRemover = item.AcaoRemover
                    .AnalisesEstatisticasSerie = item.AnalisesEstatisticasSerie
                    .AtivoSerie = item.AtivoSerie
                    .CalculaComissoesSerie = item.CalculaComissoesSerie
                    .CodigoSerie = item.CodigoSerie
                    .DataCriacao = item.DataCriacao
                    .DescricaoSerie = item.DescricaoSerie
                    .ID = item.ID
                    .IDLoja = item.IDLoja
                    .DescricaoLoja = item.DescricaoLoja
                    .IDMapasVistas = item.IDMapasVistas
                    .IDParametrosEmpresaCAE = item.IDParametrosEmpresaCAE
                    .IDSistemaTiposDocumentoComunicacao = item.IDSistemaTiposDocumentoComunicacao
                    .DescricaoSistemaTiposDocumentoComunicacao = item.DescricaoSistemaTiposDocumentoComunicacao
                    .CodigoSistemaTiposDocumentoComunicacao = item.CodigoSistemaTiposDocumentoComunicacao
                    .IDSistemaTiposDocumentoOrigem = item.IDSistemaTiposDocumentoOrigem
                    .IDTiposDocumento = item.IDTiposDocumento
                    .IVAIncluido = item.IVAIncluido
                    .IVARegimeCaixa = item.IVARegimeCaixa
                    .NumeroVias = item.NumeroVias
                    .SugeridaPorDefeito = item.SugeridaPorDefeito
                    .TiposDocumentoSeriesPermissoes = RepositorioTiposDocumentoSeriesPermissoes.RetornaPermissoesTabela(item.ID)
                    .UtilizadorCriacao = item.UtilizadorCriacao
                    .BlnTemDocAssoc = item.BlnTemDocAssoc
                    .ATCodValidacaoSerie = item.ATCodValidacaoSerie
                End With
                lstSeries.Add(objSerie)
            Next

            Return lstSeries
        End Function

        ' FILTRA QUERY
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbTiposDocumentoSeries)
            Dim query As IQueryable(Of tbTiposDocumentoSeries) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto
            Dim IDMenuAreaEmpresa As Long = 0
            Using rpMenuAreaEmpseries As New F3M.Repositorios.Administracao.RepositorioMenusAreas
                IDMenuAreaEmpresa = rpMenuAreaEmpseries.getIDDocSerieMenusAreasEmpresasAtual("DocumentosSeries")
            End Using


            ' --- ESPECIFICO ---
            Dim IDTipoDoc As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.ID, GetType(Long))
            Dim IDTipoDocSeries As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDTiposDocumentoSeries", GetType(Long))
            Dim dataDocStr As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "DataOrdemFabrico", GetType(String))
            Dim FiltraSeriesByCodigo As Boolean = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "FiltraSeriesByCodigo", GetType(Boolean))
            Dim IDTipoDocDuplica As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDTipoDocDuplica", GetType(Long))
            Dim AreaTemp As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "AreaTemp", GetType(String))
            Dim dateValue As Date
            Dim IDPerfil = ClsF3MSessao.RetornaPerfilID()

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) And filtroTxt <> Traducao.EstruturaAplicacaoTermosBase.Selecionar AndAlso Not FiltraSeriesByCodigo Then
                query = query.Where(Function(w) w.DescricaoSerie.Contains(filtroTxt))
            End If

            If Not ClsTexto.ENuloOuVazio(filtroTxt) And filtroTxt <> Traducao.EstruturaAplicacaoTermosBase.Selecionar AndAlso FiltraSeriesByCodigo Then
                query = query.Where(Function(w) w.CodigoSerie.Contains(filtroTxt))
            End If
            ' --- END GENERICO ---

            query = query.Where(Function(w) w.AtivoSerie.Equals(True) AndAlso w.IDSistemaTiposDocumentoOrigem <> TiposDocumentosOrigem.OutroSistema)


            If IDTipoDocSeries > 0 Then
                query = query.Where(Function(o) o.ID.Equals(IDTipoDocSeries))
            End If

            If Not AreaTemp Is Nothing And AreaTemp = "0" Then
                query = query.Where(Function(o) o.IVAIncluido = True)
            End If

            If ClsTexto.ENuloOuVazio(dataDocStr) Then
                dataDocStr = ClsUtilitarios.RetornaValorKeyDicionario(inFiltro.CamposFiltrar, "DataDocumento", CamposGenericos.CampoTexto)
            End If

            If Date.TryParse(dataDocStr, dateValue) AndAlso IDTipoDoc > 0 Then
                Dim dataDoc As Date = CDate(dataDocStr)

                If IDTipoDoc > 0 Then
                    query = query.Where(Function(o) o.IDTiposDocumento = IDTipoDoc)
                End If

                Using ctx As New F3M.F3MGeralEntities
                    Dim list As List(Of Long?) =
                        ctx.tbPerfisAcessosAreasEmpresa.AsNoTracking _
                            .Where(Function(f) f.IDPerfis = IDPerfil AndAlso f.tbMenusAreasEmpresa.ID = IDMenuAreaEmpresa AndAlso f.Consultar = True) _
                            .Select(Function(e) e.IDLinhaTabela).ToList

                    query = query.Where(Function(o) list.Contains(o.ID) AndAlso
                                            ((o.DataInicial Is Nothing And o.DataFinal Is Nothing) Or
                                             (o.DataInicial <= dataDoc And o.DataFinal Is Nothing) Or
                                             (o.DataInicial Is Nothing And o.DataFinal >= dataDoc) Or
                                             (o.DataInicial <= dataDoc And o.DataFinal >= dataDoc)))
                End Using
            End If

            'DUPLICA
            If IDTipoDocDuplica <> 0 Then query = query.Where(Function(w) w.IDTiposDocumento = IDTipoDocDuplica)

            'MULTI-EMPRESA
            If (IDTipoDoc <> 0 OrElse IDTipoDocDuplica <> 0) AndAlso EMultiEmpresa Then
                Dim IDLojaSedeByIDLojaEmSessao As Long
                Using rpLojas As New RepositorioLojas
                    IDLojaSedeByIDLojaEmSessao = rpLojas.RetornaIDLojaSedeByLojaEmSessao
                End Using

                query = query.Where(Function(w) w.IDLoja = IDLojaSedeByIDLojaEmSessao)
            End If

            Return query
        End Function
#End Region

#Region "ESCRITA"
        ' GRAVA POR OBJETO
        Public Sub GravaObjEsp(ByRef inCtx As BD.Dinamica.Aplicacao, ByRef o As Oticas.TiposDocumentoSeries, inAcao As AcoesFormulario)
            Try
                Dim e As tbTiposDocumentoSeries = GravaObjContexto(inCtx, o, inAcao)
                If e.ID = 0 Then
                    GravaEntidadeLinha(inCtx, e, AcoesFormulario.Adicionar, Nothing)
                End If

                inCtx.SaveChanges()
                ' GRAVA LINHAS
                GravaLinhasTodas(inCtx, o, e, inAcao)
                o.ID = e.ID
            Catch
                Throw
            End Try
        End Sub

        ' GRAVA LINHAS
        Protected Overrides Sub GravaLinhasTodas(ByRef inCtx As Oticas.BD.Dinamica.Aplicacao, ByRef o As TiposDocumentoSeries,
                                     e As tbTiposDocumentoSeries, inAcao As AcoesFormulario)
            Try
                If inAcao.Equals(AcoesFormulario.Adicionar) Or inAcao.Equals(AcoesFormulario.Alterar) Then
                    'Dim dict As Dictionary(Of String, Object) = New Dictionary(Of String, Object)
                    'dict.Add("IDSerie", e.ID)
                    Dim lstPerfisAcessoAreasEmpresa As New List(Of F3M.tbPerfisAcessosAreasEmpresa)
                    Using BDContexto As New F3M.F3MGeralEntities
                        Dim IDEmp As Long = ClsF3MSessao.RetornaEmpresaID
                        Dim IDPerfil As Long = ClsF3MSessao.RetornaPerfilID
                        Dim lstAcessosExistentes = BDContexto.tbPerfisAcessosAreasEmpresa.ToList
                        For Each Linha In o.TiposDocumentoSeriesPermissoes
                            Dim LinhasAcessosExistentesPerfisAcessos = lstAcessosExistentes.Where(Function(f) f.ID = Linha.ID).FirstOrDefault
                            If LinhasAcessosExistentesPerfisAcessos IsNot Nothing Then
                                With LinhasAcessosExistentesPerfisAcessos
                                    .IDMenusAreasEmpresa = Linha.IDMenusAreasEmpresa
                                    .IDLinhaTabela = Linha.IDLinhaTabela
                                    .IDPerfis = Linha.IDPerfis
                                    .Consultar = Linha.Consultar
                                    .Adicionar = Linha.Adicionar
                                    .Alterar = Linha.Alterar
                                    .Remover = Linha.Remover
                                    .Imprimir = Linha.Imprimir
                                    .Exportar = Linha.Exportar
                                    .UtilizadorCriacao = Linha.UtilizadorCriacao
                                    .DataCriacao = Linha.DataCriacao
                                End With
                                BDContexto.tbPerfisAcessosAreasEmpresa.Attach(LinhasAcessosExistentesPerfisAcessos)
                                BDContexto.Entry(LinhasAcessosExistentesPerfisAcessos).State = EntityState.Modified
                            Else
                                Dim LinhaNova As New F3M.tbPerfisAcessosAreasEmpresa
                                With LinhaNova
                                    .IDMenusAreasEmpresa = Linha.IDMenusAreasEmpresa
                                    .IDLinhaTabela = If(Linha.IDLinhaTabela = 0, e.ID, Linha.IDLinhaTabela)
                                    .IDPerfis = Linha.IDPerfis
                                    .Consultar = Linha.Consultar
                                    .Adicionar = Linha.Adicionar
                                    .Alterar = Linha.Alterar
                                    .Remover = Linha.Remover
                                    .Imprimir = Linha.Imprimir
                                    .Exportar = Linha.Exportar
                                    .UtilizadorCriacao = Linha.UtilizadorCriacao
                                    .DataCriacao = Linha.DataCriacao
                                End With
                                BDContexto.tbPerfisAcessosAreasEmpresa.Attach(LinhaNova)
                                BDContexto.Entry(LinhaNova).State = EntityState.Added
                            End If
                        Next
                        BDContexto.SaveChanges()
                    End Using

                ElseIf inAcao.Equals(AcoesFormulario.Remover) Then
                    GravaLinhasEntidades(Of tbTiposDocumentoSeriesPermissoes)(inCtx, e.tbTiposDocumentoSeriesPermissoes.ToList,
                                                                            AcoesFormulario.Remover, Nothing)
                End If

            Catch
                Throw
            End Try
        End Sub
#End Region

#Region "FUNCOES AUXILIARES"

        Public Sub RemovePerfisAcesso(o As TiposDocumentoSeries)
            Try
                Using BDContexto As New F3M.F3MGeralEntities
                    Dim lstPerm = BDContexto.tbPerfisAcessosAreasEmpresa.Where(Function(f) f.IDLinhaTabela = o.ID)
                    BDContexto.tbPerfisAcessosAreasEmpresa.RemoveRange(lstPerm)
                    BDContexto.SaveChanges()
                End Using
            Catch ex As Exception
                Throw
            End Try
        End Sub

        Public Sub RemovePerfisAcessoAcaoRemove(o As List(Of tbTiposDocumentoSeries))
            Try
                Using BDContexto As New F3M.F3MGeralEntities
                    For Each lin In o
                        Dim lstPermissoes = BDContexto.tbPerfisAcessosAreasEmpresa.Where(Function(f) f.IDLinhaTabela = lin.ID)
                        BDContexto.tbPerfisAcessosAreasEmpresa.RemoveRange(lstPermissoes)
                        BDContexto.SaveChanges()
                    Next
                End Using
            Catch ex As Exception
                Throw
            End Try
        End Sub

        Public Function BlnExisteUltimoDoc(ByVal IDSerie As Long, ByVal IDTipoDoc As Long) As Boolean
            Return BDContexto.tbControloDocumentos.Where(Function(e) e.IDTipoDocumento = IDTipoDoc AndAlso e.IDTiposDocumentoSeries = IDSerie AndAlso e.NumeroDocumento <> 0).Count > 0
        End Function

        Public Function GetProximoNumero(ByVal lngIDTipoDocumentoSerie As Long) As Long

            Dim Ultimo = BDContexto.tbDocumentosVendas.Where(Function(f) f.IDTiposDocumentoSeries = lngIDTipoDocumentoSerie).OrderByDescending(Function(f) f.NumeroDocumento).FirstOrDefault
            If Ultimo IsNot Nothing Then
                Return Ultimo.NumeroDocumento + 1
            Else
                Return 1
            End If
        End Function

        '' TODO: Alterar esta funcao para Generico não está a definir Tipo de Documento por prop "Predefinido"
        Public Function GetTDSByTipo(ByVal strTipo As String, Optional filtro As String = "") As TiposDocumentoSeries
            Dim tbTDS As IQueryable(Of tbTiposDocumentoSeries) = BDContexto.tbTiposDocumentoSeries.Where(Function(f) f.tbTiposDocumento.tbSistemaTiposDocumento.Tipo.Equals(strTipo) And f.tbTiposDocumento.Adiantamento = False)

            If filtro <> String.Empty Then
                tbTDS = tbTDS.Where(Function(c) c.tbTiposDocumento.tbSistemaTiposDocumentoFiscal.Tipo = filtro)
            End If

            tbTDS = tbTDS.OrderBy(Function(f) f.tbTiposDocumento.IDSistemaTiposDocumentoFiscal)

            If tbTDS IsNot Nothing Then
                Return ListaCamposTodos(tbTDS).FirstOrDefault
            End If

            Return Nothing
        End Function

        ''' <summary>
        ''' Funcao que verifica se pode inativar a serie
        ''' </summary>
        ''' <param name="inIDSerie"></param>
        ''' <param name="inIDTipoDoc"></param>
        ''' <returns></returns>
        Public Function PermiteInAtivarSerie(ByVal inIDSerie As Long, ByVal inIDTipoDoc As Long) As SerieInAtivar
            Dim serie As SerieInAtivar = New SerieInAtivar

            serie.blnPermiteInAtivarSerie = True

            If inIDTipoDoc <> 0 AndAlso inIDSerie <> 0 Then
                Dim dataAtual As Date = Date.Now

                Dim dataDoc As Date? = (From s In BDContexto.tbControloDocumentos
                                        Where s.IDTipoDocumento = inIDTipoDoc AndAlso s.IDTiposDocumentoSeries = inIDSerie
                                        Order By s.DataDocumento Descending
                                        Take 1 Select s.DataDocumento).FirstOrDefault

                If dataDoc IsNot Nothing Then
                    serie.Ano = dataDoc.Value.Year 'Atribuir ano

                    If dataDoc.Value.Year = dataAtual.Year Then
                        If dataAtual.Day <> 31 Or dataAtual.Month <> 12 Then
                            serie.blnPermiteInAtivarSerie = False
                        End If
                    Else
                        If dataDoc.Value.Year > dataAtual.Year Then
                            serie.blnPermiteInAtivarSerie = False
                        End If
                    End If

                End If

            End If

            Return serie
        End Function

        Private Function RetornaNumUltimoDocF(e As tbTiposDocumentoSeries) As Long?

            Dim lngVal As Long?

            If e.tbControloDocumentos IsNot Nothing Then
                If e.tbControloDocumentos.Where(Function(r) r.NumeroDocumento <> 0).Count > 0 Then
                    lngVal = e.tbControloDocumentos.Where(Function(r) r.NumeroDocumento <> 0).Max(Function(s) s.NumeroDocumento)
                End If
            End If

            Return lngVal
        End Function

        Private Function RetornaDataUltimoDoc(e As tbTiposDocumentoSeries) As Date?

            Dim dtVal As Date?

            If e.tbControloDocumentos IsNot Nothing Then
                If e.tbControloDocumentos.Where(Function(r) r.NumeroDocumento <> 0).Count > 0 Then
                    dtVal = e.tbControloDocumentos.Where(Function(r) r.NumeroDocumento <> 0).Max(Function(s) s.DataDocumento)
                End If
            End If

            Return dtVal
        End Function

        Private Function RetornaParametrosEmpresaCAE(e As tbTiposDocumentoSeries) As String
            Dim strResult As String = String.Empty

            If e.tbParametrosEmpresaCAE IsNot Nothing Then
                strResult = String.Concat(e.tbParametrosEmpresaCAE.Codigo, " - ", e.tbParametrosEmpresaCAE.Descricao)
            End If

            Return strResult
        End Function

        Private Function RetornaTemDocAssoc(e As tbTiposDocumentoSeries) As Boolean
            Dim blnVal As Boolean = False

            If e.tbControloDocumentos IsNot Nothing Then
                blnVal = e.tbControloDocumentos.Any(Function(f) f.IDTipoDocumento = e.IDTiposDocumento AndAlso f.IDTiposDocumentoSeries = e.ID)
            End If

            Return blnVal
        End Function

#End Region
    End Class

    Public Class SerieInAtivar
        Public Property blnPermiteInAtivarSerie As Boolean
        Public Property Ano As String
    End Class

End Namespace