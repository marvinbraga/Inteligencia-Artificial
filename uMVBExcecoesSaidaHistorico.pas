{-----------------------------------------------------------------------------
 Unit Name: uMVBExcecoesSaidaHistorico
 Author:    Vinícius
 Purpose:
 History:
-----------------------------------------------------------------------------}

unit uMVBExcecoesSaidaHistorico;

interface

uses
  { mvb }
  uMVBClasses;

type
  { classes de exceções }
  EMVBExcecaoSaidaHistorico = class(EMVBException);

  EMVBExcecaoSaidaHistoricoNaoEncontrada = class(EMVBExcecaoSaidaHistorico)
  public
    constructor Create; reintroduce; overload;
  end;

  EMVBExcecaoSaidaHistoricoJaCadastrada = class(EMVBExcecaoSaidaHistorico)
  public
    constructor Create; reintroduce; overload;
  end;

implementation

resourcestring
  SuMVBExcecoesSaidaHistorico_SaidaHistoricoJaCadastrada =
    'Saída/Histórico já cadastrada.';
  SuMVBExcecoesSaidaHistorico_SaidaHistoricoNaoEncontrada =
    'Saída/Histórico não encontrada.';

  { EMVBExcecaoSaidaHistoricoNaoEncontrada }

constructor EMVBExcecaoSaidaHistoricoNaoEncontrada.Create;
begin
  Self.Message := SuMVBExcecoesSaidaHistorico_SaidaHistoricoNaoEncontrada;
end;

{ EMVBExcecaoSaidaHistoricoJaCadastrada }

constructor EMVBExcecaoSaidaHistoricoJaCadastrada.Create;
begin
  Self.Message := SuMVBExcecoesSaidaHistorico_SaidaHistoricoJaCadastrada;
end;

end.

