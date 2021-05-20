Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes
Imports F3M.Modelos.Comunicacao

Imports F3M.Areas.TabelasAuxiliares.Controllers
Imports F3M.Modelos.Autenticacao

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class CodigosPostaisController
        Inherits CodigosPostaisController(Of Oticas.BD.Dinamica.Aplicacao, tbCodigosPostais, CodigosPostais)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioCodigosPostais())
        End Sub
#End Region

#Region "ACOES DE LEITURA"
        ' LEITURA PARA A COMBO/DDL
        Public Function ListaComboCodigo(<DataSourceRequest> request As DataSourceRequest, inObjFiltro As ClsF3MFiltro) As JsonResult
            Try
                Dim result As IQueryable(Of CodigosPostais) = Nothing

                Using rep As New RepositorioCodigosPostais
                    result = rep.ListaComboCodigo(inObjFiltro)
                End Using

                Return Json(result, JsonRequestBehavior.AllowGet)
            Catch ex As Exception
                Return RetornaJSONErrorsTamMaximo(ex)
            End Try
        End Function
#End Region

#Region "ESCRITA"
        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        Public Function Importa(<DataSourceRequest> request As DataSourceRequest, <Bind> ByVal modelo As F3M.Importacao, filtro As ClsF3MFiltro) As JsonResult
            Try
                Dim rep As New Repositorio.RepositorioClientes
                modelo = rep.Importar(modelo)
                modelo.strFicheiro = String.Empty
                Return Json(New With {.DadosObjeto = modelo})
            Catch ex As F3M.Modelos.Excepcoes.Tipo.ClsExF3MValidacao
                Return Json(New With {.Erros = ex.Message, .DadosObjeto = modelo})
            Catch ex As Exception
                Return Json(New With {.Erros = ex.Message, .DadosObjeto = modelo})
            End Try
        End Function
#End Region

    End Class
End Namespace
