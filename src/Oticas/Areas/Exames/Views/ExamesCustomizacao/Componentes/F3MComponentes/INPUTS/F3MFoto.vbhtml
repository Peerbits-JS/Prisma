@Imports F3M.Modelos.Constantes

@Code
    Dim calcXS As Integer = Model.EndCol - Model.StartCol + 1
    If Model.EElementoGridLinhas Then calcXS = 12
End Code

<div class="col-f3m col-@calcXS text-center">
    @Html.Partial(URLs.PartialFotosIndex, Model)
</div>  