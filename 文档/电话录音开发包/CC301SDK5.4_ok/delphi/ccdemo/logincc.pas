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
               MessageBox(handle,'�Ѿ���½,��������','����',MB_OK);
        end
        else
        begin
               strValue := cccode.Text+','+ccpwd.Text;//','�ָ�
               if QNV_CCCtrl(QNV_CCCTRL_LOGIN,PChar(strValue),0) <= 0 then //��ʼ��½
               begin
               MessageBox(handle,'��½CCʧ��','����',MB_OK);
               end
               else
               close();
        end;
end;

end.
