Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Repositorio
Imports F3M.Repositorio.DocumentosComum

Namespace Repositorio.Documentos
    Public Class RepositorioDocumentosComprasLinhasDimensoes
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbDocumentosComprasLinhasDimensoes, Oticas.DocumentosComprasLinhasDimensoes)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of Oticas.DocumentosComprasLinhasDimensoes)
            Return RepositorioDocComprasLinhasDims.Lista(
                Of tbDocumentosComprasLinhasDimensoes, Oticas.DocumentosComprasLinhasDimensoes)(BDContexto, inFiltro, True)
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of Oticas.DocumentosComprasLinhasDimensoes)
            Return RepositorioDocComprasLinhasDims.ListaCombo(
                Of tbDocumentosComprasLinhasDimensoes, Oticas.DocumentosComprasLinhasDimensoes)(BDContexto, inFiltro, True)
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace