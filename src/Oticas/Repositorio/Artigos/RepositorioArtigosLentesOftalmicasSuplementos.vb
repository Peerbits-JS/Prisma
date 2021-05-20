Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.Artigos
    Public Class RepositorioArtigosLentesOftalmicasSuplementos
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbLentesOftalmicasSuplementos, ArtigosLentesOftalmicasSuplementos)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbLentesOftalmicasSuplementos)) As IQueryable(Of ArtigosLentesOftalmicasSuplementos)
            Return query.Select(Function(e) New ArtigosLentesOftalmicasSuplementos With {
                .ID = e.ID,
                .IDLenteOftalmica = e.IDLenteOftalmica, .IDSuplementoLente = e.IDSuplementoLente, .DescricaoSuplementoLente = e.tbSuplementosLentes.Descricao,
                .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of ArtigosLentesOftalmicasSuplementos)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function
#End Region

#Region "ESCRITA"
#End Region

        Public Function getSuplementosByLente(ByVal IDLenteOftalmica As Long?, ByVal IDModelo As Long?) As List(Of ArtigosLentesOftalmicasSuplementos)
            Dim listSuplementos As New List(Of ArtigosLentesOftalmicasSuplementos)

            listSuplementos = BDContexto.tbLentesOftalmicasSuplementos.Where(Function(x) x.IDLenteOftalmica = IDLenteOftalmica).Select(Function(f) New ArtigosLentesOftalmicasSuplementos With {
                                                                                .ID = f.ID, .IDLenteOftalmica = f.IDLenteOftalmica, .IDSuplementoLente = f.IDSuplementoLente, .DescricaoSuplementoLente = f.tbSuplementosLentes.Descricao,
                                                                                .UtilizadorCriacao = f.UtilizadorCriacao, .UtilizadorAlteracao = f.UtilizadorAlteracao,
                                                                                .DataAlteracao = f.DataAlteracao, .DataCriacao = f.DataCriacao
                                                                                }).OrderBy(Function(m) m.DescricaoSuplementoLente).ToList()


            Dim supsSemModelo As New List(Of SuplementosLentes)
            supsSemModelo = BDContexto.tbSuplementosLentes.Where(Function(x) x.IDModelo Is Nothing).Select(Function(y) New SuplementosLentes With {.ID = y.ID, .Descricao = y.Descricao
                                                                                }).OrderBy(Function(j) j.Descricao).ToList()

            For Each lin In supsSemModelo
                Dim sup As New ArtigosLentesOftalmicasSuplementos
                sup.ID = 0 : sup.IDSuplementoLente = lin.ID : sup.DescricaoSuplementoLente = lin.Descricao



                If (listSuplementos.Where(Function(f) f.IDSuplementoLente = lin.ID)).Count = 0 Then listSuplementos.Add(sup)
            Next

            Return listSuplementos
        End Function
    End Class
End Namespace