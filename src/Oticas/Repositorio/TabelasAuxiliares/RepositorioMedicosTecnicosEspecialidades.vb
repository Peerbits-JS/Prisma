
Imports System.Data.Entity
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Base
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Genericos
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports Oticas.Modelos.Constantes

'para a funcao ListaMenus
Imports F3M.Modelos.Controlos

' Copiado do RepositorioPerfis (do F3M)
Namespace Repositorios.TabelasAuxiliares
    Public Class RepositorioMedicosTecnicosEspecialidades
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbMedicosTecnicosEspecialidades, MedicosTecnicosEspecialidades)



#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"


        'copy de RepositorioPerfisAcessos [@16jun2016_pef]
        ''' <summary>
        ''' 
        ''' </summary>
        ''' <param name="itemID"></param>
        ''' <param name="idPai"></param>
        ''' <param name="objMedicosTecnicosEspecialidade"></param>
        ''' <param name="lstEspecialidades"></param>
        ''' <param name="lstMedicosTecnicosEspecialidades"></param>
        ''' <param name="inObjFiltro"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Public Function ListaEspecialidades(itemID As Integer, idPai As Integer?, ByRef objMedicosTecnicosEspecialidade As List(Of MedicosTecnicosEspecialidades),
                                   lstEspecialidades As List(Of tbEspecialidades),
                                   lstMedicosTecnicosEspecialidades As List(Of tbMedicosTecnicosEspecialidades),
                                   inObjFiltro As ClsF3MFiltro) As List(Of MedicosTecnicosEspecialidades)
            Try
                Dim IDMedTec As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inObjFiltro, CamposGenericos.IDMedicoTecnico, GetType(Long))

                'Listas
                If IsNothing(lstEspecialidades) Then
                    lstEspecialidades = (From mmm In BDContexto.tbEspecialidades).AsNoTracking().ToList()
                End If

                If IsNothing(lstMedicosTecnicosEspecialidades) Then
                    lstMedicosTecnicosEspecialidades = (From mmm In BDContexto.tbMedicosTecnicosEspecialidades Where mmm.IDMedicoTecnico = IDMedTec).AsNoTracking().ToList()
                End If

                For Each especialidade In lstEspecialidades
                    Dim obj As New MedicosTecnicosEspecialidades
                    Dim LinhaMedicosTecnicosEspecialidades = lstMedicosTecnicosEspecialidades.Where(Function(f) f.IDEspecialidade = especialidade.ID).FirstOrDefault


                    'If para forçar o campo .Selecionado = true caso só exista uma especialidade  _@21jun2016_pef
                    If lstEspecialidades.Count = 1 Then
                        With obj
                            .AcaoCRUD = If(IsNothing(LinhaMedicosTecnicosEspecialidades), AcoesFormulario.Adicionar, AcoesFormulario.Alterar)
                            .ID = especialidade.ID
                            .IDAux = If(IsNothing(LinhaMedicosTecnicosEspecialidades), Nothing, LinhaMedicosTecnicosEspecialidades.ID)
                            .Selecionado = True
                            .Descricao = Traducao.Traducao.ClsTraducao.Traduz(Traducao.Traducao.ClsTipos.TipoTraducao.Menus, especialidade.Descricao, ClsF3MSessao.Idioma)
                            .Principal = True
                            .Ativo = If(Not IsNothing(LinhaMedicosTecnicosEspecialidades), LinhaMedicosTecnicosEspecialidades.Ativo, False)
                            .UtilizadorCriacao = especialidade.UtilizadorCriacao
                            .DataCriacao = especialidade.DataCriacao
                            .parentId = Nothing
                        End With
                    Else
                        With obj
                            .AcaoCRUD = If(IsNothing(LinhaMedicosTecnicosEspecialidades), AcoesFormulario.Adicionar, AcoesFormulario.Alterar)
                            .ID = especialidade.ID
                            .IDAux = If(IsNothing(LinhaMedicosTecnicosEspecialidades), Nothing, LinhaMedicosTecnicosEspecialidades.ID)
                            .Selecionado = If(Not IsNothing(LinhaMedicosTecnicosEspecialidades), LinhaMedicosTecnicosEspecialidades.Selecionado, False)
                            .Descricao = Traducao.Traducao.ClsTraducao.Traduz(Traducao.Traducao.ClsTipos.TipoTraducao.Menus, especialidade.Descricao, ClsF3MSessao.Idioma)
                            .Principal = If(Not IsNothing(LinhaMedicosTecnicosEspecialidades), LinhaMedicosTecnicosEspecialidades.Principal, False)
                            .Ativo = If(Not IsNothing(LinhaMedicosTecnicosEspecialidades), LinhaMedicosTecnicosEspecialidades.Ativo, False)
                            .UtilizadorCriacao = especialidade.UtilizadorCriacao
                            .DataCriacao = especialidade.DataCriacao
                            .parentId = Nothing
                        End With
                    End If
                    objMedicosTecnicosEspecialidade.Add(obj)
                Next

                Return objMedicosTecnicosEspecialidade
            Catch ex As Exception
                Return Nothing
            End Try
        End Function






        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbMedicosTecnicosEspecialidades)) As IQueryable(Of MedicosTecnicosEspecialidades)
            Return query.Select(Function(e) New F3M.MedicosTecnicosEspecialidades With {
                .ID = e.ID, .Principal = e.Principal, .Selecionado = e.Selecionado, .IDEspecialidade = e.IDEspecialidade, .IDMedicoTecnico = e.IDMedicoTecnico,
                .Ativo = e.Ativo, .Sistema = e.Sistema, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador,
                .DescricaoMedicoTecnico = e.tbMedicosTecnicos.Nome,
                .DescricaoEspecialidade = e.tbEspecialidades.Descricao})
        End Function

        'Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbMedicosTecnicosEspecialidades)) As IQueryable(Of F3M.MedicosTecnicosEspecialidades)
        '    Return query.Select(Function(e) New F3M.MedicosTecnicosEspecialidades With {
        '        .ID = e.ID, .Codigo = e.Codigo, .Nome = e.Nome})
        'End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbMedicosTecnicosEspecialidades)) As IQueryable(Of MedicosTecnicosEspecialidades)
            Return query.Select(Function(e) New F3M.MedicosTecnicosEspecialidades With {
                .ID = e.ID, .DescricaoEspecialidade = e.tbEspecialidades.Descricao, .UtilizadorCriacao = e.UtilizadorCriacao, .Selecionado = e.Selecionado, .IDEspecialidade = e.IDEspecialidade
            }).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
        End Function

        'Private Function ListaAcessosMenu(query As IQueryable(Of tbMedicosTecnicosAcessos)) As IQueryable(Of tbPerfisAcessos)
        '    Return query.Select(Function(e) New tbPerfisAcessos With {
        '        .ID = e.ID
        '    })
        'End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of MedicosTecnicosEspecialidades)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of MedicosTecnicosEspecialidades)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ''' <summary>
        ''' Para filtrar a tabela
        ''' </summary>
        ''' <param name="inFiltro"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbMedicosTecnicosEspecialidades)
            Dim query As IQueryable(Of tbMedicosTecnicosEspecialidades) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            AplicaFiltrosEOrdenacoesDasVistas(inFiltro, query)

            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.tbEspecialidades.Descricao.Contains(filtroTxt))
            End If

            Return query.OrderBy(Function(o) o.tbEspecialidades.Descricao)
        End Function

        ' GET BY ID
        Public Overrides Function ObtemPorObjID(objID As Object) As MedicosTecnicosEspecialidades
            Dim lngObjID As Long = CLng(objID)
            Return ListaCamposTodos(tabela.AsNoTracking.Where(Function(w) w.ID.Equals(lngObjID))).FirstOrDefault
        End Function
#End Region
    End Class
End Namespace