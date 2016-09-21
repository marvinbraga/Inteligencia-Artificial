unit uMVBMlpPrevisao;

interface

uses
  { borland }
  SysUtils, Controls, DB, ADODB,
  { mvb }
  uMVBClasses, uMVBConsts, uMVBMultiLayerPerceptron, uMVBParametrosRede;

type
  TMVBEventoTreinamento = procedure(AListaDados: TMVBListaBase;
    ACiclo, AEpoca: Integer; AErro: Extended) of object;

  TMVBMlpPrevisao = class(TMVBMultiLayerPerceptron)
  private
    FQuery: TADOQuery;
    FListaDados, FDadosPrevistos: TMVBListaBase;
    FErroTotal: Extended;
    FEpocas: Integer;
    FValorTeste: Integer;
    FValorAnterior: Extended;
    FParametrosRede: TMVBParametrosRede;
    FOrdemFinalTeste: Integer;
    FOrdemInicialTreinamento: Integer;
    FOrdemFinalTreinamento: Integer;
    FOrdemInicialTeste: Integer;
    FListaDadosTeste: TMVBListaBase;
    FOnTreinamento: TMVBEventoTreinamento;
    FQuantidadeEntradas: Integer;
    FUsarAtraso: Boolean;
    procedure RecuperarDados(const AListaDados: TMVBListaBase);
    procedure SetParametrosRede(const Value: TMVBParametrosRede);
    procedure SetOrdemFinalTeste(const Value: Integer);
    procedure SetOrdemFinalTreinamento(const Value: Integer);
    procedure SetOrdemInicialTeste(const Value: Integer);
    procedure SetOrdemInicialTreinamento(const Value: Integer);
    procedure SetOnTreinamento(const Value: TMVBEventoTreinamento);
    procedure SetUsarAtraso(const Value: Boolean);
  protected
    FAtraso: Integer;
    procedure ExecutarTeste; virtual; abstract;
    procedure RecuperarLimitesMinimosMaximos; virtual; abstract;
    procedure PassarParametrosParaRede;
    property QuantidadeEntradas: Integer
      read FQuantidadeEntradas write FQuantidadeEntradas;
  public
    constructor Create; override;
    destructor Destroy; override;
    property Gama;
  published
    procedure Treinar; virtual; abstract;
    procedure Construir;
    procedure Testar;
    property Query: TADOQuery read FQuery write FQuery;
    property Epocas: Integer read FEpocas write FEpocas;
    property ErroTotal: Extended read FErroTotal write FErroTotal;
    property ValorTeste: Integer read FValorTeste write FValorTeste;
    property DadosPrevistos: TMVBListaBase read FDadosPrevistos;
    property ListaDados: TMVBListaBase read FListaDados;
    property ListaDadosTeste: TMVBListaBase read FListaDadosTeste;
    property ValorAnterior: Extended read FValorAnterior;
    property ParametrosRede: TMVBParametrosRede read FParametrosRede
      write SetParametrosRede;
    property OrdemInicialTreinamento: Integer
      read FOrdemInicialTreinamento write SetOrdemInicialTreinamento;
    property OrdemFinalTreinamento: Integer
      read FOrdemFinalTreinamento write SetOrdemFinalTreinamento;
    property OrdemInicialTeste: Integer
      read FOrdemInicialTeste write SetOrdemInicialTeste;
    property OrdemFinalTeste: Integer read FOrdemFinalTeste
      write SetOrdemFinalTeste;
    property UsarAtraso: Boolean read FUsarAtraso write SetUsarAtraso;
    { evento }
    property OnTreinamento: TMVBEventoTreinamento
      read FOnTreinamento write SetOnTreinamento;
  end;

  TMVBMlpPrevisaoLongoPrazo = class(TMVBMlpPrevisao)
  private
  protected
    procedure ExecutarTeste; override;
    procedure RecuperarLimitesMinimosMaximos; override;
  public
    constructor Create; override;
    procedure Treinar; override;
  published
  end;

  TMVBMlpPrevisaoLongoPrazoComValoresAnteriores = class(TMVBMlpPrevisao)
  private
  protected
    procedure ExecutarTeste; override;
    procedure RecuperarLimitesMinimosMaximos; override;
  public
    constructor Create; override;
    procedure Treinar; override;
  published
  end;

  TMVBMlpPrevisaoFechamento = class(TMVBMlpPrevisao)
  private
  protected
    procedure ExecutarTeste; override;
    procedure RecuperarLimitesMinimosMaximos; override;
  public
    constructor Create; override;
    procedure Treinar; override;
  published
  end;

implementation

uses
  { borland }
  Dialogs,
  { mvb }
  uMVBDadoPrevisaoLongoPrazo;

{ **************************************************************************** }
{ TMVBMlpPrevisao }
{ **************************************************************************** }

procedure TMVBMlpPrevisao.Construir;
begin
  Self.PassarParametrosParaRede;
  { verifica os valores }
  if Query.Active then
  begin
    Query.Close;
  end;
  { prepara a query com os dados para o treinamento }
  Query.Parameters[0].Value := FOrdemInicialTreinamento;
  Query.Parameters[1].Value := FOrdemFinalTreinamento;
  Query.Prepared := True;
  Query.Open;
  try
    Self.RecuperarLimitesMinimosMaximos;
    Self.RecuperarDados(FListaDados);
  finally
    { fecha a query }
    Query.Close;
  end;
end;

constructor TMVBMlpPrevisao.Create;
begin
  inherited;
  FListaDados := TMVBListaBase.Create;
  FListaDadosTeste := TMVBListaBase.Create;
  FDadosPrevistos := TMVBListaBase.Create;
  FParametrosRede := TMVBParametrosRede.Create;
  Self.UsarAtraso := False;
end;

destructor TMVBMlpPrevisao.Destroy;
begin
  FListaDados.Free;
  FListaDadosTeste.Free;
  FDadosPrevistos.Free;
  FParametrosRede.Free;
  inherited;
end;

procedure TMVBMlpPrevisao.PassarParametrosParaRede;
begin
  { informa o nome do arquivo }
  Self.ArquivoConhecimento := Self.ParametrosRede.ArquivoConhecimento;
  { checa se o arquivo existe }
  if not FileExists(Self.ArquivoConhecimento) then
  begin
    ShowMessage('Não existe o arquivo ' + Self.ArquivoConhecimento +
      '. Continuando...');
    { informa a estrutura }
    Self.Estrutura.Add(IntToStr(FQuantidadeEntradas));
    { checa se existem unidades ocultas }
    if Self.ParametrosRede.UnidadesOcultas > 0 then
    begin
      Self.Estrutura.Add(IntToStr(Self.ParametrosRede.UnidadesOcultas));
    end;
    { adiciona camada de saída }
    Self.Estrutura.Add('1');
    { constroi a rede }
    Self.Build;
    { configura }
    Self.Aprendizado := Self.ParametrosRede.Apredizado;
    Self.Momento := Self.ParametrosRede.Momento;
  end
  else
  begin
    Self.Load;
  end;
end;

procedure TMVBMlpPrevisao.RecuperarDados(const AListaDados: TMVBListaBase);
var
  LDado: TMVBDadoPrevisaoLongoPrazo;
begin
  { limpa a lista }
  AListaDados.Clear;
  try
    Query.First;
    while not Query.Eof do
    begin
      { adiciona os dados à lista }
      LDado := TMVBDadoPrevisaoLongoPrazo.Create;
      { recupera os dados da data }
      LDado.Data.Data := Query.FieldByName('Data').AsDateTime;
      LDado.Data.DiaSemana.Seg := Query.FieldByName('Seg').AsInteger;
      LDado.Data.DiaSemana.Ter := Query.FieldByName('Ter').AsInteger;
      LDado.Data.DiaSemana.Qua := Query.FieldByName('Qua').AsInteger;
      LDado.Data.DiaSemana.Qui := Query.FieldByName('Qui').AsInteger;
      LDado.Data.DiaSemana.Sex := Query.FieldByName('Sex').AsInteger;
      LDado.Data.Dia.Dez00 := Query.FieldByName('DiaDez0').AsInteger;
      LDado.Data.Dia.Dez10 := Query.FieldByName('DiaDez10').AsInteger;
      LDado.Data.Dia.Dez20 := Query.FieldByName('DiaDez20').AsInteger;
      LDado.Data.Dia.Dez30 := Query.FieldByName('DiaDez30').AsInteger;
      LDado.Data.Dia.Uni0 := Query.FieldByName('DiaUni0').AsInteger;
      LDado.Data.Dia.Uni1 := Query.FieldByName('DiaUni1').AsInteger;
      LDado.Data.Dia.Uni2 := Query.FieldByName('DiaUni2').AsInteger;
      LDado.Data.Dia.Uni3 := Query.FieldByName('DiaUni3').AsInteger;
      LDado.Data.Dia.Uni4 := Query.FieldByName('DiaUni4').AsInteger;
      LDado.Data.Dia.Uni5 := Query.FieldByName('DiaUni5').AsInteger;
      LDado.Data.Dia.Uni6 := Query.FieldByName('DiaUni6').AsInteger;
      LDado.Data.Dia.Uni7 := Query.FieldByName('DiaUni7').AsInteger;
      LDado.Data.Dia.Uni8 := Query.FieldByName('DiaUni8').AsInteger;
      LDado.Data.Dia.Uni9 := Query.FieldByName('DiaUni9').AsInteger;
      LDado.Data.Mes.Janeiro := Query.FieldByName('Jan').AsInteger;
      LDado.Data.Mes.Fevereiro := Query.FieldByName('Fev').AsInteger;
      LDado.Data.Mes.Marco := Query.FieldByName('Mar').AsInteger;
      LDado.Data.Mes.Abril := Query.FieldByName('Abr').AsInteger;
      LDado.Data.Mes.Maio := Query.FieldByName('Mai').AsInteger;
      LDado.Data.Mes.Junho := Query.FieldByName('Jun').AsInteger;
      LDado.Data.Mes.Julho := Query.FieldByName('Jul').AsInteger;
      LDado.Data.Mes.Agosto := Query.FieldByName('Ago').AsInteger;
      LDado.Data.Mes.Setembro := Query.FieldByName('Set').AsInteger;
      LDado.Data.Mes.Outubro := Query.FieldByName('Out').AsInteger;
      LDado.Data.Mes.Novembro := Query.FieldByName('Nov').AsInteger;
      LDado.Data.Mes.Dezembro := Query.FieldByName('Dez').AsInteger;
      { ordem }
      LDado.Ordem := Query.FieldByName('Ordem').AsInteger;
      { valores }
      LDado.Retorno := Query.FieldByName('Retorno').AsFloat;
      LDado.Abertura := Query.FieldByName('Abertura').AsFloat;
      LDado.Maximo := Query.FieldByName('Maximo').AsFloat;
      LDado.Minimo := Query.FieldByName('Minimo').AsFloat;
      LDado.Fechamento := Query.FieldByName('Fechamento').AsFloat;
      LDado.Volume := Query.FieldByName('Volume').AsFloat;
      { adiciona à lista }
      AListaDados.Inserir(LDado);
      { próximo registro }
      Query.Next;
    end;
  except
    AListaDados.Clear;
    raise;
  end;
end;

procedure TMVBMlpPrevisao.SetOnTreinamento(
  const Value: TMVBEventoTreinamento);
begin
  FOnTreinamento := Value;
end;

procedure TMVBMlpPrevisao.SetOrdemFinalTeste(const Value: Integer);
begin
  FOrdemFinalTeste := Value;
end;

procedure TMVBMlpPrevisao.SetOrdemFinalTreinamento(const Value: Integer);
begin
  FOrdemFinalTreinamento := Value;
end;

procedure TMVBMlpPrevisao.SetOrdemInicialTeste(const Value: Integer);
begin
  FOrdemInicialTeste := Value;
end;

procedure TMVBMlpPrevisao.SetOrdemInicialTreinamento(
  const Value: Integer);
begin
  FOrdemInicialTreinamento := Value;
end;

procedure TMVBMlpPrevisao.SetParametrosRede(
  const Value: TMVBParametrosRede);
begin
  FParametrosRede.Assign(Value);
end;

procedure TMVBMlpPrevisao.SetUsarAtraso(const Value: Boolean);
begin
  FUsarAtraso := Value;
  FAtraso := 1;
  if FUsarAtraso then
  begin
    FAtraso := 0;
  end;
end;

procedure TMVBMlpPrevisao.Testar;
begin
  { verifica os valores }
  if Query.Active then
  begin
    Query.Close;
  end;
  { prepara a query com os dados para o treinamento }
  Query.Parameters[0].Value := FOrdemInicialTeste;
  Query.Parameters[1].Value := FOrdemFinalTeste;
  Query.Prepared := True;
  Query.Open;
  try
    { recupera os dados do treinamento }
    Self.RecuperarDados(FListaDadosTeste);
    { executa os testes }
    Self.ExecutarTeste;
  finally
    { fecha a query }
    Query.Close;
  end;
end;

{ **************************************************************************** }
{ TMVBMlpPrevisaoLongoPrazo }
{ **************************************************************************** }

constructor TMVBMlpPrevisaoLongoPrazo.Create;
begin
  inherited;
  { informa o número de entradas }
  FQuantidadeEntradas := 37;
end;

procedure TMVBMlpPrevisaoLongoPrazo.ExecutarTeste;
var
  LCont, LOrdem: Integer;
  LDado: TMVBDadoPrevisaoLongoPrazo;
begin
  { limpa a lista de previsão }
  FDadosPrevistos.Clear;
  { passa o valor para a próxima amostra }
  LDado := FListaDadosTeste.ProcurarPorIndice(0)
    as TMVBDadoPrevisaoLongoPrazo;
  LOrdem := LDado.Ordem;
  { insere o primeiro item como nulo }
  LDado := TMVBDadoPrevisaoLongoPrazo.Create;
  LDado.Ordem := LOrdem;
  LDado.Fechamento := 0;
  { insere a nova amostra na lista }
  FDadosPrevistos.Inserir(LDado);
  { recupera todos os dados da lista de treinamento }
  for LCont := 0 to FListaDadosTeste.Count - 1 do
  begin
    { recupera o dado }
    LDado := FListaDadosTeste.ProcurarPorIndice(LCont)
      as TMVBDadoPrevisaoLongoPrazo;
    { recupera todas as entradas }
    LOrdem := LDado.Ordem;
    Self.ValorEntrada(0, LDado.Data.DiaSemana.Seg);
    Self.ValorEntrada(1, LDado.Data.DiaSemana.Ter);
    Self.ValorEntrada(2, LDado.Data.DiaSemana.Qua);
    Self.ValorEntrada(3, LDado.Data.DiaSemana.Qui);
    Self.ValorEntrada(4, LDado.Data.DiaSemana.Sex);
    Self.ValorEntrada(5, LDado.Data.Dia.Dez00);
    Self.ValorEntrada(6, LDado.Data.Dia.Dez10);
    Self.ValorEntrada(7, LDado.Data.Dia.Dez20);
    Self.ValorEntrada(8, LDado.Data.Dia.Dez30);
    Self.ValorEntrada(9, LDado.Data.Dia.Uni0);
    Self.ValorEntrada(10, LDado.Data.Dia.Uni1);
    Self.ValorEntrada(11, LDado.Data.Dia.Uni2);
    Self.ValorEntrada(12, LDado.Data.Dia.Uni3);
    Self.ValorEntrada(13, LDado.Data.Dia.Uni4);
    Self.ValorEntrada(14, LDado.Data.Dia.Uni5);
    Self.ValorEntrada(15, LDado.Data.Dia.Uni6);
    Self.ValorEntrada(16, LDado.Data.Dia.Uni7);
    Self.ValorEntrada(17, LDado.Data.Dia.Uni8);
    Self.ValorEntrada(18, LDado.Data.Dia.Uni9);
    Self.ValorEntrada(19, LDado.Data.Mes.Janeiro);
    Self.ValorEntrada(20, LDado.Data.Mes.Fevereiro);
    Self.ValorEntrada(21, LDado.Data.Mes.Marco);
    Self.ValorEntrada(22, LDado.Data.Mes.Abril);
    Self.ValorEntrada(23, LDado.Data.Mes.Maio);
    Self.ValorEntrada(24, LDado.Data.Mes.Junho);
    Self.ValorEntrada(25, LDado.Data.Mes.Julho);
    Self.ValorEntrada(26, LDado.Data.Mes.Agosto);
    Self.ValorEntrada(27, LDado.Data.Mes.Setembro);
    Self.ValorEntrada(28, LDado.Data.Mes.Outubro);
    Self.ValorEntrada(29, LDado.Data.Mes.Novembro);
    Self.ValorEntrada(30, LDado.Data.Mes.Dezembro);
    Self.ValorEntrada(31, LDado.Retorno);
    Self.ValorEntrada(32, LDado.Abertura);
    Self.ValorEntrada(33, LDado.Maximo);
    Self.ValorEntrada(34, LDado.Minimo);
    Self.ValorEntrada(35, LDado.Volume);
    Self.ValorEntrada(36, LDado.Fechamento);
    { testa }
    Self.Test;
    { passa o valor para a próxima amostra }
    LDado := TMVBDadoPrevisaoLongoPrazo.Create;
    LDado.Ordem := LOrdem + FAtraso;
    LDado.Fechamento := Self.RecuperarSaida(0);
    { insere a nova amostra na lista }
    FDadosPrevistos.Inserir(LDado);
  end;
end;

procedure TMVBMlpPrevisaoLongoPrazo.RecuperarLimitesMinimosMaximos;
var
  LMaximoRetorno, LMinimoRetorno: Extended;
  LMaximoAbertura, LMinimoAbertura: Extended;
  LMaximoMaximo, LMinimoMaximo: Extended;
  LMaximoMinimo, LMinimoMinimo: Extended;
  LMaximoVolume, LMinimoVolume: Extended;
  LMaximoFechamento, LMinimoFechamento: Extended;
  LCont: Integer;
begin
  { informa os máximos e mínimos dos atributos binários }
  for LCont := 0 to 30 do
  begin
    Self.ValorEntradaMinimo(LCont, 0);
    Self.ValorEntradaMaximo(LCont, 1);
  end;
  { Definição dos valores máximo e mínimo do conjunto de treinamento }
  LMinimoRetorno := 1E9;
  LMaximoRetorno := -1E9;
  LMinimoAbertura := 1E9;
  LMaximoAbertura := -1E9;
  LMinimoMaximo := 1E9;
  LMaximoMaximo := -1E9;
  LMinimoMinimo := 1E9;
  LMaximoMinimo := -1E9;
  LMinimoVolume := 1E9;
  LMaximoVolume := -1E9;
  LMinimoFechamento := 1E9;
  LMaximoFechamento := -1E9;
  { recupera os valores de máximo e mínimo }
  Query.First;
  while not Query.Eof do
  begin
    { Retorno }
    if Query.FieldByName('Retorno').AsFloat > LMaximoRetorno then
    begin
      LMaximoRetorno := Query.FieldByName('Retorno').AsFloat;
    end;
    if Query.FieldByName('Retorno').AsFloat < LMinimoRetorno then
    begin
      LMinimoRetorno := Query.FieldByName('Retorno').AsFloat;
    end;
    { Abertura }
    if Query.FieldByName('Abertura').AsFloat > LMaximoAbertura then
    begin
      LMaximoAbertura := Query.FieldByName('Abertura').AsFloat;
    end;
    if Query.FieldByName('Abertura').AsFloat < LMinimoAbertura then
    begin
      LMinimoAbertura := Query.FieldByName('Abertura').AsFloat;
    end;
    { Maximo }
    if Query.FieldByName('Maximo').AsFloat > LMaximoMaximo then
    begin
      LMaximoMaximo := Query.FieldByName('Maximo').AsFloat;
    end;
    if Query.FieldByName('Maximo').AsFloat < LMinimoMaximo then
    begin
      LMinimoMaximo := Query.FieldByName('Maximo').AsFloat;
    end;
    { Minimo }
    if Query.FieldByName('Minimo').AsFloat > LMaximoMinimo then
    begin
      LMaximoMinimo := Query.FieldByName('Minimo').AsFloat;
    end;
    if Query.FieldByName('Minimo').AsFloat < LMinimoMinimo then
    begin
      LMinimoMinimo := Query.FieldByName('Minimo').AsFloat;
    end;
    { Volume }
    if Query.FieldByName('Volume').AsFloat > LMaximoVolume then
    begin
      LMaximoVolume := Query.FieldByName('Volume').AsFloat;
    end;
    if Query.FieldByName('Volume').AsFloat < LMinimoVolume then
    begin
      LMinimoVolume := Query.FieldByName('Volume').AsFloat;
    end;
    { Fechamento }
    if Query.FieldByName('Fechamento').AsFloat > LMaximoFechamento then
    begin
      LMaximoFechamento := Query.FieldByName('Fechamento').AsFloat;
    end;
    if Query.FieldByName('Fechamento').AsFloat < LMinimoFechamento then
    begin
      LMinimoFechamento := Query.FieldByName('Fechamento').AsFloat;
    end;
    Query.Next;
  end;
  { Definição da faixa de trabalho dos neurônios de entrada }
  Self.ValorEntradaMinimo(31, LMinimoRetorno);
  Self.ValorEntradaMaximo(31, LMaximoRetorno);
  Self.ValorEntradaMinimo(32, LMinimoAbertura);
  Self.ValorEntradaMaximo(32, LMaximoAbertura);
  Self.ValorEntradaMinimo(33, LMinimoMaximo);
  Self.ValorEntradaMaximo(33, LMaximoMaximo);
  Self.ValorEntradaMinimo(34, LMinimoMinimo);
  Self.ValorEntradaMaximo(34, LMaximoMinimo);
  Self.ValorEntradaMinimo(35, LMinimoVolume);
  Self.ValorEntradaMaximo(35, LMaximoVolume);
  Self.ValorEntradaMinimo(36, LMinimoFechamento);
  Self.ValorEntradaMaximo(36, LMaximoFechamento);
  { Definição da faixa de trabalho do neurônio de saída }
  Self.ValorSaidaMinimo(0, LMinimoFechamento);
  Self.ValorSaidaMaximo(0, LMaximoFechamento);
end;

procedure TMVBMlpPrevisaoLongoPrazo.Treinar;
var
  LContCiclos, LContDados, LOrdem: Integer;
  LDado, LDadoTemp: TMVBDadoPrevisaoLongoPrazo;
  LListaTemp: TMVBListaBase;
begin
  LListaTemp := TMVBListaBase.Create;
  try
    LContCiclos := 0;
    Self.Epocas := 0;
    while LContCiclos < Self.ParametrosRede.Ciclos do
    begin
      LDadoTemp := FListaDados.ProcurarPorIndice(0)
        as TMVBDadoPrevisaoLongoPrazo;
      LOrdem := LDadoTemp.Ordem;
      { cria um dado temporário para controlar teste no treinamento }
      LDadoTemp := TMVBDadoPrevisaoLongoPrazo.Create;
      LDadoTemp.Ordem := LOrdem;
      LDadoTemp.Fechamento := 0;
      LListaTemp.Inserir(LDadoTemp);

      for LContDados := 0 to FListaDados.Count - 2 do
      begin
        { recupera o dado }
        LDado := FListaDados.ProcurarPorIndice(LContDados)
          as TMVBDadoPrevisaoLongoPrazo;
        { inclui os valores para as entradas rede }
        Self.ValorEntrada(0, LDado.Data.DiaSemana.Seg);
        Self.ValorEntrada(1, LDado.Data.DiaSemana.Ter);
        Self.ValorEntrada(2, LDado.Data.DiaSemana.Qua);
        Self.ValorEntrada(3, LDado.Data.DiaSemana.Qui);
        Self.ValorEntrada(4, LDado.Data.DiaSemana.Sex);
        Self.ValorEntrada(5, LDado.Data.Dia.Dez00);
        Self.ValorEntrada(6, LDado.Data.Dia.Dez10);
        Self.ValorEntrada(7, LDado.Data.Dia.Dez20);
        Self.ValorEntrada(8, LDado.Data.Dia.Dez30);
        Self.ValorEntrada(9, LDado.Data.Dia.Uni0);
        Self.ValorEntrada(10, LDado.Data.Dia.Uni1);
        Self.ValorEntrada(11, LDado.Data.Dia.Uni2);
        Self.ValorEntrada(12, LDado.Data.Dia.Uni3);
        Self.ValorEntrada(13, LDado.Data.Dia.Uni4);
        Self.ValorEntrada(14, LDado.Data.Dia.Uni5);
        Self.ValorEntrada(15, LDado.Data.Dia.Uni6);
        Self.ValorEntrada(16, LDado.Data.Dia.Uni7);
        Self.ValorEntrada(17, LDado.Data.Dia.Uni8);
        Self.ValorEntrada(18, LDado.Data.Dia.Uni9);
        Self.ValorEntrada(19, LDado.Data.Mes.Janeiro);
        Self.ValorEntrada(20, LDado.Data.Mes.Fevereiro);
        Self.ValorEntrada(21, LDado.Data.Mes.Marco);
        Self.ValorEntrada(22, LDado.Data.Mes.Abril);
        Self.ValorEntrada(23, LDado.Data.Mes.Maio);
        Self.ValorEntrada(24, LDado.Data.Mes.Junho);
        Self.ValorEntrada(25, LDado.Data.Mes.Julho);
        Self.ValorEntrada(26, LDado.Data.Mes.Agosto);
        Self.ValorEntrada(27, LDado.Data.Mes.Setembro);
        Self.ValorEntrada(28, LDado.Data.Mes.Outubro);
        Self.ValorEntrada(29, LDado.Data.Mes.Novembro);
        Self.ValorEntrada(30, LDado.Data.Mes.Dezembro);
        Self.ValorEntrada(31, LDado.Retorno);
        Self.ValorEntrada(32, LDado.Abertura);
        Self.ValorEntrada(33, LDado.Maximo);
        Self.ValorEntrada(34, LDado.Minimo);
        Self.ValorEntrada(35, LDado.Volume);
        Self.ValorEntrada(36, LDado.Fechamento);
        { recupera o valor para a saída que é o fechamento do próximo dia }
        LDado := FListaDados.ProcurarPorIndice(LContDados + 1)
          as TMVBDadoPrevisaoLongoPrazo;
        { informa a saída }
        Self.ValorSaida(0, LDado.Fechamento);
        { treina a rede }
        Self.Training;
        FErroTotal := Self.Cost;
        Self.Epocas := Self.Epocas + 1;
        { cria um dado temporário para controlar teste no treinamento }
        LDadoTemp := TMVBDadoPrevisaoLongoPrazo.Create;
        LDadoTemp.Ordem := LDado.Ordem;
        LDadoTemp.Fechamento := Self.RecuperarSaida(0);
        LListaTemp.Inserir(LDadoTemp);
      end;
      { chama o OnTreinamento }
      if Assigned(FOnTreinamento) then
      begin
        FOnTreinamento(LListaTemp, LContCiclos, Self.Epocas, FErroTotal);
      end;
      { limpa a lista temporária }
      LListaTemp.Clear;
      { próxima época }
      Inc(LContCiclos);
    end;
  finally
    LListaTemp.Free;
  end;
  { Após treinar guarda o conhecimento acumulado pela rede }
  Self.Save;
end;

{ **************************************************************************** }
{ TMVBMlpPrevisaoFechamento }
{ **************************************************************************** }

constructor TMVBMlpPrevisaoFechamento.Create;
begin
  inherited;
  { informa o número de entradas }
  FQuantidadeEntradas := 2;
  FQuantidadeEntradas := StrToInt(
    InputBox('Camada de entrada', 'Informe a quantidade de entradas',
    IntToStr(FQuantidadeEntradas)));
end;

procedure TMVBMlpPrevisaoFechamento.ExecutarTeste;
var
  LCont, LContEntradas, LOrdem: Integer;
  LDado: TMVBDadoPrevisaoLongoPrazo;
begin
  LOrdem := 0;
  { limpa a lista de previsão }
  FDadosPrevistos.Clear;

  for LCont := 0 to Self.QuantidadeEntradas - 1 do
  begin
    LDado := FListaDadosTeste.ProcurarPorIndice(LCont)
      as TMVBDadoPrevisaoLongoPrazo;
    LOrdem := LDado.Ordem;
    LDado := TMVBDadoPrevisaoLongoPrazo.Create;
    LDado.Ordem := LOrdem;
    LDado.Fechamento := 0;
    { insere a nova amostra na lista }
    FDadosPrevistos.Inserir(LDado);
  end;

  Self.Epocas := Self.QuantidadeEntradas;
  { recupera todos os dados da lista de treinamento }
  for LCont := 0 to (FListaDadosTeste.Count - (Self.QuantidadeEntradas)) do
  begin
    for LContEntradas := 0 to Self.QuantidadeEntradas - 1 do
    begin
      { recupera o dado }
      LDado := FListaDadosTeste.ProcurarPorIndice(LCont + LContEntradas)
        as TMVBDadoPrevisaoLongoPrazo;
      { recupera todas as entradas }
      LOrdem := LDado.Ordem;
      Self.ValorEntrada(LContEntradas, LDado.Fechamento);
    end;
    { testa }
    Self.Test;
    { passa o valor para a próxima amostra }
    LDado := TMVBDadoPrevisaoLongoPrazo.Create;
    LDado.Ordem := LOrdem + FAtraso;
    LDado.Fechamento := Self.RecuperarSaida(0);
    { insere a nova amostra na lista }
    FDadosPrevistos.Inserir(LDado);
    { próxima época }
    Self.Epocas := Self.Epocas + 1;
  end;
end;

procedure TMVBMlpPrevisaoFechamento.RecuperarLimitesMinimosMaximos;
var
  LMaximoFechamento, LMinimoFechamento: Extended;
  LCont: Integer;
begin
  { Definição dos valores máximo e mínimo do conjunto de treinamento }
  LMinimoFechamento := 1E9;
  LMaximoFechamento := -1E9;
  { recupera os valores de máximo e mínimo }
  Query.First;
  while not Query.Eof do
  begin
    { Fechamento }
    if Query.FieldByName('Fechamento').AsFloat > LMaximoFechamento then
    begin
      LMaximoFechamento := Query.FieldByName('Fechamento').AsFloat;
    end;
    if Query.FieldByName('Fechamento').AsFloat < LMinimoFechamento then
    begin
      LMinimoFechamento := Query.FieldByName('Fechamento').AsFloat;
    end;
    Query.Next;
  end;
  { Definição da faixa de trabalho dos neurônios de entrada }
  for LCont := 0 to Self.QuantidadeEntradas - 1 do
  begin
    Self.ValorEntradaMinimo(LCont, LMinimoFechamento);
    Self.ValorEntradaMaximo(LCont, LMaximoFechamento);
  end;
  { Definição da faixa de trabalho do neurônio de saída }
  Self.ValorSaidaMinimo(0, LMinimoFechamento);
  Self.ValorSaidaMaximo(0, LMaximoFechamento);
end;

procedure TMVBMlpPrevisaoFechamento.Treinar;
var
  LContCiclos, LContDados, LContEntradas, LOrdem: Integer;
  LDado, LDadoTemp: TMVBDadoPrevisaoLongoPrazo;
  LListaTemp: TMVBListaBase;
begin
  LListaTemp := TMVBListaBase.Create;
  try
    LContCiclos := 0;
    Self.Epocas := Self.QuantidadeEntradas;

    while LContCiclos < Self.ParametrosRede.Ciclos do
    begin
      { insere valores nulo para os que não serão previstos }
      for LContDados := 0 to Self.QuantidadeEntradas - 1 do
      begin
        { recupera o dado }
        LDadoTemp := FListaDados.ProcurarPorIndice(LContDados)
          as TMVBDadoPrevisaoLongoPrazo;
        LOrdem := LDadoTemp.Ordem;
        LDadoTemp := TMVBDadoPrevisaoLongoPrazo.Create;
        LDadoTemp.Ordem := LOrdem;
        LDadoTemp.Fechamento := 0;
        LListaTemp.Inserir(LDadoTemp);
      end;

      for LContDados := 0 to (FListaDados.Count - (Self.QuantidadeEntradas + 1))
        do
      begin
        LContEntradas := 0;
        while LContEntradas < Self.QuantidadeEntradas do
        begin
          { recupera o dado }
          LDado := FListaDados.ProcurarPorIndice(LContDados + LContEntradas)
            as TMVBDadoPrevisaoLongoPrazo;
          { inclui os valores para as entradas rede }
          Self.ValorEntrada(LContEntradas, LDado.Fechamento);
          { próxima entrada }
          Inc(LContEntradas);
        end;
        { recupera o valor para a saída }
        LDado := FListaDados.ProcurarPorIndice(LContDados + LContEntradas)
          as TMVBDadoPrevisaoLongoPrazo;
        { informa a saída }
        Self.ValorSaida(0, LDado.Fechamento);

        { treina a rede }
        Self.Training;

        FErroTotal := Self.Cost;
        Self.Epocas := Self.Epocas + 1;
        { cria um dado temporário para controlar teste no treinamento }
        LDadoTemp := TMVBDadoPrevisaoLongoPrazo.Create;
        LDadoTemp.Ordem := LDado.Ordem;
        LDadoTemp.Fechamento := Self.RecuperarSaida(0);
        LListaTemp.Inserir(LDadoTemp);
      end;
      { chama o OnTreinamento }
      if Assigned(FOnTreinamento) then
      begin
        FOnTreinamento(LListaTemp, LContCiclos, Self.Epocas, FErroTotal);
      end;
      { limpa a lista temporária }
      LListaTemp.Clear;
      { próxima época }
      Inc(LContCiclos);
    end;
  finally
    LListaTemp.Free;
  end;
  { Após treinar guarda o conhecimento acumulado pela rede }
  Self.Save;
end;

{ **************************************************************************** }
{ TMVBMlpPrevisaoLongoPrazoComValoresAnteriores }
{ **************************************************************************** }

constructor TMVBMlpPrevisaoLongoPrazoComValoresAnteriores.Create;
begin
  inherited;
  { informa o número de entradas }
  FQuantidadeEntradas := 41;
end;

procedure TMVBMlpPrevisaoLongoPrazoComValoresAnteriores.ExecutarTeste;
var
  LCont, LOrdem: Integer;
  LDado, LDadoT1, LDadoT2, LDadoT3, LDadoT4: TMVBDadoPrevisaoLongoPrazo;
begin
  { limpa a lista de previsão }
  FDadosPrevistos.Clear;
  { passa o valor para a próxima amostra }
  for LCont := 0 to 4 do
  begin
    LDado := FListaDadosTeste.ProcurarPorIndice(LCont)
      as TMVBDadoPrevisaoLongoPrazo;
    LOrdem := LDado.Ordem;
    { itens nulos }
    LDado := TMVBDadoPrevisaoLongoPrazo.Create;
    LDado.Ordem := LOrdem;
    LDado.Fechamento := 0;
    { insere a nova amostra na lista }
    FDadosPrevistos.Inserir(LDado);
  end;
  { recupera todos os dados da lista de treinamento }
  for LCont := 4 to FListaDadosTeste.Count - 1 do
  begin
    { recupera o dado }
    LDado := FListaDadosTeste.ProcurarPorIndice(LCont)
      as TMVBDadoPrevisaoLongoPrazo;
    LDadoT1 := FListaDadosTeste.ProcurarPorIndice(LCont - 1)
      as TMVBDadoPrevisaoLongoPrazo;
    LDadoT2 := FListaDadosTeste.ProcurarPorIndice(LCont - 2)
      as TMVBDadoPrevisaoLongoPrazo;
    LDadoT3 := FListaDadosTeste.ProcurarPorIndice(LCont - 3)
      as TMVBDadoPrevisaoLongoPrazo;
    LDadoT4 := FListaDadosTeste.ProcurarPorIndice(LCont - 4)
      as TMVBDadoPrevisaoLongoPrazo;
    { recupera todas as entradas }
    LOrdem := LDado.Ordem;
    Self.ValorEntrada(0, LDado.Data.DiaSemana.Seg);
    Self.ValorEntrada(1, LDado.Data.DiaSemana.Ter);
    Self.ValorEntrada(2, LDado.Data.DiaSemana.Qua);
    Self.ValorEntrada(3, LDado.Data.DiaSemana.Qui);
    Self.ValorEntrada(4, LDado.Data.DiaSemana.Sex);
    Self.ValorEntrada(5, LDado.Data.Dia.Dez00);
    Self.ValorEntrada(6, LDado.Data.Dia.Dez10);
    Self.ValorEntrada(7, LDado.Data.Dia.Dez20);
    Self.ValorEntrada(8, LDado.Data.Dia.Dez30);
    Self.ValorEntrada(9, LDado.Data.Dia.Uni0);
    Self.ValorEntrada(10, LDado.Data.Dia.Uni1);
    Self.ValorEntrada(11, LDado.Data.Dia.Uni2);
    Self.ValorEntrada(12, LDado.Data.Dia.Uni3);
    Self.ValorEntrada(13, LDado.Data.Dia.Uni4);
    Self.ValorEntrada(14, LDado.Data.Dia.Uni5);
    Self.ValorEntrada(15, LDado.Data.Dia.Uni6);
    Self.ValorEntrada(16, LDado.Data.Dia.Uni7);
    Self.ValorEntrada(17, LDado.Data.Dia.Uni8);
    Self.ValorEntrada(18, LDado.Data.Dia.Uni9);
    Self.ValorEntrada(19, LDado.Data.Mes.Janeiro);
    Self.ValorEntrada(20, LDado.Data.Mes.Fevereiro);
    Self.ValorEntrada(21, LDado.Data.Mes.Marco);
    Self.ValorEntrada(22, LDado.Data.Mes.Abril);
    Self.ValorEntrada(23, LDado.Data.Mes.Maio);
    Self.ValorEntrada(24, LDado.Data.Mes.Junho);
    Self.ValorEntrada(25, LDado.Data.Mes.Julho);
    Self.ValorEntrada(26, LDado.Data.Mes.Agosto);
    Self.ValorEntrada(27, LDado.Data.Mes.Setembro);
    Self.ValorEntrada(28, LDado.Data.Mes.Outubro);
    Self.ValorEntrada(29, LDado.Data.Mes.Novembro);
    Self.ValorEntrada(30, LDado.Data.Mes.Dezembro);
    Self.ValorEntrada(31, LDado.Retorno);
    Self.ValorEntrada(32, LDado.Abertura);
    Self.ValorEntrada(33, LDado.Maximo);
    Self.ValorEntrada(34, LDado.Minimo);
    Self.ValorEntrada(35, LDado.Volume);
    Self.ValorEntrada(36, LDado.Fechamento);
    Self.ValorEntrada(37, LDadoT1.Fechamento);
    Self.ValorEntrada(38, LDadoT2.Fechamento);
    Self.ValorEntrada(39, LDadoT3.Fechamento);
    Self.ValorEntrada(40, LDadoT4.Fechamento);
    { testa }
    Self.Test;
    { passa o valor para a próxima amostra }
    LDado := TMVBDadoPrevisaoLongoPrazo.Create;
    LDado.Ordem := LOrdem + FAtraso;
    LDado.Fechamento := Self.RecuperarSaida(0);
    { insere a nova amostra na lista }
    FDadosPrevistos.Inserir(LDado);
  end;
end;

procedure
  TMVBMlpPrevisaoLongoPrazoComValoresAnteriores.RecuperarLimitesMinimosMaximos;
var
  LMaximoRetorno, LMinimoRetorno: Extended;
  LMaximoAbertura, LMinimoAbertura: Extended;
  LMaximoMaximo, LMinimoMaximo: Extended;
  LMaximoMinimo, LMinimoMinimo: Extended;
  LMaximoVolume, LMinimoVolume: Extended;
  LMaximoFechamento, LMinimoFechamento: Extended;
  LCont: Integer;
begin
  { informa os máximos e mínimos dos atributos binários }
  for LCont := 0 to 30 do
  begin
    Self.ValorEntradaMinimo(LCont, 0);
    Self.ValorEntradaMaximo(LCont, 1);
  end;
  { Definição dos valores máximo e mínimo do conjunto de treinamento }
  LMinimoRetorno := 1E9;
  LMaximoRetorno := -1E9;
  LMinimoAbertura := 1E9;
  LMaximoAbertura := -1E9;
  LMinimoMaximo := 1E9;
  LMaximoMaximo := -1E9;
  LMinimoMinimo := 1E9;
  LMaximoMinimo := -1E9;
  LMinimoVolume := 1E9;
  LMaximoVolume := -1E9;
  LMinimoFechamento := 1E9;
  LMaximoFechamento := -1E9;
  { recupera os valores de máximo e mínimo }
  Query.First;
  while not Query.Eof do
  begin
    { Retorno }
    if Query.FieldByName('Retorno').AsFloat > LMaximoRetorno then
    begin
      LMaximoRetorno := Query.FieldByName('Retorno').AsFloat;
    end;
    if Query.FieldByName('Retorno').AsFloat < LMinimoRetorno then
    begin
      LMinimoRetorno := Query.FieldByName('Retorno').AsFloat;
    end;
    { Abertura }
    if Query.FieldByName('Abertura').AsFloat > LMaximoAbertura then
    begin
      LMaximoAbertura := Query.FieldByName('Abertura').AsFloat;
    end;
    if Query.FieldByName('Abertura').AsFloat < LMinimoAbertura then
    begin
      LMinimoAbertura := Query.FieldByName('Abertura').AsFloat;
    end;
    { Maximo }
    if Query.FieldByName('Maximo').AsFloat > LMaximoMaximo then
    begin
      LMaximoMaximo := Query.FieldByName('Maximo').AsFloat;
    end;
    if Query.FieldByName('Maximo').AsFloat < LMinimoMaximo then
    begin
      LMinimoMaximo := Query.FieldByName('Maximo').AsFloat;
    end;
    { Minimo }
    if Query.FieldByName('Minimo').AsFloat > LMaximoMinimo then
    begin
      LMaximoMinimo := Query.FieldByName('Minimo').AsFloat;
    end;
    if Query.FieldByName('Minimo').AsFloat < LMinimoMinimo then
    begin
      LMinimoMinimo := Query.FieldByName('Minimo').AsFloat;
    end;
    { Volume }
    if Query.FieldByName('Volume').AsFloat > LMaximoVolume then
    begin
      LMaximoVolume := Query.FieldByName('Volume').AsFloat;
    end;
    if Query.FieldByName('Volume').AsFloat < LMinimoVolume then
    begin
      LMinimoVolume := Query.FieldByName('Volume').AsFloat;
    end;
    { Fechamento }
    if Query.FieldByName('Fechamento').AsFloat > LMaximoFechamento then
    begin
      LMaximoFechamento := Query.FieldByName('Fechamento').AsFloat;
    end;
    if Query.FieldByName('Fechamento').AsFloat < LMinimoFechamento then
    begin
      LMinimoFechamento := Query.FieldByName('Fechamento').AsFloat;
    end;
    Query.Next;
  end;
  { Definição da faixa de trabalho dos neurônios de entrada }
  Self.ValorEntradaMinimo(31, LMinimoRetorno);
  Self.ValorEntradaMaximo(31, LMaximoRetorno);
  Self.ValorEntradaMinimo(32, LMinimoAbertura);
  Self.ValorEntradaMaximo(32, LMaximoAbertura);
  Self.ValorEntradaMinimo(33, LMinimoMaximo);
  Self.ValorEntradaMaximo(33, LMaximoMaximo);
  Self.ValorEntradaMinimo(34, LMinimoMinimo);
  Self.ValorEntradaMaximo(34, LMaximoMinimo);
  Self.ValorEntradaMinimo(35, LMinimoVolume);
  Self.ValorEntradaMaximo(35, LMaximoVolume);
  Self.ValorEntradaMinimo(36, LMinimoFechamento);
  Self.ValorEntradaMaximo(36, LMaximoFechamento);
  Self.ValorEntradaMinimo(37, LMinimoFechamento);
  Self.ValorEntradaMaximo(37, LMaximoFechamento);
  Self.ValorEntradaMinimo(38, LMinimoFechamento);
  Self.ValorEntradaMaximo(38, LMaximoFechamento);
  Self.ValorEntradaMinimo(39, LMinimoFechamento);
  Self.ValorEntradaMaximo(39, LMaximoFechamento);
  Self.ValorEntradaMinimo(40, LMinimoFechamento);
  Self.ValorEntradaMaximo(40, LMaximoFechamento);
  { Definição da faixa de trabalho do neurônio de saída }
  Self.ValorSaidaMinimo(0, LMinimoFechamento);
  Self.ValorSaidaMaximo(0, LMaximoFechamento);
end;

procedure TMVBMlpPrevisaoLongoPrazoComValoresAnteriores.Treinar;
var
  LContCiclos, LContDados, LOrdem: Integer;
  LDado, LDadoT1, LDadoT2, LDadoT3, LDadoT4,
    LDadoTemp: TMVBDadoPrevisaoLongoPrazo;
  LListaTemp: TMVBListaBase;
begin
  LListaTemp := TMVBListaBase.Create;
  try
    LContCiclos := 0;
    Self.Epocas := 0;
    while LContCiclos < Self.ParametrosRede.Ciclos do
    begin
      { cria um dado temporário para controlar teste no treinamento }
      for LContDados := 0 to 4 do
      begin
        LDado := FListaDados.ProcurarPorIndice(LContDados)
          as TMVBDadoPrevisaoLongoPrazo;
        LOrdem := LDado.Ordem;
        { itens nulos }
        LDadoTemp := TMVBDadoPrevisaoLongoPrazo.Create;
        LDadoTemp.Ordem := LOrdem;
        LDadoTemp.Fechamento := 0;
        LListaTemp.Inserir(LDadoTemp);
      end;

      for LContDados := 4 to FListaDados.Count - 2 do
      begin
        { recupera o dado }
        LDado := FListaDados.ProcurarPorIndice(LContDados)
          as TMVBDadoPrevisaoLongoPrazo;
        LDadoT1 := FListaDados.ProcurarPorIndice(LContDados - 1)
          as TMVBDadoPrevisaoLongoPrazo;
        LDadoT2 := FListaDados.ProcurarPorIndice(LContDados - 2)
          as TMVBDadoPrevisaoLongoPrazo;
        LDadoT3 := FListaDados.ProcurarPorIndice(LContDados - 3)
          as TMVBDadoPrevisaoLongoPrazo;
        LDadoT4 := FListaDados.ProcurarPorIndice(LContDados - 4)
          as TMVBDadoPrevisaoLongoPrazo;
        { inclui os valores para as entradas rede }
        Self.ValorEntrada(0, LDado.Data.DiaSemana.Seg);
        Self.ValorEntrada(1, LDado.Data.DiaSemana.Ter);
        Self.ValorEntrada(2, LDado.Data.DiaSemana.Qua);
        Self.ValorEntrada(3, LDado.Data.DiaSemana.Qui);
        Self.ValorEntrada(4, LDado.Data.DiaSemana.Sex);
        Self.ValorEntrada(5, LDado.Data.Dia.Dez00);
        Self.ValorEntrada(6, LDado.Data.Dia.Dez10);
        Self.ValorEntrada(7, LDado.Data.Dia.Dez20);
        Self.ValorEntrada(8, LDado.Data.Dia.Dez30);
        Self.ValorEntrada(9, LDado.Data.Dia.Uni0);
        Self.ValorEntrada(10, LDado.Data.Dia.Uni1);
        Self.ValorEntrada(11, LDado.Data.Dia.Uni2);
        Self.ValorEntrada(12, LDado.Data.Dia.Uni3);
        Self.ValorEntrada(13, LDado.Data.Dia.Uni4);
        Self.ValorEntrada(14, LDado.Data.Dia.Uni5);
        Self.ValorEntrada(15, LDado.Data.Dia.Uni6);
        Self.ValorEntrada(16, LDado.Data.Dia.Uni7);
        Self.ValorEntrada(17, LDado.Data.Dia.Uni8);
        Self.ValorEntrada(18, LDado.Data.Dia.Uni9);
        Self.ValorEntrada(19, LDado.Data.Mes.Janeiro);
        Self.ValorEntrada(20, LDado.Data.Mes.Fevereiro);
        Self.ValorEntrada(21, LDado.Data.Mes.Marco);
        Self.ValorEntrada(22, LDado.Data.Mes.Abril);
        Self.ValorEntrada(23, LDado.Data.Mes.Maio);
        Self.ValorEntrada(24, LDado.Data.Mes.Junho);
        Self.ValorEntrada(25, LDado.Data.Mes.Julho);
        Self.ValorEntrada(26, LDado.Data.Mes.Agosto);
        Self.ValorEntrada(27, LDado.Data.Mes.Setembro);
        Self.ValorEntrada(28, LDado.Data.Mes.Outubro);
        Self.ValorEntrada(29, LDado.Data.Mes.Novembro);
        Self.ValorEntrada(30, LDado.Data.Mes.Dezembro);
        Self.ValorEntrada(31, LDado.Retorno);
        Self.ValorEntrada(32, LDado.Abertura);
        Self.ValorEntrada(33, LDado.Maximo);
        Self.ValorEntrada(34, LDado.Minimo);
        Self.ValorEntrada(35, LDado.Volume);
        Self.ValorEntrada(36, LDado.Fechamento);
        Self.ValorEntrada(37, LDadoT1.Fechamento);
        Self.ValorEntrada(38, LDadoT2.Fechamento);
        Self.ValorEntrada(39, LDadoT3.Fechamento);
        Self.ValorEntrada(40, LDadoT4.Fechamento);
        { recupera o valor para a saída com o valor do próximo dia }
        LDado := FListaDados.ProcurarPorIndice(LContDados + 1)
          as TMVBDadoPrevisaoLongoPrazo;
        { informa a saída }
        Self.ValorSaida(0, LDado.Fechamento);
        { treina a rede }
        Self.Training;
        FErroTotal := Self.Cost;
        Self.Epocas := Self.Epocas + 1;
        { cria um dado temporário para controlar teste no treinamento }
        LDadoTemp := TMVBDadoPrevisaoLongoPrazo.Create;
        LDadoTemp.Ordem := LDado.Ordem;
        LDadoTemp.Fechamento := Self.RecuperarSaida(0);
        LListaTemp.Inserir(LDadoTemp);
      end;
      { chama o OnTreinamento }
      if Assigned(FOnTreinamento) then
      begin
        FOnTreinamento(LListaTemp, LContCiclos, Self.Epocas, FErroTotal);
      end;
      { limpa a lista temporária }
      LListaTemp.Clear;
      { próxima época }
      Inc(LContCiclos);
    end;
  finally
    LListaTemp.Free;
  end;
  { Após treinar guarda o conhecimento acumulado pela rede }
  Self.Save;
end;

end.

