unit ccctrl;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus,brisdklib;

type
  TForm1 = class(TForm)
    lbmsg: TListBox;
    close: TButton;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    logoncc: TMenuItem;
    offline: TMenuItem;
    regcc: TMenuItem;
    ccmsg: TMenuItem;
    cccmd: TMenuItem;
    cccall: TMenuItem;
    sendppfile: TMenuItem;
    setserveraddr: TMenuItem;
    procedure ShowMsg(const msg : WideString);
    procedure logonccClick(Sender: TObject);
    procedure closeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MyMsgProc(var Msg:TMessage); message BRI_EVENT_MESSAGE;
    procedure offlineClick(Sender: TObject);
    procedure regccClick(Sender: TObject);
    procedure ccmsgClick(Sender: TObject);
    procedure cccmdClick(Sender: TObject);
    procedure cccallClick(Sender: TObject);
    procedure setserveraddrClick(Sender: TObject);
    procedure sendppfileClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses logincc,
     msgform,
     regccform,
     cmdform, callform, inputsvrform, filetransform, inputccform,
  sendfileform;

{$R *.dfm}


procedure TForm1.ShowMsg(const msg : WideString);
begin
  lbMsg.Items.Append(msg);
  lbMsg.Selected[lbMsg.Items.Count-1]:=true;//选择显示最后一个状态
end;

procedure TForm1.logonccClick(Sender: TObject);
begin
        loginwin.ShowModal();
end;

procedure TForm1.MyMsgProc(var Msg:TMessage);
var
 pEvent:PTBriEvent_Data;
 strData:string;
begin
 pEvent := PTBriEvent_Data(Msg.LParam);
 case pEvent^.lEventType of
        BriEvent_CC_ConnectFailed:
        begin
        ShowMsg('连接服务器失败');
        end;
        BriEvent_CC_LoginFailed:
        begin
        ShowMsg('登陆失败 原因='+inttostr(pEvent^.lResult));
        end;
        BriEvent_CC_LoginSuccess:
        begin
        ShowMsg('登陆成功');
        filetransd.InitForm();
        ccmsgd.InitForm();
        cccmdd.InitForm();
        cccalld.InitForm();
        end;
        BriEvent_CC_SystemTimeErr:
        begin
        ShowMsg('本地系统时间错误');
        end;
        BriEvent_CC_CallIn:
        begin
        ShowMsg('CC语音呼入请求');
        end;
        BriEvent_CC_CallOutSuccess:
        begin
        ShowMsg ('CC语音正在呼出');
        end;
        BriEvent_CC_CallOutFailed:
        begin
        ShowMsg ('CC语音呼出失败');
        end;
        BriEvent_CC_ReplyBusy:
        begin
        ShowMsg ('CC对方回复忙')
        end;
        BriEvent_CC_Connected:
        begin
        ShowMsg ('CC语音已经连通');
        end;
        BriEvent_CC_CallFinished:
        begin
        ShowMsg ('CC语音呼叫结束');
        end;
        BriEvent_CC_RecvedMsg:
        begin
        ShowMsg('接收到消息');
        end;
        BriEvent_CC_RecvedCmd:
        begin
        ShowMsg('接收到命令');
        end;
        BriEvent_CC_RecvFileRequest:
        begin
        ShowMsg('接收到文件请求');
        end;
        BriEvent_CC_TransFileFinished:
        begin
        ShowMsg('传输文件结束');
        end;
        BriEvent_CC_RegSuccess:
        begin
        ShowMsg('注册CC成功');
        end;
        BriEvent_CC_RegFailed:
        begin
        ShowMsg('注册CC失败');
        end;
        BriEvent_CC_ContactUpdateStatus:
        begin
        strData:=stringreplace(pEvent^.szData,MSG_KEY_SPLIT,' ',[rfReplaceAll]);//list 不能显示换行,用空格代替显示
        ShowMsg('获取到用户状态: '+strData);
        end;
        else
        begin
        ShowMsg('其它消息 id='+inttostr(pEvent^.lEventType));
        end;
 end;//end case
end;

procedure TForm1.closeClick(Sender: TObject);
begin
ShowMsg('退出');
PostMessage(Handle,WM_CLOSE,0,0);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
lRegResult: longint;
begin
        if QNV_OpenDevice(ODT_CC,0,QNV_CC_LICENSE) <= 0 then//加载CC模块
        begin
		ShowMsg('加载CC模块失败');
        end
	else
        begin
		//注册本窗口接收CC模块的事件
                lRegResult:=QNV_Event(CCCTRL_CHANNELID,QNV_EVENT_REGWND,integer(handle),NULL,NULL,0);
		if lRegResult <= 0 then
                begin
                        ShowMsg('注册窗口失败');
                end
                else
                        begin
		        ShowMsg('加载CC模块完成');
                        end
	end

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	QNV_CCCtrl(QNV_CCCTRL_LOGOUT,NULL,0);//离线
	QNV_CloseDevice(ODT_CC,0);//关闭CC模块
end;

procedure TForm1.offlineClick(Sender: TObject);
begin
        QNV_CCCtrl(QNV_CCCTRL_LOGOUT,NULL,0);
        ShowMsg('离线');
end;

procedure TForm1.regccClick(Sender: TObject);
begin
        regccd.ShowModal();
end;

procedure TForm1.ccmsgClick(Sender: TObject);
begin
        ccmsgd.show();
end;

procedure TForm1.cccmdClick(Sender: TObject);
begin
        cccmdd.show();
end;

procedure TForm1.cccallClick(Sender: TObject);
begin
        inputccd.ShowModal();
        if inputccd.destcc.Text <> '' then
        begin
        cccalld.show();
        cccalld.CallCC(inputccd.destcc.Text);
        end;
end;

procedure TForm1.setserveraddrClick(Sender: TObject);
begin
        inputsvrd.showmodal();
end;

procedure TForm1.sendppfileClick(Sender: TObject);
begin
        sendfiled.ShowModal();
        if ((sendfiled.destcc.text <> '') AND (sendfiled.transfile.text <> '')) then
        begin
        //先注册文件传输组件 regsvr32 qnvfiletrans.dll
        filetransd.show();
        filetransd.StartSendFile(sendfiled.destcc.text,sendfiled.transfile.text);
        end;
end;

end.
