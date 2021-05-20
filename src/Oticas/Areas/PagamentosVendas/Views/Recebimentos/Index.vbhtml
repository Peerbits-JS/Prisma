@Imports F3M.Modelos.Constantes
@Code
    Dim ListOfPagamentosVendas As List(Of PagamentosVendas) = ViewBag.ListOfPagamentos
End Code

<div class="clearfix">
    <div class="list-group list-group-horizontal">
        @Code
            If ListOfPagamentosVendas IsNot Nothing Then
                For Each lin In ListOfPagamentosVendas
                    @<a id="@lin.ID" class="list-group-item Pagamentos" title="@lin.Data">@lin.Documento</a>
                Next
            End If
        End Code
    </div>
</div>