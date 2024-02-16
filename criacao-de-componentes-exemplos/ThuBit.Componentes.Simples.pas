unit ThuBit.Componentes.Simples;

interface

uses
  System.Classes;

type

  TDiaSemana = (dsDom, dsSeg, dsTer, dsQua, dsQui, dsSex, dsSab);

  TDiaSemanaSet = set of TDiaSemana;

  TDiaSemanaProc = procedure (Sender: TObject; pDiaSemana: TDiaSemana) of object;


  TThubitSimples = class(TComponent)
  private
    FTexto: string;
    FData: TDate;
    FValor: Double;
    FAtivo: Boolean;
    FDiaPrincipal: TDiaSemana;
    FDiasAtivo: TDiaSemanaSet;
    FOnExecutar: TNotifyEvent;
    FBeforeChangeDia: TDiaSemanaProc;
    FAfterChangeDia: TDiaSemanaProc;
    procedure SetAtivo(const Value: Boolean);
    procedure SetDiaPrincipal(const Value: TDiaSemana);
  published
    property Texto: string read FTexto write FTexto;
    property Data: TDate read FData write FData;
    property Valor: Double read FValor write FValor;
    property Ativo: Boolean read FAtivo write SetAtivo;
    property DiaPrincipal: TDiaSemana read FDiaPrincipal write SetDiaPrincipal;
    property DiasAtivo: TDiaSemanaSet read FDiasAtivo write FDiasAtivo;
    property OnExecutar: TNotifyEvent read FOnExecutar write FOnExecutar;
    property BeforeChangeDia: TDiaSemanaProc read FBeforeChangeDia write FBeforeChangeDia;
    property AfterChangeDia: TDiaSemanaProc read FAfterChangeDia write FAfterChangeDia;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Thubit',[TThubitSimples]);
end;


{ TThubitSimples }

procedure TThubitSimples.SetAtivo(const Value: Boolean);
begin
  FAtivo := Value;
  if FAtivo then
  begin
    if Assigned(FOnExecutar) then
      FOnExecutar(Self);
  end;
end;

procedure TThubitSimples.SetDiaPrincipal(const Value: TDiaSemana);
begin
  if FDiaPrincipal <> Value then
  begin
    if Assigned(FBeforeChangeDia) then
      FBeforeChangeDia(self,FDiaPrincipal);

    FDiaPrincipal := Value;

    if Assigned(FAfterChangeDia) then
      FAfterChangeDia(self,FDiaPrincipal);
  end;
end;

end.
