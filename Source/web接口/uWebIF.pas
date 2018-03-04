unit uWebIF;

interface
uses
  uHttpComm,Classes,SysUtils,IdObjs,superobject,uGenericData,ZKFPEngXUtils;

type

  {web�ӿ�����}
  RWebConfig = record
    //�ͻ���ID
    strCID:string;
    //��������ַ
    strHost:string;
    //�ӿڵ�ַ
    strURL:string;    
  end;

  //////////////////////////////////////////////////////////////////////////////
  /// ����:TWebAPI
  /// ����:web�ӿڲ���
  //////////////////////////////////////////////////////////////////////////////
  TWebIF = class
  public
    constructor Create();
    destructor Destroy; override;
  public
    //web�ӿ������շ�
    function TransData_UnifiedURL(dataType:string;JsonData:string;var strResult:string): Boolean;
   
  private
    {����:��ȡURL}
    function GetHostURL():string;
  public
    //web�ӿ�����
    webConfig :RWebConfig;
    //httpͨ�Ż���
		HttpComm: THttpComm;

  end;


implementation

{ TWebAPI }
function TWebIF.TransData_UnifiedURL(dataType:string;JsonData:string;var strResult:string): Boolean;
var
  AValues: TIdStringList;
begin
  Result := False;
  AValues:= TIdStringList.Create;
  try
    try
      AValues.Values['cid'] :=webConfig.strCID;
      AValues.Values['data'] := JsonData;
      AValues.Values['dataType'] := dataType;
      strResult := HttpComm.Post(GetHostURL(),AValues);
      strResult := Utf8ToAnsi(strResult);
      Result := True;
    except on e:Exception do
      strResult := e.Message;
    end;
  finally
    AValues.Free;
  end;
end;


constructor TWebIF.Create;
begin
  HttpComm := THttpComm.Create;
end;

destructor TWebIF.Destroy;
begin
  HttpComm.Free;
  inherited;
end;

function TWebIF.GetHostURL: string;
begin
  result :=webConfig.strURL;
end;


end.
