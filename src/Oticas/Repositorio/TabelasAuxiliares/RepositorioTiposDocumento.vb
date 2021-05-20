Imports System.Data.Entity
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports F3M.Repositorio.TabelasAuxiliaresComum
Imports F3M.Repositorios.Administracao

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioTiposDocumento
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbTiposDocumento, Oticas.TiposDocumento)

        Dim EMultiEmpresa As Boolean = ClsF3MSessao.VerificaSessaoObjeto().Licenciamento.ExisteModulo(ModulosLicenciamento.Prisma.MultiEmpresa)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        ' Listagem Tipos de documento Generico + Especifico (para versao generica ver no proj Produz)
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of Oticas.TiposDocumento)
            Dim queryTB As IQueryable(Of tbTiposDocumento) = Nothing
            Dim query As IQueryable(Of TiposDocumento) = Nothing

            Using repD As New RepositorioTipoDoc
                ' Retorna listagem de registos da BD + Filtra Generico
                queryTB = repD.ListaTudoBD(Of tbTiposDocumento, tbTiposDocumentoTipEntPermDoc)(BDContexto, inFiltro, True)
            End Using

            If queryTB IsNot Nothing AndAlso queryTB.Count > 0 Then
                ' Filtra Especifico
                FiltraQueryEsp(queryTB, inFiltro)
                ' Mapeia
                query = ListaCamposTodos(queryTB)
            End If

            Return query.AsQueryable
        End Function

        ' Mapear Tipos de documento Generico
        Protected Overrides Function ListaCamposTodos(inQuery As IQueryable(Of tbTiposDocumento)) As IQueryable(Of Oticas.TiposDocumento)
            Using repD As New RepositorioTipoDoc
                Return repD.MapeiaLista(Of tbTiposDocumento, Oticas.TiposDocumento, tbTiposDocumentoTipEntPermDoc, tbSistemaTiposDocumentoColunasAutomaticas)(inQuery)
            End Using
        End Function

        ' Listagem Tipos de documento Generico + Especifico para a Combo (para versao generica ver no proj Produz)
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of Oticas.TiposDocumento)
            Dim queryTB As IQueryable(Of tbTiposDocumento) = Nothing
            Dim query As IQueryable(Of TiposDocumento) = Nothing

            Using repD As New RepositorioTipoDoc
                ' Retorna listagem de registos da BD + Filtra Generico
                queryTB = repD.ListaTudoBD(Of tbTiposDocumento, tbTiposDocumentoTipEntPermDoc)(BDContexto, inFiltro, True, True)
            End Using

            If queryTB IsNot Nothing AndAlso queryTB.Count > 0 Then
                ' Filtra Especifico
                FiltraQueryEsp(queryTB, inFiltro)
                ' Mapeia
                query = ListaCamposCombo(queryTB)
            End If

            Return query?.AsQueryable()
        End Function

        ' Mapear Tipos de documento Generico para a Combo
        Protected Overrides Function ListaCamposCombo(inQuery As IQueryable(Of tbTiposDocumento)) As IQueryable(Of Oticas.TiposDocumento)
            Using repD As New RepositorioTipoDoc
                Return repD.MapeiaLista(Of tbTiposDocumento, Oticas.TiposDocumento, tbTiposDocumentoTipEntPermDoc, tbSistemaTiposDocumentoColunasAutomaticas)(inQuery, True).
                    Take(TamanhoDados.NumeroMaximo)
            End Using
        End Function

        ' FILTRA QUERY ESPECIFICO
        Protected Sub FiltraQueryEsp(ByRef inQuery As IQueryable(Of tbTiposDocumento), inFiltro As ClsF3MFiltro,
                                     Optional ByRef inCtx As DbContext = Nothing)
            ' --- ESPECIFICO ---
            Dim lngIDMod As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDModulo, GetType(Long))
            Dim lngIDSistTipoDoc As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDSistemaTipoDocumento", GetType(Long))
            Dim strTipoDoc As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "FiltrarTipoDocumentos", GetType(String))
            Dim strCodigoModulo As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "CodigoModulo", GetType(String))
            'ESPECIFICO DUPLICAR
            Dim FromDuplicar As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "FromDuplicar", GetType(Boolean))
            Dim IDSistemaTipoEntidadeDuplicar As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDSistemaTipoEntidadeDuplicar", GetType(Long))

            strTipoDoc = strTipoDoc.ToLower

            If Not ClsTexto.ENuloOuVazio(strTipoDoc) Then
                If strTipoDoc = "ftfsfr" Then
                    inQuery = inQuery.Where(Function(w) w.Ativo = True AndAlso
                                                Not w.Adiantamento AndAlso
                                                w.tbSistemaTiposDocumentoFiscal IsNot Nothing AndAlso
                                                (w.tbSistemaTiposDocumentoFiscal.Tipo = TiposDocumentosFiscal.Fatura OrElse
                                                w.tbSistemaTiposDocumentoFiscal.Tipo = TiposDocumentosFiscal.FaturaRecibo OrElse
                                                w.tbSistemaTiposDocumentoFiscal.Tipo = TiposDocumentosFiscal.FaturaSimplificada))

                ElseIf strTipoDoc = "nc" Then
                    inQuery = inQuery.Where(Function(w) w.Ativo = True AndAlso
                                                Not w.Adiantamento AndAlso
                                                w.tbSistemaTiposDocumentoFiscal IsNot Nothing AndAlso
                                                w.tbSistemaTiposDocumentoFiscal.Tipo = TiposDocumentosFiscal.NotaCredito)
                End If
            Else
                If lngIDSistTipoDoc = 17 Then ' Especifico para Servicos
                    inQuery = inQuery.Where(Function(w) w.IDSistemaTiposDocumento = lngIDSistTipoDoc)

                ElseIf lngIDMod = 5 Or strCodigoModulo = SistemaCodigoModulos.ContaCorrente Then
                    inQuery = inQuery.Where(Function(w) (w.tbSistemaModulos.Codigo = SistemaCodigoModulos.ContaCorrente AndAlso w.IDSistemaTiposLiquidacao Is Nothing))

                ElseIf lngIDMod <> 0 Then
                    inQuery = inQuery.Where(Function(w) (w.tbSistemaTiposDocumentoFiscal Is Nothing) OrElse
                                        (w.tbSistemaTiposDocumentoFiscal IsNot Nothing AndAlso w.tbSistemaTiposDocumentoFiscal.Tipo <> TiposDocumentosFiscal.ReciboVendas))

                    inQuery = inQuery.Where(Function(w) w.tbSistemaTiposDocumento.Tipo <> TiposSistemaTiposDocumento.VendasServico And w.Adiantamento = False)
                End If
            End If

            ''ESPECIFICO DUPLICAR
            If FromDuplicar AndAlso IDSistemaTipoEntidadeDuplicar <> 0 Then
                Dim LstTiposEntiade As List(Of Long) = New List(Of Long) From {IDSistemaTipoEntidadeDuplicar} 'esta lista e para fazer o contains
                inQuery = inQuery.Where(Function(w) w.tbTiposDocumentoTipEntPermDoc.Any(Function(a) LstTiposEntiade.Contains(a.tbSistemaTiposEntidadeModulos.tbSistemaTiposEntidade.ID)))
            End If
        End Sub

        ''' <summary>
        ''' Funcao que retorna a serie por defeito para a contagem de stocks
        ''' </summary>
        ''' <returns></returns>
        Public Function ObtemSeriePorDefeitoContagemStock() As TiposDocumentoSeries
            'get id loja sede by id loja em sessao
            Dim IDLojaSedeByIDLojaEmSessao As Long
            Using rpLojas As New RepositorioLojas
                IDLojaSedeByIDLojaEmSessao = rpLojas.RetornaIDLojaSedeByLojaEmSessao
            End Using
            'func where gen to docsocks contagem
            Dim funcWhere As Func(Of tbTiposDocumentoSeries, Boolean) = Function(w)
                                                                            Return w.tbTiposDocumento.tbSistemaModulos.Codigo = SistemaCodigoModulos.Stocks AndAlso
                                                                            w.tbTiposDocumento.tbSistemaTiposDocumento.Tipo = "StkContagemStock" AndAlso
                                                                            w.tbTiposDocumento.Predefinido = True
                                                                        End Function
            'get func where for multi empresa
            Dim funcWhereMultiEmpresa As Func(Of tbTiposDocumentoSeries, Boolean) = Function(w)
                                                                                        If EMultiEmpresa Then
                                                                                            Return Not w.IDLoja Is Nothing AndAlso w.IDLoja = IDLojaSedeByIDLojaEmSessao

                                                                                        Else
                                                                                            Return w.tbTiposDocumento.Predefinido = True
                                                                                        End If
                                                                                    End Function
            'get select function => map tbTiposDocumentoSeries to TiposDocumentoSeries
            Dim funcSel As Func(Of tbTiposDocumentoSeries, TiposDocumentoSeries) = Function(tipoDocumentoSeries)
                                                                                       Return New TiposDocumentoSeries With {
                                                                                       .ID = tipoDocumentoSeries.ID,
                                                                                       .CodigoSerie = tipoDocumentoSeries.CodigoSerie,
                                                                                       .DescricaoSerie = tipoDocumentoSeries.DescricaoSerie,
                                                                                       .IDTiposDocumento = tipoDocumentoSeries.IDTiposDocumento,
                                                                                       .CodigoTipoDocumento = tipoDocumentoSeries.tbTiposDocumento.Codigo,
                                                                                       .DescricaoTipoDocumento = tipoDocumentoSeries.tbTiposDocumento.Descricao,
                                                                                       .IDModulo = tipoDocumentoSeries.tbTiposDocumento.IDModulo,
                                                                                       .IDSistemaTipoDocumento = tipoDocumentoSeries.tbTiposDocumento.IDSistemaTiposDocumento,
                                                                                       .CodigoDescricao = tipoDocumentoSeries.tbTiposDocumento.Codigo & " - " & tipoDocumentoSeries.tbTiposDocumento.Descricao}
                                                                                   End Function
            'return tipo doc serie
            Return BDContexto.tbTiposDocumentoSeries.Where(funcWhere).Where(funcWhereMultiEmpresa).Select(funcSel).FirstOrDefault
        End Function

        ''' <summary>
        ''' Funcao que retorna a serie por defeito para os servicos de substituicao de artigos
        ''' </summary>
        ''' <returns></returns>
        Public Function ObtemSeriePorDefeitoServicosSubstituicao() As TiposDocumentoSeries
            'get id loja sede by id loja em sessao
            Dim IDLojaSedeByIDLojaEmSessao As Long
            Using rpLojas As New RepositorioLojas
                IDLojaSedeByIDLojaEmSessao = rpLojas.RetornaIDLojaSedeByLojaEmSessao
            End Using
            'func where gen to docsocks contagem
            Dim funcWhere As Func(Of tbTiposDocumentoSeries, Boolean) = Function(w)
                                                                            Return w.tbTiposDocumento.tbSistemaModulos.Codigo = SistemaCodigoModulos.Oficina AndAlso
                                                                            w.tbTiposDocumento.tbSistemaTiposDocumento.Tipo = "SubstituicaoArtigos" AndAlso
                                                                            w.tbTiposDocumento.Predefinido = True
                                                                        End Function
            'get func where for multi empresa
            Dim funcWhereMultiEmpresa As Func(Of tbTiposDocumentoSeries, Boolean) = Function(w)
                                                                                        If EMultiEmpresa Then
                                                                                            Return Not w.IDLoja Is Nothing AndAlso w.IDLoja = IDLojaSedeByIDLojaEmSessao

                                                                                        Else
                                                                                            Return w.tbTiposDocumento.Predefinido = True
                                                                                        End If
                                                                                    End Function
            'get select function => map tbTiposDocumentoSeries to TiposDocumentoSeries
            Dim funcSel As Func(Of tbTiposDocumentoSeries, TiposDocumentoSeries) = Function(tipoDocumentoSeries)
                                                                                       Return New TiposDocumentoSeries With {
                                                                                       .ID = tipoDocumentoSeries.ID,
                                                                                       .CodigoSerie = tipoDocumentoSeries.CodigoSerie,
                                                                                       .DescricaoSerie = tipoDocumentoSeries.DescricaoSerie,
                                                                                       .IDTiposDocumento = tipoDocumentoSeries.IDTiposDocumento,
                                                                                       .CodigoTipoDocumento = tipoDocumentoSeries.tbTiposDocumento.Codigo,
                                                                                       .DescricaoTipoDocumento = tipoDocumentoSeries.tbTiposDocumento.Descricao,
                                                                                       .IDModulo = tipoDocumentoSeries.tbTiposDocumento.IDModulo,
                                                                                       .IDSistemaTipoDocumento = tipoDocumentoSeries.tbTiposDocumento.IDSistemaTiposDocumento,
                                                                                       .CodigoDescricao = tipoDocumentoSeries.tbTiposDocumento.Codigo & " - " & tipoDocumentoSeries.tbTiposDocumento.Descricao}
                                                                                   End Function
            'return tipo doc serie
            Return BDContexto.tbTiposDocumentoSeries.Where(funcWhere).Where(funcWhereMultiEmpresa).Select(funcSel).FirstOrDefault
        End Function
#End Region

#Region "ESCRITA"
        ' ADICIONA POR OBJETO
        Public Overrides Sub AdicionaObj(ByRef o As TiposDocumento, inFiltro As ClsF3MFiltro)
            Try
                Using ctx As New Oticas.BD.Dinamica.Aplicacao
                    Using trans As DbContextTransaction = ctx.Database.BeginTransaction(IsolationLevel.RepeatableRead)
                        Try
                            If o.IDSistemaTiposDocumentoMovStock = 0 Then o.IDSistemaTiposDocumentoMovStock = Nothing
                            ValidaLinhas(ctx, o, AcoesFormulario.Adicionar)
                            RepositorioTipoDoc.GravaPredefinido(Of tbTiposDocumento)(ctx, o)
                            'o.IDArtigosStock = Nothing
                            Dim e As tbTiposDocumento = GravaObjContexto(ctx, o, AcoesFormulario.Adicionar)

                            ctx.SaveChanges()
                            ' GRAVA LINHAS
                            GravaLinhasTodas(ctx, o, e, AcoesFormulario.Adicionar)
                            trans.Commit()
                            o.ID = e.ID
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

        ' EDITA POR OBJETO
        Public Overrides Sub EditaObj(ByRef o As TiposDocumento, inFiltro As ClsF3MFiltro)
            Try
                Using ctx As New Oticas.BD.Dinamica.Aplicacao
                    Using trans As DbContextTransaction = ctx.Database.BeginTransaction(IsolationLevel.RepeatableRead)
                        Try
                            If o.IDSistemaTiposDocumentoMovStock = 0 Then o.IDSistemaTiposDocumentoMovStock = Nothing
                            ValidaLinhas(ctx, o, AcoesFormulario.Alterar)
                            RepositorioTipoDoc.GravaPredefinido(Of tbTiposDocumento)(ctx, o)

                            Dim e As tbTiposDocumento = GravaObjContexto(ctx, o, AcoesFormulario.Alterar)

                            ' GRAVA LINHAS
                            GravaLinhasTodas(ctx, o, e, AcoesFormulario.Alterar)

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

        ' REMOVE POR OBJETO
        Public Overrides Sub RemoveObj(ByRef o As TiposDocumento, inFiltro As ClsF3MFiltro)
            Try
                Using ctx As New Oticas.BD.Dinamica.Aplicacao
                    Dim IDTipoDoc = o.ID
                    Dim lstSeries = ctx.tbTiposDocumentoSeries.Where(Function(f) f.IDTiposDocumento = IDTipoDoc).ToList()
                    Using rep As New RepositorioTiposDocumentoSeries
                        If lstSeries.Count > 0 Then
                            rep.RemovePerfisAcessoAcaoRemove(lstSeries)
                        End If
                    End Using
                End Using
                AcaoObjTransacao(o, AcoesFormulario.Remover)
            Catch
                Throw
            End Try
        End Sub

        ' GRAVA LINHAS
        Protected Overrides Sub GravaLinhasTodas(ByRef inCtx As BD.Dinamica.Aplicacao, ByRef o As TiposDocumento,
                                                 e As tbTiposDocumento, inAcao As AcoesFormulario)
            Dim dict As Dictionary(Of String, Object) = New Dictionary(Of String, Object)
            dict.Add("IDTiposDocumento", e.ID)

            If inAcao.Equals(AcoesFormulario.Adicionar) Or inAcao.Equals(AcoesFormulario.Alterar) Then

                If Not IsNothing(o.TiposDocumentoSeries) Then
                    Using rep As New RepositorioTiposDocumentoSeries
                        For Each lin In o.TiposDocumentoSeries
                            lin.IDTiposDocumento = If(lin.IDTiposDocumento = 0, e.ID, lin.IDTiposDocumento)
                            lin.IDParametrosEmpresaCAE = If(lin.IDParametrosEmpresaCAE Is Nothing OrElse lin.IDParametrosEmpresaCAE = 0, Nothing, lin.IDParametrosEmpresaCAE)

                            Dim blnTemDocsAssoc As Boolean = inCtx.tbControloDocumentos.Any(Function(f) f.IDTipoDocumento = lin.IDTiposDocumento AndAlso f.IDTiposDocumentoSeries = lin.ID)

                            'para remover serie não pode ter documentos associados
                            If lin.AcaoRemover = True AndAlso Not blnTemDocsAssoc Then
                                GravaLinhasEntidades(Of tbTiposDocumentoSeries)(inCtx, e.tbTiposDocumentoSeries.Where(Function(f) f.ID = lin.ID).ToList, AcoesFormulario.Remover, Nothing)
                            Else
                                If inAcao.Equals(AcoesFormulario.Alterar) Then
                                    If e.tbControloDocumentos.Where(Function(s) s.NumeroDocumento <> 0 AndAlso s.IDTipoDocumento = e.ID AndAlso s.IDTiposDocumentoSeries = lin.ID).Count > 0 Then
                                        '  lin.ListaCamposEvitaMapear
                                        lin.ExecutaListaCamposEvitaMapear = True
                                        lin.ListaCamposEvitaMapear = New List(Of String)
                                        lin.ListaCamposEvitaMapear.Add("NumUltimoDoc")
                                        lin.ListaCamposEvitaMapear.Add("DataUltimoDoc")
                                    End If
                                End If

                                Dim dictSerie As Dictionary(Of String, Object) = New Dictionary(Of String, Object)
                                dictSerie.Add("IDSerie", lin.ID)
                                rep.GravaObjEsp(inCtx, lin, inAcao)
                            End If
                        Next

                    End Using
                End If

                GravaLinhas(Of tbTiposDocumentoIdioma, TiposDocumentoIdiomas)(inCtx, e, o, dict)

            ElseIf inAcao.Equals(AcoesFormulario.Remover) Then
                GravaLinhasEntidades(Of tbTiposDocumentoSeries)(inCtx, e.tbTiposDocumentoSeries.ToList, AcoesFormulario.Remover, Nothing)
                GravaLinhasEntidades(Of tbTiposDocumentoIdioma)(inCtx, e.tbTiposDocumentoIdioma.ToList, AcoesFormulario.Remover, Nothing)
            End If
            'ESPECIFICO LINHAS DA TREEVIEW(NAO SE UTILIZOU OS METODOS ACIMA PORQUE A TREEVIEW USA 2 CLASSES DIFERENTES(CARREGAMENTO DE TIPOS E CARREGAMENTO DE LINHAS ASSOCIADAS AO 
            ' ID TIPO DOCUMENTO, PROVOCA CONFLITO DE ID'S NO GRAVALINHAS GENERICO
            'TODO: REAVALIAR CARREGAMENTO DA TREEVIEW
            GravaTreeView(inCtx, o, e, inAcao)
            Using rep As New RepositorioTiposDocumentoSeries
                If o.TiposDocumentoSeries IsNot Nothing Then
                    For Each lin In o.TiposDocumentoSeries
                        If lin.AcaoRemover = True Then
                            rep.RemovePerfisAcesso(lin)
                        End If
                    Next
                End If
            End Using

        End Sub

        Private Sub GravaTreeView(ByRef inCtx As BD.Dinamica.Aplicacao, ByRef o As TiposDocumento, e As tbTiposDocumento, inAcao As AcoesFormulario)
            Dim LinhasDoTipoDocumento = inCtx.tbTiposDocumentoTipEntPermDoc.Where(Function(f) f.IDTiposDocumento = e.ID And f.ContadorDoc = 0).ToList
            Dim LinhasNaoRemovidas = inCtx.tbTiposDocumentoTipEntPermDoc.Where(Function(f) f.IDTiposDocumento = e.ID And f.ContadorDoc > 0).ToList

            inCtx.tbTiposDocumentoTipEntPermDoc.RemoveRange(LinhasDoTipoDocumento)
            Dim LinhasSistemaTiposEntidadeModulos = inCtx.tbSistemaTiposEntidadeModulos.ToList

            If inAcao.Equals(AcoesFormulario.Adicionar) Or inAcao.Equals(AcoesFormulario.Alterar) Then
                If LinhasDoTipoDocumento.Count > 0 Or LinhasNaoRemovidas.Count > 0 Or inAcao.Equals(AcoesFormulario.Adicionar) Then
                    If Not IsNothing(o.TiposDocumentoTipEntPermDoc) Then
                        For Each linha In o.TiposDocumentoTipEntPermDoc
                            If linha.checked Then
                                Dim obj As New tbTiposDocumentoTipEntPermDoc
                                With obj
                                    .IDTiposDocumento = e.ID
                                    .IDSistemaTiposEntidadeModulos = LinhasSistemaTiposEntidadeModulos.Where(Function(f) f.IDSistemaModulos = e.IDModulo And f.IDSistemaTiposEntidade = linha.ID).FirstOrDefault.ID
                                    .DataCriacao = Date.Now()
                                    .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome
                                    .UtilizadorAlteracao = ClsF3MSessao.RetornaUtilizadorNome
                                    .DataAlteracao = Date.Now()
                                End With
                                If LinhasNaoRemovidas.Count > 0 Then
                                    For Each item In LinhasNaoRemovidas
                                        If item.IDTiposDocumento <> obj.IDTiposDocumento Or item.tbSistemaTiposEntidadeModulos.ID <> obj.IDSistemaTiposEntidadeModulos Then
                                            inCtx.tbTiposDocumentoTipEntPermDoc.Attach(obj)
                                            inCtx.Entry(obj).State = Entity.EntityState.Added
                                        End If
                                    Next
                                Else
                                    inCtx.tbTiposDocumentoTipEntPermDoc.Attach(obj)
                                    inCtx.Entry(obj).State = Entity.EntityState.Added
                                End If
                            End If
                        Next
                    End If
                End If
            End If

            inCtx.SaveChanges()
        End Sub
#End Region

#Region "FUNÇÕES AUXILIARES"
#End Region

    End Class
End Namespace