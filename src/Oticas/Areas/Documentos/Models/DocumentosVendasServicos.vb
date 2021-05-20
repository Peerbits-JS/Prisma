Imports System.Runtime.Serialization
Imports System.ComponentModel.DataAnnotations
Imports F3M.Modelos.Atributos
Imports F3M.Modelos.Constantes
Imports F3M.Modelos.Base
Imports F3M.Modelos.Utilitarios

Public Class DocumentosVendasServicos
    Inherits F3M.DocumentosVendas

    <DataMember>
    Public Property ContatoPreferencial As String

    '-- CAMPOS DO MODELO
    <DataMember>
    <Display(Name:=CamposGenericos.MedicoTecnico, ResourceType:=GetType(Traducao.EstruturaDocumentos))>
    <AnotacaoF3M(ChaveEstrangeira:=True,
    MapearTabelaChaveEstrangeira:="tbMedicosTecnicos", MapearDescricaoChaveEstrangeira:="DescricaoMedicoTecnico")>
    Public Property IDMedicoTecnico As Nullable(Of Long)

    <DataMember>
    <Display(Name:=CamposGenericos.MedicoTecnico, ResourceType:=GetType(Traducao.EstruturaDocumentos))>
    Public Property DescricaoMedicoTecnico As String

    <DataMember>
    <Display(Name:="DataReceita", ResourceType:=GetType(Traducao.EstruturaDocumentos))>
    Public Property DataReceita As Nullable(Of Date)

    <DataMember>
    Public Property VerPrismas As Nullable(Of Boolean)

    <DataMember>
    Public Property VisaoIntermedia As Nullable(Of Boolean)

    <DataMember>
    <Display(Name:="DataEntregaLonge", ResourceType:=GetType(Traducao.EstruturaDocumentos))>
    Public Property DataEntregaLonge As Nullable(Of Date)

    <DataMember>
    <Display(Name:="DataEntregaPerto", ResourceType:=GetType(Traducao.EstruturaDocumentos))>
    Public Property DataEntregaPerto As Nullable(Of Date)

    <DataMember>
    Public Property CombinacaoDefeito As Nullable(Of Boolean)

    <DataMember>
    <Display(Name:="DataEntregaLonge", ResourceType:=GetType(Traducao.EstruturaDocumentos))>
    Public Property DataEntregaLongeAux As Nullable(Of Date)

    <DataMember>
    <Display(Name:="DataEntregaPerto", ResourceType:=GetType(Traducao.EstruturaDocumentos))>
    Public Property DataEntregaPertoAux As Nullable(Of Date)

    <DataMember>
    Public Property BoxLonge As String

    <DataMember>
    Public Property BoxPerto As String

    <DataMember>
    Public Property SimboloMoedaRef As String

    <DataMember>
    Public Property Servicos As New List(Of Servicos)

    <DataMember>
    Public Property Diversos As New List(Of DocumentosVendasLinhas)

    <DataMember>
    Public TotalMoedaServicos As Double

    <DataMember>
    <Required>
    <Display(Name:="Entidade", ResourceType:=GetType(Traducao.EstruturaAplicacaoTermosBase))>
    <AnotacaoF3M(ChaveEstrangeira:=True, MapearTabelaChaveEstrangeira:="tbClientes", MapearDescricaoChaveEstrangeira:="DescricaoEntidade")>
    Public Shadows Property IDEntidade As Nullable(Of Long)

    <DataMember>
    Public DescricaoTipoEstado As String

    <DataMember>
    Public ValidaEstado As Boolean

    <DataMember>
    Public Property UtilizaConfigDescontos As Boolean = False

    <DataMember>
    Public Property ServicoFases As New List(Of ServicosFases)

    <DataMember>
    Public Property GraduacoesAlteradas As String()

#Region "IMPORTAÇÃO"

    <DataMember>
    Public Property GraduacoesImportacao As New List(Of DocumentosVendasLinhasGraduacoes)

#End Region


    <DataMember>
    Public Property isNewUserOnFeature As Boolean
End Class


Public Class ServicosFases
    <DataMember>
    Public Property IDServico As Long

    <DataMember>
    Public Property IDTipoServico As Long

    <DataMember>
    Public Property Descricao As String

    <DataMember>
    Public Property Fases As New List(Of DocumentosVendasServicosFases)
End Class


Public Class Servicos

    Private _AcaoCRUD As Int64 = AcoesFormulario.Adicionar
    <DataMember>
    Public Property AcaoCRUD() As Int64
        Get
            Return _AcaoCRUD
        End Get
        Set(ByVal Value As Int64)
            _AcaoCRUD = Value
        End Set
    End Property

    <DataMember>
    Public Property ID As Long

    <DataMember>
    Public Property IDDocumentoVendaLinha As Long

    <DataMember>
    Public Property DescricaoServico As String

    <DataMember>
    Public Property IDTipoServico As Long

    <DataMember>
    Public Property IDTipoServicoAux As Long

    <DataMember>
    Public Property IDTipoServicoOlho As Long

    <DataMember>
    <Display(Name:=CamposGenericos.MedicoTecnico, ResourceType:=GetType(Traducao.EstruturaDocumentos))>
    <AnotacaoF3M(ChaveEstrangeira:=True,
    MapearTabelaChaveEstrangeira:="tbMedicosTecnicos", MapearDescricaoChaveEstrangeira:="DescricaoMedicoTecnico")>
    Public Property IDMedicoTecnico As Nullable(Of Long)

    <DataMember>
    <Display(Name:=CamposGenericos.MedicoTecnico, ResourceType:=GetType(Traducao.EstruturaDocumentos))>
    Public Property DescricaoMedicoTecnico As String

    <DataMember>
    <Display(Name:="DataReceita", ResourceType:=GetType(Traducao.EstruturaDocumentos))>
    Public Property DataReceita As Nullable(Of Date)

    <DataMember>
    Public Property VerPrismas As Nullable(Of Boolean)

    <DataMember>
    Public Property VisaoIntermedia As Nullable(Of Boolean)

    <DataMember>
    <Display(Name:="DataEntregaLonge", ResourceType:=GetType(Traducao.EstruturaDocumentos))>
    Public Property DataEntregaLonge As Nullable(Of Date)

    <DataMember>
    <Display(Name:="DataEntregaPerto", ResourceType:=GetType(Traducao.EstruturaDocumentos))>
    Public Property DataEntregaPerto As Nullable(Of Date)

    <DataMember>
    <Display(Name:="DataEntregaLonge", ResourceType:=GetType(Traducao.EstruturaDocumentos))>
    Public Property DataEntregaLongeAux As Nullable(Of Date)

    <DataMember>
    <Display(Name:="DataEntregaPerto", ResourceType:=GetType(Traducao.EstruturaDocumentos))>
    Public Property DataEntregaPertoAux As Nullable(Of Date)

    <DataMember>
    Public Property CombinacaoDefeito As Nullable(Of Boolean)

    Private _TotalLonge As Nullable(Of Double) = 0
    <DataMember>
    Public Property TotalLonge As Nullable(Of Double)
        Get
            Return ClsUtilitarios.RetornaZeroSeVazioDuplo(_TotalLonge)
        End Get
        Set(ByVal Value As Nullable(Of Double))
            _TotalLonge = Value
        End Set
    End Property

    Private _TotalComparticipadoLonge As Nullable(Of Double) = 0
    <DataMember>
    Public Property TotalComparticipadoLonge As Nullable(Of Double)
        Get
            Return ClsUtilitarios.RetornaZeroSeVazioDuplo(_TotalComparticipadoLonge)
        End Get
        Set(ByVal Value As Nullable(Of Double))
            _TotalComparticipadoLonge = Value
        End Set
    End Property

    Private _TotalPerto As Nullable(Of Double) = 0
    <DataMember>
    Public Property TotalPerto As Nullable(Of Double)
        Get
            Return ClsUtilitarios.RetornaZeroSeVazioDuplo(_TotalPerto)
        End Get
        Set(ByVal Value As Nullable(Of Double))
            _TotalPerto = Value
        End Set
    End Property

    Private _TotalComparticipadoPerto As Nullable(Of Double) = 0
    <DataMember>
    Public Property TotalComparticipadoPerto As Nullable(Of Double)
        Get
            Return ClsUtilitarios.RetornaZeroSeVazioDuplo(_TotalComparticipadoPerto)
        End Get
        Set(ByVal Value As Nullable(Of Double))
            _TotalComparticipadoPerto = Value
        End Set
    End Property

    Private _TotalLentesContacto As Nullable(Of Double) = 0
    <DataMember>
    Public Property TotalLentesContacto As Nullable(Of Double)
        Get
            Return ClsUtilitarios.RetornaZeroSeVazioDuplo(_TotalLentesContacto)
        End Get
        Set(ByVal Value As Nullable(Of Double))
            _TotalLentesContacto = Value
        End Set
    End Property

    Private _TotalComparticipadoLentesContacto As Nullable(Of Double) = 0
    <DataMember>
    Public Property TotalComparticipadoLentesContacto As Nullable(Of Double)
        Get
            Return ClsUtilitarios.RetornaZeroSeVazioDuplo(_TotalComparticipadoLentesContacto)
        End Get
        Set(ByVal Value As Nullable(Of Double))
            _TotalComparticipadoLentesContacto = Value
        End Set
    End Property

    Private _TotalServico As Nullable(Of Double) = 0
    <DataMember>
    Public Property TotalServico As Nullable(Of Double)
        Get
            Return ClsUtilitarios.RetornaZeroSeVazioDuplo(_TotalServico)
        End Get
        Set(ByVal Value As Nullable(Of Double))
            _TotalServico = Value
        End Set
    End Property

    <DataMember>
    Public Property DocumentosVendasLinhasGraduacoes As New List(Of DocumentosVendasLinhasGraduacoes)

    <DataMember>
    Public Property DocumentosVendasLinhas As New List(Of DocumentosVendasLinhas)



    <DataMember>
    Public Property Diversos As New List(Of DocumentosVendasLinhas)

    <DataMember>
    Public Property BoxLonge As String

    <DataMember>
    Public Property BoxPerto As String

    <DataMember>
    Public Property Artigos As New List(Of DocumentosVendasServicosSubstituicaoArtigos)

    <DataMember>
    Public Property IDDocumentosVendasServicosSubstituicaoArtigos As Long?
End Class

Public Class DocumentosVendasLinhasGraduacoes
    Inherits F3M.DocumentosVendasLinhas

    <DataMember>
    <StringLength(200)>
    Public Shadows Property Descricao As String

    <DataMember>
    Public Shadows Property IDDocumentoVenda As Nullable(Of Long)

    <DataMember>
    Public Property IDDocumentoVendaLinha As Nullable(Of Long)

    <DataMember>
    Public Property IDTipoOlho As Long

    <DataMember>
    Public Property IDTipoGraduacao As Long

    Private _PotenciaEsferica As Nullable(Of Double) = 0
    <DataMember>
    Public Property PotenciaEsferica As Nullable(Of Double)
        Get
            Return _PotenciaEsferica
        End Get
        Set(ByVal Value As Nullable(Of Double))
            _PotenciaEsferica = Value
        End Set
    End Property

    Private _PotenciaCilindrica As Nullable(Of Double) = 0
    <DataMember>
    Public Property PotenciaCilindrica As Nullable(Of Double)
        Get
            Return _PotenciaCilindrica
        End Get
        Set(ByVal Value As Nullable(Of Double))
            _PotenciaCilindrica = Value
        End Set
    End Property

    Private _PotenciaPrismatica As Nullable(Of Double) = 0
    <DataMember>
    Public Property PotenciaPrismatica As Nullable(Of Double)
        Get
            Return _PotenciaPrismatica
        End Get
        Set(ByVal Value As Nullable(Of Double))
            _PotenciaPrismatica = Value
        End Set
    End Property

    Private _BasePrismatica As String = "0"
    <DataMember>
    <StringLength(10)>
    Public Property BasePrismatica As String
        Get
            Return _BasePrismatica
        End Get
        Set(ByVal Value As String)
            _BasePrismatica = Value
        End Set
    End Property

    Private _Adicao As Nullable(Of Double) = 0
    <DataMember>
    Public Property Adicao As Nullable(Of Double)
        Get
            Return _Adicao
        End Get
        Set(ByVal Value As Nullable(Of Double))
            _Adicao = Value
        End Set
    End Property

    Private _Eixo As Integer = 0
    <DataMember>
    Public Property Eixo As Integer
        Get
            Return _Eixo
        End Get
        Set(ByVal Value As Integer)
            _Eixo = Value
        End Set
    End Property

    Private _RaioCurvatura As String = "0"
    <DataMember>
    <StringLength(10)>
    Public Property RaioCurvatura As String
        Get
            Return _RaioCurvatura
        End Get
        Set(ByVal Value As String)
            _RaioCurvatura = Value
        End Set
    End Property

    Private _DetalheRaio As String = "0"
    <DataMember>
    <StringLength(10)>
    Public Property DetalheRaio As String
        Get
            Return _DetalheRaio
        End Get
        Set(ByVal Value As String)
            _DetalheRaio = Value
        End Set
    End Property

    Private _DNP As Nullable(Of Double) = 0
    <DataMember>
    Public Property DNP As Nullable(Of Double)
        Get
            Return _DNP
        End Get
        Set(ByVal Value As Nullable(Of Double))
            _DNP = Value
        End Set
    End Property

    Private _Altura As Nullable(Of Double) = 0
    <DataMember>
    Public Property Altura As Nullable(Of Double)
        Get
            Return _Altura
        End Get
        Set(ByVal Value As Nullable(Of Double))
            _Altura = Value
        End Set
    End Property

    Private _AcuidadeVisual As String = "0"
    <DataMember>
    <StringLength(10)>
    Public Property AcuidadeVisual As String
        Get
            Return _AcuidadeVisual
        End Get
        Set(ByVal Value As String)
            _AcuidadeVisual = Value
        End Set
    End Property

    Private _AnguloPantoscopico As String = "0"
    <DataMember>
    <StringLength(10)>
    Public Property AnguloPantoscopico As String
        Get
            Return _AnguloPantoscopico
        End Get
        Set(ByVal Value As String)
            _AnguloPantoscopico = Value
        End Set
    End Property

    Private _DistanciaVertex As String = "0"
    <DataMember>
    <StringLength(10)>
    Public Property DistanciaVertex As String
        Get
            Return _DistanciaVertex
        End Get
        Set(ByVal Value As String)
            _DistanciaVertex = Value
        End Set
    End Property

End Class

Public Class DocumentosVendasLinhas
    Inherits F3M.DocumentosVendasLinhas

    <DataMember>
    Public Property IDServico As Nullable(Of Long)

    <DataMember>
    Public Property IDTipoOlho As Nullable(Of Long)

    <DataMember>
    Public Property IDTipoGraduacao As Nullable(Of Long)

    <DataMember>
    Public Property Diametro As String

    <DataMember>
    Public Property IDMarca As Nullable(Of Long)

    <DataMember>
    Public Property DescricaoMarca As String

    <DataMember>
    Public Property IDMateria As Nullable(Of Long)

    <DataMember>
    Public Property IDTipoLente As Nullable(Of Long)

    <DataMember>
    Public Property IDModelo As Nullable(Of Long)

    <DataMember>
    Public Property IDTratamentoLente As Nullable(Of Long)

    <DataMember>
    Public Property IDCorLente As Nullable(Of Long)

    <DataMember>
    Public Property IDCampanha As Nullable(Of Long)

    <DataMember>
    Public Property Campanha As String

    <DataMember>
    <Display(Name:="DescEstado", ResourceType:=GetType(Traducao.EstruturaDocumentos))>
    <AnotacaoF3M(ChaveEstrangeira:=True,
        MapearTabelaChaveEstrangeira:="tbEstados", MapearDescricaoChaveEstrangeira:="DescricaoEstado")>
    Public Property IDEstado As Nullable(Of Long)

    <DataMember>
    <Display(Name:="DescEstado", ResourceType:=GetType(Traducao.EstruturaDocumentos))>
    Public Property DescricaoEstado As String

    <DataMember>
    Public Property PotenciaEsferica As Nullable(Of Double)

    <DataMember>
    Public Property PotenciaCilindrica As Nullable(Of Double)

    <DataMember>
    Public Property PotenciaPrismatica As Nullable(Of Double)

    <DataMember>
    Public Property Adicao As Nullable(Of Double)

    <DataMember>
    Public Property RaioCurvatura As String

    <DataMember>
    Public Property DetalheRaio As String

    <DataMember>
    Public Property Eixo As Nullable(Of Double)

    Private _PrecoUnitarioEfetivoSemIva As Nullable(Of Double) = 0
    <DataMember>
    Public Property PrecoUnitarioEfetivoSemIva() As Nullable(Of Double)
        Get
            Return ClsUtilitarios.RetornaZeroSeVazioDuplo(_PrecoUnitarioEfetivoSemIva)
        End Get
        Set(ByVal Value As Nullable(Of Double))
            _PrecoUnitarioEfetivoSemIva = Value
        End Set
    End Property

    Private _ValorDescontoEfetivoSemIva As Nullable(Of Double) = 0
    <DataMember>
    Public Property ValorDescontoEfetivoSemIva() As Nullable(Of Double)
        Get
            Return ClsUtilitarios.RetornaZeroSeVazioDuplo(_ValorDescontoEfetivoSemIva)
        End Get
        Set(ByVal Value As Nullable(Of Double))
            _ValorDescontoEfetivoSemIva = Value
        End Set
    End Property

    Private _ValorUnitarioEntidade1 As Nullable(Of Double) = 0
    <DataMember>
    Public Property ValorUnitarioEntidade1() As Nullable(Of Double)
        Get
            Return ClsUtilitarios.RetornaZeroSeVazioDuplo(_ValorUnitarioEntidade1)
        End Get
        Set(ByVal Value As Nullable(Of Double))
            _ValorUnitarioEntidade1 = Value
        End Set
    End Property

    Private _ValorEntidade1 As Nullable(Of Double)
    <DataMember>
    Public Property ValorEntidade1() As Nullable(Of Double)
        Get
            Return ClsUtilitarios.RetornaZeroSeVazioDuplo(_ValorEntidade1)
        End Get
        Set(ByVal Value As Nullable(Of Double))
            _ValorEntidade1 = Value
        End Set
    End Property

    Private _ValorUnitarioEntidade2 As Nullable(Of Double) = 0
    <DataMember>
    Public Property ValorUnitarioEntidade2() As Nullable(Of Double)
        Get
            Return ClsUtilitarios.RetornaZeroSeVazioDuplo(_ValorUnitarioEntidade2)
        End Get
        Set(ByVal Value As Nullable(Of Double))
            _ValorUnitarioEntidade2 = Value
        End Set
    End Property

    Private _ValorEntidade2 As Nullable(Of Double) = 0
    <DataMember>
    Public Property ValorEntidade2() As Nullable(Of Double)
        Get
            Return ClsUtilitarios.RetornaZeroSeVazioDuplo(_ValorEntidade2)
        End Get
        Set(ByVal Value As Nullable(Of Double))
            _ValorEntidade2 = Value
        End Set
    End Property

    Public Property IDsSuplementos As List(Of Long)


    <DataMember>
    Public Property TipoTaxa As String

    Private _PrecoTotal As Nullable(Of Double) = 0


    <DataMember>
    Public Property IDAdiantamentoOrigem As Nullable(Of Long)

    <DataMember>
    Public Property CodigoIva As String

    <DataMember>
    Public Property IndiceRefracao As Double?

    <DataMember>
    Public Property Fotocromatica As Boolean?
End Class