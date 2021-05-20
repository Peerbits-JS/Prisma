@Modeltype Components

@Code
    Dim UrlSonsEngine As String = "~/Areas/Exames/Views/ExamesCustomizacao/Componentes/F3MEngine/F3MSonsEngine.vbhtml"
End Code

<!-- DESENHA TABS -->
<div role="tabpanel" class="f3m-tabs clsF3MTabs">
    <ul class="nav nav-pills f3m-tabs__ul clsAreaFixed" role="tablist">
        @Code
            @<!-- DESENHA TITULO DAS TABS -->
            For Each tab As Components In Model.ListOfComponentesFilhos
                @<li role="presentation" class="nav-item">
                    <a href="#tab_@tab.ID" class="nav-link @tab.ViewClassesCSS" role="tab" data-toggle="tab" aria-expanded="false">@tab.Label</a>
                </li>
            Next
        End Code
    </ul>
    <div class="tab-content">
        @Code
            @<!-- DESENHA CONTEUDO DAS TABS -->
            For Each tabConteudo In Model.ListOfComponentesFilhos
                @<div id="tab_@tabConteudo.ID" role="tabpanel" class="tab-pane fade @tabConteudo.ViewClassesCSS">
                    @Html.Partial(UrlSonsEngine, tabConteudo)
                </div>
            Next
        End Code
    </div>
</div>