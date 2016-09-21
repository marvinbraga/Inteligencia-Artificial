{-----------------------------------------------------------------------------
 Unit Name: uMVBSaidaAtivo
 Author:    Vinícius
 Purpose:
 History:
-----------------------------------------------------------------------------}

unit uMVBSaidaHistorico;

interface

uses
  { borland }
  Classes,
  { mvb }
  uMVBClasses, uMVBHistoricoAtivo, uMVBSaida;

type
  TMVBSaidaHistorico = class(TMVBDadosBase)
  private
    FSaida: TMVBSaida;
    FHistoricoAtivo: TMVBHistoricoAtivo;
    procedure SetSaida(const Value: TMVBSaida);
    procedure SetHistoricoAtivo(const Value: TMVBHistoricoAtivo);
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear; override;
    procedure Assign(ASource: TMVBDadosBase); override;
  published
    property Saida: TMVBSaida read FSaida write SetSaida;
    property HistoricoAtivo: TMVBHistoricoAtivo read FHistoricoAtivo write
      SetHistoricoAtivo;
  end;

implementation

{ TMVBSaidaHistorico }

{-----------------------------------------------------------------------------
  Procedure: TMVBSaidaHistorico.Assign
  Author:    Vinícius
  Date:      31-jan-2000
  Arguments: ASource: TMVBDadosBase
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBSaidaHistorico.Assign(ASource: TMVBDadosBase);
begin
  inherited;
  FSaida.Assign(TMVBSaidaHistorico(ASource).Saida);
  FHistoricoAtivo.Assign(TMVBSaidaHistorico(ASource).HistoricoAtivo);
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBSaidaHistorico.Clear
  Author:    Vinícius
  Date:      31-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBSaidaHistorico.Clear;
begin
  inherited;
  FSaida.Clear;
  FHistoricoAtivo.Clear;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBSaidaHistorico.Create
  Author:    Vinícius
  Date:      31-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

constructor TMVBSaidaHistorico.Create;
begin
  inherited;
  FHistoricoAtivo := TMVBHistoricoAtivo.Create;
  FSaida := TMVBSaida.Create;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBSaidaHistorico.Destroy
  Author:    Vinícius
  Date:      31-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

destructor TMVBSaidaHistorico.Destroy;
begin
  FHistoricoAtivo.Free;
  FSaida.Free;
  inherited;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBSaidaHistorico.SetHistoricoAtivo
  Author:    Vinícius
  Date:      31-jan-2000
  Arguments: const Value: TMVBHistoricoAtivo
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBSaidaHistorico.SetHistoricoAtivo(const Value: TMVBHistoricoAtivo);
begin
  FHistoricoAtivo.Assign(Value);
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBSaidaHistorico.SetSaida
  Author:    Vinícius
  Date:      31-jan-2000
  Arguments: const Value: TMVBSaida
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBSaidaHistorico.SetSaida(const Value: TMVBSaida);
begin
  FSaida.Assign(Value);
end;

initialization
  RegisterClass(TMVBSaidaHistorico);

finalization
  UnRegisterClass(TMVBSaidaHistorico);

end.

