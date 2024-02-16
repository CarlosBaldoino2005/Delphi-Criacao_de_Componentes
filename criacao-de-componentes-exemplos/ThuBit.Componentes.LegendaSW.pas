unit ThuBit.Componentes.LegendaSW;

interface
uses
  system.Classes, Vcl.Forms, Winapi.Messages, Vcl.Graphics, Winapi.Windows,
  Vcl.Controls;

type

  TLegendaConst = class
  const
    MARGEM_TOP = 6;    // Margem superior da legenda
    LEFT_LEG = 10;     // Posição esquerda do retangulo de cor da legenda
    RIGHT_LEG = 33;    // Posição direita do retangulo de cor da legenda
    HEIGHT_LEG = 13;   // Altura do retangulo de cor da legenda
    LEFT_TEXT = 37;    // Posição esquerda do Texto da legenda
    HEIGHT_LINHA = 18; // Tamanho da altura das linhas
  end;

  TLegendaItem = class(TCollectionItem)
  private
    FColor: TColor;
    FCaption: string;
    procedure SetCaption(const Value: string);
    procedure SetColor(const Value: TColor);
  published
    property Color: TColor read FColor write SetColor;
    property Caption: string read FCaption write SetCaption;
  end;

  TLegendas = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TLegendaItem;
    procedure SetItem(Index: Integer; const Value: TLegendaItem);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    function Add: TLegendaItem;
    property Item[Index: Integer]: TLegendaItem read GetItem write SetItem; default;
  end;

  TThubitLegendaSW = class(TScrollingWinControl)
  private
    FCanvas: TCanvas;
    FLegendas: TLegendas;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMNChitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
  protected
    procedure Paint; virtual;
    procedure PaintWindow(DC: HDC); override;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Legendas: TLegendas read FLegendas write FLegendas;
    property Color;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Thubit',[TThubitLegendaSW]);
end;


{ TThubitLegendaSW }

constructor TThubitLegendaSW.Create(AOwner: TComponent);
begin
  inherited;
  FCanvas := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;
  DoubleBuffered := True;

  FLegendas := TLegendas.Create(Self,TLegendaItem);
end;

procedure TThubitLegendaSW.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.Style := Params.Style + WS_BORDER;
end;

procedure TThubitLegendaSW.Paint;
var
  li, lTop: Integer;
begin
  FCanvas.Brush.Color := Color;
  FCanvas.Brush.Style := bsSolid;
  FCanvas.FillRect(ClientRect);

  for li := 0 to FLegendas.Count - 1 do
  begin
    lTop := TLegendaConst.MARGEM_TOP + (li * TLegendaConst.HEIGHT_LINHA) - VertScrollBar.Position;
    FCanvas.Pen.Color := clBlack;
    FCanvas.Pen.Width := 1;
    FCanvas.Brush.Color := FLegendas[li].Color;
    FCanvas.RoundRect(TLegendaConst.LEFT_LEG, lTop, TLegendaConst.RIGHT_LEG,
                      lTop + TLegendaConst.HEIGHT_LEG, 5, 5);

    FCanvas.Brush.Style := bsClear;
    FCanvas.TextOut(TLegendaConst.LEFT_TEXT, lTop, FLegendas[li].Caption);
  end;

end;

procedure TThubitLegendaSW.PaintWindow(DC: HDC);
begin
  FCanvas.Lock;
  try
    FCanvas.Handle := DC;
    try
      TControlCanvas(FCanvas).UpdateTextFlags;
      Paint;
    finally
      FCanvas.Handle := 0;
    end;
  finally
    FCanvas.Unlock;
  end;
end;

procedure TThubitLegendaSW.WMNChitTest(var Message: TWMNCHitTest);
begin
  DefaultHandler(Message);
end;

procedure TThubitLegendaSW.WMPaint(var Message: TWMPaint);
begin
  ControlState := ControlState + [csCustomPaint];
  inherited;
  ControlState := ControlState - [csCustomPaint];
end;

{ TLegendas }

function TLegendas.Add: TLegendaItem;
begin
  Result := TLegendaItem(inherited Add);
end;

function TLegendas.GetItem(Index: Integer): TLegendaItem;
begin
  Result := TLegendaItem(inherited GetItem(Index));
end;

procedure TLegendas.SetItem(Index: Integer; const Value: TLegendaItem);
begin
  inherited SetItem(Index,Value);
end;

procedure TLegendas.Update(Item: TCollectionItem);
var
  lThubitLegenda: TThubitLegendaSW;
begin
  inherited;
  if Owner is TThubitLegendaSW then
  begin
    lThubitLegenda := TThubitLegendaSW(Owner);
    lThubitLegenda.VertScrollBar.Range :=
      (lThubitLegenda.Legendas.Count * TLegendaConst.HEIGHT_LINHA) + TLegendaConst.MARGEM_TOP;
    lThubitLegenda.Invalidate;
  end;
end;

{ TLegendaItem }

procedure TLegendaItem.SetCaption(const Value: string);
begin
  FCaption := Value;
  Changed(False);
end;

procedure TLegendaItem.SetColor(const Value: TColor);
begin
  FColor := Value;
  Changed(False);
end;

end.
