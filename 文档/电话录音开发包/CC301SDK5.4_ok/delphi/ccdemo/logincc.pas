unit logincc;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,brisdklib;

type
  TLoginwin = class(TForm)
    logon: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    cccode: TEdit;
    ccpwd: TEdit;
    idok: TButton;
    idcancel: TButton;
    procedure idcancelClick(Sender: TObject);
    procedure idokClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Loginwin: TLoginwin;

implementation

{$R *.dfm}

procedure TLoginwin.idcancelClick(Sender: TObject);
begin
close();
end;

procedure TLoginwin.idokClick(Sender: TObject);
var
strValue : string;
begin
        if QNV_CCCtrl(QNV_CCCTRL_ISLOGON,NULL,0) > 0 then
        begin
               MessageBox(handle,'已经登陆,请先离线','警告',MB_OK);
        end
        else
        begin
               strValue := cccode.Text+','+ccpwd.Text;//','分隔
               if QNV_CCCtrl(QNV_CCCTRL_LOGIN,PChar(strValue),0) <= 0 then //开始登陆
               begin
               MessageBox(handle,'登陆CC失败','错误',MB_OK);
               end
               else
               close();
        end;
end;

end.
