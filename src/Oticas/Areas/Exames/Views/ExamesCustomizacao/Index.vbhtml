@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Modeltype ExamesCustomizacao
@Code
    Layout = URLs.SharedLayoutFuncionalidades
End Code

<style>
    .cust-container {
        min-height: calc(100% / 10);
    }

    .col-container {
        display: table; /* Make the container element behave like a table */
        width: 100%; /* Set full-width to expand the whole page */
    }

    .col {
        display: table-cell; /* Make elements inside the container behave like table cells */
    }
</style>

<div id="F3MExamesCustomizacao">
    @*CABECALHO*@
    <div class="f3m-top submenu clearfix">
        <div class="float-left f3m-top__left">
            @*TITULO*@
            @Html.Partial("~/F3M/Views/Partials/F3MMenuFavoritoHomepageTitulo.vbhtml")
        </div>
        <div class="float-right f3m-top__right">
            @*BOTOES*@
            @Code
                Html.F3M().Botao("BtSave", Mvc.BotoesGrelha.Guardar & Mvc.BotoesGrelha.BtsCRUD, "Guardar", "floppy-o")
            End Code
        </div>
    </div>

    @*CONTAINERS*@
    <div class="area-vazia">
        <div class="container-fluid">
            @Html.Partial("~/Areas/Exames/Views/ExamesCustomizacao/Componentes/F3MLogic/F3MDesenhaJanela.vbhtml", Model.ExamesCustomizacaoComponents)
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        ComboBoxAbrePopup();
    });
</script>