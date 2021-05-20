@Imports F3M.Modelos.Constantes

@ModelType F3M.Modelos.Grelhas.ClsMvcKendoGrid

@Code
    If Model.Campos IsNot Nothing Then
        Dim campoDiametro = Model.Campos.Where(Function(c) c.Id = "Diametro").FirstOrDefault
        Dim campoRaio = Model.Campos.Where(Function(c) c.Id = "Raio").FirstOrDefault
        Dim campoPotenciaEsferica = Model.Campos.Where(Function(c) c.Id = "PotenciaEsfericaTransposta").FirstOrDefault
        Dim campoPotenciaCilindrica = Model.Campos.Where(Function(c) c.Id = "PotenciaCilindricaTransposta").FirstOrDefault

        If campoDiametro IsNot Nothing Then campoDiametro.Alinhamento = AlinhamentoColuna.Direita
        If campoRaio IsNot Nothing Then campoRaio.Alinhamento = AlinhamentoColuna.Direita
        If campoPotenciaEsferica IsNot Nothing Then campoPotenciaEsferica.Alinhamento = AlinhamentoColuna.Direita
        If campoPotenciaCilindrica IsNot Nothing Then campoPotenciaCilindrica.Alinhamento = AlinhamentoColuna.Direita
    End If

    Dim grid As Fluent.GridBuilder(Of Artigos)

    If Not Model.OrigemF4.IsEmpty Then
        Model.FuncaoJavascriptGridDataBound = "GrelhaParaGrelhaFormDataBound"

        If Model.OrigemF4.Equals(GetType(Oticas.DocumentosVendasServicos).Name.ToLower) Then
            Model.FuncaoJavascriptEnviaParams = "window.parent.$servicos.ajax.EnviaParametrosArtigos"

        ElseIf Model.OrigemF4 = GetType(Oticas.DocumentosVendasServicosSubstituicao).Name.ToLower Then
            Model.FuncaoJavascriptEnviaParams = "window.parent.$docsservicossubstituicaoartigos.ajax.EnviaParametrosArtigosF4"
        End If

        grid = Html.F3M().Grelha(Of Oticas.Artigos)(Model)

    Else
        grid = Html.F3M().GrelhaFormulario(Of Oticas.Artigos)(Model)
    End If

    With grid
        If Not (Me.Context.Request.QueryString("IDDrillDown") IsNot Nothing AndAlso Me.Context.Request.QueryString("IDDrillDown") <> 0) Then
            .DataSource(Function(ds) ds.Ajax.Filter(Function(ft) ft.Add(Function(model) model.Ativo).IsEqualTo(True)))
        End If
        .Render()
    End With
End Code