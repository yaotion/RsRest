unit regccform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,brisdklib;

type
  Tregccd = class(TForm)
    recbox: TGroupBox;
    cccode: TLabel;
    cc: TEdit;
    Label1: TLabel;
    pwd: TEdit;
    Label2: TLabel;
    nick: TEdit;
    Label3: TLabel;
    serverid: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    regcc: TButton;
    idcancel: TButton;
    procedure idcancelClick(Sender: TObject);
    procedure regccClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  regccd: Tregccd;

implementation

{$R *.dfm}

procedure Tregccd.idcancelClick(Sender: TObject);
begin
close();
end;

procedure Tregccd.regccClick(Sender: TObject);
var
strValue : string;
strRet : string;
lRegRet :longint;
begin
        if cc.Text = '' then
        begin
		MessageBox(handle,'CC���벻��Ϊ��','����',MB_OK);
                Exit;
        end;
	if Pos(cc.text,',') > 0 then // ��������','
        begin
	        MessageBox(handle,'CC�����ж���','����',MB_OK);
                Exit;
        end;
        if pwd.Text = '' then
        begin
		MessageBox(handle,'���벻��Ϊ��','����',MB_OK);
                Exit;
        end;
	if Pos(pwd.text,',') > 0 then // ��������','
        begin
	        MessageBox(handle,'���벻���ж���','����',MB_OK);
                Exit;
        end;
        if nick.Text = '' then
        begin
		MessageBox(handle,'�ǳƲ���Ϊ��','����',MB_OK);
                Exit;
        end;
	if Pos(nick.text,',') > 0 then // ��������','
        begin
	        MessageBox(handle,'�ǳƲ����ж���','����',MB_OK);
                Exit;
        end;
	if Pos(serverid.text,',') > 0 then // ��������','
        begin
	        MessageBox(handle,'������ID�����ж���','����',MB_OK);
                Exit;
        end;

        strValue := cc.Text+','+pwd.Text+','+nick.Text+','+serverid.text;//','�ָ�
        lRegRet := QNV_CCCtrl(QNV_CCCTRL_REGCC,PChar(strValue),0);
	if  lRegRet<= 0 then //��ʼע��
        begin
                strRet := 'ע��ʧ�� ����ID='+inttostr(lRegRet);
		MessageBox(handle,PChar(strRet),'����',MB_OK);
        end;

        close();
end;

end.
