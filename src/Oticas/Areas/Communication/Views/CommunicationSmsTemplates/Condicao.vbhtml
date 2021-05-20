@Imports F3M.Modelos.Constantes
@Imports Oticas.Areas.Communication.Models
@ModelType List(Of CommunicationSmsTemplatesCondicoes)

@Code
    Dim disabled As String = String.Empty
    If Model.Count = 1 Then disabled = " disabled "
End Code
<div class="f3m-query-builder__connector"></div>
<div class="d-inline-block">
    <select class="form-control clsF3MQBInputCondicao" @disabled onchange="$communicationtemplate.ajax.ChangeCondicao(this)">
        @Code
            @If Model.Count > 1 Then
                @<option data-id="0">Selecionar</option>
            End If

            @For Each condicao As CommunicationSmsTemplatesCondicoes In Model
                Dim selected As String = If(condicao.ID = condicao.IDCondicaoSelected, "selected", String.Empty)

                @<option data-id="@condicao.ID" @selected>@condicao.Descricao</option>
            Next
        End Code
    </select>
</div>