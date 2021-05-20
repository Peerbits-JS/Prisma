Imports CsvHelper
Imports CsvHelper.Configuration

Public Class DocumentosStockContagemArtigoImportacao
    Public Property Codigo As String
    Public Property Quantidade As Double
    Public Property Lote As String
End Class

Public Class DocumentosStockContagemArtigoImportacaoMap
    Inherits ClassMap(Of DocumentosStockContagemArtigoImportacao)

    Sub New()
        AutoMap()
        Map(Function(x) x.Quantidade).Default(1)
    End Sub
End Class



