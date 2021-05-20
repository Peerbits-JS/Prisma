@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.Grelhas
@Code
    Dim bool As Boolean = (ViewBag.VistaParcial IsNot Nothing AndAlso ViewBag.VistaParcial)
    Dim gf As New ClsMvcKendoGrid

    Html.Partial("~/F3M/Areas/TabelasAuxiliaresComum/Views/TiposDocumento/Idiomas.vbhtml", gf)

    gf.GrelhaHTML = Html.F3M().GrelhaLinhas(Of TiposDocumentoIdiomas)(gf).ToHtmlString()

    If bool Then
        @<script>
            GrelhaLinhasInit('@gf.Id', { '@CamposGenericos.ID': 'IDTiposDocumento' }, resources.Idioma );
        </script>
    End If
End Code

<div role="tabpanel" class="tab-pane fade" id="tabIdioma">
    <div class="row form-container">
        <div class="primeiragrelha @(ClassesCSS.XS12) primeiragrelha">
            @Html.Partial(gf.PartialViewInterna, gf)
        </div>
    </div>
</div>