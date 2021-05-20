@Modeltype Oticas.DocumentosStockContagem

<div id="TotaisArtigos">       
    <p class="titulo">@Traducao.EstruturaDocumentosStockContagem.Artigos</p>      
    <div class="valor-soma">
        <ul class="list-unstyled">
            <li>
                <div>@Traducao.EstruturaDocumentosStockContagem.Faltam</div>
                <div><strong><span class="CLSF3MLadoDirFaltam">@Model.FaltamContar</span></strong></div>
            </li>
            <li>
                <div>@Traducao.EstruturaDocumentosStockContagem.Contados</div>
                <div><strong><span class="CLSF3MLadoDirContados">@Model.Contados</span></strong></div>
            </li>
            <li>
                <div>@Traducao.EstruturaDocumentosStockContagem.ComDiferencas</div>
                <div><strong><span class="CLSF3MLadoDirDiferencas">@Model.Diferencas</span></strong></div>
            </li>
        </ul>
    </div>
</div>