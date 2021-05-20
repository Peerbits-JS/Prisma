Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports Oticas.Modelos.Constantes
Imports System.Data.Entity
Imports F3M.Modelos.BaseDados

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioMedicosTecnicos
        Inherits RepositorioGenerico(Of Oticas.BD.Dinamica.Aplicacao, tbMedicosTecnicos, MedicosTecnicos)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbMedicosTecnicos)) As IQueryable(Of MedicosTecnicos)
            Return query.Select(Function(e) New MedicosTecnicos With {
                .ID = e.ID, .IDLoja = e.IDLoja, .Codigo = e.Codigo, .Nome = e.Nome,
                .IDSexo = e.IDSexo,
                .Abreviatura = e.Abreviatura, .Apelido = e.Apelido,
                .DataValidade = e.DataValidade, .DataNascimento = e.DataNascimento,
                .CartaoCidadao = e.CartaoCidadao, .NCedula = e.NCedula, .NContribuinte = e.NContribuinte,
                .Tempoconsulta = e.Tempoconsulta, .TemAgenda = e.TemAgenda, .Cor = e.Cor,
                .Foto = e.Foto, .FotoCaminho = e.FotoCaminho, .FotoAnterior = e.Foto, .FotoCaminhoAnterior = e.FotoCaminho, .Observacoes = e.Observacoes,
                .Ativo = e.Ativo, .Sistema = e.Sistema, .DataCriacao = e.DataCriacao, .UtilizadorCriacao = e.UtilizadorCriacao,
                .DataAlteracao = e.DataAlteracao, .UtilizadorAlteracao = e.UtilizadorAlteracao, .F3MMarcador = e.F3MMarcador,
                .IDTipoEntidade = e.IDTipoEntidade, .IDUtilizador = e.IDUtilizador, .IDSistemaAcoes = e.IDSistemaAcoes, .Cabecalho = e.Cabecalho, .CodigoTemplate = e.tbTiposConsultas.tbTemplates.Codigo,
                .DescricaoTipoEntidade = e.tbSistemaTiposEntidade.Tipo, .IDTemplate = e.IDTemplate, .DescricaoTemplate = e.tbTemplates.Descricao, .IDTipoConsulta = e.IDTipoConsulta, .DescricaoTipoConsulta = e.tbTiposConsultas.Descricao,
                .DescricaoSplitterLadoDireito = e.Nome})
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbMedicosTecnicos)) As IQueryable(Of MedicosTecnicos)
            Return query.Select(Function(e) New MedicosTecnicos With {
                .ID = e.ID, .Nome = e.Nome, .Tempoconsulta = e.Tempoconsulta, .TemAgenda = e.TemAgenda, .IDSistemaAcoes = e.IDSistemaAcoes, .IDTemplate = e.IDTemplate, .CodigoTemplate = e.tbTiposConsultas.tbTemplates.Codigo,
                .FotoCaminho = If(e.FotoCaminho IsNot Nothing AndAlso e.Foto IsNot Nothing, e.FotoCaminho & e.Foto, String.Concat(URLs.FotosGerais, "user.png"))
            }).Take(F3M.Modelos.Constantes.TamanhoDados.NumeroMaximo)
        End Function


        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of MedicosTecnicos)
            Return ListaCamposTodos(FiltraQuery(inFiltro))
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of MedicosTecnicos)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ''' <summary>
        ''' Para filtrar a tabela
        ''' </summary>
        ''' <param name="inFiltro"></param>
        ''' <returns></returns>
        ''' <remarks></remarks>
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbMedicosTecnicos)
            Dim query As IQueryable(Of tbMedicosTecnicos) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto

            Dim TemAgenda As Boolean = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "TemAgenda", GetType(Boolean))
            Dim FiltraAtivo As Boolean = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "Ativo", GetType(Boolean))
            Dim ECalendario As Boolean = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "ECalendario", GetType(Boolean))

            Dim IDsEspecialidade As New List(Of Long)
            Dim FiltroEspecialidades = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDEspecialidade", GetType(Long))


            If FiltroEspecialidades.GetType() Is GetType(List(Of String)) Then
                For Each c As Long In ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDEspecialidade", GetType(Long))
                    IDsEspecialidade.Add(c)
                Next
            ElseIf FiltroEspecialidades <> 0 Then
                IDsEspecialidade.Add(FiltroEspecialidades)
            End If




            ' ATIVO
            If FiltraAtivo Then
                query = query.Where(Function(w) w.Ativo)
            End If

            ' COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                query = query.Where(Function(w) w.Nome.Contains(filtroTxt))
            End If

            'ESPECIFICO
            If IDsEspecialidade.Any() Then
                query = query.Where(Function(f) f.tbMedicosTecnicosEspecialidades.Any(Function(a) IDsEspecialidade.Contains(a.IDEspecialidade)))
            ElseIf IDsEspecialidade.Any() = False And ECalendario Then
                query = query.Where(Function(f) f.tbMedicosTecnicosEspecialidades.Any())
            End If

            If TemAgenda Then
                query = query.Where(Function(f) f.TemAgenda)
            End If

            Return query.OrderBy(Function(o) o.Nome)
        End Function

        ' GET BY ID
        Public Overrides Function ObtemPorObjID(objID As Object) As MedicosTecnicos
            Dim lngObjID As Long = CLng(objID)
            Dim result As MedicosTecnicos = ListaCamposTodos(tabela.AsNoTracking.Where(Function(w) w.ID.Equals(lngObjID))).FirstOrDefault

            If result.IDUtilizador IsNot Nothing Then
                Using ctx As New F3M.F3MGeralEntities
                    result.DescricaoUtilizador = ctx.tbUtilizadores.Where(Function(f) f.ID = result.IDUtilizador).FirstOrDefault?.AspNetUsers.FirstOrDefault?.UserName
                End Using
            End If

            'RGPD - Valida e efetua logs de ações CRUD sobre a entidade - MJS
            ClsControloBDLogs.EscreveLog(Of MedicosTecnicos)(result, AcoesFormulario.Consultar, Nothing)

            Return result
        End Function


#End Region

#Region "ESCRITA"
        ' ADICIONA POR OBJETO
        Public Overrides Sub AdicionaObj(ByRef o As MedicosTecnicos, inFiltro As ClsF3MFiltro)
            Try
                If o.IDUtilizador IsNot Nothing Then
                    Dim lngIdUtilizador As Long = o.IDUtilizador
                    Dim lngID As Long = o.ID

                    Dim medicos As List(Of MedicosTecnicos) = (From x In BDContexto.tbMedicosTecnicos
                                                               Where x.IDUtilizador = lngIdUtilizador AndAlso x.ID <> lngID
                                                               Select New MedicosTecnicos With {.ID = x.ID, .Nome = x.Nome}).ToList()
                    If medicos.Count > 0 Then
                        Throw New Exception(Traducao.EstruturaEmpresas.UtilizadorAssociadoMedico)
                    End If
                End If

                AcaoObjTransacao(o, AcoesFormulario.Adicionar)
            Catch
                Throw
            End Try
        End Sub

        ' EDITA POR OBJETO
        Public Overrides Sub EditaObj(ByRef o As MedicosTecnicos, inFiltro As ClsF3MFiltro)
            Try
                If o.IDUtilizador IsNot Nothing Then
                    Dim lngIdUtilizador As Long = o.IDUtilizador
                    Dim lngID As Long = o.ID

                    Dim medicos As List(Of MedicosTecnicos) = (From x In BDContexto.tbMedicosTecnicos
                                                               Where x.IDUtilizador = lngIdUtilizador AndAlso x.ID <> lngID
                                                               Select New MedicosTecnicos With {.ID = x.ID, .Nome = x.Nome}).ToList()
                    If medicos.Count > 0 Then
                        Throw New Exception(Traducao.EstruturaEmpresas.UtilizadorAssociadoMedico)
                    End If
                End If

                AcaoObjTransacao(o, AcoesFormulario.Alterar)
            Catch
                Throw
            End Try
        End Sub

        ' REMOVE POR OBJETO
        Public Overrides Sub RemoveObj(ByRef o As MedicosTecnicos, inFiltro As ClsF3MFiltro)
            AcaoObjTransacao(o, AcoesFormulario.Remover)
        End Sub

        ' GRAVA LINHAS
        Protected Overrides Sub GravaLinhasTodas(ByRef inCtx As Oticas.BD.Dinamica.Aplicacao, ByRef o As Oticas.MedicosTecnicos, e As tbMedicosTecnicos, inAcao As AcoesFormulario)
            Try
                Dim dict As Dictionary(Of String, Object) = New Dictionary(Of String, Object)
                dict.Add(CamposGenericos.IDMedicoTecnico, e.ID)

                If inAcao.Equals(AcoesFormulario.Adicionar) Or inAcao.Equals(AcoesFormulario.Alterar) Then
                    GravaLinhas(Of tbMedicosTecnicosContatos, MedicosTecnicosContatos)(inCtx, e, o, dict)
                    GravaLinhas(Of tbMedicosTecnicosMoradas, MedicosTecnicosMoradas)(inCtx, e, o, dict)

                    If Not IsNothing(o.MedicosTecnicosEspecialidades) Then
                        For i As Integer = o.MedicosTecnicosEspecialidades.Count - 1 To 0 Step -1
                            With o.MedicosTecnicosEspecialidades.Item(i)
                                .IDMedicoTecnico = o.ID
                                .IDEspecialidade = .ID
                                .ID = .IDAux

                                If .ID = 0 AndAlso .Selecionado = False AndAlso .Principal = False Then
                                    o.MedicosTecnicosEspecialidades.Remove(o.MedicosTecnicosEspecialidades.Item(i))
                                End If

                                If .ID <> 0 AndAlso .Selecionado = False AndAlso .Principal = False Then
                                    GravaLinhasEntidades(Of tbMedicosTecnicosEspecialidades)(inCtx, (From x In e.tbMedicosTecnicosEspecialidades Where x.ID = .ID).ToList(), AcoesFormulario.Remover, Nothing)
                                    o.MedicosTecnicosEspecialidades.Remove(o.MedicosTecnicosEspecialidades.Item(i))
                                End If
                            End With
                        Next
                    End If
                    GravaLinhas(Of tbMedicosTecnicosEspecialidades, MedicosTecnicosEspecialidades)(inCtx, e, o, dict)

                ElseIf inAcao.Equals(AcoesFormulario.Remover) Then
                    GravaLinhasEntidades(Of tbMedicosTecnicosContatos)(inCtx, e.tbMedicosTecnicosContatos.ToList, AcoesFormulario.Remover, Nothing)
                    GravaLinhasEntidades(Of tbMedicosTecnicosMoradas)(inCtx, e.tbMedicosTecnicosMoradas.ToList, AcoesFormulario.Remover, Nothing)
                    GravaLinhasEntidades(Of tbMedicosTecnicosEspecialidades)(inCtx, e.tbMedicosTecnicosEspecialidades.ToList, AcoesFormulario.Remover, Nothing)
                End If

                inCtx.SaveChanges()
            Catch
                Throw
            End Try
        End Sub
#End Region

#Region "Funcoes extras"

#End Region
    End Class
End Namespace