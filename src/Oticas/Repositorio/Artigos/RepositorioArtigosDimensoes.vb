Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Base
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.ConstantesKendo
Imports F3M.Modelos.Genericos
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.Artigos
    Public Class RepositorioArtigosDimensoes
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbArtigosDimensoes, ArtigosDimensoes)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbArtigosDimensoes)) As IQueryable(Of ArtigosDimensoes)
            Return query.Select(Function(e) New ArtigosDimensoes With {
                .ID = e.ID, .IDArtigo = e.IDArtigo, .DescricaoArtigo = e.tbArtigos.Descricao,
                .IDDimensaoLinha1 = e.IDDimensaoLinha1, .DescricaoDimensaoLinha1 = e.tbDimensoesLinhas.Descricao,
                    .OrdemDimensaoLinha1 = e.tbDimensoesLinhas.Ordem, .VirtualDimensaoLinha1 = e.tbDimensoesLinhas.Virtual,
                .IDDimensaoLinha2 = e.IDDimensaoLinha2, .DescricaoDimensaoLinha2 = e.tbDimensoesLinhas1.Descricao,
                    .OrdemDimensaoLinha2 = e.tbDimensoesLinhas1.Ordem, .VirtualDimensaoLinha2 = e.tbDimensoesLinhas1.Virtual,
                .CodigoBarras = e.CodigoBarras, .StkMin = e.StkMin, .StkMax = e.StkMax,
                .QtdPendenteCompras = e.QtdPendenteCompras, .StkEncomenda = e.StkEncomenda, .StkArtigo = e.StkArtigo, .StkArmazem = e.StkArmazem,
                .UPC = e.UPC, .UltimoCustoAdicional = e.UltimoCustoAdicional, .CustoMedio = e.CustoMedio,
                .PV1 = e.PV1, .PV2 = e.PV2, .PV3 = e.PV3, .PV4 = e.PV4, .PV5 = e.PV5, .PV6 = e.PV6, .PV7 = e.PV7, .PV8 = e.PV8, .PV9 = e.PV9, .PV10 = e.PV10,
                .PVP = e.PVP, .TextoExtra = e.TextoExtra,
                .CodEstatistico = e.CodEstatistico, .TextoExtra2 = e.TextoExtra2, .TextoExtra3 = e.TextoExtra3,
                .Sistema = e.Sistema, .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador,
                .CustoPadrao = e.CustoPadrao
            })
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbArtigosDimensoes)) As IQueryable(Of ArtigosDimensoes)
            Return query.Select(Function(e) New ArtigosDimensoes With {
                .ID = e.ID
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of ArtigosDimensoes)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of ArtigosDimensoes)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ''' <summary>
        ''' Para filtrar a tabela
        ''' </summary>
        ''' <param name="inFiltro"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbArtigosDimensoes)
            Dim query As IQueryable(Of tbArtigosDimensoes) = tabela.AsNoTracking
            Dim IDArt As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.ID, GetType(Long))

            AplicaFiltroAtivo(inFiltro, query)

            query = query.Where(Function(o) o.IDArtigo = IDArt).Distinct

            Return query
        End Function

        ' LISTA ESPECIFICO
        Private Function ListaEspecifico(inFiltro As ClsF3MFiltro) As IQueryable(Of ArtigosDimensoes)
            Dim IDArt As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDArtigo, GetType(Long))
            Dim strAux As String = ClsUtilitarios.RetornaValorKeyDicionario(inFiltro.CamposFiltrar, CamposEspecificos.TipoOperacoesDimensoes, Atributos.F3M.CampoTexto)
            Dim strDDLTipoOp As String = Traducao.Traducao.ClsTraducao.ReturnKeysByValues(strAux, ClsF3MSessao.Idioma, 2).FirstOrDefault

            If IDArt > 0 AndAlso Not ClsTexto.ENuloOuVazio(strDDLTipoOp) Then
                Dim strQuery As String = ClsTexto.ConcatenaStrings(New String() {
                    "SELECT ad.ID AS ID, d1.Descricao AS DescricaoDimensaoLinha1, d2.Descricao AS DescricaoDimensaoLinha2,",
                        " {0} AS ", strDDLTipoOp, ", ad.IDDimensaoLinha1, ad.IDDimensaoLinha2,",
                        " d1.Ordem AS OrdemDimensaoLinha1, d2.Ordem AS OrdemDimensaoLinha2",
                        " FROM tbArtigosDimensoes AS ad",
                        " LEFT JOIN tbDimensoesLinhas AS d1 ON ad.IDDimensaoLinha1 = d1.id ",
                        " LEFT JOIN tbDimensoesLinhas AS d2 ON ad.IDDimensaoLinha2 = d2.id ",
                        " WHERE IDArtigo = ", IDArt, " AND ad.ID in (",
                            " SELECT IDArtigosDimensoes",
                                " FROM tbArtigosDimensoesEmpresa AS ade",
                                " LEFT JOIN tbArtigosDimensoes AS tbad ON ade.IDArtigosDimensoes = tbad.ID",
                                " WHERE tbad.IDArtigo = ", IDArt, ")"})

                Dim TipoFormatoCampo = GetType(ArtigosDimensoes).GetProperty(strDDLTipoOp).GetCustomAttributesData _
                                       .Where(Function(f) f.AttributeType.Name = Atributos.F3M.Anotacao).FirstOrDefault _
                                       .NamedArguments.Where(Function(f) f.MemberName = "TipoFormatoCampo").FirstOrDefault.TypedValue.Value.ToString

                If TipoFormatoCampo = Mvc.Componentes.F3MTexto Then
                    strQuery = strQuery.Replace("{0}", "ad." & strDDLTipoOp)
                Else
                    strQuery = strQuery.Replace("{0}", "ISNULL(ad." & strDDLTipoOp & ", 0)")
                End If

                Return BDContexto.ExecutaQueryeDevolveIQueryable(Of ArtigosDimensoes)(strQuery)
            End If

            Dim lista As New List(Of ArtigosDimensoes)
            Return lista.AsQueryable
        End Function

#End Region

#Region "ESCRITA"
        'ATUALIZA
        Public Sub EditaLinhas(inFiltro As ClsF3MFiltro)
            Dim IDArt As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDArtigo, GetType(Long))

            If IDArt > 0 Then
                Using ctx As New BD.Dinamica.Aplicacao
                    Dim dict As Dictionary(Of String, Object) = New Dictionary(Of String, Object)

                    dict.Add(CamposGenericos.IDArtigo, IDArt)
                    EditaLinhasMatriz(Of tbArtigosDimensoes)(ctx, inFiltro, dict)
                    ctx.SaveChanges()
                End Using
            End If
        End Sub

        'GUARDA DIMENSOES
        Public Sub GuardaMatriz(inFiltro As ClsF3MFiltro)
            Try
                Using ctx As New BD.Dinamica.Aplicacao
                    'Using trans As DbContextTransaction = ctx.Database.BeginTransaction(IsolationLevel.ReadCommitted)
                    'Try
                    Dim IDArt As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDArtigo, GetType(Long))

                    ' TIPO DIMENSAO
                    Dim dictCV As Dictionary(Of String, Dictionary(Of String, String)) = inFiltro.CampoValores
                    Dim IDDim As Long = -1
                    Dim strTipoDime As String = String.Empty
                    If dictCV IsNot Nothing Then
                        strTipoDime = dictCV.Keys.FirstOrDefault()
                        IDDim = ClsUtilitarios.RetornaValorKeyDicionarioCampoValores(inFiltro, strTipoDime, GetType(Long))
                    End If

                    ''verificar aqui....
                    '' REMOVIDOS
                    'Dim dictAux As Dictionary(Of String, String) = ClsUtilitarios.RetornaValorKeyDicionarioLinhasIDs(inFiltro, "IDsRemovidos", String.Empty)
                    'Dim IDsRem() As String = Nothing
                    'Dim valor1 As List(Of FichaTecnicaLinhasDimensao1) = Nothing
                    'Dim valor2 As List(Of FichaTecnicaLinhasDimensao2) = Nothing
                    'Dim valorMP1 As List(Of FichaTecnicaMateriasPrimasDist) = Nothing
                    'Dim valorMP2 As List(Of FichaTecnicaMateriasPrimasDist) = Nothing

                    'If dictAux IsNot Nothing Then
                    '    IDsRem = dictAux.Keys.ToArray
                    'End If
                    'If IDsRem IsNot Nothing Then
                    '    strfilterIDsRemPA = String.Join(" OR a.IDArtigoDimensaoLinha = ", IDsRem)
                    '    strfilterIDsRemMP1 = String.Join(" OR a.IDFichaTecnicaMatPrimaDimensao1 = ", IDsRem)
                    '    strfilterIDsRemMP2 = String.Join(" OR a.IDFichaTecnicaMatPrimaDimensao2 = ", IDsRem)

                    '    If strTipoDime = "DimensaoLinha1" Then
                    '        valor1 = ValidaDims1PAFT(IDArt, strfilterIDsRemPA)
                    '        valorMP1 = ValidaDims1MPFT(IDArt, strfilterIDsRemMP1)
                    '        If valor1.Count Or valorMP1.Count Then
                    '            Throw New Exception(ProduzTraducao.EstruturaDeErrosFK.FK_tbArtigos_tbDimensoes)
                    '        End If
                    '    End If
                    '    If strTipoDime = "DimensaoLinha2" Then
                    '        valor2 = ValidaDims2PAFT(IDArt, strfilterIDsRemPA)
                    '        valorMP2 = ValidaDims2MPFT(IDArt, strfilterIDsRemMP2)
                    '        If valor2.Count Or valorMP2.Count Then
                    '            Throw New Exception(ProduzTraducao.EstruturaDeErrosFK.FK_tbArtigos_tbDimensoes)
                    '        End If
                    '    End If

                    'End If
                    '    If Not ClsTexto.ENuloOuVazio(strTipoDime) Then
                    '        If strTipoDime = "DimensaoLinha1" Then
                    '            Dim TotalDimsFTArt1 = ctx.tbFichaTecnicaLinhasDimensao1.Where(Function(f) f.IDArtigoDimensaoLinha IsNot Nothing AndAlso IDsRem.Contains(f.IDArtigoDimensaoLinha)).Count
                    '            Dim TotalDimsFTMP1 = ctx.tbFichaTecnicaMateriasPrimasDist.Where(Function(f) f.IDFichaTecnicaArtigoDimensao1 IsNot Nothing AndAlso IDsRem.Contains(f.IDFichaTecnicaMatPrimaDimensao1)).Count
                    '            If TotalDimsFTArt1 > 0 Or TotalDimsFTMP1 > 0 Then
                    '                Throw New Exception(Traducao.ProducaoEstruturaDeErrosFK.FK_tbArtigos_tbDimensoes)
                    '            End If
                    '            'Throw New Exception("srfwer") 
                    '        End If
                    '        If strTipoDime = "DimensaoLinha2" Then
                    '            Dim TotalDimsAss2 = ctx.tbFichaTecnicaLinhasDimensao2.Where(Function(f) f.IDArtigoDimensaoLinha IsNot Nothing AndAlso IDsRem.Contains(f.IDArtigoDimensaoLinha)).Count
                    '            Dim TotalDimsFTMP2 = ctx.tbFichaTecnicaMateriasPrimasDist.Where(Function(f) f.IDFichaTecnicaArtigoDimensao2 IsNot Nothing AndAlso IDsRem.Contains(f.IDFichaTecnicaMatPrimaDimensao2)).Count
                    '            If TotalDimsAss2 > 0 Or TotalDimsFTMP2 > 0 Then
                    '                Throw New Exception(Traducao.ProducaoEstruturaDeErrosFK.FK_tbArtigos_tbDimensoes)
                    '            End If
                    '        End If
                    '    End If
                    'End If

                    If IDArt > 0 AndAlso Not ClsTexto.ENuloOuVazio(strTipoDime) Then
                        Dim iqTbAD As IQueryable(Of tbArtigosDimensoes) = tabela.AsNoTracking.Where(Function(f) f.IDArtigo = IDArt)
                        Dim iqTbADE As IQueryable(Of tbArtigosDimensoesEmpresa) = ctx.tbArtigosDimensoesEmpresa.AsNoTracking.Where(Function(f) f.tbArtigosDimensoes.IDArtigo = IDArt)

                        Dim ArtigosDimensoesDoArtigo As List(Of tbArtigosDimensoes) = tabela.AsNoTracking.Where(Function(f) f.IDArtigo = IDArt).ToList
                        'Trata associados
                        TrataArtigosDimensoesAssociados(strTipoDime, IDArt, iqTbAD, iqTbADE, inFiltro,
                            ctx, If(ArtigosDimensoesDoArtigo.Count > 0, False, True))
                        ctx.SaveChanges()
                        'Trata visiveis
                        TrataArtigosDimensoesVisiveis(strTipoDime, iqTbAD, iqTbADE, inFiltro, ctx)
                        ctx.SaveChanges()
                        ''Trata Linhas nulas
                        ApagaLinhasNulas(iqTbAD, iqTbADE, inFiltro, ctx)
                        ctx.SaveChanges()
                    End If
                End Using
            Catch
                Throw
            End Try
        End Sub
#End Region

#Region "Funções Auxiliares"


#Region "!!!!!!!! P R O D UZ !!!!!!!!"
#End Region


        'METODOS GERA TABELA
        Public Overrides Function GeraTabela(inFiltro As ClsF3MFiltro) As Object
            Dim IDArt As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDArtigo, GetType(Long))
            'Dim strDDLTipoOp As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposEspecificos.TipoOperacoesDimensoes, GetType(String))
            Dim strAux As String = ClsUtilitarios.RetornaValorKeyDicionario(inFiltro.CamposFiltrar, CamposEspecificos.TipoOperacoesDimensoes, Atributos.F3M.CampoTexto)
            Dim strDDLTipoOp As String = Traducao.Traducao.ClsTraducao.ReturnKeysByValues(strAux, ClsF3MSessao.Idioma, 2).FirstOrDefault

            Dim lstArtDim As List(Of ArtigosDimensoes) = ListaEspecifico(inFiltro).ToList()
            Dim dataGrelha As New ClsObjGenericoMatriz

            'Valida Dimensoes
            Dim res As String = ValidaDimensoes(lstArtDim, IDArt)

            If Not ClsTexto.ENuloOuVazio(res) Then
                Return New With {.data = Nothing, .errors = res}
            End If

            'TIPO DE DADOS DA VISUALIZACAO
            Dim aux = GetType(ArtigosDimensoes).GetProperty(strDDLTipoOp).GetCustomAttributesData.Where(Function(f) f.AttributeType.Name = "StringLengthAttribute").FirstOrDefault
            Dim maxLength = If(aux IsNot Nothing, aux.ConstructorArguments.FirstOrDefault.Value(), Nothing)
            Dim TipoFormatoCampo = GetType(ArtigosDimensoes).GetProperty(strDDLTipoOp).GetCustomAttributesData _
                                   .Where(Function(f) f.AttributeType.Name = Atributos.F3M.Anotacao).FirstOrDefault _
                                   .NamedArguments.Where(Function(f) f.MemberName = "TipoFormatoCampo").FirstOrDefault.TypedValue.Value.ToString

            dataGrelha.maxLengthCampo = CLng(maxLength)

            Select Case TipoFormatoCampo
                Case Mvc.Componentes.F3MNumero
                    dataGrelha.Tipo = "numeric"
                    dataGrelha.CasasDecimais = ClsF3MSessao.RetornaParametros.CasasDecimaisPercentagem
                Case Mvc.Componentes.F3MMoeda
                    dataGrelha.Tipo = "currency"
                    dataGrelha.CasasDecimais = ClsF3MSessao.RetornaParametros.MoedaReferencia.CasasDecimaisPrecosUnitarios
                    dataGrelha.Moeda = ClsF3MSessao.RetornaParametros.MoedaReferencia.Codigo
                Case Mvc.Componentes.F3MTexto
                    dataGrelha.Tipo = "text"
                Case Mvc.Componentes.F3MCheckBox
                    dataGrelha.Tipo = "checkbox"
                Case Mvc.Componentes.F3MDropDownList
                    dataGrelha.Tipo = "dropdown"
                Case Mvc.Componentes.F3MLookup
                    dataGrelha.Tipo = "lookup"
                Case Mvc.Componentes.F3MData
                    dataGrelha.Tipo = "date"
                Case Mvc.Componentes.F3MDataTempo
                    dataGrelha.Tipo = "date"
                Case Mvc.Componentes.F3MTempo
                    dataGrelha.Tipo = "date"
            End Select

            Dim ObjLinha As New List(Of Dictionary(Of String, Object))
            Dim ObjDataIDs As New List(Of Dictionary(Of String, Object))

            Dim Linhas As Dictionary(Of String, String) =
                lstArtDim.Where(Function(f) ClsUtilitarios.RetornaZeroSeVazio(f.IDDimensaoLinha1) <> 0) _
                    .OrderBy(Function(o) o.OrdemDimensaoLinha1) _
                    .GroupBy(Of String)(Function(o) o.IDDimensaoLinha1) _
                    .ToDictionary(Of String, String) _
                        (Function(d) d.Select(Function(s) s.IDDimensaoLinha1.ToString).FirstOrDefault,
                            Function(d2) d2.Select(Function(s) s.DescricaoDimensaoLinha1).FirstOrDefault)

            Dim Colunas As Dictionary(Of String, String) =
                lstArtDim.Where(Function(f) ClsUtilitarios.RetornaZeroSeVazio(f.IDDimensaoLinha2) <> 0) _
                    .OrderBy(Function(o) o.OrdemDimensaoLinha2) _
                    .GroupBy(Of String)(Function(o) o.IDDimensaoLinha2) _
                    .ToDictionary(Of String, String) _
                        (Function(d) d.Select(Function(s) s.IDDimensaoLinha2.ToString).FirstOrDefault,
                            Function(d2) d2.Select(Function(s) s.DescricaoDimensaoLinha2).FirstOrDefault)

            If Linhas.Count > 0 AndAlso Colunas.Count.Equals(0) Then
                Colunas.Add(0, String.Empty)
            End If

            dataGrelha.Linhas = Linhas.Select(Function(s) s.Value).ToList
            dataGrelha.Colunas = Colunas.Select(Function(s) s.Value).ToList

            For Each linha In Linhas
                Dim linhaID As Long = CLng(linha.Key)
                Dim dict As New Dictionary(Of String, Object)

                For Each coluna In Colunas
                    Dim colunaID As Long = CLng(coluna.Key)
                    Dim artDim As ArtigosDimensoes =
                        lstArtDim.Where(
                            Function(w) w.IDDimensaoLinha1.Equals(linhaID) _
                                AndAlso ClsUtilitarios.RetornaZeroSeVazio(w.IDDimensaoLinha2).Equals(colunaID)).FirstOrDefault

                    If artDim IsNot Nothing Then
                        Dim value = CStr(ClsUtilitarios.DaPropriedadedoModeloReflection(artDim, strDDLTipoOp))
                        Dim te As New ClsObjGenericoChaveDescricao With {
                            .ID = artDim.ID,
                            .Descricao = If(value IsNot Nothing, value.Replace(",", "."), Nothing)}
                        dict.Add(coluna.Value, te)
                    End If
                Next
                ObjLinha.Add(dict)
            Next

            dataGrelha.data = ObjLinha
            dataGrelha.TipoVisualizacao = strDDLTipoOp
            Return New With {.data = dataGrelha, .errors = Nothing}
        End Function

        Private Function ValidaDimensoes(lstArtDim As List(Of ArtigosDimensoes), inIDArtigo As Long)
            Using ctx As New BD.Dinamica.Aplicacao
                Dim LinhaArtigo = ctx.tbArtigos.Where(Function(f) f.ID = inIDArtigo).FirstOrDefault
                If LinhaArtigo.IDDimensaoPrimeira IsNot Nothing And LinhaArtigo.IDDimensaoSegunda IsNot Nothing Then '2 DIMENSOES
                    Dim ListaVisiveis = ctx.tbArtigosDimensoesEmpresa.Include("tbArtigosDimensoes").Where(Function(f) f.tbArtigosDimensoes.IDArtigo = inIDArtigo And f.tbArtigosDimensoes.IDDimensaoLinha1 IsNot Nothing And f.tbArtigosDimensoes.IDDimensaoLinha2 IsNot Nothing).Count
                    If (ListaVisiveis > 0) Then
                        If lstArtDim.Count = 0 Then
                            Return Traducao.EstruturaArtigos.MatrizConfigurarDimensoes '"Definir as dimensões"
                        ElseIf lstArtDim.Where(Function(f) f.IDDimensaoLinha1 Is Nothing).Count > 0 Then
                            Return Traducao.EstruturaArtigos.MatrizConfigurarDimensoes '"Definir a primeira dimensão"
                        ElseIf lstArtDim.Where(Function(f) f.IDDimensaoLinha2 Is Nothing).Count > 0 Then
                            Return Traducao.EstruturaArtigos.MatrizConfigurarDimensoes '"Definir a segunda dimensão"
                        End If
                    Else
                        Return Traducao.EstruturaArtigos.MatrizConfigurarDimensoes '"Definir as duas dimensões"
                    End If
                ElseIf LinhaArtigo.IDDimensaoPrimeira IsNot Nothing And LinhaArtigo.IDDimensaoSegunda Is Nothing Then '1 DIMENSAO
                    Dim ListaVisiveis = ctx.tbArtigosDimensoesEmpresa.Include("tbArtigosDimensoes").Where(Function(f) f.tbArtigosDimensoes.IDArtigo = inIDArtigo And f.tbArtigosDimensoes.IDDimensaoLinha1 IsNot Nothing And f.tbArtigosDimensoes.IDDimensaoLinha2 Is Nothing).Count
                    If (ListaVisiveis > 0) Then
                        Dim ListaAD = lstArtDim.Where(Function(f) f.IDDimensaoLinha1 Is Nothing)
                        If ListaAD.Count > 0 Then
                            If ListaAD.FirstOrDefault.IDDimensaoLinha1 Is Nothing Then
                                Return Traducao.EstruturaArtigos.MatrizConfigurarDimensoes '"Deve associar a primeira dimensão"
                            End If
                        End If
                        If lstArtDim.Count = 0 Then
                            Return Traducao.EstruturaArtigos.MatrizConfigurarDimensoes '"Deve associar a primeira dimensão"
                        End If
                    Else
                        Return Traducao.EstruturaArtigos.MatrizConfigurarDimensoes '"Definir a dimensão"
                    End If
                End If
                Return String.Empty
            End Using
        End Function

        'METODOS DE GESTAO ARTIGOS DIMENSOES (ASSOCIADOS)
        Private Sub TrataArtigosDimensoesAssociados(strTipoDime As String, IDArt As Long,
                iqTbAD As IQueryable(Of tbArtigosDimensoes), iqTbADE As IQueryable(Of tbArtigosDimensoesEmpresa),
                inFiltro As ClsF3MFiltro, ctx As BD.Dinamica.Aplicacao, AdicionaAutomaticamenteVisiveis As Boolean)

            Dim boolD1 As Boolean = strTipoDime.IndexOf(CamposEspecificos.DimensaoLinha1) <> -1
            Dim boolD2 As Boolean = strTipoDime.IndexOf(CamposEspecificos.DimensaoLinha2) <> -1

            ' LISTA ADICIONADOS E REMOVIDOS
            Dim dictAux As Dictionary(Of String, String) = ClsUtilitarios.RetornaValorKeyDicionarioLinhasIDs(inFiltro, "IDsAdicionados", String.Empty)
            ' ADICIONADOS
            Dim IDsAdd As String() = Nothing
            If dictAux IsNot Nothing Then
                IDsAdd = dictAux.Keys.ToArray
            End If
            ' REMOVIDOS
            dictAux = ClsUtilitarios.RetornaValorKeyDicionarioLinhasIDs(inFiltro, "IDsRemovidos", String.Empty)
            Dim IDsRem As String() = Nothing
            If dictAux IsNot Nothing Then
                IDsRem = dictAux.Keys.ToArray
            End If

            'INSERE ARTIGOSDIMENSOES NOVOS
            'Dim dbContextTransaction = BDContexto.Database.BeginTransaction()
            'Try
            If IDsAdd IsNot Nothing Then
                ' Using dbContextTransaction
                For Each IDadded In IDsAdd
                    Dim tbAD As tbArtigosDimensoes = New tbArtigosDimensoes With {.IDArtigo = IDArt}

                    If boolD1 Then
                        If iqTbAD.Where(Function(f) f.IDDimensaoLinha1 IsNot Nothing And f.IDDimensaoLinha1 = IDadded).Count = 0 Then
                            Dim totalDims2 = iqTbAD.Where(Function(f) f.IDDimensaoLinha2 IsNot Nothing).Select(Function(f) f.IDDimensaoLinha2).Distinct.ToList

                            If totalDims2.Count = 0 Then
                                tbAD.IDDimensaoLinha1 = IDadded
                                GravaEntidadeLinha(ctx, tbAD, AcoesFormulario.Adicionar, Nothing)
                            ElseIf totalDims2.Count > 0 Then
                                For Each n2 In totalDims2
                                    tbAD = New tbArtigosDimensoes With {
                                        .IDArtigo = IDArt,
                                        .IDDimensaoLinha1 = IDadded,
                                        .IDDimensaoLinha2 = n2.Value}
                                    GravaEntidadeLinha(ctx, tbAD, AcoesFormulario.Adicionar, Nothing)
                                Next
                            End If
                        End If
                    ElseIf boolD2 Then
                        If iqTbAD.Where(Function(f) f.IDDimensaoLinha2 IsNot Nothing And f.IDDimensaoLinha2 = IDadded).Count = 0 Then
                            Dim totalDims1 = iqTbAD.Where(Function(f) f.IDDimensaoLinha1 IsNot Nothing).Select(Function(f) f.IDDimensaoLinha1).Distinct.ToList

                            If totalDims1.Count = 0 Then
                                tbAD.IDDimensaoLinha2 = IDadded
                                GravaEntidadeLinha(ctx, tbAD, AcoesFormulario.Adicionar, Nothing)
                            ElseIf totalDims1.Count > 0 Then
                                For Each n1 In totalDims1
                                    tbAD = New tbArtigosDimensoes With {
                                        .IDArtigo = IDArt,
                                        .IDDimensaoLinha1 = n1.Value,
                                        .IDDimensaoLinha2 = IDadded}
                                    GravaEntidadeLinha(ctx, tbAD, AcoesFormulario.Adicionar, Nothing)
                                Next
                            End If
                        End If
                    End If
                Next
                '    dbContextTransaction.Commit()
                'End Using
            End If

            'APAGA ARTIGOSDIMENSOES
            Dim dims As New List(Of Long?)
            If IDsRem IsNot Nothing Then
                'SE REMOVER TODAS AS DIMS DA DIM1/2, INSERE AS OUTRAS DIMS DA DIM 2/1 NO IF ABAIXO
                Dim totalDims = iqTbAD.Where(
                    Function(f) (f.IDDimensaoLinha1 IsNot Nothing AndAlso IDsRem.Contains(f.IDDimensaoLinha1)) _
                        Or (f.IDDimensaoLinha2 IsNot Nothing AndAlso IDsRem.Contains(f.IDDimensaoLinha2))).Count

                If totalDims = iqTbAD.Count Then
                    If boolD1 Then
                        dims = iqTbAD.Select(Function(f) f.IDDimensaoLinha2).Distinct().ToList
                    ElseIf boolD2 Then
                        dims = iqTbAD.Select(Function(f) f.IDDimensaoLinha1).Distinct().ToList
                    End If
                End If

                'Using dbContextTransaction
                For Each IDRem In IDsRem
                    Dim listatbAD As List(Of tbArtigosDimensoes) = Nothing

                    If boolD1 Then
                        listatbAD = iqTbAD.Where(
                            Function(f) f.IDDimensaoLinha1 IsNot Nothing And f.IDDimensaoLinha1 = IDRem).ToList
                    ElseIf boolD2 Then
                        listatbAD = iqTbAD.Where(
                            Function(f) f.IDDimensaoLinha2 IsNot Nothing And f.IDDimensaoLinha2 = IDRem).ToList
                    End If

                    If listatbAD IsNot Nothing Then
                        For Each tbAD As tbArtigosDimensoes In listatbAD
                            Dim tbADEmp As tbArtigosDimensoesEmpresa = iqTbADE.Where(
                                Function(f) f.IDArtigosDimensoes = tbAD.ID).FirstOrDefault

                            If tbADEmp IsNot Nothing Then
                                GravaEntidadeLinha(ctx, tbADEmp, AcoesFormulario.Remover, Nothing)
                            End If
                            'tabela.Remove(tbAD)
                            GravaEntidadeLinha(ctx, tbAD, AcoesFormulario.Remover, Nothing)
                        Next
                    End If
                Next
                '    dbContextTransaction.Commit()
                'End Using
            End If

            'INSERE DIMENSAO 1 SE REMOVEU TODAS AS DIMENSOES 2
            If dims.Count > 0 AndAlso iqTbAD.Count = 0 Then
                ' Using dbContextTransaction
                For Each IDadded In IDsAdd
                    Dim tbAD As tbArtigosDimensoes = New tbArtigosDimensoes With {.IDArtigo = IDArt}

                    If boolD1 Then
                        tbAD.IDDimensaoLinha1 = IDadded
                        GravaEntidadeLinha(ctx, tbAD, AcoesFormulario.Adicionar, Nothing)
                    ElseIf boolD2 Then
                        tbAD.IDDimensaoLinha2 = IDadded
                        GravaEntidadeLinha(ctx, tbAD, AcoesFormulario.Adicionar, Nothing)
                    End If
                Next
                '    dbContextTransaction.Commit()
                'End Using
            End If

            'SE FOR A PRIMEIRA VEZ A ASSOCIAR AS DIMENSOES, COLOCA COMO VISIVEIS.
            If AdicionaAutomaticamenteVisiveis Then
                Dim listatbADE As List(Of Long) = tabela.AsNoTracking.Where(
                    Function(f) f.IDArtigo = IDArt).Select(Function(f) f.ID).ToList

                'Using dbContextTransaction
                For Each IDAD In listatbADE
                    Dim tbADE As tbArtigosDimensoesEmpresa = New tbArtigosDimensoesEmpresa With {.IDArtigosDimensoes = IDAD}
                    GravaEntidadeLinha(ctx, tbADE, AcoesFormulario.Adicionar, Nothing)
                Next
                'DbContextTransaction.Commit()
                '    End Using
            End If
            'Catch ex As Exception
            '    DbContextTransaction.Rollback()
            'End Try
        End Sub

        'METODOS DE GESTAO ARTIGOS DIMENSOES (VISIVEIS) 
        Private Sub TrataArtigosDimensoesVisiveis(strTipoDime As String, iqTbAD As IQueryable(Of tbArtigosDimensoes),
                iqTbADE As IQueryable(Of tbArtigosDimensoesEmpresa), inFiltro As ClsF3MFiltro, ctx As BD.Dinamica.Aplicacao)

            Dim boolD1 As Boolean = strTipoDime.IndexOf(CamposEspecificos.DimensaoLinha1) <> -1
            Dim boolD2 As Boolean = strTipoDime.IndexOf(CamposEspecificos.DimensaoLinha2) <> -1

            ' LISTA ADICIONADOS E REMOVIDOS
            Dim dictAux As Dictionary(Of String, String) = ClsUtilitarios.RetornaValorKeyDicionarioLinhasIDs(inFiltro, "IDsAdicionados2", String.Empty)
            ' ADICIONADOS
            Dim IDsAdd As String() = Nothing
            If dictAux IsNot Nothing Then
                IDsAdd = dictAux.Keys.ToArray
            End If
            ' REMOVIDOS
            dictAux = ClsUtilitarios.RetornaValorKeyDicionarioLinhasIDs(inFiltro, "IDsRemovidos2", String.Empty)
            Dim IDsRem As String() = Nothing
            If dictAux IsNot Nothing Then
                IDsRem = dictAux.Keys.ToArray
            End If

            'INSERE DIMS VISIVEIS
            If IDsAdd IsNot Nothing Then
                'Retorna lista de ids da dimensao contrária que estão na tabela tbArtigosDimensoesEmpresa(visiveis)
                Dim IDsDimensaoContraria As New List(Of Long?)
                If (iqTbADE.Count() > 0) Then
                    If boolD1 Then
                        IDsDimensaoContraria = iqTbAD.Where(
                            Function(f) f.IDDimensaoLinha2 IsNot Nothing And f.tbArtigosDimensoesEmpresa.Count > 0) _
                                .Select(Function(f) f.IDDimensaoLinha2).Distinct().ToList()
                    ElseIf boolD2 Then
                        IDsDimensaoContraria = iqTbAD.Where(
                            Function(f) f.IDDimensaoLinha1 IsNot Nothing And f.tbArtigosDimensoesEmpresa.Count > 0) _
                                .Select(Function(f) f.IDDimensaoLinha1).Distinct().ToList()
                    End If
                Else
                    If boolD1 Then
                        IDsDimensaoContraria = iqTbAD.Where(
                            Function(f) IDsAdd.Contains(f.IDDimensaoLinha1) And f.IDDimensaoLinha2 IsNot Nothing) _
                                .Select(Function(f) f.IDDimensaoLinha2).Distinct().ToList()
                    ElseIf boolD2 Then
                        IDsDimensaoContraria = iqTbAD.Where(
                            Function(f) IDsAdd.Contains(f.IDDimensaoLinha2) And f.IDDimensaoLinha1 IsNot Nothing) _
                                .Select(Function(f) f.IDDimensaoLinha1).Distinct().ToList()
                    End If
                End If

                For Each IDAdd In IDsAdd
                    If IDsDimensaoContraria.Count > 0 Then
                        For Each iddc In IDsDimensaoContraria
                            Dim tbAD As tbArtigosDimensoes = Nothing

                            If boolD1 Then
                                tbAD = iqTbAD.Where(Function(f) f.IDDimensaoLinha1 IsNot Nothing AndAlso f.IDDimensaoLinha1 = IDAdd AndAlso f.IDDimensaoLinha2 IsNot Nothing AndAlso f.IDDimensaoLinha2 = iddc).FirstOrDefault
                            ElseIf boolD2 Then
                                tbAD = iqTbAD.Where(Function(f) f.IDDimensaoLinha1 IsNot Nothing AndAlso f.IDDimensaoLinha1 = iddc AndAlso f.IDDimensaoLinha2 IsNot Nothing AndAlso f.IDDimensaoLinha2 = IDAdd).FirstOrDefault
                            End If

                            If tbAD IsNot Nothing Then
                                If Not iqTbADE.Any(Function(f) f.IDArtigosDimensoes = tbAD.ID) Then
                                    Dim tbADE = New tbArtigosDimensoesEmpresa With {.IDArtigosDimensoes = tbAD.ID}
                                    GravaEntidadeLinha(ctx, tbADE, AcoesFormulario.Adicionar, Nothing)
                                End If
                            End If
                        Next
                    Else
                        Dim tbAD As tbArtigosDimensoes = iqTbAD.Where(Function(f) f.IDDimensaoLinha1 = IDAdd).FirstOrDefault
                        If tbAD IsNot Nothing Then
                            If Not iqTbADE.Any(Function(f) f.IDArtigosDimensoes = tbAD.ID) Then
                                Dim tbADE = New tbArtigosDimensoesEmpresa With {.IDArtigosDimensoes = tbAD.ID}
                                GravaEntidadeLinha(ctx, tbADE, AcoesFormulario.Adicionar, Nothing)
                            End If
                        End If
                    End If
                Next
            End If

            'APAGA DIMS VISIVEIS
            If IDsRem IsNot Nothing Then
                Dim listatbAD As New List(Of tbArtigosDimensoes)
                If boolD1 Then
                    listatbAD = iqTbAD.Where(Function(f) IDsRem.Contains(f.IDDimensaoLinha1)).ToList
                ElseIf boolD2 Then
                    listatbAD = iqTbAD.Where(Function(f) IDsRem.Contains(f.IDDimensaoLinha2)).ToList
                End If

                For Each tbAD As tbArtigosDimensoes In listatbAD
                    Dim tbADEmp As tbArtigosDimensoesEmpresa = iqTbADE.Where(Function(f) f.IDArtigosDimensoes = tbAD.ID).FirstOrDefault

                    If tbADEmp IsNot Nothing Then
                        GravaEntidadeLinha(ctx, tbADEmp, AcoesFormulario.Remover, Nothing)
                    End If
                Next
            End If
        End Sub

        'METODOS DE GESTAO ARTIGOS DIMENSOES APAGA LINHAS NULAS
        Private Sub ApagaLinhasNulas(iqTbAD As IQueryable(Of tbArtigosDimensoes), iqTbADE As IQueryable(Of tbArtigosDimensoesEmpresa),
                inFiltro As ClsF3MFiltro, ctx As BD.Dinamica.Aplicacao)

            Dim listatbADNulas As IQueryable(Of tbArtigosDimensoes) = iqTbAD.Where(
                Function(f) ((f.IDDimensaoLinha1 Is Nothing Or f.IDDimensaoLinha2 Is Nothing) _
                             Or (f.IDDimensaoLinha1 Is Nothing And f.IDDimensaoLinha2 Is Nothing)))
            Dim tbADPrim As tbArtigosDimensoes = listatbADNulas.FirstOrDefault()

            If listatbADNulas.Count > 0 And listatbADNulas.Count < iqTbAD.Count Then
                For Each tbAD In listatbADNulas
                    Dim tbADE As tbArtigosDimensoesEmpresa = iqTbADE.Where(Function(f) f.IDArtigosDimensoes = tbAD.ID).FirstOrDefault
                    If tbADE IsNot Nothing Then
                        GravaEntidadeLinha(ctx, tbADE, AcoesFormulario.Remover, Nothing)
                    End If
                    GravaEntidadeLinha(ctx, tbAD, AcoesFormulario.Remover, Nothing)
                Next
            ElseIf listatbADNulas.Count = 1 AndAlso tbADPrim.IDDimensaoLinha1 Is Nothing AndAlso tbADPrim.IDDimensaoLinha2 Is Nothing Then
                Dim tbADE As tbArtigosDimensoesEmpresa = iqTbADE.Where(Function(f) f.IDArtigosDimensoes = tbADPrim.ID).FirstOrDefault
                If tbADE IsNot Nothing Then
                    GravaEntidadeLinha(ctx, tbADE, AcoesFormulario.Remover, Nothing)
                End If
                GravaEntidadeLinha(ctx, tbADPrim, AcoesFormulario.Remover, Nothing)
            End If
        End Sub

        'RETORNO DOS ACESSOS NAS AREAS DOS ARTIGOS DIMENSOES
        Public Overrides Function ObtemAcessosAreas(OpcaoMenu As Object, inFiltro As ClsF3MFiltro) As Object
            ' LISTA LOGICA MOEDA DO F3MSGPGeralEntidades
            Using rep As New F3M.Repositorios.Administracao.RepositorioMenusAreas
                Dim OpcoesMenu As ClsF3MMenus = TryCast(OpcaoMenu, ClsF3MMenus)
                Dim IDMenu As Long = OpcoesMenu.ID
                Dim lst As IQueryable(Of F3M.MenusAreas) = rep.ListaComboEspecifica(inFiltro, IDMenu)

                Dim lsitaFin = lst.Select(Function(e) New F3M.MenusAreas With {
                                            .ID = e.ID,
                                            .Descricao = e.Descricao,
                                            .DescricaoAbreviada = e.DescricaoAbreviada}).ToList

                Return lsitaFin
            End Using
        End Function
#End Region

    End Class
End Namespace