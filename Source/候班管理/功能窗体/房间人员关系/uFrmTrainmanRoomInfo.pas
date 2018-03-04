unit uFrmTrainmanRoomInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,utfsystem,uWaitWork,uWaitWorkMgr;

type
  TFrmTrainmanRoomInfo = class(TForm)
    lvRecord: TListView;
    btnAdd: TButton;
    btnModify: TButton;
    btnDel: TButton;
    Label2: TLabel;
    lbRoomNumber: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
  private
     // 显示到界面上
    procedure DataToListView(BedInfoArray:TRsBedInfoArray);
  private
    { Private declarations }
    m_WaitMgr:TWaitWorkMgr;
    //房间人员数组
    m_listBedInfo:TRsBedInfoArray ;
    //传入的房间号
    m_strRoomNumber:string;
  public
    { Public declarations }
    procedure InitData(RoomNumber:string);
  end;

var
  FrmTrainmanRoomInfo: TFrmTrainmanRoomInfo;

implementation

uses
  uGlobalDM ,utfPopBox,
  uFrmAddTrainmanRoomRelation,ufrmQuestionBox;

{$R *.dfm}

procedure TFrmTrainmanRoomInfo.btnAddClick(Sender: TObject);
var
  BedInfo:RRsBedInfo;
  strRoomNumber:string;
begin
  if not TFrmAddTrainmanRoomRelation.AddBedInfo(BedInfo) then
    Exit;
  if m_WaitMgr.DBTMRoomRel.IsHaveTrainmanRoomRelation(BedInfo.strTrainmanGUID,strRoomNumber) then
  begin
    TtfPopBox.ShowBox('该人员已经被安排在房间:【'+ strRoomNumber + '】');
    Exit
  end;
  
  if not m_WaitMgr.DBTMRoomRel.InsertTrainmanRoomRelation(m_strRoomNumber,BedInfo) then
    Exit;
  InitData(m_strRoomNumber) ;
end;

procedure TFrmTrainmanRoomInfo.btnDelClick(Sender: TObject);
var
  BedInfo:RRsBedInfo;
begin
  try
    if lvRecord.Selected = nil then
    begin
      TtfPopBox.ShowBox('请选中要删除的数据');
      Exit;
    end;
    if lvRecord.Selected.Data = nil then
      Exit;
    if not tfMessageBox('确认删除吗?') then
      Exit ;


    BedInfo := ( RRsBedInfoPointer (lvRecord.Selected.Data) )^;
    if m_WaitMgr.DBTMRoomRel.RemoveTrainmanRoomRelation(m_strRoomNumber,BedInfo) then
    begin
      InitData(m_strRoomNumber);
      TtfPopBox.ShowBox('删除成功');
    end;
  except
   on e:Exception do
   begin
     ShowMessage(e.Message);
   end;
  end;
end;

procedure TFrmTrainmanRoomInfo.DataToListView(BedInfoArray: TRsBedInfoArray);
var
  i:Integer;
  listItem:TListItem;
  strText:string;
begin
  lvRecord.Items.Clear;
  for I := 0 to Length(BedInfoArray) - 1 do
  begin
    listItem := lvRecord.Items.Add;
    with listItem do
    begin
      Caption := inttostr(i+1) ;
      //SubItems.Add( IntToStr(BedInfoArray[i].nBedNumber) );
      strText := Format('[%s]%s',[BedInfoArray[i].strTrainmanNumber,BedInfoArray[i].strTrainmanName]) ;
      SubItems.Add(strText);
    end;
    listItem.Data := Addr(BedInfoArray[i]);
  end;
end;

procedure TFrmTrainmanRoomInfo.FormCreate(Sender: TObject);
begin
  m_WaitMgr :=TWaitWorkMgr.GetInstance(nil);
  //m_dbRoomInfo := TRsDBAccessRoomInfo.Create(GlobalDM.LocalADOConnection);
end;

procedure TFrmTrainmanRoomInfo.FormDestroy(Sender: TObject);
begin
  //m_dbRoomInfo.Free ;
end;

procedure TFrmTrainmanRoomInfo.InitData(RoomNumber: string);
begin
  m_strRoomNumber := RoomNumber ;
  lbRoomNumber.Caption := RoomNumber ;
  SetLength(m_listBedInfo,0);
  m_WaitMgr.DBTMRoomRel.GetAllTrainmanRoomRelation(RoomNumber,m_listBedInfo);
  DataToListView(m_listBedInfo);
end;

end.
