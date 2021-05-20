@Modeltype HistoricoExamesGrids

@Code
    'SET PRIVATE VARS
    Dim _ModelGrid As List(Of HistoricoExamesAccordionsInfo) = Model.ModelAccordion
    'SET HEADERS / ROWS CODE
    If String.IsNullOrEmpty(Model.HeadersCode) Then Model.HeadersCode = Model.GridCode
    If String.IsNullOrEmpty(Model.RowsCode) Then Model.RowsCode = Model.GridCode
    'GET TITULO DA GRELHA
    Dim Titulo As String = Model.Title
    If String.IsNullOrEmpty(Titulo) Then
        Titulo = _ModelGrid.Where(Function(w) Not w.IDElemento Is Nothing AndAlso w.IDElemento = Model.GridCode & "_MAIN_CAPTION").FirstOrDefault.Label
    End If
    'GET HEADERS
    Dim Headers As String() = _ModelGrid.Where(Function(w)
                                                   Return Not w.IDElemento Is Nothing AndAlso w.IDElemento.Contains(Model.HeadersCode & "_MAIN_TH")
                                               End Function).OrderBy(Function(o) o.Ordem).Select(Function(s) s.Label).ToArray()
    'GET ROWS
    Dim Rows As Integer = _ModelGrid.Where(Function(w)
                                               Return Not w.IDElemento Is Nothing AndAlso w.IDElemento.Contains(Model.RowsCode & "_TR")
                                           End Function).Select(Function(S) S.IDElemento.Split("_")(5)).ToArray().Max

    'DESENHA GRELHA
    @<table class="historico table table-sm table-striped">
        @If Not String.IsNullOrEmpty(Titulo) Then
            @<caption Class="caption">@Titulo</caption>
        End If
        <thead>
            <tr>
                @Code
                    If Model.PrimeiraColunaHeaderVazia Then
                        @<th></th>
                    End If

                    @For Each header As String In Headers
                        @<th>@header</th>
                    Next
                End Code
            </tr>
        </thead>
        <tbody>
            @Code
                For intCiclo As Integer = 1 To Rows
                    @<tr>
                        @Code
                            Dim _subGridTds As List(Of TD) = _ModelGrid.Where(Function(w)
                                                                                  Return Not w.IDElemento Is Nothing AndAlso
                                                                                  w.IDElemento.Contains(Model.RowsCode & "_TR_" & intCiclo)
                                                                              End Function).OrderBy(Function(o)
                                                                                                        Return CInt(o.IDElemento.Split("_")(7))
                                                                                                    End Function).Select(Function(s)
                                                                                                                             Dim td As New TD

                                                                                                                             With td
                                                                                                                                 .Text = s.ValorID
                                                                                                                                 If String.IsNullOrEmpty(.Text) Then .Text = s.Label

                                                                                                                                 .ViewClassesCSS = s.ViewClassesCSS
                                                                                                                             End With

                                                                                                                             Return td
                                                                                                                         End Function).ToList

                            Dim _width As String = (CDbl((1 / (_subGridTds.Count + Model.EmptyLastColsExtra)) * 100) & "%").Replace(",", ".")
                            For Each td As TD In _subGridTds
                                @<td class="@td.ViewClassesCSS" style="width: @_width">@td.Text</td>
                            Next

                            For intCiclo2 As Integer = 1 To Model.EmptyLastColsExtra
                                @<td style="width: @_width">---</td>
                            Next
                        End Code
                    </tr>
                            Next
            End Code
        </tbody>
    </table>
End Code