@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Componentes


@Scripts.Render("~/bundles/f3m/jsAreaSideBar")

@Code
    Dim viewsPath As String = "~/F3M.Core.Business.Documents/Views/PurchaseDocuments/AreaSidebar/"
    Dim viewsPathButtonsBar As String = "~/F3M.Core.Business.Documents/Views/PurchaseDocuments/Bar/ButtonsBar.cshtml"
    Dim classButtonsBar As String = " com-barra-botoes"

    If Model.AcaoFormulario = AcoesFormulario.Adicionar Then
        viewsPathButtonsBar = String.Empty
        classButtonsBar = String.Empty
    End If

    Dim AreaSideBars As New F3MAreaSideBars
    With AreaSideBars
        .URLLadoDireito = viewsPath & "SidebarRight.cshtml"
        .URLAreaGeral = "~/F3M.Core.Business.Documents/Views/PurchaseDocuments/Details.cshtml"
        .TamanhoBarraEsq = "500px"
        .ESobrepostaEsq = True
        .TamanhoBarraDir = "200px"
        .URLLadoDireitoBotoes = viewsPathButtonsBar
        .AreaGeralClasses = "junto-barra-direita com-scroll" & classButtonsBar
        .URLLadoDireitoFechado = viewsPath & "SidebarRightClosed.cshtml"
        .Modelo = Model
        .LateralDirEstado = False
        .LateralEsqEstado = False

    End With

End Code


@Html.Partial("~/F3M/Views/Partials/F3MAreaSideBars.vbhtml", AreaSideBars)