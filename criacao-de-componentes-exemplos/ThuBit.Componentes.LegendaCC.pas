unit ThuBit.Componentes.LegendaCC;

interface
uses
  System.Classes, Vcl.Controls, Vcl.Graphics, Winapi.Messages;

type
  TThubitLegendaCC = class(TCustomControl)
  private
    FFontFocus: TFont;
    FColorFocus: TColor;
    procedure SetFontFocus(const Value: TFont);
    procedure SetColorFocus(const Value: TColor);
  protected
    procedure Paint; override;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
    procedure CMFocusChanged(var Message: TMessage); message CM_FOCUSCHANGED;
    procedure Click; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Font;
    property Caption;
    property Color;
    property TabOrder;
    property TabStop;
    property FontFocus: TFont read FFontFocus write SetFontFocus;
    property ColorFocus: TColor read FColorFocus write SetColorFocus;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Thubit', [TThubitLegendaCC]);
end;

{ TThubitLegendaCC }

procedure TThubitLegendaCC.Click;
begin
  inherited;
  SetFocus;
end;

procedure TThubitLegendaCC.CMFocusChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TThubitLegendaCC.CMTextChanged(var Message: TMessage);
begin
  inherited;
  invalidate;
end;

constructor TThubitLegendaCC.Create(AOwner: TComponent);
begin
  inherited;
  TabStop := True;
  FFontFocus := TFont.Create;
  ControlStyle := ControlStyle + [csAcceptsControls];
end;

destructor TThubitLegendaCC.Destroy;
begin
  FFontFocus.Free;
  inherited;
end;

procedure TThubitLegendaCC.Paint;
var
  lX, lY: Integer;
begin
  inherited;

  Canvas.Pen.Color := clBlack;
  Canvas.Pen.Style := psSolid;
  Canvas.Pen.Width := 1;

  if Focused then
  begin
    Canvas.Brush.Color := FColorFocus;
    Canvas.Brush.Style := bsSolid;
    Canvas.Font := FFontFocus;
  end else begin
    Canvas.Brush.Color := Color;
    Canvas.Brush.Style := bsSolid;
    Canvas.Font := Font;
  end;

  Canvas.RoundRect(ClientRect,10,10);

  lX := (Width div 2) - (Canvas.TextExtent(Caption).Width div 2);
  lY := (Height div 2) - (Canvas.TextExtent(Caption).Height div 2);

  Canvas.TextOut(lX, lY, Caption);


end;

procedure TThubitLegendaCC.SetColorFocus(const Value: TColor);
begin
  FColorFocus := Value;
  Invalidate;
end;

procedure TThubitLegendaCC.SetFontFocus(const Value: TFont);
begin
  FFontFocus.Assign(Value);
  Invalidate;
end;

end.
