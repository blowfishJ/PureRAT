object FormChat: TFormChat
  Left = 238
  Top = 150
  Width = 579
  Height = 321
  BorderIcons = [biMinimize, biMaximize]
  Caption = 'FormChat'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object redt1: TRichEdit
    Left = 0
    Top = 0
    Width = 563
    Height = 261
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object edt1: TsEdit
    Left = 0
    Top = 261
    Width = 563
    Height = 21
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnKeyPress = edt1KeyPress
    Align = alBottom
  end
end
