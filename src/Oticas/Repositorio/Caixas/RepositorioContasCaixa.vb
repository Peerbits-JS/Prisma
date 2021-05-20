Imports System.Data.Entity
Imports System.Data.SqlClient
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.Caixas
    Public Class RepositorioContasCaixa
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbContasCaixa, ContasCaixa)

        Sub New()
            MyBase.New()
        End Sub


        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbContasCaixa)) As IQueryable(Of ContasCaixa)
            Return query.Select(Function(cc) New ContasCaixa With {
                .ID = cc.ID, .Codigo = cc.Codigo, .Descricao = cc.Descricao, .IDLoja = cc.IDLoja, .DescricaoLoja = cc.tbLojas.Descricao,
                .PorDefeito = cc.PorDefeito, .Ativo = cc.Ativo, .Sistema = cc.Sistema, .DataCriacao = cc.DataCriacao,
                .UtilizadorCriacao = cc.UtilizadorCriacao, .DataAlteracao = cc.DataAlteracao,
                .UtilizadorAlteracao = cc.UtilizadorAlteracao, .F3MMarcador = cc.F3MMarcador
            })
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbContasCaixa)) As IQueryable(Of ContasCaixa)
            Return ListaCamposTodos(query).Take(TamanhoDados.NumeroMaximo)
        End Function

        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of ContasCaixa)
            Return AplicaQueryListaPersonalizada(inFiltro)
        End Function

        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of ContasCaixa)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbContasCaixa)
            Dim query As IQueryable(Of tbContasCaixa) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            If Not String.IsNullOrWhiteSpace(filtroTxt) Then
                query = query.Where(Function(cc) cc.Descricao.Contains(filtroTxt))
            End If

            If ClsUtilitarios.TemKeyDicionario(inFiltro.CamposFiltrar, "IDLoja") Then
                Dim idLoja As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDLoja", GetType(Long))

                query = query.Where(Function(cc) cc.IDLoja = idLoja)
            End If

            AplicaFiltroAtivo(inFiltro, query)

            Return query
        End Function

        Public Function ObtemCaixasPorLoja(ByVal idLoja As Long) As List(Of ContasCaixa)
            Dim queryContasCaixa As IQueryable(Of tbContasCaixa) = BDContexto.tbContasCaixa.Where(Function(cc) cc.IDLoja = idLoja AndAlso cc.Ativo)

            Return ListaCamposTodos(queryContasCaixa).ToList
        End Function


        Public Overrides Sub AdicionaObj(ByRef contaCaixa As ContasCaixa, inFiltro As ClsF3MFiltro)
            Using ctx As New BD.Dinamica.Aplicacao
                Using trans As DbContextTransaction = ctx.Database.BeginTransaction(IsolationLevel.RepeatableRead)
                    Try
                        If contaCaixa.PorDefeito Then
                            RetiraRegistosPorDefeitoPorLoja(ctx, contaCaixa)
                        End If

                        GravaObjContexto(ctx, contaCaixa, AcoesFormulario.Adicionar)
                        ctx.SaveChanges()

                        trans.Commit()
                    Catch ex As Exception
                        trans.Rollback()
                        Throw
                    End Try
                End Using
            End Using
        End Sub

        Public Overrides Sub EditaObj(ByRef contaCaixa As ContasCaixa, inFiltro As ClsF3MFiltro)
            Using ctx As New BD.Dinamica.Aplicacao
                Using trans As DbContextTransaction = ctx.Database.BeginTransaction(IsolationLevel.RepeatableRead)
                    Try
                        If contaCaixa.PorDefeito Then
                            RetiraRegistosPorDefeitoPorLoja(ctx, contaCaixa)
                        End If

                        GravaObjContexto(ctx, contaCaixa, AcoesFormulario.Alterar)
                        ctx.SaveChanges()

                        trans.Commit()
                    Catch ex As Exception
                        trans.Rollback()
                        Throw
                    End Try
                End Using
            End Using
        End Sub

        Public Overrides Sub RemoveObj(ByRef contaCaixa As ContasCaixa, inObjFiltro As ClsF3MFiltro)
            If ExisteUtilizadorComCaixaPorDefeito(contaCaixa) Then
                Throw New Exception(Traducao.EstruturaAplicacaoTermosBase.RemocaoContaCaixaPorDefeito)
            End If

            AcaoObjTransacao(contaCaixa, AcoesFormulario.Remover)
        End Sub

        Private Sub RetiraRegistosPorDefeitoPorLoja(ByRef ctx As BD.Dinamica.Aplicacao, ByRef contaCaixa As ContasCaixa)
            Dim idLoja As Long = If(contaCaixa.IDLoja, 0)

            Dim contasAlterar As List(Of tbContasCaixa) = ctx.tbContasCaixa.Where(Function(cc) cc.IDLoja = idLoja).ToList()

            For Each cc In contasAlterar
                cc.PorDefeito = False
                ctx.Entry(cc).State = EntityState.Modified
            Next
        End Sub

        Private Function ExisteUtilizadorComCaixaPorDefeito(ByRef contaCaixa As ContasCaixa) As Boolean
            Dim temUtilizador As Boolean = False

            Dim connectionGeral As String = ClsUtilitarios.ConstroiLigacaoBaseDadosDinamica(String.Empty, True)

            Using ctxGeral As New DbContext(connectionGeral)
                Dim queryObterUtilizador As String = "SELECT IDUtilizador FROM tbUtilizadoresContaCaixa WHERE IDContaCaixa = @idContaCaixa"

                Dim idUtilizador As Long =
                    ctxGeral.Database _
                        .SqlQuery(Of Long)(queryObterUtilizador, New SqlParameter("@idContaCaixa", contaCaixa.ID)) _
                        .FirstOrDefault

                If idUtilizador > 0 Then
                    temUtilizador = True
                End If
            End Using

            Return temUtilizador
        End Function

    End Class
End Namespace