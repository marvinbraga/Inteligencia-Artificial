{-----------------------------------------------------------------------------
 Unit Name: uMVBClasses
 Author:    Marcus Vinicius Braga (mvbraga@gmail.com)
 Purpose:
 History:
-----------------------------------------------------------------------------}

unit uMVBClasses;

interface

uses
  { borland }
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Contnrs,
  { mvb }
  uMVBConsts;

type
  EMVBException = class(Exception);

  TMVBDadosBase = class(TPersistent)
  private
    FId: TGUID;
    procedure RecuperarNovoId;
    procedure SetId(const Value: TGUID);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function GetKey: string; virtual;
    function Equals(AItem: TMVBDadosBase): Boolean; reintroduce; virtual;
    procedure Clear; virtual;
    procedure Assign(ASource: TMVBDadosBase); reintroduce; overload; virtual; 
    procedure AfterConstruction; override;
  published
    property Id: TGUID read FId write SetId;
  end;

  TMVBListaBase = class(TObjectList)
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Excluir(AItem: TMVBDadosBase);
    procedure Inserir(AItem: TMVBDadosBase);
    function LocalizarIndice(AItem: TMVBDadosBase): Integer;
    function ProcurarItem(AItem: TMVBDadosBase): TMVBDadosBase;
    function ProcurarPorIndice(AIndex: Integer): TMVBDadosBase;
    function ProcurarPorChave(AChave: string): TMVBDadosBase;
    procedure AssignObjects(AListaBase: TMVBListaBase);
  end;

implementation

const
  C_NAO_EXISTE = -1;

  { TMVBDadosBase }

{-----------------------------------------------------------------------------
  Procedure: TMVBDadosBase.AfterConstruction
  Author:    Vinícius
  Date:      11-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBDadosBase.AfterConstruction;
begin
  inherited;
  Self.Clear;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBDadosBase.Assign
  Author:    Vinícius
  Date:      11-jan-2000
  Arguments: Source: TPersistent
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBDadosBase.Assign(ASource: TMVBDadosBase);
begin
  { recupera o identificador }
  FId := TMVBDadosBase(ASource).Id;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBDadosBase.Clear
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBDadosBase.Clear;
begin
  { recupera }
  Self.RecuperarNovoId;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBDadosBase.Create
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

constructor TMVBDadosBase.Create;
begin

end;

{-----------------------------------------------------------------------------
  Procedure: TMVBDadosBase.Destroy
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

destructor TMVBDadosBase.Destroy;
begin
  inherited;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBDadosBase.Equals
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: AItem: TMVBDadosBase
  Result:    Boolean
-----------------------------------------------------------------------------}

function TMVBDadosBase.Equals(AItem: TMVBDadosBase): Boolean;
begin
  { retorna verdadeiro se as chaves forem iguais }
  Result := SameText(Self.GetKey, AItem.GetKey);
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBDadosBase.GetKey
  Author:    Vinícius
  Date:      11-jan-2000
  Arguments: None
  Result:    string
-----------------------------------------------------------------------------}

function TMVBDadosBase.GetKey: string;
begin
  { retorna o identificador }
  Result := GUIDToString(Self.Id);
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBDadosBase.RecuperarNovoId
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: None
  Result:    TGUID
-----------------------------------------------------------------------------}

procedure TMVBDadosBase.RecuperarNovoId;
begin
  { cria um novo identificador }
  CreateGUID(FId);
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBDadosBase.SetId
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: const Value: TGUID
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBDadosBase.SetId(const Value: TGUID);
begin
  FId := Value;
end;

{ TMVBListaBase }

{-----------------------------------------------------------------------------
  Procedure: TMVBListaBase.AssignObjects
  Author:    Vinícius
  Date:      11-jan-2000
  Arguments: AListaBase: TMVBListaBase
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBListaBase.AssignObjects(AListaBase: TMVBListaBase);
var
  LCont: Integer;
  LClass: string;
  LObjeto: TMVBDadosBase;
begin
  { limpa os objetos da lista }
  Self.Clear;
  { percorre todos os elementos da lista }
  for LCont := 0 to AListaBase.Count - 1 do
  begin
    { recupera o nome da classe do objeto }
    LClass := AListaBase.ProcurarPorIndice(LCont).ClassName;
    { cria o objeto }
    LObjeto := TMVBDadosBase(GetClass(LClass).Create);
    { adiciona-o à lista }
    Self.Inserir(LObjeto);
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBListaBase.Create
  Author:    Vinícius
  Date:      15-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

constructor TMVBListaBase.Create;
begin
  { cria lista fazendo preparando para controlar objetos}
  inherited Create(True);
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBListaBase.Destroy
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

destructor TMVBListaBase.Destroy;
begin
  Self.Clear;
  inherited;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBListaBase.Excluir
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: AItem: TMVBDadosBase
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBListaBase.Excluir(AItem: TMVBDadosBase);
var
  LIndex: Integer;
begin
  { procura o índice }
  LIndex := Self.LocalizarIndice(AItem);
  { se for maior que -1 é porque existe }
  if LIndex > C_NAO_EXISTE then
  begin
    { exclui o objeto da lista }
    Delete(LIndex);
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBListaBase.Inserir
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: AItem: TMVBDadosBase
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBListaBase.Inserir(AItem: TMVBDadosBase);
begin
  { insere o objeto na lista }
  Add(AItem);
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBListaBase.LocalizarIndice
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: AItem: TMVBDadosBase
  Result:    Integer
-----------------------------------------------------------------------------}

function TMVBListaBase.LocalizarIndice(AItem: TMVBDadosBase): Integer;
var
  LIndex, LResult: Integer;
  LSair: Boolean;
  LItem: TMVBDadosBase;
begin
  { inicializa busca }
  LResult := C_NAO_EXISTE;
  LIndex := 0;
  LSair := False;
  { procura pelo item }
  while ((LIndex < Self.Count) and not (LSair)) do
  begin
    { recupera o item }
    LItem := Self.ProcurarPorIndice(LIndex);
    { se os objetos forem iguais }
    if AItem.Equals(LItem) then
    begin
      { recupera o resultado }
      LResult := LIndex;
      { informa que é para sair }
      LSair := True;
    end;
    { recupera o próximo objeto da lista }
    Inc(LIndex);
  end;
  { informa o resultado }
  Result := LResult;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBListaBase.ProcurarItem
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: AItem: TMVBDadosBase
  Result:    TMVBDadosBase
-----------------------------------------------------------------------------}

function TMVBListaBase.ProcurarItem(AItem: TMVBDadosBase): TMVBDadosBase;
var
  LResult: TMVBDadosBase;
  LIndex: Integer;
begin
  { inicializa }
  LResult := nil;
  { procura o item }
  LIndex := Self.LocalizarIndice(AItem);
  { se existir }
  if LIndex > C_NAO_EXISTE then
  begin
    LResult := Self.ProcurarPorIndice(LIndex);
  end;
  { informa o resultado }
  Result := LResult;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBListaBase.ProcurarPorChave
  Author:    Vinícius
  Date:      17-jan-2000
  Arguments: AChave: string
  Result:    TMVBDadosBase
-----------------------------------------------------------------------------}

function TMVBListaBase.ProcurarPorChave(AChave: string): TMVBDadosBase;
var
  LIndex: Integer;
  LResult, LItem: TMVBDadosBase;
  LSair: Boolean;
begin
  { inicializa busca }
  LResult := nil;
  LSair := False;
  LIndex := 0;
  { percorre toda a lista }
  while ((LIndex < Self.Count) and not (LSair)) do
  begin
    { recupera o item }
    LItem := Self.ProcurarPorIndice(LIndex);
    { checa as chaves }
    if SameText(LItem.GetKey, Trim(AChave)) then
    begin
      { recupera o resultado }
      LResult := LItem;
      { informa que é para sair }
      LSair := True;
    end;
    { recupera o próximo objeto da lista }
    Inc(LIndex);
  end;
  { informa o resultado }
  Result := LResult;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBListaBase.ProcurarPorIndice
  Author:    Vinícius
  Date:      08-jan-2000
  Arguments: AIndex: Integer
  Result:    TMVBDadosBase
-----------------------------------------------------------------------------}

function TMVBListaBase.ProcurarPorIndice(AIndex: Integer): TMVBDadosBase;
var
  LResult: TMVBDadosBase;
begin
  { inicializa }
  LResult := nil;
  { checa se o índice existe }
  if AIndex < Self.Count then
  begin
    { procura o item }
    LResult := Self.GetItem(AIndex) as TMVBDadosBase;
  end;
  { informa o resultado }
  Result := LResult;
end;

end.

