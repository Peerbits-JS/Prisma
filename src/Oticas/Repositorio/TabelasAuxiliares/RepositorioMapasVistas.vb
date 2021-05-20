Imports F3M.Modelos.Autenticacao
Imports F3M.Modelos.Comunicacao
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Repositorio
Imports F3M.Modelos.Utilitarios
Imports F3M.Repositorios.Administracao

Namespace Repositorio.TabelasAuxiliares
    Public Class RepositorioMapasVistas
        Inherits RepositorioGenerico(Of BD.Dinamica.Aplicacao, tbMapasVistas, MapasVistas)

#Region "Construtores"
        Sub New()
            MyBase.New()
        End Sub
#End Region

#Region "LEITURA"
        Protected Overrides Function ListaCamposTodos(query As IQueryable(Of tbMapasVistas)) As IQueryable(Of MapasVistas)
            Return F3M.Repositorio.TabelasAuxiliaresComum.RepositorioMapasVistas.ListaCampoTodosComum(Of tbMapasVistas, MapasVistas)(BDContexto, query, inFiltro)
        End Function

        Protected Overrides Function ListaCamposCombo(query As IQueryable(Of tbMapasVistas)) As IQueryable(Of MapasVistas)
            Return F3M.Repositorio.TabelasAuxiliaresComum.RepositorioMapasVistas.ListaCamposComboComum(Of tbMapasVistas, MapasVistas)(BDContexto, query)
        End Function
        ''' <summary>
        ''' Faz o update da vista por defeito
        ''' </summary>
        ''' <param name="inFiltro">fitro onde passa o novo mapa por defeito</param>
        ''' <returns></returns>
        Public Function UpdateVistasPorDefeito(inFiltro As ClsF3MFiltro) As Boolean
            Dim lngIDTipoDocumento As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDTipoDocumento", GetType(Long))
            Dim strEntidade As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "Entidade", GetType(String))
            Dim lngIDTipoDocumentoSeries As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDTiposDocumentoSeries", GetType(Long))
            Dim strNomeMapa As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "NomeMapa", GetType(String))
            Dim strQueryIDMapaVistas As String = String.Empty
            Dim strQueryMapaPorDefeito As String = String.Empty
            Dim strQueryPorDefeitoFalso As String = String.Empty
            Dim strQueryPorDefeitotbMapasVista As String = String.Empty
            Dim lngIDMapaVistas As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDMapaVistas", GetType(Long))
            Dim blnPorDefeito As Boolean = False
            Dim blnPorDefeitoFalso As Boolean = False
            Dim blnPorDefeitotbMapasVista As Boolean = False

            If lngIDTipoDocumento <> 0 Then

                If lngIDTipoDocumentoSeries <> 0 Then

                    'strQueryIDMapaVistas = String.Concat("SELECT Id FROM tbMapasVistas WHERE NomeMapa = '" + strNomeMapa + "'")
                    'lngIDMapaVistas = BDContexto.Database.SqlQuery(Of Long)(strQueryIDMapaVistas).FirstOrDefault()

                    strQueryMapaPorDefeito = ClsTexto.ConcatenaStrings(New String() {"UPDATE tbTiposDocumentoSeries SET IDMapasVistas =" & lngIDMapaVistas & " where id = " & lngIDTipoDocumentoSeries})
                    blnPorDefeito = BDContexto.Database.ExecuteSqlCommand(strQueryMapaPorDefeito)

                    strQueryPorDefeitoFalso = ClsTexto.ConcatenaStrings(New String() {"UPDATE tbMapasVistas SET PorDefeito = 0 WHERE Entidade = " & ClsUtilitarios.EnvolveSQL(strEntidade) & "  AND ID <> " & lngIDMapaVistas})
                    blnPorDefeitoFalso = BDContexto.Database.ExecuteSqlCommand(strQueryPorDefeitoFalso)

                    strQueryPorDefeitotbMapasVista = ClsTexto.ConcatenaStrings(New String() {"UPDATE tbMapasVistas SET PorDefeito = 1 where ID = " & lngIDMapaVistas})
                    blnPorDefeitotbMapasVista = BDContexto.Database.ExecuteSqlCommand(strQueryPorDefeitotbMapasVista)

                    Return blnPorDefeito
                End If
            Else

                strQueryPorDefeitoFalso = ClsTexto.ConcatenaStrings(New String() {"UPDATE tbMapasVistas SET PorDefeito = 0 WHERE Entidade = " & ClsUtilitarios.EnvolveSQL(strEntidade) & "  AND ID <> " & lngIDMapaVistas})
                blnPorDefeitoFalso = BDContexto.Database.ExecuteSqlCommand(strQueryPorDefeitoFalso)

                strQueryPorDefeitotbMapasVista = ClsTexto.ConcatenaStrings(New String() {"UPDATE tbMapasVistas SET PorDefeito = 1 where ID = " & lngIDMapaVistas})
                blnPorDefeitotbMapasVista = BDContexto.Database.ExecuteSqlCommand(strQueryPorDefeitotbMapasVista)

                Return blnPorDefeitotbMapasVista

            End If


            Return False
        End Function

        ' LISTA
        Public Overrides Function Lista(inFiltro As ClsF3MFiltro) As IQueryable(Of MapasVistas)
            Dim blnDesignerMapas As Boolean = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "DesignerMapas", GetType(Boolean))
            Dim lngIDTipoDocumento As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDTipoDocumento", GetType(Long))
            Dim lngIDTiposDocumentoSeries As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDTiposDocumentoSeries", GetType(Long))
            Dim strQueryModulo As String = String.Empty
            Dim strQuerySistemaTipoDoc As String = String.Empty
            Dim strQuerySistemaTipoDocFiscal As String = String.Empty
            Dim lngIDModulo As Long
            Dim lngIDSistemaTiposDocumento As Long
            Dim blnIDSistemaTiposDocumentoFiscal As Boolean?
            Dim lngPorDefeito As Long?
            'aqui  'se objectofiltro DesignerMapas 'if IDTipoDocumento no objfiltro e diferente de 0, então carrega IDModulo, IDSistemaTiposDocumento e IDSistemaTiposDocumentoFiscal
            'adicionas ao objefiltro
            If blnDesignerMapas = True Then
                If lngIDTipoDocumento <> 0 Then
                    strQueryModulo = String.Concat("Select IDModulo from tbTiposDocumento where id = ", lngIDTipoDocumento)
                    lngIDModulo = BDContexto.Database.SqlQuery(Of Long)(strQueryModulo).FirstOrDefault()

                    strQuerySistemaTipoDoc = String.Concat("Select IDSistemaTiposDocumento from tbTiposDocumento where id= ", lngIDTipoDocumento)
                    lngIDSistemaTiposDocumento = BDContexto.Database.SqlQuery(Of Long)(strQuerySistemaTipoDoc).FirstOrDefault()

                    strQuerySistemaTipoDocFiscal = String.Concat("Select TipoFiscal from tbSistemaTiposDocumento where ID = ", lngIDSistemaTiposDocumento)
                    blnIDSistemaTiposDocumentoFiscal = BDContexto.Database.SqlQuery(Of Boolean?)(strQuerySistemaTipoDocFiscal).FirstOrDefault()

                    If IsNothing(blnIDSistemaTiposDocumentoFiscal) Then
                        lngIDSistemaTiposDocumentoFiscal = 0
                    End If

                    inFiltro.AddCampoFiltrar("IDModulo", lngIDModulo, "")
                    inFiltro.AddCampoFiltrar("IDSistemaTiposDocumento", lngIDSistemaTiposDocumento, "")
                    inFiltro.AddCampoFiltrar("IDSistemaTiposDocumentoFiscal", blnIDSistemaTiposDocumentoFiscal, "")
                End If
            End If

            lngPorDefeito = BDContexto.tbTiposDocumentoSeries.Where(Function(f) f.ID = lngIDTiposDocumentoSeries).Select(Function(s) s.IDMapasVistas).FirstOrDefault()

            If lngPorDefeito Is Nothing Then
                lngPorDefeito = 0
            End If

            Return F3M.Repositorio.TabelasAuxiliaresComum.RepositorioMapasVistas.ListaCampoTodosComum(Of tbMapasVistas, MapasVistas)(BDContexto, FiltraQuery(inFiltro), lngPorDefeito)
        End Function

        ' LISTA COMBO
        Public Overrides Function ListaCombo(inFiltro As ClsF3MFiltro) As IQueryable(Of MapasVistas)
            Return ListaCamposCombo(FiltraQuery(inFiltro))
        End Function

        ' LISTA FILTRADO
        Public Function ListaF4(inFiltro As ClsF3MFiltro) As IQueryable(Of MapasVistas)
            Return ListaCombo(inFiltro)
        End Function

        ' FILTRA LISTA
        Protected Overrides Function FiltraQuery(inFiltro As ClsF3MFiltro) As IQueryable(Of tbMapasVistas)
            Dim query As IQueryable(Of tbMapasVistas) = tabela.AsNoTracking
            Dim filtroTxt As String = inFiltro.FiltroTexto
            Dim entidade As String = String.Empty
            'se objectofiltro DesignerMapas
            'if IDTipoDocumento no objfiltro e diferente de 0, então carrega IDModulo, IDSistemaTiposDocumento e IDSistemaTiposDocumentoFiscal

            Dim blnDesignerMapas As Boolean = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "DesignerMapas", GetType(Boolean))
            Dim blnIgnoraSubReport As Boolean = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IgnoraSubReport", GetType(Boolean))

            If blnDesignerMapas = True Then
                entidade = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "Entidade", GetType(String))
            End If

            '--- GENERICO ---
            'COMBO
            If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                'query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))
            End If
            AplicaFiltroAtivo(inFiltro, query)

            '--- ESPECIFICO ---
            Dim ID_Modulo As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDModulo", GetType(Long))
            Dim ID_SistemaTipoDoc As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDSistemaTiposDocumento", GetType(Long))
            Dim ID_SistemaTipoDocFiscal As Long = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "IDSistemaTiposDocumentoFiscal", GetType(Long))
            Dim EntidadeAux As String = ClsUtilitarios.RetornaValorKeyDicionarioCamposFiltrar(inFiltro, "EntidadeAux", GetType(String))

            If ID_Modulo <> 0 And ID_SistemaTipoDoc = 0 And ID_SistemaTipoDocFiscal = 0 Then
                query = query.Where(Function(w) w.IDModulo = ID_Modulo)

            ElseIf (ID_Modulo <> 0 And ID_SistemaTipoDoc <> 0 And ID_SistemaTipoDocFiscal = 0) Then
                Dim lstRecords = query.Where(Function(w) (w.IDModulo = ID_Modulo And w.IDSistemaTipoDoc = ID_SistemaTipoDoc))

                If lstRecords.ToList.Count = 0 Then
                    query = query.Where(Function(w) (w.IDModulo = ID_Modulo And w.IDSistemaTipoDoc = ID_SistemaTipoDoc) Or
                                (w.IDModulo = ID_Modulo And w.IDSistemaTipoDoc Is Nothing And w.IDSistemaTipoDocFiscal Is Nothing))
                Else
                    query = query.Where(Function(w) (w.IDModulo = ID_Modulo And w.IDSistemaTipoDoc = ID_SistemaTipoDoc))
                End If


            ElseIf (ID_Modulo <> 0 And ID_SistemaTipoDoc <> 0 And ID_SistemaTipoDocFiscal <> 0) Then
                query = query.Where(Function(w) (w.IDModulo = ID_Modulo And w.IDSistemaTipoDoc = ID_SistemaTipoDoc And w.IDSistemaTipoDocFiscal = ID_SistemaTipoDocFiscal) Or
                                                    (w.IDModulo = ID_Modulo And w.IDSistemaTipoDoc Is Nothing And w.IDSistemaTipoDocFiscal Is Nothing) Or
                                                    (w.IDModulo = ID_Modulo And w.IDSistemaTipoDoc = ID_SistemaTipoDoc And w.IDSistemaTipoDocFiscal Is Nothing))
            Else
                If Not ClsTexto.ENuloOuVazio(filtroTxt) Then
                    query = query.Where(Function(w) w.Descricao.Contains(filtroTxt))
                End If
            End If

            AplicaFiltrosEOrdenacoesDasVistas(inFiltro, query)

            If Not String.IsNullOrEmpty(entidade) Then query = query.Where(Function(o) o.Entidade = entidade)

            If Not String.IsNullOrEmpty(EntidadeAux) Then query = query.Where(Function(w) w.Entidade = EntidadeAux)

            If blnIgnoraSubReport Then query = query.Where(Function(o) o.SubReport = False)

            Return query
        End Function
#End Region

#Region "ESCRITA"

#End Region

#Region "FUNÇÕES AUXILIARES"

#End Region

    End Class
End Namespace