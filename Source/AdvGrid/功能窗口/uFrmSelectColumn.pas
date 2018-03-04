unit uFrmSelectColumn;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzLstBox, RzChkLst, ComCtrls, RzListVw,uStrGridUtils,AdvGrid;

type
  TfrmSelectColumn = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    RzListView1: TRzListView;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    m_ColumnVisibles : TRGridColVisibleArray;
    procedure InitColumns(ColumnVisibles : TRGridColVisibleArray);
  public
    { Public declarations }
    //…Ë÷√œ‘ æ¡–
    class procedure SelectColumn(StrGrid : TAdvStringGrid;SectionName : string);
  end;



implementation
uses
  uGlobalDM;
{$R *.dfm}

{ TfrmSelectColumn }

procedure TfrmSelectColumn.Button1Click(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to length(m_ColumnVisibles) - 1 do
  begin
     m_ColumnVisibles[i].ColumnVisible := RzListView1.Items[i].Checked;
  end;
  ModalResult := mrOk;
end;

procedure TfrmSelectColumn.Button2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmSelectColumn.InitColumns(ColumnVisibles: TRGridColVisibleArray);
var
  i: Integer;
  item : TListItem;
begin
  m_ColumnVisibles := ColumnVisibles;
  RzListView1.Items.Clear;
  for i := 0 to length(m_ColumnVisibles) - 1 do
  begin
    item := RzListView1.Items.Add;
    item.Caption := m_ColumnVisibles[i].ColumnName;
    item.Checked := m_ColumnVisibles[i].ColumnVisible;
  end;
end;

class procedure TfrmSelectColumn.SelectColumn(StrGrid: TAdvStringGrid;SectionName : string);
var
  frmSelectColumn : TfrmSelectColumn;
  columnVisibles : TRGridColVisibleArray;
begin
  frmSelectColumn := TfrmSelectColumn.Create(nil);
  try
    TStrGridUtils.GetColumnVisible(StrGrid,columnVisibles);
    frmSelectColumn.InitColumns(columnVisibles);
    if frmSelectColumn.ShowModal = mrCancel then exit;
    TStrGridUtils.SetColumnVisible(StrGrid,frmSelectColumn.m_ColumnVisibles);
   // GlobalDM.SetGridColumnWidth(StrGrid);
    GlobalDM.SaveGridColumnVisible(StrGrid);
    //TStrGridUtils.SaveColumnVisible(StrGrid,GlobalDM.AppPath + StrGridVisibleFile,SectionName);
  finally
    frmSelectColumn.Free;
  end;
end;

end.
