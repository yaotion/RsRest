unit uFrmWaitTimeTable;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Mask, RzEdit, StdCtrls, ExtCtrls, RzPanel, ComCtrls,uFrmEditWaitTime,
  uWaitWork,uWaitWorkMgr,uTFSystem,uGlobalDM,ComObj,  ufrmProgressEx;

type
  TFrmWaitTimeTable = class(TForm)
    lvWaitTime: TListView;
    rzpnl1: TRzPanel;
    btnAdd: TButton;
    btnModfy: TButton;
    btnDel: TButton;
    btnImPort: TButton;
    dlgOpen1: TOpenDialog;
    btnDown: TButton;
    procedure btnAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnModfyClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnImPortClick(Sender: TObject);
    procedure lvWaitTimeDblClick(Sender: TObject);
  private
    //������
    m_waitMgr:TWaitWorkMgr;
    m_WaitTimeAry:TWaitTimeAry;
  private
    {����:ˢ��ʱ�̱�}
    procedure ReFresh();
    {����:���������}
    procedure fillLine(item:TListItem;waitTime:RWaitTime);
  public

  public
    {����:ͼ���������}
    class procedure ManageWaitRoomTable();
  end;
  {����:��ʾ}



implementation

uses
  utfPopBox,ufrmQuestionBox ;

{$R *.dfm}

{ TFrmWaitRoomTable }

procedure TFrmWaitTimeTable.btnAddClick(Sender: TObject);
var
  waitTime:RWaitTime;
begin
  if TFrmEditWaitTime.AddWaitTable(waitTime) = False then Exit;
  try
    m_waitMgr.DBWaitTime.Add(waitTime);
  except on e:exception do
    begin
      TtfPopBox.ShowBox('����ʧ��,ԭ��:' + e.Message);
      Exit;
    end;
  end;
  ReFresh();
end;

procedure TFrmWaitTimeTable.btnDelClick(Sender: TObject);
var
  item:TListItem;
  waitTime:RWaitTime;
begin
  item := lvWaitTime.Selected;
  if item = nil then
  begin
    TtfPopBox.ShowBox('δѡ����Ч��');
    Exit
  end;
  if tfMessageBox('ȷ��ɾ����?') = False then Exit;
  
  waitTime := m_WaitTimeAry[item.index];
  m_waitMgr.DBWaitTime.Delete(waitTime.strGUID);
  ReFresh();
end;

procedure TFrmWaitTimeTable.btnImPortClick(Sender: TObject);
var
  excelApp: Variant;
  nIndex,nTotalCount : integer;
  strTrainNo:string;
  waittime:RWaitTime;
begin
  if not dlgOpen1.Execute then exit;
  try
    excelApp := CreateOleObject('Excel.Application');
  except
    Application.MessageBox('�㻹û�а�װMicrosoft Excel,���Ȱ�װ��','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  
  try
    excelApp.Visible := false;
    excelApp.Caption := 'Ӧ�ó������ Microsoft Excel';
    excelApp.workBooks.Open(dlgOpen1.FileName);
    excelApp.Worksheets[1].activate;
    nIndex := 2;
    nTotalCount := 0;
    while true do
    begin
      strTrainNo := excelApp.Cells[nIndex,2].Value;
      if strTrainNo = '' then break;
      Inc(nTotalCount);
      Inc(nIndex);
    end;
    if nTotalCount = 0 then
    begin
       Application.MessageBox('û�пɵ���ĺ��ʱ�̱�','��ʾ',MB_OK + MB_ICONINFORMATION);
       exit;
    end;
    m_waitMgr.DBWaitTime.delAll();
    nIndex := 2;

    for nIndex := 2 to nTotalCount + 1 do      
    begin
      waittime.strGUID := NewGUID;
      waittime.strWorkshopGUID := excelApp.Cells[nIndex,1].Value;
      waittime.strWorkShopName := excelApp.Cells[nIndex,2].Value;
      waittime.strTrainJiaoLuGUID := excelApp.Cells[nIndex,3].Value;
      waittime.strTrainJiaoLuName := excelApp.Cells[nIndex,4].Value;
      waittime.strTrainJiaoLuNickName := excelApp.Cells[nIndex,5].Value;
      waittime.strTrainNo := excelApp.Cells[nIndex,6].Value;
      waittime.strRoomNum := excelApp.Cells[nIndex,7].Value;
      waittime.dtWaitTime := excelApp.Cells[nIndex,8].Value;
      waittime.dtCallTime := excelApp.Cells[nIndex,9].Value;
      waittime.dtChuQinTime := excelApp.Cells[nIndex,10].Value;
      waittime.dtKaiCheTime := excelApp.Cells[nIndex,11].Value;
      m_waitMgr.DBWaitTime.Add(waittime);
      TfrmProgressEx.ShowProgress('���ڵ���������Ժ�',nIndex - 1,nTotalCount);
    end;
  finally
    TfrmProgressEx.CloseProgress;
    excelApp.Quit;
    excelApp := Unassigned;
  end;
  Application.MessageBox('������ϣ�','��ʾ',MB_OK + MB_ICONINFORMATION);
  ReFresh();
end;

procedure TFrmWaitTimeTable.btnModfyClick(Sender: TObject);
var
  item:TListItem;
  waitTime:RWaitTime;
begin
  item := lvWaitTime.Selected;
  if item = nil then
  begin
    TtfPopBox.ShowBox('δѡ����Ч��');
    Exit
  end;
  waitTime := m_WaitTimeAry[item.index];
  if TFrmEditWaitTime.ModifyWaitTable(waitTime) = False then Exit;
  m_waitMgr.DBWaitTime.Modify(waitTime);
  ReFresh();
end;

procedure TFrmWaitTimeTable.fillLine(item: TListItem; waitTime: RWaitTime);
begin
  item.Caption := inttostr(item.Index+1);
//  item.SubItems.Add(waitTime.strWorkShopName);
//  item.SubItems.Add(waitTime.strTrainJiaoLuName);
//  item.SubItems.Add(waitTime.strTrainJiaoLuNickName);
  item.SubItems.Add(waitTime.strTrainNo);
  item.SubItems.Add(waitTime.strRoomNum);
  if waitTime.bMustSleep then
    item.SubItems.Add('��')
  else
    item.SubItems.Add('��');
  item.SubItems.Add(FormatDateTime('HH:mm',waitTime.dtWaitTime));
  item.SubItems.Add(FormatDateTime('HH:mm',waitTime.dtCallTime));
  item.SubItems.Add(FormatDateTime('HH:mm',waitTime.dtChuQinTime));
  item.SubItems.Add(FormatDateTime('HH:mm',waitTime.dtKaiCheTime));
end;

procedure TFrmWaitTimeTable.FormCreate(Sender: TObject);
begin
  m_waitMgr:=TWaitWorkMgr.GetInstance(GlobalDM.LocalADOConnection);
end;

procedure TFrmWaitTimeTable.FormShow(Sender: TObject);
begin
  ReFresh();
end;

procedure TFrmWaitTimeTable.lvWaitTimeDblClick(Sender: TObject);
begin
  btnModfyClick(Sender);
end;

class procedure TFrmWaitTimeTable.ManageWaitRoomTable;
var
  frm: TFrmWaitTimeTable;
begin
  frm:= TFrmWaitTimeTable.Create(nil);
  try
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;

procedure TFrmWaitTimeTable.ReFresh;
var
  i:Integer;
  nCount:Integer;
  item:TListItem;
begin
  m_waitMgr.DBWaitTime.GetAll(m_WaitTimeAry);
  nCount := Length(m_WaitTimeAry);
  lvWaitTime.Clear();
  for i := 0 to nCount - 1 do
  begin
    item :=lvWaitTime.Items.Add;
    fillLine(item,m_WaitTimeAry[i]);
  end;
    
end;

end.
