{
Пакет             Simple Game Engine 1
Файл              sgeCommandHistory.pas
Версия            1.1
Создан            09.12.2018
Автор             Творческий человек  (accuratealx@gmail.com)
Описание          Класс хранения истории введённых команд
}

unit sgeCommandHistory;

{$mode objfpc}{$H+}

interface

uses
  StringArray,
  sgeConst, sgeTypes,
  SysUtils;


type
  TsgeCommandHistory = class
  private
    FCommands: TStringArray;  //Массив строк истории
    FMaxLines: Word;          //Максимальное количество строк
    FCurrentIndex: Integer;   //Текущий индекс строки вставки

    function  GetCount: Integer;
    procedure SetMaxLines(ALines: Word);
  public
    constructor Create(MaxLines: Word = 50);
    destructor  Destroy; override;

    procedure Clear;
    procedure AddCommand(Cmd: String);
    procedure SaveToFile(FileName: String);
    procedure LoadFromFile(FileName: String);
    function  GetPreviousCommand: String;
    function  GetNextCommand: String;

    property MaxLines: Word read FMaxLines write SetMaxLines;
  end;



implementation


const
  _UNITNAME = 'sgeCommandHistory';



function TsgeCommandHistory.GetCount: Integer;
begin
  Result := StringArray_GetCount(@FCommands);
end;


procedure TsgeCommandHistory.SetMaxLines(ALines: Word);
begin
  FMaxLines := ALines;
  while GetCount > FMaxLines do
    StringArray_Delete(@FCommands, 0);
end;


constructor TsgeCommandHistory.Create(MaxLines: Word);
begin
  FMaxLines := MaxLines;
end;


destructor TsgeCommandHistory.Destroy;
begin
  Clear;
end;


procedure TsgeCommandHistory.Clear;
begin
  StringArray_Clear(@FCommands);
end;


procedure TsgeCommandHistory.AddCommand(Cmd: String);
var
  Idx: Integer;
begin
  if Cmd = '' then Exit;

  Idx := StringArray_GetCount(@FCommands) - 1;
  if Idx < 0 then StringArray_Add(@FCommands, Cmd) else
    if LowerCase(FCommands[Idx]) <> LowerCase(Cmd) then StringArray_Add(@FCommands, Cmd);

  if StringArray_GetCount(@FCommands) > FMaxLines then StringArray_Delete(@FCommands, 0);

  FCurrentIndex := StringArray_GetCount(@FCommands);
end;


procedure TsgeCommandHistory.SaveToFile(FileName: String);
begin
  if not StringArray_SaveToFile(@FCommands, FileName) then
    raise EsgeException.Create(sgeCreateErrorString(_UNITNAME, Err_FileWriteError, FileName));
end;


procedure TsgeCommandHistory.LoadFromFile(FileName: String);
begin
  if not StringArray_LoadFromFile(@FCommands, FileName) then
    raise EsgeException.Create(sgeCreateErrorString(_UNITNAME, Err_FileReadError, FileName));

  FCurrentIndex := StringArray_GetCount(@FCommands);
end;


function TsgeCommandHistory.GetPreviousCommand: String;
var
  c: Integer;
begin
  Result := '';
  c := StringArray_GetCount(@FCommands);
  if c = 0 then Exit;

  Dec(FCurrentIndex);
  if FCurrentIndex < 0 then FCurrentIndex := 0;
  Result := FCommands[FCurrentIndex];
end;


function TsgeCommandHistory.GetNextCommand: String;
var
  c: Integer;
begin
  Result := '';
  c := StringArray_GetCount(@FCommands);
  if c = 0 then Exit;

  Inc(FCurrentIndex);
  if FCurrentIndex >= c then FCurrentIndex := c - 1;
  Result := FCommands[FCurrentIndex];
end;


end.

