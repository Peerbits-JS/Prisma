@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo

@Scripts.Render("~/bundles/f3m/jsExames")

@Code
    Dim atrHTML As New Dictionary(Of String, Object) From {{"class", CssClasses.InputF3M}}

    Html.F3M().Hidden(CamposGenericos.ID, Model.ID, atrHTML)
    Html.F3M().Hidden(CamposGenericos.AcaoFormulario, Model.AcaoFormulario, atrHTML)
End Code



<div class="@(ClassesCSS.FormPrincLDirComBt)">
    <div class="FormularioAjudaScroll">
        <div class="container-fluid">
            @Html.Partial("~/Areas/Exames/Views/Templates/Cabecalho/Cabecalho.vbhtml", Model)

            <div id="main-content" class="tabs-exames">
                <div role="tabpanel" class="f3m-tabs clsF3MTabs">
                    <ul class="nav nav-pills f3m-tabs__ul clsAreaFixed" role="tablist">
                        <li role="presentation" class="in nav-item"><a href="#tab_66" class="nav-link active" role="tab" data-toggle="tab" aria-expanded="false">Anamnese</a></li>
                        <li role="presentation" class="nav-item"><a href="#tab_188" class="nav-link" role="tab" data-toggle="tab" aria-expanded="false">Graduação Atual</a></li>
                        <li role="presentation" class="nav-item"><a href="#tab_493" class="nav-link" role="tab" data-toggle="tab" aria-expanded="false">Resultados Final</a></li>
                        <li role="presentation" class="nav-item"><a href="#tab_67" class="nav-link" role="tab" data-toggle="tab" aria-expanded="false">Observações</a></li>
                    </ul>
                    <div class="tab-content">
                        <div id="tab_66" role="tabpanel" class="tab-pane fade show active">

                            <div class="row">
                                <div class="col-3">
                                    <div class="card-title titulo-sec-tab">MOTIVO DA CONSULTA</div>
                                    <div class="clearfix card-body">
                                        <div class="arrayChecks">
                                            <div class="divCheckBoxBootstrap alinhamentoesquerda clsF3MCampo">
                                                <div class="checkbox">
                                                    <label><input type="checkbox" class="clsF3MInput" name="Rotina" id="Rotina">Rotina</label>
                                                </div>
                                            </div>
                                            <div class="divCheckBoxBootstrap alinhamentoesquerda clsF3MCampo">
                                                <div class="checkbox">
                                                    <label><input type="checkbox" class="clsF3MInput" name="Rotina" id="Rotina">Rastreio visual</label>
                                                </div>
                                            </div>
                                            <div class="divCheckBoxBootstrap alinhamentoesquerda clsF3MCampo">
                                                <div class="checkbox">
                                                    <label><input type="checkbox" class="clsF3MInput" name="Rotina" id="Rotina">Dificuldade em VL</label>
                                                </div>
                                            </div>
                                            <div class=" divCheckBoxBootstrap alinhamentoesquerda clsF3MCampo">
                                                <div class="checkbox">
                                                    <label><input type="checkbox" class="clsF3MInput" name="Rotina" id="Rotina">Dificuldade em VP</label>
                                                </div>
                                            </div>
                                            <div class=" divCheckBoxBootstrap alinhamentoesquerda clsF3MCampo">
                                                <div class="checkbox">
                                                    <label><input type="checkbox" class="clsF3MInput" name="Rotina" id="Rotina">Experimentar LC</label>
                                                </div>
                                            </div>
                                            <div class="card-bottom-outros">
                                                <hr />
                                                <div class="divTextArea alinhamentoesquerda clsF3MCampo">
                                                    <label for="OB" class="" textolabelrequired="">Outro</label>
                                                    <textarea id="OB" data-role="text-area" name="OB" class="textarea-form clsF3MInput clsF3MTextArea textarea-input alinhamentoesquerda " maxlength="8000"></textarea>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-3">
                                    <div class="card-title titulo-sec-tab">DORES DE CABEÇA</div>
                                    <div class="clearfix card-body">
                                        <div class="arrayChecks">
                                            <div class="divCheckBoxBootstrap alinhamentoesquerda clsF3MCampo">
                                                <div class="checkbox">
                                                    <label><input type="checkbox" class="clsF3MInput" name="Rotina" id="Rotina">Logo pela manhã</label>
                                                </div>
                                            </div>
                                            <div class="divCheckBoxBootstrap alinhamentoesquerda clsF3MCampo">
                                                <div class="checkbox">
                                                    <label><input type="checkbox" class="clsF3MInput" name="Rotina" id="Rotina">Vão piorando</label>
                                                </div>
                                            </div>
                                            <hr />
                                            <div class=" divCheckBoxBootstrap alinhamentoesquerda clsF3MCampo">
                                                <div class="checkbox">
                                                    <label><input type="checkbox" class="clsF3MInput" name="Rotina" id="Rotina">Frontal</label>
                                                </div>
                                            </div>
                                            <div class=" divCheckBoxBootstrap alinhamentoesquerda clsF3MCampo">
                                                <div class="checkbox">
                                                    <label><input type="checkbox" class="clsF3MInput" name="Rotina" id="Rotina">Ocipital</label>
                                                </div>
                                            </div>
                                            <div class=" divCheckBoxBootstrap alinhamentoesquerda clsF3MCampo">
                                                <div class="checkbox">
                                                    <label><input type="checkbox" class="clsF3MInput" name="Rotina" id="Rotina">Temporal</label>
                                                </div>
                                            </div>
                                            <hr />
                                            <div class="divCheckBoxBootstrap alinhamentoesquerda clsF3MCampo">
                                                <div class="checkbox">
                                                    <label><input type="checkbox" class="clsF3MInput" name="Rotina" id="Rotina">Sem padrão</label>
                                                </div>
                                            </div>
                                            <div class="card-bottom-outros">
                                                <hr />

                                                <div class="divTextArea alinhamentoesquerda clsF3MCampo">
                                                    <label for="OB" class="" textolabelrequired="">Outro</label>
                                                    <textarea id="OB" data-role="text-area" name="OB" class="textarea-form clsF3MInput clsF3MTextArea textarea-input alinhamentoesquerda " maxlength="8000"></textarea>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-3">
                                    <div class="card-title titulo-sec-tab">SAÚDE GERAL</div>
                                    <div class="clearfix card-body">
                                        <div class="arrayChecks">
                                            <div class="divCheckBoxBootstrap alinhamentoesquerda clsF3MCampo">
                                                <div class="checkbox">
                                                    <label><input type="checkbox" class="clsF3MInput" name="Rotina" id="Rotina">Diabetes - Tipo I</label>
                                                </div>
                                            </div>
                                            <div class="divCheckBoxBootstrap alinhamentoesquerda clsF3MCampo">
                                                <div class="checkbox">
                                                    <label><input type="checkbox" class="clsF3MInput" name="Rotina" id="Rotina">Diabetes - Tipo II</label>
                                                </div>
                                            </div>
                                            <div class="divCheckBoxBootstrap alinhamentoesquerda clsF3MCampo">
                                                <div class="checkbox">
                                                    <label><input type="checkbox" class="clsF3MInput" name="Rotina" id="Rotina">Hipertensão arterial</label>
                                                </div>
                                            </div>
                                            <div class="divCheckBoxBootstrap alinhamentoesquerda clsF3MCampo">
                                                <div class="checkbox">
                                                    <label><input type="checkbox" class="clsF3MInput" name="Rotina" id="Rotina">Colesterol</label>
                                                </div>
                                            </div>
                                            <div class=" divCheckBoxBootstrap alinhamentoesquerda clsF3MCampo">
                                                <div class="checkbox">
                                                    <label><input type="checkbox" class="clsF3MInput" name="Rotina" id="Rotina">Alterações cardíacas</label>
                                                </div>
                                            </div>
                                            <hr />
                                            <div class=" divCheckBoxBootstrap alinhamentoesquerda clsF3MCampo">
                                                <div class="checkbox">
                                                    <label><input type="checkbox" class="clsF3MInput" name="Rotina" id="Rotina">Catarata</label>
                                                </div>
                                            </div>
                                            <div class=" divCheckBoxBootstrap alinhamentoesquerda clsF3MCampo">
                                                <div class="checkbox">
                                                    <label><input type="checkbox" class="clsF3MInput" name="Rotina" id="Rotina">Hipertensão ocular</label>
                                                </div>
                                            </div>
                                            <div class=" divCheckBoxBootstrap alinhamentoesquerda clsF3MCampo">
                                                <div class="checkbox">
                                                    <label><input type="checkbox" class="clsF3MInput" name="Rotina" id="Rotina">Glaucoma</label>
                                                </div>
                                            </div>
                                            <div class=" divCheckBoxBootstrap alinhamentoesquerda clsF3MCampo">
                                                <div class="checkbox">
                                                    <label><input type="checkbox" class="clsF3MInput" name="Rotina" id="Rotina">Miopia/Astigmatismo </label>
                                                </div>
                                            </div>
                                            <div class="card-bottom-outros">
                                                <hr />
                                                <div class="divTextArea alinhamentoesquerda clsF3MCampo">
                                                    <label for="OBG" class="" textolabelrequired="">Outro</label>
                                                    <textarea id="OBG" data-role="text-area" name="OBG" class="textarea-form clsF3MInput clsF3MTextArea textarea-input alinhamentoesquerda " maxlength="8000"></textarea>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>


                                <div class="col-3">
                                    <div class="card-title titulo-sec-tab">HISTÓRIA CLÍNICA</div>
                                    <div class="clearfix card-body">
                                        <div class="arrayChecks">
                                            <div class="divTextArea alinhamentoesquerda clsF3MCampo">
                                                <label for="OBG" class="" textolabelrequired="">Antecedentes familiares</label>
                                                <textarea id="OBG" data-role="text-area" name="OBG" class="textarea-form textarea-alt clsF3MInput clsF3MTextArea textarea-input alinhamentoesquerda " maxlength="8000"></textarea>
                                            </div>
                                            <hr />
                                            <div class="divTextArea alinhamentoesquerda clsF3MCampo">
                                                <label for="OBG" class="" textolabelrequired="">Medicação</label>
                                                <textarea id="OBG" data-role="text-area" name="OBG" class="textarea-form textarea-alt clsF3MInput clsF3MTextArea textarea-input alinhamentoesquerda " maxlength="8000"></textarea>
                                            </div>
                                            <div class="card-bottom-outros">
                                                <hr />
                                                <div class="divTextArea alinhamentoesquerda clsF3MCampo">
                                                    <label for="OBG" class="" textolabelrequired="">Outro</label>
                                                    <textarea id="OBG" data-role="text-area" name="OBG" class="textarea-form clsF3MInput clsF3MTextArea textarea-input alinhamentoesquerda " maxlength="8000"></textarea>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>


                        <div id="tab_188" role="tabpanel" class="tab-pane fade">

                            <style>
                                .table-ocl-lc {
                                    background-color: whitesmoke;
                                    border-radius: 3px;
                                    margin-bottom: 30px;
                                    border-width: 1px;
                                    border-style: solid;
                                    border-color: rgb(210, 210, 210);
                                    padding: 8px 5px 5px 0;
                                    box-shadow: rgba(0, 0, 0, 0.15) 0px 3px 8px;
                                }

                                .table {
                                    margin-bottom: 0;
                                }

                                    .table .table-titulos {
                                        background-color: whitesmoke;
                                        border-radius: 4px;
                                    }

                                    .table > tbody > tr > td, .table > tbody > tr > th, .table > tfoot > tr > td, .table > tfoot > tr > th, .table > thead > tr > td, .table > thead > tr > th {
                                        vertical-align: middle;
                                        text-align: center;
                                        border-top: none;
                                    }

                                    .table > thead > tr > th {
                                        border: none;
                                        font-size: 15px;
                                    }

                                    .table td.rotate-90g {
                                        transform: rotate(-90deg);
                                        font-size: 14px;
                                        letter-spacing: 3px;
                                        font-weight: bold;
                                    }

                                table .input-group-lg > .form-control {
                                    height: 40px;
                                    padding: 5px 8px;
                                    font-size: 14px;
                                    text-align: center;
                                }

                                table .input-group-lg > .input-group-btn > .btn {
                                    padding: 0px 10px;
                                    height: 38px;
                                }

                                .table .titulo-ocl-lc {
                                    background-color: rgb(210, 210, 210);
                                    min-width: 103px;
                                    border-radius: 0 30px 30px 0;
                                    min-width: 103px;
                                }
                            </style>

                            <!--TABLE PARA OS ÓCULOS-->
                            <div class="table-responsive table-ocl-lc">
                                <table class="table table-sm">
                                    <thead>
                                        <tr class="table-titulos">
                                            <th colspan="2" class="titulo-ocl-lc">ÓCULOS</th>
                                            <th>ESF</th>
                                            <th>CIL</th>
                                            <th>AX</th>
                                            <th>ADD</th>
                                            <th>PRISM</th>
                                            <th>AV</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <!--oculos longe-->
                                        <tr>
                                            <td rowspan="2" class="rotate-90g">LONGE</td>
                                            <td><strong>OD</strong></td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><strong>OE</strong></td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>
                                        <!--oculos perto-->
                                        <tr>
                                            <td rowspan="2" class="rotate-90g">PERTO</td>
                                            <td><strong>OD</strong></td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td><strong>OE</strong></td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div><!--END TABLE PARA OS ÓCULOS-->
                            <!--TABLE PARA OS LENTES CONTACCTO-->
                            <div class="table-responsive table-ocl-lc">
                                <table class="table table-sm">
                                    <thead>
                                        <tr>
                                            <th class="titulo-ocl-lc">LC</th>
                                            <th style="font-size:18px">&oslash;</th>
                                            <th>RC</th>
                                            <th>ESF</th>
                                            <th>CIL</th>
                                            <th>AX</th>
                                            <th>ADD</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td class="alinhamentodireita"><strong>OD</strong></td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="alinhamentodireita"><strong>OE</strong></td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                            <td>
                                                <div class="input-group input-group-lg">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-down"></span></button>
                                                    </span>
                                                    <input type="number" class="form-control">
                                                    <span class="input-group-btn">
                                                        <button class="btn btn-secondary" type="button"><span class="fm f3icon-angle-up"></span></button>
                                                    </span>
                                                </div>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div><!--END TABLE PARA OS ÓCULOS-->


                            <div class="clsF3MCampo">
                                <label for="OBF" class="" textolabelrequired="">Observações</label>
                                <textarea id="OBF" data-role="text-area" name="OBF" class="textarea-form clsF3MInput clsF3MTextArea textarea-input alinhamentoesquerda " maxlength="8000"></textarea>
                            </div>

                        </div> <!-- END TAB OCULOS/LC-->

                        <div id="tab_67" role="tabpanel" class="tab-pane fade">
                            <div class="obs-holder">
                                <div class=" divTextArea alinhamentoesquerda clsF3MCampo">
                                    <label for="Obs" class="" textolabelrequired="">Observações</label>
                                    <script>lookupTextAreaLimpaDivWindow('ObsJanela')</script><a id="textosbase" class="import-txt btn main-btn f3m-btn-xs" onclick="lookupTextArea('ObsJanela');"><span class="fm f3icon-import"></span> Textos Base</a><textarea campovalor="Texto" id="Obs" data-role="text-area" name="Obs" class="textarea-form clsF3MInput clsF3MTextArea alinhamentoesquerda " maxlength="8000"></textarea>
                                    <script>kendo.syncReady(function () { jQuery("#ObsJanela").kendoWindow({ "open": function (e) { janelaAbrir(e, '../TabelasAuxiliares/TextosBase/IndexGrelha', true) }, "refresh": function (e) { janelaRefrescar(e, 'ObsJanela', true) }, "modal": true, "iframe": true, "draggable": true, "scrollable": false, "pinned": false, "title": "", "resizable": false, "width": 800, "height": 500, "actions": ["Maximize", "Close"] }); });</script>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>