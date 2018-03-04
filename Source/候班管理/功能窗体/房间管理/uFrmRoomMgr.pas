unit uFrmRoomMgr;

interface

uses
  CommCtrl, 
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, ComCtrls, RzListVw, Buttons, PngSpeedButton, Menus,
  ActnList,{uRoomSign,uBaseDBRoomSign,uDBRoomSign,}uDBLocalTrainman,utfsystem,uTrainman,uDBTrainman, RzStatus,
  Grids, StdCtrls, PngCustomButton, frxClass, frxDBSet, pngimage,uWaitWork,uWaitWorkMgr,
  uSaftyEnum,uPubFun, RzTabs,StrUtils;

type


  TFrmRoomMgr = class(TForm)
    rzpnl1: TRzPanel;
    actlst1: TActionList;
    tmrRefresh: TTimer;
    strGridRoom: TStringGrid;
    rzpnl2: TRzPanel;
    lb2: TLabel;
    lbInTime: TLabel;
    actPrint: TAction;
    frxUserDataSet: TfrxUserDataSet;
    frxReport1: TfrxReport;
    btnAddRoom: TPngCustomButton;
    btnDelRoom: TPngCustomButton;
    lb1: TLabel;
    btnChangeRoom: TPngCustomButton;
    ab1: TRzTabControl;
    Label1: TLabel;
    lbCallTime: TLabel;
    Image1: TImage;
    Image2: TImage;
    lbCount: TLabel;
    pMenu1: TPopupMenu;
    miClearUser: TMenuItem;
    procedure mniE1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmrRefreshTimer(Sender: TObject);
    procedure strGridRoomDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure strGridRoomSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure strGridRoomMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure frxUserDataSetGetValue(const VarName: string; var Value: Variant);
    procedure actPrintExecute(Sender: TObject);
    procedure frxReport1Preview(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnAddRoomClick(Sender: TObject);
    procedure mniExchangeRoomClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure pMenu1Popup(Sender: TObject);
    procedure btnDelRoomClick(Sender: TObject);
    procedure btnChangeRoomClick(Sender: TObject);
    procedure ab1Change(Sender: TObject);
    procedure miClearUserClick(Sender: TObject);
  private
    //
    function GetTrainmanNumber(NumberName:String):string;
    //��ȡѡ���еķ���
    function  GetSelectRoomNumber():string;
    //��ȡ�к�
    function  GetSelectColoumn():Integer ;
    //��ʾ������Ա��Ϣ
    procedure RoomInfoToList(RoomList:TWaitRoomList);
    {����:��ʽ����ʾ�ƻ���Ա��Ϣ}
    function FormatTrainmanNameNum(room: TWaitRoom;nIndex:Integer):string;
    {����:��ȡѡ�з����¼}
    function GetSelectedRoomInfo():TWaitRoom;
    {����:��ȡѡ�е���Ա}
    function GetSelectedWaitMan():TWaitWorkTrainmanInfo;
    {����:��ȡ�з����¼}
    function GetLineRoomInfo(nRow:Integer):TWaitRoom;
    {����:��ʾ��Ա��Ԣʱ��}
    procedure ShowInRoomTime(room: TWaitRoom;nTrainmanIndex:Integer);
    {����:ѡ����Ա}
    procedure FocusManCell(strNameNum:string);
     //���뷿���
    function InputRoomNum(strTitle:string;var strRoomNum:string):Boolean;
  public
    //���STRING_GRID
    procedure ClearGrid();
    //��ʼ��
    procedure InitData();
    //��ӡ
    procedure ShowReport();
    {����:ɾ������}
    procedure DelRoom();
  private
    { Private declarations }
    //���˹���
    m_WaitWorkMgr:TWaitWorkMgr;
    //������Ϣ�б�
    m_RoomList :TWaitRoomList;
    //¥���б�
    m_RoomFloorList:TRoomFloorList;
  public
    { Public declarations }
    procedure RefreshData;
  end;

var
  FrmRoomMgr: TFrmRoomMgr;

implementation




{$R *.dfm}

uses
  uGlobalDM, utfPopBox,ufrmQuestionBox ,
  ufrmTextInput;

{ TFrmRoomMgr }




procedure TFrmRoomMgr.ab1Change(Sender: TObject);
begin
  RoomInfoToList(m_RoomList);
end;

procedure TFrmRoomMgr.actPrintExecute(Sender: TObject);
begin
  ShowReport ;
end;



procedure TFrmRoomMgr.btnAddRoomClick(Sender: TObject);
var
  strRoomNum:string;
begin
  //if TextInput('���ӷ���','���뷿���',strRoomNum,'^[1-9][0-9][0-9]','����ű�����1λ��¥��+2λ�ķ�������') = True  then
  if InputRoomNum('���ӷ���',strRoomNum) = True then
  begin
    if m_WaitWorkMgr.bRoomExist(strRoomNum) then
    begin
      TtfPopBox.ShowBox(Format('����[%s]�Ѵ���!',[strRoomNum]));
      Exit;
    end;
    m_WaitWorkMgr.AddRoom(strRoomNum);
    InitData();
  end;
end;

procedure TFrmRoomMgr.btnChangeRoomClick(Sender: TObject);
begin
  mniExchangeRoomClick(nil);
end;

procedure TFrmRoomMgr.btnDelRoomClick(Sender: TObject);
begin
  DelRoom();
end;

procedure TFrmRoomMgr.btnRefreshClick(Sender: TObject);
begin
  InitData;
end;

procedure TFrmRoomMgr.ClearGrid;
var
  i : Integer ;
begin
  with strGridRoom do
  begin
    for I := 1 to RowCount - 1 do
    begin
      Rows[i].Clear;
    end;
    for i  := 1 to ColCount - 1 do
    begin
      ColWidths[i] := 250;
    end;

  end;

end;

procedure TFrmRoomMgr.DelRoom;
var
  room:TWaitRoom;
begin
  room := GetSelectedRoomInfo;
  if not Assigned(room) then
  begin
    TtfPopBox.ShowBox('��ѡ���޷�����Ϣ');
    Exit;
  end;
  if room.waitManList.Count <> 0 then
  begin
    TtfPopBox.ShowBox('��ѡ��������Ա��ס,����ɾ��!');
    Exit;
  end;
  if tfMessageBox('ȷ��ɾ���˷���?') = False then Exit;

  m_WaitWorkMgr.DelRoom(room.strRoomNum);
  InitData();
end;

procedure TFrmRoomMgr.FocusManCell(strNameNum:string);
var
  nRow,nCol:Integer;
begin
  for nRow := 1 to strGridRoom.RowCount - 1 do
  begin
    for nCol := 1 to strGridRoom.ColCount - 1 do
    begin
      if strGridRoom.Cells[nCol,nRow] = strNameNum then
      begin
        strGridRoom.Col := nCol;
        strGridRoom.Row := nRow;
        Exit;
      end;
    end;
  end;
end;

function TFrmRoomMgr.FormatTrainmanNameNum(room: TWaitRoom;
  nIndex: Integer): string;
var
  tmInfo:TWaitWorkTrainmanInfo;
begin
  result := '��';
  if room.waitManList.Count <= nIndex  then Exit;

  tmInfo :=  room.waitManList.Items[nIndex];
  if (tmInfo.eTMState  >=  psInRoom) and (tmInfo.eTMState  < psOutRoom) then
  begin
    //������Ų�Ϊ��
    if tmInfo.strTrainmanGUID <> '' then
    begin
      if GlobalDM.bShowTrainmNumber then
        result := Format('%s[%s]',[tmInfo.strTrainmanName,tmInfo.strTrainmanNumber])
      else
        result := Format('%s',[tmInfo.strTrainmanName])
    end
  end
  else
  begin
    result := Format('%s',[tmInfo.strTrainmanName]) ;
  end;

end;

procedure TFrmRoomMgr.FormCreate(Sender: TObject);
const
  STR_GRID_HEAD = 0 ;
var
  i:Integer;
  RoomFloor:TRoomFloor;
begin


  strGridRoom.Cells[0,STR_GRID_HEAD] := '����';
  strGridRoom.Cells[1,STR_GRID_HEAD] := '��λһ';
  strGridRoom.Cells[2,STR_GRID_HEAD] := '��λ��';
  strGridRoom.Cells[3,STR_GRID_HEAD] := '��λ��';
  strGridRoom.Cells[4,STR_GRID_HEAD] := '��λ��';

  
  m_WaitWorkMgr := TWaitWorkMgr.GetInstance(GlobalDM.LocalADOConnection);
  m_RoomList :=TWaitRoomList.create;
  m_RoomFloorList:=TRoomFloorList.Create;
  for i := 1 to 4 do
  begin
    RoomFloor:=TRoomFloor.Create;
    m_RoomFloorList.Add(RoomFloor);
    RoomFloor.strFloorNum := IntToStr(i);
  end;
    
  //InitData;
end;

procedure TFrmRoomMgr.FormDestroy(Sender: TObject);
begin
  m_RoomList.Free;
  m_RoomFloorList.Free;
end;

procedure TFrmRoomMgr.FormShow(Sender: TObject);
begin
  //InitData;
end;

procedure TFrmRoomMgr.frxReport1Preview(Sender: TObject);
begin
    frxUserDataSet.RangeEndCount := strGridRoom.RowCount - 1 ;
end;

procedure TFrmRoomMgr.frxUserDataSetGetValue(const VarName: string;
  var Value: Variant);
begin
  if VarName='1' then
  begin
    Value := strGridRoom.Cells[ 0,frxUserDataSet.RecNo + 1 ] ;
  end
  else  if VarName = '2' then
  begin
    Value := strGridRoom.Cells[ 1, frxUserDataSet.RecNo+ 1] ;
  end
  else  if VarName = '3' then
  begin
    Value := strGridRoom.Cells[ 2,frxUserDataSet.RecNo+ 1] ;
  end
  else  if VarName = '4' then
  begin
    Value := strGridRoom.Cells[ 3,frxUserDataSet.RecNo+ 1] ;
  end
end;

function TFrmRoomMgr.GetLineRoomInfo(nRow: Integer): TWaitRoom;
var
  strRoomNum:string;
begin
  result := nil;
  strRoomNum := strGridRoom.Cells[0,nRow];
  if strRoomNum <> '' then
  begin
    Result := m_RoomList.Find(strRoomNum);
  end;
  
//  if (nRow >0 )and  (nRow <= m_RoomList.Count )then
//  begin
//
//    result :=m_RoomList.Items[nRow-1];
//    Exit;
//  end;
end;

function TFrmRoomMgr.GetSelectColoumn: Integer;
begin
  Result := strGridRoom.Col ;
end;

function TFrmRoomMgr.GetSelectedRoomInfo: TWaitRoom;
var
  strRoomNum:string;
begin
  result := nil;
  //i :=strGridRoom.Row-1;
  strRoomNum := strGridRoom.cells[0,strGridRoom.Row];
  result := m_RoomList.Find(strRoomNum);
end;

function TFrmRoomMgr.GetSelectedWaitMan: TWaitWorkTrainmanInfo;
var
  room:TWaitRoom;
  nIndex:Integer;
begin
  result := nil;
  room :=GetSelectedRoomInfo();
  if room = nil  then Exit;
  with strGridRoom do
  begin
    nIndex := Col -1;
    if (nIndex >= 0) and (nIndex < room.waitManList.Count) then
    begin
      result:= room.waitManList.Items[nIndex];
    end;
  end;
end;

function TFrmRoomMgr.GetSelectRoomNumber: string;
var
  aRow:Integer ;
begin
  aRow := Self.strGridRoom.Row ;
  Result := strGridRoom.Cells[0,aRow] ;
end;


function TFrmRoomMgr.GetTrainmanNumber(NumberName: String): string;
var
  i : Integer ;
begin
  i := Pos(']',NumberName);
  Result := Copy(NumberName,2,i-2);
end;

procedure TFrmRoomMgr.InitData;
begin
  m_RoomList.clear;
  m_WaitWorkMgr.GetRoomWaitInfo(m_RoomList);
  RoomInfoToList(m_RoomList);
end;


function TFrmRoomMgr.InputRoomNum(strTitle:string; var strRoomNum: string): Boolean;
begin
  result := TPubfun.InputRoomNum(strTitle,strRoomNum);
end;

procedure TFrmRoomMgr.miClearUserClick(Sender: TObject);
begin
  BoxErr('aa');
end;

procedure TFrmRoomMgr.mniE1Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmRoomMgr.mniExchangeRoomClick(Sender: TObject);
var
  NewRoom,OldRoom:TWaitRoom;
  strRoomNum:string;
  waitMan:TWaitWorkTrainmanInfo;
  strNameNum:string;
begin
   OldRoom:=GetSelectedRoomInfo;
  if not Assigned(OldRoom) then
  begin
    TtfPopBox.ShowBox('��ѡ���޷�����Ϣ,�޷�����!');
    Exit;
  end;
  waitMan:= GetSelectedWaitMan;
  if waitMan = nil then
  begin
    TtfPopBox.ShowBox('δѡ����ס��Ա,�޷�����!');
    Exit;
  end;
  if InputRoomNum('��������',strRoomNum) = False then Exit;
  
  //if TextInput('��������','�����·������!',strRoomNum) = False then Exit;

  if m_WaitWorkMgr.bRoomExist(strRoomNum) = False then
  begin
    if tfMessageBox(Format('δ�ҵ�����[%s],�Ƿ����Ӵ˷���',[strRoomNum]))= False then Exit;
    m_WaitWorkMgr.AddRoom(strRoomNum);
  end;

  NewRoom := m_RoomList.Find(strRoomNum);

  if NewRoom.waitManList.Count = 4  then
  begin
    TtfPopBox.ShowBox(Format('Ŀ�귿��[%s]����Ա,����ʧ��!',[strRoomNum]));
    Exit;
  end;

  try
    waitMan.strRealRoom := strRoomNum;
    m_WaitWorkMgr.GetInOutRoomInfo(waitMan);
    waitMan.InRoomInfo.strRoomNumber := strRoomNum;
    m_WaitWorkMgr.SaveChangeRoomInfo(waitMan) ;
    strNameNum := TPubFun.FormatTMNameNum(waitMan.strTrainmanName,waitMan.strTrainmanNumber);
  except
    on e:Exception do
    begin
      TtfPopBox.ShowBox(e.Message);
    end;
  end;
  InitData();
  FocusManCell(strNameNum);
end;
{
procedure TFrmRoomMgr.mniExchangeRoomClick(Sender: TObject);
var
  NewRoom,OldRoom:TWaitRoom;
  strRoomNum:string;
  waitMan:TWaitWorkTrainmanInfo;
  strNameNum:string;
begin
  OldRoom:=GetSelectedRoomInfo;
  if not Assigned(OldRoom) then
  begin
    TtfPopBox.ShowBox('��ѡ���޷�����Ϣ,�޷�����!');
    Exit;
  end;
  waitMan:= GetSelectedWaitMan;
  if waitMan = nil then
  begin
    TtfPopBox.ShowBox('δѡ����ס��Ա,�޷�����!');
    Exit;
  end;
  if InputRoomNum('��������',strRoomNum) = False then Exit;
  
  //if TextInput('��������','�����·������!',strRoomNum) = False then Exit;

  if m_WaitWorkMgr.bRoomExist(strRoomNum) = False then
  begin
    if QuestionBox(Format('δ�ҵ�����[%s],�Ƿ����Ӵ˷���',[strRoomNum]))= False then Exit;
    m_WaitWorkMgr.AddRoom(strRoomNum);
  end;

  NewRoom := m_RoomList.Find(strRoomNum);

  if NewRoom.waitManList.Count = 4  then
  begin
    TtfPopBox.ShowBox(Format('Ŀ�귿��[%s]����Ա,����ʧ��!',[strRoomNum]));
    Exit;
  end;

  waitMan.strRealRoom := strRoomNum;
  m_WaitWorkMgr.DBWaitMan.Modify(waitMan);
  strNameNum := TPubFun.FormatTMNameNum(waitMan.strTrainmanName,waitMan.strTrainmanNumber);


  InitData();
  Application.ProcessMessages;
  FocusManCell(strNameNum);
end;   }


procedure TFrmRoomMgr.N2Click(Sender: TObject);
var
  room:TWaitRoom;
begin
  room := GetSelectedRoomInfo;
  if not Assigned(room) then
  begin
    TtfPopBox.ShowBox('��ѡ���޷�����Ϣ');
    Exit;
  end;
  {if Assigned(room.waitPlan )then
  begin
    TtfPopBox.ShowBox('��ѡ��������Ա��ס,����ɾ��!');
    Exit;
  end;   }
  m_WaitWorkMgr.DelRoom(room.strRoomNum);
  InitData();
end;

procedure TFrmRoomMgr.pMenu1Popup(Sender: TObject);
var
  room:TWaitRoom;
  waitMan:TWaitWorkTrainmanInfo;
begin
  room := GetSelectedRoomInfo;
//  if not Assigned(room) then  //����,
//  begin
//    pMenu1.Items[0].Enabled := False;
//  end
//  else
//  begin
//    waitMan := GetSelectedWaitMan;
//    if waitMan <> nil then //����,�����������
//    begin
//      pMenu1.Items[0].Enabled := True;
//    end
//    else
//    begin
//      pMenu1.Items[0].Enabled := False;
//    end;
//  end;
end;

procedure TFrmRoomMgr.RefreshData;
begin
  InitData;
end;

procedure TFrmRoomMgr.RoomInfoToList(RoomList:TWaitRoomList);
var
  strText:string;
  i : Integer ;
  nPersonCount :Integer ;
  room:TWaitRoom;
begin
  nPersonCount := 0 ;
  ClearGrid;
  m_RoomFloorList.ResetRoomInfo();
  with strGridRoom do
  begin
    RowCount := 2;
    for I := 0 to RoomList.Count - 1 do
    begin
      Application.ProcessMessages;
      room := RoomList.items[i];
      //strText := Format('�����:%s',[room.strRoomNum]);
      //OutputDebugString(pansichar(strText));
      m_RoomFloorList.AddRoom(room);

      if (ab1.TabIndex = 0 ) or( StrToInt(room.FloorNum) = ab1.TabIndex) then
      begin
        Cells[0,RowCount-1] :=  room.strRoomNum;
        Cells[1,RowCount-1] :=  FormatTrainmanNameNum(room,0);
        Cells[2,RowCount-1] :=  FormatTrainmanNameNum(room,1);
        Cells[3,RowCount-1] :=  FormatTrainmanNameNum(room,2);
        Cells[4,RowCount-1] :=  FormatTrainmanNameNum(room,3);


        //
        nPersonCount := nPersonCount + room.waitManList.Count;
        //strText := Format('¥��:%s,����:%d',[room.strRoomNum,room.waitManList.Count]);
        //OutputDebugString(pansichar(strText));
        RowCount := RowCount + 1;
        Application.ProcessMessages;
      end;
    end;
  end;
  //��ʾ������
  lbCount.Caption := Format(' %d ',[nPersonCount])  ;
  for i := 0 to m_RoomFloorList.Count - 1 do
  begin
    ab1.Tabs.Items[i+1].Caption := m_RoomFloorList.Items[i].FmtFloorInfo;
  end;
  ab1.Tabs.Items[0].Caption := m_RoomFloorList.FmtTotalFloorInfo;

end;

procedure TFrmRoomMgr.ShowInRoomTime(room: TWaitRoom;
  nTrainmanIndex: Integer);
var
  inRoomInfo:RRSInOutRoomInfo;
  tmInfo:TWaitWorkTrainmanInfo;
begin
  if nTrainmanIndex >= room.waitManList.Count  then
  begin
    lbInTime.caption := '';
    Exit;
  end;

  tmInfo := room.waitManList.Items[nTrainmanIndex];

  m_WaitWorkMgr.GetInOutRoomInfo(tmInfo);
  inRoomInfo := tmInfo.InRoomInfo;
  if (inRoomInfo.strGUID = '') then
  begin
    lbInTime.Caption := '';
  end
  else
  begin
    lbInTime.Caption := FormatDateTime('yyyy-mm-dd HH:mm:ss',inRoomInfo.dtInOutRoomTime);
    //���ӽа�ʱ��
    lbCallTime.Caption := FormatDateTime('yyyy-mm-dd HH:mm:ss',inRoomInfo.dtCallTime);
  end;


end;

procedure TFrmRoomMgr.ShowReport;
var
  mv: TfrxMemoView;
begin
  mv := frxReport1.FindObject('mmoRoomNumber') as TfrxMemoView;
  if mv <> nil then
    mv.Text := '�����' ;

  mv := frxReport1.FindObject('mmoBedNumber1') as TfrxMemoView;
  if mv <> nil then
    mv.Text := '��λһ' ;

  mv := frxReport1.FindObject('mmoBedNumber2') as TfrxMemoView;
  if mv <> nil then
    mv.Text := '��λ��' ;

  mv := frxReport1.FindObject('mmoBedNumber3') as TfrxMemoView;
  if mv <> nil then
    mv.Text := '��λ��' ;
  mv := frxReport1.FindObject('mmoBedNumber4') as TfrxMemoView;
  if mv <> nil then
    mv.Text := '��λ��' ;

  self.frxReport1.ShowReport(True);
end;


procedure TFrmRoomMgr.strGridRoomDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
const
  FIRST_BED_NUMBER = 0 ;
  SECOND_BED_NUMBER = 1 ;
  THIRD_BED_NUMBER = 1 ;
var
  strHead:string;
  strTxt:string ;
begin
  with strGridRoom do
  begin
    if ARow = 0 then
    begin
      case ACol of
       0 :
       begin
        strHead := '����';
       end;
       1:begin
        strHead := '��λһ';
       end;
       2:begin
        strHead := '��λ��';
       end;
       3:begin
        strHead := '��λ��';
       end;
       4:begin
        strHead := '��λ��';
       end;
      end;
      Canvas.Rectangle(Rect);
      Canvas.Brush.Style := bsClear;
      strTxt := Cells[acol,arow] ;
      Canvas.TextRect(Rect,strTxt,[tfCenter,tfSingleLine,tfVerticalCenter]);
    end;
    if (ARow <> 0)  then
    begin
      case ACol of
        0 :
        begin
          Canvas.Brush.Color :=  clYellow;
        end;
        1:
        begin
          Canvas.Brush.Color :=  RGB(179,255,179);
        end;
        2:
        begin
          Canvas.Brush.Color :=  RGB(242,252,152);
        end;
        3:
        begin
          Canvas.Brush.Color := RGB(255,176,176) ;
        end;
        4:
        begin
          Canvas.Brush.Color := RGB(200,220,176) ;
        end;
        else
          begin
            Exit;
          end;

      end;
      Canvas.Pen.Style := psClear;

      if [gdFocused, gdSelected] * State<>[] then
      begin
        Canvas.Brush.Color := clHighlight;
      end;

      Canvas.Rectangle(Rect);
      Canvas.Brush.Style := bsClear;
      strTxt := Cells[acol,arow] ;
      //Canvas.Font.Color := clWhite ;
      Canvas.TextRect(Rect,strTxt,[tfCenter,tfSingleLine,tfVerticalCenter]);
    end;
   end;

end;

procedure TFrmRoomMgr.strGridRoomMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if mbRight = Button  then

    strGridRoom.Perform(WM_LBUTTONDOWN,0,MakelParam(x,y));
end;

procedure TFrmRoomMgr.strGridRoomSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  room:TWaitRoom;
  strTrainmanNumber:string;
begin
  lbInTime.Caption := '';
  if ( ACol = 1 )  or
     ( ACol = 2 )or
    ( ACol = 3 )or
    (ACol = 4)
  then
  begin
    room := GetLineRoomInfo(ARow);
    if not Assigned(room) then Exit;
    ShowInRoomTime(room,ACol -1);
    Exit;
    
    strTrainmanNumber := strGridRoom.Cells[ACol,ARow];
    if strTrainmanNumber = '��' then
    begin
      lbInTime.Caption := '';
      Exit;
    end;
    strTrainmanNumber := GetTrainmanNumber(strTrainmanNumber) ;

  end
  

end;

procedure TFrmRoomMgr.tmrRefreshTimer(Sender: TObject);
begin
  InitData();
end;

end.
