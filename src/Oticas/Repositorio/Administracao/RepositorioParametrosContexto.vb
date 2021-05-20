Imports System.Data.SqlClient
Imports System.Data.Entity
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports F3M.ImposicoesLegais
Imports Traducao.Traducao

Namespace Repositorio.Administracao
    Public Class RepositorioParametrosContexto
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbParametrosContexto, ParametrosContexto)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbParametrosContexto)) As IQueryable(Of ParametrosContexto)
            Return query.Select(Function(f) New ParametrosContexto With {
                .ID = f.ID, .IDPai = f.IDPai, .Codigo = f.Codigo, .Descricao = f.Descricao, .Accao = f.Accao, .MostraConteudo = f.MostraConteudo,
                .IDParametrosEmpresa = f.tbParametrosEmpresa.ID, .Ordem = f.Ordem, .Ativo = f.Ativo, .Sistema = f.Sistema, .DataCriacao = f.DataCriacao,
                .UtilizadorCriacao = f.UtilizadorCriacao, .DataAlteracao = f.DataAlteracao, .UtilizadorAlteracao = f.UtilizadorAlteracao,
                .F3MMarcador = f.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbParametrosContexto)) As IQueryable(Of ParametrosContexto)
            Return query.Select(Function(e) New ParametrosContexto With {
                .ID = e.ID})
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of ParametrosContexto)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of ParametrosContexto)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbParametrosContexto)
            Dim query As IQueryable(Of tbParametrosContexto) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            'If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
            '    query = query.Where(Function(w) w.Morada.Contains(filtroTxt))
            'End If

            AplicaFiltrosEOrdenacoesDasVistas(inFiltro, query)

            Return query
        End Function

        Private Function ListaEspecificoTreeEmpresas(ByVal IdPai As Long, IDEmpresa As Long, IDLoja As Long, SqlQuery As String) As List(Of ParametrosContexto)
            Dim lst As New List(Of ParametrosContexto)

            If IDLoja > 0 Then
                If IdPai = 0 Then
                    lst = BDContexto.tbParametrosContexto.Where(Function(y) y.IDLoja = IDLoja And y.IDPai Is Nothing).Select(Function(x) New ParametrosContexto _
                        With {.ID = x.ID, .IDPai = x.IDPai, .IDLoja = x.IDLoja, .Codigo = x.Codigo, .Descricao = x.Descricao, .Accao = x.Accao, .MostraConteudo = x.MostraConteudo, .Ordem = x.Ordem}).OrderBy(Function(f) f.Ordem).ToList()
                    Return lst
                Else
                    lst = BDContexto.tbParametrosContexto.Where(Function(y) y.IDLoja = IDLoja And y.IDPai = IdPai And y.Ativo = True And y.Sistema = False).Select(Function(x) New ParametrosContexto _
                        With {.ID = x.ID, .IDPai = x.IDPai, .IDLoja = x.IDLoja, .Codigo = x.Codigo, .Descricao = x.Descricao, .Accao = x.Accao, .MostraConteudo = x.MostraConteudo, .Ordem = x.Ordem}).OrderBy(Function(f) f.IDPai And f.Ordem).ToList()
                    Return lst
                End If
            Else
                Using sqlConnectionBD As New SqlConnection(Me.STR_CONEXAO)
                    sqlConnectionBD.Open()

                    Using sqlcmd As New SqlCommand(SqlQuery, sqlConnectionBD)
                        Dim reader As SqlDataReader = sqlcmd.ExecuteReader()

                        While reader.Read()
                            Dim param As New ParametrosContexto
                            With param
                                .ID = reader.Item(CamposGenericos.ID)
                                .IDPai = If(IsDBNull(reader.Item("IDPai")), Nothing, reader.Item("IDPai"))
                                .Codigo = reader.Item(CamposGenericos.Codigo)
                                .Descricao = reader.Item(CamposGenericos.Descricao)
                                .Accao = If(IsDBNull(reader.Item("Accao")), Nothing, reader.Item("Accao"))
                                .MostraConteudo = reader.Item("MostraConteudo")
                                .IDParametrosEmpresa = If(IsDBNull(reader.Item("IDParametrosEmpresa")), Nothing, reader.Item("IDParametrosEmpresa"))
                                .IDLoja = If(IsDBNull(reader.Item(CamposGenericos.IDLoja)), Nothing, reader.Item(CamposGenericos.IDLoja))
                                .Ordem = reader.Item(CamposGenericos.Ordem)
                            End With

                            lst.Add(param)
                        End While

                        reader.Close()
                    End Using

                    sqlConnectionBD.Close()
                End Using
                Return lst
            End If
        End Function

        Public Function DaListaParametrosTree(IDEmpresa As String, IDLoja As String) As String
            Try
                Dim resposta As String = String.Empty
                resposta = ClsTexto.ConcatenaStrings(New String() {"[", Menus(0, String.Empty, IDEmpresa, IDLoja, Nothing), "]"})

                Return resposta
            Catch ex As Exception
                Return Nothing
            End Try
        End Function

        Private Function Menus(itemID As Integer, ByRef instrResultado As String, IDEmpresa As String, IDLoja As String, lstParametros As List(Of ParametrosContexto)) As String
            Try
                If IsNothing(lstParametros) Then
                    If IDLoja > 0 Then
                        lstParametros = ListaEspecificoTreeEmpresas(0, IDEmpresa, IDLoja, "Select * from tbParametrosContexto where IDPai IS NULL and IDLoja=" & IDLoja).ToList
                    Else
                        lstParametros = ListaEspecificoTreeEmpresas(0, IDEmpresa, IDLoja, "Select * from tbParametrosContexto where IDPai IS NULL and IDParametrosEmpresa=1").ToList
                    End If
                End If

                For Each item As ParametrosContexto In lstParametros
                    With item
                        instrResultado = ClsTexto.ConcatenaStrings(New String() {
                            instrResultado, "{id:""", CStr(.ID), """,Codigo: """, .Codigo, """, encoded: false ,Descricao:""", ClsTraducao.Traduz(ClsTipos.TipoTraducao.Menus, .Descricao, ClsF3MSessao.Idioma), """,CaminhoURL: """, .Accao, """,IDOpcao: """, CStr(.ID), """"})

                        Dim lstMenusFilhos As List(Of ParametrosContexto) = ListaEspecificoTreeEmpresas(.ID, IDEmpresa, IDLoja, "Select * from tbParametrosContexto where IDPai =" & .ID & " AND Ativo = 1 AND Sistema = 0 Order by Ordem").ToList

                        If lstMenusFilhos.Count > 0 Then
                            instrResultado = ClsTexto.ConcatenaStrings(New String() {instrResultado, ",items:["})
                            Menus(item.ID, instrResultado, IDEmpresa, IDLoja, lstMenusFilhos)
                            instrResultado = ClsTexto.ConcatenaStrings(New String() {instrResultado, "]},"})
                        Else
                            instrResultado = ClsTexto.ConcatenaStrings(New String() {instrResultado, "},"})
                        End If
                    End With
                Next
                Return instrResultado.TrimEnd(",")
            Catch
                Throw
            End Try
        End Function
#End Region

#Region "ESCRITA"
        ' EDITA POR OBJETO
        Public Overrides Sub EditaObj(ByRef o As ParametrosContexto, inFiltro As ClsF3MFiltro)
            Try
                Using ctx As New Oticas.BD.Dinamica.Aplicacao
                    Using trans As DbContextTransaction = ctx.Database.BeginTransaction(IsolationLevel.RepeatableRead)
                        Try
                            Dim listaPCC As List(Of ParametrosCamposContexto) = o.ParametrosCamposContexto.ToList
                            Dim listaIDs As List(Of Long) = listaPCC.Select(Function(s) s.ID).ToList
                            Dim listaEntPCC As List(Of tbParametrosCamposContexto) = ctx.tbParametrosCamposContexto _
                                                                                    .Where(Function(w) listaIDs.Contains(w.ID)).ToList
                            For Each pcc In listaPCC
                                Dim entPcc As tbParametrosCamposContexto = listaEntPCC.Where(Function(w) w.ID.Equals(pcc.ID)).FirstOrDefault

                                If entPcc IsNot Nothing Then
                                    If pcc.CodigoCampo = CamposGenericos.Password Then
                                        pcc.ValorCampo = ClsEncriptacao.Encriptar(pcc.ValorCampo)
                                    End If

                                    If pcc.DescricaoTipoDados.Equals("dropdown") OrElse pcc.DescricaoTipoDados = "lookup" Then
                                        pcc.ValorCampo = pcc.ValorCampoID
                                    End If

                                    entPcc.ValorCampo = pcc.ValorCampo
                                    entPcc.ValorReadOnly = pcc.ValorReadOnly
                                End If
                            Next

                            ctx.SaveChanges()
                            trans.Commit()
                        Catch
                            trans.Rollback()
                            Throw
                        End Try
                    End Using
                End Using
            Catch
                Throw
            End Try
        End Sub

#End Region

    End Class
End Namespace