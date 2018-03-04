unit uWebIF;

interface
uses
  uHttpComm,Classes,SysUtils,IdObjs,superobject,uGenericData,ZKFPEngXUtils;

type

  {web接口配置}
  RWebConfig = record
    //客户端ID
    strCID:string;
    //服务器地址
    strHost:string;
    //接口地址
    strURL:string;    
  end;

  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TWebAPI
  /// 描述:web接口操作
  //////////////////////////////////////////////////////////////////////////////
  TWebIF = class
  public
    constructor Create();
    destructor Destroy; override;
  public
    //web接口数据收发
    function TransData_UnifiedURL(dataType:string;JsonData:string;var strResult:string): Boolean;
   
  private
    {功能:获取URL}
    function GetHostURL():string;
  public
    //web接口配置
    webConfig :RWebConfig;
    //http通信基类
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
