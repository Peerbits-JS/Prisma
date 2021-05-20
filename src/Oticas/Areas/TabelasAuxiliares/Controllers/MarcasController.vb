Imports Kendo.Mvc.UI
Imports F3M.Modelos.Constantes
Imports Oticas.Repositorio.TabelasAuxiliares
Imports Oticas.Modelos.Constantes
Imports F3M.Areas.TabelasAuxiliares.Controllers
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports System.IO
Imports F3M.Modelos.Utilitarios
Imports F3M.Modelos.ConstantesKendo

Namespace Areas.TabelasAuxiliares.Controllers
    Public Class MarcasController
        Inherits MarcasController(Of Oticas.BD.Dinamica.Aplicacao, tbMarcas, Marcas)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioMarcas())
        End Sub
#End Region

#Region "LEITURA"

#End Region

#Region "ESCRITA"

        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        Public Function Importa(<DataSourceRequest> request As DataSourceRequest, <Bind> ByVal modelo As F3M.Importacao, filtro As ClsF3MFiltro) As JsonResult
            Try
                Dim rep As New RepositorioMarcas
                modelo = rep.Importar(modelo)
                modelo.strFicheiro = String.Empty
                Return Json(New With {.DadosObjeto = modelo})
            Catch ex As F3M.Modelos.Excepcoes.Tipo.ClsExF3MValidacao
                Return Json(New With {.Erros = ex.Message, .DadosObjeto = modelo})
            Catch ex As Exception

                'Dim listaRMSC As New List(Of ClsF3MRespostaMensagemServidorCliente)
                'listaRMSC.Add(New ClsF3MRespostaMensagemServidorCliente() With {
                '                .Tipo = TipoAlerta.Informacao,
                '                .Mensagem = ex.Message})

                Return RetornaJSONTamMaximo(New With {.Erros = ex.Message, .DadosObjeto = modelo})
            End Try
        End Function
#End Region

#Region "FUNCOES AUXILIARES"

        Public Function ProximoCodigo(Optional inObjFiltro As ClsF3MFiltro = Nothing) As ActionResult
            Dim strCodigo As String = String.Empty

            Using rp As New RepositorioMarcas
                strCodigo = rp.ProximoCodigo
            End Using

            Return Content(strCodigo)
        End Function

#End Region

    End Class
End Namespace
