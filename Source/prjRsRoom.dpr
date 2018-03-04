program prjRsRoom;

{%File 'uDebug.inc'}

uses
  Forms,
  SysUtils,
  windows,
  uFrmLogin in '登录\功能窗体\uFrmLogin.pas' {frmLogin},
  uDutyUser in '登录\数据定义\uDutyUser.pas',
  uGlobalDM in 'uGlobalDM.pas' {GlobalDM: TDataModule},
  uDBDutyUser in '登录\数据库操作\uDBDutyUser.pas',
  uDutyPlace in '出勤点\数据定义\uDutyPlace.pas',
  uDBSite in '客户端信息\数据库操作\uDBSite.pas',
  uSite in '客户端信息\数据定义\uSite.pas',
  uTrainJiaolu in '交路_行车\数据定义\uTrainJiaolu.pas',
  uTrainmanJiaolu in '交路_人员\数据定义\uTrainmanJiaolu.pas',
  uStation in '车站\uStation.pas',
  uRsInterfaceDefine in '服务\数据定义\uRsInterfaceDefine.pas',
  uRunEvent in '事件\数据定义\uRunEvent.pas',
  uDBTrainman in '人员\数据库操作\uDBTrainman.pas',
  uClientAppInfo in '客户端信息\数据定义\uClientAppInfo.pas',
  uLogs in '日志\uLogs.pas',
  uTrainman in '人员\数据定义\uTrainman.pas',
  uLogManage in '日志\uLogManage.pas',
  uHttpComm in 'web接口\uHttpComm.pas',
  uWebIF in 'web接口\uWebIF.pas',
  uGenericData in 'Json\uGenericData.pas',
  superobject in 'Json\superobject.pas',
  uLocalTrainman in '人员\数据定义\uLocalTrainman.pas',
  uDBLocalTrainman in '人员\数据库操作\uDBLocalTrainman.pas',
  uFrmMain_RoomSign in 'uFrmMain_RoomSign.pas' {frmMain_RoomSign},
  uWaitWorkMgr in '候班管理\uWaitWorkMgr.pas',
  uWaitWork in '候班管理\数据定义\uWaitWork.pas',
  uPubFun in '公共函数\uPubFun.pas',
  uDBWaitWork in '候班管理\数据库操作\uDBWaitWork.pas',
  uRoomSignConfig in '本地配置\逻辑单元\uRoomSignConfig.pas',
  uFrmWaitWorkPlanMgr in '候班管理\功能窗体\候班计划显示\uFrmWaitWorkPlanMgr.pas' {FrmWaitWorkPlanMgr},
  uFrmEditWaitWork in '候班管理\功能窗体\编辑待乘计划\uFrmEditWaitWork.pas' {FrmEditWaitWork},
  uFrmQueryWaitRecord in '候班管理\功能窗体\查询待乘记录\uFrmQueryWaitRecord.pas' {FrmQueryWaitRecord},
  uFrmCreateWaitWorkPlan in '候班管理\功能窗体\创建待乘计划\uFrmCreateWaitWorkPlan.pas' {FrmCreateWaitWorkPlan},
  uFrmLoadWaitPlan in '候班管理\功能窗体\加载待乘计划\uFrmLoadWaitPlan.pas' {FrmLoadWaitPlan},
  uFrmMatchWaitMan in '候班管理\功能窗体\匹配签点候班人员\uFrmMatchWaitMan.pas' {FrmMatchWaitMan},
  uFrmSelWaitTrainNo in '候班管理\功能窗体\选择候班车次\uFrmSelWaitTrainNo.pas' {FrmSelWaitTrainNo},
  uFrmSetTrainmanPlan in '候班管理\功能窗体\指定待乘计划\uFrmSetTrainmanPlan.pas' {FrmSetTrainmanPlan},
  uDBWorkShop in '车间\数据库操作\uDBWorkShop.pas',
  uWorkShop in '车间\数据定义\uWorkShop.pas',
  uDBTrainJiaolu in '交路_行车\数据库操作\uDBTrainJiaolu.pas',
  uFrmSelectColumn in 'AdvGrid\功能窗口\uFrmSelectColumn.pas' {frmSelectColumn},
  uStrGridUtils in 'AdvGrid\功能单元\uStrGridUtils.pas',
  uFrmModifyCallWorkTime in '候班管理\功能窗体\编辑待乘计划\uFrmModifyCallWorkTime.pas' {FrmEditCallWorkTime},
  uFrmMunualCall in '叫班管理\功能窗体\人工叫班\uFrmMunualCall.pas' {FrmMunualCall},
  uRoomCallApp in '叫班管理\功能单元\uRoomCallApp.pas',
  uRoomCall in '叫班管理\数据定义\叫班对象\uRoomCall.pas',
  uCallControl in '叫班管理\功能单元\叫班通讯\uCallControl.pas',
  uCallUtils in '叫班管理\功能单元\叫班通讯\uCallUtils.pas',
  uRoomCallOp in '叫班管理\功能单元\叫班通讯\uRoomCallOp.pas',
  uMixerRecord in '叫班管理\功能单元\录音功能\uMixerRecord.pas',
  uRoomCallMsgDefine in '叫班管理\数据定义\公寓叫班消息定义\uRoomCallMsgDefine.pas',
  uLCSignPlan in '退勤签点\逻辑单元\WebIF\uLCSignPlan.pas',
  uBaseWebInterface in 'web接口\uBaseWebInterface.pas',
  uHttpCom in 'web接口\uHttpCom.pas',
  uSignPlan in '退勤签点\功能单元\uSignPlan.pas',
  uFrmRoomSync in '数据同步\功能窗体\uFrmRoomSync.pas' {FrmRoomSync},
  uUPDateThread in '数据同步\功能单元\同步线程\uUPDateThread.pas',
  uWebJob_TrainmanSync in '数据同步\功能单元\同步任务\同步乘务员信息\uWebJob_TrainmanSync.pas',
  uTrainmanSync in '数据同步\功能单元\同步任务\同步乘务员信息\uTrainmanSync.pas',
  uSerializable in '数据同步\功能单元\同步任务\同步乘务员信息\uSerializable.pas',
  uWebJob_InOutRoom in '数据同步\功能单元\同步任务\上传出入寓记录\uWebJob_InOutRoom.pas',
  uHttpDataUpdateMgr in '数据同步\功能单元\同步任务\任务管理\uHttpDataUpdateMgr.pas',
  uRunSaftyMessageDefine in '消息\数据定义\uRunSaftyMessageDefine.pas',
  uFrmWaitTimeTable in '候班管理\功能窗体\候班时刻表\uFrmWaitTimeTable.pas' {FrmWaitTimeTable},
  uFrmEditWaitTime in '候班管理\功能窗体\候班时刻表\uFrmEditWaitTime.pas' {FrmEditWaitTime},
  ufrmCallConfig in '叫班管理\功能窗体\叫班配置\ufrmCallConfig.pas' {frmCallConfig},
  uFrmCallDevMgr in '叫班管理\功能窗体\叫班设备\uFrmCallDevMgr.pas' {FrmCallDevMgr},
  uFrmEditCallDev in '叫班管理\功能窗体\叫班设备\uFrmEditCallDev.pas' {FrmEditCallDev},
  uFrmCallPlan in '叫班管理\功能窗体\叫班计划\uFrmCallPlan.pas' {FrmCallPlan},
  uFrmEditCallPlan in '叫班管理\功能窗体\叫班计划\uFrmEditCallPlan.pas' {FrmEditCallPlan},
  UFrmRecvCallNotify in '叫班管理\功能窗体\叫班通知\UFrmRecvCallNotify.pas' {FrmRecvCallNotify},
  uFrmSendNodityCall in '叫班管理\功能窗体\叫班通知\uFrmSendNodityCall.pas' {FrmSendNotifyCall},
  uCallRecord in '叫班管理\数据定义\叫班记录\uCallRecord.pas',
  uCallNotify in '叫班管理\数据定义\叫班通知\uCallNotify.pas',
  uDBRoomCall in '叫班管理\数据库操作\叫班对象\uDBRoomCall.pas',
  uDBCallNotify in '叫班管理\数据库操作\叫班通知\uDBCallNotify.pas',
  uFrmQueryCallRecord in '叫班管理\功能窗体\叫班记录\uFrmQueryCallRecord.pas' {FrmQueryCallRecord},
  uFrmWaitPlanLoadTimeSet in '叫班管理\功能窗体\叫班计划\uFrmWaitPlanLoadTimeSet.pas' {FrmWaitWorkPlanLoadTimeSet},
  uFrmRoomMgr in '候班管理\功能窗体\房间管理\uFrmRoomMgr.pas' {FrmRoomMgr},
  ufrmAccessReadFingerprintTemplates in '人员\功能窗体\加载人员进度\ufrmAccessReadFingerprintTemplates.pas' {frmAccessReadFingerprintTemplates},
  uFrmLeaderInspect in '候班管理\功能窗体\干部查岗\uFrmLeaderInspect.pas' {FrmLeaderInspect},
  uLeaderExam in '候班管理\数据定义\uLeaderExam.pas',
  uFrmGetInput in '候班管理\功能窗体\干部查岗\uFrmGetInput.pas' {FrmGetInput},
  uDBLeaderInspect in '候班管理\数据库操作\uDBLeaderInspect.pas',
  utfPopBox in '通用窗体\自动关闭无焦点对话框\utfPopBox.pas' {tfPopBox},
  ufrmTextInput in '通用窗体\输入对话框\ufrmTextInput.pas' {frmTextInput},
  ufrmTimeRange in '通用窗体\时段选择对话框\ufrmTimeRange.pas' {frmTuDingTimeRange},
  ufrmHint in '通用窗体\信息提示对话框\ufrmHint.pas' {frmHint},
  uFrmTrainmanManage in '人员\功能窗体\人员管理\uFrmTrainmanManage.pas' {frmTrainmanManage},
  ufrmUserInfoEdit in '人员\功能窗体\人员管理\ufrmUserInfoEdit.pas' {frmUserInfoEdit},
  uDBGuideGroup in '人员\数据库操作\uDBGuideGroup.pas',
  uGuideGroup in '人员\数据定义\uGuideGroup.pas',
  ufrmTrainmanIdentityAccess in '人员\功能窗体\人员登记\ufrmTrainmanIdentityAccess.pas' {FrmTrainmanIdentityAccess},
  ufrmCamer in '通用窗体\拍照\ufrmCamer.pas' {frmCamera: TFrame},
  ufrmgather in '通用窗体\拍照\ufrmgather.pas' {frmPictureGather},
  ufrmFingerRegister in '通用窗体\指纹注册\ufrmFingerRegister.pas' {frmFingerRegister},
  ufrmConfig in '本地配置\功能窗体\登录配置\ufrmConfig.pas' {frmConfig},
  uFrmRoomSign_Config in '本地配置\功能窗体\同步配置\uFrmRoomSign_Config.pas' {FrmRoomSign_Config},
  uFrmRoomSignSysConfig in '本地配置\功能窗体\同步配置\uFrmRoomSignSysConfig.pas' {FrmRoomSignsSysConfig},
  ufrmTrainmanPicFigEdit in '人员\功能窗体\人员管理\ufrmTrainmanPicFigEdit.pas' {FrmTrainmanPicFigEdit},
  uDBCLientApp in '客户端信息\数据库操作\uDBCLientApp.pas',
  uFrmBaseDataConfig in '本地配置\功能窗体\基础数据配置\uFrmBaseDataConfig.pas' {FrmBaseDataConfig},
  uFrmJWDMgr in '机务段\功能窗体\uFrmJWDMgr.pas' {FrmJWDMgr},
  uFrmJWDEdit in '机务段\功能窗体\uFrmJWDEdit.pas' {FrmJWDEdit},
  uArea in '机务段\数据定义\uArea.pas',
  uDBArea in '机务段\数据库操作\uDBArea.pas',
  uFrmWorkShopMgr in '车间\功能窗体\uFrmWorkShopMgr.pas' {FrmWorkShopMgr},
  uFrmWorkShopEdit in '车间\功能窗体\uFrmWorkShopEdit.pas' {FrmWorkShopEdit},
  uFrmTrainJiaoLuMgr in '交路_行车\功能窗体\uFrmTrainJiaoLuMgr.pas' {FrmTrainJiaoLuMgr},
  uFrmTrainJiaoluEdit in '交路_行车\功能窗体\uFrmTrainJiaoluEdit.pas' {FrmTrainJiaoLuEdit},
  uFrmSiteMgr in '客户端信息\功能窗体\uFrmSiteMgr.pas' {FrmSiteMgr},
  uFrmSiteEdit in '客户端信息\功能窗体\uFrmSiteEdit.pas' {FrmSiteEdit},
  uFrmTrainJiaoluSel in '交路_行车\功能窗体\uFrmTrainJiaoluSel.pas' {FrmTrainJiaoSel},
  pcre in '公共函数\正则表达式\pcre.pas',
  PerlRegEx in '公共函数\正则表达式\PerlRegEx.pas',
  uSaftyEnum in '枚举类型\数据定义\uSaftyEnum.pas',
  uFrmDutyUserMgr in '登录\功能窗体\uFrmDutyUserMgr.pas' {FrmDutyUserMgr},
  uFrmDutyUserEdit in '登录\功能窗体\uFrmDutyUserEdit.pas' {FrmDutyUserEdit},
  uCheckInputPubFun in '公共函数\uCheckInputPubFun.pas',
  uLCTrainPlan in '行车计划\web接口\uLCTrainPlan.pas',
  uTrainPlan in '行车计划\数据定义\uTrainPlan.pas',
  uFrmAutoCall_Insert in '叫班管理\功能窗体\自动叫班\uFrmAutoCall_Insert.pas' {FrmAutoCall_Insert},
  uWebJob_SyncDic in '数据同步\功能单元\同步任务\下载字典数据\uWebJob_SyncDic.pas',
  uWebJob_SyncDic_Site in '数据同步\功能单元\同步任务\下载字典数据\uWebJob_SyncDic_Site.pas',
  uAudio in '叫班管理\功能单元\音频控制\uAudio.pas',
  uAudioXP in '叫班管理\功能单元\音频控制\uAudioXP.pas',
  uMMDevApi in '叫班管理\功能单元\音频控制\uMMDevApi.pas',
  uWebJob_SyncDic_Site_Limit in '数据同步\功能单元\同步任务\下载字典数据\uWebJob_SyncDic_Site_Limit.pas',
  uWebJob_SyncDic_Station in '数据同步\功能单元\同步任务\下载字典数据\uWebJob_SyncDic_Station.pas',
  uDBStation in '车站\数据库操作\uDBStation.pas',
  uWebJob_SyncDic_TrainJiaoLu in '数据同步\功能单元\同步任务\下载字典数据\uWebJob_SyncDic_TrainJiaoLu.pas',
  uWebJob_SyncDic_TrainJiaoLu_InSite in '数据同步\功能单元\同步任务\下载字典数据\uWebJob_SyncDic_TrainJiaoLu_InSite.pas',
  uWebJob_SyncDic_Area in '数据同步\功能单元\同步任务\下载字典数据\uWebJob_SyncDic_Area.pas',
  uWebJob_SyncDic_DutyUser in '数据同步\功能单元\同步任务\下载字典数据\uWebJob_SyncDic_DutyUser.pas',
  uWebJob_SyncDic_WorkShop in '数据同步\功能单元\同步任务\下载字典数据\uWebJob_SyncDic_WorkShop.pas',
  uFrmSyncBaseData in '数据同步\功能窗体\uFrmSyncBaseData.pas' {FrmSyncBaseData},
  uFrmNotifyNotOutRoom in '候班管理\功能窗体\未离寓提醒\uFrmNotifyNotOutRoom.pas' {FrmNotifyNotOutRoom},
  uWebJob_LeaderInspect in '数据同步\功能单元\同步任务\上传干部查岗记录\uWebJob_LeaderInspect.pas',
  uAutoRecallNoFrm in '叫班管理\功能单元\自动叫班\uAutoRecallNoFrm.pas',
  uCallRoomFunIF in '叫班管理\功能单元\叫班功能管理\uCallRoomFunIF.pas',
  uFrmAddTrainmanRoomRelation in '候班管理\功能窗体\房间人员关系\uFrmAddTrainmanRoomRelation.pas' {FrmAddTrainmanRoomRelation},
  uFrmRoomInfo in '候班管理\功能窗体\房间人员关系\uFrmRoomInfo.pas' {FrmRoomInfo},
  uFrmTrainmanRoomInfo in '候班管理\功能窗体\房间人员关系\uFrmTrainmanRoomInfo.pas' {FrmTrainmanRoomInfo},
  uDBSignPlan in '退勤签点\数据库操作\uDBSignPlan.pas',
  uFrmAutoCall in '叫班管理\功能窗体\自动叫班\uFrmAutoCall.pas' {FrmAutoCall},
  uProgressCommFun in '进程通信\uProgressCommFun.pas',
  uFrmProgressEx in '通用窗体\进度对话框\uFrmProgressEx.pas' {frmProgressEx},
  uFrmAbout in '通用窗体\关于\uFrmAbout.pas' {frmAbout},
  uFrmAutoCloseQry in '通用窗体\自动关闭询问对话框\uFrmAutoCloseQry.pas' {FrmAutoCloseQry},
  ufrmQuestionBox in '通用窗体\询问窗口\ufrmQuestionBox.pas' {FrmQuestionBox},
  uFrmRecordTel in '电话录音\uFrmRecordTel.pas' {FrmRecordTel},
  uDBTelRecord in '电话录音\数据库操作\uDBTelRecord.pas',
  uFrmTelCallQuery in '电话录音\电话录音查询\uFrmTelCallQuery.pas' {FrmTelCallQuery},
  uRecordTelUtil in '电话录音\uRecordTelUtil.pas',
  brisdklib in '电话录音\数据定义\brisdklib.pas',
  uQNVControl in '电话录音\数据定义\uQNVControl.pas',
  uTelRecord in '电话录音\数据定义\uTelRecord.pas',
  uFrmEditWaitWorkJiNing in '候班管理\功能窗体\集宁模式\待乘计划\编辑待乘计划\uFrmEditWaitWorkJiNing.pas' {FrmEditWaitWorkJiNing},
  uFrmJiNingTrainmanEdit in '候班管理\功能窗体\集宁模式\人员管理\增加人员\uFrmJiNingTrainmanEdit.pas' {FrmJiNingTrainmanEdit},
  uFrmSelectTrainman in '通用窗体\人员选择\uFrmSelectTrainman.pas' {frmSelectTrainman},
  uFrmCreateWaitWorkPlan_JiNing in '候班管理\功能窗体\集宁模式\待乘计划\创建待乘计划\uFrmCreateWaitWorkPlan_JiNing.pas' {TFrmCreateWaitWorkPlan_JiNing},
  uFrmMunualCall2 in '叫班管理\功能窗体\人工叫班2\uFrmMunualCall2.pas' {FrmMunualCall2},
  uFrmSelectTrainman2 in '通用窗体\人员选择2\uFrmSelectTrainman2.pas' {frmSelectTrainman2},
  ufrmTextInput2 in '通用窗体\输入对话框2\ufrmTextInput2.pas' {frmTextInput2},
  uFrmServerRoomManager in '服务室管理\uFrmServerRoomManager.pas' {FrmServerRoomManager},
  uFrmEditCallDev2 in '服务室管理\叫班设备\uFrmEditCallDev2.pas' {FrmEditCallDev2},
  uFrmServerRoomRelation in '服务室管理\下属房间\uFrmServerRoomRelation.pas' {FrmServerRoomRelation},
  uAutoServerRoomNoFrm in '叫班管理\功能单元\服务室呼叫\uAutoServerRoomNoFrm.pas',
  uFrmEditInRoom in '候班管理\功能窗体\集宁模式\入寓登记\uFrmEditInRoom.pas' {FrmEditInRoom},
  uFrmJoinRoomManager in '候班管理\功能窗体\集宁模式\关联房间\uFrmJoinRoomManager.pas' {FrmJoinRoomManager},
  uDrawMenu in '菜单自绘\uDrawMenu.pas',
  uTFSystem,
  uFrmModifyCallKaiCheTime in '候班管理\功能窗体\编辑待乘计划\uFrmModifyCallKaiCheTime.pas' {FrmEditCallKaiCheTime},
  uFrmReverseCall_Insert in '叫班管理\功能窗体\反呼值班\uFrmReverseCall_Insert.pas' {FrmReverseCall_Insert},
  uFrmReverseCallManager in '反呼\uFrmReverseCallManager.pas' {FrmReverseCallManager},
  uFrmMunualMonitor in '叫班管理\功能窗体\监听房间\uFrmMunualMonitor.pas' {FrmMunualMonitor};

{$R *.res}

var
  HMutex : DWord;
begin



  HMutex := CreateMutex(nil, TRUE, 'RunSaftyRoom'); //创建Mutex句柄
  {-----检测Mutex对象是否存在，如果存在，退出程序------------}
  if (GetLastError = ERROR_ALREADY_EXISTS) then
  begin
    ReleaseMutex(hMutex); //释放Mutex对象
    Exit;
  end;

  //时间格式化
  TimeSeparator := ':';
  DateSeparator := '-';
  ShortDateFormat := 'yyyy-mm-dd';
  ShortTimeFormat := 'hh:nn:ss';

  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
  Application.Initialize;
  
  //读取应用程序的标题配置
  Application.Title := ReadIniFile(ExtractFilePath(ParamStr(0))+'Config.ini', 'sysConfig', 'AppTitle');
  if Application.Title = '' then
  begin
    Application.Title := '叫班系统';
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
