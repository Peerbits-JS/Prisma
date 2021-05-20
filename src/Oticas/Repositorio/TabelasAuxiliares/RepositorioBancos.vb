Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports F3M.Modelos.Genericos
Imports System.Data.Entity
Imports F3M
Imports F3M.Modelos.BaseDados

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioBancos
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbBancos, Bancos)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbBancos)) As IQueryable(Of Bancos)
            Return query.Select(Function(e) New Bancos With {
                .ID = e.ID, .Codigo = e.Codigo, .Descricao = e.Descricao, .IDLoja = e.IDLoja, .Sigla = e.Sigla, .CodigoBP = e.CodigoBP,
                .PaisIban = e.PaisIban, .BicSwift = e.BicSwift, .NomeFichSepa = e.NomeFichSepa, .Observacoes = e.Observacoes,
                .Sistema = e.Sistema, .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbBancos)) As IQueryable(Of Bancos)
            Return query.Select(Function(e) New Bancos With {
                .ID = e.ID, .Descricao = e.Descricao
            }).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
        End Function

        Private Function ListaEspecificoBancos(query As IQueryable(Of tbBancos), IDLinha As Long) As IQueryable(Of Bancos)

            Return ListaCamposTodos(query).Where(Function(e) e.ID.Equals(IDLinha))
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of Bancos)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of Bancos)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbBancos)
            Dim query As IQueryable(Of tbBancos) = tabela.AsNoTracking
            Dim eLookup As Boolean = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.eLookup, GetType(Boolean))
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))
            End If

            Return query.OrderBy(Function(o) o.Descricao)
        End Function

        ' GET BY ID
        Public Overrides Function ObtemPorObjID(objID As Object) As Bancos
            Dim lngObjID As Long = CLng(objID)
            Return ListaCamposTodos(tabela.AsNoTracking.Where(Function(w) w.ID.Equals(lngObjID))).FirstOrDefault
        End Function
#End Region

#Region "ESCRITA"
        ' ADICIONA POR OBJETO
        Public Overrides Sub AdicionaObj(ByRef o As Bancos, inFiltro As ClsF3MFiltro)
            AcaoObjTransacao(o, AcoesFormulario.Adicionar)
        End Sub

        ' EDITA POR OBJETO
        Public Overrides Sub EditaObj(ByRef o As Bancos, inFiltro As ClsF3MFiltro)
            AcaoObjTransacao(o, AcoesFormulario.Alterar)
        End Sub

        ' REMOVE POR OBJETO
        Public Overrides Sub RemoveObj(ByRef o As Bancos, inFiltro As ClsF3MFiltro)
            AcaoObjTransacao(o, AcoesFormulario.Remover)
        End Sub

        ' GRAVA LINHAS
        Protected Overrides Sub GravaLinhasTodas(ByRef inCtx As Oticas.BD.Dinamica.Aplicacao, ByRef o As Bancos,
                                                 e As tbBancos, inAcao As AcoesFormulario)
            Dim dict As Dictionary(Of String, Object) = New Dictionary(Of String, Object)
            dict.Add(CamposGenericos.IDBanco, e.ID)

            If inAcao.Equals(AcoesFormulario.Adicionar) Or inAcao.Equals(AcoesFormulario.Alterar) Then
                GravaLinhas(Of tbBancosContatos, BancosContatos)(inCtx, e, o, dict)
                GravaLinhas(Of tbBancosMoradas, BancosMoradas)(inCtx, e, o, dict)

            ElseIf inAcao.Equals(AcoesFormulario.Remover) Then
                GravaLinhasEntidades(Of tbBancosContatos)(inCtx, e.tbBancosContatos.ToList, AcoesFormulario.Remover, Nothing)
                GravaLinhasEntidades(Of tbBancosMoradas)(inCtx, e.tbBancosMoradas.ToList, AcoesFormulario.Remover, Nothing)
            End If
        End Sub

#End Region
    End Class
End Namespace