unit uMVBDadoPrevisaoLongoPrazo;

interface

uses
  { borland }
  Classes, Controls,
  { mvb }
  uMVBClasses, uMVBConsts;

type
  TMVBSemana = class(TMVBDadosBase)
  private
    FSeg: Integer;
    FSex: Integer;
    FTer: Integer;
    FQua: Integer;
    FQui: Integer;
    procedure SetQua(const Value: Integer);
    procedure SetQui(const Value: Integer);
    procedure SetSeg(const Value: Integer);
    procedure SetSex(const Value: Integer);
    procedure SetTer(const Value: Integer);
  public
    procedure Clear; override;
    procedure Assign(ASource: TMVBDadosBase); override;
  protected
  published
    property Seg: Integer read FSeg write SetSeg;
    property Ter: Integer read FTer write SetTer;
    property Qua: Integer read FQua write SetQua;
    property Qui: Integer read FQui write SetQui;
    property Sex: Integer read FSex write SetSex;
  end;

  TMVBDia = class(TMVBDadosBase)
  private
    FUni9: Integer;
    FUni1: Integer;
    FDez10: Integer;
    FUni6: Integer;
    FUni8: Integer;
    FUni2: Integer;
    FUni3: Integer;
    FDez30: Integer;
    FDez20: Integer;
    FDez00: Integer;
    FUni0: Integer;
    FUni7: Integer;
    FUni5: Integer;
    FUni4: Integer;
    procedure SetDez00(const Value: Integer);
    procedure SetDez10(const Value: Integer);
    procedure SetDez20(const Value: Integer);
    procedure SetDez30(const Value: Integer);
    procedure SetUni0(const Value: Integer);
    procedure SetUni1(const Value: Integer);
    procedure SetUni2(const Value: Integer);
    procedure SetUni3(const Value: Integer);
    procedure SetUni4(const Value: Integer);
    procedure SetUni5(const Value: Integer);
    procedure SetUni6(const Value: Integer);
    procedure SetUni7(const Value: Integer);
    procedure SetUni8(const Value: Integer);
    procedure SetUni9(const Value: Integer);
  public
    procedure Clear; override;
    procedure Assign(ASource: TMVBDadosBase); override;
  protected
  published
    property Dez00: Integer read FDez00 write SetDez00;
    property Dez10: Integer read FDez10 write SetDez10;
    property Dez20: Integer read FDez20 write SetDez20;
    property Dez30: Integer read FDez30 write SetDez30;
    property Uni0: Integer read FUni0 write SetUni0;
    property Uni1: Integer read FUni1 write SetUni1;
    property Uni2: Integer read FUni2 write SetUni2;
    property Uni3: Integer read FUni3 write SetUni3;
    property Uni4: Integer read FUni4 write SetUni4;
    property Uni5: Integer read FUni5 write SetUni5;
    property Uni6: Integer read FUni6 write SetUni6;
    property Uni7: Integer read FUni7 write SetUni7;
    property Uni8: Integer read FUni8 write SetUni8;
    property Uni9: Integer read FUni9 write SetUni9;
  end;

  TMVBMes = class(TMVBDadosBase)
  private
    FAbril: Integer;
    FMaio: Integer;
    FFevereiro: Integer;
    FMarco: Integer;
    FNovembro: Integer;
    FJulho: Integer;
    FJaneiro: Integer;
    FJunho: Integer;
    FAgosto: Integer;
    FOutubro: Integer;
    FSetembro: Integer;
    FDezembro: Integer;
    procedure SetAbril(const Value: Integer);
    procedure SetAgosto(const Value: Integer);
    procedure SetDezembro(const Value: Integer);
    procedure SetFevereiro(const Value: Integer);
    procedure SetJaneiro(const Value: Integer);
    procedure SetJulho(const Value: Integer);
    procedure SetJunho(const Value: Integer);
    procedure SetMaio(const Value: Integer);
    procedure SetMarco(const Value: Integer);
    procedure SetNovembro(const Value: Integer);
    procedure SetOutubro(const Value: Integer);
    procedure SetSetembro(const Value: Integer);
  public
    procedure Clear; override;
    procedure Assign(ASource: TMVBDadosBase); override;
  protected
  published
    property Janeiro: Integer read FJaneiro write SetJaneiro;
    property Fevereiro: Integer read FFevereiro write SetFevereiro;
    property Marco: Integer read FMarco write SetMarco;
    property Abril: Integer read FAbril write SetAbril;
    property Maio: Integer read FMaio write SetMaio;
    property Junho: Integer read FJunho write SetJunho;
    property Julho: Integer read FJulho write SetJulho;
    property Agosto: Integer read FAgosto write SetAgosto;
    property Setembro: Integer read FSetembro write SetSetembro;
    property Outubro: Integer read FOutubro write SetOutubro;
    property Novembro: Integer read FNovembro write SetNovembro;
    property Dezembro: Integer read FDezembro write SetDezembro;
  end;

  { data para longo prazo }
  TMVBData = class(TMVBDadosBase)
  private
    FData: TDate;
    FDia: TMVBDia;
    FMes: TMVBMes;
    FDiaSemana: TMVBSemana;
    procedure SetData(const Value: TDate);
    procedure SetDia(const Value: TMVBDia);
    procedure SetDiaSemana(const Value: TMVBSemana);
    procedure SetMes(const Value: TMVBMes);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear; override;
    procedure Assign(ASource: TMVBDadosBase); override;
  protected
  published
    property Data: TDate read FData write SetData;
    property DiaSemana: TMVBSemana read FDiaSemana write SetDiaSemana;
    property Dia: TMVBDia read FDia write SetDia;
    property Mes: TMVBMes read FMes write SetMes;
  end;

  { data para longo prazo }
  TMVBDadoPrevisaoLongoPrazo = class(TMVBDadosBase)
  private
    FRetorno: Extended;
    FAbertura: Extended;
    FMaximo: Extended;
    FMinimo: Extended;
    FFechamento: Extended;
    FVolume: Extended;
    FOrdem: Integer;
    FData: TMVBData;
    procedure SetAbertura(const Value: Extended);
    procedure SetData(const Value: TMVBData);
    procedure SetFechamento(const Value: Extended);
    procedure SetMaximo(const Value: Extended);
    procedure SetMinimo(const Value: Extended);
    procedure SetOrdem(const Value: Integer);
    procedure SetRetorno(const Value: Extended);
    procedure SetVolume(const Value: Extended);
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear; override;
    procedure Assign(ASource: TMVBDadosBase); override;
  protected
  published
    property Data: TMVBData read FData write SetData;
    property Ordem: Integer read FOrdem write SetOrdem;
    property Retorno: Extended read FRetorno write SetRetorno;
    property Abertura: Extended read FAbertura write SetAbertura;
    property Maximo: Extended read FMaximo write SetMaximo;
    property Minimo: Extended read FMinimo write SetMinimo;
    property Fechamento: Extended read FFechamento write SetFechamento;
    property Volume: Extended read FVolume write SetVolume;
  end;

implementation

uses
  { borland }
  DateUtils;

{ ************************************************************************** }
{ TMVBSemana }
{ ************************************************************************** }

procedure TMVBSemana.Assign(ASource: TMVBDadosBase);
begin
  inherited;
  FSeg := TMVBSemana(ASource).Seg;
  FTer := TMVBSemana(ASource).Ter;
  FQua := TMVBSemana(ASource).Qua;
  FQui := TMVBSemana(ASource).Qui;
  FSex := TMVBSemana(ASource).Sex;
end;

procedure TMVBSemana.Clear;
begin
  inherited;
  FSeg := C_INTEGER_NULL;
  FTer := C_INTEGER_NULL;
  FQua := C_INTEGER_NULL;
  FQui := C_INTEGER_NULL;
  FSex := C_INTEGER_NULL;
end;

procedure TMVBSemana.SetQua(const Value: Integer);
begin
  FQua := Value;
end;

procedure TMVBSemana.SetQui(const Value: Integer);
begin
  FQui := Value;
end;

procedure TMVBSemana.SetSeg(const Value: Integer);
begin
  FSeg := Value;
end;

procedure TMVBSemana.SetSex(const Value: Integer);
begin
  FSex := Value;
end;

procedure TMVBSemana.SetTer(const Value: Integer);
begin
  FTer := Value;
end;

{ ************************************************************************** }
{ TMVBDia }
{ ************************************************************************** }

procedure TMVBDia.Assign(ASource: TMVBDadosBase);
begin
  inherited;
  FDez00 := TMVBDia(ASource).Dez00;
  FDez10 := TMVBDia(ASource).Dez10;
  FDez20 := TMVBDia(ASource).Dez20;
  FDez30 := TMVBDia(ASource).Dez30;
  FUni0 := TMVBDia(ASource).Uni0;
  FUni1 := TMVBDia(ASource).Uni1;
  FUni2 := TMVBDia(ASource).Uni2;
  FUni3 := TMVBDia(ASource).Uni3;
  FUni4 := TMVBDia(ASource).Uni4;
  FUni5 := TMVBDia(ASource).Uni5;
  FUni6 := TMVBDia(ASource).Uni6;
  FUni7 := TMVBDia(ASource).Uni7;
  FUni8 := TMVBDia(ASource).Uni8;
  FUni9 := TMVBDia(ASource).Uni9;
end;

procedure TMVBDia.Clear;
begin
  inherited;
  FDez00 := C_INTEGER_NULL;
  FDez10 := C_INTEGER_NULL;
  FDez20 := C_INTEGER_NULL;
  FDez30 := C_INTEGER_NULL;
  FUni0 := C_INTEGER_NULL;
  FUni1 := C_INTEGER_NULL;
  FUni2 := C_INTEGER_NULL;
  FUni3 := C_INTEGER_NULL;
  FUni4 := C_INTEGER_NULL;
  FUni5 := C_INTEGER_NULL;
  FUni6 := C_INTEGER_NULL;
  FUni7 := C_INTEGER_NULL;
  FUni8 := C_INTEGER_NULL;
  FUni9 := C_INTEGER_NULL;
end;

procedure TMVBDia.SetDez00(const Value: Integer);
begin
  FDez00 := Value;
end;

procedure TMVBDia.SetDez10(const Value: Integer);
begin
  FDez10 := Value;
end;

procedure TMVBDia.SetDez20(const Value: Integer);
begin
  FDez20 := Value;
end;

procedure TMVBDia.SetDez30(const Value: Integer);
begin
  FDez30 := Value;
end;

procedure TMVBDia.SetUni0(const Value: Integer);
begin
  FUni0 := Value;
end;

procedure TMVBDia.SetUni1(const Value: Integer);
begin
  FUni1 := Value;
end;

procedure TMVBDia.SetUni2(const Value: Integer);
begin
  FUni2 := Value;
end;

procedure TMVBDia.SetUni3(const Value: Integer);
begin
  FUni3 := Value;
end;

procedure TMVBDia.SetUni4(const Value: Integer);
begin
  FUni4 := Value;
end;

procedure TMVBDia.SetUni5(const Value: Integer);
begin
  FUni5 := Value;
end;

procedure TMVBDia.SetUni6(const Value: Integer);
begin
  FUni6 := Value;
end;

procedure TMVBDia.SetUni7(const Value: Integer);
begin
  FUni7 := Value;
end;

procedure TMVBDia.SetUni8(const Value: Integer);
begin
  FUni8 := Value;
end;

procedure TMVBDia.SetUni9(const Value: Integer);
begin
  FUni9 := Value;
end;

{ ************************************************************************** }
{ TMVBMes }
{ ************************************************************************** }

procedure TMVBMes.Assign(ASource: TMVBDadosBase);
begin
  inherited;
  FJaneiro := TMVBMes(ASource).Janeiro;
  FFevereiro := TMVBMes(ASource).Fevereiro;
  FMarco := TMVBMes(ASource).Marco;
  FAbril := TMVBMes(ASource).Abril;
  FMaio := TMVBMes(ASource).Maio;
  FJunho := TMVBMes(ASource).Junho;
  FJulho := TMVBMes(ASource).Julho;
  FAgosto := TMVBMes(ASource).Agosto;
  FSetembro := TMVBMes(ASource).Setembro;
  FOutubro := TMVBMes(ASource).Outubro;
  FNovembro := TMVBMes(ASource).Novembro;
  FDezembro := TMVBMes(ASource).Dezembro;
end;

procedure TMVBMes.Clear;
begin
  inherited;
  FJaneiro := C_INTEGER_NULL;
  FFevereiro := C_INTEGER_NULL;
  FMarco := C_INTEGER_NULL;
  FAbril := C_INTEGER_NULL;
  FMaio := C_INTEGER_NULL;
  FJunho := C_INTEGER_NULL;
  FJulho := C_INTEGER_NULL;
  FAgosto := C_INTEGER_NULL;
  FSetembro := C_INTEGER_NULL;
  FOutubro := C_INTEGER_NULL;
  FNovembro := C_INTEGER_NULL;
  FDezembro := C_INTEGER_NULL;
end;

procedure TMVBMes.SetAbril(const Value: Integer);
begin
  FAbril := Value;
end;

procedure TMVBMes.SetAgosto(const Value: Integer);
begin
  FAgosto := Value;
end;

procedure TMVBMes.SetDezembro(const Value: Integer);
begin
  FDezembro := Value;
end;

procedure TMVBMes.SetFevereiro(const Value: Integer);
begin
  FFevereiro := Value;
end;

procedure TMVBMes.SetJaneiro(const Value: Integer);
begin
  FJaneiro := Value;
end;

procedure TMVBMes.SetJulho(const Value: Integer);
begin
  FJulho := Value;
end;

procedure TMVBMes.SetJunho(const Value: Integer);
begin
  FJunho := Value;
end;

procedure TMVBMes.SetMaio(const Value: Integer);
begin
  FMaio := Value;
end;

procedure TMVBMes.SetMarco(const Value: Integer);
begin
  FMarco := Value;
end;

procedure TMVBMes.SetNovembro(const Value: Integer);
begin
  FNovembro := Value;
end;

procedure TMVBMes.SetOutubro(const Value: Integer);
begin
  FOutubro := Value;
end;

procedure TMVBMes.SetSetembro(const Value: Integer);
begin
  FSetembro := Value;
end;

{ ************************************************************************** }
{ TMVBData }
{ ************************************************************************** }

procedure TMVBData.Assign(ASource: TMVBDadosBase);
begin
  inherited;
  FData := TMVBData(ASource).Data;
  FDiaSemana.Assign(TMVBData(ASource).DiaSemana);
  FDia.Assign(TMVBData(ASource).Dia);
  FMes.Assign(TMVBData(ASource).Mes);
end;

procedure TMVBData.Clear;
begin
  inherited;
  FData := C_DATE_TIME_NULL;
  FDiaSemana.Clear;
  FDia.Clear;
  FMes.Clear;
end;

constructor TMVBData.Create;
begin
  inherited;
  FDiaSemana := TMVBSemana.Create;
  FDia := TMVBDia.Create;
  FMes := TMVBMes.Create;
end;

destructor TMVBData.Destroy;
begin
  FDiaSemana.Free;
  FDia.Free;
  FMes.Free;
  inherited;
end;

procedure TMVBData.SetData(const Value: TDate);
begin
  FData := Value;
end;

procedure TMVBData.SetDia(const Value: TMVBDia);
begin
  FDia.Assign(Value);
end;

procedure TMVBData.SetDiaSemana(const Value: TMVBSemana);
begin
  FDiaSemana.Assign(Value);
end;

procedure TMVBData.SetMes(const Value: TMVBMes);
begin
  FMes.Assign(Value);
end;

{ ************************************************************************** }
{ TMVBDadoPrevisaoLongoPrazo }
{ ************************************************************************** }

procedure TMVBDadoPrevisaoLongoPrazo.Assign(ASource: TMVBDadosBase);
begin
  inherited;
  FData.Assign(TMVBDadoPrevisaoLongoPrazo(ASource).Data);
  FOrdem := TMVBDadoPrevisaoLongoPrazo(ASource).Ordem;
  FRetorno := TMVBDadoPrevisaoLongoPrazo(ASource).Retorno;
  FAbertura := TMVBDadoPrevisaoLongoPrazo(ASource).Abertura;
  FMaximo := TMVBDadoPrevisaoLongoPrazo(ASource).Maximo;
  FMinimo := TMVBDadoPrevisaoLongoPrazo(ASource).Minimo;
  FFechamento := TMVBDadoPrevisaoLongoPrazo(ASource).Fechamento;
  FVolume := TMVBDadoPrevisaoLongoPrazo(ASource).Volume;
end;

procedure TMVBDadoPrevisaoLongoPrazo.Clear;
begin
  inherited;
  FData.Clear;
  FOrdem := C_INTEGER_NULL;
  FRetorno := C_DOUBLE_NULL;
  FAbertura := C_DOUBLE_NULL;
  FMaximo := C_DOUBLE_NULL;
  FMinimo := C_DOUBLE_NULL;
  FFechamento := C_DOUBLE_NULL;
  FVolume := C_INTEGER_NULL;
end;

constructor TMVBDadoPrevisaoLongoPrazo.Create;
begin
  inherited;
  FData := TMVBData.Create;
end;

destructor TMVBDadoPrevisaoLongoPrazo.Destroy;
begin
  FData.Free;
  inherited;
end;

procedure TMVBDadoPrevisaoLongoPrazo.SetAbertura(const Value: Extended);
begin
  FAbertura := Value;
end;

procedure TMVBDadoPrevisaoLongoPrazo.SetData(const Value: TMVBData);
begin
  FData := Value;
end;

procedure TMVBDadoPrevisaoLongoPrazo.SetFechamento(const Value: Extended);
begin
  FFechamento := Value;
end;

procedure TMVBDadoPrevisaoLongoPrazo.SetMaximo(const Value: Extended);
begin
  FMaximo := Value;
end;

procedure TMVBDadoPrevisaoLongoPrazo.SetMinimo(const Value: Extended);
begin
  FMinimo := Value;
end;

procedure TMVBDadoPrevisaoLongoPrazo.SetOrdem(const Value: Integer);
begin
  FOrdem := Value;
end;

procedure TMVBDadoPrevisaoLongoPrazo.SetRetorno(const Value: Extended);
begin
  FRetorno := Value;
end;

procedure TMVBDadoPrevisaoLongoPrazo.SetVolume(const Value: Extended);
begin
  FVolume := Value;
end;

initialization
  RegisterClass(TMVBDadoPrevisaoLongoPrazo);

finalization
  UnRegisterClass(TMVBDadoPrevisaoLongoPrazo);

end.
