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
  lbMsg.Selected[lbMsg.Items.Count-1]:=true;//ѡ����ʾ���һ��״̬
end;

procedure TForm1.ProcDevErr(lerrid : longint);
begin
  case lerrid of
  0:
  begin
  ShowMsg('��ȡ���ݴ���');
  end;
  1:
  begin
  ShowMsg('д�����ݴ���');
  end;
  2:
  begin
  ShowMsg('����֡ID��ʧ,������CPU̫æ');
  end;
  3:
  begin
  ShowMsg('�豸�Ѿ����ε�');
  end;
  4:
  begin
  ShowMsg('���кų�ͻ');
  end;
  else
  begin
  ShowMsg('δ֪����');
  end;
end 
end;

procedure TForm1.StopchannelRecfile(chid: Smallint);
begin
	if ChannelStatus[chid].lRecFileID > 0 then
        begin
        	QNV_RecordFile(chid,QNV_RECORD_FILE_STOP,ChannelStatus[chid].lRecFileID,0,NULL);
		ChannelStatus[chid].lRecFileID := -1;
                ShowMsg('ֹͣ');
	end;
end;

procedure TForm1.StopchannelPlayfile(chid: Smallint);
begin
	if ChannelStatus[chid].lPlayFileID > 0 then
        begin
        	QNV_PlayFile(chid,QNV_PLAY_FILE_STOP,ChannelStatus[chid].lPlayFileID,0,NULL);
		ChannelStatus[chid].lPlayFileID := -1;
                ShowMsg('ֹͣ����');
	end;
end;

//��Ϣ�¼�������
procedure TForm1.MyMsgProc(var Msg:TMessage);
var
 pEvent:PTBriEvent_Data;
 e:TBriEvent_Data;
begin
 pEvent := PTBriEvent_Data(Msg.LParam);
 QNV_Event(pEvent^.uChannelID,QNV_EVENT_POP,0,NULL,@e,0);//��ʾ������ȡ�¼�������ʽ,��ʵ������
 case pEvent^.lEventType of
   BriEvent_PhoneHook:
        begin
          ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'���ػ���ժ��');
          if QNV_General(pEvent^.uChannelID,QNV_GENERAL_ISDIALING,0,NULL) = 0 then
          begin
          QNV_SetDevCtrl(pEvent^.uChannelID,QNV_CTRL_DOHOOK,0);
          ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ': '+'�Զ���һ�����ֹ��������豸����3��ͨ��');
          end
        end;
   BriEvent_PhoneHang:
        begin
           ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'���ػ����һ�');
        end;
   BriEvent_CallIn:
        begin
           if pEvent^.szData[1] = '0' then
           begin
            ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'�������忪ʼ');
           end
           else
            ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'�������徲��');
        end;
   BriEvent_SpeechResult:
        begin
            ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'����ʶ����:'+pEvent^.szData);
            QNV_Speech(pEvent^.uChannelID,QNV_SPEECH_STARTSPEECH,0,NULL);
            showmsg('���¿�ʼʶ��');
        end;
   BriEvent_GetCallID:
        begin
            ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'��ȡ��������� '+pEvent^.szData);
        end;
   BriEvent_StopCallIn:
        begin
            ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'�Է�ֹͣ�������һ��δ�ӵ绰 ');
        end;
   BriEvent_DialEnd:
        begin
           ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'���Ž���');
           if QNV_GetDevCtrl(pEvent^.uChannelID,QNV_CTRL_PHONE) > 0 then
          begin
          QNV_SetDevCtrl(pEvent^.uChannelID,QNV_CTRL_DOHOOK,0);
          ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ': '+'��⵽�绰����ժ��,�Զ���һ�����ֹ��������豸����3��ͨ��');
          end
        end;
   BriEvent_PlayFileEnd:
        begin
          ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'�����ļ�����');
        end;
   BriEvent_PlayMultiFileEnd:
        begin
          ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'���ļ���������');
        end;
   BriEvent_GetDTMFChar:
        begin
          ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'��⵽DTMF����:'+pEvent^.szData);
        end;
   BriEvent_Busy:
        begin
          ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'��⵽æ���ź�/����δͨ����ͨ���ѽ���');
        end;
   BriEvent_RemoteHook:
        begin
          ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'��⵽�Է�ժ��');
        end;
   BriEvent_RemoteHang:
        begin
          ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'��⵽�Է��һ�');
        end;
   BriEvent_DialTone:
        begin
          ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'��⵽������');
        end;
   BriEvent_PhoneDial:
       begin
          ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'���ػ�������:'+pEvent^.szData);
        end;
   BriEvent_RingBack:
        begin
          ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'��⵽������');
        end;
   BriEvent_RefuseEnd:
        begin
          ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'�ܽ����');
        end;
   BriEvent_FlashEnd:
        begin
          ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'�Ĳ�����');
        end;
   BriEvent_DevErr:
        begin
        ProcDevErr(pEvent^.lResult);
        end;
     else
        begin
         ShowMsg('ͨ��' + IntToStr(pEvent^.uChannelID + 1) + ': ' +'�����¼� id='+IntToStr(pEvent^.lEventType) + ' result=' +IntToStr(pEvent^.lResult));
        end;
   end;
end;

procedure TForm1.closedevClick(Sender: TObject);
begin
        QNV_CloseDevice(ODT_ALL,0);
        channellist.Clear();
        ShowMsg('�豸�ѹر�');
end;

function  TForm1.GetChannelModule(chid:smallint):string;
var
lModule:longint;
strModule:string;
begin
     lModule := QNV_DevInfo(chid,QNV_DEVINFO_GETMODULE);
     if (lModule AND DEVMODULE_DOPLAY) <> 0 then
      begin
         strModule := strModule + '������/';
      end;
      if (lModule AND DEVMODULE_CALLID) <> 0 then
      begin
         strModule := strModule + '��������ʾ/';
      end;
      if (lModule AND DEVMODULE_PHONE) <> 0 then
      begin
         strModule := strModule + '��������/';
      end;
      if (lModule AND DEVMODULE_SWITCH) <> 0 then
      begin
         strModule := strModule + '�Ͽ��绰��/';
      end;
      if (lModule AND DEVMODULE_PLAY2TEL) <> 0 then
      begin
         strModule := strModule + '�����������绰��/';
      end;
      if (lModule AND DEVMODULE_HOOK) <> 0 then
      begin
         strModule := strModule + '��ժ��/';
      end;
      if (lModule AND DEVMODULE_MICSPK) <> 0 then
      begin
         strModule := strModule + '�ж���/MIC/';
      end;
      if (lModule AND DEVMODULE_RING) <> 0 then
      begin
         strModule := strModule + 'ģ�⻰������/';
      end;
      if (lModule AND DEVMODULE_FAX) <> 0 then
      begin
         strModule := strModule + '�շ�����/';
      end;
      if (lModule AND DEVMODULE_POLARITY) <> 0 then
      begin
         strModule := strModule + '�������/';
      end;
     Result := strModule;
end;

//��ʼ���豸
procedure TForm1.InitDevice();
var
id:integer;
//e:TBriEvent_Data;
begin
        channellist.Clear();
        if QNV_OpenDevice(0,0,NULL)> 0 then
        begin
            ShowMsg('��ʼ���豸�ɹ�,�ܹ�ͨ����'+IntToStr(QNV_DevInfo(0,QNV_DEVINFO_GETCHANNELS)));
            for id:=0 to QNV_DevInfo(0,QNV_DEVINFO_GETCHANNELS)-1 do
              begin
                //�����������ʱ����رտ��Ź�,��ʽ����ʱ�������Ź�
                //�������������رտ��Ź�,�ڳ���ϵ�ͣ������5��,�豸�����Զ���λ,����Ҫ���´��豸��
                QNV_SetDevCtrl(id,QNV_CTRL_WATCHDOG,0);
                micam.ItemIndex := QNV_GetParam(id,QNV_PARAM_AM_MIC);
	        spkam.itemindex := QNV_GetParam(id,QNV_PARAM_AM_SPKOUT);
                ChannelStatus[id].lRecFileID  := -1;
                ChannelStatus[id].lPlayFileID := -1;
                QNV_Event(id,QNV_EVENT_REGWND,handle,NULL,NULL,0);
                //QNV_Event(id,QNV_EVENT_POP,0,NULL,@e,0);

                channellist.Items.Add('ͨ��'+inttostr(id+1));

                ShowMsg('ͨ��ID='+Inttostr(id+1)+' �豸ID='+Inttostr(QNV_DevInfo(id,QNV_DEVINFO_GETDEVID))
                        + ' ���к�='+Inttostr(QNV_DevInfo(id,QNV_DEVINFO_GETSERIAL))+' �豸����='+Inttostr(QNV_DevInfo(id,QNV_DEVINFO_GETTYPE))
                        + ' оƬ����='+inttostr(QNV_DevInfo(id,QNV_DEVINFO_GETCHIPTYPE)) + ' ģ��='+GetChannelModule(0));

              end;

            if channellist.Items.Count > 0 then
            begin
            channellist.ItemIndex := 0;
            end;
            ShowMsg('��ʼ��ͨ���������');
        end
        else
            ShowMsg('���豸ʧ��,�����豸�Ƿ��Ѿ����벢��װ������,����û�����������Ѿ����豸');
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
        MessageBox(handle,'���������,һ�����ſ����ӳ�1��','����',MB_OK);
        end
        else
        QNV_General(channellist.ItemIndex,QNV_GENERAL_STARTDIAL,0,BRIPCHAR8(AnsiString(pstncode.Text)));
end;

procedure TForm1.doplaymuxChange(Sender: TObject);
begin
        case doplaymux.ItemIndex of
        0:
        begin
        QNV_SetDevCtrl(channellist.ItemIndex,QNV_CTRL_PLAYMUX,DOPLAY_CHANNEL0_DAC);//ѡ������·����
        end;
        1:
        begin
        QNV_SetDevCtrl(channellist.ItemIndex,QNV_CTRL_PLAYMUX,DOPLAY_CHANNEL0_ADC);//ѡ������·����
        end;
        end ;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
id : integer;
begin
        SendMessage(lbmsg.Handle, LB_SETHORIZONTALEXTENT, 1024, 0);
        doplaymux.Clear();
        doplaymux.Items.Add('���ŵ�����������');
        doplaymux.Items.Add('��·����������');
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
        lMask := PLAYFILE_MASK_REPEAT;//ѭ������
        ChannelStatus[channellist.ItemIndex].lPlayFileID := QNV_PlayFile(channellist.ItemIndex,QNV_PLAY_FILE_START,0,lMask,BRIPCHAR8(AnsiString(playfiledialog.FileName)));
        if ChannelStatus[channellist.ItemIndex].lPlayFileID < 0 then
                begin
                ShowMsg('ͨ��'+InttoStr(channellist.ItemIndex)+'�����ļ�����');
                end
        else
                ShowMsg('ͨ��'+InttoStr(channellist.ItemIndex)+'��ʼ�����ļ�');
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
               ShowMsg('ͨ��'+InttoStr(channellist.ItemIndex)+'�ļ�¼������');
             end
             else
               ShowMsg('ͨ��'+InttoStr(channellist.ItemIndex)+'��ʼ�ļ�¼��');
     end;
end;

procedure TForm1.refusecallinClick(Sender: TObject);
begin
        if QNV_GetDevCtrl(channellist.ItemIndex,QNV_CTRL_RINGTIMES) <= 0 then
        begin
	     MessageBox(handle,'û�����磬��Ч�ľܽ�','����',MB_OK);
        end
	else
             QNV_General(channellist.ItemIndex,QNV_GENERAL_STARTREFUSE,0,NULL);
end;

procedure TForm1.startflashClick(Sender: TObject);
begin
	if (QNV_GetDevCtrl(channellist.ItemIndex,QNV_CTRL_DOHOOK) <= 0) AND (QNV_GetDevCtrl(channellist.ItemIndex,QNV_CTRL_PHONE) <= 0)  then
          begin
		MessageBox(handle,'û��ժ��״̬/PSTN����״̬����Ч���Ĳ��','����',MB_OK);
          end
	  else
           begin
		if QNV_General(channellist.ItemIndex,QNV_GENERAL_STARTFLASH,FT_ALL,'') <= 0 then//*1099*/
                begin
	        MessageBox(handle,'�Ĳ��ʧ��','ʧ��',MB_OK);
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
	QNV_Speech(1,QNV_SPEECH_CONTENTLIST,0,'��,һ,��,��,��,��,��,��,��,��');
	if(QNV_Speech(1,QNV_SPEECH_STARTSPEECH,0,NULL) <= 0)  then
        begin
        ShowMsg('��������ʶ��ʧ��');
        end
        else
        begin
         ShowMsg('��ʼ����˵��ʶ������0-9�������𻰻�˵');
         end;
end;

end.
