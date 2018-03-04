unit uFrmSyncBaseData;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RzPanel,uHttpDataUpdateMgr,uWebIF,uGlobalDM,
  uWebJob_TrainmanSync,uWebJob_SyncDic_Area,uWebJob_SyncDic_DutyUser,
  uWebJob_SyncDic_Site,uWebJob_SyncDic_Site_Limit,
  uWebJob_SyncDic_Station,uWebJob_SyncDic_TrainJiaoLu,
  uWebJob_SyncDic_TrainJiaoLu_InSite, uWebJob_SyncDic_WorkShop
  ;

type
  TFrmSyncBaseData = class(TForm)
    mmoLogs: TMemo;
    pnl1: TRzPanel;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
     //同步管理器
    m_HttpUpdateMgr: TDataUpdateManager;

  private
    //显示日志
    procedure InsertLogs(strLogText:string);

  public
    class function LoadData():Boolean;
  end;

implementation

{$R *.dfm}

procedure TFrmSyncBaseData.btnCancelClick(Sender: TObject);
begin
  m_HttpUpdateMgr.Stop;
  self.ModalResult := mrOk;
end;

procedure TFrmSyncBaseData.FormActivate(Sender: TObject);
var
  strErr:string;
begin
  try
    if  m_HttpUpdateMgr.InitDB(GlobalDM.SQLConfig_Local.ConnString,strErr) = False then
    begin
      ShowMessage(strErr);
      Exit;
    end;
    m_HttpUpdateMgr.DoUpdate;
  finally
    btnCancel.Visible := True;
  end;
end;

procedure TFrmSyncBaseData.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := btnCancel.Visible;
end;

procedure TFrmSyncBaseData.FormCreate(Sender: TObject);
var
  webConfig:RWebConfig;
begin
  webConfig.strCID := '';//GlobalDM.SiteInfo.strSiteGUID;
  webConfig.strURL := GlobalDM.GetWebUrl;
  webConfig.strHost := GlobalDM.GetWebApiHost();
  m_HttpUpdateMgr:= TDataUpdateManager.Create;

  m_HttpUpdateMgr.AddUpdateJob(TWebJob_SyncDic_Area.Create('机务段信息'));
  m_HttpUpdateMgr.AddUpdateJob(TWebJob_SyncDic_WorkShop.Create('车间信息'));
  m_HttpUpdateMgr.AddUpdateJob(TWebJob_SyncDic_Site.Create('客户端信息'));
  m_HttpUpdateMgr.AddUpdateJob(TWebJob_SyncDic_Site_Limit.Create('客户端权限信息'));
  m_HttpUpdateMgr.AddUpdateJob(TWebJob_SyncDic_Station.Create('车站信息'));
  m_HttpUpdateMgr.AddUpdateJob(TWebJob_SyncDic_TrainJiaoLu.Create('行车交路信息'));
  m_HttpUpdateMgr.AddUpdateJob(TWebJob_SyncDic_TrainJiaoLu_InSite.Create('客户端管辖行车交路信息'));
  m_HttpUpdateMgr.AddUpdateJob(TWebJob_SyncDic_DutyUser.Create('管理员信息'));
  //m_HttpUpdateMgr.AddUpdateJob(TWebJob_TrainmanSync.Create('人员信息'));

  m_HttpUpdateMgr.SetWebConfig(webConfig);
  m_HttpUpdateMgr.OnInsertLogs := self.InsertLogs;

end;

procedure TFrmSyncBaseData.FormDestroy(Sender: TObject);
begin
  m_HttpUpdateMgr.Free;
end;

procedure TFrmSyncBaseData.InsertLogs(strLogText: string);
begin
 { if MmoLogs.Lines.Count>1000 then
  begin
    MmoLogs.Lines.Clear;
  end; }
  strLogText := formatDateTime('[yyyy-mm-dd hh:nn:ss]', now) + ' ' + strLogText;
  {if MmoLogs.Lines.Count > 1000 then
    MmoLogs.Lines.Clear; }
  MmoLogs.Lines.Add(strLogText);
end;

class function TFrmSyncBaseData.LoadData: Boolean;
var
  frm: TFrmSyncBaseData;
begin
  result := False;
  frm:= TFrmSyncBaseData.Create(nil);
  try
    if frm.ShowModal = mrOk then
      result := True;
  finally
    frm.Free;
  end;
end;

end.
