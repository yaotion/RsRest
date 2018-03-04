unit uTelRecord;

interface

uses
    Classes,SysUtils,Contnrs;

type

  {�绰¼����¼��}
  TTelRecord =  class(TPersistent)
  private
    m_nId: integer;
    m_strGUID: string;
    {�Է��绰}
    m_strDestTel: string;
    {��ǰֵ��Ա��Ϣ}
    m_strUserNumber: string;
    m_strUserName: string;
    {�ļ�����}
    m_strFileName: string;
    {����ʱ��}
    m_dtCreateTime: tdatetime;
    {¼����ʼʱ��ͽ���ʱ��}
    m_dtStartTime: tdatetime;
    m_dtEndTime: tdatetime;
    {���з���}
    m_nCallDirection : integer;{0=����,1����}

    {�Ƿ��ͨ}
    m_bIsDialed :boolean ;

    m_strRemark:string; {��ע}
  public
    {�������}
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



    {��ѯ������}
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
  {�Է��绰}
  m_strDestTel:= '';
  {��ǰֵ��Ա��Ϣ}
  m_strUserNumber:= '';
  m_strUserName:= '';
  {�ļ�����}
  m_strFileName:= '';
  {����ʱ��}
  m_dtCreateTime := Now ;
  {¼����ʼʱ��ͽ���ʱ��}
  m_dtStartTime:= Now;
  m_dtEndTime:= Now;
  {���з���}
  m_nCallDirection := -1 ;

  m_bIsDialed := true ;

  m_strRemark := '' ;
end;

end.
