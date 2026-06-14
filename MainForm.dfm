object ColorSwapMainForm: TColorSwapMainForm
  Left = 0
  Top = 0
  Caption = 'RGB Color Swapper'
  ClientHeight = 538
  ClientWidth = 1003
  Color = clWindow
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object pnlMain: TPanel
    Left = 0
    Top = 0
    Width = 1003
    Height = 504
    Align = alClient
    BevelOuter = bvNone
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 0
    OnResize = imgPreviewResize
    object Splitter1: TSplitter
      Left = 595
      Top = 0
      Height = 504
      ResizeStyle = rsUpdate
      OnMoved = imgPreviewResize
      ExplicitLeft = 601
      ExplicitTop = 6
      ExplicitHeight = 353
    end
    object pnlFileList: TPanel
      Left = 0
      Top = 0
      Width = 595
      Height = 504
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object vstFiles: TVirtualStringTree
        AlignWithMargins = True
        Left = 8
        Top = 8
        Width = 579
        Height = 488
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 8
        Align = alClient
        Header.AutoSizeIndex = 0
        Header.Options = [hoAutoResize, hoColumnResize, hoDblClickResize, hoDrag, hoShowSortGlyphs, hoVisible]
        Indent = 0
        PopupMenu = PopupMenu1
        TabOrder = 0
        TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages]
        TreeOptions.SelectionOptions = [toFullRowSelect, toMultiSelect]
        OnChange = vstFilesChange
        OnCompareNodes = vstFilesCompareNodes
        OnGetText = vstFilesGetText
        OnHeaderClick = vstFilesHeaderClick
        Touch.InteractiveGestures = [igPan, igPressAndTap]
        Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
        Columns = <
          item
            Position = 0
            Text = 'Filename'
            Width = 245
          end
          item
            Position = 1
            Text = 'Type'
          end
          item
            Position = 2
            Text = 'Dimensions'
            Width = 90
          end
          item
            Position = 3
            Text = 'Size'
            Width = 70
          end
          item
            Position = 4
            Text = 'Last modified'
            Width = 120
          end>
      end
    end
    object pnlImage: TPanel
      Left = 598
      Top = 0
      Width = 405
      Height = 504
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object imgPreview: TImage
        AlignWithMargins = True
        Left = 8
        Top = 46
        Width = 389
        Height = 450
        Margins.Left = 8
        Margins.Top = 8
        Margins.Right = 8
        Margins.Bottom = 8
        Align = alClient
        Center = True
        Proportional = True
        Stretch = True
        ExplicitLeft = 11
        ExplicitTop = 136
        ExplicitHeight = 185
      end
      object pnlControls: TPanel
        AlignWithMargins = True
        Left = 0
        Top = 0
        Width = 397
        Height = 38
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 8
        Margins.Bottom = 0
        Align = alTop
        BevelEdges = [beBottom]
        BevelKind = bkFlat
        BevelOuter = bvNone
        TabOrder = 0
        object lblSwapMode: TLabel
          Left = 8
          Top = 11
          Width = 62
          Height = 15
          Caption = 'Swap mode'
        end
        object cbSwapMode: TComboBox
          Left = 81
          Top = 8
          Width = 105
          Height = 23
          Style = csDropDownList
          TabOrder = 0
          OnChange = cbSwapModeChange
        end
      end
    end
  end
  object pnlProgress: TPanel
    Left = 0
    Top = 504
    Width = 1003
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    Visible = False
    object btnCancel: TButton
      AlignWithMargins = True
      Left = 920
      Top = 4
      Width = 75
      Height = 26
      Margins.Left = 8
      Margins.Top = 4
      Margins.Right = 8
      Margins.Bottom = 4
      Align = alRight
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 0
      OnClick = btnCancelClick
    end
    object pbSave: TProgressBar
      AlignWithMargins = True
      Left = 8
      Top = 8
      Width = 896
      Height = 18
      Margins.Left = 8
      Margins.Top = 8
      Margins.Right = 8
      Margins.Bottom = 8
      Align = alClient
      TabOrder = 1
    end
  end
  object selectDirectoryDialog: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = [fdoPickFolders]
    Left = 32
    Top = 104
  end
  object RefreshPreviewTimer: TTimer
    OnTimer = RefreshPreviewTimerTimer
    Left = 416
    Top = 73
  end
  object ActionList1: TActionList
    Left = 104
    Top = 40
    object ActionAddFile: TAction
      Caption = 'Add File'
      ShortCut = 16463
      OnExecute = ActionAddFileExecute
      OnUpdate = ActionAddFileUpdate
    end
    object ActionAddDirectory: TAction
      Caption = 'Add Directory'
      ShortCut = 24655
      OnExecute = ActionAddDirectoryExecute
      OnUpdate = ActionAddFileUpdate
    end
    object ActionClearFiles: TAction
      Caption = 'Clear'
      OnExecute = ActionClearFilesExecute
      OnUpdate = ActionAddFileUpdate
    end
    object ActionSaveAs: TAction
      Caption = 'Save as'
      ShortCut = 16467
      OnExecute = ActionSaveAsExecute
      OnUpdate = ActionAddFileUpdate
    end
    object ActionSaveAsJpeg: TAction
      Caption = 'Save as JPEG'
      ShortCut = 16458
      OnExecute = ActionSaveAsJpegExecute
      OnUpdate = ActionAddFileUpdate
    end
    object ActionRemoveSelected: TAction
      Caption = 'Remove selected'
      ShortCut = 46
      OnExecute = ActionRemoveSelectedExecute
      OnUpdate = ActionAddFileUpdate
    end
    object ActionShowSettings: TAction
      Caption = 'Settings'
      ShortCut = 114
      OnExecute = ActionShowSettingsExecute
      OnUpdate = ActionAddFileUpdate
    end
    object ActionAbout: TAction
      Caption = 'About'
      OnExecute = ActionAboutExecute
    end
  end
  object MainMenu: TMainMenu
    Left = 32
    Top = 41
    object File1: TMenuItem
      Caption = 'File'
      object AddFile1: TMenuItem
        Action = ActionAddFile
      end
      object AddDirectory1: TMenuItem
        Action = ActionAddDirectory
      end
      object Removeselected1: TMenuItem
        Action = ActionRemoveSelected
      end
      object Clear1: TMenuItem
        Action = ActionClearFiles
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Saveas2: TMenuItem
        Action = ActionSaveAs
      end
      object SaveasJPEG2: TMenuItem
        Action = ActionSaveAsJpeg
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object Settings2: TMenuItem
        Action = ActionShowSettings
      end
      object About2: TMenuItem
        Action = ActionAbout
      end
    end
  end
  object SelectFileDialog: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'All Images'
        FileMask = 
          '*.wbmp;*.webp;*.svg;*.gif;*.jpg;*.jpeg;*.png;*.bmp;*.ico;*.emf;*' +
          '.wmf;*.tif;*.tiff'
      end
      item
        DisplayName = 'JPEG Image Files'
        FileMask = '*.jpg;*.jpeg'
      end
      item
        DisplayName = 'Portable Network Graphics'
        FileMask = '*.png'
      end
      item
        DisplayName = 'Bitmaps'
        FileMask = '*.bmp'
      end>
    Options = [fdoAllowMultiSelect]
    Left = 128
    Top = 112
  end
  object PopupMenu1: TPopupMenu
    Left = 296
    Top = 224
    object AddFile2: TMenuItem
      Action = ActionAddFile
    end
    object AddDirectory2: TMenuItem
      Action = ActionAddDirectory
    end
    object Removeselected2: TMenuItem
      Action = ActionRemoveSelected
    end
    object Clear2: TMenuItem
      Action = ActionClearFiles
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Saveas1: TMenuItem
      Action = ActionSaveAs
    end
    object SaveasJPEG1: TMenuItem
      Action = ActionSaveAsJpeg
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Settings1: TMenuItem
      Action = ActionShowSettings
    end
    object About1: TMenuItem
      Action = ActionAbout
    end
  end
  object FileSaveDialog: TFileSaveDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = [fdoOverWritePrompt]
    Left = 128
    Top = 176
  end
end
