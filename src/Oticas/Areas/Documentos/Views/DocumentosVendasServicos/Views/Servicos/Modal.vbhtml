@Imports F3M.Modelos.Autenticacao
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Modulos
<!-- Modal -->
<div id="modal-adiciona-subservico" class="modal bd-example-modal-sm f3m-modal-bts" role="dialog" data-keyboard="false" data-backdrop="static">
    <div class="modal-dialog modal-sm modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header f3m-modal-bts__header">
                <button id="closeModalSubServicos" type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body f3m-modal-bts__body">
                <div id="ToggleServico" class="btn-group btn-group-toggle float-left mb-3 w-100" data-toggle="buttons">
                    <label class="btn btn-line btn-sm active">
                        <input type="radio" name="ServicoLCO" id="ServicoO" autocomplete="off"> @Traducao.EstruturaDocumentos.Oculos
                    </label>
                    <label class="btn btn-line btn-sm">
                        <input type="radio" name="ServicoLCO" id="ServicoLC" autocomplete="off"> @Traducao.EstruturaDocumentos.LentesContato
                    </label>
                </div>
                <div class="container-fluid p-0">
                    <div class="row">
                        <div class="col-12" id="radiosTipoServico">
                            <div class="col-6 radio-submenu">
                                <div class="radio-button float-none">
                                    <input type="radio" id="TSUnifocal" name="TipoServico" value="Unifocal" checked />
                                    <label for="TSUnifocal" class="radio-label">@Traducao.EstruturaDocumentos.Unifocal</label>
                                </div>
                                <div class="radio-button float-none">
                                    <input type="radio" id="TSBifocal" name="TipoServico" value="Bifocal" />
                                    <label for="TSBifocal" class="radio-label">@Traducao.EstruturaDocumentos.Bifocal</label>
                                </div>
                                <div class="radio-button float-none">
                                    <input type="radio" id="TSProgressiva" name="TipoServico" value="Progressiva" />
                                    <label for="TSProgressiva" class="radio-label">@Traducao.EstruturaDocumentos.Progressiva</label>
                                </div>
                            </div>
                            <div class="col-6 radio-submenu">
                                <div class="radio-button float-none">
                                    <input type="radio" id="IDLongePerto" name="TipoServicoOlho" value="LongePerto" checked />
                                    <label for="IDLongePerto" class="radio-label">@Traducao.EstruturaDocumentos.LongePerto</label>
                                </div>
                                <div class="radio-button float-none">
                                    <input type="radio" id="IDLonge" name="TipoServicoOlho" value="Longe" />
                                    <label for="IDLonge" class="radio-label">@Traducao.EstruturaDocumentos.Longe</label>
                                </div>
                                <div class="radio-button float-none">
                                    <input type="radio" id="IDPerto" name="TipoServicoOlho" value="Perto" />
                                    <label for="IDPerto" class="radio-label">@Traducao.EstruturaDocumentos.Perto</label>
                                </div>
                                <div class="radio-button float-none disabled">
                                    <input type="radio" id="IDAmbos" name="TipoServicoOlho" value="Ambos" disabled />
                                    <label for="IDAmbos" class="radio-label">@Traducao.EstruturaDocumentos.Ambos</label>
                                </div>
                                <div class="radio-button float-none disabled">
                                    <input type="radio" id="IDOE" name="TipoServicoOlho" value="OlhoEsquerdo" disabled />
                                    <label for="IDOE" class="radio-label">@Traducao.EstruturaDocumentos.OE</label>
                                </div>
                                <div class="radio-button float-none disabled">
                                    <input type="radio" id="IDOD" name="TipoServicoOlho" value="OlhoDireito" disabled />
                                    <label for="IDOD" class="radio-label">@Traducao.EstruturaDocumentos.OD</label>
                                </div>
                            </div>
                        </div>
                        <div class="col-12 mt-2">
                            @Code
                                Html.F3M().DesenhaCampo(New ClsF3MCampo With {.Id = "CombinacaoDefeito",
                                                                                .Label = Traducao.EstruturaDocumentos.CombinacaoDefeito,
                                                                                .Modelo = Model.Modelo,
                                                                                .TipoEditor = Mvc.Componentes.F3MCheckBoxBootstrap,
                                                                                .ViewClassesCSS = {"f3m-checkbox-sem-top"}})
                            End Code
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button id="adicionaSubServico" type="button" class="btn main-btn">Confirmar</button>
            </div>
        </div>
    </div>
</div>