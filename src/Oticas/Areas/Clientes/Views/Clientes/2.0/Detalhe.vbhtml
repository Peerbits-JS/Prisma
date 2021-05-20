@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@ModelType Oticas.Clientes
@Scripts.Render("~/bundles/f3m/jsFormularioClientes")
@Code
    Dim atrHTML As New Dictionary(Of String, Object) From {{"class", CssClasses.InputF3M}}
    Dim AcaoForm As AcoesFormulario = Model.AcaoFormulario
    ViewBag.VistaParcial = True '?!
    'U R L S     -    C O M U M      E     E S P E C I F I C O
    Dim URLClientesComum As String = "~/F3M/Areas/ClientesComum/Views/2.0/"
    Dim URLClientesEsp As String = "~/Areas/Clientes/Views/Clientes/2.0/"

    'H I D D E N S
    Html.F3M().Hidden("Versao", 2, atrHTML)
End Code
<div class="@(ClassesCSS.FormPrinc) @(If(AcaoForm <> AcoesFormulario.Adicionar, ClassesCSS.ComBts, String.Empty))">
    <div class="FormularioAjudaScroll">
        <div class="container-fluid">
            @Html.Partial(URLClientesComum & "Cabecalho/Cabecalho.vbhtml", Model)
            <div role="tabpanel" class="f3m-tabs clsF3MTabs">
                <ul class="nav nav-pills f3m-tabs__ul clsAreaFixed" role="tablist">
                    @Html.Partial(URLClientesComum & "Tabs/Tabs.vbhtml")
                </ul>
                <div class="tab-content">
                    @Html.Action(URLs.HistComumIndex, Menus.Historicos, New With {.Area = Menus.Historicos, .inModelo = Model})

                    @Html.Partial(URLClientesComum & "Tabs/TabDadosPessoais.vbhtml", New With {
                   .Modelo = Model,
                   .URLMedicosEntidades = URLClientesEsp & "MedicosEntidades.vbhtml"})

                    @Html.Partial(URLClientesComum & "Tabs/TabDefComerciaisFiscais.vbhtml", New With {.Modelo = Model})

                    @Html.Partial(URLClientesComum & "Tabs/TabObservacoes.vbhtml", Model)
                </div>
            </div>
        </div>
    </div>
</div>

@Html.Partial(URLClientesEsp & "BarraBotoes.vbhtml", Model)

@Code
    If Not String.IsNullOrEmpty(Model.Avisos) Then
        @<script>ClientesEspNotificaAviso("@Model.Avisos.Replace(vbCr, " ").Replace(vbLf, " ")");</script>
    End If
End Code