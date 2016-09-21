{-----------------------------------------------------------------------------
 Unit Name: uMVBExcecoesMultiLayerPerceptron
 Author:    Vinícius
 Purpose:
 History:
-----------------------------------------------------------------------------}

unit uMVBExcecoesMultiLayerPerceptron;

interface

uses
  { MVB }
  uMVBClasses;

type
  { classe para para exceções de MLP }
  EMVBMultiLayerPerceptron = class(EMVBException);

  { classes de exceções }
  EMVBMultiLayerPerceptronRedeNaoConstruida = class(EMVBMultiLayerPerceptron)
  public
    constructor Create; reintroduce; overload;
  end;

  EMVBMultiLayerPerceptronMinimoCamadasNaoAtendido = class(
      EMVBMultiLayerPerceptron)
  public
    constructor Create; reintroduce; overload;
  end;

  EMVBMultiLayerPerceptronArquivoConhecimentoInexistente = class(
      EMVBMultiLayerPerceptron)
  public
    constructor Create(ANomeArquivo: string); reintroduce; overload;
  end;

implementation

uses
  { borland }
  SysUtils;

resourcestring
  SuMVBExcecoesMultiLayerPerceptron_OArquivoDeConhecimentoNaoExiste =
    'O arquivo de conhecimento %S não existe.';
  SuMVBExcecoesMultiLayerPerceptron_UmaRedeMLPDeveTerNoMinimo2Camada =
    'Uma rede MLP deve ter no mínimo 2 camadas';
  SuMVBExcecoesMultiLayerPerceptron_RedeNaoConstruida = 'Rede não construída.';

  { EMVBMultiLayerPerceptronRedeNaoConstruida }

  {-----------------------------------------------------------------------------
    Procedure: EMVBMultiLayerPerceptronRedeNaoConstruida.Create
    Author:    Vinícius
    Date:      11-jan-2000
    Arguments: None
    Result:    None
  -----------------------------------------------------------------------------}

constructor EMVBMultiLayerPerceptronRedeNaoConstruida.Create;
begin
  Self.Message := SuMVBExcecoesMultiLayerPerceptron_RedeNaoConstruida;
end;

{ EMVBMultiLayerPerceptronMinimoCamadasNaoAtendido }

{-----------------------------------------------------------------------------
  Procedure: EMVBMultiLayerPerceptronMinimoCamadasNaoAtendido.Create
  Author:    Vinícius
  Date:      11-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

constructor EMVBMultiLayerPerceptronMinimoCamadasNaoAtendido.Create;
begin
  Self.Message :=
    SuMVBExcecoesMultiLayerPerceptron_UmaRedeMLPDeveTerNoMinimo2Camada;
end;

{ EMVBMultiLayerPerceptronArquivoConhecimentoInexistente }

{-----------------------------------------------------------------------------
  Procedure: EMVBMultiLayerPerceptronArquivoConhecimentoInexistente.Create
  Author:    Vinícius
  Date:      25-jan-2000
  Arguments: ANomeArquivo: string
  Result:    None
-----------------------------------------------------------------------------}

constructor EMVBMultiLayerPerceptronArquivoConhecimentoInexistente.Create(
  ANomeArquivo: string);
begin
  Self.Message :=
    Format(SuMVBExcecoesMultiLayerPerceptron_OArquivoDeConhecimentoNaoExiste,
    [ANomeArquivo]);
end;

end.

