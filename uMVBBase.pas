{-----------------------------------------------------------------------------
 Unit Name: uMVBBase
 Author:    Vinícius
 Purpose:
 History:
-----------------------------------------------------------------------------}

unit uMVBBase;

interface

uses
  { borland }
  Classes,
  { mvb }
  uMVBConsts;

type
  { string }
  TMVBString = class(TObject)
  private
    FValue: string;
    FOldValue: string;
    procedure SetValue(const Value: string);
  public
    function IsNull: Boolean;
    function GetNullValue: string;
    procedure Clear; virtual;
    { propriedades }
    property OldValue: string read FOldValue;
  published
    property Value: string read FValue write SetValue;
  end;

  { inteiro }
  TMVBInteger = class(TObject)
  private
    FValue: Integer;
    FOldValue: Integer;
    procedure SetValue(const Value: Integer);
  public
    function IsNull: Boolean;
    function GetNullValue: Integer;
    procedure Clear; virtual;
    { propriedades }
    property OldValue: Integer read FOldValue;
  published
    property Value: Integer read FValue write SetValue;
  end;

  { ponto flutuante }
  TMVBDouble = class(TObject)
  private
    FValue: Double;
    FOldValue: Double;
    procedure SetValue(const Value: Double);
  public
    function IsNull: Boolean;
    function GetNullValue: Double;
    procedure Clear; virtual;
    { propriedades }
    property OldValue: Double read FOldValue;
  published
    property Value: Double read FValue write SetValue;
  end;

  { Data e hora  }
  TMVBDateTime = class(TObject)
  private
    FValue: TDateTime;
    FOldValue: TDateTime;
    procedure SetValue(const Value: TDateTime);
  public
    function IsNull: Boolean;
    function GetNullValue: TDateTime;
    procedure Clear; virtual;
    { propriedades }
    property OldValue: TDateTime read FOldValue;
  published
    property Value: TDateTime read FValue write SetValue;
  end;

  { Boleano  }
  TMVBBoolean = class(TObject)
  private
    FValue: Boolean;
    FOldValue: Boolean;
    procedure SetValue(const Value: Boolean);
  public
    procedure Clear; virtual;
    { propriedades }
    property OldValue: Boolean read FOldValue;
  published
    property Value: Boolean read FValue write SetValue;
  end;

implementation

uses SysUtils;

  { TMVBString }

{-----------------------------------------------------------------------------
  Procedure: TMVBString.Clear
  Author:    Vinícius
  Date:      11-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBString.Clear;
begin
  { recupera o valor nulo para a propriedade }
  FValue := Self.GetNullValue;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBString.GetNullValue
  Author:    Vinícius
  Date:      11-jan-2000
  Arguments: None
  Result:    string
-----------------------------------------------------------------------------}

function TMVBString.GetNullValue: string;
begin
  { retorna o valor da string nula }
  Result := C_STRING_NULL;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBString.IsNull
  Author:    Vinícius
  Date:      11-jan-2000
  Arguments: None
  Result:    Boolean
-----------------------------------------------------------------------------}

function TMVBString.IsNull: Boolean;
begin
  { checa se o valor é nulo }
  Result := (FValue = Self.GetNullValue);
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBString.SetValue
  Author:    Vinícius
  Date:      11-jan-2000
  Arguments: const Value: string
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBString.SetValue(const Value: string);
begin
  { garda o valor antigo }
  FOldValue := FValue;
  { recupera o novo valor }
  FValue := Value;
end;

{ TMVBInteger }

{-----------------------------------------------------------------------------
  Procedure: TMVBInteger.Clear
  Author:    Vinícius
  Date:      11-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBInteger.Clear;
begin
  { recupera o valor nulo para a propriedade }
  FValue := Self.GetNullValue;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBInteger.GetNullValue
  Author:    Vinícius
  Date:      11-jan-2000
  Arguments: None
  Result:    Integer
-----------------------------------------------------------------------------}

function TMVBInteger.GetNullValue: Integer;
begin
  Result := C_INTEGER_NULL;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBInteger.IsNull
  Author:    Vinícius
  Date:      11-jan-2000
  Arguments: None
  Result:    Boolean
-----------------------------------------------------------------------------}

function TMVBInteger.IsNull: Boolean;
begin
  { checa se o valor é nulo }
  Result := (FValue = Self.GetNullValue);
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBInteger.SetValue
  Author:    Vinícius
  Date:      11-jan-2000
  Arguments: const Value: Integer
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBInteger.SetValue(const Value: Integer);
begin
  { garda o valor antigo }
  FOldValue := FValue;
  { recupera o novo valor }
  FValue := Value;
end;

{ TMVBDouble }

{-----------------------------------------------------------------------------
  Procedure: TMVBDouble.Clear
  Author:    Vinícius
  Date:      11-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBDouble.Clear;
begin
  { recupera o valor nulo para a propriedade }
  FValue := Self.GetNullValue;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBDouble.GetNullValue
  Author:    Vinícius
  Date:      11-jan-2000
  Arguments: None
  Result:    Double
-----------------------------------------------------------------------------}

function TMVBDouble.GetNullValue: Double;
begin
  Result := C_DOUBLE_NULL;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBDouble.IsNull
  Author:    Vinícius
  Date:      11-jan-2000
  Arguments: None
  Result:    Boolean
-----------------------------------------------------------------------------}

function TMVBDouble.IsNull: Boolean;
begin
  { checa se o valor é nulo }
  Result := (FValue = Self.GetNullValue);
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBDouble.SetValue
  Author:    Vinícius
  Date:      11-jan-2000
  Arguments: const Value: Double
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBDouble.SetValue(const Value: Double);
begin
  { garda o valor antigo }
  FOldValue := FValue;
  { recupera o novo valor }
  FValue := Value;
end;

{ TMVBDateTime }

{-----------------------------------------------------------------------------
  Procedure: TMVBDateTime.Clear
  Author:    Vinícius
  Date:      11-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBDateTime.Clear;
begin
  { recupera o valor nulo para a propriedade }
  FValue := Self.GetNullValue;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBDateTime.GetNullValue
  Author:    Vinícius
  Date:      11-jan-2000
  Arguments: None
  Result:    TDateTime
-----------------------------------------------------------------------------}

function TMVBDateTime.GetNullValue: TDateTime;
begin
  Result := C_DATE_TIME_NULL;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBDateTime.IsNull
  Author:    Vinícius
  Date:      11-jan-2000
  Arguments: None
  Result:    Boolean
-----------------------------------------------------------------------------}

function TMVBDateTime.IsNull: Boolean;
begin
  { checa se o valor é nulo }
  Result := (FValue = Self.GetNullValue);
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBDateTime.SetValue
  Author:    Vinícius
  Date:      11-jan-2000
  Arguments: const Value: TDateTime
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBDateTime.SetValue(const Value: TDateTime);
begin
  { garda o valor antigo }
  FOldValue := FValue;
  { recupera o novo valor }
  FValue := Value;
end;

{ TMVBBoolean }

{-----------------------------------------------------------------------------
  Procedure: TMVBBoolean.Clear
  Author:    Vinícius
  Date:      11-jan-2000
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBBoolean.Clear;
begin
  FValue := False;
end;

{-----------------------------------------------------------------------------
  Procedure: TMVBBoolean.SetValue
  Author:    Vinícius
  Date:      11-jan-2000
  Arguments: const Value: Boolean
  Result:    None
-----------------------------------------------------------------------------}

procedure TMVBBoolean.SetValue(const Value: Boolean);
begin
  { garda o valor antigo }
  FOldValue := FValue;
  { recupera o novo valor }
  FValue := Value;
end;

end.

