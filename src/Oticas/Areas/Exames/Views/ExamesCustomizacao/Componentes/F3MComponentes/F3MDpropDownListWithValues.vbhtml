@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo

<div class="row form-container">
    <div class="col-xs-3 col-f3m divDropDownList alinhamentoesquerda clsF3MCampo">
        <label>Catarata</label>
        @Code
            Dim t As New Oticas.Areas.Exames.Controllers.MyInumerable
        End Code

        @Html.Kendo().DropDownList().Name("teste").DataTextField("Text").DataValueField("Value").BindTo(t.RetornaOlhos()).OptionLabel("Selecionar")
    </div>

    <div class="col-xs-3 col-f3m divDropDownList alinhamentoesquerda clsF3MCampo">
        <label>Anos</label>
        @Html.Kendo().IntegerTextBox.Name("ANOS").Max(100).Min(0).Value(0).
    </div>

</div>


