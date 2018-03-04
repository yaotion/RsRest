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
		MessageBox(handle,'CC号码不能为空','错误',MB_OK);
                Exit;
        end;
	if Pos(cc.text,',') > 0 then // 不能输入','
        begin
	        MessageBox(handle,'CC不能有逗号','错误',MB_OK);
                Exit;
        end;
        if pwd.Text = '' then
        begin
		MessageBox(handle,'密码不能为空','错误',MB_OK);
                Exit;
        end;
	if Pos(pwd.text,',') > 0 then // 不能输入','
        begin
	        MessageBox(handle,'密码不能有逗号','错误',MB_OK);
                Exit;
        end;
        if nick.Text = '' then
        begin
		MessageBox(handle,'昵称不能为空','错误',MB_OK);
                Exit;
        end;
	if Pos(nick.text,',') > 0 then // 不能输入','
        begin
	        MessageBox(handle,'昵称不能有逗号','错误',MB_OK);
                Exit;
        end;
	if Pos(serverid.text,',') > 0 then // 不能输入','
        begin
	        MessageBox(handle,'服务器ID不能有逗号','错误',MB_OK);
                Exit;
        end;

        strValue := cc.Text+','+pwd.Text+','+nick.Text+','+serverid.text;//','分隔
        lRegRet := QNV_CCCtrl(QNV_CCCTRL_REGCC,PChar(strValue),0);
	if  lRegRet<= 0 then //开始注册
        begin
                strRet := '注册失败 错误ID='+inttostr(lRegRet);
		MessageBox(handle,PChar(strRet),'警告',MB_OK);
        end;

        close();
end;

end.
