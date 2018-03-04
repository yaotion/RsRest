unit uHttpComm;

interface
uses
  Classes,SysUtils,IdBaseComponent, IdComponent,IdTCPConnection, IdTCPClient,
  IdHTTP,IdGlobal,IdObjs,IdURI,IdMultipartFormData;
type
  THttpProcessEvent= procedure(nPercent: Integer) of object;
  THttpComm = class
	private
		m_nReadTimeOut: integer;
		m_nConnectTimeOut: integer;
    m_HttpProcessEvent: THttpProcessEvent;
    procedure OnIdHTTPWork(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Integer);
	public
		function Get(URL: string): string;
		function Post(URL,ClientID,Data: string): string; overload;
    function Post(URL: string ;Values:TStringS): string;overload;
		function SubmitFile(URL: string;PostStream: TIdMultiPartFormDataStream;ProcessEvent: THttpProcessEvent): string;
	public
		property ReadTimeOut: integer read m_nReadTimeOut write m_nReadTimeOut;
		property ConnectTimeOut: integer read m_nConnectTimeOut write m_nConnectTimeOut;
	end;
implementation

function THttpComm.Get(URL: string): string;
var
  IdHTTP: TIdHTTP;
begin
  IdHTTP := TIdHTTP.Create(nil);
  try
    IdHTTP.ReadTimeout := m_nReadTimeOut;
    Result := IdHTTP.Get(URL);
  finally
    IdHTTP.Free;
  end;
end;

procedure THttpComm.OnIdHTTPWork(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Integer);
begin
  if TIdHTTP(ASender).Request.Source.Size = 0 then
    Exit;
  if Assigned(m_HttpProcessEvent) then
    m_HttpProcessEvent(Round(AWorkCount / TIdHTTP(ASender).Request.Source.Size) * 100);
end;



function THttpComm.Post(URL: string; Values: TStringS): string;
var
  idHttp: TIdHTTP;
begin
  idHttp := TIdHTTP.Create(nil);
  try
    idHttp.ConnectTimeout := m_nConnectTimeOut;
    idHttp.Request.Pragma := 'no-cache';
    idHttp.Request.CacheControl := 'no-cache';
    idHttp.Request.Connection := 'close';

    Result := idHttp.Post(URL, Values);

  finally
    idHttp.Free;
  end;
end;

function THttpComm.Post(URL,ClientID,Data: string): string;
var
  idHttp: TIdHTTP;
  AValues: TIdStringList;
begin
  idHttp := TIdHTTP.Create(nil);
  AValues := TIdStringList.Create;

  try
    AValues.Values['cid'] := ClientID;

    AValues.Values['data'] := AnsiToUtf8(Data);

    idHttp.ConnectTimeout := m_nConnectTimeOut;
    idHttp.Request.Pragma := 'no-cache';
    idHttp.Request.CacheControl := 'no-cache';
    idHttp.Request.Connection := 'close';

    Result := idHttp.Post(URL, AValues);
  finally
    AValues.Free;
    idHttp.Free;
  end;
end;

function THttpComm.SubmitFile(URL: string;
  PostStream: TIdMultiPartFormDataStream;ProcessEvent: THttpProcessEvent): string;
var
  idHttp: TIdHTTP;
  ResponseStream: TIdStringStream;
begin
  idHttp := TIdHTTP.Create(nil);
  ResponseStream := TIdStringStream.Create('');

  try
    m_HttpProcessEvent := ProcessEvent;
    idHttp.OnWork := OnIdHTTPWork;
    idHttp.ConnectTimeout := m_nConnectTimeOut;
    idHttp.Request.Pragma := 'no-cache';
    idHttp.Request.CacheControl := 'no-cache';
    idHttp.Request.Connection := 'close';
    idHttp.Request.ContentType := PostStream.RequestContentType;
    idHttp.Post(URL, PostStream, ResponseStream);


    Result := ResponseStream.DataString;;
  finally
    ResponseStream.Free;
    idHttp.Free;
  end;
end;
end.

