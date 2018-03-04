unit uDrawMenu;

interface

uses
  Graphics,windows,Menus,StrUtils;

const
  MENU_ITEM_SEPARATOR :string = '-' ;
const
    MENU_ITEM_WIDTH  : integer = 220 ;    //菜单宽度
    MENU_ITEM_HEIGHT : integer = 35 ;     //菜单高度

type

  TDrawMenu = class
  public
    procedure DrawMenus(Menu:TMainMenu);overload;
    procedure DrawMenus(Menu:TPopupMenu);overload;
  private
    procedure SetMenuDrawEvent(Menu:TMenuItem);

    procedure DrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect;
      Selected: Boolean);
    procedure MeasureItem(Sender: TObject; ACanvas: TCanvas; var Width,
      Height: Integer);
  end;


implementation

{ TDrawMenu }

procedure TDrawMenu.DrawItem(Sender: TObject; ACanvas: TCanvas;
  ARect: TRect; Selected: Boolean);
var
  Item: TMenuItem;
  nWidth : integer ;
begin
  Item := TMenuItem(Sender);
  windows.OutputDebugString(PAnsiChar(item.Caption));
  //ACanvas.Brush.Color := clMenuBar ;
  ACanvas.FillRect(ARect);

  ACanvas.Font.Color := clBlack ;
  ACanvas.Font.Name:= '微软雅黑';
  ACanvas.Font.Size := 14;
  if Item.Checked then
    ACanvas.TextOut(ARect.Left + 12, ARect.Top + 5, '√');
  if item.Caption = MENU_ITEM_SEPARATOR  then
  begin
    nWidth :=   ( ARect.Bottom - ARect.Top )  div 2  ;
    ACanvas.MoveTo(ARect.Left, ARect.Top + nWidth );
    acanvas.LineTo(ARect.Right,ARect.Top + nWidth  );
  end
  else
    ACanvas.TextOut(ARect.Left + 32, ARect.Top + 6, Item.Caption);
end;

procedure TDrawMenu.SetMenuDrawEvent(Menu: TMenuItem);
begin
  Menu.OnDrawItem := DrawItem ;
  Menu.OnMeasureItem := MeasureItem ;
end;

procedure TDrawMenu.DrawMenus(Menu: TMainMenu);
var
  i : integer ;
begin
  exit ;
  Menu.OwnerDraw := true ;
  for I := 0 to Menu.Items.Count - 1 do
  begin
    SetMenuDrawEvent(menu.Items.Items[i]);
  end;

end;

procedure TDrawMenu.DrawMenus(Menu: TPopupMenu);
var
  i : integer ;
begin
  Menu.OwnerDraw := true ;
  for I := 0 to Menu.Items.Count - 1 do
  begin
    SetMenuDrawEvent(menu.Items.Items[i]);
  end;
end;

procedure TDrawMenu.MeasureItem(Sender: TObject; ACanvas: TCanvas;
  var Width, Height: Integer);
var
  Item: TMenuItem;
begin
  Item := TMenuItem(Sender);
  if Item.Caption <>  MENU_ITEM_SEPARATOR then
  begin
    Width := MENU_ITEM_WIDTH;
    Height := MENU_ITEM_HEIGHT;
  end;
end;

end.
