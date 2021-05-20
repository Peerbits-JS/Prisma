Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioTiposArtigos
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbTiposArtigos, TiposArtigos)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbTiposArtigos)) As IQueryable(Of TiposArtigos)
            Return query.Select(Function(e) New TiposArtigos With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao,
                .CodigoSistemaTipoArtigo = e.tbSistemaClassificacoesTiposArtigos.Codigo,
                .IDSistemaClassificacao = e.IDSistemaClassificacao, .DescricaoSistemaClassificacao = e.tbSistemaClassificacoesTiposArtigos.Descricao,
                .IDSistemaClassificacaoGeral = e.IDSistemaClassificacaoGeral, .DescricaoSistemaClassificacaoGeral = e.tbSistemaClassificacoesTiposArtigosGeral.Descricao,
                .Sistema = e.Sistema, .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador, .VariavelContabilidade = e.VariavelContabilidade,
                .CodigoSAFT = e.tbSistemaClassificacoesTiposArtigosGeral.CodigoSAFT, .CodigoAT = e.tbSistemaClassificacoesTiposArtigosGeral.CodigoAT,
                .StkUnidade1 = e.StkUnidade1, .StkUnidade2 = e.StkUnidade2
                })
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbTiposArtigos)) As IQueryable(Of TiposArtigos)
            Return query.Select(Function(e) New TiposArtigos With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao, .CodigoSistemaTipoArtigo = e.tbSistemaClassificacoesTiposArtigos.Codigo,
                .CodigoSAFT = e.tbSistemaClassificacoesTiposArtigosGeral.CodigoSAFT, .CodigoAT = e.tbSistemaClassificacoesTiposArtigosGeral.CodigoAT
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of TiposArtigos)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of TiposArtigos)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA QUERY
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbTiposArtigos)
            Dim query As IQueryable(Of tbTiposArtigos) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))
            End If

            AplicaFiltroAtivo(inFiltro, query)

            Return query.OrderBy(Function(y) y.Descricao)
        End Function
#End Region

#Region "ESCRITA"

        Public Overrides Sub EditaObj(ByRef o As TiposArtigos, inFiltro As ClsF3MFiltro)
            Try
                Using ctx As New Oticas.BD.Dinamica.Aplicacao
                    Using trans As Entity.DbContextTransaction = ctx.Database.BeginTransaction(IsolationLevel.RepeatableRead)
                        Try
                            Dim blnTipoArtigoUsado As Boolean = False

                            Dim lngIDTipoArtigo As Long = o.ID
                            Dim tbTipoArtigoAnt As tbTiposArtigos = ctx.tbTiposArtigos.Find(lngIDTipoArtigo)

                            Using rep As New Artigos.RepositorioArtigos
                                blnTipoArtigoUsado = rep.ExistemDocumentosArtigos(Nothing, lngIDTipoArtigo)
                            End Using

                            If blnTipoArtigoUsado Then
                                DevolveMsgErro(o, tbTipoArtigoAnt)
                            End If

                            Dim e As tbTiposArtigos = GravaObjContexto(ctx, o, AcoesFormulario.Alterar)
                            ctx.SaveChanges()

                            trans.Commit()
                            o.ID = e.ID

                        Catch ex As Exception
                            Throw (ex)
                            trans.Rollback()
                        End Try
                    End Using
                End Using
            Catch
                Throw
            End Try
        End Sub

        Private Sub DevolveMsgErro(ByRef inObjNovo As Oticas.TiposArtigos, ByRef inObjAnterior As Oticas.tbTiposArtigos)
            Dim result As String = String.Empty
            Dim strLstCampos As List(Of String) = New List(Of String)
            If inObjNovo.IDSistemaClassificacao <> inObjAnterior.IDSistemaClassificacao Then
                strLstCampos.Add(Traducao.EstruturaTiposArtigos.Classificacao)
            End If
            'If inObjNovo.StkUnidade1 <> inObjAnterior.StkUnidade1 Then
            '    strLstCampos.Add(Traducao.EstruturaTiposArtigos.StkUnidade1)
            'End If
            'If inObjNovo.StkUnidade2 <> inObjAnterior.StkUnidade2 Then
            '    strLstCampos.Add(Traducao.EstruturaTiposArtigos.StkUnidade2)
            'End If

            If strLstCampos.Count > 0 Then
                result = String.Join(",", strLstCampos.ToArray())
                Throw New Exception(Traducao.EstruturaTiposArtigos.TipoArtigoEmUso.Replace("{0}", "(" + result + ")"))
            End If
        End Sub
#End Region


    End Class
End Namespace