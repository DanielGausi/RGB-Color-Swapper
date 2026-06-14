object FormSettings: TFormSettings
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Settings'
  ClientHeight = 311
  ClientWidth = 443
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  DesignSize = (
    443
    311)
  TextHeight = 15
  object grpJpegQuality: TGroupBox
    AlignWithMargins = True
    Left = 8
    Top = 161
    Width = 427
    Height = 104
    Margins.Left = 8
    Margins.Top = 0
    Margins.Right = 8
    Margins.Bottom = 8
    Align = alTop
    Caption = 'Jpeg quality settings (90)'
    TabOrder = 1
    object lblBestCompression: TLabel
      Left = 24
      Top = 60
      Width = 93
      Height = 15
      Alignment = taCenter
      Caption = 'Best compression'
    end
    object lblBestQuality: TLabel
      Left = 331
      Top = 60
      Width = 61
      Height = 15
      Alignment = taCenter
      Caption = 'Best quality'
    end
    object tbJpegQuality: TTrackBar
      Left = 125
      Top = 52
      Width = 200
      Height = 45
      Max = 100
      PageSize = 10
      Frequency = 10
      Position = 90
      TabOrder = 1
      OnChange = tbJpegQualityChange
    end
    object cbSaveAsJpeg: TCheckBox
      Left = 8
      Top = 24
      Width = 329
      Height = 17
      Caption = 'Save all files as jpeg'
      TabOrder = 0
    end
  end
  object grpBoxFileOptions: TGroupBox
    AlignWithMargins = True
    Left = 8
    Top = 8
    Width = 427
    Height = 145
    Margins.Left = 8
    Margins.Top = 8
    Margins.Right = 8
    Margins.Bottom = 8
    Align = alTop
    Caption = 'File options'
    TabOrder = 0
    object rbReplaceOriginal: TRadioButton
      AlignWithMargins = True
      Left = 8
      Top = 24
      Width = 300
      Height = 17
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Caption = 'Replace original files'
      TabOrder = 0
    end
    object rbRenameEdited: TRadioButton
      Left = 8
      Top = 48
      Width = 369
      Height = 17
      Caption = 'Rename edited files and save in original directory'
      TabOrder = 1
    end
    object rbSaveDifferentDirectory: TRadioButton
      Left = 8
      Top = 72
      Width = 393
      Height = 17
      Caption = 'Save files in different directory'
      TabOrder = 2
    end
    object edtSaveDirectory: TEdit
      Left = 30
      Top = 97
      Width = 329
      Height = 23
      TabOrder = 4
    end
    object btnSelectDir: TButton
      Left = 365
      Top = 96
      Width = 34
      Height = 25
      Caption = '...'
      TabOrder = 3
      OnClick = btnSelectDirClick
    end
  end
  object btnOk: TButton
    Left = 270
    Top = 278
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 2
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 360
    Top = 278
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object SelectSaveDirDialog: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = [fdoPickFolders, fdoCreatePrompt]
    Left = 344
    Top = 24
  end
end
