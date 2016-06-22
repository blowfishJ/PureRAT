object FormServicesManager: TFormServicesManager
  Left = 518
  Top = 117
  BorderStyle = bsDialog
  Caption = 'Services Manager'
  ClientHeight = 169
  ClientWidth = 322
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 8
    Top = 10
    Width = 64
    Height = 13
    Caption = 'Service name'
  end
  object lbl3: TLabel
    Left = 8
    Top = 42
    Width = 42
    Height = 13
    Caption = 'Filename'
  end
  object lbl4: TLabel
    Left = 8
    Top = 74
    Width = 53
    Height = 13
    Caption = 'Description'
  end
  object lbl5: TLabel
    Left = 8
    Top = 106
    Width = 69
    Height = 13
    Caption = 'Startup option'
  end
  object edtName: TEdit
    Left = 88
    Top = 8
    Width = 225
    Height = 21
    TabOrder = 0
  end
  object edtFilename: TEdit
    Left = 88
    Top = 40
    Width = 225
    Height = 21
    TabOrder = 1
  end
  object edtDescription: TEdit
    Left = 88
    Top = 72
    Width = 225
    Height = 21
    TabOrder = 2
  end
  object cbbStartup: TComboBoxEx
    Left = 88
    Top = 104
    Width = 225
    Height = 22
    ItemsEx = <
      item
        Caption = 'Automatic'
      end
      item
        Caption = 'Manual'
      end
      item
        Caption = 'Disable'
      end>
    Style = csExDropDownList
    ItemHeight = 16
    TabOrder = 3
    DropDownCount = 8
  end
  object btn1: TButton
    Left = 160
    Top = 136
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 4
    OnClick = btn1Click
  end
  object btn2: TButton
    Left = 240
    Top = 136
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 5
    OnClick = btn2Click
  end
end
