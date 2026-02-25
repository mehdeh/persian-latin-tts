unit Options;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ValEdit, StdCtrls;

type
  TForm2 = class(TForm)
    GroupBox1: TGroupBox;
    Button1: TButton;
    Label1: TLabel;
    MemoVowels: TMemo;
    Label2: TLabel;
    MemoConsonants: TMemo;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    MemoAlpha_Lower: TMemo;
    MemoAlpha_Upper: TMemo;
    Label5: TLabel;
    MemoNumbers: TMemo;
    Label6: TLabel;
    MemoSilence_Symbol: TMemo;
    Label7: TLabel;
    MemoSentence_EndPoint: TMemo;
    Label8: TLabel;
    MemoAlpha2: TMemo;
    Label9: TLabel;
    MemoAlpha1: TMemo;
    Button2: TButton;
    Button3: TButton;
    Label10: TLabel;
    MemoNumbers_Str: TMemo;
    Label11: TLabel;
    Label12: TLabel;
    MemoSymbol: TMemo;
    MemoSymbol_Str: TMemo;
    Label13: TLabel;
    MemoAlpha_Str: TMemo;
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
     procedure LoadFiles;
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses main;


{$R *.dfm}

procedure TForm2.Button2Click(Sender: TObject);
begin
     Close;
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
     LoadFiles;
end;

procedure TForm2.LoadFiles;
begin
     MemoAlpha_Lower.Lines.LoadFromFile(programpath+'Alpha_Lower.txt');
     MemoAlpha_Upper.Lines.LoadFromFile(programpath+'Alpha_Upper.txt');
     MemoAlpha_Str.Lines.LoadFromFile(programpath+'Alpha_Str.txt');
     MemoSilence_Symbol.Lines.LoadFromFile(programpath+'Silence_Symbol.txt');
     MemoNumbers.Lines.LoadFromFile(programpath+'Numbers.txt');
     MemoVowels.Lines.LoadFromFile(programpath+'Vowels.txt');
     MemoConsonants.Lines.LoadFromFile(programpath+'Consonants.txt');
     MemoSentence_EndPoint.Lines.LoadFromFile(programpath+'Sentence_EndPoint.txt');
     MemoAlpha2.Lines.LoadFromFile(programpath+'Alpha2.txt');
     MemoAlpha1.Lines.LoadFromFile(programpath+'Alpha1.txt');
     MemoNumbers_Str.Lines.LoadFromFile(programpath+'Numbers_Str.txt');
     MemoSymbol.Lines.LoadFromFile(programpath+'Symbol.txt');
     MemoSymbol_Str.Lines.LoadFromFile(programpath+'Symbol_Str.txt');






end;

procedure TForm2.Button1Click(Sender: TObject);
begin
     MemoAlpha_Lower.Lines.SaveToFile(programpath+'Alpha_Lower.txt');
     MemoAlpha_Upper.Lines.SaveToFile(programpath+'Alpha_Upper.txt');
     MemoAlpha_Str.Lines.SaveToFile(programpath+'Alpha_Str.txt');
     MemoSilence_Symbol.Lines.SaveToFile(programpath+'Silence_Symbol.txt');
     MemoNumbers.Lines.SaveToFile(programpath+'Numbers.txt');
     MemoVowels.Lines.SaveToFile(programpath+'Vowels.txt');
     MemoConsonants.Lines.SaveToFile(programpath+'Consonants.txt');
     MemoSentence_EndPoint.Lines.SaveToFile(programpath+'Sentence_EndPoint.txt');
     MemoAlpha2.Lines.SaveToFile(programpath+'Alpha2.txt');
     MemoAlpha1.Lines.SaveToFile(programpath+'Alpha1.txt');
     MemoNumbers_Str.Lines.SaveToFile(programpath+'Numbers_Str.txt');
     MemoSymbol.Lines.SaveToFile(programpath+'Symbol.txt');
     MemoSymbol_Str.Lines.SaveToFile(programpath+'Symbol_Str.txt');
end;

end.
