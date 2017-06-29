unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TAdditionalWindow = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AdditionalWindow: TAdditionalWindow;

implementation

uses Unit1;

{$R *.dfm}

procedure TAdditionalWindow.Button1Click(Sender: TObject);
begin
  Main.Close;
end;

end.
