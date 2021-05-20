@Imports F3M.Modelos.Constantes
@Imports F3M.Modelos.Grelhas
@Imports F3M.Modelos.ConstantesKendo
@Code
    @Scripts.Render("~/bundles/f3m/jsTabelasAuxiliaresMarcas")

    Layout = URLs.SharedLayoutTabelas
    Dim grid As Fluent.GridBuilder(Of Marcas)
    Dim listaCol = New List(Of ClsF3MCampo)

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Codigo, .LarguraColuna = 150})

    listaCol.Add(New ClsF3MCampo With {.Id = CamposGenericos.Descricao, .LarguraColuna = 200})

    listaCol.Add(New ClsF3MCampo With {
        .Id = "IDSegmentoMarca",
        .Label = Traducao.EstruturaAplicacaoTermosBase.SegmentoMarca,
        .TipoEditor = Mvc.Componentes.F3MDropDownList,
        .Controlador = "../TabelasAuxiliares/SegmentosMarcas",
        .EObrigatorio = False,
        .EChaveEstrangeira = True,
        .LarguraColuna = 150
    })

    Dim gf As New ClsMvcKendoGrid With {
.Tipo = New Marcas().GetType,
.CamposOrdenar = New Dictionary(Of String, String) From {{CamposGenericos.Descricao, "asc"}},
.FuncaoJavascriptGridEdit = "MarcasEditaGrelha",
.Campos = listaCol}

    grid = Html.F3M().Grelha(Of Marcas)(gf)

    With grid
        If Not (Me.Context.Request.QueryString("IDDrillDown") IsNot Nothing AndAlso Me.Context.Request.QueryString("IDDrillDown") <> 0) Then
            .DataSource(Function(ds) ds.Ajax.Filter(Function(ft) ft.Add(Function(model) model.Ativo).IsEqualTo(True)))
        End If
    End With

    gf.GrelhaHTML = grid.ToHtmlString()

    @Html.Partial(gf.PartialViewInterna, gf)
End Code