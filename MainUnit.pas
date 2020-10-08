unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ExtDlgs, ArrayUtils,
  Vcl.ComCtrls, System.Generics.Collections, System.Math;

type
  TMainForm = class(TForm)
    OpenFileButton: TButton;
    InputPanel: TPanel;
    OutputPanel: TPanel;
    Splitter: TSplitter;
    InputMemo: TMemo;
    OutputMemo: TMemo;
    SplitIntoOperands: TButton;
    OpenFileDialog: TOpenTextFileDialog;
    procedure OpenFileButtonClick(Sender: TObject);
    procedure SplitIntoOperandsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
  MainForm: TMainForm;
  isFileOpened: Boolean;
  nm1, nm2: TDictionary<String, Integer>;
  n1, n2: Integer;

const
  DEBUG = False;
  SplitterStrings: array [0..2] of String = (
    ';', '.', ','
  );
  SkipChars: array [0..7] of Char = (
    ' ', ',', #39, #13, #10, ':', '=', ';'
  );
  OperatorsChars : array [0..8] of Char = (
    '[', ']', '(', ')', '+', '-', '*', '/', #39
  );
  OperatorsStrings : array [0..7] of String = (
    'begin', 'end', 'program', 'var', 'type', 'interface', 'class', 'implementation'
  );

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  if DEBUG then begin
    InputMemo.Lines.LoadFromFile(ExtractFilePath(Application.ExeName)+'test.txt');
    isFileOpened:=true;
    SplitIntoOperandsClick(Sender);
  end;
end;

procedure TMainForm.OpenFileButtonClick(Sender: TObject);
var
  OpenedFile: TextFile;
begin
  isFileOpened := OpenFileDialog.Execute((self as TForm).Handle);
  if isFileOpened then begin
    InputMemo.Lines.LoadFromFile(OpenFileDialog.FileName);
  end;
end;

procedure InitClear(Form: TMainForm);
begin
  Form.OutputMemo.Lines.Clear;
  N1:=0;
  N2:=0;
  Nm1:=TDictionary<String, Integer>.Create();
  Nm2:=TDictionary<String, Integer>.Create();
end;

{
  Nm1 - уникальые операторы
  Nm2 - уникальные операнды
  N1 - число операторов
  N2 - число операндов
}
procedure ProcessOperator(Op: String; Form: TMainForm);
begin
  Form.OutputMemo.Lines.Add('Оператор: '+Op);
  if not Nm1.ContainsKey(Op) then begin
    Nm1.Add(Op, 1);
  end
  else begin
    Nm1.Items[Op]:=Nm1.Items[Op]+1;
  end;
  N1:=N1+1;


end;

procedure ProcessOperand(Op: String; Form: TMainForm);
begin
  Form.OutputMemo.Lines.Add('Операнд: '+Op);
  if not Nm2.ContainsKey(Op) then begin
    Nm2.Add(Op, 1);
  end
  else begin
    Nm2.Items[Op]:=Nm2.Items[Op]+1;
  end;
  N2:=N2+1;
end;

procedure TMainForm.SplitIntoOperandsClick(Sender: TObject);
var
  OpBuffer: String;
  ProgramChars: TList<Char>;
  I, J: Integer;
  isStringContinues: Boolean;
  CurrentChar, NextChar: Char;
  CharCode: Integer;
  CurrentLine: System.TArray<Char>;
  KeysBuffer: TArray<String>;
begin
  InitClear(self);

  isStringContinues:=False;
  for I := 0 to InputMemo.Lines.Count - 1 do begin
    if InputMemo.Lines[I].ToLower.StartsWith('program') then Continue;

    CurrentLine:=InputMemo.Lines[I].ToCharArray;
    for J := 0 to Length(CurrentLine) - 1 do begin

      CurrentChar:=CurrentLine[J];
      CharCode:=Ord(CurrentChar);
      if Ord(CurrentChar) = 39 then begin
        if isStringContinues then begin
          isStringContinues:=False;
          ProcessOperand(OpBuffer+#39, self);
          OpBuffer:=Opbuffer.Empty;
          Continue;
        end
        else begin
          isStringContinues:=True;
        end;
      end;
      if isStringContinues then begin
        OpBuffer := OpBuffer + CurrentChar;
        Continue;
      end;

      if ArrayUtils.TArrayUtils<String>.Contains(OpBuffer.ToLower, OperatorsStrings) then begin
        ProcessOperator(OpBuffer.ToLower, self);
        OpBuffer:=OpBuffer.Empty;
      end;


      if ArrayUtils.TArrayUtils<Char>.Contains(CurrentChar, SkipChars) then begin//Пробелы и знаки между словами силы
        if (CurrentChar = ':') and (J < Length(CurrentLine)-1) and (CurrentLine[J+1] = '=') then begin
          ProcessOperator(':=', self);
        end
        else if ArrayUtils.TArrayUtils<String>.Contains(OpBuffer.ToLower, SplitterStrings) then begin
          OpBuffer:=OpBuffer.Empty;
        end
        else begin
          if OpBuffer <> OpBuffer.Empty then
            ProcessOperand(OpBuffer.ToLower, self);
          OpBuffer:=OpBuffer.Empty;
        end;
      end
      else if ArrayUtils.TArrayUtils<Char>.Contains(CurrentChar, OperatorsChars) then begin
        if ArrayUtils.TArrayUtils<String>.Contains(OpBuffer.ToLower, SplitterStrings) then begin
          OpBuffer:=OpBuffer.Empty;
        end
        else begin
          if OpBuffer <> OpBuffer.Empty then
            ProcessOperand(OpBuffer.ToLower, self);
          OpBuffer:=OpBuffer.Empty;
        end;
        ProcessOperator(CurrentChar, self);
      end
      else begin
        OpBuffer := OpBuffer + CurrentChar;
      end;


    end;
  end;
  OutputMemo.Lines.Clear;
  KeysBuffer:=Nm1.Keys.ToArray;
  OutputMemo.Lines.Add('Операторы:');
  for I := 0 to Length(KeysBuffer)-1 do begin
    OutputMemo.Lines.Add(KeysBuffer[I]+' - '+IntToStr(Nm1[KeysBuffer[I]]));
  end;
  KeysBuffer:=Nm2.Keys.ToArray;
  OutputMemo.Lines.Add('Операнды:');
  for I := 0 to Length(KeysBuffer)-1 do begin
    OutputMemo.Lines.Add(KeysBuffer[I]+' - '+IntToStr(Nm2[KeysBuffer[I]]));
  end;
  OutputMemo.Lines.Add('');
  OutputMemo.Lines.Add('Итак, вот что мы имеем:');
  OutputMemo.Lines.Add('D='+FloatToStr((Nm1.Keys.Count/2)*(N2/Nm2.Keys.Count)));
  OutputMemo.Lines.Add('L='+FloatToStr(1/((Nm1.Keys.Count/2)*(N2/Nm2.Keys.Count))));
  OutputMemo.Lines.Add('V='+FloatToStr((N1+N2)*log2(Nm1.Keys.Count+Nm2.Keys.Count)));
  OutputMemo.Lines.Add('E='+FloatToStr(((N1+N2)*log2(Nm1.Keys.Count+Nm2.Keys.Count))/(1/((Nm1.Keys.Count/2)*(N2/Nm2.Keys.Count)))));
end;

end.
