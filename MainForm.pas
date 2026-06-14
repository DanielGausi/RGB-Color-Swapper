unit MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Winapi.ShellAPI, System.Math,
  ColorSwap.Images, ColorSwap.Settings, FSettings,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls, VirtualTrees,
  System.Actions, Vcl.ActnList, Vcl.Menus, Vcl.ExtDlgs;

type
  TColorSwapMainForm = class(TForm)
    imgPreview: TImage;
    pnlMain: TPanel;
    selectDirectoryDialog: TFileOpenDialog;
    pnlControls: TPanel;
    Splitter1: TSplitter;
    cbSwapMode: TComboBox;
    pnlFileList: TPanel;
    RefreshPreviewTimer: TTimer;
    vstFiles: TVirtualStringTree;
    lblSwapMode: TLabel;
    ActionList1: TActionList;
    ActionAddFile: TAction;
    ActionAddDirectory: TAction;
    ActionClearFiles: TAction;
    MainMenu: TMainMenu;
    File1: TMenuItem;
    AddFile1: TMenuItem;
    AddDirectory1: TMenuItem;
    Clear1: TMenuItem;
    pnlImage: TPanel;
    SelectFileDialog: TFileOpenDialog;
    PopupMenu1: TPopupMenu;
    AddFile2: TMenuItem;
    AddDirectory2: TMenuItem;
    Clear2: TMenuItem;
    ActionSaveAs: TAction;
    FileSaveDialog: TFileSaveDialog;
    N1: TMenuItem;
    Saveas1: TMenuItem;
    ActionSaveAsJpeg: TAction;
    SaveasJPEG1: TMenuItem;
    N2: TMenuItem;
    Saveas2: TMenuItem;
    SaveasJPEG2: TMenuItem;
    ActionRemoveSelected: TAction;
    Removeselected1: TMenuItem;
    Removeselected2: TMenuItem;
    ActionShowSettings: TAction;
    N3: TMenuItem;
    Settings1: TMenuItem;
    Settings2: TMenuItem;
    pnlProgress: TPanel;
    btnCancel: TButton;
    pbSave: TProgressBar;
    N4: TMenuItem;
    ActionAbout: TAction;
    About1: TMenuItem;
    About2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbSwapModeChange(Sender: TObject);
    procedure imgPreviewResize(Sender: TObject);

    procedure RefreshPreviewTimerTimer(Sender: TObject);
    procedure vstFilesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure vstFilesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure ActionAddFileExecute(Sender: TObject);
    procedure ActionAddDirectoryExecute(Sender: TObject);
    procedure ActionClearFilesExecute(Sender: TObject);
    procedure ActionSaveAsExecute(Sender: TObject);
    procedure ActionSaveAsJpegExecute(Sender: TObject);
    procedure ActionRemoveSelectedExecute(Sender: TObject);
    procedure ActionShowSettingsExecute(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure ActionAddFileUpdate(Sender: TObject);
    procedure vstFilesCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure vstFilesHeaderClick(Sender: TVTHeader; HitInfo: TVTHeaderHitInfo);
    procedure ActionAboutExecute(Sender: TObject);
  private
    { Private declarations }
    FAllImages: TSwapImageList;
    fWorking: Boolean;
    fCancelled: Boolean;
    fColorSwapSettings: TColorSwapSettings;

    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;

    procedure PrepareSaveDialog(aFormatDescription, aExtension: string);
    procedure FillSwapModeSelection;
    procedure RefreshPreview;
    function FocussedSwapImage: TSwapImage;
    procedure FillTreeView;
    function ShowSettingsDialog: Integer;

    procedure SaveSingleFile;
    procedure SaveSingleFileAsJpeg;
    procedure SaveMultipleFiles(asJpeg: Boolean);
    procedure StartBatch(aCount: Integer);
    procedure FinishBatch;

  public
    { Public declarations }
    procedure Init;
  end;

var
  ColorSwapMainForm: TColorSwapMainForm;

implementation

{$R *.dfm}

uses FAbout;

procedure TColorSwapMainForm.FormCreate(Sender: TObject);
begin
  FAllImages := TSwapImageList.Create;
  fColorSwapSettings := TColorSwapSettings.Create;

  fWorking := False;
  DragAcceptFiles(Handle, True);
  Init;
end;

procedure TColorSwapMainForm.FormDestroy(Sender: TObject);
begin
  fColorSwapSettings.SwapMode := teSwapRGBMode(cbSwapMode.ItemIndex);
  fColorSwapSettings.SaveToIni;
  fColorSwapSettings.Free;

  FAllImages.Free;
  DragAcceptFiles(Handle, False);
end;

procedure TColorSwapMainForm.Init;
var
  sample: string;
begin
  fColorSwapSettings.LoadFromIni;
  FillSwapModeSelection;

  sample := ExtractFilepath(Application.ExeName) + 'sample.jpg';
  if FileExists(sample) then begin
    FAllImages.AddImage(sample);
    FillTreeView;
  end;
end;

procedure TColorSwapMainForm.WMDropFiles(var Msg: TWMDropFiles);
var
  i, fileCount: Integer;
  aFileName: array[0..MAX_PATH - 1] of Char;
begin
  inherited;

  if fWorking then
    exit;

  fileCount := DragQueryFile(Msg.Drop, $FFFFFFFF, nil, 0);
  for i := 0 to fileCount - 1 do begin
    DragQueryFile(Msg.Drop, i, aFileName, Length(aFileName));
    if (FileGetAttr((aFileName)) AND faDirectory <> faDirectory) then begin
      if IsCommonImageFile(aFileName) then
        FAllImages.AddImage(aFileName);
    end else
      FAllImages.AddDirectory(aFileName)
  end;
  DragFinish(Msg.Drop);

  // Show Files
  FillTreeView;
end;

function TColorSwapMainForm.FocussedSwapImage: TSwapImage;
var
  aNode: PVirtualNode;
begin
  aNode := vstFiles.FocusedNode;
  if assigned(aNode) then
    result := vstFiles.GetNodeData<TSwapImage>(aNode)
  else
    result := nil;
end;

procedure TColorSwapMainForm.ActionAddFileExecute(Sender: TObject);
var
  i: Integer;
begin
  if SelectFileDialog.Execute then begin
    for i := 0 to SelectFileDialog.Files.Count - 1 do
      FAllImages.AddImage(SelectFileDialog.Files[i]);
    FillTreeView;
  end;
end;

procedure TColorSwapMainForm.ActionAddFileUpdate(Sender: TObject);
begin
  if (Sender is TAction) then
    TAction(Sender).Enabled := not fWorking;
end;

procedure TColorSwapMainForm.ActionAboutExecute(Sender: TObject);
begin
  FormAbout.ShowModal;
end;

procedure TColorSwapMainForm.ActionAddDirectoryExecute(Sender: TObject);
begin
  if self.selectDirectoryDialog.Execute then begin
    FAllImages.AddDirectory(selectDirectoryDialog.FileName);
    FillTreeView;
  end;
end;

procedure TColorSwapMainForm.ActionClearFilesExecute(Sender: TObject);
begin
  FAllImages.Clear;
  FillTreeView;
  RefreshPreview;
end;

procedure TColorSwapMainForm.ActionRemoveSelectedExecute(Sender: TObject);
var
  selectedNodes: TNodeArray;
  aImg: TSwapImage;
  i: Integer;
begin
  selectedNodes := vstFiles.GetSortedSelection(True);
  vstFiles.BeginUpdate;
  try
    // remove selected Nodes
    for i := length(selectedNodes) - 1 downto 0 do begin
      aImg := vstFiles.GetNodeData<TSwapImage>(selectedNodes[i]);
      FAllImages.Remove(aImg);
    end;
    vstFiles.DeleteSelectedNodes;
  finally
    vstFiles.EndUpdate;
  end;
end;

procedure TColorSwapMainForm.PrepareSaveDialog(aFormatDescription, aExtension: string);
begin
  if FocussedSwapImage = nil then
    exit;

  FileSaveDialog.FileTypes.Clear;
  FileSaveDialog.DefaultExtension := aExtension;
  FocussedSwapImage.JpegQuality := fColorSwapSettings.JpegQuality;
  with FileSaveDialog.FileTypes.Add do begin
    DisplayName := aFormatDescription;
    FileMask := '*' + aExtension;
  end;
end;

procedure TColorSwapMainForm.SaveSingleFile;
var
  tmp: TSwapImage;
begin
  tmp := FocussedSwapImage;
  if assigned(tmp) then begin
    PrepareSaveDialog('Original File Format', tmp.Extension);
    tmp.JpegQuality := fColorSwapSettings.JpegQuality;
    if FileSaveDialog.Execute then begin
      tmp.saveAs(FileSaveDialog.FileName, False);
    end;
  end;
end;

procedure TColorSwapMainForm.SaveSingleFileAsJpeg;
var
  tmp: TSwapImage;
begin
  tmp := FocussedSwapImage;
  if assigned(tmp) then begin
    PrepareSaveDialog('JPEG Image Files', '.jpg');
    tmp.JpegQuality := fColorSwapSettings.JpegQuality;
    if FileSaveDialog.Execute then begin
      tmp.saveAs(FileSaveDialog.FileName, True);
    end;
  end;
end;

procedure TColorSwapMainForm.StartBatch(aCount: Integer);
begin
  fWorking := True;
  fCancelled := False;
  pnlProgress.Visible := True;
  pbSave.Max := aCount;
  pbSave.Position := 0;
end;

procedure TColorSwapMainForm.FinishBatch;
begin
  fWorking := False;
  pnlProgress.Visible := False;
end;

procedure TColorSwapMainForm.SaveMultipleFiles(asJpeg: Boolean);
  var
  selectedNodes: TNodeArray;
  swapImage: TSwapImage;
  i: Integer;
  editFilename, targetExt: string;
begin
  fColorSwapSettings.SaveAsJpeg := asJpeg;

  if ShowSettingsDialog = mrOk then begin
    // user preference for "asJpeg" may have changed in the SettingsDialog ...
    if fColorSwapSettings.SaveAsJpeg then
      targetExt := '.jpg'
    else
      targetExt := '';
    selectedNodes := vstFiles.GetSortedSelection(False);

    StartBatch(length(selectedNodes) - 1);
    try
      for i := 0 to length(selectedNodes) - 1 do begin
        // refresh progress, allow cancel
        pbSave.Position := i + 1;
        Application.ProcessMessages;
        if fCancelled then
          break;
        // process next image
        swapImage := vstFiles.GetNodeData<TSwapImage>(selectedNodes[i]);
        swapImage.JpegQuality := fColorSwapSettings.JpegQuality;
        swapImage.SwapMode := teSwapRGBMode(cbSwapMode.ItemIndex);
        case fColorSwapSettings.FileMode of
          fmReplace: editFilename := swapImage.OriginalEditFilename(fColorSwapSettings.SaveAsJpeg);
          fmRename: editFilename := swapImage.UniqueEditFilename('', targetExt);
          fmDifferentDirectory: editFilename := swapImage.UniqueEditFilename(fColorSwapSettings.SaveDirectory, targetExt);
        end;
        swapImage.saveAs(editFilename, fColorSwapSettings.SaveAsJpeg);
      end;
    finally
      FinishBatch;
    end;
  end;
end;

procedure TColorSwapMainForm.ActionSaveAsExecute(Sender: TObject);
begin
  if self.vstFiles.SelectedCount <= 1 then
    SaveSingleFile
  else
    SaveMultipleFiles(False);
end;

procedure TColorSwapMainForm.ActionSaveAsJpegExecute(Sender: TObject);
begin
  if self.vstFiles.SelectedCount <= 1 then
    SaveSingleFileAsJpeg
  else
    SaveMultipleFiles(True);
end;

procedure TColorSwapMainForm.ActionShowSettingsExecute(Sender: TObject);
begin
  ShowSettingsDialog;
end;

procedure TColorSwapMainForm.btnCancelClick(Sender: TObject);
begin
  fCancelled := True;
end;

procedure TColorSwapMainForm.cbSwapModeChange(Sender: TObject);
begin
  RefreshPreview;
end;

procedure TColorSwapMainForm.FillSwapModeSelection;
var
  i: teSwapRGBMode;
begin
  cbSwapMode.Items.Clear;
  for i := Low(teSwapRGBMode) to High(teSwapRGBMode) do
    cbSwapMode.Items.Add(cSwapRGBModes[i]);

  cbSwapMode.ItemIndex := Integer(fColorSwapSettings.SwapMode);
end;

procedure TColorSwapMainForm.RefreshPreview;
var
  tmp: TSwapImage;
begin
  if fWorking then
    exit;

  tmp := FocussedSwapImage;
  if assigned(tmp) then begin
    tmp.PreviewWidth := imgPreview.Width;
    tmp.PreviewHeight := imgPreview.Height;
    tmp.SwapMode := teSwapRGBMode(cbSwapMode.ItemIndex);
    imgPreview.Picture.Assign(tmp.PreviewEdit);
  end else
    imgPreview.Picture.Assign(nil);

  imgPreview.Refresh;
end;

procedure TColorSwapMainForm.FillTreeView;
var
  i: Integer;
  firstNode: PVirtualNode;
begin
  if fWorking then
    exit;

  vstFiles.BeginUpdate;
  try
    vstFiles.Clear;
    for i := 0 to FAllImages.Count - 1 do begin
      vstFiles.AddChild(nil, FAllImages[i]);
    end;

    firstNode := vstFiles.GetFirst;
    if assigned(firstNode) then begin
      vstFiles.Selected[firstNode] := True;
      vstFiles.FocusedNode := firstNode;
    end;

  finally
    vstFiles.EndUpdate;
  end;
end;

function TColorSwapMainForm.ShowSettingsDialog: Integer;
var
  FormSettings: TFormSettings;
begin
  FormSettings := TFormSettings.Create(nil);
  try
    FormSettings.ColorSwapSettings := fColorSwapSettings;
    Result := FormSettings.ShowModal;
  finally
    FormSettings.Free;
  end;
end;

procedure TColorSwapMainForm.imgPreviewResize(Sender: TObject);
begin
  RefreshPreviewTimer.Enabled := False;
  RefreshPreviewTimer.Enabled := True;
end;

procedure TColorSwapMainForm.RefreshPreviewTimerTimer(Sender: TObject);
begin
  RefreshPreviewTimer.Enabled := False;
  RefreshPreview;
end;

procedure TColorSwapMainForm.vstFilesGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  swapImage: TSwapImage;
begin

  swapImage := Sender.GetNodeData<TSwapImage>(Node);

  case Column of
    0: CellText := ExtractFilename(swapImage.Filename);
    1: CellText := swapImage.Extension;
    2: if (swapImage.Width > 0) and (swapImage.Height > 0 ) then
          CellText := Format('%d x %d', [swapImage.Width, swapImage.Height])
       else CellText := '';
    3: if swapImage.FileSize > 0 then
          CellText := Format('%d KB', [round(swapImage.FileSize / 1024)])
       else CellText := '';
    4: DateTimeToString(CellText, 'ddddd t', swapImage.LastModified);
  end;
end;


procedure TColorSwapMainForm.vstFilesChange(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  if fWorking then
    exit;
  RefreshPreview;

end;

procedure TColorSwapMainForm.vstFilesHeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
begin
  if fWorking then
    exit;

  if Sender.SortColumn <> HitInfo.Column then
    Sender.SortColumn := HitInfo.Column
  else
    if Sender.SortDirection = sdAscending then
      Sender.SortDirection := sdDescending
    else
      Sender.SortDirection := sdAscending;
  Sender.Treeview.SortTree( HitInfo.Column, Sender.SortDirection);
end;

procedure TColorSwapMainForm.vstFilesCompareNodes(Sender: TBaseVirtualTree;
  Node1, Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  img1, img2: TSwapImage;
begin
  img1 := Sender.GetNodeData<TSwapImage>(Node1);
  img2 := Sender.GetNodeData<TSwapImage>(Node2);
  case Column of
    0: result := AnsiCompareText(img1.Filename, img2.Filename);
    1: result := AnsiCompareText(img1.Extension, img2.Extension);
    2: begin
      result := CompareValue(img1.Width, img2.Width);
      if result = 0 then
        result := CompareValue(img1.Height, img2.Height);
    end;
    3: result := CompareValue(img1.FileSize, img2.FileSize);
    4: result := CompareValue(img1.LastModified, img2.LastModified);
  end;
end;

end.
