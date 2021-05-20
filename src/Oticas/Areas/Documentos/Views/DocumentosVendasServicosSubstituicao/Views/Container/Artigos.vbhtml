@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports Oticas.Modelos.Constantes
@Modeltype Oticas.DocumentosVendasServicosSubstituicao

@Code
    Dim F3MBarLoading As String = URLs.F3MFrontEndComponentes & "BarLoading.vbhtml"
End Code

<div role="tabpanel" class="tab-pane fade" id="tabArtigos">
    <div class="obs-holder">
        <div id="accordion" role="tablist" aria-multiselectable="true">
            <div class="card f3m-card-collapse f3m-card-collapse--default">
                <div class="card-header f3m-card-collapse__header edu1 active-state" role="tab" id="headingFG">
                    <div class="card-title f3m-card-collapse__header-title">
                        <a data-toggle="collapse" data-parent="#accordion" href="#FoleGrelha" aria-expanded="true" aria-controls="FoleGrelha" class="">
                            <span class="fm f3icon-chevron-down"></span>
                        </a>
                    </div>
                </div>
                <div id="FoleGrelha" class="collapse show" role="tabpanel" aria-labelledby="headingFG" aria-expanded="true">
                    <div class="card-body servicos-body clearfix">
                        @Code
                            If Model.Servico.IDTipoServico = TipoServico.Contacto Then
                        End Code

                        <div id="tblLentes" class="table-lentes">
                            <div>
                                <Table class="dioptrias InputTouch">
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
                                            <td> <Label for="ODRaio" class="" textolabelrequired="OD: Raio"></Label><input id="ODRaio" type="number" min="0" max="30" step="0.1" class="input-dioptria TabOlhoDireito RaioCurvatura" tabindex="67" /></td>
                                            <td> <input class="input-dioptria TabOlhoDireito DetalheRaio" value="" tabindex="68" /></td>
                                            <td> <input type="number" min="-50" max="50" Step="0.25" class="input-dioptria TabOlhoDireito PotenciaEsferica" tabindex="69" /></td>
                                            <td> <input type="number" min="-50" max="50" Step="0.25" class="input-dioptria TabOlhoDireito PotenciaCilindrica" tabindex="70" /></td>
                                            <td> <input type="number" min="0" max="180" Step="1" class="input-dioptria TabOlhoDireito Eixo" tabindex="71" /></td>
                                            <td> <input type="number" min="0" max="30" Step="0.25" class="input-dioptria TabOlhoDireito Adicao" tabindex="72" /></td>
                                            <td> <input type="number" min="0" max="15" Step="0.1" class="input-dioptria TabOlhoDireito AcuidadeVisual" tabindex="73" /></td>
                                            <td class="cel-vazia copia-centro">
                                                <a id="spnCopiaEsquerdaLC" class="btn main-btn btn-sm copy-grads">
                                                    <Span class="fm f3icon-angle-right"></Span>
                                                    <Span class="fm f3icon-angle-right"></Span>
                                                </a>
                                                <a id="spnCopiaDireitaLC" class="btn main-btn btn-sm copy-grads">
                                                    <Span class="fm f3icon-angle-left"></Span>
                                                    <Span class="fm f3icon-angle-left"></Span>
                                                </a>
                                            </td>
                                            <td style="border-left:1px solid #ccc"><label For="OERaio" class="" textolabelrequired="OE: Raio"></label><input id="OERaio" type="number" min="0" max="30" Step="0.1" class="input-dioptria TabOlhoEsquerdo RaioCurvatura" tabindex="74" /></td>
                                            <td> <input class="input-dioptria TabOlhoEsquerdo DetalheRaio" value="" tabindex="75" /></td>
                                            <td> <input type="number" min="-50" max="50" Step="0.25" class="input-dioptria TabOlhoEsquerdo PotenciaEsferica" tabindex="76" /></td>
                                            <td> <input type="number" min="-50" max="50" Step="0.25" class="input-dioptria TabOlhoEsquerdo PotenciaCilindrica" tabindex="77" /></td>
                                            <td> <input type="number" min="0" max="180" Step="1" class="input-dioptria TabOlhoEsquerdo Eixo" tabindex="78" /></td>
                                            <td> <input type="number" min="0" max="30" Step="0.25" class="input-dioptria TabOlhoEsquerdo Adicao" tabindex="79" /></td>
                                            <td> <input type="number" min="0" max="15" Step="0.1" class="input-dioptria TabOlhoEsquerdo AcuidadeVisual" tabindex="80" /></td>
                                            <td class="cel-vazia odoe"><span class="fm f3icon-eye"></span><br />@Traducao.EstruturaDocumentos.OE</td>
                                        </tr>
                                    </tbody>
                                </Table>
                            </div>
                        </div>
                        @Code
                        End If
                        End Code

                        @Code
                            If Model.Servico.IDTipoServico <> TipoServico.Contacto Then
                        End Code

                        <div id="tblOculos" style="overflow-x: auto;">
                            <div>
                                <table class="dioptrias InputTouch">
                                    <thead>
                                        <tr>
                                            <th class="cel-vazia"></th>
                                            <th><Span class="TabOlhoDireito PotenciaEsferica">@Traducao.EstruturaDocumentos.ESF</Span></th>
                                            <th><Span class="TabOlhoDireito PotenciaCilindrica">@Traducao.EstruturaDocumentos.CIL</Span></th>
                                            <th><Span class="TabOlhoDireito Eixo">@Traducao.EstruturaDocumentos.AX</Span></th>
                                            <th><Span class="TabOlhoDireito Adicao">@Traducao.EstruturaDocumentos.ADD</Span></th>
                                            <th><Span class="TabOlhoDireito DNP">@Traducao.EstruturaDocumentos.DNP</Span></th>
                                            <th><Span class="TabOlhoDireito Altura">@Traducao.EstruturaDocumentos.AL</Span></th>

                                            @if Model.Servico.VerPrismas Then
                                                @<th><Span Class="TabOlhoDireito PotenciaPrismatica">@Traducao.EstruturaDocumentos.PRISM</Span></th>
                                                @<th><Span class="TabOlhoDireito BasePrismatica">@Traducao.EstruturaDocumentos.BP</Span></th>
                                            End If

                                            <th><Span class="TabOlhoDireito AcuidadeVisual">@Traducao.EstruturaDocumentos.AV</Span></th>
                                            <th><Span class="TabOlhoDireito AnguloPantoscopico">@Traducao.EstruturaDocumentos.PAN</Span></th>
                                            <th><Span class="TabOlhoDireito DistanciaVertex">@Traducao.EstruturaDocumentos.VTX</Span></th>
                                            <th class="cel-vazia" style="border-bottom:none">
                                                <a id="spnCopiaEsquerdaO" class="btn main-btn btn-sm copy-grads" style="float:left" title="@Traducao.EstruturaDocumentos.CopiarParaOE">
                                                    <Span class="fm f3icon-angle-right"></Span>
                                                    <Span class="fm f3icon-angle-right"></Span>
                                                </a>
                                                <a id="spnCopiaDireitaO" class="btn main-btn btn-sm copy-grads" style="float:right" title="@Traducao.EstruturaDocumentos.CopiarParaOD">
                                                    <Span class="fm f3icon-angle-left"></Span>
                                                    <Span class="fm f3icon-angle-left"></Span>
                                                </a>
                                            </th>
                                            <th> <Span class="TabOlhoEsquerdo PotenciaEsferica">@Traducao.EstruturaDocumentos.ESF</Span></th>
                                            <th> <Span class="TabOlhoEsquerdo PotenciaCilindrica">@Traducao.EstruturaDocumentos.CIL</Span></th>
                                            <th> <Span class="TabOlhoEsquerdo Eixo">@Traducao.EstruturaDocumentos.AX</Span></th>
                                            <th> <Span class="TabOlhoEsquerdo Adicao">@Traducao.EstruturaDocumentos.ADD</Span></th>
                                            <th> <Span class="TabOlhoEsquerdo DNP">@Traducao.EstruturaDocumentos.DNP</Span></th>
                                            <th> <Span class="TabOlhoEsquerdo Altura">@Traducao.EstruturaDocumentos.AL</Span></th>

                                            @if Model.Servico.VerPrismas Then
                                                @<th> <Span Class="TabOlhoEsquerdo PotenciaPrismatica">@Traducao.EstruturaDocumentos.PRISM</Span></th>
                                                @<th> <Span Class="TabOlhoEsquerdo BasePrismatica">@Traducao.EstruturaDocumentos.BP</Span></th>
                                            End If

                                            <th> <Span class="TabOlhoEsquerdo AcuidadeVisual">@Traducao.EstruturaDocumentos.AV</Span></th>
                                            <th> <Span class="TabOlhoEsquerdo AnguloPantoscopico">@Traducao.EstruturaDocumentos.PAN</Span></th>
                                            <th> <Span class="TabOlhoEsquerdo DistanciaVertex">@Traducao.EstruturaDocumentos.VTX</Span></th>
                                            <th class="cel-vazia"></th>
                                        </tr>
                                    </thead>
                                    <tbody>

                                        @Code
                                            If Model.Servico.IDTipoServico <> TipoServico.Perto Then
                                        End Code

                                        <tr class="TabLonge">
                                            <td rowspan="1" class="cel-vazia odoe LblLonge"><span class="fm f3icon-eye"></span><br />@Traducao.EstruturaDocumentos.OD</td>
                                            <td> <input type="number" min="-50" max="50" Step="0.25" class="input-dioptria TabOlhoDireito PotenciaEsferica" tabindex="1" /></td>
                                            <td> <input type="number" min="-50" max="50" Step="0.25" class="input-dioptria TabOlhoDireito PotenciaCilindrica" tabindex="2" /></td>
                                            <td> <input type="number" min="0" max="180" Step="1" class="input-dioptria TabOlhoDireito Eixo" tabindex="3" /></td>
                                            <td> <input type="number" min="0" max="30" Step="0.25" class="input-dioptria TabOlhoDireito Adicao" tabindex="4" /></td>
                                            <td> <input type="number" min="0" max="50" Step="0.5" class="input-dioptria TabOlhoDireito DNP" tabindex="5" /></td>
                                            <td> <input type="number" min="0" max="50" Step="0.25" class="input-dioptria TabOlhoDireito Altura" tabindex="6" /></td>

                                            @If Model.Servico.VerPrismas Then
                                                @<td><input type="number" min="0" max="30" Step="0.5" Class="input-dioptria TabOlhoDireito PotenciaPrismatica" tabindex="7" /></td>
                                                @<td><input type="number" min="0" max="180" Step="1" Class="input-dioptria TabOlhoDireito BasePrismatica" tabindex="8" /></td>
                                            End If

                                            <td> <input type="number" min="0" max="15" Step="0.5" Class="input-dioptria TabOlhoDireito AcuidadeVisual" tabindex="9" /></td>
                                            <td> <input type="number" min="0" max="180" Step="1" Class="input-dioptria TabOlhoDireito AnguloPantoscopico" tabindex="10" /></td>
                                            <td> <input type="number" min="0" max="15" Step="0.1" Class="input-dioptria TabOlhoDireito DistanciaVertex" tabindex="11" /></td>

                                            <td Class="cel-vazia intermed">
                                                <Span Class="txt-linha"> @Traducao.EstruturaDocumentos.Longe</Span>
                                            </td>

                                            <td style="border-left:1px solid #ccc"> <input type="number" min="-50" max="50" Step="0.25" class="input-dioptria TabOlhoEsquerdo PotenciaEsferica" tabindex="34" /></td>
                                            <td> <input type="number" min="-50" max="50" Step="0.25" class="input-dioptria TabOlhoEsquerdo PotenciaCilindrica" tabindex="35" /></td>
                                            <td> <input type="number" min="0" max="180" Step="1" class="input-dioptria TabOlhoEsquerdo Eixo" tabindex="36" /></td>
                                            <td> <input type="number" min="0" max="30" Step="0.25" class="input-dioptria TabOlhoEsquerdo Adicao" tabindex="37" /></td>
                                            <td> <input type="number" min="0" max="50" Step="0.5" class="input-dioptria TabOlhoEsquerdo DNP" tabindex="38" /></td>
                                            <td> <input type="number" min="0" max="50" Step="0.25" class="input-dioptria TabOlhoEsquerdo Altura" tabindex="39" /></td>

                                            @If Model.Servico.VerPrismas Then
                                                @<td><input type="number" min="0" max="30" Step="0.5" Class="input-dioptria TabOlhoEsquerdo PotenciaPrismatica" tabindex="40" /></td>
                                                @<td><input type="number" min="0" max="180" Step="1" Class="input-dioptria TabOlhoEsquerdo BasePrismatica" tabindex="41" /></td>
                                            End If

                                            <td> <input type="number" min="0" max="15" Step="0.5" class="input-dioptria TabOlhoEsquerdo AcuidadeVisual" tabindex="42" /></td>
                                            <td> <input type="number" min="0" max="180" Step="1" class="input-dioptria TabOlhoEsquerdo AnguloPantoscopico" tabindex="43" /></td>
                                            <td> <input type="number" min="0" max="15" Step="0.1" class="input-dioptria TabOlhoEsquerdo DistanciaVertex" tabindex="44" /></td>
                                            <td rowspan="1" class="cel-vazia odoe LblLonge"><span class="fm f3icon-eye"></span><br />@Traducao.EstruturaDocumentos.OE</td>
                                        </tr>

                                        @Code
                                        End If
                                        End Code


                                        @If Model.Servico.VisaoIntermedia Then
                                            @<tr Class="TabInt">
                                                <td rowspan="1" Class="cel-vazia odoe"></td>
                                                <td> <input type="number" min="-50" max="50" Step="0.25" Class="input-dioptria TabOlhoDireito PotenciaEsferica" tabindex="12" /></td>
                                                <td> <input type="number" min="-50" max="50" Step="0.25" Class="input-dioptria TabOlhoDireito PotenciaCilindrica" tabindex="13" /></td>
                                                <td> <input type="number" min="0" max="180" Step="1" Class="input-dioptria TabOlhoDireito Eixo" tabindex="14" /></td>
                                                <td> <input type="number" min="0" max="30" Step="0.25" Class="input-dioptria TabOlhoDireito Adicao" tabindex="15" /></td>
                                                <td> <input type="number" min="0" max="50" Step="0.5" Class="input-dioptria TabOlhoDireito DNP" tabindex="16" /></td>
                                                <td> <input type="number" min="0" max="50" Step="0.25" Class="input-dioptria TabOlhoDireito Altura" tabindex="17" /></td>

                                                @If Model.Servico.VerPrismas Then
                                                    @<td> <input type="number" min="0" max="30" Step="0.5" Class="input-dioptria TabOlhoDireito PotenciaPrismatica" tabindex="18" /></td>
                                                    @<td> <input type="number" min="0" max="180" Step="1" Class="input-dioptria TabOlhoDireito BasePrismatica" tabindex="19" /></td>
                                                End If

                                                <td> <input type="number" min="0" max="15" Step="0.5" class="input-dioptria TabOlhoDireito AcuidadeVisual" tabindex="20" /></td>
                                                <td> <input type="number" min="0" max="180" Step="1" class="input-dioptria TabOlhoDireito AnguloPantoscopico" tabindex="21" /></td>
                                                <td> <input type="number" min="0" max="15" Step="0.1" class="input-dioptria TabOlhoDireito DistanciaVertex" tabindex="22" /></td>
                                                <td class="cel-vazia intermed">
                                                    <Span class="txt-linha tab-span-intermedio"> @Traducao.EstruturaDocumentos.INT</Span>
                                                </td>
                                                <td style="border-left:1px solid #ccc"> <input type="number" min="-50" max="50" Step="0.25" class="input-dioptria TabOlhoEsquerdo PotenciaEsferica" tabindex="45" /></td>
                                                <td> <input type="number" min="-50" max="50" Step="0.25" class="input-dioptria TabOlhoEsquerdo PotenciaCilindrica" tabindex="46" /></td>
                                                <td> <input type="number" min="0" max="180" Step="1" class="input-dioptria TabOlhoEsquerdo Eixo" tabindex="47" /></td>
                                                <td> <input type="number" min="-50" max="50" Step="0.25" class="input-dioptria TabOlhoEsquerdo Adicao" tabindex="48" /></td>
                                                <td> <input type="number" min="0" max="30" Step="0.5" class="input-dioptria TabOlhoEsquerdo DNP" tabindex="49" /></td>
                                                <td> <input type="number" min="0" max="30" Step="0.25" class="input-dioptria TabOlhoEsquerdo Altura" tabindex="50" /></td>

                                                @If Model.Servico.VerPrismas Then
                                                    @<td> <input type="number" min="0" max="30" Step="0.5" Class="input-dioptria TabOlhoEsquerdo PotenciaPrismatica" tabindex="51" /></td>
                                                    @<td> <input type="number" min="0" max="180" Step="1" Class="input-dioptria TabOlhoEsquerdo BasePrismatica" tabindex="52" /></td>
                                                End If
                                                <td> <input type="number" min="0" max="15" Step="0.5" class="input-dioptria TabOlhoEsquerdo AcuidadeVisual" tabindex="53" /></td>
                                                <td> <input type="number" min="0" max="180" Step="1" class="input-dioptria TabOlhoEsquerdo AnguloPantoscopico" tabindex="54" /></td>
                                                <td> <input type="number" min="0" max="15" Step="0.1" class="input-dioptria TabOlhoEsquerdo DistanciaVertex" tabindex="55" /></td>
                                                <td rowspan="1" Class="cel-vazia odoe"></td>
                                            </tr>
                                        End If

                                        @Code
                                            If Model.Servico.IDTipoServico <> TipoServico.Longe Then
                                        End Code

                                        <tr class="TabPerto">
                                            <td rowspan="1" class="cel-vazia odoe LblPerto"><span class="fm f3icon-eye"></span><br />@Traducao.EstruturaDocumentos.OD</td>
                                            <td> <input type="number" min="-50" max="50" Step="0.25" class="input-dioptria TabOlhoDireito PotenciaEsferica" tabindex="23" /></td>
                                            <td> <input type="number" min="-50" max="50" Step="0.25" class="input-dioptria TabOlhoDireito PotenciaCilindrica" tabindex="24" /></td>
                                            <td> <input type="number" min="0" max="180" Step="1" class="input-dioptria TabOlhoDireito Eixo" tabindex="25" /></td>
                                            <td> <input type="number" min="0" max="30" Step="0.25" class="input-dioptria TabOlhoDireito Adicao" tabindex="26" /></td>
                                            <td> <input type="number" min="0" max="50" Step="0.5" class="input-dioptria TabOlhoDireito DNP" tabindex="27" /></td>
                                            <td> <input type="number" min="0" max="50" Step="0.25" class="input-dioptria TabOlhoDireito Altura" tabindex="28" /></td>

                                            @If Model.Servico.VerPrismas Then
                                                @<td> <input type="number" min="0" max="30" Step="0.5" Class="input-dioptria TabOlhoDireito PotenciaPrismatica" tabindex="29" /></td>
                                                @<td> <input type="number" min="0" max="180" Step="1" Class="input-dioptria TabOlhoDireito BasePrismatica" tabindex="30" /></td>
                                            End If

                                            <td> <input type="number" min="0" max="15" Step="0.5" class="input-dioptria TabOlhoDireito AcuidadeVisual" tabindex="31" /></td>
                                            <td> <input type="number" min="0" max="180" Step="1" class="input-dioptria TabOlhoDireito AnguloPantoscopico" tabindex="32" /></td>
                                            <td> <input type="number" min="0" max="15" Step="0.1" class="input-dioptria TabOlhoDireito DistanciaVertex" tabindex="33" /></td>

                                            <td class="cel-vazia intermed">
                                                <Span class="txt-linha"> @Traducao.EstruturaDocumentos.Perto</Span>
                                            </td>
                                            <td style="border-left:1px solid #ccc"><input type="number" min="-50" max="50" Step="0.25" class="input-dioptria TabOlhoEsquerdo PotenciaEsferica" tabindex="56" /></td>
                                            <td> <input type="number" min="-50" max="50" Step="0.25" class="input-dioptria TabOlhoEsquerdo PotenciaCilindrica" tabindex="57" /></td>
                                            <td> <input type="number" min="0" max="180" Step="1" class="input-dioptria TabOlhoEsquerdo Eixo" tabindex="58" /></td>
                                            <td> <input type="number" min="0" max="30" Step="0.25" class="input-dioptria TabOlhoEsquerdo Adicao" tabindex="59" /></td>
                                            <td> <input type="number" min="0" max="50" Step="0.5" class="input-dioptria TabOlhoEsquerdo DNP" tabindex="60" /></td>
                                            <td> <input type="number" min="0" max="50" Step="0.25" class="input-dioptria TabOlhoEsquerdo Altura" tabindex="61" /></td>

                                            @If Model.Servico.VerPrismas Then
                                                @<td> <input type="number" min="0" max="30" Step="0.5" Class="input-dioptria TabOlhoEsquerdo PotenciaPrismatica" tabindex="62" /></td>
                                                @<td> <input type="number" min="0" max="180" Step="1" Class="input-dioptria TabOlhoEsquerdo BasePrismatica" tabindex="63" /></td>
                                            End If

                                            <td> <input type="number" min="0" max="15" Step="0.5" class="input-dioptria TabOlhoEsquerdo AcuidadeVisual" tabindex="64" /></td>
                                            <td> <input type="number" min="0" max="180" Step="1" class="input-dioptria TabOlhoEsquerdo AnguloPantoscopico" tabindex="65" /></td>
                                            <td> <input type="number" min="0" max="15" Step="0.1" class="input-dioptria TabOlhoEsquerdo DistanciaVertex" tabindex="66" /></td>
                                            <td rowspan="1" class="cel-vazia odoe LblPerto"><span class="fm f3icon-eye"></span><br />@Traducao.EstruturaDocumentos.OE</td>
                                        </tr>

                                        @Code
                                        End If
                                        End Code
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        @Code
                        End If
                        End Code
                    </div>
                </div>
            </div>
        </div>
        @* LOADING *@
        @Html.Partial(F3MBarLoading)
        <div class="@(ConstHT.ClassesHT.Container)">
            <div id="hdsnArtigos"></div>
        </div>
    </div>
</div>