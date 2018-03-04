unit uFrmRoomInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, RzTabs,uWaitWorkMgr,uWaitWork,utfsystem,uFrmTrainmanRoomInfo;
type
  TFrmRoomInfo = class(TForm)
    lvRecord: TListView;
    Label1: TLabel;
    edtTrainmanNumber: TEdit;
    edtTrainmanName: TEdit;
    btnFind: TButton;
    Label2: TLabel;
    PageCtrlMain: TRzPageControl;
    tsTrainman: TRzTabSheet;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure lvRecordClick(Sender: TObject);
  private
    { Private declarations }
    //初始化数据
    procedure InitData();
    //创建子窗体
    procedure CreateSubForms();
    //显示到列表
    procedure RoomInfoToList();
    //获取房间号
    function GetSelRoomNumber():string;
  private
    //m_listRoomInfo : TRsRoomInfoArray ;
    RoomList: TWaitRoomList;
    //候班管理
    m_WaitMgr:TWaitWorkMgr;
    //人员房间管理
    m_FrmTrainmanRoomInfo : TFrmTrainmanRoomInfo;
  public
    { Public declarations }
    class procedure Manager();
  end;

var
  FrmRoomInfo: TFrmRoomInfo;

implementation

uses
  uGlobalDM,utfPopBox;

{$R *.dfm}

procedure TFrmRoomInfo.btnFindClick(Sender: TObject);
var
  strTrainmanNumber:string;
  strTrainmanName:string;
  strRoomNumber:string;
begin
  strTrainmanNumber := Trim(edtTrainmanNumber.Text);
  strTrainmanName := Trim(edtTrainmanName.Text) ;
  if ( strTrainmanNumber = '')  and ( strTrainmanName = '') then
    Exit ;
  if m_WaitMgr.dbTmRoomRel.QueryTrainmanRoomRelation(strTrainmanNumber,strTrainmanName,strRoomNumber) then
  begin
    TtfPopBox.ShowBox('房间号: ' + strRoomNumber);
  end;
end;



procedure TFrmRoomInfo.CreateSubForms;
begin
    {入寓离寓登记}
  m_FrmTrainmanRoomInfo := TFrmTrainmanRoomInfo.Create(nil);
  m_FrmTrainmanRoomInfo.Parent := tsTrainman ;
  m_FrmTrainmanRoomInfo.Show ;
end;

procedure TFrmRoomInfo.FormCreate(Sender: TObject);
var
  i : Integer ;
begin
  m_FrmTrainmanRoomInfo := nil;
  RoomList:= TWaitRoomList.Create;
  m_WaitMgr:=TWaitWorkMgr.GetInstance(nil);
 
  for I := 0 to PageCtrlMain.PageCount - 1 do
    PageCtrlMain.Pages[i].TabVisible := False;
  CreateSubForms ;
end;

procedure TFrmRoomInfo.FormDestroy(Sender: TObject);
begin
  //m_dbRoomInfo.Free ;
  RoomList.Free;
  if m_FrmTrainmanRoomInfo <> nil then
    m_FrmTrainmanRoomInfo.Free;
end;

function TFrmRoomInfo.GetSelRoomNumber: string;
begin
   Result := lvRecord.Selected.SubItems[0];
end;

procedure TFrmRoomInfo.InitData;
begin
  //SetLength(m_listRoomInfo,0);
  //m_dbRoomInfo.GetAllRoom(m_listRoomInfo);
  RoomList.Clear;
  m_WaitMgr.DBRoom.GetAll(RoomList);
  RoomInfoToList() ;
end;

procedure TFrmRoomInfo.lvRecordClick(Sender: TObject);
var
  strRoomNumber:string;
begin
  try
    if lvRecord.Items.Count = 0 then
      Exit ;

    if lvRecord.Selected.Data = nil then
      Exit;
    strRoomNumber := GetSelRoomNumber ;
    m_FrmTrainmanRoomInfo.InitData(strRoomNumber);
  except
   on e:Exception do
   begin
     ShowMessage(e.Message);
   end;
  end;
end;

class procedure TFrmRoomInfo.Manager;
var
  frm : TFrmRoomInfo ;
begin
  frm := TFrmRoomInfo.Create(nil);
  try
    frm.InitData;
    frm.ShowModal;
  finally
    frm.Free ;
  end;

end;

procedure TFrmRoomInfo.RoomInfoToList();
var
  i:Integer;
  listItem:TListItem;
begin
  lvRecord.Items.Clear;
  for I := 0 to RoomList.count - 1 do
  begin
    listItem := lvRecord.Items.Add;
    with listItem do
    begin
      Caption := inttostr(i+1) ;
      SubItems.Add(RoomList.Items[i].strRoomNum);
    end;
    listItem.Data := RoomList.Items[i];
  end; 
end;

end.
