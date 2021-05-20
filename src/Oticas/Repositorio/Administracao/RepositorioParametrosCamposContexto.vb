Imports System.Data.Entity
Imports System.Data.SqlClient
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports Traducao.Traducao
Imports F3M.ImposicoesLegais

Namespace Repositorio.Administracao
    Public Class RepositorioParametrosCamposContexto
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbParametrosCamposContexto, ParametrosCamposContexto)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbParametrosCamposContexto)) As IQueryable(Of ParametrosCamposContexto)
            Return query.Select(Function(f) New ParametrosCamposContexto With {
                .ID = f.ID, .IDParametroContexto = f.tbParametrosContexto.ID, .CodigoCampo = f.CodigoCampo, .DescricaoCampo = f.DescricaoCampo, .TipoCondicionante = f.TipoCondicionante,
                .IDTipoDados = f.tbTiposDados.ID, .DescricaoTipoDados = f.tbTiposDados.Descricao, .ValorCampo = f.ValorCampo, .Accao = f.Accao, .AccaoExtra = f.AccaoExtra, .Filtro = f.Filtro, .ValorMax = f.ValorMax, .ValorMin = f.ValorMin, .ValorReadOnly = f.ValorReadOnly,
                .Ordem = f.Ordem, .Ativo = f.Ativo, .Sistema = f.Sistema, .DataCriacao = f.DataCriacao,
                .ValorCampoID = If(f.tbTiposDados.Descricao = "dropdown", Convert.ToInt64(f.ValorCampo), Nothing),
                .UtilizadorCriacao = f.UtilizadorCriacao, .DataAlteracao = f.DataAlteracao, .UtilizadorAlteracao = f.UtilizadorAlteracao,
               .F3MMarcador = f.F3MMarcador, .ConteudoLista = f.ConteudoLista})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbParametrosCamposContexto)) As IQueryable(Of ParametrosCamposContexto)
            Return query.Select(Function(e) New ParametrosCamposContexto With {
                .ID = e.ID})
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of ParametrosCamposContexto)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of ParametrosCamposContexto)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbParametrosCamposContexto)
            Dim query As IQueryable(Of tbParametrosCamposContexto) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            'If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
            '    query = query.Where(Function(w) w.Morada.Contains(filtroTxt))
            'End If

            AplicaFiltrosEOrdenacoesDasVistas(inFiltro, query)

            Return query
        End Function

        'METODOS GERA TABELA DS
        Public Function RetornaDS(inFiltro As ClsF3MFiltro) As List(Of ParametrosCamposContexto)
            Return ListaParametroCamposContexto(inFiltro)
        End Function

        'LISTA ESPECIFICO PARAMETRO CAMPOS CONTEXTO
        Private Function ListaParametroCamposContexto(inFiltro As ClsF3MFiltro) As List(Of ParametrosCamposContexto)
            Dim idParamContexto As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDParametroContexto", GetType(Long))
            Dim IdLoja As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDLoja, GetType(Long))
            Dim idEmpresa As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDEmpresa, GetType(Long))
            Dim lst As List(Of ParametrosCamposContexto) = New List(Of ParametrosCamposContexto)

            If IdLoja > 0 Then
                Using sqlConnBD As New SqlConnection(Me.STR_CONEXAO)
                    sqlConnBD.Open()

                    Using sqlcmd As New SqlCommand("SELECT pcc.ID, pcc.IDParametroContexto, pcc.CodigoCampo, pcc.DescricaoCampo, " &
                                                   "pcc.TipoCondicionante, pcc.IDTipoDados, pcc.ValorCampo, pcc.ConteudoLista, " &
                                                   "pcc.Accao, pcc.AccaoExtra, pcc.Filtro, pcc.ValorMax, pcc.ValorMin, pcc.ValorReadOnly, " &
                                                   "pcc.Ordem , td.Descricao AS DescricaoTipoDados, i.Descricao AS DescricaoLookUp " & _
                                                   "FROM tbParametrosCamposContexto pcc WITH (NOLOCK) " & _
                                                   "LEFT JOIN tbTiposDados td WITH (NOLOCK) ON " & _
                                                   "pcc.IDTipoDados = td.ID " & _
                                                   "LEFT JOIN tbArmazensLocalizacoes i WITH (NOLOCK) ON " & _
                                                   "i.ID = CASE WHEN Isnumeric(pcc.ValorCampo) = 1 THEN CONVERT(bigint, pcc.ValorCampo) ELSE NULL END " & _
                                                   "WHERE pcc.IDParametroContexto = " & idParamContexto & " AND pcc.Ativo = 1 Order by pcc.Ordem ", sqlConnBD)

                        Dim reader As SqlDataReader = sqlcmd.ExecuteReader()

                        While reader.Read()
                            Dim param As New ParametrosCamposContexto
                            Dim im As New ClsF3MAssinaturasAT
                            With param
                                .ID = reader.Item(CamposGenericos.ID)
                                .IDParametroContexto = reader.Item("IDParametroContexto")
                                .CodigoCampo = reader.Item("CodigoCampo")
                                .DescricaoCampo = ClsTraducao.Traduz(ClsTipos.TipoTraducao.Parametros, reader.Item("DescricaoCampo"), ClsF3MSessao.Idioma)
                                .TipoCondicionante = If(IsDBNull(reader.Item("TipoCondicionante")), Nothing, reader.Item("TipoCondicionante"))
                                .IDTipoDados = reader.Item("IDTipoDados")
                                .ValorCampo = If(reader.Item("CodigoCampo").Equals("Password"), If(IsDBNull(reader.Item("ValorCampo")), Nothing, ClsEncriptacao.Desencriptar(reader.Item("ValorCampo"))), If(IsDBNull(reader.Item("ValorCampo")), Nothing, reader.Item("ValorCampo")))
                                .Accao = If(IsDBNull(reader.Item("Accao")), Nothing, reader.Item("Accao"))
                                .AccaoExtra = If(IsDBNull(reader.Item("AccaoExtra")), Nothing, reader.Item("AccaoExtra"))
                                .Filtro = If(IsDBNull(reader.Item("Filtro")), Nothing, reader.Item("Filtro"))
                                .ValorMax = If(IsDBNull(reader.Item("ValorMax")), Nothing, reader.Item("ValorMax"))
                                .ValorMin = If(IsDBNull(reader.Item("ValorMin")), Nothing, reader.Item("ValorMin"))
                                .ValorReadOnly = reader.Item("ValorReadOnly")
                                .Ordem = reader.Item(CamposGenericos.Ordem)
                                .Alterado = False
                                .ValorCampoID = If(reader.Item("DescricaoTipoDados").Equals("dropdown"), If(IsDBNull(reader.Item("ValorCampo")), Nothing, Convert.ToInt64(reader.Item("ValorCampo"))), Nothing)
                                .DescricaoTipoDados = reader.Item("DescricaoTipoDados")
                                .ConteudoLista = If(IsDBNull(reader.Item("ConteudoLista")), Nothing, reader.Item("ConteudoLista"))
                                .DescricaoLookUp = If(IsDBNull(reader.Item("DescricaoLookUp")), Nothing, reader.Item("DescricaoLookUp"))
                                .Condicionantes = RetornaListaCondicionantes(reader.Item("ID"), sqlConnBD)
                            End With

                            lst.Add(param)
                        End While

                        reader.Close()
                    End Using
                    sqlConnBD.Close()
                End Using
                Return lst

                For Each lin In lst
                    lin.DescricaoCampo = TraduzString(lin.DescricaoCampo)
                    Using rp = New RepositorioCondicionantes
                        lin.Condicionantes = rp.ListaComboID(lin.ID)
                    End Using
                Next

                Return lst
            Else
                Using sqlConnBD As New SqlConnection(Me.STR_CONEXAO)
                    sqlConnBD.Open()

                    Using sqlcmd As New SqlCommand("SELECT pcc.ID, pcc.IDParametroContexto, pcc.CodigoCampo, pcc.DescricaoCampo, " &
                                                   "pcc.TipoCondicionante, pcc.IDTipoDados, pcc.ValorCampo, pcc.ConteudoLista, " &
                                                   "pcc.Accao, pcc.AccaoExtra, pcc.Filtro, pcc.ValorMax, pcc.ValorMin, pcc.ValorReadOnly, " &
                                                   "pcc.Ordem , td.Descricao AS DescricaoTipoDados, i.Descricao AS DescricaoLookUp " & _
                                                   "FROM tbParametrosCamposContexto pcc WITH (NOLOCK) " & _
                                                   "LEFT JOIN tbTiposDados td WITH (NOLOCK) ON " & _
                                                   "pcc.IDTipoDados = td.ID " & _
                                                   "LEFT JOIN tbIVA i WITH (NOLOCK) ON " & _
                                                   "i.ID = CASE WHEN Isnumeric(pcc.ValorCampo) = 1 THEN CONVERT(bigint, pcc.ValorCampo) ELSE NULL END " & _
                                                   "WHERE pcc.IDParametroContexto = " & idParamContexto & " AND pcc.Ativo = 1 Order by pcc.Ordem ", sqlConnBD)

                        Dim reader As SqlDataReader = sqlcmd.ExecuteReader()

                        While reader.Read()
                            Dim param As New ParametrosCamposContexto
                            Dim im As New ClsF3MAssinaturasAT
                            With param
                                .ID = reader.Item(CamposGenericos.ID)
                                .IDParametroContexto = reader.Item("IDParametroContexto")
                                .CodigoCampo = reader.Item("CodigoCampo")
                                .DescricaoCampo = ClsTraducao.Traduz(ClsTipos.TipoTraducao.Parametros, reader.Item("DescricaoCampo"), ClsF3MSessao.Idioma)
                                .TipoCondicionante = If(IsDBNull(reader.Item("TipoCondicionante")), Nothing, reader.Item("TipoCondicionante"))
                                .IDTipoDados = reader.Item("IDTipoDados")
                                .ValorCampo = If(reader.Item("CodigoCampo").Equals("Password"), If(IsDBNull(reader.Item("ValorCampo")), Nothing, ClsEncriptacao.Desencriptar(reader.Item("ValorCampo"))), If(IsDBNull(reader.Item("ValorCampo")), Nothing, reader.Item("ValorCampo")))
                                .Accao = If(IsDBNull(reader.Item("Accao")), Nothing, reader.Item("Accao"))
                                .AccaoExtra = If(IsDBNull(reader.Item("AccaoExtra")), Nothing, reader.Item("AccaoExtra"))
                                .Filtro = If(IsDBNull(reader.Item("Filtro")), Nothing, reader.Item("Filtro"))
                                .ValorMax = If(IsDBNull(reader.Item("ValorMax")), Nothing, reader.Item("ValorMax"))
                                .ValorMin = If(IsDBNull(reader.Item("ValorMin")), Nothing, reader.Item("ValorMin"))
                                .ValorReadOnly = reader.Item("ValorReadOnly")
                                .Ordem = reader.Item(CamposGenericos.Ordem)
                                .Alterado = False
                                .ValorCampoID = If(reader.Item("DescricaoTipoDados").Equals("dropdown"), If(IsDBNull(reader.Item("ValorCampo")), Nothing, Convert.ToInt64(reader.Item("ValorCampo"))), Nothing)
                                .DescricaoTipoDados = reader.Item("DescricaoTipoDados")
                                .ConteudoLista = If(IsDBNull(reader.Item("ConteudoLista")), Nothing, reader.Item("ConteudoLista"))
                                .DescricaoLookUp = If(IsDBNull(reader.Item("DescricaoLookUp")), Nothing, reader.Item("DescricaoLookUp"))
                                .Condicionantes = RetornaListaCondicionantes(reader.Item("ID"), sqlConnBD)
                            End With

                            lst.Add(param)
                        End While

                        reader.Close()
                    End Using

                    sqlConnBD.Close()
                End Using
                Return lst
            End If
        End Function

        Private Function RetornaListaCondicionantes(idParametrosCampoContexto As Long, sqlConnectionBD As SqlConnection) As List(Of Condicionantes)
            Dim lst As List(Of Condicionantes) = New List(Of Condicionantes)
            Using sqlcmd As New SqlCommand("Select tbCondicionantes.ID, tbCondicionantes.IDParametroCamposContexto, tbCondicionantes.CampoCondicionante, " & _
                                           "tbCondicionantes.ValorCondicionante,tbCondicionantes.ValorPorDefeito,tbCondicionantes.TipoValorPorDefeito,tbCondicionantes.Ordem FROM " & _
                                           "tbCondicionantes Where tbCondicionantes.Ativo = 1 AND tbCondicionantes.IDParametroCamposContexto = " & idParametrosCampoContexto, sqlConnectionBD)

                Dim reader As SqlDataReader = sqlcmd.ExecuteReader()
                While reader.Read()
                    Dim param As Condicionantes = New Condicionantes
                    With param
                        .ID = reader.Item("ID")
                        .IDParametroCamposContexto = reader.Item("IDParametroCamposContexto")
                        .CampoCondicionante = If(IsDBNull(reader.Item("CampoCondicionante")), Nothing, reader.Item("CampoCondicionante"))
                        .ValorCondicionante = If(IsDBNull(reader.Item("ValorCondicionante")), Nothing, reader.Item("ValorCondicionante"))
                        .ValorPorDefeito = If(IsDBNull(reader.Item("ValorPorDefeito")), Nothing, reader.Item("ValorPorDefeito"))
                        .TipoValorPorDefeito = If(IsDBNull(reader.Item("TipoValorPorDefeito")), Nothing, reader.Item("TipoValorPorDefeito"))
                        .Ordem = reader.Item("Ordem")
                    End With
                    lst.Add(param)
                End While

                reader.Close()
            End Using
            Return lst
        End Function

        Private Function TraduzString(ByVal strDescricao As String) As String
            Dim str1 = ClsTraducao.Traduz(ClsTipos.TipoTraducao.Parametros, strDescricao, ClsF3MSessao.Idioma)
            Return str1
        End Function

#End Region

    End Class
End Namespace