object FormSelectPorts: TFormSelectPorts
  Left = 376
  Top = 172
  BorderStyle = bsDialog
  Caption = 'object se1: TSpinEditobject se1: TSpinEdit'
  ClientHeight = 237
  ClientWidth = 240
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
    Left = 112
    Top = 152
    Width = 75
    Height = 13
    Caption = 'Connection limit'
  end
  object lvPorts: TListView
    Left = 0
    Top = 0
    Width = 105
    Height = 237
    Align = alLeft
    Columns = <
      item
        Caption = 'Port'
        Width = -2
        WidthType = (
          -2)
      end>
    ReadOnly = True
    RowSelect = True
    PopupMenu = pm1
    TabOrder = 0
    ViewStyle = vsReport
  end
  object se1: TSpinEdit
    Left = 112
    Top = 8
    Width = 121
    Height = 22
    MaxLength = 5
    MaxValue = 65535
    MinValue = 1
    TabOrder = 1
    Value = 80
  end
  object btn1: TButton
    Left = 112
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Add port'
    TabOrder = 2
    OnClick = btn1Click
  end
  object chk1: TCheckBox
    Left = 112
    Top = 112
    Width = 97
    Height = 17
    Caption = 'Show password'
    TabOrder = 3
    OnClick = chk1Click
  end
  object edt1: TEdit
    Left = 112
    Top = 80
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 4
    OnChange = edt1Change
  end
  object se2: TSpinEdit
    Left = 111
    Top = 176
    Width = 121
    Height = 22
    MaxLength = 5
    MaxValue = 10000
    MinValue = 1
    TabOrder = 5
    Value = 50
  end
  object pm1: TPopupMenu
    Left = 8
    Top = 32
    object C1: TMenuItem
      Caption = 'Close'
      OnClick = C1Click
    end
  end
end
