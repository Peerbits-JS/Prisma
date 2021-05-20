@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.ConstantesKendo
@ModelType F3M.Modelos.Grelhas.ClsMvcKendoGrid
@Code
    Model.ControladorCustomizavel = GetType(Oticas.DocumentosVendasServicos).Name

    ' Verifica se existe coluna Descricao
    Dim campoDesc As ClsF3MCampo = Model.Campos.Where(Function(f) f.Id.Equals(CamposGenericos.Descricao)).FirstOrDefault

    If campoDesc IsNot Nothing Then
        campoDesc.LarguraColuna = 300
    End If

    ' Verifica se existe coluna Data Documento e atribui o tipo
    Dim campoDataDoc As ClsF3MCampo = Model.Campos.Where(Function(f) f.Id.Equals(CamposGenericos.DataDocumento)).FirstOrDefault

    If campoDataDoc IsNot Nothing Then
        campoDataDoc.TipoEditor = Mvc.Componentes.F3MData
    End If

    Model.CamposOrdenar = New Dictionary(Of String, String) From {{CamposGenericos.DataDocumento, "desc"}}
    Model.Campos.Add(New ClsF3MCampo With {.Id = CamposGenericos.Ativo,
        .EVisivel = False})

    If Not Model.OrigemF4.IsEmpty Then
        Html.F3M().Grelha(Of Oticas.DocumentosVendasServicos)(Model).Render()
    Else
        ' COMPRIMIR MODELO (PARA SERVIDOR E CLIENTE)
        Model.FuncaoJavascriptEnviaParams = "FuncaoJavascriptEnviaParamsEspecifica"

        Html.F3M().GrelhaFormulario(Of Oticas.DocumentosVendasServicos)(Model).Render()
    End If
End Code

<script>
    var VemDeHistorico = false;

    function FuncaoJavascriptEnviaParamsEspecifica(objetoFiltro) {

        if (sessionStorage.getItem('ExecutouAbreTab') || VemDeHistorico) {
            objetoFiltro['CamposFiltrar']['IgnoraAcessoPorLoja'] = { 'CampoValor': 'true', 'CampoTexto': 'true' };
            objetoFiltro['CamposFiltrar']['FromHistorico'] = { 'CampoValor': 'true', 'CampoTexto': 'true' };
            VemDeHistorico = true;
            sessionStorage.removeItem('ExecutouAbreTab');
        }

        return objetoFiltro;
    }
</script>