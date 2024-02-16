unit ThuBit.Componentes.Relogio;

interface

uses
  Vcl.ExtCtrls, System.Classes, System.SysUtils;

type
  TDespertadorProc = procedure(Sender: TObject; pHorario: TTime) of object;

  TThubitHorarioItem = class(TCollectionItem)
  private
    FHorario: TTime;
    FActive: Boolean;
  protected
      function GetDisplayName: string; override;
  published
    property Active: Boolean read FActive write FActive;
    property Horario: TTime read FHorario write FHorario;
  end;

  TThubitHorarioCollection = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TThubitHorarioItem;
    procedure SetItem(Index: Integer; const Value: TThubitHorarioItem);
  public
    function Add: TThubitHorarioItem;
    property Items[Index: Integer]: TThubitHorarioItem read GetItem write SetItem; default;
  end;


  TThubitRelogio = class(TCustomPanel)
    FTimer: TTimer;
  private
    FDateTimeFormat: string;
    FOnTimer: TNotifyEvent;
    FValue: TDateTime;
    FHorarios: TThubitHorarioCollection;
    FOnDespertador: TDespertadorProc;
    procedure SetActive(const Value: boolean);
    function GetActive: boolean;
    procedure FTimerOnTimer(Sender: TObject);
    procedure SetDateTimeFormat(const Value: string);
    procedure AtualizarDataHora;
    function GetDateTime: TDateTime;
    procedure VerificarHorarios;
  public
    constructor Create(AOwner: TComponent); override;
    property DateTime: TDateTime read GetDateTime;
  published
    property Active: boolean read GetActive write SetActive;
    property DateTimeFormat: string read FDateTimeFormat write SetDateTimeFormat;
    property Horarios: TThubitHorarioCollection read FHorarios write FHorarios;
    property OnTimer: TNotifyEvent read FOnTimer write FOnTimer;
    property OnDespertador: TDespertadorProc read FOnDespertador write FOnDespertador;
    property Font;
  end;


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Thubit',[TThubitRelogio]);
end;


{ TThubitRelogio }

procedure TThubitRelogio.AtualizarDataHora;
begin
  FValue := Now;
  Caption := FormatDateTime(FDateTimeFormat,FValue);
end;

constructor TThubitRelogio.Create(AOwner: TComponent);
begin
  inherited;
  FTimer := TTimer.Create(Self);
  FTimer.OnTimer := FTimerOnTimer;
  FTimer.Enabled := False;

  FHorarios := TThubitHorarioCollection.Create(Self,TThubitHorarioItem);

  FDateTimeFormat := FormatSettings.ShortDateFormat+' '+FormatSettings.ShortTimeFormat;

  AtualizarDataHora;
end;

procedure TThubitRelogio.VerificarHorarios;
var
  li: Integer;
begin
  for li := 0 to FHorarios.Count - 1 do
  begin
    if FHorarios[li].Active and (FormatDateTime('hh:nn:ss', FHorarios[li].Horario) = FormatDateTime('hh:nn:ss', FValue)) then
    begin
      if Assigned(FOnDespertador) then
        FOnDespertador(Self, FValue);
    end;
  end;
end;

procedure TThubitRelogio.FTimerOnTimer(Sender: TObject);
begin
  if not (csDesigning in ComponentState) then
  begin
    AtualizarDataHora;
    VerificarHorarios;
  end;

  if Assigned(FOnTimer) then
    FOnTimer(sender);
end;

function TThubitRelogio.GetActive: boolean;
begin
  Result := FTimer.Enabled;
end;

function TThubitRelogio.GetDateTime: TDateTime;
begin
  Result := FValue;
end;

procedure TThubitRelogio.SetActive(const Value: boolean);
begin
  FTimer.Enabled := Value;
end;

procedure TThubitRelogio.SetDateTimeFormat(const Value: string);
begin
  FDateTimeFormat := Value;
  AtualizarDataHora;
end;

{ TThubitHorarioCollection }

function TThubitHorarioCollection.Add: TThubitHorarioItem;
begin
  Result := TThubitHorarioItem(inherited Add);
end;

function TThubitHorarioCollection.GetItem(Index: Integer): TThubitHorarioItem;
begin
  Result := TThubitHorarioItem(inherited GetItem(Index));
end;

procedure TThubitHorarioCollection.SetItem(Index: Integer;
  const Value: TThubitHorarioItem);
begin
  inherited SetItem(Index, Value);
end;

{ TThubitHorarioItem }

function TThubitHorarioItem.GetDisplayName: string;
begin
  if FActive then
    Result := FormatDateTime(FormatSettings.ShortTimeFormat,FHorario)+' (On)'
  else
    Result := FormatDateTime(FormatSettings.ShortTimeFormat,FHorario)+' (Off)';
end;

end.
