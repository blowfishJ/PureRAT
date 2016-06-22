object FormFTPManager: TFormFTPManager
  Left = 419
  Top = 146
  BorderStyle = bsDialog
  Caption = 'FTP manager'
  ClientHeight = 241
  ClientWidth = 337
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lbl17: TLabel
    Left = 8
    Top = 171
    Width = 41
    Height = 13
    Caption = 'FTP port'
  end
  object lbl16: TLabel
    Left = 8
    Top = 107
    Width = 64
    Height = 13
    Caption = 'FTP directory'
  end
  object lbl15: TLabel
    Left = 8
    Top = 75
    Width = 67
    Height = 13
    Caption = 'FTP password'
  end
  object lbl14: TLabel
    Left = 8
    Top = 43
    Width = 68
    Height = 13
    Caption = 'FTP username'
  end
  object lbl13: TLabel
    Left = 8
    Top = 11
    Width = 42
    Height = 13
    Caption = 'FTP host'
  end
  object lbl1: TLabel
    Left = 8
    Top = 139
    Width = 42
    Height = 13
    Caption = 'Filename'
  end
  object seFtpPort: TSpinEdit
    Left = 104
    Top = 168
    Width = 121
    Height = 22
    MaxLength = 5
    MaxValue = 65535
    MinValue = 1
    TabOrder = 0
    Value = 21
  end
  object edtFtpUser: TEdit
    Left = 104
    Top = 40
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object edtFtpPass: TEdit
    Left = 104
    Top = 72
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 2
  end
  object edtFtphost: TEdit
    Left = 104
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 3
  end
  object edtFtpDir: TEdit
    Left = 104
    Top = 104
    Width = 121
    Height = 21
    TabOrder = 4
  end
  object chk2: TCheckBox
    Left = 232
    Top = 74
    Width = 97
    Height = 17
    Caption = 'Show password'
    TabOrder = 5
  end
  object btn1: TButton
    Left = 176
    Top = 208
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 6
    OnClick = btn1Click
  end
  object btn2: TButton
    Left = 256
    Top = 208
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 7
    OnClick = btn2Click
  end
  object edtFilename: TEdit
    Left = 104
    Top = 136
    Width = 121
    Height = 21
    TabOrder = 8
  end
end
