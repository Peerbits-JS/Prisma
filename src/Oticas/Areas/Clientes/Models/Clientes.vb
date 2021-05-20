Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Atributos
Imports F3M.Modelos.Constantes

Public Class Clientes
    Inherits F3M.Clientes

    ' ESPECIFICO MEDICOS TECNICOS
    <DataMember>
    <Display(Name:=CamposGenericos.Entidade1, ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    <AnotacaoF3M(ChaveEstrangeira:=True,
    MapearTabelaChaveEstrangeira:="tbEntidades", MapearDescricaoChaveEstrangeira:="DescricaoEntidade1")>
    Public Property IDEntidade1 As Nullable(Of Long)

    <DataMember>
    <Display(Name:=CamposGenericos.Entidade1, ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property DescricaoEntidade1 As String

    <DataMember>
    <Display(Name:=CamposGenericos.NumeroBeneficiario1, ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    <StringLength(50)>
    Public Property NumeroBeneficiario1 As String

    <DataMember>
    <Display(Name:=CamposGenericos.Entidade2, ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    <AnotacaoF3M(ChaveEstrangeira:=True,
        MapearTabelaChaveEstrangeira:="tbEntidades", MapearDescricaoChaveEstrangeira:="DescricaoEntidade2")>
    Public Property IDEntidade2 As Nullable(Of Long)
    <DataMember>
    <Display(Name:=CamposGenericos.Entidade2, ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property DescricaoEntidade2 As String

    <DataMember>
    <Display(Name:=CamposGenericos.NumeroBeneficiario2, ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    <StringLength(50)>
    Public Property NumeroBeneficiario2 As String

    <DataMember>
    <Display(Name:=CamposGenericos.MedicoTecnico, ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    <AnotacaoF3M(ChaveEstrangeira:=True,
        MapearTabelaChaveEstrangeira:="tbMedicosTecnicos", MapearDescricaoChaveEstrangeira:="DescricaoMedicoTecnico")>
    Public Property IDMedicoTecnico As Nullable(Of Long)
    <DataMember>
    <Display(Name:=CamposGenericos.MedicoTecnico, ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property DescricaoMedicoTecnico As String

    'LINHAS 
    <DataMember>
    Public Property ClientesMoradas As List(Of ClientesMoradas)

    <DataMember>
    Public Property ClientesContatos As List(Of ClientesContatos)

    <DataMember>
    <Display(Name:=CamposGenericos.Parentesco1, ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    <StringLength(50)>
    Public Property Parentesco1 As String

    <DataMember>
    <Display(Name:=CamposGenericos.Parentesco2, ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    <StringLength(50)>
    Public Property Parentesco2 As String

    Public Property CodigoLocalOperacao As String

    <DataMember>
    <Display(Name:=CamposGenericos.Loja, ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    <AnotacaoF3M(ChaveEstrangeira:=True,
    MapearTabelaChaveEstrangeira:="tbLojas", MapearDescricaoChaveEstrangeira:="DescricaoLoja")>
    Public Overrides Property IDLoja As Nullable(Of Long)

    <DataMember>
    <Display(Name:=CamposGenericos.Loja, ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property DescricaoLoja As String

    <DataMember>
    Public Property Telefone As String

    <DataMember>
    Public Property Telemovel As String

    <DataMember>
    Public Property EMail As String

    <DataMember>
    Public Property Saldo As Nullable(Of Double)

    <DataMember>
    Public Property DiaNascimento As String

    <DataMember>
    <Display(Name:=CamposGenericos.Morada, ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property DescricaoMorada As String

    <DataMember>
    <Display(Name:=CamposGenericos.CodigoPostal, ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property CodigoPostal As String
    <DataMember>
    <Display(Name:=CamposGenericos.Localidade, ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    Public Property DescricaoCodigoPostal As String
End Class
