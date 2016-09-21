{-----------------------------------------------------------------------------
 Unit Name: uMVBHistoricoAtivo
 Author:    Vinícius
 Purpose:
 History:
-----------------------------------------------------------------------------}

unit uMVBHistoricoAtivo;

interface

uses
  { borland }
  Classes,
  { mvb }
  uMVBClasses, uMVBHistorico, uMVBAtivoEmpresa, uMVBListaSaida;

type
  TMVBHistoricoAtivo = class(TMVBHistorico)
  private
    FAtivo: TMVBAtivoEmpresa;
    FSaidas: TMVBListaSaida;
    procedure SetAtivo(const Value: TMVBAtivoEmpresa);
    procedure SetSaidas(const Value: TMVBListaSaida);
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear; override;
    procedure Assign(ASource: TMVBDadosBase); override;
  published
    property Ativo: TMVBAtivoEmpresa read FAtivo write SetAtivo;
    property Saidas: TMVBListaSaida read FSaidas write SetSaidas;
  end;

implementation

{ TMVBHistoricoAtivo }

{-----------------------------------------------------------------------------
  Procedure: TMVBHistoricoAtivo.Assign
  Author:    Vinícius
  Date:      31-jan-2000
  Arguments: ASource: TMVBDadosBase
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBHistoricoAtivo.Assign(ASource: TMVBDadosBase);
begin
  inherited;
  FAtivo.Assign(TMVBHistoricoAtivo(ASource).Ativo);
  FSaidas.AssignObjects(TMVBHistoricoAtivo(ASource).Saidas);
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBHistoricoAtivo.Clear
  Author:    Vinícius
  Date:      31-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBHistoricoAtivo.Clear;
begin
  inherited;
  FAtivo.Clear;
  FSaidas.Clear;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBHistoricoAtivo.Create
  Author:    Vinícius
  Date:      31-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

constructor TMVBHistoricoAtivo.Create;
begin
  inherited;
  FAtivo := TMVBAtivoEmpresa.Create;
  FSaidas := TMVBListaSaida.Create;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBHistoricoAtivo.Destroy
  Author:    Vinícius
  Date:      31-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

destructor TMVBHistoricoAtivo.Destroy;
begin
  FAtivo.Free;
  FSaidas.Free;
  inherited;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBHistoricoAtivo.SetAtivo
  Author:    Vinícius
  Date:      31-jan-2000
  Arguments: const Value: TMVBAtivoEmpresa
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBHistoricoAtivo.SetAtivo(const Value: TMVBAtivoEmpresa);
begin
  FAtivo.Assign(Value);
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBHistoricoAtivo.SetSaidas
  Author:    Vinícius
  Date:      31-dez-2003
  Arguments: const Value: TMVBListaSaida
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBHistoricoAtivo.SetSaidas(const Value: TMVBListaSaida);
begin
  FSaidas.AssignObjects(Value);
end;

initialization
  RegisterClass(TMVBHistoricoAtivo);

finalization
  UnRegisterClass(TMVBHistoricoAtivo);

end.

