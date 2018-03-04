unit uRecordTelUtil;

interface

uses
  uTelRecord,uDBTelRecord,adodb;

type
  TRecordTelUtil = class
  public
    constructor Create(ADOConnection: TADOConnection);
    destructor Destroy(); override;
  public
    procedure Query(TelRecordQueryCond:TTelRecordQueryCond;TelRecordList:TTelRecordList);

    procedure Insert(TelRecord: TTelRecord);
  private
    m_DBTelRecord: TDBTelRecord;
  end;

implementation

{ TRecordTelUtil }

constructor TRecordTelUtil.Create(ADOConnection: TADOConnection);
begin
  m_DBTelRecord := TDBTelRecord.Create(ADOConnection);
end;

destructor TRecordTelUtil.Destroy;
begin
  m_DBTelRecord.Free ;
  inherited;
end;

procedure TRecordTelUtil.Insert(TelRecord: TTelRecord);
begin
  m_DBTelRecord.Insert(TelRecord);
end;

procedure TRecordTelUtil.Query(TelRecordQueryCond:TTelRecordQueryCond; TelRecordList: TTelRecordList);
begin
  m_DBTelRecord.Query(TelRecordQueryCond,TelRecordList);
end;

end.
