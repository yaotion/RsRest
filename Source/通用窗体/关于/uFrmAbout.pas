unit uFrmAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ActnList, RzStatus;

type
  TfrmAbout = class(TForm)
    Image1: TImage;
    lblVersion: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    btnClose: TSpeedButton;
    ActionList1: TActionList;
    actEsc: TAction;
    RzVersionInfo1: TRzVersionInfo;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure actEscExecute(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

uses
  ufrmQuestionBox,ufrmTextInput ;

{$R *.dfm}
//获取版本号
function GetBuildInfo: string;
var
  verinfosize : DWORD;
  verinfo : pointer;
  vervaluesize : dword;
  vervalue : pvsfixedfileinfo;
  dummy : dword;
  v1,v2,v3,v4 : word;
begin
  verinfosize := getfileversioninfosize(pchar(paramstr(0)),dummy);
  if verinfosize = 0 then
  begin
    dummy := getlasterror;
    result := '0.0.0.0';
  end;
  getmem(verinfo,verinfosize);
  getfileversioninfo(pchar(paramstr(0)),0,verinfosize,verinfo);
  verqueryvalue(verinfo,'\',pointer(vervalue),vervaluesize);
  with vervalue^ do
  begin
    v1 := dwfileversionms shr 16;
    v2 := dwfileversionms and $ffff;
    v3 := dwfileversionls shr 16;
    v4 := dwfileversionls and $ffff;
  end;
  result := inttostr(v1) + '.' + inttostr(v2) + '.' + inttostr(v3) + '.' + inttostr(v4);
  freemem(verinfo,verinfosize);
end;
procedure TfrmAbout.actEscExecute(Sender: TObject);
begin
  btnClose.Click;
end;

procedure TfrmAbout.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  lblVersion.Caption := Format('版本号：%s',[GetBuildInfo]);
end;

procedure TfrmAbout.Image1DblClick(Sender: TObject);
const
  PASS_WORD:string = 'thinkfreely';
var
  strPassWord:string;
begin
  if not TextInput('提示','请输入密码',strPassWord) then
  begin
    exit ;
  end;

  if Trim(strPassWord) = '' then
  begin
    Exit;
  end;
 

  if not tfMessageBox('确定清空数据库吗') then
  begin
    exit ;
  end;
  
end;

end.
