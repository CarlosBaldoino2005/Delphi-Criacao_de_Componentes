unit ThuBit.Componentes.LegendaGC;

interface
uses
  System.Classes, Vcl.Controls, Vcl.Graphics, Winapi.Messages;

type
  TThubitLegendaGC = class(TGraphicControl)
  protected
    procedure Paint; override;
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
  published
    property Font;
    property Caption;
    property Color;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Thubit', [TThubitLegendaGC]);
end;

{ TThubitLegendaGC }

procedure TThubitLegendaGC.CMTextChanged(var Message: TMessage);
begin
  inherited;
  invalidate;
end;

procedure TThubitLegendaGC.Paint;
var
  lX, lY: Integer;
begin
  inherited;
  Canvas.Brush.Color := Color;
  Canvas.Brush.Style := bsSolid;
  Canvas.Pen.Color := clBlack;
  Canvas.Pen.Style := psSolid;
  Canvas.Pen.Width := 1;
  Canvas.Font := Font;

  Canvas.RoundRect(ClientRect,10,10);

  lX := (Width div 2) - (Canvas.TextExtent(Caption).Width div 2);
  lY := (Height div 2) - (Canvas.TextExtent(Caption).Height div 2);

  Canvas.TextOut(lX, lY, Caption);


end;

end.
