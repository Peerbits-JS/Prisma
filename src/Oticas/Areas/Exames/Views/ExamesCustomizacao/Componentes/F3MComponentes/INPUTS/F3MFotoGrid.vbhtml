@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Utilitarios

@Scripts.Render("~/bundles/f3m/frontendLibsFotos")

@Code
    Dim URLFotoBaseAux As String = String.Concat(URLs.FotosGerais, FotoEntidades.FotoBase)
    Dim URLFotoBaseAuxDev As String = String.Concat(Operadores.Slash, ChavesWebConfig.Projeto.ProjCliente, URLFotoBaseAux)
    Dim caminhoFoto As String = If(Not CBool(ChavesWebConfig.Projeto.EmDesenv), URLFotoBaseAuxDev, URLFotoBaseAux)
    Dim URLFotoAuxDev As String = String.Concat(Operadores.Slash, ChavesWebConfig.Projeto.ProjCliente, URLs.Fotos)
    Dim caminhobase As String = If(Not CBool(ChavesWebConfig.Projeto.EmDesenv), URLFotoAuxDev, URLs.Fotos)

    Dim funcionalidade As String = ClsF3MSessao.getResourceControlo
End Code

<div class="clsF3MFotoGrid grid animate-grid">
    @Code
        For intCiclo As Integer = 0 To ViewBag.ExamesFotos.Count - 1
            Dim pic As FotosGrid = ViewBag.ExamesFotos(intCiclo)

            Dim fotoEnt As String = String.Empty, foto As String = String.Empty, fotoNome As String = String.Empty
            Dim fotoExtensao As String = String.Empty, fotoSize As Long = 0
            Dim caminhoServidor As String = String.Empty

            Dim AcaoForm As AcoesFormulario = pic.AcaoFormulario
            If AcaoForm <> AcoesFormulario.Adicionar Then
                foto = pic.Foto

                If Not ClsTexto.ENuloOuVazio(foto) Then
                    fotoEnt = pic.FotoCaminhoCompleto
                    caminhoServidor = Server.MapPath(fotoEnt)
                    fotoNome = Path.GetFileName(caminhoServidor)
                    fotoExtensao = Path.GetExtension(caminhoServidor)

                    If IO.File.Exists(caminhoServidor) Then fotoSize = New FileInfo(caminhoServidor).Length
                End If
            End If


            Dim azb As String = CamposGenericos.Foto & (intCiclo + 1)

            @<input class="clsF3MFotoGridInput" type="hidden" id="@azb" name="@azb" value="@pic.Foto" data-f3m-bd-id="@pic.ID" data-f3m-acao-form="@pic.AcaoFormulario" data-f3m-funcionalidade="@funcionalidade"
                    data-f3m-foto-cam="@pic.FotoCaminho" data-f3m-foto-cam-completo="@pic.FotoCaminhoCompleto"
                    data-f3m-foto-anterior="@pic.FotoAnterior" data-f3m-foto-cam-anterior="@pic.FotoCaminhoAnterior" data-f3m-cam-ant-completo="@pic.FotoCaminhoAnteriorCompleto">

    End Code
    <div class="grid-sizer"></div>
    <div class="grid-item" data-f3m-foto="@azb">
        <div class="userimg-holder clsF3MClickFotoArea">
            <a class="clsF3MFotoArea area-foto">
                <img src="@Url.Content(pic.FotoCaminhoCompleto)" id="FotoEntidade@(intCiclo + 1)" alt="@(CamposGenericos.Foto)" class="img-responsive img-base" />
            </a>
            @*LABEL CARREGAR FOTO*@
            <span class="label-load-foto">@(Traducao.EstruturaAplicacaoTermosBase.CarregarFoto)</span>
            @*BOTAO EXPANDIR*@
            <a id="FullScreenImg@(intCiclo + 1)" tabindex="0" data-toggle="popover" data-trigger="focus" data-placement="right" class="clsF3MFullSize full-size btn main-btn btn-sm">
                <span class="fm f3icon-expand"></span>
            </a>
            @*BOTAO ELIMINAR FOTO*@
            <a class="clsF3MElimFoto elimina-foto btn main-btn btn-sm">
                <span class="fm f3icon-close-2"></span>
            </a>
            @*LOADING FOTO*@
            <div id="loadingupload@(intCiclo + 1)" class="loading-userimg" style="display:none">
                <img src="@Url.Content(" ../F3M/Images/loading.gif")" alt="uploading" />
            </div>
        </div>
        <div style="display:none;visibility:hidden">
            <div>
                @*KENDO UPLOAD*@
                @Code
                    Html.F3M().Upload("files" & (intCiclo + 1), funcionalidade, fotoNome, fotoExtensao, fotoSize).Render()
                End Code
            </div>
        </div>
    </div>
    @Code
        Next
    End Code

    @Code
        Dim count As Integer = ViewBag.ExamesFotos.Count + 1

        @<input class="clsF3MFotoGridInput" type="hidden" id="@("Foto")@count" name="@("Foto")@count" value="" data-f3m-bd-id="" data-f3m-acao-form="0"
                data-f3m-foto-cam="@caminhobase" data-f3m-foto-anterior="" data-f3m-foto-cam-anterior="">
    End Code
    <div class="grid-sizer"></div>
    <div class="grid-item" data-f3m-foto="Foto@(count)">
        <div class="userimg-holder clsF3MClickFotoArea">
            <a class="clsF3MFotoArea area-foto">
                <img src="@Url.Content(caminhoFoto)" id="FotoEntidade@(count)" alt="@(CamposGenericos.Foto)" class="img-responsive img-base" />
            </a>
            @*LABEL CARREGAR FOTO*@
            <span class="label-load-foto">@(Traducao.EstruturaAplicacaoTermosBase.CarregarFoto)</span>
            @*BOTAO EXPANDIR*@
            <a id="FullScreenImg@(count)" tabindex="0" data-toggle="popover" data-trigger="focus" data-placement="right" class="clsF3MFullSize full-size btn main-btn btn-sm">
                <span class="fm f3icon-expand"></span>
            </a>
            @*BOTAO ELIMINAR FOTO*@
            <a class="clsF3MElimFoto elimina-foto btn main-btn btn-sm">
                <span class="fm f3icon-close-2"></span>
            </a>
            @*LOADING FOTO*@
            <div id="loadingupload@(count)" class="loading-userimg" style="display:none">
                <img src="@Url.Content(" ../F3M/Images/loading.gif")" alt="uploading" />
            </div>
        </div>
        <div style="display:none;visibility:hidden">
            <div>
                @*KENDO UPLOAD*@
                @Code
                    Html.F3M().Upload("files" & count, funcionalidade, "", "", 0).Render()
                End Code
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function (e) {
        F3MFotoInit(false, true);
    });
</script>