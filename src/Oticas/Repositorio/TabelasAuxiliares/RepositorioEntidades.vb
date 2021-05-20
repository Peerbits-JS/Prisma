Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports Oticas.Modelos.Constantes
Imports System.Data.Entity
Imports System.Data.SqlClient

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioEntidades
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbEntidades, Entidades)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbEntidades)) As IQueryable(Of Entidades)
            Return query.Select(Function(e) New Entidades With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao, .Abreviatura = e.Abreviatura, .NContribuinte = e.NContribuinte, .Contabilidade = e.Contabilidade,
                .Observacoes = e.Observacoes, .IDTipoEntidade = e.IDTipoEntidade, .DescricaoTipoEntidade = e.tbSistemaEntidadeDescricao.Descricao,
                .IDClienteEntidade = e.IDClienteEntidade, .DescricaoClienteEntidade = e.tbClientes2.Nome,
                .IDTipoDescricao = e.IDTipoDescricao, .DescricaoTipoDescricao = e.tbSistemaEntidadeComparticipacao.Descricao, .Foto = e.Foto, .FotoCaminho = e.FotoCaminho,
                .FotoAnterior = e.Foto, .FotoCaminhoAnterior = e.FotoCaminho, .Sistema = e.Sistema, .Ativo = e.Ativo,
                .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbEntidades)) As IQueryable(Of Entidades)
            Return query.Select(Function(e) New Entidades With {
                .ID = e.ID, .Descricao = e.Descricao
            }).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of Entidades)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of Entidades)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbEntidades)
            Dim query As IQueryable(Of tbEntidades) = tabela.AsNoTracking
            Dim eLookup As Boolean = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.eLookup, GetType(Boolean))
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))
            End If

            AplicaFiltroAtivo(inFiltro, query)

            If eLookup Then
                query = query.OrderBy(Function(o) o.Descricao)
            End If

            Return query
        End Function

        Public Function LerValorComparticipacao(ByVal lngIDEntidade As Long, ByVal strTipoArtigo As String, ByVal lngIDTipoLente As Long, ByVal dblValorArtigo As Double,
                                        Optional ByVal dblPotEsf As Double = Nothing, Optional ByVal dblPotCil As Double = Nothing,
                                        Optional ByVal dblPotPrism As Double = Nothing, Optional ByRef dblQtdMaxima As Double = 1000, Optional ByRef dblDuracao As Double = 1000) As Double
            Dim adapterVistas As SqlDataAdapter
            Dim strCond As String = String.Empty
            Dim strQry As String = String.Empty

            Dim dblvalor As Double = 0
            Dim dblValorMaximo As Double = 0
            Dim dblvalorPercentagem As Double = 0

            Using dsListaVistas As New DataSet
                Using sqlcon As SqlConnection = New SqlConnection(Me.STR_CONEXAO)
                    sqlcon.Open()

                    strCond = " where sta.codigo=" & ClsUtilitarios.EnvolveSQL(strTipoArtigo)

                    If strTipoArtigo = "LO" Or strTipoArtigo = "LC" Then
                        strCond = strCond & " and (idtipolente=" & lngIDTipoLente & " or idtipolente is null) "

                        If Not IsNothing(dblPotEsf) Then
                            If dblPotCil < 0 Then
                                strCond = strCond & " and abs(" & (dblPotEsf + dblPotCil).ToString.Replace(",", ".") & ") between isnull(PotenciaEsfericaDe,-50) and isnull(PotenciaEsfericaAte,50)"
                            Else
                                strCond = strCond & " and abs(" & dblPotEsf.ToString.Replace(",", ".") & ") between isnull(PotenciaEsfericaDe,-50) and isnull(PotenciaEsfericaAte,50)"
                            End If
                        End If

                        If dblPotCil > 0 Then
                            strCond = strCond & " and abs(" & dblPotCil.ToString.Replace(",", ".") & ") between isnull(PotenciaCilindricaDe,-50) and isnull(PotenciaCilindricaAte,50)"
                        End If
                    End If

                    If strTipoArtigo = "LO" Then
                        If dblPotPrism > 0 Then
                            strCond = strCond & " and " & dblPotPrism.ToString.Replace(",", ".") & "between isnull(PotenciaPrismaticaDe ,-50) and isnull(PotenciaPrismaticaAte,50) "
                        End If
                    End If

                    If lngIDEntidade > 0 Then
                        strCond = strCond & " and ec.IDEntidade=" & lngIDEntidade
                    End If

                    strQry = "select isnull(ec.Percentagem,0) as Percentagem, isnull(ec.ValorMaximo,0) as ValorMaximo, isnull(ec.Quantidade,0) as Quantidade, isnull(ec.Duracao,0) as Duracao from tbentidadescomparticipacoes ec with (nolock) inner join tbtiposartigos ta with (nolock) on ec.idtipoartigo=ta.id inner join tbSistemaClassificacoesTiposArtigos sta with (nolock) on ta.idsistemaclassificacao=sta.id " & strCond

                    Using sqlcmdVistas As New SqlCommand(strQry, sqlcon)
                        sqlcmdVistas.CommandType = System.Data.CommandType.Text
                        adapterVistas = New SqlDataAdapter(sqlcmdVistas)
                        adapterVistas.Fill(dsListaVistas)
                        If dsListaVistas.Tables(0).Rows.Count > 0 Then
                            Dim row As DataRow
                            row = dsListaVistas.Tables(0).Rows(0)
                            If row!Percentagem.ToString <> "" Then
                                dblvalorPercentagem = row!Percentagem
                                dblValorMaximo = row!ValorMaximo
                                dblQtdMaxima = row!Quantidade
                                dblDuracao = row!Duracao
                            End If
                        Else
                            dblvalorPercentagem = 0
                            dblValorMaximo = 0
                            dblQtdMaxima = 1000
                            dblDuracao = 1000
                        End If
                    End Using
                End Using

                dblvalor = dblValorMaximo

                If dblvalorPercentagem > 0 Then
                    dblvalor = dblValorArtigo * dblvalorPercentagem / 100
                    dblvalor = Math.Round(dblvalor, ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisPrecosUnitarios)
                End If

                If dblvalor > dblValorMaximo Then
                    dblvalor = dblValorMaximo
                End If
                Return dblvalor
            End Using
        End Function

        Public Function LerValorComparticipacaoArtigo(ByVal inDV As DocumentosVendas, ByVal inDVL As DocumentosVendasLinhas, ByVal lngIDArtigo As Long, ByVal dblValor As Double) As Double

            Dim dblComparticipacao As Double = 0

            Dim strTipoArtigo As String = (From x In BDContexto.tbArtigos Where x.ID = lngIDArtigo Select x.tbTiposArtigos.tbSistemaClassificacoesTiposArtigos.Codigo).FirstOrDefault()

            Dim dblQtdAnterior As Double = LerQuantidadeComparticipadaDocAnterior(inDV, strTipoArtigo)
            Dim dblQtdActual As Double = LerQuantidadeComparticipadaDocActual(inDV, strTipoArtigo, inDVL.ID)
            Dim dblQtdUsada As Double = dblQtdAnterior + dblQtdActual
            Dim dblQtdMaxima As Double
            Dim dblDuracao As Double

            Select Case strTipoArtigo
                Case "LO"
                    Dim tb As ArtigosLentesOftalmicas = BDContexto.tbLentesOftalmicas.Where(Function(w) w.IDArtigo = lngIDArtigo).Select(Function(s) New ArtigosLentesOftalmicas With {.IDTipoLente = s.tbModelos.IDTipoLente, .PotenciaEsferica = s.PotenciaEsferica, .PotenciaCilindrica = s.PotenciaCilindrica, .PotenciaPrismatica = s.PotenciaPrismatica}).FirstOrDefault()
                    If Not tb Is Nothing Then
                        dblComparticipacao = LerValorComparticipacao(inDV.IDEntidade1, strTipoArtigo, tb.IDTipoLente, dblValor, tb.PotenciaEsferica, tb.PotenciaCilindrica, tb.PotenciaPrismatica, dblQtdMaxima, dblDuracao)
                    End If
                Case "LC"
                    Dim tb1 As ArtigosLentesContato = BDContexto.tbLentesContato.Where(Function(w) w.IDArtigo = lngIDArtigo).Select(Function(s) New ArtigosLentesContato With {.IDTipoLente = s.tbModelos.IDTipoLente, .PotenciaEsferica = s.PotenciaEsferica, .PotenciaCilindrica = s.PotenciaCilindrica}).FirstOrDefault()
                    If Not tb1 Is Nothing Then
                        dblComparticipacao = LerValorComparticipacao(inDV.IDEntidade1, strTipoArtigo, tb1.IDTipoLente, dblValor, tb1.PotenciaEsferica, tb1.PotenciaCilindrica, 0, dblQtdMaxima, dblDuracao)
                    End If
                Case Else
                    dblComparticipacao = LerValorComparticipacao(inDV.IDEntidade1, strTipoArtigo, 0, dblValor,,,, dblQtdMaxima, dblDuracao)
            End Select

            If dblQtdUsada >= dblQtdMaxima Then
                dblComparticipacao = 0
            ElseIf (dblQtdUsada + inDVL.Quantidade) > dblQtdMaxima Then
                dblComparticipacao = dblComparticipacao * ((dblQtdMaxima - dblQtdUsada) / inDVL.Quantidade)
            ElseIf (dblQtdUsada + inDVL.Quantidade) <= dblQtdMaxima Then
            End If

            Return dblComparticipacao
        End Function

        Public Function LerValorComparticipacaoLentes(ByVal inDV As DocumentosVendas, ByVal inDVL As DocumentosVendasLinhas, ByVal strTipoArtigo As String, ByVal lngIDTipoLente As Long,
                                                      ByVal dblPotEsf As Double, ByVal dblPotCil As Double, ByVal dblPotPrism As Double, ByVal dblValor As Double) As Double

            Dim dblComparticipacao As Double = 0
            Dim dblQtdAnterior As Double = LerQuantidadeComparticipadaDocAnterior(inDV, strTipoArtigo)
            Dim dblQtdActual As Double = LerQuantidadeComparticipadaDocActual(inDV, strTipoArtigo, inDVL.ID)
            Dim dblQtdUsada As Double = dblQtdAnterior + dblQtdActual
            Dim dblQtdMaxima As Double
            Dim dblDuracao As Double

            Select Case strTipoArtigo
                Case "LO"
                    dblComparticipacao = LerValorComparticipacao(inDV.IDEntidade1, strTipoArtigo, lngIDTipoLente, dblValor, dblPotEsf, dblPotCil, dblPotPrism, dblQtdMaxima, dblDuracao)
                Case "LC"
                    dblComparticipacao = LerValorComparticipacao(inDV.IDEntidade1, strTipoArtigo, lngIDTipoLente, dblValor, dblPotEsf, dblPotCil, 0, dblQtdMaxima, dblDuracao)
                Case Else
                    dblComparticipacao = 0
            End Select

            If dblQtdUsada >= dblQtdMaxima Then
                dblComparticipacao = 0
            ElseIf (dblQtdUsada + inDVL.Quantidade) > dblQtdMaxima Then
                dblComparticipacao = dblComparticipacao * ((dblQtdMaxima - dblQtdUsada) / inDVL.Quantidade)
            ElseIf (dblQtdUsada + inDVL.Quantidade) <= dblQtdMaxima Then
            End If

            Return dblComparticipacao
        End Function

        Private Function LerQuantidadeComparticipadaDocActual(ByRef model As DocumentosVendas, ByRef strCodigoTipoArtigo As String, ByRef lngID As Long) As Double
            Try
                Dim dblQuantidade As Double = 0
                For Each DVL In model.DocumentosVendasLinhas.Where(Function(f) f.AcaoCRUD <> AcoesFormulario.Remover)
                    If Left(DVL.CodigoArtigo, 2) = strCodigoTipoArtigo Then
                        If DVL.ValorUnitarioEntidade1 > 0 And DVL.ID <> lngID Then
                            dblQuantidade += DVL.Quantidade
                        End If
                    End If
                Next

                Return dblQuantidade
            Catch
                Throw
            End Try
        End Function

        Private Function LerQuantidadeComparticipadaDocAnterior(ByRef model As DocumentosVendas, ByVal strTipoArtigo As String) As Double

            Return CDbl(0)
            Dim strQry As String = String.Empty
            Dim strCond As String = String.Empty

            strCond = " where d.codigotipoestado='EFT' and ta.codigo='" & strTipoArtigo & "' and isnull(l.valorentidade1,0)>0 "
            If model.IDEntidade IsNot Nothing Then
                strCond = " and d.identidade=" & model.IDEntidade
            End If

            strQry = "Select isnull(sum(l.quantidade),0) as Quantidade from tbdocumentosvendas d with (nolock) inner join tbdocumentosvendaslinhas l with (nolock) on d.id=l.iddocumentovenda " &
                     "inner Join tbartigos a with (nolock) on l.idartigo=a.id inner join tbtiposartigos ta with (nolock) on a.idtipoartigo=ta.id " &
                    "inner join tbSistemaClassificacoesTiposArtigos sta with (nolock) on ta.idsistemaclassificacao=sta.id " & strCond

            Dim dblQuantidade As Double = BDContexto.Database.SqlQuery(Of Double)(strQry).FirstOrDefault()
            Return dblQuantidade
        End Function

#End Region

#Region "ESCRITA"
        ' ADICIONA POR OBJETO
        Public Overrides Sub AdicionaObj(ByRef o As Entidades, inFiltro As ClsF3MFiltro)
            AcaoObjTransacao(o, AcoesFormulario.Adicionar)
        End Sub

        ' EDITA POR OBJETO
        Public Overrides Sub EditaObj(ByRef o As Entidades, inFiltro As ClsF3MFiltro)
            AcaoObjTransacao(o, AcoesFormulario.Alterar)
        End Sub

        ' REMOVE POR OBJETO
        Public Overrides Sub RemoveObj(ByRef o As Entidades, inFiltro As ClsF3MFiltro)
            AcaoObjTransacao(o, AcoesFormulario.Remover)
        End Sub

        ' GRAVA LINHAS
        Protected Overrides Sub GravaLinhasTodas(ByRef inCtx As Oticas.BD.Dinamica.Aplicacao, ByRef o As Oticas.Entidades,
                                                 e As tbEntidades, inAcao As AcoesFormulario)
            Try

                Dim dict As Dictionary(Of String, Object) = New Dictionary(Of String, Object)
                dict.Add(CamposGenericos.IDEntidade, e.ID)

                If inAcao.Equals(AcoesFormulario.Adicionar) Or inAcao.Equals(AcoesFormulario.Alterar) Then
                    GravaLinhas(Of tbEntidadesContatos, EntidadesContatos)(inCtx, e, o, dict)
                    GravaLinhas(Of tbEntidadesLojas, EntidadesLojas)(inCtx, e, o, dict)
                    GravaLinhas(Of tbEntidadesMoradas, EntidadesMoradas)(inCtx, e, o, dict)
                    GravaLinhas(Of tbEntidadesComparticipacoes, EntidadesComparticipacoes)(inCtx, e, o, dict)
                ElseIf inAcao.Equals(AcoesFormulario.Remover) Then
                    GravaLinhasEntidades(Of tbEntidadesContatos)(inCtx, e.tbEntidadesContatos.ToList, AcoesFormulario.Remover, Nothing)
                    GravaLinhasEntidades(Of tbEntidadesLojas)(inCtx, e.tbEntidadesLojas.ToList, AcoesFormulario.Remover, Nothing)
                    GravaLinhasEntidades(Of tbEntidadesMoradas)(inCtx, e.tbEntidadesMoradas.ToList, AcoesFormulario.Remover, Nothing)
                    GravaLinhasEntidades(Of tbEntidadesComparticipacoes)(inCtx, e.tbEntidadesComparticipacoes.ToList, AcoesFormulario.Remover, Nothing)
                End If

                inCtx.SaveChanges()
            Catch
                Throw
            End Try
        End Sub
#End Region

    End Class
End Namespace