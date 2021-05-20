Imports System.Data.Entity
Imports F3M.Modelos.Autenticacao
Imports F3M.Repositorio.Recalculos

Namespace Areas.Utilitarios.Controllers
    Public Class ConsultasController
        Inherits F3M.Areas.Consultas.ConsultasController

        Public Sub New()
            MyBase.New()
        End Sub

        ''' <summary>
        ''' Funcao que retorna condicoes /// parametros /// se existem artigos marcados
        ''' </summary>
        ''' <param name="IDLista"></param>
        ''' <returns></returns>
        <F3MAcesso>
        Public Overrides Function RetornaViewParametros_DSCondicoes(IDLista As Long) As JsonResult
            'my base
            Dim myBaseResult As JsonResult = MyBase.RetornaViewParametros_DSCondicoes(IDLista)
            'get context
            Dim ctx As DbContext = Activator.CreateInstance(Of BD.Dinamica.Aplicacao)
            'verifica se a lista personalizada e do tipo inventariodata
            Dim boolTemArtigosMarcados As Boolean = False
            If myBaseResult.Data.DSCondicoes.TabelaPrincipal = "inventariodata" Then
                'verifica se tem exsitem artigos marcados para recalculo de stocks
                boolTemArtigosMarcados = RepositorioRecalculos.VerificaSeTemArtigosMarcados(ctx)
            End If
            'return new json result with DSCondicoes /// ViewParametros /// boolTemArtigosMarcados
            Return RetornaJSONTamMaximo(New With {
                                        .DSCondicoes = myBaseResult.Data.DSCondicoes,
                                        .ViewParametros = myBaseResult.Data.ViewParametros,
                                        .boolTemArtigosMarcados = boolTemArtigosMarcados})
        End Function
    End Class
End Namespace