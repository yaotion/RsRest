unit inputsvrform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,brisdklib;

type
  Tinputsvrd = class(TForm)
    Label1: TLabel;
    ipaddr: TEdit;
    idok: TButton;
    idcancel: TButton;
    Label2: TLabel;
    procedure idcancelClick(Sender: TObject);
    procedure idokClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  inputsvrd: Tinputsvrd;

implementation

{$R *.dfm}

procedure Tinputsvrd.idcancelClick(Sender: TObject);
begin
close();
end;

procedure Tinputsvrd.idokClick(Sender: TObject);
begin
        if QNV_CCCtrl(QNV_CCCTRL_ISLOGON,NULL,0) > 0 then
        begin
	        MessageBox(handle,'已经登陆不能修改服务器地址,请先离线','警告',MB_OK);
                close();
	end
        else
        begin
                if QNV_CCCtrl(QNV_CCCTRL_SETSERVER,PChar(ipaddr.Text),0) <= 0 then
                begin
                        MessageBox(handle,'修改服务器IP地址失败','警告',MB_OK);
                end
		else
                begin
                        MessageBox(handle,'修改服务器IP地址完成,可以重新登陆..','提示',MB_OK);
                end;
        close();
        end;
end;

end.
