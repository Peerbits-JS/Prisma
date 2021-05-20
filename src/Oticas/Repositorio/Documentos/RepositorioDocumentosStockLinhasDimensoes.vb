Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Repositorio
Imports F3M.Repositorio.DocumentosComum

Namespace Repositorio.Documentos
    Public Class RepositorioDocumentosStockLinhasDimensoes
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbDocumentosStockLinhasDimensoes, Oticas.DocumentosStockLinhasDimensoes)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of Oticas.DocumentosStockLinhasDimensoes)
            Return RepositorioDocStockLinhasDims(Of tbDocumentosStockLinhasDimensoes, Oticas.DocumentosStockLinhasDimensoes).
                ListaTudoMOD(BDContexto, inFiltro, True)
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of Oticas.DocumentosStockLinhasDimensoes)
            Return RepositorioDocStockLinhasDims(Of tbDocumentosStockLinhasDimensoes, Oticas.DocumentosStockLinhasDimensoes).
                ListaTudoMOD(BDContexto, inFiltro, True, True)
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace