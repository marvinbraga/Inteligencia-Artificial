unit fMVBParametrosRede;

interface

uses
  { borland }
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ActnList, ExtCtrls,
  { mvb }
  fMVBCadastroComunicacao,
  uMVBConsts,
  uMVBParametrosRede;

type
  TfrmMVBParametrosRede = class(TfrmMVBCadastroComunicacao)
    lbeNeuroniosOcultos: TLabeledEdit;
    cboFuncaoAtivacao: TComboBox;
    lblFuncaoAtivacao: TLabel;
    lbeNumeroEpocas: TLabeledEdit;
    lbeTaxaAprendizagem: TLabeledEdit;
    lbeMomento: TLabeledEdit;
    lbeArquivoConhecimento: TLabeledEdit;
    btnArquivoConhecimento: TButton;
    dlgOpen: TOpenDialog;
    procedure btnArquivoConhecimentoClick(Sender: TObject);
  private
    FParametrosRede: TMVBParametrosRede;
    procedure SetParametrosRede(const Value: TMVBParametrosRede);
  protected
    procedure DoNovo; override;
    procedure DoAlterar; override;
    procedure ObjetosToControles; override;
    procedure ControlesToObjetos; override;
    procedure LimparControles; override;
  public
    procedure Init; override;
    property ParametrosRede: TMVBParametrosRede read FParametrosRede
      write SetParametrosRede;
  end;

var
  frmMVBParametrosRede: TfrmMVBParametrosRede;

implementation

uses
  { mvb }
  fMVBDados, uMVBMultiLayerPerceptron;

{$R *.dfm}

{ TfrmMVBParametrosRede }

procedure TfrmMVBParametrosRede.ControlesToObjetos;
begin
  FParametrosRede.UnidadesOcultas := StrToInt(Trim(lbeNeuroniosOcultos.Text));
  case cboFuncaoAtivacao.ItemIndex of
    //0: FParametrosRede.FuncaoAtivacao := faNaoInformada;
    //1: FParametrosRede.FuncaoAtivacao := faLinearPorPartes;
    0: FParametrosRede.FuncaoAtivacao := faSigmoide;
    1: FParametrosRede.FuncaoAtivacao := faSigmoideBipolar;
  else
    FParametrosRede.FuncaoAtivacao := faTangenteHiperbolica;
  end;
  FParametrosRede.Ciclos := StrToInt(Trim(lbeNumeroEpocas.Text));
  FParametrosRede.Apredizado := StrToFloat(Trim(lbeTaxaAprendizagem.Text));
  FParametrosRede.Momento := StrToFloat(Trim(lbeMomento.Text));
  FParametrosRede.ArquivoConhecimento := Trim(lbeArquivoConhecimento.Text);
end;

procedure TfrmMVBParametrosRede.DoAlterar;
begin
  dtmDados.ParametrosRedeAlterar(FParametrosRede);
end;

procedure TfrmMVBParametrosRede.DoNovo;
begin
  { nada aqui }
end;

procedure TfrmMVBParametrosRede.Init;
begin
  Assert(FParametrosRede <> nil,
    'A propriedade ParametrosRede não pode ser NIL.');
  inherited;
end;

procedure TfrmMVBParametrosRede.LimparControles;
begin
  lbeNeuroniosOcultos.Text := EmptyStr;
  cboFuncaoAtivacao.ItemIndex := 0;
  lbeNumeroEpocas.Text := EmptyStr;
  lbeTaxaAprendizagem.Text := EmptyStr;
  lbeMomento.Text := EmptyStr;
  lbeArquivoConhecimento.Text := EmptyStr;
end;

procedure TfrmMVBParametrosRede.ObjetosToControles;
begin
  lbeNeuroniosOcultos.Text := IntToStr(FParametrosRede.UnidadesOcultas);
  case FParametrosRede.FuncaoAtivacao of
    //faNaoInformada: cboFuncaoAtivacao.ItemIndex := 0;
    //faLinearPorPartes: cboFuncaoAtivacao.ItemIndex := 1;
    faSigmoide: cboFuncaoAtivacao.ItemIndex := 0;
    faSigmoideBipolar: cboFuncaoAtivacao.ItemIndex := 1;
  else
    cboFuncaoAtivacao.ItemIndex := 2;
  end;
  lbeNumeroEpocas.Text := IntToStr(FParametrosRede.Ciclos);
  lbeTaxaAprendizagem.Text := FloatToStr(FParametrosRede.Apredizado);
  lbeMomento.Text := FloatToStr(FParametrosRede.Momento);
  lbeArquivoConhecimento.Text := FParametrosRede.ArquivoConhecimento;
end;

procedure TfrmMVBParametrosRede.SetParametrosRede(
  const Value: TMVBParametrosRede);
begin
  FParametrosRede := Value;
end;

procedure TfrmMVBParametrosRede.btnArquivoConhecimentoClick(
  Sender: TObject);
begin
  inherited;
  if dlgOpen.Execute then
  begin
    FParametrosRede.ArquivoConhecimento := dlgOpen.FileName;
    Self.ObjetosToControles;
  end;
end;

end.
