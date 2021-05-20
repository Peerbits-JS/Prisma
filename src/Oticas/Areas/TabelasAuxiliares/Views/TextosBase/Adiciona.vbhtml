@ModelType TextosBase

@Using (Html.BeginForm()) 
    @Html.AntiForgeryToken()
    @Html.ValidationSummary(True, "", New With {.class = "text-danger"})
    
    @<div class="form-horizontal">
        @Html.Partial("Detalhe", Model)
    </div>
End Using

