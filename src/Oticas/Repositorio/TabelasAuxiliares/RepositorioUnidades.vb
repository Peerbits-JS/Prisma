Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioUnidades
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbUnidades, Unidades)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbUnidades)) As IQueryable(Of Unidades)
            Return query.Select(Function(e) New Unidades With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao, .NumeroDeCasasDecimais = e.NumeroDeCasasDecimais,
                .Sistema = e.Sistema, .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .PorDefeito = e.PorDefeito,
                .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbUnidades)) As IQueryable(Of Unidades)
            Return query.Select(Function(e) New Unidades With {
                .ID = e.ID, .Descricao = e.Descricao, .Codigo = e.Codigo,
                .NumeroDeCasasDecimais = e.NumeroDeCasasDecimais,
                .PorDefeito = e.PorDefeito
            }).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of Unidades)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of Unidades)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA QUERY
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbUnidades)
            Dim query As IQueryable(Of tbUnidades) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto
            ' --- ESPECIFICO ---
            ' Se o filtro do artigo existe, vamos carregar apenas as unidades associadas às dos artigos
            Dim IDArtigo As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDArtigo, GetType(Long))
            If IDArtigo > 0 Then
                Dim strUnidade As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "TipoUnidade", GetType(String))
                query = FiltraUnidValidasArtigo(IDArtigo, strUnidade)
            End If
            ' --- GENERICO ---
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))
            End If
            AplicaFiltroAtivo(inFiltro, query)
            Return query
        End Function

        ''' <summary>
        '''  Filtra Query por Codigo
        ''' </summary>
        ''' <param name="inFiltro"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Protected Function FiltraQueryCodigo(inFiltro As ClsF3MFiltro) As IQueryable(Of tbUnidades)
            Dim query As IQueryable(Of tbUnidades) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto
            ' --- ESPECIFICO ---
            ' Se o filtro do artigo existe, vamos carregar apenas as unidades associadas às dos artigos
            Dim IDArtigo As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDArtigo, GetType(Long))
            If IDArtigo > 0 Then
                Dim strUnidade As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "TipoUnidade", GetType(String))
                query = FiltraUnidValidasArtigo(IDArtigo, strUnidade)
            End If
            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.Codigo.Contains(filtroTxt))
            End If
            AplicaFiltrosEOrdenacoesDasVistas(inFiltro, query)
            Return query.OrderBy(Function(o) o.Descricao)
        End Function

        ' LISTA COMBO
        Public Function ListaComboCodigo(inFiltro As ClsF3MFiltro) As IQueryable(Of Oticas.Unidades)
            Dim listaUni As List(Of Oticas.Unidades) = ListaCamposCombo(FiltraQueryCodigo(inFiltro)).ToList
            Return listaUni.AsQueryable
        End Function

        Private Function FiltraUnidValidasArtigo(inIDArtigo As Long, inTipoUnidade As String) As IQueryable(Of tbUnidades)
            Dim query As IQueryable(Of tbUnidades) = tabela.AsNoTracking
            Dim IDUnidade As Long
            Using ctx As New BD.Dinamica.Aplicacao
                ' 1º carrego a identificação das unidades
                Dim lstUnidArt = ctx.tbArtigos.AsNoTracking.Where(Function(f) f.ID = inIDArtigo).
                    Select(Function(f) New Oticas.Artigos With {.IDUnidade = f.IDUnidade,
                                                                    .IDUnidadeStock2 = f.IDUnidadeStock2,
                                                                    .IDUnidadeCompra = f.IDUnidadeCompra,
                                                                    .IDUnidadeVenda = f.IDUnidadeVenda,
                                                                    .UnidStkConvVariavel = f.tbTiposArtigos.StkUnidade1,
                                                                    .Controla2UnidStk = f.tbTiposArtigos.StkUnidade2}).FirstOrDefault
                ' Se o tipo de artigo do artigo tem 1ª unidade com conversão variável, todas as unidades deverão ser mostradas
                ' caso contrário apenas as unidades com relação são consideradas
                If lstUnidArt.UnidStkConvVariavel = False Then
                    Select Case inTipoUnidade
                        Case "Stock"
                            IDUnidade = lstUnidArt.IDUnidade
                        Case "Compra"
                            IDUnidade = lstUnidArt.IDUnidadeCompra
                        Case "Venda"
                            IDUnidade = lstUnidArt.IDUnidadeVenda
                        Case "Stock2"
                            IDUnidade = lstUnidArt.IDUnidadeStock2
                    End Select
                    ' 2º carregar a unidade principal
                    Dim listaU As List(Of Unidades) = ctx.tbUnidades.AsNoTracking.Where(Function(f) f.ID = IDUnidade).
                        Select(Function(f) New Oticas.Unidades With {.ID = f.ID}).ToList
                    Dim lstUn As List(Of Long) = listaU.Select(Function(f) f.ID).Distinct.ToList
                    ' 3º carregar as unidades do lado esquerdo com conversão na ficha do artigo
                    Dim listaAUEsq As List(Of ArtigosUnidades) = ctx.tbArtigosUnidades.AsNoTracking.Where(Function(f) f.IDUnidade = IDUnidade And f.IDArtigo = inIDArtigo And f.Ativo = True).
                        Select(Function(f) New Oticas.ArtigosUnidades With {.IDUnidadeConversao = f.IDUnidadeConversao}).ToList
                    Dim listaArtUniEsq As List(Of Long?) = listaAUEsq.Select(Function(f) f.IDUnidadeConversao).Distinct.ToList
                    ' 4º carregar as unidades do lado direito com conversão na ficha do artigo
                    Dim listaAUDir As List(Of ArtigosUnidades) = ctx.tbArtigosUnidades.AsNoTracking.Where(Function(f) f.IDUnidadeConversao = IDUnidade And f.IDArtigo = inIDArtigo And f.Ativo = True).
                        Select(Function(f) New Oticas.ArtigosUnidades With {.IDUnidade = f.IDUnidade}).ToList
                    Dim listaArtUniDir As List(Of Long) = listaAUDir.Select(Function(f) f.IDUnidade).Distinct.ToList
                    ' 5º carregar as unidades do lado esquerdo com conversão na lista geral (relações unidades)
                    Dim listaUREsq As List(Of UnidadesRelacoes) = ctx.tbUnidadesRelacoes.AsNoTracking.Where(Function(f) f.IDUnidade = IDUnidade And f.Ativo = True).
                        Select(Function(f) New Oticas.UnidadesRelacoes With {.IDUnidadeConversao = f.IDUnidadeConversao}).ToList
                    Dim listaUniRelEsq As List(Of Long?) = listaUREsq.Select(Function(f) f.IDUnidadeConversao).Distinct.ToList
                    ' 6º carregar as unidades do lado esquerdo com conversão na lista geral (relações unidades)
                    Dim listaURDir As List(Of UnidadesRelacoes) = ctx.tbUnidadesRelacoes.AsNoTracking.Where(Function(f) f.IDUnidadeConversao = IDUnidade And f.Ativo = True).
                        Select(Function(f) New Oticas.UnidadesRelacoes With {.IDUnidade = f.IDUnidade}).ToList
                    Dim listaUniRelDir As List(Of Long?) = listaURDir.Select(Function(f) f.IDUnidade).Distinct.ToList
                    ' 7º carregar a query com a lista de id´s válidos
                    Dim numIDs = listaArtUniEsq.Count + listaArtUniDir.Count + listaUniRelEsq.Count + listaUniRelDir.Count
                    If numIDs > 0 Then
                        ' Se encontrou relações inclui a própria unidade do artigo
                        query = query.Where(Function(w) lstUn.Contains(w.ID) Or listaArtUniEsq.Contains(w.ID) Or listaArtUniDir.Contains(w.ID) Or listaUniRelEsq.Contains(w.ID) Or listaUniRelDir.Contains(w.ID))
                    Else
                        If lstUnidArt.Controla2UnidStk = False Then
                            query = query.Where(Function(w) lstUn.Contains(w.ID))
                        Else
                            ' Se NÃO encontrou relações exclui a unidade do artigo para não apresentar registos
                            query = query.Where(Function(w) listaArtUniEsq.Contains(w.ID) Or listaArtUniDir.Contains(w.ID) Or listaUniRelEsq.Contains(w.ID) Or listaUniRelDir.Contains(w.ID))
                        End If
                    End If
                End If
            End Using
            Return query
        End Function

        Public Function ArtigoUnidadeComRelacoes(inIDArtigo As Long, inIDUnidade As Long) As Boolean
            Dim query As IQueryable(Of tbUnidades) = tabela.AsNoTracking
            Using ctx As New BD.Dinamica.Aplicacao

                ' 1º verifico se há relações nas unidades do artigo do lado esquerdo
                Dim listaAUEsq As List(Of ArtigosUnidades) = ctx.tbArtigosUnidades.AsNoTracking.Where(Function(f) f.IDUnidade = inIDUnidade And f.IDArtigo = inIDArtigo And f.Ativo = True).
                    Select(Function(f) New Oticas.ArtigosUnidades With {.IDUnidadeConversao = f.IDUnidadeConversao}).ToList
                Dim listaArtUniEsq As List(Of Long?) = listaAUEsq.Select(Function(f) f.IDUnidadeConversao).Distinct.ToList
                If listaArtUniEsq.Count > 0 Then
                    Return True
                End If
                ' 2º verifico se há relações nas unidades do artigo do lado direito
                Dim listaAUDir As List(Of ArtigosUnidades) = ctx.tbArtigosUnidades.AsNoTracking.Where(Function(f) f.IDUnidadeConversao = inIDUnidade And f.IDArtigo = inIDArtigo And f.Ativo = True).
                    Select(Function(f) New Oticas.ArtigosUnidades With {.IDUnidade = f.IDUnidade}).ToList
                Dim listaArtUniDir As List(Of Long) = listaAUDir.Select(Function(f) f.IDUnidade).Distinct.ToList
                If listaArtUniDir.Count > 0 Then
                    Return True
                End If
                ' 3º verifico se há relações nas unidades da lista geral do lado esquerdo (relações unidades)
                Dim listaUREsq As List(Of UnidadesRelacoes) = ctx.tbUnidadesRelacoes.AsNoTracking.Where(Function(f) f.IDUnidade = inIDUnidade And f.Ativo = True).
                    Select(Function(f) New Oticas.UnidadesRelacoes With {.IDUnidadeConversao = f.IDUnidadeConversao}).ToList
                Dim listaUniRelEsq As List(Of Long?) = listaUREsq.Select(Function(f) f.IDUnidadeConversao).Distinct.ToList
                If listaUniRelEsq.Count > 0 Then
                    Return True
                End If
                ' 4º verifico se há relações nas unidades da lista geral do lado direito (relações unidades)
                Dim listaURDir As List(Of UnidadesRelacoes) = ctx.tbUnidadesRelacoes.AsNoTracking.Where(Function(f) f.IDUnidadeConversao = inIDUnidade And f.Ativo = True).
                    Select(Function(f) New Oticas.UnidadesRelacoes With {.IDUnidade = f.IDUnidade}).ToList
                Dim listaUniRelDir As List(Of Long?) = listaURDir.Select(Function(f) f.IDUnidade).Distinct.ToList
                If listaUniRelDir.Count > 0 Then
                    Return True
                End If
            End Using
            Return False
        End Function

        Public Function CarregaCasasDecimaisUnidade(inIDUnidade As Long) As Integer
            Using ctx As New BD.Dinamica.Aplicacao
                Dim lstUnid = ctx.tbUnidades.AsNoTracking.Where(Function(a) a.ID = inIDUnidade).
                    Select(Function(a) New Oticas.Unidades With {.NumeroDeCasasDecimais = a.NumeroDeCasasDecimais}).FirstOrDefault()
                If Not lstUnid Is Nothing Then
                    Return lstUnid.NumeroDeCasasDecimais
                End If
            End Using
            Return 0
        End Function

        Public Function CarregaFatorArtigoUnidade(inIDArtigo As Long, inIDUnidadeLinha As Long, inIDUnidadeRelacionada As Long) As Hashtable
            Dim objFator As New Hashtable()
            If inIDUnidadeLinha = inIDUnidadeRelacionada Then
                objFator.Add("Operacao", "Multiplica")
                objFator.Add("Fator", 1.0)
            Else
                objFator.Add("Operacao", "Multiplica")
                objFator.Add("Fator", 0.0)
            End If
            Using ctx As New BD.Dinamica.Aplicacao
                ' ARTIGOS UNIDADES
                ' 1º carrego o fator nas relações nas unidades do artigo do lado esquerdo
                Dim listaAUEsq = ctx.tbArtigosUnidades.AsNoTracking.Where(Function(f) f.IDArtigo = inIDArtigo And f.IDUnidade = inIDUnidadeLinha And f.IDUnidadeConversao = inIDUnidadeRelacionada And f.Ativo = True).
                    Select(Function(f) New Oticas.ArtigosUnidades With {.FatorConversao = f.FatorConversao}).FirstOrDefault
                If Not listaAUEsq Is Nothing Then
                    If listaAUEsq.FatorConversao <> 0 Then
                        objFator.Item("Operacao") = "Multiplica"
                        objFator.Item("Fator") = listaAUEsq.FatorConversao
                        Return objFator
                    End If
                End If
                ' 2º carrego o fator nas relações nas unidades do artigo do lado direito
                Dim listaAUDir = ctx.tbArtigosUnidades.AsNoTracking.Where(Function(f) f.IDArtigo = inIDArtigo And f.IDUnidade = inIDUnidadeRelacionada And f.IDUnidadeConversao = inIDUnidadeLinha And f.Ativo = True).
                    Select(Function(f) New Oticas.ArtigosUnidades With {.FatorConversao = f.FatorConversao}).FirstOrDefault
                If Not listaAUDir Is Nothing Then
                    If listaAUDir.FatorConversao <> 0 Then
                        objFator.Item("Operacao") = "Divide"
                        objFator.Item("Fator") = listaAUDir.FatorConversao
                        Return objFator
                    End If
                End If
                ' RELAÇÕES UNIDADES
                ' 3º carrego o fator nas relações das unidades da lista geral do lado esquerdo (relações unidades)
                Dim listaUREsq = ctx.tbUnidadesRelacoes.AsNoTracking.Where(Function(f) f.IDUnidade = inIDUnidadeLinha And f.IDUnidadeConversao = inIDUnidadeRelacionada And f.Ativo = True).
                    Select(Function(f) New Oticas.UnidadesRelacoes With {.FatorConversao = f.FatorConversao}).FirstOrDefault
                If Not listaUREsq Is Nothing Then
                    If listaUREsq.FatorConversao <> 0 Then
                        objFator.Item("Operacao") = "Multiplica"
                        objFator.Item("Fator") = listaUREsq.FatorConversao
                        Return objFator
                    End If
                End If
                ' 4º carrego o fator nas relações das unidades da lista geral do lado direito (relações unidades)
                Dim listaURDir = ctx.tbUnidadesRelacoes.AsNoTracking.Where(Function(f) f.IDUnidade = inIDUnidadeRelacionada And f.IDUnidadeConversao = inIDUnidadeLinha And f.Ativo = True).
                    Select(Function(f) New Oticas.UnidadesRelacoes With {.FatorConversao = f.FatorConversao}).FirstOrDefault
                If Not listaURDir Is Nothing Then
                    If listaURDir.FatorConversao <> 0 Then
                        objFator.Item("Operacao") = "Divide"
                        objFator.Item("Fator") = listaURDir.FatorConversao
                        Return objFator
                    End If
                End If
            End Using
            Return objFator
        End Function

#End Region

#Region "ESCRITA"
#End Region

#Region "FUNÇÕES AUXILIARES"
        ''' <summary>
        ''' Funcao que retorna a unidade que esta definida por defeito
        ''' </summary>
        ''' <returns></returns>
        Public Function GetUnidadePorDefeito() As Unidades
            Return (From x In BDContexto.tbUnidades Where x.PorDefeito Select New Unidades With {.ID = x.ID, .Descricao = x.Descricao}).FirstOrDefault()
        End Function
#End Region
    End Class
End Namespace