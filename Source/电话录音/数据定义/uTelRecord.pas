unit uTelRecord;

interface

uses
    Classes,SysUtils,Contnrs;

type

  {电话录音记录类}
  TTelRecord =  class(TPersistent)
  private
    m_nId: integer;
    m_strGUID: string;
    {对方电话}
    m_strDestTel: string;
    {当前值班员信息}
    m_strUserNumber: string;
    m_strUserName: string;
    {文件名字}
    m_strFileName: string;
    {建立时间}
    m_dtCreateTime: tdatetime;
    {录音开始时间和结束时间}
    m_dtStartTime: tdatetime;
    m_dtEndTime: tdatetime;
    {呼叫方向}
    m_nCallDirection : integer;{0=主动,1被动}

    {是否接通}
    m_bIsDialed :boolean ;

    m_strRemark:string; {备注}
  public
    {功能清空}
    procedure Clear();
  published
    property nId: integer read m_nId write m_nId;
    property strGUID: string read m_strGUID write m_strGUID;
    property strDestTel: string read m_strDestTel write m_strDestTel;
    property strUserNumber: string read m_strUserNumber write m_strUserNumber;
    property strUserName: string read m_strUserName write m_strUserName;
    property strFileName: string read m_strFileName write m_strFileName;
    property dtCreateTime: tdatetime read m_dtCreateTime write m_dtCreateTime;
    property dtStartTime: tdatetime read m_dtStartTime write m_dtStartTime;
    property dtEndTime: tdatetime read m_dtEndTime write m_dtEndTime;
    property nCallDirection: integer read m_nCallDirection write m_nCallDirection;
    property bIsDialed: boolean read m_bIsDialed write m_bIsDialed;
    property strRemark: string read m_strRemark write m_strRemark;
  end;



    {查询条件类}
  TTelRecordQueryCond = record
  public
   StartDate:TDateTime;
   EndDate:TDateTime;
   UserNumber:string;
   CallDirection:integer;
   DailedType : integer;
  end;

  TTelRecordList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TTelRecord;
    procedure SetItem(Index: Integer; AObject: TTelRecord);

  public
    function Add(AObject: TTelRecord): Integer;
    property Items[Index: Integer]: TTelRecord read GetItem write SetItem; default;
  end;




implementation

{ TTelRecordList }

function TTelRecordList.Add(AObject: TTelRecord): Integer;
begin
  result := Inherited add(AObject);
end;

function TTelRecordList.GetItem(Index: Integer): TTelRecord;
begin
  result := TTelRecord(inherited GetItem(Index));
end;
procedure TTelRecordList.SetItem(Index: Integer; AObject: TTelRecord);
begin
  Inherited SetItem(Index,AObject);
end;

{ TTelRecord }

procedure TTelRecord.Clear;
begin
  nId := 0 ;
  m_strGUID := '';
  {对方电话}
  m_strDestTel:= '';
  {当前值班员信息}
  m_strUserNumber:= '';
  m_strUserName:= '';
  {文件名字}
  m_strFileName:= '';
  {建立时间}
  m_dtCreateTime := Now ;
  {录音开始时间和结束时间}
  m_dtStartTime:= Now;
  m_dtEndTime:= Now;
  {呼叫方向}
  m_nCallDirection := -1 ;

  m_bIsDialed := true ;

  m_strRemark := '' ;
end;

end.
