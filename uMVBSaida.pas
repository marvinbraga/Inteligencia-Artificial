{-----------------------------------------------------------------------------
 Unit Name: uMVBSaida
 Author:    Vinícius
 Purpose:
 History:
-----------------------------------------------------------------------------}

unit uMVBSaida;

interface

uses
  { borland }
  Classes,
  { mvb }
  uMVBClasses, uMVBConsts;

type
  TMVBPropriedadesSaida = (psId, psDescricao);

  TMVBSaida = class(TMVBDadosBase)
  private
    FValor: Double;
    FDescricao: string;
  protected
  public
    procedure Clear; override;
    procedure Assign(ASource: TMVBDadosBase); override;
  published
    property Descricao: string read FDescricao write FDescricao;
    property Valor: Double read FValor write FValor;
  end;

implementation

{ TMVBSaida }

{-----------------------------------------------------------------------------
  Procedure: TMVBSaida.Assign
  Author:    Vinícius
  Date:      31-jan-2000
  Arguments: ASource: TMVBDadosBase
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBSaida.Assign(ASource: TMVBDadosBase);
begin
  inherited;
  FDescricao := TMVBSaida(ASource).Descricao;
  FValor := TMVBSaida(ASource).Valor;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBSaida.Clear
  Author:    Vinícius
  Date:      31-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBSaida.Clear;
begin
  inherited;
  FDescricao := C_STRING_NULL;
  FValor := C_DOUBLE_NULL;
end;

initialization
  RegisterClass(TMVBSaida);

finalization
  UnRegisterClass(TMVBSaida);

end.

