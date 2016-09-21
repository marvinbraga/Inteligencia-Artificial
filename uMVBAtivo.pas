{-----------------------------------------------------------------------------
 Unit Name: uMVBAtivo
 Author:    Vinícius
 Purpose:
 History:
-----------------------------------------------------------------------------}

unit uMVBAtivo;

interface

uses
  { borland }
  Classes,
  { mvb }
  uMVBClasses, uMVBConsts;

type
  TMVBPropriedadesAtivo = (paId, paSigla, paDescricao);

  TMVBTipoAtivo = (taDesconhecido, taAcao, taOpcaoCompra, taOpcaoVenda);

  TMVBAtivo = class(TMVBDadosBase)
  private
    FSigla: string;
    FTipo: TMVBTipoAtivo;
    FValor: double;
    FDescricao: string;
    FVencimento: TDateTime;
  protected
  public
    procedure Clear; override;
    procedure Assign(ASource: TMVBDadosBase); override;
  published
    property Sigla: string read FSigla write FSigla;
    property Tipo: TMVBTipoAtivo read FTipo write FTipo;
    property Descricao: string read FDescricao write FDescricao;
    property Valor: double read FValor write FValor;
    property Vencimento: TDateTime read FVencimento write FVencimento; 
  end;

implementation

{ TMVBAtivo }

{-----------------------------------------------------------------------------
  Procedure: TMVBAtivo.Assign
  Author:    Vinícius
  Date:      30-jan-2000
  Arguments: ASource: TMVBDadosBase
  Result:    None
-----------------------------------------------------------------------------}
procedure TMVBAtivo.Assign(ASource: TMVBDadosBase);
begin
  inherited;
  FSigla := TMVBAtivo(ASource).Sigla;
  FTipo := TMVBAtivo(ASource).Tipo;
  FDescricao := TMVBAtivo(ASource).Descricao;
  FValor := TMVBAtivo(ASource).Valor;
  FVencimento := TMVBAtivo(ASource).Vencimento;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBAtivo.Clear
  Author:    Vinícius
  Date:      30-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}
procedure TMVBAtivo.Clear;
begin
  inherited;
  FSigla := C_STRING_NULL;
  FTipo := taDesconhecido;
  FDescricao := C_STRING_NULL;
  FValor := C_DOUBLE_NULL;
  FVencimento := C_DATE_TIME_NULL;
end;

initialization
  RegisterClass(TMVBAtivo);

finalization
  UnRegisterClass(TMVBAtivo);

end.
