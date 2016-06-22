object FormConnectionsLog: TFormConnectionsLog
  Left = 240
  Top = 128
  BorderStyle = bsDialog
  Caption = 'Connections log'
  ClientHeight = 284
  ClientWidth = 563
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object lv1: TListView
    Left = 0
    Top = 0
    Width = 563
    Height = 284
    Align = alClient
    Columns = <
      item
        Caption = 'Idle'
        Width = -2
        WidthType = (
          -2)
      end
      item
        Caption = 'Status'
        Width = -2
        WidthType = (
          -2)
      end>
    ReadOnly = True
    TabOrder = 0
    ViewStyle = vsReport
  end
end
