object FormProgressBar: TFormProgressBar
  Left = 369
  Top = 269
  BorderStyle = bsDialog
  ClientHeight = 41
  ClientWidth = 377
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pb1: TProgressBar
    Left = 8
    Top = 8
    Width = 281
    Height = 25
    TabOrder = 0
  end
  object btn1: TButton
    Left = 296
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = btn1Click
  end
end
