Imports System.Data.Entity
Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio

Namespace Repositorio.Documentos
    Public Class RepositorioDocumentosVendasServicosFases
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbServicosFases, DocumentosVendasServicosFases)

#Region "LEITURA"
        Protected Friend Function ListaFasesByServico(ByVal IDServico As Long, ByVal IDTipoServico As Long) As List(Of DocumentosVendasServicosFases)
            Dim funcSelect As Func(Of tbServicosFases, DocumentosVendasServicosFases) = Function(s)
                                                                                            Dim servicoFases As New DocumentosVendasServicosFases

                                                                                            With servicoFases
                                                                                                .IsChecked = True
                                                                                                .ID = s.ID : .IDTipoFase = s.IDTipoFase : .IDServico = s.IDServico : .IDTipoServico = s.IDTipoServico
                                                                                                .DescricaoTiposFases = s.tbTiposFases.Descricao
                                                                                                .Data = s.Data.Value.ToShortDateString() & " " & s.Data.Value.ToShortTimeString()
                                                                                                .Observacoes = s.Observacoes : .Ordem = s.tbTiposFases.Ordem
                                                                                                .Sistema = s.Sistema : .Ativo = s.Ativo
                                                                                                .DataCriacao = s.DataCriacao : .UtilizadorCriacao = s.UtilizadorCriacao : .DataAlteracao = s.DataAlteracao : .UtilizadorAlteracao = s.UtilizadorAlteracao

                                                                                                If Not String.IsNullOrEmpty(s.UtilizadorAlteracao) Then
                                                                                                    .UtilizadorEstado = s.UtilizadorAlteracao
                                                                                                Else
                                                                                                    .UtilizadorEstado = s.UtilizadorCriacao
                                                                                                End If
                                                                                            End With

                                                                                            Return servicoFases
                                                                                        End Function

            Return tabela.Where(Function(w) w.IDServico = IDServico AndAlso w.IDTipoServico = IDTipoServico).Select(funcSelect).ToList()
        End Function

#End Region

#Region "ESCRITA"
        Protected Friend Function CRUD(model As DocumentosVendasServicosFases) As DocumentosVendasServicosFases
            Select Case model.AcaoFormulario
                Case AcoesFormulario.Adicionar
                    Return Create(model)
                Case AcoesFormulario.Alterar
                    Return Update(model)
                Case AcoesFormulario.Remover
                    Return Delete(model)
            End Select

            Return model
        End Function

        Private Function Create(model As DocumentosVendasServicosFases) As DocumentosVendasServicosFases
            Dim fase As New tbServicosFases
            Mapear(Of DocumentosVendasServicosFases, tbServicosFases)(model, fase)

            With fase
                .UtilizadorCriacao = ClsF3MSessao.RetornaUtilizadorNome : .DataCriacao = DateAndTime.Now() : .Data = .DataCriacao
            End With

            With BDContexto
                .Entry(fase).State = EntityState.Added
                .SaveChanges()
            End With

            With model
                .ID = fase.ID
                .Data = fase.Data.Value.ToShortDateString() & " " & fase.Data.Value.ToShortTimeString()
                .UtilizadorCriacao = fase.UtilizadorCriacao : .UtilizadorEstado = fase.UtilizadorCriacao : .DataCriacao = fase.DataCriacao
            End With

            UpdateServico(model.IDServico, fase.UtilizadorCriacao, fase.DataCriacao)

            Return model
        End Function

        Private Function Update(model As DocumentosVendasServicosFases) As DocumentosVendasServicosFases
            Dim fase As tbServicosFases = BDContexto.tbServicosFases.FirstOrDefault(Function(w) w.ID = model.ID)

            With fase
                .Observacoes = model.Observacoes
                .UtilizadorAlteracao = ClsF3MSessao.RetornaUtilizadorNome : .DataAlteracao = DateAndTime.Now() : .Data = .DataAlteracao
            End With

            With BDContexto
                .Entry(fase).State = EntityState.Modified
                .SaveChanges()
            End With

            With model
                .Data = fase.Data.Value.ToShortDateString() & " " & fase.Data.Value.ToShortTimeString()
                .UtilizadorAlteracao = fase.UtilizadorAlteracao : .UtilizadorEstado = fase.UtilizadorAlteracao : .DataAlteracao = fase.DataAlteracao
            End With

            UpdateServico(model.IDServico, fase.UtilizadorAlteracao, fase.DataAlteracao)

            Return model
        End Function

        Private Function Delete(model As DocumentosVendasServicosFases) As DocumentosVendasServicosFases

            UpdateServico(model.IDServico, ClsF3MSessao.RetornaUtilizadorNome, DateAndTime.Now())

            Dim fase As tbServicosFases = BDContexto.tbServicosFases.FirstOrDefault(Function(w) w.ID = model.ID)
            With BDContexto
                .Entry(fase).State = EntityState.Deleted
                .SaveChanges()
            End With

            With model
                .ID = 0 : .Observacoes = String.Empty
            End With

            Return model
        End Function

        Private Sub UpdateServico(idservico As Long, utilizador As String, data As DateTime)
            Dim servico As tbServicos = BDContexto.tbServicos.FirstOrDefault(Function(w) w.ID = idservico)
            With servico
                .UtilizadorAlteracao = utilizador : .DataAlteracao = data
                .tbDocumentosVendas.UtilizadorAlteracao = utilizador : .tbDocumentosVendas.DataAlteracao = data
            End With

            With BDContexto
                .Entry(servico).State = EntityState.Modified
                .Entry(servico.tbDocumentosVendas).State = EntityState.Modified
                .SaveChanges()
            End With
        End Sub
#End Region
    End Class
End Namespace