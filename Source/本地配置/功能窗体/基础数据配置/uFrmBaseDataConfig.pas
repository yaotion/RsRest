unit uFrmBaseDataConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, RzPanel, StdCtrls,uFrmJWDMgr,uFrmWorkShopMgr,
  uFrmTrainJiaoLuMgr,uFrmSiteMgr,uFrmDutyUserMgr;

type
  TClsForm = class of TForm;
  TFrmBaseDataConfig = class(TForm)
    pnl1: TRzPanel;
    pnl2: TRzPanel;
    tv1: TTreeView;
    pgc1: TPageControl;
    procedure FormShow(Sender: TObject);
    procedure tv1Click(Sender: TObject);
  private
    //初始化功能
    procedure InitSubForms();
    //增加功能窗体
    procedure AddConfigPage(caption:string;clsObj:TClsForm);
  public
    class procedure Show();
  end;


implementation

{$R *.dfm}

{ TFrmBaseDataConfig }

procedure TFrmBaseDataConfig.AddConfigPage(caption:string;clsObj:TClsForm);
var
  pgSheet:TTabSheet;
  frm:TForm;
begin
  pgSheet := TTabSheet.Create(pgc1);
  pgSheet.PageControl := pgc1;
  pgSheet.TabVisible := False;
  frm := clsObj.Create(pgSheet);
  frm.BorderStyle := bsNone;
  frm.Align := alClient;
  tv1.Items.AddChild(nil,caption);
  frm.Parent := pgSheet;
  frm.Show;


end;

procedure TFrmBaseDataConfig.FormShow(Sender: TObject);
begin
  InitSubForms();
  pgc1.ActivePageIndex := 0;
end;

procedure TFrmBaseDataConfig.InitSubForms;
begin
  AddConfigPage('公寓',TFrmJWDMgr);
  AddConfigPage('机务段',TFrmWorkShopMgr);
  AddConfigPage('行车交路',TFrmTrainJiaoLuMgr);
  AddConfigPage('客户端',TFrmSiteMgr);
  AddConfigPage('管理员',TFrmDutyUserMgr);

  pgc1.ActivePageIndex := 0;
  tv1.Items[0].Selected := True;

end;

class procedure TFrmBaseDataConfig.Show;
var
  Frm: TFrmBaseDataConfig;
begin
  Frm:= TFrmBaseDataConfig.Create(nil);
  try
    Frm.ShowModal;
  finally
    Frm.Free;
  end;
end;

procedure TFrmBaseDataConfig.tv1Click(Sender: TObject);
begin
  pgc1.ActivePageIndex := tv1.Selected.Index;
  TForm(pgc1.ActivePage.Components[0]).Show;
  TForm(pgc1.ActivePage.Components[0]).OnShow(nil);
end;

end.
