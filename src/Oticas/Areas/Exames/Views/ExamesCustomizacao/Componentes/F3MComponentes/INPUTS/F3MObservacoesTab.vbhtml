@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo

<div class="obs-holder">
    @Code
        Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = Model.ModelPropertyName,
                        .Label = Model.Label,
                        .TipoEditor = Mvc.Componentes.F3MTextArea,
                        .Modelo = Model,
                        .EEditavel = Model.EEditavel AndAlso Not Model.ECustomizacao,
                        .ControladorAccaoExtra = URLs.Areas.TabAux & F3M.Modelos.Constantes.Menus.TextosBase & "/IndexGrelha",
                        .CampoValor = "Texto"})
    End Code
</div>
