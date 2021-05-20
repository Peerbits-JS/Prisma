@Imports F3M.Modelos.Constantes
@Imports Oticas.Areas.Communication.Models
@Modeltype List(Of CommunicationSmsTemplatesValores)

@Code
    @<div class="f3m-query-builder__connector"></div>
    @For Each v In Model
        @<div class="d-inline-block">
    @Select Case v.TipoComponente
        Case "checkbox"
            Dim isChecked As String = If(v.Valor Is Nothing OrElse v.Valor = "1", "checked", String.Empty)

            @<div class="f3m-checkbox-sem-top">
                <div class="custom-control custom-checkbox f3m-checkbox">
                    <input type="checkbox"
                           id="@v.IDSistemaComunicacaoSmsTemplatesValores"
                           name="@v.IDSistemaComunicacaoSmsTemplatesValores"
                           data-bd-id="@v.ID"
                           data-id="@v.IDSistemaComunicacaoSmsTemplatesValores"
                           class="f3m-checkbox__input custom-control-input clsF3MQBInput"
                           checked="@isChecked"
                           autoComplete="none" />
                    <label for="@v.IDSistemaComunicacaoSmsTemplatesValores" class="f3m-checkbox__label custom-control-label"></label>
                </div>
            </div>


        Case "text"
                                    @<input data-id="@v.IDSistemaComunicacaoSmsTemplatesValores"
                                            data-bd-id="@v.ID"
                                            type="text"
                                            class="form-control clsF3MQBInput"
                                            value="@v.Valor"
                                            placeholder="@v.Placeholder" />

        Case "int"
                                    @<input data-id="@v.IDSistemaComunicacaoSmsTemplatesValores"
                                            data-bd-id="@v.ID"
                                            type="number"
                                            class="form-control clsF3MQBInput"
                                            min="@v.MinValue"
                                            max="@v.MaxValue"
                                            value="@v.Valor"
                                            placeholder="@v.Placeholder" />


        Case "date"
            @<input 
                    type="date"
                    data-bd-id="@v.ID"
                    data-id="@v.IDSistemaComunicacaoSmsTemplatesValores"
                    value="@v.Valor"
                    class="form-control clsF3MQBInput">

        Case "multiselect"
                                                            @<select data-id="@v.IDSistemaComunicacaoSmsTemplatesValores"
                                                                     data-bd-id="@v.ID"
                                                                     class="clsF3MQBInput selectpicker form-control"
                                                                     multiple
                                                                     data-live-search="true"
                                                                     data-selected-text-format="count > 3"
                                                                     data-size="6">

                                                                @For Each valor As SqlQuery In v.SqlQueryValores

                                                                    Dim strSelected As String = String.Empty
                                                                    If Not String.IsNullOrEmpty(v.Valor) Then
                                                                        Dim t = v.Valor.Split(",")

                                                                        For Each r In t
                                                                            If r = valor.ID Then
                                                                                strSelected = "selected"
                                                                            End If
                                                                        Next
                                                                    End If

                                                                    @<option value="@valor.ID" data-id="@valor.ID" @strSelected>
                                                                        @valor.Descricao
                                                                    </option>
                                                                Next
                                                            </select>


        Case "select"
                                                                                    @<select 
                                                                                             class="form-control clsF3MQBInput" 
                                                                                             data-id="@v.IDSistemaComunicacaoSmsTemplatesValores"
                                                                                             data-bd-id="@v.ID">

                                                                                        @For Each valor As SqlQuery In v.SqlQueryValores

                                                                                            Dim strSelected As String = String.Empty
                                                                                            If Not String.IsNullOrEmpty(v.Valor) Then
                                                                                                Dim t = v.Valor.Split(",")

                                                                                                For Each r In t
                                                                                                    If r = valor.ID Then
                                                                                                        strSelected = "selected"
                                                                                                    End If
                                                                                                Next
                                                                                            End If

                                                                                            @<option value="@valor.ID" data-id="@valor.ID" @strSelected>
                                                                                                @valor.Descricao
                                                                                            </option>
                                                                                        Next
                                                                                    </select>

    End Select
</div>
    Next
End Code