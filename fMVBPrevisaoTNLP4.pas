unit fMVBPrevisaoTNLP4;

interface

uses
  { borland }
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DB, ADODB, ActnList, Menus, ComCtrls, StdCtrls,
  { mvb }
  uMVBClasses, uMVBConsts, uMVBMlpPrevisao, uMVBParametrosRede,
  { teechart }
  VCLTee.TeEngine, VCLTee.Series, VCLTee.TeeProcs, VCLTee.Chart;

type
  TMVBSolucaoEscolhida = (seNenhuma, seLongoPrazo, seLongoPrazoComValores,
    seFechamento);

  TfrmMVBPrevisaoTNLP4 = class(TForm)
    qryDados: TADOQuery;
    mnuPrincipal: TMainMenu;
    aclAcoes: TActionList;
    Arquivo1: TMenuItem;
    arefas1: TMenuItem;
    actParamentosRede: TAction;
    Parmetrosdarede1: TMenuItem;
    pnlTreinamento: TPanel;
    pnlTextoTreinamento: TPanel;
    pgcTreinamento: TPageControl;
    tabInfoTreinamento: TTabSheet;
    tabConjuntoDadosTreinamento: TTabSheet;
    tabGraficosTreinamento: TTabSheet;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    lbeOrdemInicialTreinamento: TLabeledEdit;
    updOrdemInicialTreinamento: TUpDown;
    lbeOrdemFinalTreinamento: TLabeledEdit;
    updOrdemFinalTreinamento: TUpDown;
    lvwConjuntoDados: TListView;
    chtGrafico: TChart;
    actConstruirRede: TAction;
    actTreinar: TAction;
    actTestarRede: TAction;
    N1: TMenuItem;
    Construirrede1: TMenuItem;
    N2: TMenuItem;
    reinarrede1: TMenuItem;
    estarrede1: TMenuItem;
    actSair: TAction;
    Sair1: TMenuItem;
    btnConstruir: TButton;
    btnTreinar: TButton;
    Series1: TLineSeries;
    Bevel4: TBevel;
    lblConfiguracaoRede: TLabel;
    lvwConfiguracaoRede: TListView;
    Series2: TLineSeries;
    Series3: TLineSeries;
    Series4: TLineSeries;
    Series5: TLineSeries;
    sptDivisor: TSplitter;
    pnlTeste: TPanel;
    pnlDadosTeste: TPanel;
    pgcTeste: TPageControl;
    tabConjuntoTeste: TTabSheet;
    tabGraficosTeste: TTabSheet;
    lvwConjuntoDadosTeste: TListView;
    chtGraficoTeste: TChart;
    LineSeries1: TLineSeries;
    LineSeries5: TLineSeries;
    tabInfoTeste: TTabSheet;
    btnTestar: TButton;
    lbeOrdemInicialTeste: TLabeledEdit;
    lbeOrdemFinalTeste: TLabeledEdit;
    updOrdemFinalTeste: TUpDown;
    updOrdemInicialTeste: TUpDown;
    tabDadosPrevistos: TTabSheet;
    lvwDadosPrevistos: TListView;
    actEscolhaSolucaoLongoPrazo: TAction;
    actEscolhaSolucaoFechamento: TAction;
    Solues1: TMenuItem;
    SoluoparaLongoPrazo1: TMenuItem;
    N3: TMenuItem;
    SoluoFechamento1: TMenuItem;
    actSalvarConfiguracaoRede: TAction;
    N4: TMenuItem;
    Sarvarconfiguraesdaredeemarquivo1: TMenuItem;
    N5: TMenuItem;
    actSalvarGraficoTreinamento: TAction;
    actSalvarGraficoTeste: TAction;
    dlgSalvarArquivo: TSaveDialog;
    dlgSalvarGrafico: TSaveDialog;
    Salvargrficodetreinamento1: TMenuItem;
    Salvargrficodostestes1: TMenuItem;
    ppmConfiguracoesRede: TPopupMenu;
    Sarvarconfiguraesdaredeemarquivo2: TMenuItem;
    pmpGraficoTreinamento: TPopupMenu;
    Salvargrficodetreinamento2: TMenuItem;
    ppmGraficoTeste: TPopupMenu;
    Salvargrficodostestes2: TMenuItem;
    dlgCor: TColorDialog;
    actAlterarCorFundoGrafico: TAction;
    N6: TMenuItem;
    Alteraracordefundodosgrficos1: TMenuItem;
    N7: TMenuItem;
    Alteraracordefundodosgrficos2: TMenuItem;
    actExportarResultadosTestes: TAction;
    dlgExportarResultadosTeste: TSaveDialog;
    N8: TMenuItem;
    ExportarosresultadosdostestesparaHTML1: TMenuItem;
    N9: TMenuItem;
    ExportarosresultadosdostestesparaHTML2: TMenuItem;
    actVisualizarPontosNosGraficos: TAction;
    Grficoscompontos1: TMenuItem;
    Grficoscompontos2: TMenuItem;
    actEscolhaSolucaoLongoPrazoComValores: TAction;
    N10: TMenuItem;
    SoluoparaLongoPrazocomValoresAnteriores1: TMenuItem;
    actUsarAtraso: TAction;
    N11: TMenuItem;
    Usaratraso1: TMenuItem;
    pgbTreinamento: TProgressBar;
    lvwResultadoTeste: TListView;
    Bevel5: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actParamentosRedeExecute(Sender: TObject);
    procedure actConstruirRedeExecute(Sender: TObject);
    procedure actTreinarExecute(Sender: TObject);
    procedure actTestarRedeExecute(Sender: TObject);
    procedure actSairExecute(Sender: TObject);
    procedure actEscolhaSolucaoLongoPrazoExecute(Sender: TObject);
    procedure actEscolhaSolucaoFechamentoExecute(Sender: TObject);
    procedure actSalvarConfiguracaoRedeExecute(Sender: TObject);
    procedure actSalvarGraficoTreinamentoExecute(Sender: TObject);
    procedure actSalvarGraficoTesteExecute(Sender: TObject);
    procedure actAlterarCorFundoGraficoExecute(Sender: TObject);
    procedure lvwDadosPrevistosCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure actExportarResultadosTestesExecute(Sender: TObject);
    procedure actVisualizarPontosNosGraficosExecute(Sender: TObject);
    procedure actEscolhaSolucaoLongoPrazoComValoresExecute(
      Sender: TObject);
    procedure actUsarAtrasoExecute(Sender: TObject);
  private
    conTNLP: TADOConnection;
    FMLP: TMVBMlpPrevisao;
    FErroTotal: Extended;
    FCiclos: Integer;
    FSolucaoEscolhida: TMVBSolucaoEscolhida;
    { Private declarations }
    procedure AdicionarItem(AParametro, AValor: string);
    procedure InformarConfiguracoesRede;
    procedure RecuperarDadosTeste;
    procedure ExibirConjuntoDadosTreinamento;
    procedure ExibirConjuntoDadosTeste;
    procedure InformarErros;
    procedure ImprimirDados(const AListView: TListView;
      const AListaDados: TMVBListaBase; const AGrafico: TChart;
      AIndex: Integer; AListViewCompleto: Boolean = False); overload; virtual;
    procedure ImprimirDados(const AListaDados: TMVBListaBase;
      const AGrafico: TChart; AIndex: Integer); reintroduce; overload;
    procedure SetCiclos(const Value: Integer);
    procedure SetErroTotal(const Value: Extended);
    { eventos de treinamento }
    procedure OnTreinamento(AListaDados: TMVBListaBase;
      ACiclo, AEpoca: Integer; AErro: Extended);
    procedure SetSolucaoEscolhida(const Value: TMVBSolucaoEscolhida);
  public
    { Public declarations }
    property Ciclos: Integer read FCiclos write SetCiclos;
    property ErroTotal: Extended read FErroTotal write SetErroTotal;
    property SolucaoEscolhida: TMVBSolucaoEscolhida read FSolucaoEscolhida write
      SetSolucaoEscolhida;
  end;

var
  frmMVBPrevisaoTNLP4: TfrmMVBPrevisaoTNLP4;

implementation

uses
  { borland }
  Math,
  { mvb }
  fMVBCadastroComunicacao,
  fMVBDados,
  fMVBParametrosRede,
  uMVBDadoPrevisaoLongoPrazo, uMVBMultiLayerPerceptron;

const
  QUANT_ENTRADAS: Integer = 37;
  FC_STRING_CONEXAO = 'Provider=MSDASQL.1;' +
    'Password=sucesso;' +
    'Persist Security Info=True;' +
    'User ID=Admin;' +
    'Data Source=RNA';
//    'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%S;' +
//    'Persist Security Info=False;' +
//    'Jet OLEDB:Database Password=sucesso';

  {$R *.dfm}

  { **************************************************************************** }
  { TfrmMVBPrevisaoTNLP4 }
  { **************************************************************************** }

procedure TfrmMVBPrevisaoTNLP4.FormCreate(Sender: TObject);
begin
  FMLP := nil;
  { monta a string de conexao }
  conTNLP := fMVBDados.dtmDados.conAcoes;
  { cria a rede }
  Self.SolucaoEscolhida := seLongoPrazo;
end;

procedure TfrmMVBPrevisaoTNLP4.SetCiclos(const Value: Integer);
begin
  FCiclos := Value;
end;

procedure TfrmMVBPrevisaoTNLP4.SetErroTotal(const Value: Extended);
begin
  FErroTotal := Value;
end;

procedure TfrmMVBPrevisaoTNLP4.FormDestroy(Sender: TObject);
begin
  { aterra o evento }
  FMLP.OnTreinamento := nil;
  conTNLP := nil;
  { libera a rede }
  FMLP.Free;
end;

procedure TfrmMVBPrevisaoTNLP4.actParamentosRedeExecute(Sender: TObject);
var
  LForm: TfrmMVBParametrosRede;
begin
  Application.CreateForm(TfrmMVBParametrosRede, LForm);
  try
    LForm.Visible := False;
    LForm.ParametrosRede := FMLP.ParametrosRede;
    LForm.TituloForm := 'Parâmetros da RNA';
    LForm.EstadoForm := efAlterar;
    LForm.Init;
    LForm.ShowModal;
  finally
    LForm.Free;
  end;
end;

procedure TfrmMVBPrevisaoTNLP4.actConstruirRedeExecute(Sender: TObject);
begin
  FMLP.Clear;
  { constroi a rede }
  FMLP.OrdemInicialTreinamento := StrToInt(Trim(
    lbeOrdemInicialTreinamento.Text));
  FMLP.OrdemFinalTreinamento := StrToInt(Trim(
    lbeOrdemFinalTreinamento.Text));
  FMLP.FuncaoAtivacao := FMLP.ParametrosRede.FuncaoAtivacao;
  FMLP.Construir;
  { informa as configurações da rede }
  Self.InformarConfiguracoesRede;
  { exibe dados na listagem de conjunto de dados }
  Self.ExibirConjuntoDadosTreinamento;
end;

procedure TfrmMVBPrevisaoTNLP4.actTreinarExecute(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    pgbTreinamento.Min := 1;
    pgbTreinamento.Max := FMLP.ParametrosRede.Ciclos;
    pgbTreinamento.Position := pgbTreinamento.Min;
    FMLP.Treinar;
    Self.ErroTotal := FMLP.ErroTotal;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmMVBPrevisaoTNLP4.actTestarRedeExecute(Sender: TObject);
var
  LCursor: TCursor;
begin
  LCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
  try
    { passa os valores de treinamento para a rede }
    Self.RecuperarDadosTeste;
    { executa o treinamento }
    FMLP.Testar;
    { exibe dados na listagem de conjunto de dados }
    Self.ExibirConjuntoDadosTeste;
  finally
    Screen.Cursor := LCursor;
  end;
end;

procedure TfrmMVBPrevisaoTNLP4.actSairExecute(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmMVBPrevisaoTNLP4.InformarConfiguracoesRede;
var
  LFuncaoAtivacao: string;
begin
  lvwConfiguracaoRede.Items.BeginUpdate;
  try
    { limpa o listview }
    lvwConfiguracaoRede.Items.Clear;
    { passa as informações }
    Self.AdicionarItem('Arquivo de conhecimento',
      FMLP.ArquivoConhecimento);
    Self.AdicionarItem('', '');
    Self.AdicionarItem('Quantidade de camadas', IntToStr(FMLP.Estrutura.Count));
    Self.AdicionarItem('Quantidade de neurônios de entrada', FMLP.Estrutura[0]);
    if FMLP.ParametrosRede.UnidadesOcultas > 0 then
    begin
      Self.AdicionarItem('Quantidade de neurônios ocultos', FMLP.Estrutura[1]);
    end;
    Self.AdicionarItem('Quantidade de neurônios de Saída',
      FMLP.Estrutura[FMLP.Estrutura.Count - 1]);
    Self.AdicionarItem('', '');
    case FMLP.FuncaoAtivacao of
      faSigmoide: LFuncaoAtivacao := 'Sigmóide';
      faSigmoideBipolar: LFuncaoAtivacao := 'Sigmóide Bipolar';
    else
      LFuncaoAtivacao := 'Tangente Hiperbólica';
    end;
    Self.AdicionarItem('Função de ativação', LFuncaoAtivacao);
    Self.AdicionarItem('Taxa de aprendizagem',
      FormatFloat('0.000000', FMLP.Aprendizado));
    Self.AdicionarItem('Momento', FormatFloat('0.000000', FMLP.Momento));
    Self.AdicionarItem('Gama', FormatFloat('0.000000', FMLP.Gama));
    Self.AdicionarItem('', '');
    Self.AdicionarItem('Número de Ciclos',
      IntToStr(FMLP.ParametrosRede.Ciclos));
    Self.AdicionarItem('Conjunto de treinamento',
      Format('%d até %d',
      [FMLP.OrdemInicialTreinamento, FMLP.OrdemFinalTreinamento]));
    Self.AdicionarItem('', '');
  finally
    lvwConfiguracaoRede.Items.EndUpdate;
  end;
end;

procedure TfrmMVBPrevisaoTNLP4.ExibirConjuntoDadosTreinamento;
var
  LCont: Integer;
begin
  { limpa o gráfico }
  for LCont := 0 to chtGrafico.SeriesCount - 1 do
  begin
    chtGrafico.Series[LCont].Clear;
  end;
  { informa os dados }
  Self.ImprimirDados(lvwConjuntoDados, FMLP.ListaDados, chtGrafico, 0, True);
end;

procedure TfrmMVBPrevisaoTNLP4.RecuperarDadosTeste;
begin
  { constroi a rede }
  FMLP.OrdemInicialTeste := StrToInt(Trim(
    lbeOrdemInicialTeste.Text));
  FMLP.OrdemFinalTeste := StrToInt(Trim(
    lbeOrdemFinalTeste.Text));
end;

procedure TfrmMVBPrevisaoTNLP4.ExibirConjuntoDadosTeste;
var
  LCont: Integer;
begin
  { limpa o gráfico }
  for LCont := 0 to chtGraficoTeste.SeriesCount - 1 do
  begin
    chtGraficoTeste.Series[LCont].Clear;
  end;
  { com os valores de teste }
  Self.ImprimirDados(lvwConjuntoDadosTeste, FMLP.ListaDadosTeste,
    chtGraficoTeste, 0);
  { com os valores previstos }
  Self.ImprimirDados(lvwDadosPrevistos, FMLP.DadosPrevistos,
    chtGraficoTeste, 1);
  { informa os erros }
  Self.InformarErros;
end;

procedure TfrmMVBPrevisaoTNLP4.ImprimirDados(const AListView: TListView;
  const AListaDados: TMVBListaBase; const AGrafico: TChart;
  AIndex: Integer; AListViewCompleto: Boolean);
var
  LCont: Integer;
  LItem: TListItem;
  LDado: TMVBDadoPrevisaoLongoPrazo;
begin
  AListView.Items.BeginUpdate;
  try
    { informa os dados }
    AListView.Items.Clear;
    AGrafico.Series[AIndex].Clear;
    { percorre o listview }
    for LCont := 0 to AListaDados.Count - 1 do
    begin
      { recupera os valores }
      LDado := AListaDados.ProcurarPorIndice(LCont)
        as TMVBDadoPrevisaoLongoPrazo;
      { adiciona os valores recuperados pela rede ao listview }
      LItem := AListView.Items.Add;
      LItem.Caption := IntToStr(LDado.Ordem);
      if AListViewCompleto then
      begin
        LItem.SubItems.Add(FormatDateTime('dd/mm/yyyy', LDado.Data.Data));
        LItem.SubItems.Add(FormatFloat('0.00000000', LDado.Retorno));
        LItem.SubItems.Add(FormatFloat('0.00', LDado.Abertura));
        LItem.SubItems.Add(FormatFloat('0.00', LDado.Maximo));
        LItem.SubItems.Add(FormatFloat('0.00', LDado.Minimo));
        LItem.SubItems.Add(FormatFloat('###,###,###,##0', LDado.Volume));
      end;
      LItem.SubItems.Add(FormatFloat('0.00', LDado.Fechamento));
      { insere os valores no gráfico }
      AGrafico.Series[AIndex].AddXY(LDado.Ordem, LDado.Fechamento);
    end;
  finally
    AListView.Items.EndUpdate;
  end;
end;

procedure TfrmMVBPrevisaoTNLP4.ImprimirDados(
  const AListaDados: TMVBListaBase; const AGrafico: TChart;
  AIndex: Integer);
var
  LCont: Integer;
  LDado: TMVBDadoPrevisaoLongoPrazo;
begin
  { informa os dados }
  AGrafico.Series[AIndex].Clear;
  { percorre o listview }
  for LCont := 0 to AListaDados.Count - 1 do
  begin
    { recupera os valores }
    LDado := AListaDados.ProcurarPorIndice(LCont)
      as TMVBDadoPrevisaoLongoPrazo;
    { insere os valores no gráfico }
    AGrafico.Series[AIndex].AddXY(LDado.Ordem, LDado.Fechamento);
  end;
end;

procedure TfrmMVBPrevisaoTNLP4.OnTreinamento(AListaDados: TMVBListaBase;
  ACiclo, AEpoca: Integer; AErro: Extended);
var
  LUmQuarto, LMetade, LTresQuartos: Integer;

  function LCalcularMSE: Extended;
  var
    LErro, LMSE: Extended;
    LCont, LQuant: Integer;
    LDado, LDadoPrevisto: TMVBDadoPrevisaoLongoPrazo;
  begin
    LMSE := 0;
    LQuant := 0;
    for LCont := 0 to FMLP.ListaDados.Count - 1 do
    begin
      { recupera o dado original }
      LDado := FMLP.ListaDados.ProcurarPorIndice(
        LCont) as TMVBDadoPrevisaoLongoPrazo;
      { recupera o dado previsto }
      LDadoPrevisto := AListaDados.ProcurarPorIndice(
        LCont) as TMVBDadoPrevisaoLongoPrazo;
      { recupera o erro }
      LErro := LDado.Fechamento - LDadoPrevisto.Fechamento;
      if LErro <> LDado.Fechamento then
      begin
        LMSE := LMSE + Sqr(LErro);
        Inc(LQuant);
      end;
    end;
    Result := LMSE / LQuant;
  end;

  procedure LInformarErro;
  begin
    Self.AdicionarItem(Format(
      'Erro Total (Cost) em ciclo = %d e época = %d.',
      [ACiclo, AEpoca]),
      FormatFloat('0.00000000', AErro));
    Self.AdicionarItem(Format(
      'MSE em ciclo = %d e época = %d.',
      [ACiclo, AEpoca]),
      Format('%3.6f', [LCalcularMSE]));
    Self.AdicionarItem('', '');
  end;

begin
  pgbTreinamento.Position := pgbTreinamento.Position + 1;
  Application.ProcessMessages;
  { checa as épocas }
  LUmQuarto := FMLP.ParametrosRede.Ciclos div 4;
  LMetade := FMLP.ParametrosRede.Ciclos div 2;
  LTresQuartos := (FMLP.ParametrosRede.Ciclos * 3) div 4;
  { imprime os dados }
  if ACiclo = LUmQuarto then
  begin
    Self.ImprimirDados(AListaDados, chtGrafico, 1);
    LInformarErro;
  end
  else if ACiclo = LMetade then
  begin
    Self.ImprimirDados(AListaDados, chtGrafico, 2);
    LInformarErro;
  end
  else if ACiclo = LTresQuartos then
  begin
    Self.ImprimirDados(AListaDados, chtGrafico, 3);
    LInformarErro;
  end
  else if ACiclo = FMLP.ParametrosRede.Ciclos - 1 then
  begin
    Self.ImprimirDados(AListaDados, chtGrafico, 4);
    LInformarErro;
  end;
end;

procedure TfrmMVBPrevisaoTNLP4.AdicionarItem(AParametro, AValor: string);
var
  LItem: TListItem;
begin
  LItem := lvwConfiguracaoRede.Items.Add;
  LItem.Caption := AParametro;
  LItem.SubItems.Add(AValor);
end;

procedure TfrmMVBPrevisaoTNLP4.SetSolucaoEscolhida(
  const Value: TMVBSolucaoEscolhida);
begin
  if FSolucaoEscolhida <> Value then
  begin
    FSolucaoEscolhida := Value;
    { libera a anterior }
    if FMLP <> nil then
    begin
      FMLP.OnTreinamento := nil;
      FMLP.Query := nil;
      FMLP.Free;
    end;
    { cria a rede de acordo com a solução }
    case FSolucaoEscolhida of
      seLongoPrazo: FMLP := TMVBMlpPrevisaoLongoPrazo.Create;
      seLongoPrazoComValores: FMLP :=
        TMVBMlpPrevisaoLongoPrazoComValoresAnteriores.Create;
    else
      FMLP := TMVBMlpPrevisaoFechamento.Create;
    end;
    { informa a query }
    FMLP.Query := qryDados;
    { informa o evento de treinamento }
    FMLP.OnTreinamento := OnTreinamento;
    { recupera os dados dos parâmetros da rede }
    dtmDados.ParametrosRedeRecuperarItem(FMLP.ParametrosRede,
      FMLP.ParametrosRede);
  end;
end;

procedure TfrmMVBPrevisaoTNLP4.actEscolhaSolucaoLongoPrazoExecute(
  Sender: TObject);
begin
  Self.SolucaoEscolhida := seLongoPrazo;
end;

procedure TfrmMVBPrevisaoTNLP4.actEscolhaSolucaoLongoPrazoComValoresExecute(
  Sender: TObject);
begin
  Self.SolucaoEscolhida := seLongoPrazoComValores;
end;

procedure TfrmMVBPrevisaoTNLP4.actEscolhaSolucaoFechamentoExecute(
  Sender: TObject);
begin
  Self.SolucaoEscolhida := seFechamento;
end;

procedure TfrmMVBPrevisaoTNLP4.actSalvarConfiguracaoRedeExecute(
  Sender: TObject);
var
  LCont: Integer;
  LItem: TListItem;
  LArquivo: TStringList;
  LCaption, LValor: string;
begin
  if dlgSalvarArquivo.Execute then
  begin
    LArquivo := TStringList.Create;
    try
      LArquivo.Add('Parâmetros: Valores');
      LArquivo.Add('-------------------');
      LArquivo.Add('');
      for LCont := 0 to lvwConfiguracaoRede.Items.Count - 1 do
      begin
        LItem := lvwConfiguracaoRede.Items[LCont];
        LCaption := LItem.Caption;
        LValor := LItem.SubItems[0];
        if LCaption = EmptyStr then
        begin
          LArquivo.Add('');
        end
        else
        begin
          LArquivo.Add(Format('%S: %S', [LCaption, LValor]));
        end;
      end;
      LArquivo.SaveToFile(dlgSalvarArquivo.FileName);
    finally
      LArquivo.Free;
    end;
  end;
end;

procedure TfrmMVBPrevisaoTNLP4.actSalvarGraficoTreinamentoExecute(
  Sender: TObject);
begin
  if dlgSalvarGrafico.Execute then
  begin
    chtGrafico.SaveToBitmapFile(dlgSalvarGrafico.FileName);
  end;
end;

procedure TfrmMVBPrevisaoTNLP4.actSalvarGraficoTesteExecute(
  Sender: TObject);
begin
  if dlgSalvarGrafico.Execute then
  begin
    chtGraficoTeste.SaveToBitmapFile(dlgSalvarGrafico.FileName);
  end;
end;

procedure TfrmMVBPrevisaoTNLP4.actAlterarCorFundoGraficoExecute(
  Sender: TObject);
begin
  dlgCor.Color := chtGrafico.Color;
  if dlgCor.Execute then
  begin
    chtGrafico.Color := dlgCor.Color;
    chtGraficoTeste.Color := dlgCor.Color;
  end;
end;

procedure TfrmMVBPrevisaoTNLP4.lvwDadosPrevistosCustomDrawSubItem(
  Sender: TCustomListView; Item: TListItem; SubItem: Integer;
  State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if (SubItem = 2) then
  begin
    if Item.SubItems[1] <> EmptyStr then
    begin
      if (StrToFloat(Item.SubItems[1]) >= 5) then
      begin
        Sender.Canvas.Font.Color := clRed;
        Sender.Canvas.Font.Style := [fsBold];
        Sender.Canvas.Brush.Color := clSilver;
      end
      else
      begin
        Sender.Canvas.Font.Color := clWindowText;
        Sender.Canvas.Font.Style := [];
        Sender.Canvas.Brush.Color := clWindow;
      end;
    end;
  end;
end;

procedure TfrmMVBPrevisaoTNLP4.actExportarResultadosTestesExecute(
  Sender: TObject);
var
  LCont: Integer;
  LItem: TListItem;
  LArquivo: TStringList;
begin
  if dlgExportarResultadosTeste.Execute then
  begin
    LArquivo := TStringList.Create;
    try
      LArquivo.Add('<TABLE BORDER = "1">');
      LArquivo.Add('<TR>');
      LArquivo.Add('<TD ALIGN = "Certer"><B>Valor Original</B></TD>');
      LArquivo.Add('<TD ALIGN = "Certer"><B>Valor Previsto</B></TD>');
      LArquivo.Add('<TD ALIGN = "Certer"><B>Erro %</B></TD>');
      LArquivo.Add('<TD ALIGN = "Certer"><B>Direção do Erro</B></TD>');
      LArquivo.Add('</TR>');
      { recupera os valores}
      LCont := 0;
      while LCont < lvwDadosPrevistos.Items.Count do
      begin
        { insere linha }
        LArquivo.Add('<TR>');
        if LCont = lvwDadosPrevistos.Items.Count - 1 then
        begin
          LArquivo.Add(Format('<TD ALIGN = "Right">%S</TD>',
            ['']));
        end
        else
        begin
          { valor original }
          LItem := lvwConjuntoDadosTeste.Items[LCont];
          LArquivo.Add(Format('<TD ALIGN = "Right">%S</TD>',
            [LItem.SubItems[0]]));
        end;
        { valor previsto }
        LItem := lvwDadosPrevistos.Items[LCont];
        LArquivo.Add(Format('<TD ALIGN = "Right">%S</TD>',
          [LItem.SubItems[0]]));
        { erro }
        LArquivo.Add(Format('<TD ALIGN = "Center">%S</TD>',
          [LItem.SubItems[1]]));
        { direção do erro }
        LArquivo.Add(Format('<TD ALIGN = "Left">%S</TD>', [LItem.SubItems[2]]));
        { encerra linha }
        LArquivo.Add('</TR>');
        Inc(LCont);
      end;
      LArquivo.Add('</TABLE>');
      { informa os erros }
      LArquivo.Add('<P>');
      for LCont := 0 to lvwResultadoTeste.Items.Count - 1 do
      begin
        LItem := lvwResultadoTeste.Items[LCont];
        LArquivo.Add(Format('%S = %S<BR>', [LItem.Caption, LItem.SubItems[0]]));
      end;
      LArquivo.Add('</P>');
      { salva dados no arquivo }
      LArquivo.SaveToFile(dlgExportarResultadosTeste.FileName);
    finally
      LArquivo.Free;
    end;
  end;
end;

procedure TfrmMVBPrevisaoTNLP4.actVisualizarPontosNosGraficosExecute(
  Sender: TObject);
var
  LCont: Integer;
begin
  for LCont := 0 to chtGrafico.SeriesCount - 1 do
  begin
    TPointSeries(chtGrafico.Series[LCont]).Pointer.Visible :=
      TAction(Sender).Checked;
  end;
  for LCont := 0 to chtGraficoTeste.SeriesCount - 1 do
  begin
    TPointSeries(chtGraficoTeste.Series[LCont]).Pointer.Visible :=
      TAction(Sender).Checked;
  end;
end;

procedure TfrmMVBPrevisaoTNLP4.actUsarAtrasoExecute(Sender: TObject);
begin
  FMLP.UsarAtraso := actUsarAtraso.Checked;
  actTestarRede.Execute;
end;

procedure TfrmMVBPrevisaoTNLP4.InformarErros;
var
  LCont, LContValoresValidos: Integer;
  LItem: TListItem;
  LDado, LDadoPrevisto: TMVBDadoPrevisaoLongoPrazo;
  LErro, LME, LMAE, LMSE, LMAPE, LValor: Extended;
//  LNMAE: Extended;

begin
  { inicializa os erros }
  LME := 0;
  LMAE := 0;
  LMSE := 0;
  LMAPE := 0;
  LContValoresValidos := 0;
  { informa os erros }
  LCont := 0;
  while LCont < lvwDadosPrevistos.Items.Count - 1 do
  begin
    LItem := lvwDadosPrevistos.Items[LCont];
    { se a coluna não existir }
    if LItem.SubItems.Count = 1 then
    begin
      LItem.SubItems.Add('');
      LItem.SubItems.Add('');
    end;
    LDado := FMLP.ListaDadosTeste.ProcurarPorIndice(LCont) as
      TMVBDadoPrevisaoLongoPrazo;
    LDadoPrevisto := FMLP.DadosPrevistos.ProcurarPorIndice(LCont) as
      TMVBDadoPrevisaoLongoPrazo;
    LValor :=
      Abs(LDado.Fechamento - LDadoPrevisto.Fechamento) * 100 /
      LDado.Fechamento;
    { checa se o erro é diferente de 100% }
    if LValor <> 100 then
    begin
      LErro := (LDado.Fechamento - LDadoPrevisto.Fechamento);
      LME := LME + LErro;
      LMAE := LMAE + Abs(LErro);
      LMSE := LMSE + Sqr(LErro);
      LMAPE := LMAPE + LValor;
      Inc(LContValoresValidos);
    end;
    { adiciona o dado }
    LItem.SubItems[1] := Format('%3.2f', [LValor]);
    { adiciona a direção }
    if (LDado.Fechamento - LDadoPrevisto.Fechamento) > 0 then
    begin
      LItem.SubItems[2] := 'para baixo';
    end
    else
    begin
      LItem.SubItems[2] := 'para cima';
    end;
    Inc(LCont);
  end;
  LItem := lvwDadosPrevistos.Items[LCont];
  { se a coluna não existir }
  if LItem.SubItems.Count = 1 then
  begin
    LItem.SubItems.Add('');
    LItem.SubItems.Add('');
  end;

  //LNMAE := 0;//Norm([LMAPE]);

  lvwResultadoTeste.Items.Clear;

  { imprime o ME }
  LItem := lvwResultadoTeste.Items.Add;
  LItem.Caption := 'ME (Erro Médio)';
  LItem.SubItems.Add(Format('%3.6f', [LME / LContValoresValidos]));
  { imprime o MSE }
  LItem := lvwResultadoTeste.Items.Add;
  LItem.Caption := 'MSE (Erro Médio Quadrado)';
  LItem.SubItems.Add(Format('%3.6f', [LMSE / LContValoresValidos]));
  { imprime o MAE }
  LItem := lvwResultadoTeste.Items.Add;
  LItem.Caption := 'MAE (Erro Médio Absoluto)';
  LItem.SubItems.Add(Format('%3.6f', [LMAE / LContValoresValidos]));
  { imprime o MAPE }
  LItem := lvwResultadoTeste.Items.Add;
  LItem.Caption := 'MAPE (Erro Percentual Médio Absoluto)';
  LItem.SubItems.Add(Format('%1.2f', [LMAPE / LContValoresValidos]) + '%');
  { imprime o NMAE }
(*
  LItem := lvwResultadoTeste.Items.Add;
  LItem.Caption := 'NMAE (Erro Médio Absoluto Normalizado)';
  LItem.SubItems.Add(Format('%1.2f', [LNMAE]) + '%');
*)
end;

end.

