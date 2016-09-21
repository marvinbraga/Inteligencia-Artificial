unit uMVBParametrosRede;

interface

uses
  { borland }
  Classes,
  { mvb }
  uMVBClasses, uMVBConsts, uMVBMultiLayerPerceptron;

type
  TMVBParametrosRede = class(TMVBDadosBase)
  private
    FMomento: Extended;
    FApredizado: Extended;
    FUnidadesOcultas: Integer;
    FCiclos: Integer;
    FFuncaoAtivacao: TMVBFuncaoAtivacao;
    FArquivoConhecimento: string;
    procedure SetApredizado(const Value: Extended);
    procedure SetCiclos(const Value: Integer);
    procedure SetFuncaoAtivacao(const Value: TMVBFuncaoAtivacao);
    procedure SetMomento(const Value: Extended);
    procedure SetUnidadesOcultas(const Value: Integer);
    procedure SetArquivoConhecimento(const Value: string);
  protected
  public
    procedure Clear; override;
    procedure Assign(ASource: TMVBDadosBase); override;
  published
    property UnidadesOcultas: Integer read FUnidadesOcultas write SetUnidadesOcultas;
    property FuncaoAtivacao: TMVBFuncaoAtivacao read FFuncaoAtivacao write SetFuncaoAtivacao;
    property Ciclos: Integer read FCiclos write SetCiclos;
    property Apredizado: Extended read FApredizado write SetApredizado;
    property Momento: Extended read FMomento write SetMomento;
    property ArquivoConhecimento: string read FArquivoConhecimento write SetArquivoConhecimento;
  end;

implementation

{ TMVBParametrosRede }

procedure TMVBParametrosRede.Assign(ASource: TMVBDadosBase);
begin
  inherited;
  FUnidadesOcultas := TMVBParametrosRede(ASource).UnidadesOcultas;
  FFuncaoAtivacao := TMVBParametrosRede(ASource).FuncaoAtivacao;
  FCiclos := TMVBParametrosRede(ASource).Ciclos;
  FApredizado := TMVBParametrosRede(ASource).Apredizado;
  FMomento := TMVBParametrosRede(ASource).Momento;
  FArquivoConhecimento := TMVBParametrosRede(ASource).ArquivoConhecimento;
end;

procedure TMVBParametrosRede.Clear;
begin
  inherited;
  FUnidadesOcultas := C_INTEGER_NULL;
  FFuncaoAtivacao := faNaoInformada;
  FCiclos := C_INTEGER_NULL;
  FApredizado := C_DOUBLE_NULL;
  FMomento := C_DOUBLE_NULL;
  FArquivoConhecimento := C_STRING_NULL;
end;

procedure TMVBParametrosRede.SetApredizado(const Value: Extended);
begin
  FApredizado := Value;
end;

procedure TMVBParametrosRede.SetArquivoConhecimento(const Value: string);
begin
  FArquivoConhecimento := Value;
end;

procedure TMVBParametrosRede.SetCiclos(const Value: Integer);
begin
  FCiclos := Value;
end;

procedure TMVBParametrosRede.SetFuncaoAtivacao(
  const Value: TMVBFuncaoAtivacao);
begin
  FFuncaoAtivacao := Value;
end;

procedure TMVBParametrosRede.SetMomento(const Value: Extended);
begin
  FMomento := Value;
end;

procedure TMVBParametrosRede.SetUnidadesOcultas(const Value: Integer);
begin
  FUnidadesOcultas := Value;
end;

initialization
  RegisterClass(TMVBParametrosRede);

finalization
  UnRegisterClass(TMVBParametrosRede);

end.
 