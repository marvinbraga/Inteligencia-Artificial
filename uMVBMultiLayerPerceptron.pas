{-----------------------------------------------------------------------------
 Unit Name: uMVBMultiLayerPerceptron
 Author:    Marcus Vinicius Braga (mvbraga@gmail.com)
 Ano:       2000-2004   
 ----------------------------------------------------------------------------}

unit uMVBMultiLayerPerceptron;

interface

uses
  { borland }
  Classes, SysUtils, Contnrs,
  { MVB }
  uMVBClasses, uMVBConsts;

type
  TMVBFuncaoAtivacao =(faNaoInformada, faLinearPorPartes, faSigmoide,
    faSigmoideBipolar, faTangenteHiperbolica);

  TMVBTipoCamada = (tcDesconhecido, tcEntrada, tcEscondida, tcSaida);

  TMVBListaCamada = class(TMVBListaBase);
  TMVBListaNeuronio = class(TMVBListaBase);
  TMVBListaSinapse = class(TMVBListaBase);

  TMVBNeuronio = class(TMVBDadosBase)
  private
    FValorMaximo: Double;
    FAlvo: Double;
    FDelta: Double;
    FValorMinimo: Double;
    FValor: Double;
  protected
  public
    procedure Clear; override;
    procedure Assign(ASource: TMVBDadosBase); override;
  published
    { valor assumido pelo neurônio }
    property Valor: Double read FValor write FValor;
    { valor do gradiente descendente }
    property Delta: Double read FDelta write FDelta;
    { valor de alvo utilizado somente para última camada }
    property Alvo: Double read FAlvo write FAlvo;
    { valor máximo assumido pelo neurônio }
    property ValorMaximo: Double read FValorMaximo write FValorMaximo;
    { valor mínimo assumido pelo neurônio }
    property ValorMinimo: Double read FValorMinimo write FValorMinimo;
  end;

  TMVBSinapse = class(TMVBDadosBase)
  private
    FDelta: Double;
    FValor: Double;
    FNeuronio: TMVBNeuronio;
    FNeuronioProximaCamada: TMVBNeuronio;
  protected
  public
    procedure Clear; override;
    procedure Assign(ASource: TMVBDadosBase); override;
    procedure Inicializar;
  published
    { valor assumido pela sinapse }
    property Valor: Double read FValor write FValor;
    { refere-se ao delta de correção dos pesos sinápticos }
    property Delta: Double read FDelta write FDelta;
    { propriedades de ligação de neurônios }
    property Neuronio: TMVBNeuronio read FNeuronio
      write FNeuronio;
    property NeuronioProximaCamada: TMVBNeuronio read FNeuronioProximaCamada
      write FNeuronioProximaCamada;
  end;

  TMVBCamada = class(TMVBDadosBase)
  private
    FTipoCamada: TMVBTipoCamada;
    FNeuronios: TMVBListaNeuronio;
    FSinapses: TMVBListaSinapse;
    procedure SetNeuronios(const Value: TMVBListaNeuronio);
    procedure SetSinapses(const Value: TMVBListaSinapse);
    function GetQuantidadeNeuronios: Integer;
    procedure SetQuantidadeNeuronios(const Value: Integer);
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear; override;
    procedure Assign(ASource: TMVBDadosBase); override;
    procedure InicializarSinapses;
  published
    { tipo da camada }
    property TipoCamada: TMVBTipoCamada read FTipoCamada write FTipoCamada;
    { quantidade de neurônios da camada }
    property QuantidadeNeuronios: Integer read GetQuantidadeNeuronios write
      SetQuantidadeNeuronios;
    { neurônios }
    property Neuronios: TMVBListaNeuronio read FNeuronios write SetNeuronios;
    property Sinapses: TMVBListaSinapse read FSinapses write SetSinapses;
  end;

  TMVBMultiLayerPerceptron = class(TMVBDadosBase)
  private
    FAprendizado: Double;
    FMomento: Double;
    FArquivoConhecimento: TFileName;
    FEstrutura: TStrings;
    FEstaPreparada, FOnLoad: Boolean;
    FGama: Double;
    FLista: string;
    FCamadas: TMVBListaCamada;
    FFuncaoAtivacao: TMVBFuncaoAtivacao;
    procedure CriarSinapses;
    procedure SetEstrutura(const Value: TStrings);
    procedure SetCamadas(const Value: TMVBListaCamada);
  protected
    { função sigmóide }
    function Ativacao(AValor: Double): Double;
    { avança na rede calculando as saídas }
    procedure FeedForward;
    { calcula deltas após feedforward }
    procedure BackPropagation;
    { corrige pesos após backpropagation }
    procedure CorrectWeight;
    procedure CorrectWeightPruning;
    { para ver a quantidade de pesos zerados }
    function QuantidadePesosZerados: Longint;
    { propriedades }
    property Gama: Double read FGama write FGama;
    property Lista: string read FLista write FLista;
    property EstaPreparada: Boolean read FEstaPreparada write FEstaPreparada;
  public
    constructor Create; override;
    destructor Destroy; override;
    { marca entradas na primeira camada }
    procedure ValorEntrada(AIndiceNeuronio: Integer; AValor: Double);
    { marca valor máximo na primeira camada }
    procedure ValorEntradaMaximo(AIndiceNeuronio: Integer; AValor: Double);
    { marca valor mínimo na primeira camada }
    procedure ValorEntradaMinimo(AIndiceNeuronio: Integer; AValor: Double);
    { marca neurônios na saida }
    procedure ValorSaida(AIndiceNeuronio: Integer; AValor: Double);
    { valor máximo nas saídas }
    procedure ValorSaidaMaximo(AIndiceNeuronio: Integer; AValor: Double);
    { valor mínimo nas saídas }
    procedure ValorSaidaMinimo(AIndiceNeuronio: Integer; AValor: Double);
    { pega valores de saída }
    function RecuperarSaida(AIndiceNeuronio: Integer): Double;
    function TrainingPruning(AEpocas: Longint): Longint;
    { constrói a rede (é preciso rodar sempre) }
    procedure Build;
    { executa uma época de treinamento da rede }
    procedure Training;
    { Valores para teste de valores de entrada }
    procedure Test;
    { inicializa todos os valores da MLP }
    procedure Clear; override;
    { zera os valores das sinapses }
    procedure InicializarSinapses;
    { recupera a última camada }
    function RecuperarCamadaSaida: TMVBCamada;
    { recupera a camada de entrada }
    function RecuperarCamadaEntrada: TMVBCamada;
    { salva sinapses em arquivo }
    procedure Save;
    { carrega sinapses em arquivo, com rede já construída com BUILD }
    procedure Load;
    { retorna a função custo, ou seja, o erro atual }
    function Cost: Double;
    { método provisório, só para controle }
    function List: string;
    { elimina os pesos zerados }
    procedure Purge;
  published
    { define a funçao de ativação - por enquanto não altera nada, pois,
      só tem a função sigmóide implementada }
    property FuncaoAtivacao: TMVBFuncaoAtivacao read FFuncaoAtivacao
      write FFuncaoAtivacao;
    { define a quantidade de neurônios por camada }
    property Estrutura: TStrings read FEstrutura write SetEstrutura;
    { define o parâmetro de momento para atualização de pesos sinápticos }
    property Momento: Double read FMomento write FMomento;
    { define o parâmetro de aprendizado para atualização de pesos sinápticos }
    property Aprendizado: Double read FAprendizado write FAprendizado;
    { define o nome do arquivo de conhecimento que serão gravados os valores
      dos pesos sinápticos }
    property ArquivoConhecimento: TFileName read FArquivoConhecimento
      write FArquivoConhecimento;
    { camadas da rede }
    property Camadas: TMVBListaCamada read FCamadas write SetCamadas;
  end;

implementation

uses
  { borland }
  IniFiles,
  { MVB }
  uMVBExcecoesMultiLayerPerceptron;

{ TMVBCamada }

{-----------------------------------------------------------------------------
  Procedure: TMVBCamada.Assign
  Author:    Vinícius
  Date:      09-dez-2003
  Arguments: Source: TPersistent
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBCamada.Assign(ASource: TMVBDadosBase);
begin
  inherited;
  { recupera o tipo da camada }
  FTipoCamada := TMVBCamada(ASource).TipoCamada;
  { recupera os neurônios }
  FNeuronios.AssignObjects(TMVBCamada(ASource).Neuronios);
  { recupera os pesos }
  FSinapses.AssignObjects(TMVBCamada(ASource).Sinapses);
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBCamada.Clear
  Author:    Vinícius
  Date:      09-dez-2003
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBCamada.Clear;
begin
  inherited;
  { limpa o tipo da camada }
  FTipoCamada := tcDesconhecido;
  { limpa as listas }
  FNeuronios.Clear;
  FSinapses.Clear;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBCamada.Create
  Author:    Vinícius
  Date:      16-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

constructor TMVBCamada.Create;
begin
  inherited;
  FNeuronios := TMVBListaNeuronio.Create;
  FSinapses := TMVBListaSinapse.Create;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBCamada.Destroy
  Author:    Vinícius
  Date:      16-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

destructor TMVBCamada.Destroy;
begin
  FSinapses.Free;
  FNeuronios.Free;
  inherited;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBCamada.InicializarSinapses
  Author:    Vinícius
  Date:      11-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBCamada.InicializarSinapses;
var
  LIndex: Integer;
  LSinapse: TMVBSinapse;
begin
  { percorre todas as sinapses da lista }
  for LIndex := 0 to FSinapses.Count - 1 do
  begin
    { recupera a sinapse }
    LSinapse := FSinapses.ProcurarPorIndice(LIndex) as TMVBSinapse;
    { inicializa com valores aleatórios }
    LSinapse.Inicializar;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBCamada.GetQuantidadeNeuronios
  Author:    Vinícius
  Date:      11-jan-2000
  Arguments: None
  Result:    Integer
-----------------------------------------------------------------------------}

function TMVBCamada.GetQuantidadeNeuronios: Integer;
begin
  Result := FNeuronios.Count;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBCamada.SetQuantidadeNeuronios
  Author:    Vinícius
  Date:      11-jan-2000
  Arguments: const Value: Integer
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBCamada.SetQuantidadeNeuronios(const Value: Integer);
var
  LIndex: Integer;
  LNeuronio: TMVBNeuronio;
begin
  { limpa a lista }
  FNeuronios.Clear;
  FSinapses.Clear;
  { a o valor da quantidade existente for diferente do novo }
  if ((FNeuronios.Count <> Value) and (Value > 0)) then
  begin
    { cria os neurônios da camada atual }
    for LIndex := 1 to Value do
    begin
      { cria o neurônio }
      LNeuronio := TMVBNeuronio.Create;
      { inicializa o valor como zero }
      LNeuronio.Valor := 0;
      { informa o delta }
      case FTipoCamada of
        tcEntrada: LNeuronio.Delta := 0;
      else
        LNeuronio.Delta := 1;
      end;
      { adiciona neurônio à lista }
      FNeuronios.Inserir(LNeuronio);
    end;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBCamada.SetNeuronios
  Author:    Vinícius
  Date:      11-jan-2000
  Arguments: const Value: TMVBListaNeuronio
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBCamada.SetNeuronios(const Value: TMVBListaNeuronio);
begin
  FNeuronios.AssignObjects(Value);
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBCamada.SetPesos
  Author:    Vinícius
  Date:      11-jan-2000
  Arguments: const Value: TMVBListaSinapse
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBCamada.SetSinapses(const Value: TMVBListaSinapse);
begin
  FSinapses.AssignObjects(Value);
end;

{ TMVBNeuronio }

{-----------------------------------------------------------------------------
  Procedure: TMVBNeuronio.Assign
  Author:    Vinícius
  Date:      09-dez-2003
  Arguments: Source: TPersistent
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBNeuronio.Assign(ASource: TMVBDadosBase);
begin
  inherited;
  { recupera os valores }
  FValorMaximo := TMVBNeuronio(ASource).ValorMaximo;
  FAlvo := TMVBNeuronio(ASource).Alvo;
  FDelta := TMVBNeuronio(ASource).Delta;
  FValorMinimo := TMVBNeuronio(ASource).ValorMinimo;
  FValor := TMVBNeuronio(ASource).Valor;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBNeuronio.Clear
  Author:    Vinícius
  Date:      09-dez-2003
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBNeuronio.Clear;
begin
  inherited;
  { inicializa valores }
  FValorMaximo := 0; //C_DOUBLE_NULL;
  FAlvo := 0; //C_DOUBLE_NULL;
  FDelta := 0; //C_DOUBLE_NULL;
  FValorMinimo := 0; //C_DOUBLE_NULL;
  FValor := 0; //C_DOUBLE_NULL;
end;

{ TMVBSinapse }

{-----------------------------------------------------------------------------
  Procedure: TMVBSinapse.Assign
  Author:    Vinícius
  Date:      09-dez-2003
  Arguments: Source: TPersistent
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBSinapse.Assign(ASource: TMVBDadosBase);
begin
  inherited;
  { recupera os valores }
  FDelta := TMVBSinapse(ASource).Delta;
  FValor := TMVBSinapse(ASource).Valor;
  { recupera ponteiros dos neurônios }
  FNeuronio := TMVBSinapse(ASource).Neuronio;
  FNeuronioProximaCamada := TMVBSinapse(ASource).NeuronioProximaCamada;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBSinapse.Clear
  Author:    Vinícius
  Date:      09-dez-2003
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBSinapse.Clear;
begin
  inherited;
  { inicializa os valores }
  FDelta := 0; //C_DOUBLE_NULL;
  FValor := 0; //C_DOUBLE_NULL;
  { aterra os ponteiros }
  FNeuronio := nil;
  FNeuronioProximaCamada := nil;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBSinapse.Inicializar
  Author:    Vinícius
  Date:      25-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBSinapse.Inicializar;
begin
  { inicializa com valores aleatórios }
  Self.Valor := Random(1000) / 1000 - 0.5;
  { inicializa deltas com zero }
  Self.Delta := 0;
end;

{ TMVBMultiLayerPerceptron }

{-----------------------------------------------------------------------------
  Procedure: TMVBMultiLayerPerceptron.Ativacao
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: AValor: Double
  Result:    Double
-----------------------------------------------------------------------------}

function TMVBMultiLayerPerceptron.Ativacao(AValor: Double): Double;
begin
  Result := 1 / (1 + Exp(-AValor));
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBMultiLayerPerceptron.BackPropagation
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBMultiLayerPerceptron.BackPropagation;
var
  LCamada, LCamadaAnterior: TMVBCamada;
  LNeuronio: TMVBNeuronio;
  LSinapse: TMVBSinapse;
  LIndexNeuronio, LIndexCamada, LIndexSinapse: Integer;
begin
  { recupera a camada de saída }
  LCamada := Self.RecuperarCamadaSaida;
  { percorre todos os neurônios da camada de saída }
  for LIndexNeuronio := 0 to LCamada.Neuronios.Count - 1 do
  begin
    { recupera o neurônio }
    LNeuronio := LCamada.Neuronios.ProcurarPorIndice(LIndexNeuronio) as
      TMVBNeuronio;
    { calcula deltas para camada de saída }
    LNeuronio.Delta := LNeuronio.Valor *
      (1 - LNeuronio.Valor) * (LNeuronio.Alvo - LNeuronio.Valor);
  end;

  { percorre todas as camadas escondidas de tráz para a frente }
  for LIndexCamada := FCamadas.Count - 2 downto 1 do
  begin
    { recupera a camada }
    LCamadaAnterior := FCamadas.ProcurarPorIndice(LIndexCamada) as TMVBCamada;
    { percorre todas as sinapses da camada }
    for LIndexSinapse := 0 to LCamadaAnterior.Sinapses.Count - 1 do
    begin
      { recupera a sinapse }
      LSinapse := LCamadaAnterior.Sinapses.ProcurarPorIndice(LIndexSinapse) as
        TMVBSinapse;
      { calcula deltas para camadas internas }
      LSinapse.Neuronio.Delta := LSinapse.Neuronio.Delta + LSinapse.Valor *
        LSinapse.NeuronioProximaCamada.Delta;
    end;
  end;

  { percorre todas as camadas escondidas de tráz para a frente }
  for LIndexCamada := FCamadas.Count - 2 downto 1 do
  begin
    { recupera a camada }
    LCamadaAnterior := FCamadas.ProcurarPorIndice(LIndexCamada) as TMVBCamada;
    { recupera a próxima camada }
    LCamada := FCamadas.ProcurarPorIndice(LIndexCamada + 1) as TMVBCamada;
    { percorre todos os neurônios da camada }
    for LIndexNeuronio := 0 to LCamadaAnterior.Neuronios.Count - 1 do
    begin
      { recupera a sinapse }
      LNeuronio := LCamadaAnterior.Neuronios.ProcurarPorIndice(
        LIndexNeuronio) as TMVBNeuronio;
      { normaliza deltas para camadas ocultas, a de saída não é preciso }
      LNeuronio.Delta := LNeuronio.Valor * (1 - LNeuronio.Valor) *
        LNeuronio.Delta / LCamada.Neuronios.Count;
    end;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBMultiLayerPerceptron.Build
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBMultiLayerPerceptron.Build;
var
  LIndex: Integer;
  LTipoCamada: TMVBTipoCamada;

  procedure LCriarCamada(ATipoCamada: TMVBTipoCamada;
    AQuantidadeNeuronios: Integer);
  var
    LCamada: TMVBCamada;
  begin
    { se existir algum neurônio na camada }
    if AQuantidadeNeuronios > 0 then
    begin
      { cria a camada }
      LCamada := TMVBCamada.Create;
      { configura a camada }
      LCamada.TipoCamada := ATipoCamada;
      LCamada.QuantidadeNeuronios := AQuantidadeNeuronios;
      { inclui camada na lista de camadas }
      FCamadas.Inserir(LCamada);
    end;
  end;

begin
  { se a rede não estiver preparada }
  if not FEstaPreparada then
  begin
    Randomize;
    { limpa a lista de camadas }
    FCamadas.Clear;
    { cria a primeira camada }
    LCriarCamada(tcEntrada, StrToInt(FEstrutura[0]));
    { cria camadas intermediárias e camada de saída }
    for LIndex := 1 to FEstrutura.Count - 1 do
    begin
      { informa o tipo da camada, padrão escondida  }
      LTipoCamada := tcEscondida;
      if (LIndex = FEstrutura.Count - 1) then
      begin
        { informa que a camada deve ser de saída }
        LTipoCamada := tcSaida;
      end;
      { cria camada de saída }
      LCriarCamada(LTipoCamada, StrToInt(FEstrutura[LIndex]));
    end;
    { se não estiver carregando de uma arquivo }
    if not FOnLoad then
    begin
      { cria as sinapses }
      Self.CriarSinapses;
    end;
    { informa que a rede está preparada }
    FEstaPreparada := True;
  end
  else
  begin
    { informa que a rede não está construída }
    raise EMVBMultiLayerPerceptronRedeNaoConstruida.Create;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBMultiLayerPerceptron.CriarSinapses
  Author:    Vinícius
  Date:      15-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBMultiLayerPerceptron.CriarSinapses;
var
  LSinapse: TMVBSinapse;
  LCamada, LCamadaPosterior: TMVBCamada;
  LIndex, LIndexCamada, LIndexCamadaPosterior: Integer;
  LNeuronio: TMVBNeuronio;
begin
  { percorre todas as camadas, com exceção da camade de saída }
  for LIndex := 0 to FCamadas.Count - 2 do
  begin
    { recupera a camada }
    LCamada := FCamadas.ProcurarPorIndice(LIndex) as TMVBCamada;
    { recupera a próxima camada }
    LCamadaPosterior := FCamadas.ProcurarPorIndice(LIndex + 1) as TMVBCamada;
    { percorre todos os neurônios da camada }
    for LIndexCamada := 0 to LCamada.Neuronios.Count - 1 do
    begin
      { recupera o neurônio }
      LNeuronio := LCamada.Neuronios.ProcurarPorIndice(LIndexCamada) as
        TMVBNeuronio;
      { percorre todos os neurônios da camada posterior }
      for LIndexCamadaPosterior := 0 to LCamadaPosterior.Neuronios.Count - 1 do
      begin
        { cria um peso }
        LSinapse := TMVBSinapse.Create;
        { guarda o ponteiro do neurônio }
        LSinapse.Neuronio := LNeuronio;
        { guarda o ponteiro do neurônio da próxima camada }
        LSinapse.NeuronioProximaCamada :=
          LCamadaPosterior.Neuronios.ProcurarPorIndice(
          LIndexCamadaPosterior) as TMVBNeuronio;
        { adiciona sinapse à lista }
        LCamada.Sinapses.Inserir(LSinapse);
      end;
    end;
    { inicializa os pesos }
    LCamada.InicializarSinapses;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBMultiLayerPerceptron.Clear
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: None
  Result:    None

  Obs:       O método Clear serve para inicializar o objeto instaciado.
             Para inicializar sinapses use o método InicializarSinapses.
-----------------------------------------------------------------------------}

procedure TMVBMultiLayerPerceptron.Clear;
begin
  inherited;
  { se não estiver no Load }
  if not FOnLoad then
  begin
    { inicializa o arquivo de conhecimento }
    FArquivoConhecimento := C_STRING_NULL;
  end;
  { inicializa propriedades }
  FEstaPreparada := False;
  FLista := C_STRING_NULL;
  FGama := 0;
  { inicializa o aprendizado }
  FAprendizado := 0.9;
  { inicializa o momento }
  FMomento := 0.5;
  { limpa as camadas }
  FEstrutura.Clear;
  { limpa as camadas }
  FCamadas.Clear;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBMultiLayerPerceptron.InicializarSinapses
  Author:    Vinícius
  Date:      11-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBMultiLayerPerceptron.InicializarSinapses;
var
  LIndex: Integer;
  LCamada: TMVBCamada;
begin
  { percorre todas as camadas }
  for LIndex := 0 to FCamadas.Count - 1 do
  begin
    { recupera a camada }
    LCamada := FCamadas.ProcurarPorIndice(LIndex) as TMVBCamada;
    { inicializa sinapses }
    LCamada.InicializarSinapses;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBMultiLayerPerceptron.CorrectWeight
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBMultiLayerPerceptron.CorrectWeight;
var
  LCamada: TMVBCamada;
  LSinapse: TMVBSinapse;
  LIndexCamada, LIndexSinapse: Integer;
begin
  { percorre todas as camadas  }
  for LIndexCamada := 0 to FCamadas.Count - 1 do
  begin
    { recupera a camada }
    LCamada := FCamadas.ProcurarPorIndice(LIndexCamada) as TMVBCamada;
    { percorre todas as sinapses da camada }
    for LIndexSinapse := 0 to LCamada.Sinapses.Count - 1 do
    begin
      { recupera a sinapse }
      LSinapse := LCamada.Sinapses.ProcurarPorIndice(LIndexSinapse) as
        TMVBSinapse;
      { corrige os pesos }
      LSinapse.Delta := (FMomento * LSinapse.Delta) - (FAprendizado *
        LSinapse.NeuronioProximaCamada.Delta * LSinapse.Neuronio.Valor);
      { atualiza as sinapses }
      LSinapse.Valor := LSinapse.Valor - LSinapse.Delta;
    end;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBMultiLayerPerceptron.CorrectWeightPruning
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBMultiLayerPerceptron.CorrectWeightPruning;
var
  LCamada: TMVBCamada;
  LSinapse: TMVBSinapse;
  LIndexCamada, LIndexSinapse: Integer;
  LSquare: Double;
begin
  { percorre todas as camadas  }
  for LIndexCamada := 0 to FCamadas.Count - 1 do
  begin
    { recupera a camada }
    LCamada := FCamadas.ProcurarPorIndice(LIndexCamada) as TMVBCamada;
    { percorre todas as sinapses da camada }
    for LIndexSinapse := 0 to LCamada.Sinapses.Count - 1 do
    begin
      { recupera a sinapse }
      LSinapse := LCamada.Sinapses.ProcurarPorIndice(LIndexSinapse) as
        TMVBSinapse;
      { corrige os pesos }
      LSquare := LSinapse.Valor * LSinapse.Valor;
      LSinapse.Valor := LSinapse.Valor * (1 - (FGama / ((1 + LSquare) * (1 +
        LSquare))));
      LSinapse.Delta := (0.9 * LSinapse.Delta) -
        (LSinapse.NeuronioProximaCamada.Delta * LSinapse.Neuronio.Valor);
      { atualiza as sinapses }
      LSinapse.Valor := LSinapse.Valor - LSinapse.Delta;
    end;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBMultiLayerPerceptron.Cost
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: None
  Result:    Double
-----------------------------------------------------------------------------}

function TMVBMultiLayerPerceptron.Cost: Double;
var
  LCamada: TMVBCamada;
  LNeuronio: TMVBNeuronio;
  LIndex: Integer;
  LErro: Double;
begin
  { recupera a camada de saída }
  LCamada := Self.RecuperarCamadaSaida;
  { inicializa o erro }
  LErro := 0;
  { percorre todos os neurônios }
  for LIndex := 0 to LCamada.Neuronios.Count - 1 do
  begin
    { recupera o neurônio }
    LNeuronio := LCamada.Neuronios.ProcurarPorIndice(LIndex) as TMVBNeuronio;
    { calcula o valor para o erro }
    LErro := LErro +
      (LNeuronio.Alvo - LNeuronio.Valor) * (LNeuronio.Alvo - LNeuronio.Valor);
  end;
  { retorna o valor }
  Result := 0.5 * LErro;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBMultiLayerPerceptron.Create
  Author:    Vinícius
  Date:      14-dez-2003
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

constructor TMVBMultiLayerPerceptron.Create;
begin
  inherited;
  { cria o objeto de estrutura }
  FEstrutura := TStringList.Create;
  { cria a lista de camadas }
  FCamadas := TMVBListaCamada.Create;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBMultiLayerPerceptron.Destroy
  Author:    Vinícius
  Date:      14-dez-2003
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

destructor TMVBMultiLayerPerceptron.Destroy;
begin
  { libera a lista de camadas }
  FCamadas.Free;
  { libera o objeto estrutura }
  FEstrutura.Free;
  inherited;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBMultiLayerPerceptron.SetEstrutura
  Author:    Vinícius
  Date:      14-dez-2003
  Arguments: const Value: TStrings
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBMultiLayerPerceptron.FeedForward;
var
  LCamada, LCamadaPosterior: TMVBCamada;
  LSinapse: TMVBSinapse;
  LNeuronio: TMVBNeuronio;
  LIndexCamadas, LIndexSinapses, LIndexNeuronios: Integer;
begin
  { percorre todas as camadas, com exceção da camade de saída }
  for LIndexCamadas := 0 to FCamadas.Count - 2 do
  begin
    { recupera a camada }
    LCamada := FCamadas.ProcurarPorIndice(LIndexCamadas) as TMVBCamada;
    LCamadaPosterior := FCamadas.ProcurarPorIndice(LIndexCamadas + 1) as
      TMVBCamada;
    { percorre todas as sinapses da camada }
    for LIndexSinapses := 0 to LCamada.Sinapses.Count - 1 do
    begin
      { recupera a sinapse }
      LSinapse := LCamada.Sinapses.ProcurarPorIndice(LIndexSinapses) as
        TMVBSinapse;
      { acumula valores de w * x na próxima camada }
      LSinapse.NeuronioProximaCamada.Valor :=
        LSinapse.NeuronioProximaCamada.Valor + LSinapse.Neuronio.Valor *
        LSinapse.Valor;
    end;
    { percorre todos os neurônios da camada }
    for LIndexNeuronios := 0 to LCamadaPosterior.Neuronios.Count - 1 do
    begin
      { recupera o neurônio }
      LNeuronio := LCamadaPosterior.Neuronios.ProcurarPorIndice(
        LIndexNeuronios) as TMVBNeuronio;
      { normaliza valores de v, calculando a ativação }
      LNeuronio.Valor := Self.Ativacao(LNeuronio.Valor /
        LCamada.Neuronios.Count);
    end;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBMultiLayerPerceptron.QuantidadePesosZerados
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: None
  Result:    Longint

  Obs:       Não entendi o objetivo desse método.
-----------------------------------------------------------------------------}

function TMVBMultiLayerPerceptron.List: string;
var
  LCont, LIndex: Integer;
  LCamada: TMVBCamada;
  LResult: string;
begin
  { incializa resultado }
  LResult := '';
  { percorre todas as camadas }
  for LCont := 0 to FCamadas.Count - 1 do
  begin
    { recupera o índice das camadas }
    LResult := LResult + Format('C: %d', [LCont]);
    { recupera a camada }
    LCamada := FCamadas.ProcurarPorIndice(LCont) as TMVBCamada;
    { percorre todos os neurônios }
    for LIndex := 0 to LCamada.Neuronios.Count - 1 do
    begin
      { recupera o índice das camadas }
      LResult := LResult + Format(' N: %d', [LIndex]);
    end;
  end;
  LResult := LResult + ' ##### ';
  { percorre todas as camadas }
  for LCont := 0 to FCamadas.Count - 1 do
  begin
    { recupera o índice das camadas }
    LResult := LResult + Format('C: %d', [LCont]);
    { recupera a camada }
    LCamada := FCamadas.ProcurarPorIndice(LCont) as TMVBCamada;
    { percorre todas as sinapses }
    for LIndex := 0 to LCamada.Sinapses.Count - 1 do
    begin
      { recupera o índice das camadas }
      LResult := LResult + Format(' S: %d/%d-%d',
        [LIndex, LIndex - 1, LIndex + 1]);
    end;
  end;
  { retorna o valor }
  Result := LResult;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBMultiLayerPerceptron.Load
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBMultiLayerPerceptron.Load;
var
  LArquivo: TMemIniFile;
  LEstrutura, LIndexEstrutura,
    LIndexCamadas, LIndexSinapses, LIndexNeuronios,
    LCamadaAtual: Integer;
  LCamada: TMVBCamada;
  LSinapse: TMVBSinapse;
  LNeuronio: TMVBNeuronio;
  LSinapses: TStringList;

  procedure LRecuperarOrdens(AOrdem: string);
  var
    LTemp: string;
  begin
    { recupera só os números de ordem }
    LTemp := Trim(Copy(AOrdem, 1, Pos('=', AOrdem) - 1));
    { recupera a camada atual }
    LCamadaAtual := StrToInt(Copy(LTemp, 1, Pos('.', LTemp) - 1));
  end;

  function LRetirarValor(var ATexto: string): string;
  begin
    { recupera o resultado }
    Result := Trim(Copy(ATexto, 1, Pos(';', ATexto) - 1));
    { retira o valor recuperado do texto }
    Delete(ATexto, 1, Pos(';', ATexto));
  end;

  procedure LRecuperarValores(AValores: string);
  var
    LTemp, LValor: string;
    LCamadaPosterior: TMVBCamada;
  begin
    { recupera somente os valores }
    LTemp := Trim(Copy(AValores, Pos('=', AValores) + 1, Length(AValores)));
    { recupera o valor do identificador da sinapse }
    LSinapse.Id := StringToGUID(LRetirarValor(LTemp));
    { recupera o valor da sinapse }
    LSinapse.Valor := StrToFloat(LRetirarValor(LTemp));
    { recupera o identificador do neurônio }
    LValor := LRetirarValor(LTemp);
    { recupera o neurônio }
    LSinapse.Neuronio := LCamada.Neuronios.ProcurarPorChave(LValor) as
      TMVBNeuronio;
    { recupera a próxima camada }
    LCamadaPosterior := FCamadas.ProcurarPorIndice(LCamadaAtual + 1) as
      TMVBCamada;
    { recupera o identificador do neurônio }
    LValor := LRetirarValor(LTemp);
    { recupera o neurônio }
    LSinapse.NeuronioProximaCamada :=
      LCamadaPosterior.Neuronios.ProcurarPorChave(LValor) as TMVBNeuronio;
  end;

begin
  if not FileExists(FArquivoConhecimento) then
  begin
    raise EMVBMultiLayerPerceptronArquivoConhecimentoInexistente.Create(
      FArquivoConhecimento);
  end;
  { abre o arquivo de conhecimento }
  LArquivo := TMemIniFile.Create(FArquivoConhecimento);
  try
    { informa que está no Load }
    FOnLoad := True;
    { limpa todo o objeto }
    Self.Clear;
    { recupera o nome do arquivo }
    { recupera os dados do arquivo }
    Self.Gama := LArquivo.ReadFloat('Gama', 'Valor', 0);
    Self.Aprendizado := LArquivo.ReadFloat('Aprendizado', 'Valor', 0.9);
    Self.Momento := LArquivo.ReadFloat('Momento', 'Valor', 0.5);
    { recupera a estrutura da rede }
    LEstrutura := LArquivo.ReadInteger('Estrutura', 'Count', 0);
    { percorre toda a estrutura }
    for LIndexEstrutura := 0 to LEstrutura - 1 do
    begin
      { recupera a quantidade de neurônios de cada camada }
      Self.Estrutura.Add(LArquivo.ReadString('Estrutura',
        IntToStr(LIndexEstrutura), '0'));
    end;
    { carrega a rede }
    Self.Build;

    { percorre todas as camadas para recuperar os identificadores dos neurônios }
    for LIndexCamadas := 0 to FCamadas.Count - 1 do
    begin
      { recupera a camada }
      LCamada := FCamadas.ProcurarPorIndice(LIndexCamadas) as TMVBCamada;
      { percorre todos os neurônios }
      for LIndexNeuronios := 0 to LCamada.Neuronios.Count - 1 do
      begin
        { recupera o neurônio }
        LNeuronio := LCamada.Neuronios.ProcurarPorIndice(LIndexNeuronios) as
          TMVBNeuronio;
        { recupera o identificador do neurônio }
        LNeuronio.Id := StringToGUID(LArquivo.ReadString('Neurônios',
          { recupera o valor do arquivo }
          Format('%d.%d', [LIndexCamadas, LIndexNeuronios]),
          { se não existir utiliza o já existente }
          GUIDToString(LNeuronio.Id)));
      end;
    end;

    { inicializa conteiner de sinapses }
    LSinapses := TStringList.Create;
    try
      { recupera os pesos sinápticos }
      LArquivo.ReadSectionValues('Sinapses', LSinapses);
      { inicializa organizadores }
      LCamadaAtual := 0;
      { percorre todos os itens }
      for LIndexSinapses := 0 to LSinapses.Count - 1 do
      begin
        { cria a sinapse }
        LSinapse := TMVBSinapse.Create;
        { inicializa a sinapse }
        LSinapse.Inicializar;
        { recupera a ordem }
        LRecuperarOrdens(LSinapses[LIndexSinapses]);
        { recupera a camada }
        LCamada := FCamadas.ProcurarPorIndice(LCamadaAtual) as TMVBCamada;
        { recupera os valores das sinapses }
        LRecuperarValores(LSinapses[LIndexSinapses]);
        { insere sinapse na camada }
        LCamada.Sinapses.Inserir(LSinapse);
      end;
    finally
      LSinapses.Free;
    end;
  finally
    { saindo do Load }
    FOnLoad := False;
    LArquivo.Free;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBMultiLayerPerceptron.Purge
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBMultiLayerPerceptron.Purge;
var
  LCamada: TMVBCamada;
  LSinapse: TMVBSinapse;
  LIndexCamadas, LIndexSinapses: Integer;
begin
  { percorre todas as camadas }
  for LIndexCamadas := 0 to FCamadas.Count - 1 do
  begin
    { recupera a camada }
    LCamada := FCamadas.ProcurarPorIndice(LIndexCamadas) as TMVBCamada;
    { percorre todas as sinapses da camada }
    LIndexSinapses := 0;
    while LIndexSinapses < LCamada.Sinapses.Count do
    begin
      { recupera a sinapse }
      LSinapse := LCamada.Sinapses.ProcurarPorIndice(LIndexSinapses) as
        TMVBSinapse;
      { checa o valor da sinapse }
      if Trunc(LSinapse.Valor * 100) = 0 then
      begin
        { exclui a sinapse }
        LCamada.Sinapses.Excluir(LSinapse);
      end
      else
      begin
        Inc(LIndexSinapses);
      end;
    end;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBMultiLayerPerceptron.QuantidadePesosZerados
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: None
  Result:    Longint
-----------------------------------------------------------------------------}

function TMVBMultiLayerPerceptron.QuantidadePesosZerados: Longint;
var
  LIndex, LIndexSinapse: Integer;
  LCamada: TMVBCamada;
  LSinapse: TMVBSinapse;
  LZeros: Integer;
begin
  LZeros := 0;
  { percorre todas as camadas }
  for LIndex := 0 to FCamadas.Count - 1 do
  begin
    { recupera a camada }
    LCamada := FCamadas.ProcurarPorIndice(LIndex) as TMVBCamada;
    { percorre todos as sinapses }
    for LIndexSinapse := 0 to LCamada.Sinapses.Count - 1 do
    begin
      { recupera a sinapse }
      LSinapse := LCamada.Sinapses.ProcurarPorIndice(LIndexSinapse) as
        TMVBSinapse;
      { checa se o produto é zero }
      if Trunc(LSinapse.Valor * 100) = 0 then
      begin
        { incrementa }
        Inc(LZeros);
      end;
    end;
  end;
  { retorna o valor }
  Result := LZeros;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBMultiLayerPerceptron.RecuperarSaida
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: AIndiceNeuronio: Integer
  Result:    Double
-----------------------------------------------------------------------------}

function TMVBMultiLayerPerceptron.RecuperarSaida(
  AIndiceNeuronio: Integer): Double;
var
  LCamadaSaida: TMVBCamada;
  LNeuronio: TMVBNeuronio;
  LResult: Double;
begin
  { recupera a camada de saída }
  LCamadaSaida := Self.RecuperarCamadaSaida;
  { recupera o neurônio }
  LNeuronio := LCamadaSaida.Neuronios.ProcurarPorIndice(
    AIndiceNeuronio) as TMVBNeuronio;
  { recupera o resultado }
  LResult := LNeuronio.Valor - 1 *
    (LNeuronio.ValorMaximo - LNeuronio.ValorMinimo) + LNeuronio.ValorMaximo;
  { retorna o resultado }
  Result := LResult;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBMultiLayerPerceptron.Save
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBMultiLayerPerceptron.Save;
var
  LArquivo: TMemIniFile;
  LCamada: TMVBCamada;
  LSinapse: TMVBSinapse;
  LNeuronio: TMVBNeuronio;
  LIndexEstrutura, LIndexCamadas, LIndexSinapses, LIndexNeuronios: Integer;
begin
  { arquivo de conteúdo }
  LArquivo := TMemIniFile.Create(FArquivoConhecimento);
  try
    { guarda as propriedades da rede }
    LArquivo.WriteFloat('Gama', 'Valor', FGama);
    LArquivo.WriteFloat('Aprendizado', 'Valor', FAprendizado);
    LArquivo.WriteFloat('Momento', 'Valor', FMomento);
    LArquivo.WriteInteger('Estrutura', 'Count', FEstrutura.Count);
    { percorre toda a estrutura }
    for LIndexEstrutura := 0 to FEstrutura.Count - 1 do
    begin
      { salva as quantidades de neurônios de cada camada }
      LArquivo.WriteString('Estrutura', IntToStr(LIndexEstrutura),
        FEstrutura[LIndexEstrutura]);
    end;
    { salva todos os identificadores de neurônios }
    for LIndexCamadas := 0 to FCamadas.Count - 1 do
    begin
      { recupera a camada }
      LCamada := FCamadas.ProcurarPorIndice(LIndexCamadas) as TMVBCamada;
      { percorre todos os neurônios }
      for LIndexNeuronios := 0 to LCamada.Neuronios.Count - 1 do
      begin
        { recupera o neurônio }
        LNeuronio := LCamada.Neuronios.ProcurarPorIndice(
          LIndexNeuronios) as TMVBNeuronio;
        { salva os dados da sinapse }
        LArquivo.WriteString('Neurônios', Format('%d.%d', [
          { informa o número da camada }
          LIndexCamadas,
            { informa o número da sinapse }
          LIndexNeuronios]),
            { informa o indetificador do neurônio }
          GUIDToString(LNeuronio.Id));
      end;
    end;

    { salva todos os pesos sinápticos, com exceção da camada de saída }
    for LIndexCamadas := 0 to FCamadas.Count - 2 do
    begin
      { recupera a camada }
      LCamada := FCamadas.ProcurarPorIndice(LIndexCamadas) as TMVBCamada;
      { percorre todas as sinapses }
      for LIndexSinapses := 0 to LCamada.Sinapses.Count - 1 do
      begin
        { recupera a sinapse }
        LSinapse := LCamada.Sinapses.ProcurarPorIndice(
          LIndexSinapses) as TMVBSinapse;
        { salva os dados da sinapse }
        LArquivo.WriteString('Sinapses', Format('%d.%d', [
          { informa o número da camada }
          LIndexCamadas,
            { informa o número da sinapse }
          LIndexSinapses]), Format('%s; %s; %s; %s;', [
            { informa o identificador da sinapse }
          GUIDToString(LSinapse.Id),
            { informa o valor da sinapse - %4.12f }
          FloatToStr(LSinapse.Valor),
            { informa o indetificador do neurônio }
          GUIDToString(LSinapse.Neuronio.Id),
            { informa o indetificador do neurônio da próxima camada }
          GUIDToString(LSinapse.NeuronioProximaCamada.Id)]));
      end;
    end;
    LArquivo.UpdateFile;
  finally
    LArquivo.Free;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBMultiLayerPerceptron.SetCamadas
  Author:    Vinícius
  Date:      11-jan-2000
  Arguments: const Value: TMVBListaCamada
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBMultiLayerPerceptron.SetCamadas(
  const Value: TMVBListaCamada);
begin
  FCamadas.AssignObjects(Value);
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBMultiLayerPerceptron.SetEstrutura
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: const Value: TStrings
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBMultiLayerPerceptron.SetEstrutura(const Value: TStrings);
begin
  FEstrutura := Value;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBMultiLayerPerceptron.Test
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBMultiLayerPerceptron.Test;
begin
  { faz somente a passagem dos valores de entrada pelos pesos sinápticos }
  Self.FeedForward;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBMultiLayerPerceptron.Training
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBMultiLayerPerceptron.Training;
begin
  { Presume que os valores de entrada já estejam colocados, junto com os alvos.
    Executa o processo somente uma vez. }
  Self.FeedForward;
  Self.BackPropagation;
  Self.CorrectWeight;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBMultiLayerPerceptron.TrainingPruning
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: Epocas: Integer
  Result:    Longint
-----------------------------------------------------------------------------}

function TMVBMultiLayerPerceptron.TrainingPruning(AEpocas: Integer): Longint;
begin
  { Presume que os valores de entrada já estejam colocados, junto com os alvos.
    Executa o processo somente uma vez. }
  Self.FeedForward;
  Self.BackPropagation;
  FGama := FGama + (0.1 / AEpocas);
  Self.CorrectWeightPruning;
  { conta quantas sinapses foram zeradas pelo processo }
  Result := Self.QuantidadePesosZerados;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBMultiLayerPerceptron.ValorEntrada
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: AIndiceNeuronio: Integer; AValor: Double
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBMultiLayerPerceptron.ValorEntrada(AIndiceNeuronio: Integer;
  AValor: Double);
var
  LCamadaEntrada: TMVBCamada;
  LNeuronio: TMVBNeuronio;
begin
  { recupera a camada de entrada }
  LCamadaEntrada := Self.RecuperarCamadaEntrada;
  { recupera o neurônio }
  LNeuronio := LCamadaEntrada.Neuronios.ProcurarPorIndice(
    AIndiceNeuronio) as TMVBNeuronio;
  { entrada já transformada }
  LNeuronio.Valor := 1 + 2 * (AValor - LNeuronio.ValorMaximo) /
    (LNeuronio.ValorMaximo - LNeuronio.ValorMinimo);
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBMultiLayerPerceptron.ValorEntradaMaximo
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: AIndiceNeuronio: Integer; AValor: Double
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBMultiLayerPerceptron.ValorEntradaMaximo(
  AIndiceNeuronio: Integer; AValor: Double);
var
  LCamadaEntrada: TMVBCamada;
  LNeuronio: TMVBNeuronio;
begin
  { recupera a camada de entrada }
  LCamadaEntrada := Self.RecuperarCamadaEntrada;
  { recupera o neurônio }
  LNeuronio := LCamadaEntrada.Neuronios.ProcurarPorIndice(
    AIndiceNeuronio) as TMVBNeuronio;
  { passa o valor }
  LNeuronio.ValorMaximo := AValor;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBMultiLayerPerceptron.ValorEntradaMinimo
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: AIndiceNeuronio: Integer; AValor: Double
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBMultiLayerPerceptron.ValorEntradaMinimo(
  AIndiceNeuronio: Integer; AValor: Double);
var
  LCamadaEntrada: TMVBCamada;
  LNeuronio: TMVBNeuronio;
begin
  { recupera a camada de entrada }
  LCamadaEntrada := Self.RecuperarCamadaEntrada;
  { recupera o neurônio }
  LNeuronio := LCamadaEntrada.Neuronios.ProcurarPorIndice(
    AIndiceNeuronio) as TMVBNeuronio;
  { passa o valor }
  LNeuronio.ValorMinimo := AValor;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBMultiLayerPerceptron.ValorSaida
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: AIndiceNeuronio: Integer; AValor: Double
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBMultiLayerPerceptron.ValorSaida(AIndiceNeuronio: Integer;
  AValor: Double);
var
  LCamadaSaida: TMVBCamada;
  LNeuronio: TMVBNeuronio;
begin
  { recupera a camada de saída }
  LCamadaSaida := Self.RecuperarCamadaSaida;
  { recupera o neurônio }
  LNeuronio := LCamadaSaida.Neuronios.ProcurarPorIndice(
    AIndiceNeuronio) as TMVBNeuronio;
  { [0,1] }
  LNeuronio.Alvo := 1 + (AValor - LNeuronio.ValorMaximo) /
    (LNeuronio.ValorMaximo - LNeuronio.ValorMinimo);
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBMultiLayerPerceptron.ValorSaidaMaximo
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: AIndiceNeuronio: Integer; AValor: Double
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBMultiLayerPerceptron.ValorSaidaMaximo(AIndiceNeuronio: Integer;
  AValor: Double);
var
  LCamadaSaida: TMVBCamada;
  LNeuronio: TMVBNeuronio;
begin
  { recupera a camada de saída }
  LCamadaSaida := Self.RecuperarCamadaSaida;
  { recupera o neurônio }
  LNeuronio := LCamadaSaida.Neuronios.ProcurarPorIndice(
    AIndiceNeuronio) as TMVBNeuronio;
  { passa o valor }
  LNeuronio.ValorMaximo := AValor;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBMultiLayerPerceptron.ValorSaidaMinimo
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: AIndiceNeuronio: Integer; AValor: Double
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBMultiLayerPerceptron.ValorSaidaMinimo(AIndiceNeuronio: Integer;
  AValor: Double);
var
  LCamadaSaida: TMVBCamada;
  LNeuronio: TMVBNeuronio;
begin
  { recupera a camada de saída }
  LCamadaSaida := Self.RecuperarCamadaSaida;
  { recupera o neurônio }
  LNeuronio := LCamadaSaida.Neuronios.ProcurarPorIndice(
    AIndiceNeuronio) as TMVBNeuronio;
  { passa o valor }
  LNeuronio.ValorMinimo := AValor;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBMultiLayerPerceptron.RecuperarUltimaCamada
  Author:    Vinícius
  Date:      11-jan-2000
  Arguments: None
  Result:    TMVBCamada
-----------------------------------------------------------------------------}

function TMVBMultiLayerPerceptron.RecuperarCamadaSaida: TMVBCamada;
begin
  { recupera a última camada }
  Result := FCamadas.ProcurarPorIndice(FCamadas.Count - 1) as TMVBCamada;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBMultiLayerPerceptron.RecuperarCamadaEntrada
  Author:    Vinícius
  Date:      11-jan-2000
  Arguments: None
  Result:    TMVBCamada
-----------------------------------------------------------------------------}

function TMVBMultiLayerPerceptron.RecuperarCamadaEntrada: TMVBCamada;
begin
  { recupera a primeira camada }
  Result := FCamadas.ProcurarPorIndice(0) as TMVBCamada;
end;

initialization
  RegisterClasses([TMVBCamada, TMVBNeuronio, TMVBSinapse]);

finalization
  UnRegisterClasses([TMVBCamada, TMVBNeuronio, TMVBSinapse]);

end.

