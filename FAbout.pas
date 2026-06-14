unit FAbout;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Winapi.ShellAPI,
  Vcl.StdCtrls, Vcl.Imaging.pngimage;

type
  TFormAbout = class(TForm)
    LinkLabel1: TLinkLabel;
    Label1: TLabel;
    Label2: TLabel;
    LinkLabel2: TLinkLabel;
    imgIcon: TImage;
    btnClose: TButton;
    procedure LinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAbout: TFormAbout;

implementation

{$R *.dfm}

procedure TFormAbout.LinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
begin
  ShellExecute(Handle, 'open', PChar(Link), nil, nil, SW_SHOW);
end;

end.
