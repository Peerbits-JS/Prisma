@Imports F3M.Modelos.Constantes
@Imports Oticas.Areas.Communication.Models
@ModelType CommunicationSmsTemplatesRegras

<li type="row" class="f3m-query-builder__list-rule">
    <div class="w-100 clsF3MQBRegra">
        <div class="d-inline-block">
            <select class="form-control clsF3MQBFiltro" onchange="$communicationtemplate.ajax.ChangeFiltro(this)";>
                <option data-id=0>Selecionar</option>
                @Code
                    For Each filtro As CommunicationSmsTemplatesFiltros In Model.Filtros
                        Dim selected As String = If(filtro.ID = Model.IDFiltro, "selected", String.Empty)
                        @<option data-id=@filtro.ID
                                 data-codigo="@filtro.Codigo" @selected>
                            @filtro.Descricao
                        </option>
                    Next
                End Code
            </select>
        </div>
      @Html.Partial("CondicaoValor", Model)
        <div class="float-right mt-2">
            <a class="f3mlink clsF3MQBRemoverRegra" onclick="$communicationtemplate.ajax.RemoverRegra(this);">
                <span class="fm f3icon-times-square"></span>
            </a>
        </div>
    </div>
</li>
