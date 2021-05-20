@Imports F3M.Modelos.Constantes
@Modeltype Oticas.Components

@Code
    'SET VALUE
    Dim Valor As String = Model.ValorID
    If Model.AcaoFormulario = AcoesFormulario.Adicionar Then Valor = Model.ValorPorDefeito

    'set steps
    Dim steps As String = Model.Steps
    If String.IsNullOrEmpty(steps) Then steps = "1"
    steps = steps.Replace(",", ".")

End Code

<div class="input-group input-group-lg" data-f3mdbid="@Model.F3MBDID">
    <span class="input-group-btn">
        <button class="btn f3m-btn-outline-secondary btnDown mr-n01" type="button" tabindex="-1" f3m-numeric="@Model.ModelPropertyName">
            <span class="fm f3icon-angle-down"></span>
        </button>
    </span>

    <input id="@Model.ModelPropertyName"
           name="@Model.ModelPropertyName"
           type="number"
           step="@steps"
           max="@Model.ValorMaximo"
           min="@Model.ValorMinimo"
           class="form-control @CssClasses.InputF3M clsF3MCampo clsF3MGroupNum"
           value="@Valor"
           f3m-decimalplaces="@Model.NumCasasDecimais"   
           f3m-datatype="@Model.ModelPropertyType"
           f3m-defaultvalue="@Model.ValorPorDefeito">

    <span class="input-group-btn">
        <button class="btn f3m-btn-outline-secondary btnUp ml-n01" type="button" tabindex="-1" f3m-numeric="@Model.ModelPropertyName">
            <span class="fm f3icon-angle-up"></span>
        </button>
    </span>
</div>