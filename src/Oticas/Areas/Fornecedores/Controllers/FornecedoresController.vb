Imports Oticas.Repositorio
Imports F3M.Areas.Fornecedores.Controllers
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Comunicacao

Namespace Areas.Fornecedores.Controllers
    Public Class FornecedoresController
        Inherits FornecedoresController(Of Oticas.BD.Dinamica.Aplicacao, tbFornecedores, Oticas.Fornecedores)

#Region "REPOSITORIO"
        Sub New()
            MyBase.New(New RepositorioFornecedores())
        End Sub
#End Region

#Region "ACOES DEFAULT GET CRUD"
        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        Public Overrides Function Adiciona(Optional CampoValorPorDefeito As String = "", Optional ByVal IDVista As Long = 0) As ActionResult
            Dim ObjectReturn As ActionResult = MyBase.Adiciona(CampoValorPorDefeito, IDVista)

            With DirectCast(DirectCast(ObjectReturn, PartialViewResult).Model, Oticas.Fornecedores)
                .IDTipoEntidade = 4 : .DescricaoTipoEntidade = "Fornecedores"

                .IDFormaPagamento = 1 : .DescricaoFormaPagamento = "NUMERÁRIO"

                .IDCondicaoPagamento = 1 : .DescricaoCondicaoPagamento = "A PRONTO"

                .IDMoeda = 1 : .DescricaoMoeda = "Euro"

                .IDIdioma = 2 : .DescricaoIdioma = "PORTUGUÊS"

                .IDEspacoFiscal = 1 : .DescricaoEspacoFiscal = "Nacional"

                .IDRegimeIva = 1 : .DescricaoRegimeIva = "Normal"

                .IDLocalOperacao = 1 : .DescricaoLocalOperacao = "Continente"

                .NContribuinte = "999999990"

                If ClsF3MSessao.RetornaParametros.Lojas.IDPais IsNot Nothing Then
                    .IDPais = ClsF3MSessao.RetornaParametros.Lojas.IDPais
                    .DescricaoPais = ClsF3MSessao.RetornaParametros.Lojas.DescricaoPais

                Else
                    .IDPais = 184 : .DescricaoPais = "Portugal"
                End If

                Using rp As New RepositorioFornecedores
                    .Codigo = rp.AtribuirCodigo
                End Using
            End With

            Return ObjectReturn
        End Function

        <F3MAcesso(Acao:=AcoesFormulario.Adicionar)>
        Public Overrides Function AdicionaF4(TabID As String, CampoClicadoID As String, Optional OrigemAdicionaF4 As String = "", Optional ByVal IDDuplica As Long = 0) As ActionResult
            MyBase.AdicionaF4(TabID, CampoClicadoID, OrigemAdicionaF4, IDDuplica)

            Return Me.Adiciona()
        End Function

        'TODO - ActionResult?!
        <F3MAcesso>
        Public Function ProximoCodigo(Optional inObjFiltro As ClsF3MFiltro = Nothing) As ActionResult
            Dim strCodigo As String = String.Empty

            Using rp As New RepositorioFornecedores
                strCodigo = rp.AtribuirCodigo
            End Using

            Return Content(strCodigo)
        End Function
#End Region
    End Class
End Namespace
