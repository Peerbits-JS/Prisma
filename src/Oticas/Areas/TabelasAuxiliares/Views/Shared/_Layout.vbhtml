@Imports F3M.Modelos.Constantes
<!DOCTYPE html>
@Html.Partial(URLs.PartialLayoutTopo)
<html lang="pt-pt">
<body id="iframeBody">
    @Html.Partial(URLs.PartialLayoutJanelas)
    <div class="grelhaform-content">@RenderBody()</div>
    @Html.Partial(URLs.PartialLayoutFundo, "jsTabelasAuxiliares")
</body>
</html>