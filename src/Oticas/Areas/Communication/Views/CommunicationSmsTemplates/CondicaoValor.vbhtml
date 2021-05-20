@Imports F3M.Modelos.Constantes
@Imports Oticas.Areas.Communication.Models
@Modeltype CommunicationSmsTemplatesRegras

<div class="d-inline-block clsF3MQBCondicaoValor">
    @If Model.IDFiltro <> 0 Then
        @<div class="d-inline-block clsF3MQBCondicao">
            @Html.Partial("Condicao", Model.Condicoes)
        </div>

        @<div class="d-inline-block clsF3MQBValor">
            @If not Model.Valores Is Nothing Then
                @Html.Partial("Valor", Model.Valores)
            End If
        </div>
    End If
</div>