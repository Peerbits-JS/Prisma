@Imports Oticas.Areas.Communication.Models
@ModelType CommunicationSmsTemplatesGrupos

@Code
    Dim maxOrdem As Integer = 1
    Dim maxOrdemGrupos As Integer = 0
    If Model.Grupos.Any Then
        maxOrdemGrupos = Model.Grupos.Max(Function(entity) entity.Ordem)
    End If

    Dim maxOrdemRegras As Integer = Model.Regras.Max(Function(entity) entity.Ordem)
    maxOrdem = If(maxOrdemGrupos > maxOrdemRegras, maxOrdemGrupos, maxOrdemRegras)

    Dim classActiveGrupoAnd As String = If(Model.MainCondition = "AND", "active", String.Empty)
    Dim propCheckedGrupoAnd As String = If(Model.MainCondition = "AND", "active", String.Empty)

    Dim classActiveGrupoOr As String = If(Model.MainCondition = "OR", "active", String.Empty)
    Dim propCheckedGrupoOr As String = If(Model.MainCondition = "OR", "active", String.Empty)

    Dim classHidden As String = If(Model.ID <> 0, "hidden", String.Empty)
End Code

<div class="f3m-query-builder clsF3MTemplateFilters @classHidden">
    <div class="f3m-query-builder__group clsF3MQBGrupo" data-bd-id="@Model.ID">
        <div class="f3m-query-builder__header">
            <div class="f3m-query-builder__header-btn">
                @*BUTTONS E AND OU*@
                <div class="btn-holder">
                    <div class="btn-group btn-group-toggle" data-toggle="buttons">
                        <label class="btn btn-sm btn-line @classActiveGrupoAnd">
                            <input type="radio" name="options" autocomplete="off" class="clsF3MQBAnd" @propCheckedGrupoAnd>E
                        </label>
                        <label class="btn btn-sm btn-line @classActiveGrupoOr">
                            <input type="radio" name="options" autocomplete="off" class="clsF3MQBOr" @propCheckedGrupoOr>OU
                        </label>
                    </div>
                </div>
            </div>
            <div class="f3m-query-builder__header-btn float-right">
                <div class="btn-group btn-group-sm">
                    <button type="button" class="btn main-btn clsF3MQBNovaRegra" onclick="$communicationtemplate.ajax.NovaRegra(this);">Nova Regra </button>
                    <button type="button" class="btn main-btn clsF3MQBNovoGrupo" onclick="$communicationtemplate.ajax.NovoGrupo(this);">Novo Grupo</button>
                    <button type="button" class="btn main-btn clsF3MQBRemoverGrupo" onclick="$communicationtemplate.ajax.RemoverGrupo(this);">Remover Grupo</button>
                </div>
            </div>
        </div>

        <ul class="f3m-query-builder__list clsF3MQBListaRegras">
            @Code
                For index As Integer = 1 To maxOrdem
                    If Not Model.Regras Is Nothing Then
                        Dim RegraModel = Model.Regras.FirstOrDefault(Function(regra) regra.Ordem = index)
                        If Not RegraModel Is Nothing Then
                            @Html.Partial("Regra", RegraModel)
                        End If
                    End If

                    If Not Model.Grupos Is Nothing Then
                        Dim GrupoModel = Model.Grupos.FirstOrDefault(Function(regra) regra.Ordem = index)
                        If Not GrupoModel Is Nothing Then
                            @Html.Partial("Grupo", GrupoModel)
                        End If
                    End If
                Next
            End Code
        </ul>
    </div>
</div>