Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios

Namespace Repositorio.Artigos
    Public Class RepositorioArtigosLentesContato
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbLentesContato, ArtigosLentesContato)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbLentesContato)) As IQueryable(Of ArtigosLentesContato)
            Return query.Select(Function(e) New ArtigosLentesContato With {
                .ID = e.ID, .IDArtigo = e.IDArtigo, .IDModelo = e.IDModelo, .DescricaoModelo = e.tbModelos.Descricao,
                .Raio = e.Raio, .Diametro = e.Diametro, .PotenciaEsferica = e.PotenciaEsferica, .PotenciaCilindrica = e.PotenciaCilindrica, .Eixo = e.Eixo, .Adicao = e.Adicao, .Raio2 = e.Raio2,
                .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbLentesContato)) As IQueryable(Of ArtigosLentesContato)
            Return query.Select(Function(e) New ArtigosLentesContato With {
                .ID = e.ID
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of ArtigosLentesContato)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of ArtigosLentesContato)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbLentesContato)
            Dim query As IQueryable(Of tbAros) = tabela.AsNoTracking
            Dim IDArt As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDArtigo, GetType(Long))

            AplicaFiltroAtivo(inFiltro, query)

            query = query.Where(Function(o) o.IDArtigo = IDArt)

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region
    End Class
End Namespace