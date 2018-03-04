unit pstndemo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,brisdklib, StdCtrls,channeldata;

type
  TForm1 = class(TForm)
    opendev: TButton;
    closedev: TButton;
    dial: TButton;
    playfile: TButton;
    GroupBox1: TGroupBox;
    dohook: TCheckBox;
    dophone: TCheckBox;
    linetospk: TCheckBox;
    playtospk: TCheckBox;
    mictoline: TCheckBox;
    opendoplay: TCheckBox;
    recfile: TButton;
    Label1: TLabel;
    channellist: TComboBox;
    refusecallin: TButton;
    startflash: TButton;
    lbmsg: TListBox;
    dialcode: TLabel;
    pstncode: TEdit;
    doplaymux: TComboBox;
    playfiledialog: TOpenDialog;
    stopplayfile: TButton;
    stoprecfile: TButton;
    recfiledialog: TSaveDialog;
    fileecho: TCheckBox;
    fileagc: TCheckBox;
    Label2: TLabel;
    recfileformat: TComboBox;
    amGroupBox: TGroupBox;
    Label3: TLabel;
    spkam: TComboBox;
    Label4: TLabel;
    micam: TComboBox;
    startspeech: TButton;
    Button2: TButton;
    procedure closedevClick(Sender: TObject);
    procedure InitDevice();
    procedure opendevClick(Sender: TObject);
    procedure ShowMsg(const msg : WideString);
    procedure ProcDevErr(lerrid : longint);
    procedure StopchannelPlayfile(chid: Smallint);
    procedure StopchannelRecfile(chid: Smallint);
    function  GetChannelModule(chid:smallint):string;
    procedure MyMsgProc(var Msg:TMessage); message BRI_EVENT_MESSAGE;
    procedure dophoneClick(Sender: TObject);
    procedure dohookClick(Sender: TObject);
    procedure linetospkClick(Sender: TObject);
    procedure playtospkClick(Sender: TObject);
    procedure mictolineClick(Sender: TObject);
    procedure opendoplayClick(Sender: TObject);
    procedure dialClick(Sender: TObject);
    procedure doplaymuxChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure playfileClick(Sender: TObject);
    procedure stopplayfileClick(Sender: TObject);
    procedure recfileClick(Sender: TObject);
    procedure refusecallinClick(Sender: TObject);
    procedure startflashClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure spkamChange(Sender: TObject);
    procedure micamChange(Sender: TObject);
    procedure stoprecfileClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure startspeechClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.ShowMsg(const msg : WideString);
begin
  lbMsg.Items.Append(msg);
  lbMsg.Selected[lbMsg.Items.Count-1]:=true;//选择显示最后一个状态
end;

procedure TForm1.ProcDevErr(lerrid : longint);
begin
  case lerrid of
  0:
  begin
  ShowMsg('读取数据错误');
  end;
  1:
  begin
  ShowMsg('写入数据错误');
  end;
  2:
  begin
  ShowMsg('数据帧ID丢失,可能是CPU太忙');
  end;
  3:
  begin
  ShowMsg('设备已经被拔掉');
  end;
  4:
  begin
  ShowMsg('序列号冲突');
  end;
  else
  begin
  ShowMsg('未知错误');
  end;
end 
end;

procedure TForm1.StopchannelRecfile(chid: Smallint);
begin
	if ChannelStatus[chid].lRecFileID > 0 then
        begin
        	QNV_RecordFile(chid,QNV_RECORD_FILE_STOP,ChannelStatus[chid].lRecFileID,0,NULL);
		ChannelStatus[chid].lRecFileID := -1;
                ShowMsg('停止');
	end;
end;

procedure TForm1.StopchannelPlayfile(chid: Smallint);
begin
	if ChannelStatus[chid].lPlayFileID > 0 then
        begin
        	QNV_PlayFile(chid,QNV_PLAY_FILE_STOP,ChannelStatus[chid].lPlayFileID,0,NULL);
		ChannelStatus[chid].lPlayFileID := -1;
                ShowMsg('停止播放');
	end;
end;

//消息事件处理器
procedure TForm1.MyMsgProc(var Msg:TMessage);
var
 pEvent:PTBriEvent_Data;
 e:TBriEvent_Data;
begin
 pEvent := PTBriEvent_Data(Msg.LParam);
 QNV_Event(pEvent^.uChannelID,QNV_EVENT_POP,0,NULL,@e,0);//演示主动获取事件函数方式,无实际意义
 case pEvent^.lEventType of
   BriEvent_PhoneHook:
        begin
          ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'本地话机摘机');
          if QNV_General(pEvent^.uChannelID,QNV_GENERAL_ISDIALING,0,NULL) = 0 then
          begin
          QNV_SetDevCtrl(pEvent^.uChannelID,QNV_CTRL_DOHOOK,0);
          ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ': '+'自动软挂机，禁止带耳麦的设备进行3方通话');
          end
        end;
   BriEvent_PhoneHang:
        begin
           ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'本地话机挂机');
        end;
   BriEvent_CallIn:
        begin
           if pEvent^.szData[1] = '0' then
           begin
            ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'来电响铃开始');
           end
           else
            ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'来电响铃静音');
        end;
   BriEvent_SpeechResult:
        begin
            ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'语音识别结果:'+pEvent^.szData);
            QNV_Speech(pEvent^.uChannelID,QNV_SPEECH_STARTSPEECH,0,NULL);
            showmsg('重新开始识别');
        end;
   BriEvent_GetCallID:
        begin
            ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'获取到来电号码 '+pEvent^.szData);
        end;
   BriEvent_StopCallIn:
        begin
            ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'对方停止呼入产生一个未接电话 ');
        end;
   BriEvent_DialEnd:
        begin
           ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'拨号结束');
           if QNV_GetDevCtrl(pEvent^.uChannelID,QNV_CTRL_PHONE) > 0 then
          begin
          QNV_SetDevCtrl(pEvent^.uChannelID,QNV_CTRL_DOHOOK,0);
          ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ': '+'检测到电话机已摘着,自动软挂机，禁止带耳麦的设备进行3方通话');
          end
        end;
   BriEvent_PlayFileEnd:
        begin
          ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'播放文件结束');
        end;
   BriEvent_PlayMultiFileEnd:
        begin
          ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'多文件连播结束');
        end;
   BriEvent_GetDTMFChar:
        begin
          ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'检测到DTMF按键:'+pEvent^.szData);
        end;
   BriEvent_Busy:
        begin
          ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'检测到忙音信号/可能未通或者通话已结束');
        end;
   BriEvent_RemoteHook:
        begin
          ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'检测到对方摘机');
        end;
   BriEvent_RemoteHang:
        begin
          ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'检测到对方挂机');
        end;
   BriEvent_DialTone:
        begin
          ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'检测到拨号音');
        end;
   BriEvent_PhoneDial:
       begin
          ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'本地话机拨号:'+pEvent^.szData);
        end;
   BriEvent_RingBack:
        begin
          ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'检测到回铃音');
        end;
   BriEvent_RefuseEnd:
        begin
          ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'拒接完成');
        end;
   BriEvent_FlashEnd:
        begin
          ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'拍插簧完成');
        end;
   BriEvent_DevErr:
        begin
        ProcDevErr(pEvent^.lResult);
        end;
     else
        begin
         ShowMsg('通道' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'其它事件 id='+IntToStr(pEvent^.lEventType) + ' result=' +IntToStr(pEvent^.lResult));
        end;
   end;
end;

procedure TForm1.closedevClick(Sender: TObject);
begin
        QNV_CloseDevice(ODT_ALL,0);
        channellist.Clear();
        ShowMsg('设备已关闭');
end;

function  TForm1.GetChannelModule(chid:smallint):string;
var
lModule:longint;
strModule:string;
begin
     lModule := QNV_DevInfo(chid,QNV_DEVINFO_GETMODULE);
     if (lModule AND DEVMODULE_DOPLAY) <> 0 then
      begin
         strModule := strModule + '有喇叭/';
      end;
      if (lModule AND DEVMODULE_CALLID) <> 0 then
      begin
         strModule := strModule + '有来电显示/';
      end;
      if (lModule AND DEVMODULE_PHONE) <> 0 then
      begin
         strModule := strModule + '话机拨号/';
      end;
      if (lModule AND DEVMODULE_SWITCH) <> 0 then
      begin
         strModule := strModule + '断开电话机/';
      end;
      if (lModule AND DEVMODULE_PLAY2TEL) <> 0 then
      begin
         strModule := strModule + '播放语音到电话机/';
      end;
      if (lModule AND DEVMODULE_HOOK) <> 0 then
      begin
         strModule := strModule + '软摘机/';
      end;
      if (lModule AND DEVMODULE_MICSPK) <> 0 then
      begin
         strModule := strModule + '有耳机/MIC/';
      end;
      if (lModule AND DEVMODULE_RING) <> 0 then
      begin
         strModule := strModule + '模拟话机震铃/';
      end;
      if (lModule AND DEVMODULE_FAX) <> 0 then
      begin
         strModule := strModule + '收发传真/';
      end;
      if (lModule AND DEVMODULE_POLARITY) <> 0 then
      begin
         strModule := strModule + '反级检测/';
      end;
     Result := strModule;
end;

//初始化设备
procedure TForm1.InitDevice();
var
id:integer;
//e:TBriEvent_Data;
begin
        channellist.Clear();
        if QNV_OpenDevice(0,0,NULL)> 0 then
        begin
            ShowMsg('初始化设备成功,总共通道：'+IntToStr(QNV_DevInfo(0,QNV_DEVINFO_GETCHANNELS)));
            for id:=0 to QNV_DevInfo(0,QNV_DEVINFO_GETCHANNELS)-1 do
              begin
                //建议软件测试时建议关闭看门狗,正式发布时开启看门狗
                //如果测试软件不关闭看门狗,在程序断点停留超过5秒,设备将被自动复位,就需要重新打开设备了
                QNV_SetDevCtrl(id,QNV_CTRL_WATCHDOG,0);
                micam.ItemIndex := QNV_GetParam(id,QNV_PARAM_AM_MIC);
	        spkam.itemindex := QNV_GetParam(id,QNV_PARAM_AM_SPKOUT);
                ChannelStatus[id].lRecFileID  := -1;
                ChannelStatus[id].lPlayFileID := -1;
                QNV_Event(id,QNV_EVENT_REGWND,handle,NULL,NULL,0);
                //QNV_Event(id,QNV_EVENT_POP,0,NULL,@e,0);

                channellist.Items.Add('通道'+inttostr(id+1));

                ShowMsg('通道ID='+Inttostr(id+1)+' 设备ID='+Inttostr(QNV_DevInfo(id,QNV_DEVINFO_GETDEVID))
                        + ' 序列号='+Inttostr(QNV_DevInfo(id,QNV_DEVINFO_GETSERIAL))+' 设备类型='+Inttostr(QNV_DevInfo(id,QNV_DEVINFO_GETTYPE))
                        + ' 芯片类型='+inttostr(QNV_DevInfo(id,QNV_DEVINFO_GETCHIPTYPE)) + ' 模块='+GetChannelModule(0));

              end;

            if channellist.Items.Count > 0 then
            begin
            channellist.ItemIndex := 0;
            end;
            ShowMsg('初始化通道参数完成');
        end
        else
            ShowMsg('打开设备失败,请检查设备是否已经插入并安装了驱动,并且没有其它程序已经打开设备');
end;
procedure TForm1.opendevClick(Sender: TObject);
begin
        QNV_CloseDevice(ODT_ALL,0);
        InitDevice();
end;

procedure TForm1.dophoneClick(Sender: TObject);
begin
        QNV_SetDevCtrl(channellist.ItemIndex,QNV_CTRL_DOPHONE,Integer(NOT dophone.Checked));
end;

procedure TForm1.dohookClick(Sender: TObject);
begin
        QNV_SetDevCtrl(channellist.ItemIndex,QNV_CTRL_DOHOOK,Integer(dohook.Checked));
end;

procedure TForm1.linetospkClick(Sender: TObject);
begin
        QNV_SetDevCtrl(channellist.ItemIndex,QNV_CTRL_DOLINETOSPK,Integer(linetospk.Checked));
end;

procedure TForm1.playtospkClick(Sender: TObject);
begin
        QNV_SetDevCtrl(channellist.ItemIndex,QNV_CTRL_DOPLAYTOSPK,Integer(playtospk.Checked));
end;

procedure TForm1.mictolineClick(Sender: TObject);
begin
        QNV_SetDevCtrl(channellist.ItemIndex,QNV_CTRL_DOMICTOLINE,Integer(mictoline.Checked));
end;

procedure TForm1.opendoplayClick(Sender: TObject);
begin
        QNV_SetDevCtrl(channellist.ItemIndex,QNV_CTRL_DOPLAY,Integer(opendoplay.Checked));
end;

procedure TForm1.dialClick(Sender: TObject);
begin
        if pstncode.Text = '' then begin
        MessageBox(handle,'请输入号码,一个逗号可以延迟1秒','警告',MB_OK);
        end
        else
        QNV_General(channellist.ItemIndex,QNV_GENERAL_STARTDIAL,0,BRIPCHAR8(AnsiString(pstncode.Text)));
end;

procedure TForm1.doplaymuxChange(Sender: TObject);
begin
        case doplaymux.ItemIndex of
        0:
        begin
        QNV_SetDevCtrl(channellist.ItemIndex,QNV_CTRL_PLAYMUX,DOPLAY_CHANNEL0_DAC);//选择听线路声音
        end;
        1:
        begin
        QNV_SetDevCtrl(channellist.ItemIndex,QNV_CTRL_PLAYMUX,DOPLAY_CHANNEL0_ADC);//选择听线路声音
        end;
        end ;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
id : integer;
begin
        SendMessage(lbmsg.Handle, LB_SETHORIZONTALEXTENT, 1024, 0);
        doplaymux.Clear();
        doplaymux.Items.Add('播放的语音到喇叭');
        doplaymux.Items.Add('线路语音到喇叭');
        doplaymux.ItemIndex := 0;

        for id:=0 to 15 do
        begin
        spkam.Items.Add(InttoStr(id));
        end;
        for id:=0 to 7 do
        begin
        micam.Items.Add(InttoStr(id));
        end;

        recfileformat.Clear();
        recfileformat.Items.Add('BRI_WAV_FORMAT_DEFAULT (BRI_AUDIO_FORMAT_PCM8K16B)');
        recfileformat.Items.Add('BRI_WAV_FORMAT_ALAW8K (8k/s)');
        recfileformat.Items.Add('BRI_WAV_FORMAT_ULAW8K (8k/s)');
        recfileformat.Items.Add('BRI_WAV_FORMAT_IMAADPCM8K4B (4k/s)');
        recfileformat.Items.Add('BRI_WAV_FORMAT_PCM8K8B (8k/s)');
        recfileformat.Items.Add('BRI_WAV_FORMAT_PCM8K16B (16k/s)');
        recfileformat.Items.Add('BRI_WAV_FORMAT_MP38K8B (1.2k/s)');
        recfileformat.Items.Add('BRI_WAV_FORMAT_MP38K16B( 2.4k/s)');
        recfileformat.Items.Add('BRI_WAV_FORMAT_TM8K1B (1.5k/s)');
        recfileformat.Items.Add('BRI_WAV_FORMAT_GSM6108K(2.2k/s)');
        recfileformat.ItemIndex := 0;
end;

procedure TForm1.playfileClick(Sender: TObject);
var
lMask : longint;
begin
        if playfiledialog.Execute   then
        begin
        StopchannelPlayfile(channellist.ItemIndex);
        lMask := PLAYFILE_MASK_REPEAT;//循环播放
        ChannelStatus[channellist.ItemIndex].lPlayFileID := QNV_PlayFile(channellist.ItemIndex,QNV_PLAY_FILE_START,0,lMask,BRIPCHAR8(AnsiString(playfiledialog.FileName)));
        if ChannelStatus[channellist.ItemIndex].lPlayFileID < 0 then
                begin
                ShowMsg('通道'+InttoStr(channellist.ItemIndex)+'播放文件出错');
                end
        else
                ShowMsg('通道'+InttoStr(channellist.ItemIndex)+'开始播放文件');
        end;
end;

procedure TForm1.stopplayfileClick(Sender: TObject);
begin
      StopchannelPlayfile(channellist.ItemIndex);
end;

procedure TForm1.recfileClick(Sender: TObject);
var
lMask:longint;
lFormat:longint;
begin
     if recfiledialog.Execute   then
     begin
     StopchannelRecfile(channellist.ItemIndex);
     lMask := 0;//RECORD_MASK_ECHO | RECORD_MASK_AGC
     if Integer(fileecho.Checked) > 0 then
     begin
          lMask := (lMask OR RECORD_MASK_ECHO);
     end;

     if Integer(fileagc.Checked) > 0 then
     begin
          lMask := (lMask OR RECORD_MASK_AGC);
     end;
     
     lFormat := recfileformat.ItemIndex;
     ChannelStatus[channellist.ItemIndex].lRecFileID := QNV_RecordFile(channellist.ItemIndex,QNV_RECORD_FILE_START,lFormat,lMask,BRIPCHAR8(AnsiString(recfiledialog.FileName)));
     if ChannelStatus[channellist.ItemIndex].lRecFileID <= 0 then
             begin
               ShowMsg('通道'+InttoStr(channellist.ItemIndex)+'文件录音出错');
             end
             else
               ShowMsg('通道'+InttoStr(channellist.ItemIndex)+'开始文件录音');
     end;
end;

procedure TForm1.refusecallinClick(Sender: TObject);
begin
        if QNV_GetDevCtrl(channellist.ItemIndex,QNV_CTRL_RINGTIMES) <= 0 then
        begin
	     MessageBox(handle,'没有来电，无效的拒接','错误',MB_OK);
        end
	else
             QNV_General(channellist.ItemIndex,QNV_GENERAL_STARTREFUSE,0,NULL);
end;

procedure TForm1.startflashClick(Sender: TObject);
begin
	if (QNV_GetDevCtrl(channellist.ItemIndex,QNV_CTRL_DOHOOK) <= 0) AND (QNV_GetDevCtrl(channellist.ItemIndex,QNV_CTRL_PHONE) <= 0)  then
          begin
		MessageBox(handle,'没有摘机状态/PSTN空闲状态，无效的拍插簧','错误',MB_OK);
          end
	  else
           begin
		if QNV_General(channellist.ItemIndex,QNV_GENERAL_STARTFLASH,FT_ALL,'') <= 0 then//*1099*/
                begin
	        MessageBox(handle,'拍插簧失败','失败',MB_OK);
                end
           end
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
        QNV_CloseDevice(ODT_ALL,0); 
end;

procedure TForm1.spkamChange(Sender: TObject);
begin
        QNV_SetParam(channellist.ItemIndex,QNV_PARAM_AM_SPKOUT,spkam.ItemIndex);
end;

procedure TForm1.micamChange(Sender: TObject);
begin
        QNV_SetParam(channellist.ItemIndex,QNV_PARAM_AM_MIC,micam.ItemIndex);
end;

procedure TForm1.stoprecfileClick(Sender: TObject);
begin
    StopchannelRecfile(channellist.ItemIndex);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
        QNV_Speech(1,QNV_SPEECH_STOPSPEECH,0,NULL);
        QNV_SetDevCtrl(1,QNV_CTRL_DOPHONE,1);	
end;

procedure TForm1.startspeechClick(Sender: TObject);
begin
	QNV_SetDevCtrl(1,QNV_CTRL_DOPHONE,0);
	QNV_Speech(1,QNV_SPEECH_CONTENTLIST,0,'零,一,二,三,四,五,六,七,八,九');
	if(QNV_Speech(1,QNV_SPEECH_STARTSPEECH,0,NULL) <= 0)  then
        begin
        ShowMsg('启动语音识别失败');
        end
        else
        begin
         ShowMsg('开始话机说话识别数字0-9，请拿起话机说');
         end;
end;

end.
