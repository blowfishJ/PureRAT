object FormRegistryManager: TFormRegistryManager
  Left = 338
  Top = 218
  BorderStyle = bsDialog
  Caption = 'Registry manager'
  ClientHeight = 189
  ClientWidth = 369
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
    Top = 8
    Width = 27
    Height = 13
    Caption = 'Name'
  end
  object lbl2: TLabel
    Left = 8
    Top = 56
    Width = 23
    Height = 13
    Caption = 'Data'
  end
  object edtName: TEdit
    Left = 8
    Top = 24
    Width = 185
    Height = 21
    TabOrder = 0
  end
  object rgType: TRadioGroup
    Left = 208
    Top = 8
    Width = 153
    Height = 129
    Caption = 'Type'
    Items.Strings = (
      'REG_SZ'
      'REG_MULTI_SZ'
      'REG_EXPAND_SZ'
      'REG_DWORD')
    TabOrder = 1
  end
  object mmoData: TMemo
    Left = 8
    Top = 72
    Width = 185
    Height = 105
    TabOrder = 2
  end
  object btn1: TButton
    Left = 208
    Top = 152
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 3
    OnClick = btn1Click
  end
  object btn2: TButton
    Left = 288
    Top = 152
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = btn2Click
  end
end
