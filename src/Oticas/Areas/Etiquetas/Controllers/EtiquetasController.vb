Imports F3M
Imports F3M.Areas.Comum.Controllers
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Utilitarios
Imports F3M.Repositorio.TabelasAuxiliaresComum
Imports Oticas.Repositorio.Etiquetas

Namespace Areas.Etiquetas.Controllers
    Public Class EtiquetasController
        Inherits SimpleFormController

        Const EtiquetasViewsPath As String = "~/F3M/Areas/EtiquetasComum/Views/"

        ReadOnly _repositorioEtiquetas As RepositorioEtiquetas
        ReadOnly _repositorioMapasVistas As RepositorioMapasVistas

#Region "CONTRUTOR"
        Sub New()
            _repositorioEtiquetas = New RepositorioEtiquetas
            _repositorioMapasVistas = New RepositorioMapasVistas
        End Sub
#End Region

#Region "LEITURA"
        ''' <summary>
        ''' Função que retorna a view vazia
        ''' </summary>
        ''' <returns></returns>
        <F3MAcesso>
        Public Function Index() As ActionResult
            Return View(New Models.Etiquetas)
        End Function

        ''' <summary>
        ''' Funcao que retorna a view by model
        ''' </summary>
        ''' <param name="idDocument"></param>
        ''' <param name="docType"></param>
        ''' <returns></returns>
        <F3MAcesso>
        Public Function Modal(idDocument As Long, docType As String) As ActionResult
            Return View(_repositorioEtiquetas.RetornaEtiquetasMOD(idDocument, docType))
        End Function
#End Region

#Region "ESCRITA"
        ''' <summary>
        ''' Funcao que cria a tabela / inserere os dados na tabela temporaria e rotorna o nome para o rpt
        ''' </summary>
        ''' <param name="inModeloStr"></param>
        ''' <returns></returns>
        <F3MAcesso>
        Public Function CriaTemp(inModeloStr As String) As JsonResult
            Try
                Dim modelo As Models.Etiquetas = LZString.RetornaModeloDescomp(Of Models.Etiquetas)(inModeloStr)
                Dim modeloEA As New Models.Etiquetas
                Dim EA As Models.EtiquetasArtigos

                Dim intI As Integer = 0
                Dim intK As Integer = 0

                modeloEA.EtiquetasArtigos = New List(Of Models.EtiquetasArtigos)

                For intI = modelo.EtiquetasArtigos.Count - 1 To 0 Step -1
                    For intK = 1 To modelo.EtiquetasArtigos.Item(intI).Quantidade
                        EA = modelo.EtiquetasArtigos.Item(intI)
                        EA.Quantidade = 1
                        modeloEA.EtiquetasArtigos.Insert(0, EA)
                    Next
                Next

                If modelo.Entidade = "Etiquetas_A4_6_Colunas" Then
                    For intCiclo As Integer = 1 To ((modelo.Linha - 1) * 6) + (modelo.Coluna - 1)
                        modeloEA.EtiquetasArtigos.Insert(intCiclo - 1, New Models.EtiquetasArtigos)
                    Next

                ElseIf modelo.Entidade = "Etiquetas_A4_5_Colunas" Then
                    For intCiclo As Integer = 1 To ((modelo.Linha - 1) * 5) + (modelo.Coluna - 1)
                        modeloEA.EtiquetasArtigos.Insert(intCiclo - 1, New Models.EtiquetasArtigos)
                    Next

                ElseIf modelo.Entidade = "Etiquetas_A4_2_Colunas" Then
                    For intCiclo As Integer = 1 To ((modelo.Linha - 1) * 2) + (modelo.Coluna - 1)
                        modeloEA.EtiquetasArtigos.Insert(intCiclo - 1, New Models.EtiquetasArtigos)
                    Next
                End If

                Dim colunas As List(Of TempColumns) = RetornaColunasTabelaTemp()
                Dim IDMapaVistaPorDefeito As Long = _repositorioMapasVistas.GetDefaultMapByEntity(Of BD.Dinamica.Aplicacao, tbMapasVistas)(modelo.Entidade)


                Return RetornaJSONTamMaximo(New With {
                                            .tempTableName = ClsBaseDadosTabelasTemp.Cria_Insere_RetornaNomeTbl(Of BD.Dinamica.Aplicacao, Models.EtiquetasArtigos)(modeloEA.EtiquetasArtigos, colunas),
                                            IDMapaVistaPorDefeito})

            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function
#End Region

#Region "FUNÇÕES AUXILIARES"
        ''' <summary>
        ''' Funcao que retorna a lista de colunas para a tabela temporária
        ''' </summary>
        ''' <returns></returns>
        Private Function RetornaColunasTabelaTemp() As List(Of TempColumns)
            Dim colunas As New List(Of TempColumns)
            With colunas
                .Add(New TempColumns With {.Nome = "ID", .TipoDados = "bigint", .Null = True})
                .Add(New TempColumns With {.Nome = "TipoDoc", .TipoDados = "nvarchar(3)", .Null = True})
                .Add(New TempColumns With {.Nome = "IDDocumento", .TipoDados = "nvarchar(30)", .Null = True})
                .Add(New TempColumns With {.Nome = "CodigoArtigo", .TipoDados = "nvarchar(50)", .Null = True})
                .Add(New TempColumns With {.Nome = "CodigoBarras", .TipoDados = "nvarchar(50)", .Null = True})
                .Add(New TempColumns With {.Nome = "CodigoBarrasFornecedor", .TipoDados = "nvarchar(50)", .Null = True})
                .Add(New TempColumns With {.Nome = "ReferenciaFornecedor", .TipoDados = "bigint", .Null = True})
                .Add(New TempColumns With {.Nome = "Descricao", .TipoDados = "nvarchar(200)", .Null = True})
                .Add(New TempColumns With {.Nome = "ValorComIva", .TipoDados = "float", .Null = True})
                .Add(New TempColumns With {.Nome = "ValorComIva2", .TipoDados = "float", .Null = True})
                .Add(New TempColumns With {.Nome = "DescricaoArtigo", .TipoDados = "nvarchar(200)", .Null = True})
                .Add(New TempColumns With {.Nome = "CodigoFornecedor", .TipoDados = "nvarchar(50)", .Null = True})
                .Add(New TempColumns With {.Nome = "DescricaoMarca", .TipoDados = "nvarchar(50)", .Null = True})
                .Add(New TempColumns With {.Nome = "DescricaoModelo", .TipoDados = "nvarchar(50)", .Null = True})
                .Add(New TempColumns With {.Nome = "CodigoCor", .TipoDados = "nvarchar(50)", .Null = True})
            End With

            Return colunas
        End Function
#End Region
    End Class
End Namespace