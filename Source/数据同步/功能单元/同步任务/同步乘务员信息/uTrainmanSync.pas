unit uTrainmanSync;

interface
uses ADODB,DB,SysUtils,CustomProperties,Contnrs,Classes,DateUtils,
  uTFSystem,uSerializable,superobject,uSaftyEnum;

  
type

  //��ȡָ�������ķ�����Ϣ {��result��:0,��resultStr��:�����سɹ���,��signature��:��XXXXXXX��}
  RRltSignature = record
    //���ؽ��ID
    result : integer;
    //���ؽ������
    resultStr : string;
    //������
    signature : string;
  end;

   //��ȡ����Ա��Ϣѡ��
  TRltTrainmanOption = (rlttoData{��Ҫ��Ƭָ��},rlttoPhoto{Ҫ��Ƭ��Ҫָ��},rlttoFinger{Ҫָ�Ʋ�Ҫ��Ƭ},rlttoAll{ָ����Ƭ��Ҫ});
  //��Ա�б�����Ϣ�е���������Ϣ�ṹ
  RRltTrainman = record
    nID:Integer;
    trainmanid : string;
    trainmanNumber : string;
    trainmanName : string;
    finger1 : OleVariant;
    finger2 : OleVariant;
    pic : OleVariant;
  end;
  TRltTrainmanArray = array of RRltTrainman;

  //��ȡ����Ա�б���Ϣ�¼�
  TWebAPITrainmanListEvent = procedure(Index : integer;totalCount:integer;
    MaxID : integer;RltTrainmanArray :TRltTrainmanArray) of object;

    
  TTrainManList = class;
  //////////////////////////////////////////////////////////////////////////////
  /// TTrainmanFingerPrint ˾��ָ����Ϣ
  //////////////////////////////////////////////////////////////////////////////
  TTrainmanFingerPrint = class(TSerializable)
  public
    constructor Create();override;
    destructor Destroy();override;
  private
    {ָ��1}
    m_FingerPrint1 : TMemoryStream;
    {ָ��2}
    m_FingerPrint2 : TMemoryStream;
  protected
    {����:׼��JSON�ַ���}
    procedure PrepareData();override;
    {����:��JSON�ַ��������л�����}
    procedure LoadData();override;
  public
    {����:�ж�ָ��1�Ƿ�Ϊ��}
    function Finger1IsNull():Boolean;
    {����:�ж�ָ��2�Ƿ�Ϊ��}
    function Finger2IsNull():Boolean;
    property FingerPrint1: TMemoryStream read m_FingerPrint1;
    property FingerPrint2: TMemoryStream read m_FingerPrint2;
  end;

  //////////////////////////////////////////////////////////////////////////////
  /// TTrainmanFingerPrintList ˾��ָ���б�
  //////////////////////////////////////////////////////////////////////////////
  TTrainmanFingerPrintList = class(TSerializableList)
  protected
    function GetItem(Index: Integer): TTrainmanFingerPrint;
    procedure SetItem(Index: Integer; TrainmanFingerPrint: TTrainmanFingerPrint);
  public
    procedure SetString(strJson: string);overload;override;
    procedure SetJson(IJson: ISuperObject);overload;override;
    function Add(TrainmanFingerPrint: TTrainmanFingerPrint): Integer;
    property Items[Index: Integer]: TTrainmanFingerPrint read GetItem write SetItem; default;
  end;

  //////////////////////////////////////////////////////////////////////////////
  /// TTrainMan ˾�����ݲ���������
  //////////////////////////////////////////////////////////////////////////////
  TTrainMan = class(TSerializable)
  public
    constructor Create();override;
    destructor Destroy; override;
  private
    {��Ƭ}
    m_Picture : TMemoryStream;
    {ָ�ƶ���}
    m_TrainmanFingerPrint: TTrainmanFingerPrint;
    {����ԱID}
    m_strID : String;
    {����Ա����}
    m_strName : String;
    {����Ա����}
    m_strNumber : String;
    {��������ID}
    m_strFlowID: string;
    {��½��֤��ʽ}
    m_nVerify: TRsRegisterFlag;
  protected
    {����:׼��JSON�ַ���}
    procedure PrepareData();override;
    {����:��JSON�ַ��������л�����}
    procedure LoadData();override;
  public
    procedure Clone(Source: TTrainMan);
    property strID: string read m_strID write m_strID;
    property Name: string read m_strName write m_strName;
    property Number: string read m_strNumber write m_strNumber;
    property FingerPrint: TTrainmanFingerPrint read m_TrainmanFingerPrint;
    property Picture: TMemoryStream read m_Picture;
    property FlowID: string read m_strFlowID write m_strFlowID;
    property Verify: TRsRegisterFlag read m_nVerify write m_nVerify;
  end;


  
  {����Ա�����б�}
  TTrainManList = class(TSerializableList)
  protected
    function GetItems(Index: Integer): TTrainMan;
    procedure SetItems(Index: Integer; TrainMan: TTrainMan);
  public
    procedure SetString(strJson: string);overload;override;
    procedure SetJson(IJson: ISuperObject);overload;override;    
    function Add(TrainMan: TTrainMan): Integer;
    function Remove(TrainMan: TTrainMan): Integer;
    function IndexOf(TrainMan: TTrainMan): Integer;overload;
    function IndexOf(strNumber : String): Integer;overload;
    procedure Insert(Index: Integer; TrainMan: TTrainMan);
    property Items[Index: Integer]: TTrainMan read GetItems write SetItems; default;
  end;


implementation
procedure TTrainMan.Clone(Source: TTrainMan);
begin
  SetString(Source.AsString);
end;

constructor TTrainMan.Create();
begin
  inherited;
  m_Picture := TMemoryStream.Create;
  m_TrainmanFingerPrint := TTrainmanFingerPrint.Create;
end;

destructor TTrainMan.Destroy;
begin
  m_Picture.Free;
  m_TrainmanFingerPrint.Free;
  inherited;
end;


procedure TTrainMan.LoadData;
begin
  m_strID := m_GenericData.StrField['strid'];
  Name := m_GenericData.StrField['name'];
  Number := m_GenericData.StrField['number'];
  m_strFlowID := m_GenericData.StrField['flowID'];
  m_nVerify := TRsRegisterFlag(m_GenericData.IntField['verify']);

  m_Picture.Clear;
  m_GenericData.GetBlobField('picture',m_Picture);
  m_TrainmanFingerPrint.SetString(m_GenericData.ObjectField['finger'].AsString);
end;

procedure TTrainMan.PrepareData;
begin
  m_GenericData.StrField['strid'] := m_strID;
  m_GenericData.StrField['name'] := Name;
  m_GenericData.StrField['number'] := Number;
  m_GenericData.SetBlobField('picture',m_Picture);
  m_GenericData.ObjectField['finger'] := m_TrainmanFingerPrint.IJson;

  m_GenericData.StrField['flowID'] := m_strFlowID;
  m_GenericData.IntField['verify'] := Ord(m_nVerify);
end;


{ TTrainManList }

function TTrainManList.Add(TrainMan: TTrainMan): Integer;
begin
  Result := inherited Add(TrainMan);
end;


function TTrainManList.GetItems(Index: Integer): TTrainMan;
begin
  Result := TTrainMan(inherited Items[Index]);
end;

function TTrainManList.IndexOf(TrainMan: TTrainMan): Integer;
begin
  Result := inherited IndexOf(TrainMan);
end;

function TTrainManList.IndexOf(strNumber : String): Integer;
var
  i : integer;
begin
  Result := -1;
  for I := 0 to Count - 1 do
  begin
    if Items[i].Number = strNumber then
    begin
      Result := i;
      Break;
    end;
  end;
end;

procedure TTrainManList.Insert(Index: Integer; TrainMan: TTrainMan);
begin
  inherited Insert(Index, TrainMan);
end;

function TTrainManList.Remove(TrainMan: TTrainMan): Integer;
begin
  Result := inherited Remove(TrainMan);
end;

procedure TTrainManList.SetItems(Index: Integer; TrainMan: TTrainMan);
begin
  inherited Items[Index] := TrainMan;
end;

procedure TTrainManList.SetJson(IJson: ISuperObject);
begin
  SetJson(IJson,TTrainMan);
end;

procedure TTrainManList.SetString(strJson: string);
begin
  SetString(strJson,TTrainMan);
end;

{ TGanBuDBManage }

{ TTrainmanFingerPrint }

constructor TTrainmanFingerPrint.Create;
begin
  inherited;
  m_FingerPrint1 := TMemoryStream.Create;
  m_FingerPrint2 := TMemoryStream.Create;
end;

destructor TTrainmanFingerPrint.Destroy;
begin
  m_FingerPrint1.Free;
  m_FingerPrint2.Free;
  inherited;
end;

function TTrainmanFingerPrint.Finger1IsNull: Boolean;
begin
  Result := m_FingerPrint1.Size = 0;
end;

function TTrainmanFingerPrint.Finger2IsNull: Boolean;
begin
  Result := m_FingerPrint2.Size = 0;
end;

procedure TTrainmanFingerPrint.LoadData;
begin
  m_GenericData.GetBlobField('Finger1',m_FingerPrint1);
  m_GenericData.GetBlobField('Finger2',m_FingerPrint2);
end;

procedure TTrainmanFingerPrint.PrepareData;
begin
  m_FingerPrint1.Clear;
  m_FingerPrint2.Clear;
  m_GenericData.SetBlobField('Finger1',m_FingerPrint1);
  m_GenericData.SetBlobField('Finger2',m_FingerPrint2);
end;

{ TTrainmanFingerPrintList }

function TTrainmanFingerPrintList.Add(
  TrainmanFingerPrint: TTrainmanFingerPrint): Integer;
begin
  Result := inherited Add(TrainmanFingerPrint);
end;

function TTrainmanFingerPrintList.GetItem(
  Index: Integer): TTrainmanFingerPrint;
begin
  Result := TTrainmanFingerPrint(inherited GetItem(Index));
end;

procedure TTrainmanFingerPrintList.SetItem(Index: Integer;
  TrainmanFingerPrint: TTrainmanFingerPrint);
begin
  inherited SetItem(Index,TrainmanFingerPrint);
end;

procedure TTrainmanFingerPrintList.SetJson(IJson: ISuperObject);
begin
  SetJson(IJson,TTrainmanFingerPrint);
end;

procedure TTrainmanFingerPrintList.SetString(strJson: string);
begin
  SetString(strJson,TTrainmanFingerPrint);
end;

end.
