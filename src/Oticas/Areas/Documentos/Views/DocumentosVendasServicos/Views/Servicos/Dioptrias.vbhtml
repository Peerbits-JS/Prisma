@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Modulos


<!-- ACCORDION -->
<div id="accordion" role="tablist" aria-multiselectable="true">
    <div class="card f3m-card-collapse f3m-card-collapse--default">
        <div class="card-header f3m-card-collapse__header edu1 active-state" role="tab" id="headingFG">
            <div class="card-title f3m-card-collapse__header-title">
                <a data-toggle="collapse" data-parent="#accordion" href="#FoleGrelha" aria-expanded="true" aria-controls="FoleGrelha">
                    <span class="fm f3icon-chevron-down"></span>
                </a>
                <span id="spnConfigGraduacoesIcon" Class="fm f3icon-cogs"></span>
                <span id="spnConfigGraduacoes">@Traducao.EstruturaDocumentos.MaisDefinicoes</span>
                <div class="float-right">
                    <div id="divLimparTransposicao">
                        <span id="spnLimpar" class="btn main-btn f3m-btn-xs">
                            @Traducao.EstruturaDocumentos.Limpar
                        </span>
                        <div id="elemFloatingLimpar" class="float-left def-resumo clsF3MElemFloating">
                            <div class="set-resumo abre-dir" style="right: 135px;min-width: 50px;">
                                <p>
                                    <label class="btn main-btn btn-block"><span id="spnLimparOE">@Traducao.EstruturaDocumentos.OE</span></label>
                                </p>
                                <p>
                                    <label class="btn main-btn btn-block"><span id="spnLimparAmbos">@Traducao.EstruturaDocumentos.Ambos</span></label>
                                </p>
                                <p>
                                    <label class="btn main-btn btn-block"><span id="spnLimparOD">@Traducao.EstruturaDocumentos.OD</span></label>
                                </p>
                            </div>
                        </div>
                        <span id="spnTransposicao" class="btn main-btn f3m-btn-xs">
                            @Traducao.EstruturaDocumentos.Transposicao
                        </span>
                        <div id="elemFloatingTransposicao" class="float-left def-resumo clsF3MElemFloating">
                            <div class="set-resumo abre-dir" style="right: 42px;min-width: 50px;">
                                <p>
                                    <label class="btn main-btn btn-block"><span id="spnTranspOE">@Traducao.EstruturaDocumentos.OE</span></label>
                                </p>
                                <p>
                                    <label class="btn main-btn btn-block"><span id="spnTranspAmbos">@Traducao.EstruturaDocumentos.Ambos</span></label>
                                </p>
                                <p>
                                    <label class="btn main-btn btn-block"><span id="spnTranspOD">@Traducao.EstruturaDocumentos.OD</span></label>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="FoleGrelha" class="collapse show" role="tabpanel" aria-labelledby="headingFG" aria-expanded="true">
            <div class="card-body servicos-body clearfix">
                <div id="tblLentes" class="table-lentes">
                    <div>
                        <table class="dioptrias InputTouch">
                            <thead>
                                <tr>
                                    <th class="cel-vazia"></th>
                                    <th>@Traducao.EstruturaDocumentos.Raio</th>
                                    <th>@Traducao.EstruturaDocumentos.Raio2</th>
                                    <th>@Traducao.EstruturaDocumentos.ESF</th>
                                    <th>@Traducao.EstruturaDocumentos.CIL</th>
                                    <th>@Traducao.EstruturaDocumentos.AX</th>
                                    <th>@Traducao.EstruturaDocumentos.ADD</th>
                                    <th>@Traducao.EstruturaDocumentos.AV</th>
                                    <th class="cel-vazia" style="border-bottom:none"></th>
                                    <th>@Traducao.EstruturaDocumentos.Raio</th>
                                    <th>@Traducao.EstruturaDocumentos.Raio2</th>
                                    <th>@Traducao.EstruturaDocumentos.ESF</th>
                                    <th>@Traducao.EstruturaDocumentos.CIL</th>
                                    <th>@Traducao.EstruturaDocumentos.AX</th>
                                    <th>@Traducao.EstruturaDocumentos.ADD</th>
                                    <th>@Traducao.EstruturaDocumentos.AV</th>
                                    <th class="cel-vazia"></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr class="TabLentes">
                                    <td class="cel-vazia odoe"><span class="fm f3icon-eye"></span><br />@Traducao.EstruturaDocumentos.OD</td>
                                    <td><label for="ODRaio" class="" textolabelrequired="OD: Raio"></label><input id="ODRaio" type="number" min="0" max="30" step="0.1" class="input-dioptria TabOlhoDireito RaioCurvatura" tabindex="67" /></td>
                                    <td><input class="input-dioptria TabOlhoDireito DetalheRaio" value="" tabindex="68" /></td>
                                    <td><input type="number" min="-50" max="50" step="0.25" class="input-dioptria TabOlhoDireito PotenciaEsferica" tabindex="69" /></td>
                                    <td><input type="number" min="-50" max="50" step="0.25" class="input-dioptria TabOlhoDireito PotenciaCilindrica" tabindex="70" /></td>
                                    <td><input type="number" min="0" max="180" step="1" class="input-dioptria TabOlhoDireito Eixo" tabindex="71" /></td>
                                    <td><input type="number" min="0" max="30" step="0.25" class="input-dioptria TabOlhoDireito Adicao" tabindex="72" /></td>
                                    <td><input type="number" min="0" max="15" step="0.1" class="input-dioptria TabOlhoDireito AcuidadeVisual" tabindex="73" /></td>
                                    <td class="cel-vazia copia-centro">
                                        <a id="spnCopiaEsquerdaLC" class="btn main-btn btn-sm">
                                            <span class="fm f3icon-angle-right"></span>
                                            <span class="fm f3icon-angle-right"></span>
                                        </a>
                                        <a id="spnCopiaDireitaLC" class="btn main-btn btn-sm">
                                            <span class="fm f3icon-angle-left"></span>
                                            <span class="fm f3icon-angle-left"></span>
                                        </a>
                                    </td>
                                    <td style="border-left:1px solid #ccc"><label for="OERaio" class="" textolabelrequired="OE: Raio"></label><input id="OERaio" type="number" min="0" max="30" step="0.1" class="input-dioptria TabOlhoEsquerdo RaioCurvatura" tabindex="74" /></td>
                                    <td><input class="input-dioptria TabOlhoEsquerdo DetalheRaio" value="" tabindex="75" /></td>
                                    <td><input type="number" min="-50" max="50" step="0.25" class="input-dioptria TabOlhoEsquerdo PotenciaEsferica" tabindex="76" /></td>
                                    <td><input type="number" min="-50" max="50" step="0.25" class="input-dioptria TabOlhoEsquerdo PotenciaCilindrica" tabindex="77" /></td>
                                    <td><input type="number" min="0" max="180" step="1" class="input-dioptria TabOlhoEsquerdo Eixo" tabindex="78" /></td>
                                    <td><input type="number" min="0" max="30" step="0.25" class="input-dioptria TabOlhoEsquerdo Adicao" tabindex="79" /></td>
                                    <td><input type="number" min="0" max="15" step="0.1" class="input-dioptria TabOlhoEsquerdo AcuidadeVisual" tabindex="80" /></td>
                                    <td class="cel-vazia odoe"><span class="fm f3icon-eye"></span><br />@Traducao.EstruturaDocumentos.OE</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div id="tblOculos" style="overflow-x: auto;">
                    <div>
                        <table class="dioptrias InputTouch">
                            <thead>
                                <tr>
                                    <th class="cel-vazia"></th>
                                    <th><span class="TabOlhoDireito PotenciaEsferica">@Traducao.EstruturaDocumentos.ESF</span></th>
                                    <th><span class="TabOlhoDireito PotenciaCilindrica">@Traducao.EstruturaDocumentos.CIL</span></th>
                                    <th><span class="TabOlhoDireito Eixo">@Traducao.EstruturaDocumentos.AX</span></th>
                                    <th><span class="TabOlhoDireito Adicao">@Traducao.EstruturaDocumentos.ADD</span></th>
                                    <th><span class="TabOlhoDireito DNP">@Traducao.EstruturaDocumentos.DNP</span></th>
                                    <th><span class="TabOlhoDireito Altura">@Traducao.EstruturaDocumentos.AL</span></th>
                                    <th><span class="TabOlhoDireito PotenciaPrismatica">@Traducao.EstruturaDocumentos.PRISM</span></th>
                                    <th><span class="TabOlhoDireito BasePrismatica">@Traducao.EstruturaDocumentos.BP</span></th>
                                    <th><span class="TabOlhoDireito AcuidadeVisual">@Traducao.EstruturaDocumentos.AV</span></th>
                                    <th><span class="TabOlhoDireito AnguloPantoscopico">@Traducao.EstruturaDocumentos.PAN</span></th>
                                    <th><span class="TabOlhoDireito DistanciaVertex">@Traducao.EstruturaDocumentos.VTX</span></th>
                                    <th class="cel-vazia" style="border-bottom:none">
                                        <a id="spnCopiaEsquerdaO" class="btn main-btn btn-sm" style="float:left" title="@Traducao.EstruturaDocumentos.CopiarParaOE">
                                            <span class="fm f3icon-angle-right"></span>
                                            <span class="fm f3icon-angle-right"></span>
                                        </a>
                                        <a id="spnCopiaDireitaO" class="btn main-btn btn-sm" style="float:right" title="@Traducao.EstruturaDocumentos.CopiarParaOD">
                                            <span class="fm f3icon-angle-left"></span>
                                            <span class="fm f3icon-angle-left"></span>
                                        </a>
                                    </th>
                                    <th><span class="TabOlhoEsquerdo PotenciaEsferica">@Traducao.EstruturaDocumentos.ESF</span></th>
                                    <th><span class="TabOlhoEsquerdo PotenciaCilindrica">@Traducao.EstruturaDocumentos.CIL</span></th>
                                    <th><span class="TabOlhoEsquerdo Eixo">@Traducao.EstruturaDocumentos.AX</span></th>
                                    <th><span class="TabOlhoEsquerdo Adicao">@Traducao.EstruturaDocumentos.ADD</span></th>
                                    <th><span class="TabOlhoEsquerdo DNP">@Traducao.EstruturaDocumentos.DNP</span></th>
                                    <th><span class="TabOlhoEsquerdo Altura">@Traducao.EstruturaDocumentos.AL</span></th>
                                    <th><span class="TabOlhoEsquerdo PotenciaPrismatica">@Traducao.EstruturaDocumentos.PRISM</span></th>
                                    <th><span class="TabOlhoEsquerdo BasePrismatica">@Traducao.EstruturaDocumentos.BP</span></th>
                                    <th><span class="TabOlhoEsquerdo AcuidadeVisual">@Traducao.EstruturaDocumentos.AV</span></th>
                                    <th><span class="TabOlhoEsquerdo AnguloPantoscopico">@Traducao.EstruturaDocumentos.PAN</span></th>
                                    <th><span class="TabOlhoEsquerdo DistanciaVertex">@Traducao.EstruturaDocumentos.VTX</span></th>
                                    <th class="cel-vazia"></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr class="TabLonge">
                                    <td rowspan="1" class="cel-vazia odoe"><span class="fm f3icon-eye"></span><br />@Traducao.EstruturaDocumentos.OD</td>
                                    <td><input type="number" min="-50" max="50" step="0.25" class="input-dioptria TabOlhoDireito PotenciaEsferica" tabindex="1" /></td>
                                    <td><input type="number" min="-50" max="50" step="0.25" class="input-dioptria TabOlhoDireito PotenciaCilindrica" tabindex="2" /></td>
                                    <td><input type="number" min="0" max="180" step="1" class="input-dioptria TabOlhoDireito Eixo" tabindex="3" /></td>
                                    <td><input type="number" min="0" max="30" step="0.25" class="input-dioptria TabOlhoDireito Adicao" tabindex="4" /></td>
                                    <td><input type="number" min="0" max="50" step="0.5" class="input-dioptria TabOlhoDireito DNP" tabindex="5" /></td>
                                    <td><input type="number" min="0" max="50" step="0.25" class="input-dioptria TabOlhoDireito Altura" tabindex="6" /></td>
                                    <td><input type="number" min="0" max="30" step="0.5" class="input-dioptria TabOlhoDireito PotenciaPrismatica" tabindex="7" /></td>
                                    <td><input type="number" min="0" max="360" step="1" class="input-dioptria TabOlhoDireito BasePrismatica" tabindex="8" /></td>
                                    <td><input type="number" min="0" max="15" step="0.5" class="input-dioptria TabOlhoDireito AcuidadeVisual" tabindex="9" /></td>
                                    <td><input type="number" min="0" max="180" step="1" class="input-dioptria TabOlhoDireito AnguloPantoscopico" tabindex="10" /></td>
                                    <td><input type="number" min="0" max="15" step="0.1" class="input-dioptria TabOlhoDireito DistanciaVertex" tabindex="11" /></td>
                                    @*<td class="cel-vazia">
                                            <a id="spnCopiaEsquerdaO" class="btn main-btn btn-sm">
                                                <span class="fm f3icon-angle-right"></span>
                                                <span class="fm f3icon-angle-right"></span>
                                                <span class="txt-linha">@Traducao.EstruturaDocumentos.Longe</span>
                                            </a>
                                        </td>*@
                                    <td class="cel-vazia intermed">
                                        <span class="txt-linha"> @Traducao.EstruturaDocumentos.Longe</span>
                                    </td>
                                    <td style="border-left:1px solid #ccc"><input type="number" min="-50" max="50" step="0.25" class="input-dioptria TabOlhoEsquerdo PotenciaEsferica" tabindex="34" /></td>
                                    <td><input type="number" min="-50" max="50" step="0.25" class="input-dioptria TabOlhoEsquerdo PotenciaCilindrica" tabindex="35" /></td>
                                    <td><input type="number" min="0" max="180" step="1" class="input-dioptria TabOlhoEsquerdo Eixo" tabindex="36" /></td>
                                    <td><input type="number" min="0" max="30" step="0.25" class="input-dioptria TabOlhoEsquerdo Adicao" tabindex="37" /></td>
                                    <td><input type="number" min="0" max="50" step="0.5" class="input-dioptria TabOlhoEsquerdo DNP" tabindex="38" /></td>
                                    <td><input type="number" min="0" max="50" step="0.25" class="input-dioptria TabOlhoEsquerdo Altura" tabindex="39" /></td>
                                    <td><input type="number" min="0" max="30" step="0.5" class="input-dioptria TabOlhoEsquerdo PotenciaPrismatica" tabindex="40" /></td>
                                    <td><input type="number" min="0" max="360" step="1" class="input-dioptria TabOlhoEsquerdo BasePrismatica" tabindex="41" /></td>
                                    <td><input type="number" min="0" max="15" step="0.5" class="input-dioptria TabOlhoEsquerdo AcuidadeVisual" tabindex="42" /></td>
                                    <td><input type="number" min="0" max="180" step="1" class="input-dioptria TabOlhoEsquerdo AnguloPantoscopico" tabindex="43" /></td>
                                    <td><input type="number" min="0" max="15" step="0.1" class="input-dioptria TabOlhoEsquerdo DistanciaVertex" tabindex="44" /></td>
                                    <td rowspan="1" class="cel-vazia odoe"><span class="fm f3icon-eye"></span><br />@Traducao.EstruturaDocumentos.OE</td>
                                </tr>
                                <tr class="TabInt" style="display:none">
                                    <td rowspan="1" class="cel-vazia odoe"></td>
                                    <td><input type="number" min="-50" max="50" step="0.25" class="input-dioptria TabOlhoDireito PotenciaEsferica" tabindex="12" /></td>
                                    <td><input type="number" min="-50" max="50" step="0.25" class="input-dioptria TabOlhoDireito PotenciaCilindrica" tabindex="13" /></td>
                                    <td><input type="number" min="0" max="180" step="1" class="input-dioptria TabOlhoDireito Eixo" tabindex="14" /></td>
                                    <td><input type="number" min="0" max="30" step="0.25" class="input-dioptria TabOlhoDireito Adicao" tabindex="15" /></td>
                                    <td><input type="number" min="0" max="50" step="0.5" class="input-dioptria TabOlhoDireito DNP" tabindex="16" /></td>
                                    <td><input type="number" min="0" max="50" step="0.25" class="input-dioptria TabOlhoDireito Altura" tabindex="17" /></td>
                                    <td><input type="number" min="0" max="30" step="0.5" class="input-dioptria TabOlhoDireito PotenciaPrismatica" tabindex="18" /></td>
                                    <td><input type="number" min="0" max="360" step="1" class="input-dioptria TabOlhoDireito BasePrismatica" tabindex="19" /></td>
                                    <td><input type="number" min="0" max="15" step="0.5" class="input-dioptria TabOlhoDireito AcuidadeVisual" tabindex="20" /></td>
                                    <td><input type="number" min="0" max="180" step="1" class="input-dioptria TabOlhoDireito AnguloPantoscopico" tabindex="21" /></td>
                                    <td><input type="number" min="0" max="15" step="0.1" class="input-dioptria TabOlhoDireito DistanciaVertex" tabindex="22" /></td>
                                    <td class="cel-vazia intermed">
                                        <span class="txt-linha tab-span-intermedio"> @Traducao.EstruturaDocumentos.INT</span>
                                    </td>
                                    <td style="border-left:1px solid #ccc"><input type="number" min="-50" max="50" step="0.25" class="input-dioptria TabOlhoEsquerdo PotenciaEsferica" tabindex="45" /></td>
                                    <td><input type="number" min="-50" max="50" step="0.25" class="input-dioptria TabOlhoEsquerdo PotenciaCilindrica" tabindex="46" /></td>
                                    <td><input type="number" min="0" max="180" step="1" class="input-dioptria TabOlhoEsquerdo Eixo" tabindex="47" /></td>
                                    <td><input type="number" min="-50" max="50" step="0.25" class="input-dioptria TabOlhoEsquerdo Adicao" tabindex="48" /></td>
                                    <td><input type="number" min="0" max="30" step="0.5" class="input-dioptria TabOlhoEsquerdo DNP" tabindex="49" /></td>
                                    <td><input type="number" min="0" max="30" step="0.25" class="input-dioptria TabOlhoEsquerdo Altura" tabindex="50" /></td>
                                    <td><input type="number" min="0" max="30" step="0.5" class="input-dioptria TabOlhoEsquerdo PotenciaPrismatica" tabindex="51" /></td>
                                    <td><input type="number" min="0" max="360" step="1" class="input-dioptria TabOlhoEsquerdo BasePrismatica" tabindex="52" /></td>
                                    <td><input type="number" min="0" max="15" step="0.5" class="input-dioptria TabOlhoEsquerdo AcuidadeVisual" tabindex="53" /></td>
                                    <td><input type="number" min="0" max="180" step="1" class="input-dioptria TabOlhoEsquerdo AnguloPantoscopico" tabindex="54" /></td>
                                    <td><input type="number" min="0" max="15" step="0.1" class="input-dioptria TabOlhoEsquerdo DistanciaVertex" tabindex="55" /></td>
                                    <td rowspan="1" class="cel-vazia odoe"></td>
                                </tr>
                                <tr class="TabPerto">
                                    <td rowspan="1" class="cel-vazia odoe LblPerto"><span class="fm f3icon-eye"></span><br />@Traducao.EstruturaDocumentos.OD</td>
                                    <td><input type="number" min="-50" max="50" step="0.25" class="input-dioptria TabOlhoDireito PotenciaEsferica" tabindex="23" /></td>
                                    <td><input type="number" min="-50" max="50" step="0.25" class="input-dioptria TabOlhoDireito PotenciaCilindrica" tabindex="24" /></td>
                                    <td><input type="number" min="0" max="180" step="1" class="input-dioptria TabOlhoDireito Eixo" tabindex="25" /></td>
                                    <td><input type="number" min="0" max="30" step="0.25" class="input-dioptria TabOlhoDireito Adicao" tabindex="26" /></td>
                                    <td><input type="number" min="0" max="50" step="0.5" class="input-dioptria TabOlhoDireito DNP" tabindex="27" /></td>
                                    <td><input type="number" min="0" max="50" step="0.25" class="input-dioptria TabOlhoDireito Altura" tabindex="28" /></td>
                                    <td><input type="number" min="0" max="30" step="0.5" class="input-dioptria TabOlhoDireito PotenciaPrismatica" tabindex="29" /></td>
                                    <td><input type="number" min="0" max="360" step="1" class="input-dioptria TabOlhoDireito BasePrismatica" tabindex="30" /></td>
                                    <td><input type="number" min="0" max="15" step="0.5" class="input-dioptria TabOlhoDireito AcuidadeVisual" tabindex="31" /></td>
                                    <td><input type="number" min="0" max="180" step="1" class="input-dioptria TabOlhoDireito AnguloPantoscopico" tabindex="32" /></td>
                                    <td><input type="number" min="0" max="15" step="0.1" class="input-dioptria TabOlhoDireito DistanciaVertex" tabindex="33" /></td>
                                    @*<td class="cel-vazia">
                                            <a id="spnCopiaDireitaO" class="btn main-btn btn-sm">
                                                <span class="fm f3icon-angle-left"></span>
                                                <span class="fm f3icon-angle-left"></span>
                                                <span class="txt-linha">@Traducao.EstruturaDocumentos.Perto</span>
                                            </a>
                                        </td>*@
                                    <td class="cel-vazia intermed">
                                        <span class="txt-linha"> @Traducao.EstruturaDocumentos.Perto</span>
                                    </td>
                                    <td style="border-left:1px solid #ccc"><input type="number" min="-50" max="50" step="0.25" class="input-dioptria TabOlhoEsquerdo PotenciaEsferica" tabindex="56" /></td>
                                    <td><input type="number" min="-50" max="50" step="0.25" class="input-dioptria TabOlhoEsquerdo PotenciaCilindrica" tabindex="57" /></td>
                                    <td><input type="number" min="0" max="180" step="1" class="input-dioptria TabOlhoEsquerdo Eixo" tabindex="58" /></td>
                                    <td><input type="number" min="0" max="30" step="0.25" class="input-dioptria TabOlhoEsquerdo Adicao" tabindex="59" /></td>
                                    <td><input type="number" min="0" max="50" step="0.5" class="input-dioptria TabOlhoEsquerdo DNP" tabindex="60" /></td>
                                    <td><input type="number" min="0" max="50" step="0.25" class="input-dioptria TabOlhoEsquerdo Altura" tabindex="61" /></td>
                                    <td><input type="number" min="0" max="30" step="0.5" class="input-dioptria TabOlhoEsquerdo PotenciaPrismatica" tabindex="62" /></td>
                                    <td><input type="number" min="0" max="360" step="1" class="input-dioptria TabOlhoEsquerdo BasePrismatica" tabindex="63" /></td>
                                    <td><input type="number" min="0" max="15" step="0.5" class="input-dioptria TabOlhoEsquerdo AcuidadeVisual" tabindex="64" /></td>
                                    <td><input type="number" min="0" max="180" step="1" class="input-dioptria TabOlhoEsquerdo AnguloPantoscopico" tabindex="65" /></td>
                                    <td><input type="number" min="0" max="15" step="0.1" class="input-dioptria TabOlhoEsquerdo DistanciaVertex" tabindex="66" /></td>
                                    <td rowspan="1" class="cel-vazia odoe LblPerto"><span class="fm f3icon-eye"></span><br />@Traducao.EstruturaDocumentos.OE</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <div id="elemFloatingTouch" class="float-left def-resumo clsF3MElemFloating" style="width:300px;">
                <div class="set-resumo abre-dir" style="width:300px;">
                    <div class="well">
                        <div id="calc-board" class="container-fluid">
                            <div class="row">
                                <a href="#" class="btn btnT">7</a>
                                <a href="#" class="btn btnT">8</a>
                                <a href="#" class="btn btnT">9</a>
                            </div>
                            <div class="row">
                                <a href="#" class="btn btnT">4</a>
                                <a href="#" class="btn btnT">5</a>
                                <a href="#" class="btn btnT">6</a>
                                <a href="#" class="btn btnT" data-val=""><span class="fm f3icon-chevron-up spanUp" aria-hidden="true"></span></a>
                            </div>
                            <div class="row">
                                <a href="#" class="btn btnT">1</a>
                                <a href="#" class="btn btnT">2</a>
                                <a href="#" class="btn btnT">3</a>
                                <a href="#" class="btn btnT"><span class="fm f3icon-chevron-down spanDown" aria-hidden="true"></span></a>
                            </div>
                            <div class="row">
                                <a href="#" class="btn btnT">0</a>
                                <a href="#" class="btn btnT">,</a>
                                <a href="#" class="btn btnT">C</a>
                            </div>
                        </div>

                        <a class="left carousel-control"><span class="fm f3icon-chevron-left spanLeft" aria-hidden="true"></span></a>
                        <a class="right carousel-control"><span class="fm f3icon-chevron-right spanRight" aria-hidden="true"></span></a>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="elemFloatingConfigGraduacoes" class="float-left def-resumo clsF3MElemFloating">
    <div class="set-resumo">
        <div class="row form-container">
            @Code
                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "IDMedicoTecnico",
                                        .Label = Traducao.EstruturaDocumentos.MedicoTecnico,
                                        .Controlador = URLs.Areas.TabAux & "MedicosTecnicos",
                                        .ControladorAccaoExtra = .Controlador & Operadores.Slash & URLs.ViewIndexGrelha,
                                        .TipoEditor = Mvc.Componentes.F3MLookup,
                                        .CampoTexto = CamposGenericos.Nome,
                                        .FuncaoJSEnviaParams = "ServicosMedicoTecnicoEnviaParametros",
                                        .FuncaoJSChange = "ServicosMedicoTecnicoChange",
                                        .Modelo = Model.Modelo,
                                        .OpcaoMenuDescAbrev = F3M.Modelos.Constantes.Menus.MedicosTecnicos,
                                        .ViewClassesCSS = {ClassesCSS.XS8}})

                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "DataReceita",
                    .Label = Traducao.EstruturaDocumentos.DataReceita,
                    .TipoEditor = Mvc.Componentes.F3MData,
                    .Modelo = Model.Modelo,
                    .ViewClassesCSS = {ClassesCSS.XS4}})
            End Code
        </div>
        <div class="row">
            @Code
                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "VerPrismas",
                                .Label = Traducao.EstruturaDocumentos.VerPrismas,
                                .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap,
                                .Modelo = Model.Modelo,
                                .ViewClassesCSS = {ClassesCSS.SoXS4 + " f3m-checkbox-sem-top"}})

                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "VisaoIntermedia",
                        .Label = Traducao.EstruturaDocumentos.VisaoIntermedia,
                        .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap,
                        .Modelo = Model.Modelo,
                        .ValorID = False,
                        .ViewClassesCSS = {ClassesCSS.SoXS4 + " f3m-checkbox-sem-top"}})
            End Code
        </div>
    </div>
</div>