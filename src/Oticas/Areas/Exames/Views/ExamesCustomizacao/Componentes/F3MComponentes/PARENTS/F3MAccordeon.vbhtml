@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Modeltype Components

@Code
    Dim UrlComponentesEngine As String = "~/Areas/Exames/Views/ExamesCustomizacao/Componentes/F3MEngine/F3MDesenhaComponentes.vbhtml"
    Dim calcXS As Integer = Model.EndCol - Model.StartCol + 1
End Code

<!-- DESENHA ACCORDION -->
<div class="col-@calcXS">
    <div class="ClsF3MInputAccordion" id="accordion_@Model.ID" role="tablist" aria-multiselectable="true">
        <div class="card f3m-card-collapse">
            <div class="card-header f3m-card-collapse__header" role="tab" id="heading_@Model.ID">
                <h4 class="card-title f3m-card-collapse__header-title">
                    <a data-toggle="collapse" data-parent="#accordion_@Model.ID" href="#collapse_@Model.ID" aria-expanded="false" aria-controls="collapse_@Model.ID">
                        <span class="fm f3icon-chevron-down"></span>@Model.Label
                    </a>
                </h4>
            </div>

            <div id="collapse_@Model.ID" class="collapse" role="tabpanel" aria-labelledby="heading_@Model.ID">
                <div class="card-body">

                    @For intRow As Integer = 1 To 10
                        @For intCol As Integer = 1 To 12

                            Dim son2 As List(Of Components) = Model.ListOfComponentesFilhos.Where(Function(w)
                                                                                                      Return Not w.StartRow Is Nothing AndAlso Not w.StartCol Is Nothing AndAlso w.StartRow = intRow AndAlso w.StartCol = intCol
                                                                                                  End Function).ToList

                            If son2 IsNot Nothing AndAlso son2.Count Then
                                @Html.Partial(UrlComponentesEngine, son2)
                                intCol = son2.FirstOrDefault().EndCol

                            Else
                                @<div class="col-f3m col-1" style="visibility: hidden"></div>
                            End If
                        Next
                    Next
                </div>
            </div>
        </div>
    </div>
</div>