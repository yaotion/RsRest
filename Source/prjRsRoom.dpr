program prjRsRoom;

{%File 'uDebug.inc'}

uses
  Forms,
  SysUtils,
  windows,
  uFrmLogin in '��¼\���ܴ���\uFrmLogin.pas' {frmLogin},
  uDutyUser in '��¼\���ݶ���\uDutyUser.pas',
  uGlobalDM in 'uGlobalDM.pas' {GlobalDM: TDataModule},
  uDBDutyUser in '��¼\���ݿ����\uDBDutyUser.pas',
  uDutyPlace in '���ڵ�\���ݶ���\uDutyPlace.pas',
  uDBSite in '�ͻ�����Ϣ\���ݿ����\uDBSite.pas',
  uSite in '�ͻ�����Ϣ\���ݶ���\uSite.pas',
  uTrainJiaolu in '��·_�г�\���ݶ���\uTrainJiaolu.pas',
  uTrainmanJiaolu in '��·_��Ա\���ݶ���\uTrainmanJiaolu.pas',
  uStation in '��վ\uStation.pas',
  uRsInterfaceDefine in '����\���ݶ���\uRsInterfaceDefine.pas',
  uRunEvent in '�¼�\���ݶ���\uRunEvent.pas',
  uDBTrainman in '��Ա\���ݿ����\uDBTrainman.pas',
  uClientAppInfo in '�ͻ�����Ϣ\���ݶ���\uClientAppInfo.pas',
  uLogs in '��־\uLogs.pas',
  uTrainman in '��Ա\���ݶ���\uTrainman.pas',
  uLogManage in '��־\uLogManage.pas',
  uHttpComm in 'web�ӿ�\uHttpComm.pas',
  uWebIF in 'web�ӿ�\uWebIF.pas',
  uGenericData in 'Json\uGenericData.pas',
  superobject in 'Json\superobject.pas',
  uLocalTrainman in '��Ա\���ݶ���\uLocalTrainman.pas',
  uDBLocalTrainman in '��Ա\���ݿ����\uDBLocalTrainman.pas',
  uFrmMain_RoomSign in 'uFrmMain_RoomSign.pas' {frmMain_RoomSign},
  uWaitWorkMgr in '������\uWaitWorkMgr.pas',
  uWaitWork in '������\���ݶ���\uWaitWork.pas',
  uPubFun in '��������\uPubFun.pas',
  uDBWaitWork in '������\���ݿ����\uDBWaitWork.pas',
  uRoomSignConfig in '��������\�߼���Ԫ\uRoomSignConfig.pas',
  uFrmWaitWorkPlanMgr in '������\���ܴ���\���ƻ���ʾ\uFrmWaitWorkPlanMgr.pas' {FrmWaitWorkPlanMgr},
  uFrmEditWaitWork in '������\���ܴ���\�༭���˼ƻ�\uFrmEditWaitWork.pas' {FrmEditWaitWork},
  uFrmQueryWaitRecord in '������\���ܴ���\��ѯ���˼�¼\uFrmQueryWaitRecord.pas' {FrmQueryWaitRecord},
  uFrmCreateWaitWorkPlan in '������\���ܴ���\�������˼ƻ�\uFrmCreateWaitWorkPlan.pas' {FrmCreateWaitWorkPlan},
  uFrmLoadWaitPlan in '������\���ܴ���\���ش��˼ƻ�\uFrmLoadWaitPlan.pas' {FrmLoadWaitPlan},
  uFrmMatchWaitMan in '������\���ܴ���\ƥ��ǩ������Ա\uFrmMatchWaitMan.pas' {FrmMatchWaitMan},
  uFrmSelWaitTrainNo in '������\���ܴ���\ѡ���೵��\uFrmSelWaitTrainNo.pas' {FrmSelWaitTrainNo},
  uFrmSetTrainmanPlan in '������\���ܴ���\ָ�����˼ƻ�\uFrmSetTrainmanPlan.pas' {FrmSetTrainmanPlan},
  uDBWorkShop in '����\���ݿ����\uDBWorkShop.pas',
  uWorkShop in '����\���ݶ���\uWorkShop.pas',
  uDBTrainJiaolu in '��·_�г�\���ݿ����\uDBTrainJiaolu.pas',
  uFrmSelectColumn in 'AdvGrid\���ܴ���\uFrmSelectColumn.pas' {frmSelectColumn},
  uStrGridUtils in 'AdvGrid\���ܵ�Ԫ\uStrGridUtils.pas',
  uFrmModifyCallWorkTime in '������\���ܴ���\�༭���˼ƻ�\uFrmModifyCallWorkTime.pas' {FrmEditCallWorkTime},
  uFrmMunualCall in '�а����\���ܴ���\�˹��а�\uFrmMunualCall.pas' {FrmMunualCall},
  uRoomCallApp in '�а����\���ܵ�Ԫ\uRoomCallApp.pas',
  uRoomCall in '�а����\���ݶ���\�а����\uRoomCall.pas',
  uCallControl in '�а����\���ܵ�Ԫ\�а�ͨѶ\uCallControl.pas',
  uCallUtils in '�а����\���ܵ�Ԫ\�а�ͨѶ\uCallUtils.pas',
  uRoomCallOp in '�а����\���ܵ�Ԫ\�а�ͨѶ\uRoomCallOp.pas',
  uMixerRecord in '�а����\���ܵ�Ԫ\¼������\uMixerRecord.pas',
  uRoomCallMsgDefine in '�а����\���ݶ���\��Ԣ�а���Ϣ����\uRoomCallMsgDefine.pas',
  uLCSignPlan in '����ǩ��\�߼���Ԫ\WebIF\uLCSignPlan.pas',
  uBaseWebInterface in 'web�ӿ�\uBaseWebInterface.pas',
  uHttpCom in 'web�ӿ�\uHttpCom.pas',
  uSignPlan in '����ǩ��\���ܵ�Ԫ\uSignPlan.pas',
  uFrmRoomSync in '����ͬ��\���ܴ���\uFrmRoomSync.pas' {FrmRoomSync},
  uUPDateThread in '����ͬ��\���ܵ�Ԫ\ͬ���߳�\uUPDateThread.pas',
  uWebJob_TrainmanSync in '����ͬ��\���ܵ�Ԫ\ͬ������\ͬ������Ա��Ϣ\uWebJob_TrainmanSync.pas',
  uTrainmanSync in '����ͬ��\���ܵ�Ԫ\ͬ������\ͬ������Ա��Ϣ\uTrainmanSync.pas',
  uSerializable in '����ͬ��\���ܵ�Ԫ\ͬ������\ͬ������Ա��Ϣ\uSerializable.pas',
  uWebJob_InOutRoom in '����ͬ��\���ܵ�Ԫ\ͬ������\�ϴ�����Ԣ��¼\uWebJob_InOutRoom.pas',
  uHttpDataUpdateMgr in '����ͬ��\���ܵ�Ԫ\ͬ������\�������\uHttpDataUpdateMgr.pas',
  uRunSaftyMessageDefine in '��Ϣ\���ݶ���\uRunSaftyMessageDefine.pas',
  uFrmWaitTimeTable in '������\���ܴ���\���ʱ�̱�\uFrmWaitTimeTable.pas' {FrmWaitTimeTable},
  uFrmEditWaitTime in '������\���ܴ���\���ʱ�̱�\uFrmEditWaitTime.pas' {FrmEditWaitTime},
  ufrmCallConfig in '�а����\���ܴ���\�а�����\ufrmCallConfig.pas' {frmCallConfig},
  uFrmCallDevMgr in '�а����\���ܴ���\�а��豸\uFrmCallDevMgr.pas' {FrmCallDevMgr},
  uFrmEditCallDev in '�а����\���ܴ���\�а��豸\uFrmEditCallDev.pas' {FrmEditCallDev},
  uFrmCallPlan in '�а����\���ܴ���\�а�ƻ�\uFrmCallPlan.pas' {FrmCallPlan},
  uFrmEditCallPlan in '�а����\���ܴ���\�а�ƻ�\uFrmEditCallPlan.pas' {FrmEditCallPlan},
  UFrmRecvCallNotify in '�а����\���ܴ���\�а�֪ͨ\UFrmRecvCallNotify.pas' {FrmRecvCallNotify},
  uFrmSendNodityCall in '�а����\���ܴ���\�а�֪ͨ\uFrmSendNodityCall.pas' {FrmSendNotifyCall},
  uCallRecord in '�а����\���ݶ���\�а��¼\uCallRecord.pas',
  uCallNotify in '�а����\���ݶ���\�а�֪ͨ\uCallNotify.pas',
  uDBRoomCall in '�а����\���ݿ����\�а����\uDBRoomCall.pas',
  uDBCallNotify in '�а����\���ݿ����\�а�֪ͨ\uDBCallNotify.pas',
  uFrmQueryCallRecord in '�а����\���ܴ���\�а��¼\uFrmQueryCallRecord.pas' {FrmQueryCallRecord},
  uFrmWaitPlanLoadTimeSet in '�а����\���ܴ���\�а�ƻ�\uFrmWaitPlanLoadTimeSet.pas' {FrmWaitWorkPlanLoadTimeSet},
  uFrmRoomMgr in '������\���ܴ���\�������\uFrmRoomMgr.pas' {FrmRoomMgr},
  ufrmAccessReadFingerprintTemplates in '��Ա\���ܴ���\������Ա����\ufrmAccessReadFingerprintTemplates.pas' {frmAccessReadFingerprintTemplates},
  uFrmLeaderInspect in '������\���ܴ���\�ɲ����\uFrmLeaderInspect.pas' {FrmLeaderInspect},
  uLeaderExam in '������\���ݶ���\uLeaderExam.pas',
  uFrmGetInput in '������\���ܴ���\�ɲ����\uFrmGetInput.pas' {FrmGetInput},
  uDBLeaderInspect in '������\���ݿ����\uDBLeaderInspect.pas',
  utfPopBox in 'ͨ�ô���\�Զ��ر��޽���Ի���\utfPopBox.pas' {tfPopBox},
  ufrmTextInput in 'ͨ�ô���\����Ի���\ufrmTextInput.pas' {frmTextInput},
  ufrmTimeRange in 'ͨ�ô���\ʱ��ѡ��Ի���\ufrmTimeRange.pas' {frmTuDingTimeRange},
  ufrmHint in 'ͨ�ô���\��Ϣ��ʾ�Ի���\ufrmHint.pas' {frmHint},
  uFrmTrainmanManage in '��Ա\���ܴ���\��Ա����\uFrmTrainmanManage.pas' {frmTrainmanManage},
  ufrmUserInfoEdit in '��Ա\���ܴ���\��Ա����\ufrmUserInfoEdit.pas' {frmUserInfoEdit},
  uDBGuideGroup in '��Ա\���ݿ����\uDBGuideGroup.pas',
  uGuideGroup in '��Ա\���ݶ���\uGuideGroup.pas',
  ufrmTrainmanIdentityAccess in '��Ա\���ܴ���\��Ա�Ǽ�\ufrmTrainmanIdentityAccess.pas' {FrmTrainmanIdentityAccess},
  ufrmCamer in 'ͨ�ô���\����\ufrmCamer.pas' {frmCamera: TFrame},
  ufrmgather in 'ͨ�ô���\����\ufrmgather.pas' {frmPictureGather},
  ufrmFingerRegister in 'ͨ�ô���\ָ��ע��\ufrmFingerRegister.pas' {frmFingerRegister},
  ufrmConfig in '��������\���ܴ���\��¼����\ufrmConfig.pas' {frmConfig},
  uFrmRoomSign_Config in '��������\���ܴ���\ͬ������\uFrmRoomSign_Config.pas' {FrmRoomSign_Config},
  uFrmRoomSignSysConfig in '��������\���ܴ���\ͬ������\uFrmRoomSignSysConfig.pas' {FrmRoomSignsSysConfig},
  ufrmTrainmanPicFigEdit in '��Ա\���ܴ���\��Ա����\ufrmTrainmanPicFigEdit.pas' {FrmTrainmanPicFigEdit},
  uDBCLientApp in '�ͻ�����Ϣ\���ݿ����\uDBCLientApp.pas',
  uFrmBaseDataConfig in '��������\���ܴ���\������������\uFrmBaseDataConfig.pas' {FrmBaseDataConfig},
  uFrmJWDMgr in '�����\���ܴ���\uFrmJWDMgr.pas' {FrmJWDMgr},
  uFrmJWDEdit in '�����\���ܴ���\uFrmJWDEdit.pas' {FrmJWDEdit},
  uArea in '�����\���ݶ���\uArea.pas',
  uDBArea in '�����\���ݿ����\uDBArea.pas',
  uFrmWorkShopMgr in '����\���ܴ���\uFrmWorkShopMgr.pas' {FrmWorkShopMgr},
  uFrmWorkShopEdit in '����\���ܴ���\uFrmWorkShopEdit.pas' {FrmWorkShopEdit},
  uFrmTrainJiaoLuMgr in '��·_�г�\���ܴ���\uFrmTrainJiaoLuMgr.pas' {FrmTrainJiaoLuMgr},
  uFrmTrainJiaoluEdit in '��·_�г�\���ܴ���\uFrmTrainJiaoluEdit.pas' {FrmTrainJiaoLuEdit},
  uFrmSiteMgr in '�ͻ�����Ϣ\���ܴ���\uFrmSiteMgr.pas' {FrmSiteMgr},
  uFrmSiteEdit in '�ͻ�����Ϣ\���ܴ���\uFrmSiteEdit.pas' {FrmSiteEdit},
  uFrmTrainJiaoluSel in '��·_�г�\���ܴ���\uFrmTrainJiaoluSel.pas' {FrmTrainJiaoSel},
  pcre in '��������\������ʽ\pcre.pas',
  PerlRegEx in '��������\������ʽ\PerlRegEx.pas',
  uSaftyEnum in 'ö������\���ݶ���\uSaftyEnum.pas',
  uFrmDutyUserMgr in '��¼\���ܴ���\uFrmDutyUserMgr.pas' {FrmDutyUserMgr},
  uFrmDutyUserEdit in '��¼\���ܴ���\uFrmDutyUserEdit.pas' {FrmDutyUserEdit},
  uCheckInputPubFun in '��������\uCheckInputPubFun.pas',
  uLCTrainPlan in '�г��ƻ�\web�ӿ�\uLCTrainPlan.pas',
  uTrainPlan in '�г��ƻ�\���ݶ���\uTrainPlan.pas',
  uFrmAutoCall_Insert in '�а����\���ܴ���\�Զ��а�\uFrmAutoCall_Insert.pas' {FrmAutoCall_Insert},
  uWebJob_SyncDic in '����ͬ��\���ܵ�Ԫ\ͬ������\�����ֵ�����\uWebJob_SyncDic.pas',
  uWebJob_SyncDic_Site in '����ͬ��\���ܵ�Ԫ\ͬ������\�����ֵ�����\uWebJob_SyncDic_Site.pas',
  uAudio in '�а����\���ܵ�Ԫ\��Ƶ����\uAudio.pas',
  uAudioXP in '�а����\���ܵ�Ԫ\��Ƶ����\uAudioXP.pas',
  uMMDevApi in '�а����\���ܵ�Ԫ\��Ƶ����\uMMDevApi.pas',
  uWebJob_SyncDic_Site_Limit in '����ͬ��\���ܵ�Ԫ\ͬ������\�����ֵ�����\uWebJob_SyncDic_Site_Limit.pas',
  uWebJob_SyncDic_Station in '����ͬ��\���ܵ�Ԫ\ͬ������\�����ֵ�����\uWebJob_SyncDic_Station.pas',
  uDBStation in '��վ\���ݿ����\uDBStation.pas',
  uWebJob_SyncDic_TrainJiaoLu in '����ͬ��\���ܵ�Ԫ\ͬ������\�����ֵ�����\uWebJob_SyncDic_TrainJiaoLu.pas',
  uWebJob_SyncDic_TrainJiaoLu_InSite in '����ͬ��\���ܵ�Ԫ\ͬ������\�����ֵ�����\uWebJob_SyncDic_TrainJiaoLu_InSite.pas',
  uWebJob_SyncDic_Area in '����ͬ��\���ܵ�Ԫ\ͬ������\�����ֵ�����\uWebJob_SyncDic_Area.pas',
  uWebJob_SyncDic_DutyUser in '����ͬ��\���ܵ�Ԫ\ͬ������\�����ֵ�����\uWebJob_SyncDic_DutyUser.pas',
  uWebJob_SyncDic_WorkShop in '����ͬ��\���ܵ�Ԫ\ͬ������\�����ֵ�����\uWebJob_SyncDic_WorkShop.pas',
  uFrmSyncBaseData in '����ͬ��\���ܴ���\uFrmSyncBaseData.pas' {FrmSyncBaseData},
  uFrmNotifyNotOutRoom in '������\���ܴ���\δ��Ԣ����\uFrmNotifyNotOutRoom.pas' {FrmNotifyNotOutRoom},
  uWebJob_LeaderInspect in '����ͬ��\���ܵ�Ԫ\ͬ������\�ϴ��ɲ���ڼ�¼\uWebJob_LeaderInspect.pas',
  uAutoRecallNoFrm in '�а����\���ܵ�Ԫ\�Զ��а�\uAutoRecallNoFrm.pas',
  uCallRoomFunIF in '�а����\���ܵ�Ԫ\�а๦�ܹ���\uCallRoomFunIF.pas',
  uFrmAddTrainmanRoomRelation in '������\���ܴ���\������Ա��ϵ\uFrmAddTrainmanRoomRelation.pas' {FrmAddTrainmanRoomRelation},
  uFrmRoomInfo in '������\���ܴ���\������Ա��ϵ\uFrmRoomInfo.pas' {FrmRoomInfo},
  uFrmTrainmanRoomInfo in '������\���ܴ���\������Ա��ϵ\uFrmTrainmanRoomInfo.pas' {FrmTrainmanRoomInfo},
  uDBSignPlan in '����ǩ��\���ݿ����\uDBSignPlan.pas',
  uFrmAutoCall in '�а����\���ܴ���\�Զ��а�\uFrmAutoCall.pas' {FrmAutoCall},
  uProgressCommFun in '����ͨ��\uProgressCommFun.pas',
  uFrmProgressEx in 'ͨ�ô���\���ȶԻ���\uFrmProgressEx.pas' {frmProgressEx},
  uFrmAbout in 'ͨ�ô���\����\uFrmAbout.pas' {frmAbout},
  uFrmAutoCloseQry in 'ͨ�ô���\�Զ��ر�ѯ�ʶԻ���\uFrmAutoCloseQry.pas' {FrmAutoCloseQry},
  ufrmQuestionBox in 'ͨ�ô���\ѯ�ʴ���\ufrmQuestionBox.pas' {FrmQuestionBox},
  uFrmRecordTel in '�绰¼��\uFrmRecordTel.pas' {FrmRecordTel},
  uDBTelRecord in '�绰¼��\���ݿ����\uDBTelRecord.pas',
  uFrmTelCallQuery in '�绰¼��\�绰¼����ѯ\uFrmTelCallQuery.pas' {FrmTelCallQuery},
  uRecordTelUtil in '�绰¼��\uRecordTelUtil.pas',
  brisdklib in '�绰¼��\���ݶ���\brisdklib.pas',
  uQNVControl in '�绰¼��\���ݶ���\uQNVControl.pas',
  uTelRecord in '�绰¼��\���ݶ���\uTelRecord.pas',
  uFrmEditWaitWorkJiNing in '������\���ܴ���\����ģʽ\���˼ƻ�\�༭���˼ƻ�\uFrmEditWaitWorkJiNing.pas' {FrmEditWaitWorkJiNing},
  uFrmJiNingTrainmanEdit in '������\���ܴ���\����ģʽ\��Ա����\������Ա\uFrmJiNingTrainmanEdit.pas' {FrmJiNingTrainmanEdit},
  uFrmSelectTrainman in 'ͨ�ô���\��Աѡ��\uFrmSelectTrainman.pas' {frmSelectTrainman},
  uFrmCreateWaitWorkPlan_JiNing in '������\���ܴ���\����ģʽ\���˼ƻ�\�������˼ƻ�\uFrmCreateWaitWorkPlan_JiNing.pas' {TFrmCreateWaitWorkPlan_JiNing},
  uFrmMunualCall2 in '�а����\���ܴ���\�˹��а�2\uFrmMunualCall2.pas' {FrmMunualCall2},
  uFrmSelectTrainman2 in 'ͨ�ô���\��Աѡ��2\uFrmSelectTrainman2.pas' {frmSelectTrainman2},
  ufrmTextInput2 in 'ͨ�ô���\����Ի���2\ufrmTextInput2.pas' {frmTextInput2},
  uFrmServerRoomManager in '�����ҹ���\uFrmServerRoomManager.pas' {FrmServerRoomManager},
  uFrmEditCallDev2 in '�����ҹ���\�а��豸\uFrmEditCallDev2.pas' {FrmEditCallDev2},
  uFrmServerRoomRelation in '�����ҹ���\��������\uFrmServerRoomRelation.pas' {FrmServerRoomRelation},
  uAutoServerRoomNoFrm in '�а����\���ܵ�Ԫ\�����Һ���\uAutoServerRoomNoFrm.pas',
  uFrmEditInRoom in '������\���ܴ���\����ģʽ\��Ԣ�Ǽ�\uFrmEditInRoom.pas' {FrmEditInRoom},
  uFrmJoinRoomManager in '������\���ܴ���\����ģʽ\��������\uFrmJoinRoomManager.pas' {FrmJoinRoomManager},
  uDrawMenu in '�˵��Ի�\uDrawMenu.pas',
  uTFSystem,
  uFrmModifyCallKaiCheTime in '������\���ܴ���\�༭���˼ƻ�\uFrmModifyCallKaiCheTime.pas' {FrmEditCallKaiCheTime},
  uFrmReverseCall_Insert in '�а����\���ܴ���\����ֵ��\uFrmReverseCall_Insert.pas' {FrmReverseCall_Insert},
  uFrmReverseCallManager in '����\uFrmReverseCallManager.pas' {FrmReverseCallManager},
  uFrmMunualMonitor in '�а����\���ܴ���\��������\uFrmMunualMonitor.pas' {FrmMunualMonitor};

{$R *.res}

var
  HMutex : DWord;
begin



  HMutex := CreateMutex(nil, TRUE, 'RunSaftyRoom'); //����Mutex���
  {-----���Mutex�����Ƿ���ڣ�������ڣ��˳�����------------}
  if (GetLastError = ERROR_ALREADY_EXISTS) then
  begin
    ReleaseMutex(hMutex); //�ͷ�Mutex����
    Exit;
  end;

  //ʱ���ʽ��
  TimeSeparator := ':';
  DateSeparator := '-';
  ShortDateFormat := 'yyyy-mm-dd';
  ShortTimeFormat := 'hh:nn:ss';

  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
  Application.Initialize;
  
  //��ȡӦ�ó���ı�������
  Application.Title := ReadIniFile(ExtractFilePath(ParamStr(0))+'Config.ini', 'sysConfig', 'AppTitle');
  if Application.Title = '' then
  begin
    Application.Title := '�а�ϵͳ';
  end;

  Application.CreateForm(TGlobalDM, GlobalDM);
  GlobalDM.LoadConfig;
  frmLogin := TfrmLogin.Create(nil);
  try
    if frmLogin.ShowModal = 1 then
    begin
      TfrmMain_RoomSign.EnterRoomSign;
    end;
  finally
    frmLogin.Free;
  end;
  
  Application.Run;
end.
