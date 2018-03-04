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
	        MessageBox(handle,'�Ѿ���½�����޸ķ�������ַ,��������','����',MB_OK);
                close();
	end
        else
        begin
                if QNV_CCCtrl(QNV_CCCTRL_SETSERVER,PChar(ipaddr.Text),0) <= 0 then
                begin
                        MessageBox(handle,'�޸ķ�����IP��ַʧ��','����',MB_OK);
                end
		else
                begin
                        MessageBox(handle,'�޸ķ�����IP��ַ���,�������µ�½..','��ʾ',MB_OK);
                end;
        close();
        end;
end;

end.
