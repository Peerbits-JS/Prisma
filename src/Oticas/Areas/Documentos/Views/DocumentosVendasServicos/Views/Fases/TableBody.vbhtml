@Modeltype Oticas.ServicosFases

@Code
    @<tbody>
        @If Model.Fases.Count = 0 Then
            @<tr>
                <td colspan="5">
                    <i>Não existem estados de serviço definidos.</i>
                </td>
            </tr>
        Else
            @For Each fase As Oticas.DocumentosVendasServicosFases In Model.Fases
                Dim id As String = fase.IDServico & "_" & fase.IDTipoServico & "_" & fase.IDTipoFase & "_" & fase.ID

                Dim dataTitle As String = "Clique para editar"
                If Not String.IsNullOrEmpty(fase.Observacoes) Then dataTitle = fase.Observacoes

                @<tr id="tr_@id">
                     <td>
                         <div class="custom-control custom-checkbox f3m-checkbox f3m-checkbox-sem-top">
                             <input onclick="$servicosfases.ajax.stateChange(this);"  type="checkbox" class="clsF3MCheckbox custom-control-input f3m-checkbox__input" id="cbx_@(id)" checked="@(fase.IsChecked)" >
                             <label class="custom-control-label f3m-checkbox__valida" for="cbx_@(id)"></label>
                         </div>
                         @*<div class="checkbox">
                            <label class="checkbox-label">
                                <input onclick="$servicosfases.ajax.stateChange(this);" class="clsF3MCheckbox hidden" id="cbx_@(id)" type="checkbox" checked="@(fase.IsChecked)" />
                                <span class="checkbox-custom cbx-valida"></span>
                            </label>
                        </div>*@
                     </td>
                    <td>@fase.DescricaoTiposFases</td>
                    <td id="date_@(id)">@fase.Data</td>
                    <td id="user_@(id)">@fase.UtilizadorEstado</td>
                    <td onclick="$servicosfases.ajax.notesOnClick(this);" data-toggle="tooltip" data-container="body" data-title="@(dataTitle)">
                        <span>@fase.Observacoes</span>
                        <input id="obs_@(id)"
                               class="k-textbox"
                               type="text"
                               maxlength="100"
                               style="display: none"
                               autocomplete="none"
                               onchange="$servicosfases.ajax.notesOnChange(this);"
                               onfocusout="$servicosfases.ajax.notesOnFocusOut(this);"
                               value="@fase.Observacoes">
                    </td>
                </tr>
            Next
        End If
    </tbody>
End Code