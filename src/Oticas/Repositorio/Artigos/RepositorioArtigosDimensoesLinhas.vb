Imports System.Data.Entity
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.Artigos
    Public Class RepositorioArtigosDimensoesLinhas
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbDimensoesLinhas, ArtigosDimensoesLinhas)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbDimensoesLinhas)) As IQueryable(Of ArtigosDimensoesLinhas)
            Return ListaCamposEspecial(query, New ClsF3MFiltro)
        End Function

        Protected Function ListaCamposEspecial(query As IQueryable(Of tbDimensoesLinhas), inFiltro As ClsF3MFiltro) As IQueryable(Of ArtigosDimensoesLinhas)
            Dim IDArt As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDArtigo, GetType(Long))
            Dim contemChave As Boolean = False
            If inFiltro.CamposFiltrar IsNot Nothing Then
                contemChave = inFiltro.CamposFiltrar.Any(Function(f) f.Key.Contains(CamposGenericos.IDArtigo) And f.Key.Length > CamposGenericos.IDArtigo.Length)
            End If

            If contemChave Then
                Dim strChave As Object = inFiltro.CamposFiltrar.Where(Function(f) f.Key.Contains(CamposGenericos.IDArtigo) And f.Key.Length > CamposGenericos.IDArtigo.Length).FirstOrDefault
                IDArt = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, strChave.key, GetType(Long))
            End If

            Dim IDDimensLinha As Long = 0
            Dim eLookup As Boolean = False
            If inFiltro.CamposFiltrar IsNot Nothing Then
                eLookup = inFiltro.CamposFiltrar.Any(Function(f) f.Key.Contains(CamposGenericos.eLookup))
            End If

            If eLookup Then
                Dim strChave As Object = inFiltro.CamposFiltrar.Where(Function(f) f.Key.Contains(CamposGenericos.eLookup)).FirstOrDefault
                eLookup = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, strChave.key, GetType(Boolean))
                If eLookup Then
                    If inFiltro.CampoValores IsNot Nothing Then
                        contemChave = inFiltro.CampoValores.Any(Function(f) f.Key.Contains(CamposGenericos.IDArtigoDimensao) And f.Key.Length > CamposGenericos.IDArtigoDimensao.Length)
                        If contemChave Then
                            Dim strChave1 As Object = inFiltro.CampoValores.Where(Function(f) f.Key.Contains(CamposGenericos.IDArtigoDimensao) And f.Key.Length > CamposGenericos.IDArtigoDimensao.Length).FirstOrDefault
                            IDDimensLinha = ClsUtilitarios.RetornaValorKeyDicionarioCampoValores(inFiltro, strChave1.key, GetType(Long))
                        End If
                    End If
                End If
            End If

            If eLookup And IDDimensLinha <> 0 Then
                query = query.Where(Function(e) e.Ativo = True Or (e.Ativo = False And e.ID = IDDimensLinha))
            ElseIf eLookup And IDDimensLinha = 0 Then
                query = query.Where(Function(e) e.Ativo = True)
            End If

            Return query.Select(Function(e) New ArtigosDimensoesLinhas With {
               .ID = e.ID,
               .Visivel = If(e.tbArtigosDimensoes.Where(Function(f) f.IDArtigo = IDArt And f.tbArtigosDimensoesEmpresa.Count > 0).Count > 0, True, If(e.tbArtigosDimensoes1.Where(Function(f) f.IDArtigo = IDArt And f.tbArtigosDimensoesEmpresa.Count > 0).Count > 0, True, False)),
               .Associado = If(e.tbArtigosDimensoes.Where(Function(f) f.IDArtigo = IDArt).Count > 0, True, If(e.tbArtigosDimensoes1.Where(Function(f) f.IDArtigo = IDArt).Count > 0, True, False)),
               .IDDimensao = e.IDDimensao,
               .Descricao = e.Descricao,
               .Ordem = e.Ordem,
               .Sistema = e.Sistema,
               .Ativo = e.Ativo,
               .DataCriacao = e.DataCriacao,
               .UtilizadorCriacao = e.UtilizadorCriacao,
               .DataAlteracao = e.DataAlteracao,
               .UtilizadorAlteracao = e.UtilizadorAlteracao,
               .F3MMarcador = e.F3MMarcador,
               .Virtual = e.Virtual})
        End Function

        Protected Shadows Function ListaCamposCombo(query As IQueryable(Of tbDimensoesLinhas)) As IQueryable(Of ArtigosDimensoesLinhas)
            Return query.Select(Function(e) New ArtigosDimensoesLinhas With {
                .ID = e.ID, .Descricao = e.Descricao
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of ArtigosDimensoesLinhas)
            Return ListaCamposEspecial(FiltraQuery(inFiltro), inFiltro)
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of ArtigosDimensoesLinhas)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ''' <summary>
        ''' Para filtrar a tabela
        ''' </summary>
        ''' <param name="inFiltro"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbDimensoesLinhas)
            Dim query As IQueryable(Of tbDimensoesLinhas) = tabela.AsNoTracking
            Dim dictCV As Dictionary(Of String, Dictionary(Of String, String)) = inFiltro.CampoValores
            Dim dictAux As Dictionary(Of String, String) = Nothing
            Dim filtroTxt As String = inFiltro.FiltroTexto
            Dim IDArt As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDArtigo, GetType(Long))
            Dim contemChave As Boolean = False

            If inFiltro.CamposFiltrar IsNot Nothing Then
                contemChave = inFiltro.CamposFiltrar.Any(Function(f) f.Key.Contains(CamposGenericos.IDArtigo) And f.Key.Length > CamposGenericos.IDArtigo.Length)
            End If

            If contemChave Then
                Dim strChave As Object = inFiltro.CamposFiltrar.Where(Function(f) f.Key.Contains(CamposGenericos.IDArtigo) And f.Key.Length > CamposGenericos.IDArtigo.Length).FirstOrDefault
                IDArt = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, strChave.key, GetType(Long))
            End If

            Dim IDDimensLinha As Long = 0
            Dim eLookup As Boolean = False
            If inFiltro.CamposFiltrar IsNot Nothing Then
                eLookup = inFiltro.CamposFiltrar.Any(Function(f) f.Key.Contains(CamposGenericos.eLookup))
            End If

            If eLookup Then
                Dim strChave As Object = inFiltro.CamposFiltrar.Where(Function(f) f.Key.Contains(CamposGenericos.eLookup)).FirstOrDefault
                eLookup = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, strChave.key, GetType(Boolean))
                If eLookup Then
                    If inFiltro.CampoValores IsNot Nothing Then
                        contemChave = inFiltro.CampoValores.Any(Function(f) f.Key.Contains(CamposGenericos.IDArtigoDimensao) And f.Key.Length > CamposGenericos.IDArtigoDimensao.Length)
                        If contemChave Then
                            Dim strChave1 As Object = inFiltro.CampoValores.Where(Function(f) f.Key.Contains(CamposGenericos.IDArtigoDimensao) And f.Key.Length > CamposGenericos.IDArtigoDimensao.Length).FirstOrDefault
                            IDDimensLinha = ClsUtilitarios.RetornaValorKeyDicionarioCampoValores(inFiltro, strChave1.key, GetType(Long))
                        End If
                    End If
                End If
            End If

            Dim IDDim As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDDimensao, GetType(Long))
            Dim naoF4 As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "NaoF4", GetType(String))
            Dim strTipoDime As String = String.Empty

            ' TIPO DIMENSAO
            If dictCV IsNot Nothing AndAlso IDDim = 0 Then
                strTipoDime = dictCV.Keys.FirstOrDefault()
                IDDim = ClsUtilitarios.RetornaValorKeyDicionarioCampoValores(inFiltro, strTipoDime, GetType(Long))
            End If

            If IDArt > 0 AndAlso Not ClsTexto.ENuloOuVazio(strTipoDime) AndAlso ClsTexto.ENuloOuVazio(naoF4) Then
                If strTipoDime.IndexOf(CamposEspecificos.DimensaoLinha1) <> -1 Then
                    query = query.Where(Function(o) o.tbArtigosDimensoes.Any(Function(h) h.IDArtigo = IDArt)).Distinct
                ElseIf strTipoDime.IndexOf(CamposEspecificos.DimensaoLinha2) <> -1 Then
                    query = query.Where(Function(o) o.tbArtigosDimensoes1.Any(Function(h) h.IDArtigo = IDArt)).Distinct
                End If
            ElseIf IDDim >= 0 Then
                query = query.Where(Function(o) o.IDDimensao = IDDim)
            End If

            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(o) o.Descricao.Contains(filtroTxt))
            End If

            If eLookup And IDDimensLinha <> 0 Then
                query = query.Where(Function(o) o.Ativo = True Or (o.Ativo = False And o.ID = IDDimensLinha))
            ElseIf eLookup And IDDimensLinha = 0 Then
                query = query.Where(Function(o) o.Ativo = True)
            End If

            Return query.OrderBy(Function(o) o.Descricao)
        End Function
#End Region

#Region "ESCRITA"
        ' ADICIONA POR OBJETO
        Public Overrides Sub AdicionaObj(ByRef o As ArtigosDimensoesLinhas, inFiltro As ClsF3MFiltro)
            AcaoObjTransacao(o, AcoesFormulario.Adicionar)
        End Sub

        ' EDITA POR OBJETO
        Public Overrides Sub EditaObj(ByRef o As ArtigosDimensoesLinhas, inFiltro As ClsF3MFiltro)
            Try
                Using ctx As New BD.Dinamica.Aplicacao
                    Using trans As DbContextTransaction = ctx.Database.BeginTransaction(IsolationLevel.ReadCommitted)
                        Try
                            Dim e As tbDimensoesLinhas = tabela.Find(o.ID)
                            Dim lst As List(Of tbDimensoesLinhas)
                            Dim max As Long
                            Dim min As Long
                            Dim existe

                            Mapear(o, e)

                            lst = BDContexto.tbDimensoesLinhas.Where(Function(f) f.IDDimensao = e.IDDimensao).ToList
                            max = lst.Max(Function(f) f.Ordem)
                            min = lst.Min(Function(f) f.Ordem)
                            existe = lst.Where(Function(f) f.Ordem = e.Ordem).FirstOrDefault

                            Dim ObjAntigo = lst.Where(Function(f) f.ID = e.ID).FirstOrDefault
                            If (ObjAntigo.Ordem <> e.Ordem AndAlso (e.Ordem >= min And e.Ordem <= max) AndAlso existe IsNot Nothing) Then
                                TrocaOrdemLinhas("Ascending", e.IDDimensao, ObjAntigo.Ordem, e.Ordem)
                            Else
                                GravaObjContexto(ctx, o, AcoesFormulario.Alterar)
                            End If

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

        ' EDITA ORDEM DAS LINHAS
        Public Sub TrocaOrdemLinhas(dir As String, IDDimensao As Integer, inOrdemTarget As Integer, inOrdemDest As Integer?)
            Dim L1, L2 As tbDimensoesLinhas
            Dim LinhasModificar As New List(Of tbDimensoesLinhas)
            Dim ListaDeOrdens As New List(Of Integer)
            Dim OrdemL1, OrdemL2 As Integer

            If inOrdemDest IsNot Nothing Then

                Using ctx As New BD.Dinamica.Aplicacao
                    Dim query As IQueryable(Of tbDimensoesLinhas) = ctx.tbDimensoesLinhas.AsNoTracking
                    If inOrdemTarget > inOrdemDest Then
                        query = query.Where(Function(f) f.IDDimensao = IDDimensao And f.Ordem >= inOrdemDest And f.Ordem <= inOrdemTarget)
                    Else
                        query = query.Where(Function(f) f.IDDimensao = IDDimensao And f.Ordem >= inOrdemTarget And f.Ordem <= inOrdemDest)
                    End If
                    If dir = "Ascending" Then
                        query = query.OrderBy(Function(f) f.Ordem)
                    Else
                        query = query.OrderByDescending(Function(f) f.Ordem)
                    End If
                    LinhasModificar = query.ToList
                End Using

                L1 = LinhasModificar.FirstOrDefault
                L2 = LinhasModificar.Item(LinhasModificar.Count - 1)
                OrdemL1 = L1.Ordem
                OrdemL2 = L2.Ordem


                Dim passa = True
                If OrdemL1 > OrdemL2 Then
                    If Not (inOrdemDest >= OrdemL2 And inOrdemDest <= OrdemL1) Then
                        passa = False
                    End If
                Else
                    If Not (inOrdemDest >= OrdemL1 And inOrdemDest <= OrdemL2) Then
                        passa = False
                    End If
                End If

                If passa Then
                    If LinhasModificar.Count <> 2 Then
                        Using ctx As New BD.Dinamica.Aplicacao
                            'GUARDA DESTINO COM RANDOM
                            If inOrdemDest > inOrdemTarget Then
                                If dir = "Ascending" Then
                                    ListaDeOrdens.Add(OrdemL1)
                                    L1.Ordem = RetornaRandom()
                                    GuardaLinha(ctx, L1)
                                    LinhasModificar.Remove(L1)
                                Else
                                    ListaDeOrdens.Add(OrdemL2)
                                    L2.Ordem = RetornaRandom()
                                    GuardaLinha(ctx, L2)
                                    LinhasModificar.Remove(L2)
                                    LinhasModificar.Reverse()
                                End If
                            Else
                                If dir = "Ascending" Then
                                    ListaDeOrdens.Add(OrdemL2)
                                    L2.Ordem = RetornaRandom()
                                    GuardaLinha(ctx, L2)
                                    LinhasModificar.Remove(L2)
                                    LinhasModificar.Reverse()
                                Else
                                    ListaDeOrdens.Add(OrdemL1)
                                    L1.Ordem = RetornaRandom()
                                    GuardaLinha(ctx, L1)
                                    LinhasModificar.Remove(L1)
                                End If
                            End If

                            'GUARDA ORIGENS MEIO
                            For Each linha In LinhasModificar
                                ListaDeOrdens.Add(linha.Ordem)
                            Next

                            'DEFINE ORIGEM MEIO
                            Dim index As Integer = 0
                            For Each linha In LinhasModificar
                                linha.Ordem = ListaDeOrdens(index)
                                GuardaLinha(ctx, linha)
                                index += 1
                            Next

                            'GUARDA ORIGEM COM VALOR DE DESTINO
                            If inOrdemDest > inOrdemTarget Then
                                If dir = "Ascending" Then
                                    L1.Ordem = OrdemL2
                                    GuardaLinha(ctx, L1)
                                Else
                                    L2.Ordem = OrdemL1
                                    GuardaLinha(ctx, L2)
                                End If
                            Else
                                If dir = "Ascending" Then
                                    L2.Ordem = OrdemL1
                                    GuardaLinha(ctx, L2)
                                Else
                                    L1.Ordem = OrdemL2
                                    GuardaLinha(ctx, L1)
                                End If
                            End If
                        End Using
                    Else 'APENAS TROCA A ORDEM DOS 2 ELEMENTOS
                        Using ctx As New BD.Dinamica.Aplicacao
                            L1.Ordem = RetornaRandom()
                            L2.Ordem = OrdemL1
                            GuardaLinha(ctx, L1)
                            GuardaLinha(ctx, L2)
                            L1.Ordem = OrdemL2
                            GuardaLinha(ctx, L1)
                        End Using
                    End If
                Else
                    Using ctx As New BD.Dinamica.Aplicacao
                        Dim query = ctx.tbDimensoesLinhas.AsNoTracking.Where(Function(f) f.IDDimensao = IDDimensao And f.Ordem > inOrdemTarget).OrderBy(Function(f) f.Ordem).ToList
                        For Each linha In query
                            linha.Ordem = linha.Ordem - 1
                            GuardaLinha(ctx, linha)
                        Next
                    End Using
                End If
            Else
                Using ctx As New BD.Dinamica.Aplicacao
                    Dim query As IQueryable(Of tbDimensoesLinhas) = ctx.tbDimensoesLinhas.AsNoTracking.Where(Function(f) f.IDDimensao = IDDimensao And f.Ordem > inOrdemTarget).OrderBy(Function(f) f.Ordem)
                    LinhasModificar = query.ToList
                    For Each linha In LinhasModificar
                        linha.Ordem -= 1
                    Next
                    ctx.SaveChanges()
                End Using
            End If
        End Sub

#End Region

#Region "Funcoes Auxiliares"
        Private Sub GuardaLinha(ctx As BD.Dinamica.Aplicacao, Linha As tbDimensoesLinhas)
            ctx.tbDimensoesLinhas.Attach(Linha)
            ctx.Entry(Linha).State = EntityState.Modified
            ctx.SaveChanges()
        End Sub

        Private Function RetornaRandom() As Integer
            Dim rnd As New Random
            Dim random = rnd.Next(99999, 99999999)
            Return random
        End Function
#End Region

    End Class
End Namespace