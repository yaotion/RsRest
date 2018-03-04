unit utfPopBox;

interface
uses
  Forms,Messages,Windows,Types,Graphics,Controls,Classes,Contnrs,utfPopTypes,
  StdCtrls, ExtCtrls,  RzPanel, RzLstBox, Buttons;
type
  //////////////////////////////////////////////////////////////////////////////
  /// TtfPopupWindow无焦点窗体
  //////////////////////////////////////////////////////////////////////////////
  TtfPopBox = class(TForm)
    Timer1: TTimer;
    lblMsg1: TLabel;
    lblClose: TLabel;
    lblMsg2: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lblCloseMouseEnter(Sender: TObject);
    procedure lblCloseMouseLeave(Sender: TObject);
    procedure lblCloseClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  protected
    //失去焦点时关闭
    procedure Deactivate; override;

  private
    //失去焦点的消息
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
    //获取或者失去焦点的消息
    procedure WMMOUSEACTIVATE(var Message : TWMMOUSEACTIVATE ); message WM_MOUSEACTIVATE;
    procedure ReLocateMsgLabel(lbl: TLabel);
  public
    class procedure ShowBox(Msg : string; ShowTime : Cardinal = 2000);overload;
    class procedure ShowBox(Msg1,Msg2 : string; ShowTime : Cardinal = 2000);overload;
  end;
implementation
uses
  SysUtils;
{ TtfPopupWindow }
{$R *.dfm}


constructor TtfPopBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  BorderStyle := bsNone;
  {$IFDEF VCL}
  DefaultMonitor := dmDesktop;
  {$ENDIF}
  FormStyle := fsStayOnTop;

end;

procedure TtfPopBox.Deactivate;
begin
  inherited;
end;

destructor TtfPopBox.Destroy;
begin
  //实际显示的数据木
  inherited;
end;


procedure TtfPopBox.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TtfPopBox.lblCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TtfPopBox.lblCloseMouseEnter(Sender: TObject);
begin
  lblClose.Font.Style := [fsUnderline]
end;

procedure TtfPopBox.lblCloseMouseLeave(Sender: TObject);
begin
  lblClose.Font.Style := []
end;

procedure TtfPopBox.ReLocateMsgLabel(lbl: TLabel);
var
  nWidth: Integer;
begin
  nWidth := lbl.Canvas.TextWidth(lbl.Caption);


  lbl.Left := (Self.Width - nWidth) div 2;

  if lbl.Left < 10 then
    lbl.Left := 10;
end;

class procedure TtfPopBox.ShowBox(Msg1, Msg2: string; ShowTime: Cardinal);
var
  popBox : TtfPopBox;
begin
  popBox := TtfPopBox.Create(nil);
  popBox.lblMsg1.Caption := Msg1;
  popBox.lblMsg2.Caption := Msg2;
  popBox.Timer1.Interval := ShowTime;
  popBox.ReLocateMsgLabel(popBox.lblMsg1);
  popBox.ReLocateMsgLabel(popBox.lblMsg2);

  SetWindowPos(popBox.Handle, HWND_TOPMOST,Round(Screen.Width / 2) - Round(popBox.Width / 2),
    Round(Screen.Height / 2) - Round(popBox.Height / 2),popBox.Width,popBox.Height,
          SWP_NOACTIVATE  or SWP_NOSIZE or SWP_SHOWWINDOW);
  popBox.Timer1.Enabled := ShowTime <> 0;
  popBox.lblClose.Visible := not popBox.Timer1.Enabled;
  Application.ProcessMessages;
end;
class procedure TtfPopBox.ShowBox(Msg: string; ShowTime: Cardinal);
begin
  ShowBox(Msg,'',ShowTime);
end;

procedure TtfPopBox.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := false;
  Close;
end;

procedure TtfPopBox.WMActivate(var Message: TWMActivate);
begin

end;

procedure TtfPopBox.WMMOUSEACTIVATE(var Message: TWMMOUSEACTIVATE);
begin
 Message.result := MA_NOActivate;
end;

end.