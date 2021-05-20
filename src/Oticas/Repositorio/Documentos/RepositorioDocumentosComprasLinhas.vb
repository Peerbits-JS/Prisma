Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Repositorio
Imports F3M.Repositorio.DocumentosComum

Namespace Repositorio.Documentos
    Public Class RepositorioDocumentosComprasLinhas
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbDocumentosComprasLinhas, DocumentosComprasLinhas)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of DocumentosComprasLinhas)
            Return RepositorioDocComprasLinhas.Lista(Of tbDocumentosComprasLinhas, DocumentosComprasLinhas)(BDContexto, inFiltro, True)
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of DocumentosComprasLinhas)
            Return RepositorioDocComprasLinhas.ListaCombo(Of tbDocumentosComprasLinhas, DocumentosComprasLinhas)(BDContexto, inFiltro, True)
        End Function
#End Region

#Region "ESCRITA"
#End Region
    End Class
End Namespace