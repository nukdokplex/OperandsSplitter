object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'OperandSplitter'
  ClientHeight = 424
  ClientWidth = 445
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter: TSplitter
    Left = 185
    Top = 31
    Height = 362
    ExplicitLeft = 224
    ExplicitTop = 160
    ExplicitHeight = 100
  end
  object OpenFileButton: TButton
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 439
    Height = 25
    Align = alTop
    Caption = #1054#1090#1082#1088#1099#1090#1100' '#1092#1072#1081#1083
    TabOrder = 0
    OnClick = OpenFileButtonClick
  end
  object InputPanel: TPanel
    Left = 0
    Top = 31
    Width = 185
    Height = 362
    Align = alLeft
    Ctl3D = False
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 1
    object InputMemo: TMemo
      Left = 1
      Top = 1
      Width = 183
      Height = 360
      Align = alClient
      TabOrder = 0
    end
  end
  object OutputPanel: TPanel
    Left = 188
    Top = 31
    Width = 257
    Height = 362
    Align = alClient
    Ctl3D = False
    ParentCtl3D = False
    ShowCaption = False
    TabOrder = 2
    object OutputMemo: TMemo
      Left = 1
      Top = 1
      Width = 255
      Height = 360
      Align = alClient
      ReadOnly = True
      TabOrder = 0
    end
  end
  object SplitIntoOperands: TButton
    AlignWithMargins = True
    Left = 3
    Top = 396
    Width = 439
    Height = 25
    Align = alBottom
    Caption = #1056#1072#1079#1073#1080#1090#1100' '#1080' '#1074#1099#1095#1083#1077#1085#1080#1090#1100' '#1086#1087#1077#1088#1072#1085#1076#1099
    TabOrder = 3
    OnClick = SplitIntoOperandsClick
  end
  object OpenFileDialog: TOpenTextFileDialog
    Filter = #1058#1077#1082#1089#1090#1086#1074#1099#1081' '#1092#1072#1081#1083'|*.txt|'#1060#1072#1081#1083' '#1080#1089#1093#1086#1076#1085#1086#1075#1086' '#1082#1086#1076#1072'|*.pas'
    Left = 336
    Top = 16
  end
end
