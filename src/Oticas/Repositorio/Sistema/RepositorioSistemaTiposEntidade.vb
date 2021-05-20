Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports Traducao.Traducao
Imports Oticas.Repositorio.Sistema
Imports Oticas.Repositorio.TabelasAuxiliares

Namespace Repositorio.Sistema
    Public Class RepositorioSistemaTiposEntidade
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbSistemaTiposEntidade, SistemaTiposEntidade)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Public Function NumTotalTipoEntidades(ByVal inTipo As String) As Integer
            Dim NumTotalTiposEntidade As Integer = tabela.Count(Function(e) e.Codigo = inTipo)
            Return NumTotalTiposEntidade
        End Function

        Public Function ValoresPorDefeito(ByVal inTipo As String, Optional ByVal id As Long = 0) As SistemaTiposEntidade
            If id = 0 Then
                Return tabela.Where(Function(e) e.Codigo = inTipo And e.PorDefeito = True).Select(Function(e) New SistemaTiposEntidade With {
                        .ID = e.ID, .Tipo = e.Tipo, .Codigo = e.Codigo
                    }).FirstOrDefault

            Else
                Return tabela.Where(Function(e) e.Codigo = inTipo And e.ID = id).Select(Function(e) New SistemaTiposEntidade With {
                        .ID = e.ID, .Tipo = e.Tipo, .Codigo = e.Codigo
                    }).FirstOrDefault

            End If
        End Function

        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbSistemaTiposEntidade)) As IQueryable(Of SistemaTiposEntidade)
            Return query.Select(Function(e) New SistemaTiposEntidade With {
                .ID = e.ID, .Codigo = e.Codigo, .PorDefeito = e.PorDefeito, .Sistema = e.Sistema, .Tipo = e.Tipo,
                .Ativo = e.Ativo, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao, .DataAlteracao = e.DataAlteracao,
                .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbSistemaTiposEntidade)) As IQueryable(Of SistemaTiposEntidade)
            Return query.Select(Function(e) New SistemaTiposEntidade With {
                .ID = e.ID, .Tipo = e.Tipo, .TipoAux = e.TipoAux, .Codigo = e.Codigo
            })
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaTiposEntidade)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA PARA A ARVORE
        Protected Function ListaCamposArvore(query As IQueryable(Of tbSistemaTiposEntidade)) As IQueryable(Of SistemaTiposEntidade)
            Return query.Select(Function(e) New SistemaTiposEntidade With {
                .ID = e.ID, .Tipo = e.Tipo, .Codigo = e.Codigo})
        End Function

        ' LISTA FILTRADO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of SistemaTiposEntidade)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' LISTA PARA ARVORE
        Public Function ListaArvore(inFiltro As ClsF3MFiltro) As List(Of SistemaTiposEntidade)
            Dim strTipo As New List(Of String)
            strTipo.Add(TiposEntidade.Vendedores)
            strTipo.Add(TiposEntidade.Clientes)
            strTipo.Add(TiposEntidade.Fornecedores)

            'RETORNA OS TIPOS DE ENTIDADE DO MODULO ESCOLHIDO
            Dim IDModulo As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDModulo, GetType(Long))
            Dim strCodSistTipoDoc As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "CodigoSistemaTiposDocumento", GetType(String))

            Dim res As IQueryable(Of SistemaTiposEntidade) = Nothing
            If Not ClsTexto.ENuloOuVazio(strCodSistTipoDoc) AndAlso IDModulo > 0 Then
                If strCodSistTipoDoc = "CntCorrLiquidacaoClt" Then
                    res = ListaCamposArvore(FiltraQuery(inFiltro).Where(Function(f) f.Codigo = TiposEntidade.Clientes And f.tbSistemaTiposEntidadeModulos.Any(Function(e) e.IDSistemaModulos = IDModulo)))
                ElseIf strCodSistTipoDoc = "CntCorrLiquidacaoFnd" Then
                    res = ListaCamposArvore(FiltraQuery(inFiltro).Where(Function(f) f.Codigo = TiposEntidade.Fornecedores And f.tbSistemaTiposEntidadeModulos.Any(Function(e) e.IDSistemaModulos = IDModulo)))
                End If
            ElseIf IDModulo >= 0 Then
                res = ListaCamposArvore(FiltraQuery(inFiltro).Where(Function(f) strTipo.Contains(f.Codigo) And f.tbSistemaTiposEntidadeModulos.Any(Function(e) e.IDSistemaModulos = IDModulo)))
            Else
                res = ListaCamposArvore(FiltraQuery(inFiltro).Where(Function(f) strTipo.Contains(f.Codigo)))
            End If

            Dim listass = res.ToList()

            'PREENCHE A TREE (CHECKBOXES)
            Dim IDTiposDocumento As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDTiposDocumento", GetType(String))
            If IDTiposDocumento > 0 Then
                Dim linhas As List(Of tbTiposDocumentoTipEntPermDoc)
                Using ctx As New RepositorioTiposDocumentoTipEntPermDoc
                    linhas = ctx.BDContexto.tbTiposDocumentoTipEntPermDoc.Where(Function(f) f.IDTiposDocumento = IDTiposDocumento).ToList
                End Using

                For Each r In listass
                    Dim existe = linhas.Where(Function(f) f.tbSistemaTiposEntidadeModulos.IDSistemaTiposEntidade = r.ID).FirstOrDefault
                    If existe IsNot Nothing Then
                        Dim existeDoc As Boolean = BDContexto.tbControloDocumentos.Where(Function(t) t.IDEntidade IsNot Nothing AndAlso t.IDTipoDocumento = IDTiposDocumento AndAlso t.IDTipoEntidade = r.ID).Count > 0
                        r.checked = True
                        If existeDoc Then
                            r.enabled = True
                        End If
                    End If
                Next
            End If

            Return listass
        End Function

        ' FILTRA QUERY
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbSistemaTiposEntidade)
            Dim query As IQueryable(Of tbSistemaTiposEntidade) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            ' --- GENERICO ---
            AplicaFiltroAtivo(inFiltro, query)

            'If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
            '    'DEFINE FILTRO DOS RESOURCES
            '    Dim resourceByValue As List(Of String) = ClsTraducao.ReturnKeysByValues(filtroTxt, ClsF3MSessao.Idioma, Nothing)
            '    query = query.Where(Function(o) resourceByValue.Contains(o.Tipo))
            'End If

            ' --- ESPECIFICO ---
            Dim strCodSistTipoEnt As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposEspecificos.CodigoSistemaTipoEntidade, GetType(String))
            Dim strTipoSistTipoEnt As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "TipoSistemaEntidade", GetType(String))
            Dim lngIDTipoDoc As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, CamposGenericos.IDTipoDocumento, GetType(Long))
            Dim funcWhere As Func(Of tbSistemaTiposEntidade, Boolean) = Nothing
            ' Tipo Entidade
            If Not ClsTexto.ENuloOuVazio(strTipoSistTipoEnt) Then
                funcWhere = Function(f) f.Tipo.Equals(strTipoSistTipoEnt)
                ' Codigo Tipo Entidade
            ElseIf Not ClsTexto.ENuloOuVazio(strCodSistTipoEnt) Then
                If strCodSistTipoEnt.Equals(TiposEntidade.ClientesFornecedores) Then
                    funcWhere = Function(f) f.Codigo.Equals(TiposEntidade.Fornecedores) Or f.Codigo.Equals(TiposEntidade.Clientes)
                Else
                    funcWhere = Function(f) f.Codigo.Equals(strCodSistTipoEnt)
                End If
            End If

            If funcWhere IsNot Nothing Then
                query = query.Where(funcWhere).AsQueryable
            End If

            If lngIDTipoDoc > 0 Then
                Dim listaTE As List(Of Long) = BDContexto.tbTiposDocumentoTipEntPermDoc.AsNoTracking _
                                            .Where(Function(f) f.IDTiposDocumento.Equals(lngIDTipoDoc)) _
                                            .Select(Function(s) s.tbSistemaTiposEntidadeModulos.IDSistemaTiposEntidade).ToList

                If listaTE.Count > 0 Then
                    query = query.Where(Function(f) listaTE.Contains(f.ID))
                End If
            End If

            Return query
        End Function
#End Region

#Region "ESCRITA"
#End Region

    End Class
End Namespace