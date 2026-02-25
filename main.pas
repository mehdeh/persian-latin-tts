unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtDlgs, Menus,Options,Types,func, MPlayer;


type

  TKindPart=(KP_word,KP_symbol);
  TKindSyllable=(KSy_UnKnown,KSy_CV,KSy_CVC,KSy_CVCC);

  TSyllable=record
      Kind:TKindSyllable;
      Diphone:array[1..3] of string;
      Value:string;
      Count:Integer;
  end;

  TPart=record
      Kind:TKindPart;
      Syllable:array[1..20] of TSyllable;
      Value:string;
      Count:Integer;
  end;

  TKindSentence=(KS_UnKnown,KS_amri,KS_khabari,KS_Question,KS_taejobi);

  TSentence=record
     Kind:TKindSentence;
     Value:string;
     Part:array[1..30] of TPart;
     Count:Integer;
  end;

  TText=record
     Sentence:array[1..20] of TSentence;
     Count:Integer;
     value:string;
  end;

  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Exit1: TMenuItem;
    N1: TMenuItem;
    Open1: TMenuItem;
    SaveAs1: TMenuItem;
    Options1: TMenuItem;
    N2: TMenuItem;
    SaveTextFileDialog1: TSaveTextFileDialog;
    OpenTextFileDialog1: TOpenTextFileDialog;
    Save1: TMenuItem;
    Memo4: TMemo;
    MediaPlayer1: TMediaPlayer;
    procedure FormShow(Sender: TObject);
    procedure Options1Click(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure SaveAsClick(Sender: TObject);
    procedure OpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
     LastFileSaved:string;
    { Private declarations }
  public
    { Public declarations }
  end;

function TextToSentenceToPartToDiPhone(s:string):TText;
function IsVowel(s:ShortString):Boolean;
function IsConsonant(s:ShortString):Boolean;
function IsNumber(s:ShortString):Boolean;
function IsSentenceEnd(s:ShortString):Boolean;
function PreProcess(s:string):string;
function ConvertNumbersToStr(s:string):string;
function Convert2chTo1ch(s:string):string;
function NumberToStr(s:string):string;
function ConvertSymbolToStr(s:string):string;
procedure SetWordChar;
function Insert_Hamze(s:string):string;
function Is_CVCCC(s:string):Boolean;
function Is_CVCCV(s:string):Boolean;
function Is_CVCV(s:string):Boolean;
function Is_CVCC(s:string):Boolean;
function Is_CVC(s:string):Boolean;
function Is_CV(s:string):Boolean;
function Is_C(s:string):Boolean;
function Is_V(s:string):Boolean;
function Check_RulsAndCovertions(s:string):string;
procedure SentenceToWave(sentence:TSentence;var Data:TDoubleDynArray;var Ts,Fs:Cardinal;var bps:byte);
function DiphoneToWave(Diphone:string;var Data:TDoubleDynArray;var Ts,Fs:Cardinal;var bps:byte):boolean;
procedure SymbolToWave(Symbol:string;var Data:TDoubleDynArray;var Ts,Fs:Cardinal;var bps:byte);
procedure AddData(var Data:TDoubleDynArray;DataTemp:TDoubleDynArray;Overlap:Double);

var
  Form1: TForm1;

  ProgramPath:string;
  WORDCHAR:set of char;

implementation

{$R *.dfm}

function Check_RulsAndCovertions(s:string):string;
//var
//     state:byte;
//     Index,startpoint,endpoint:Integer;
begin

//     while  do
//     begin
//
//
//          case state of
//
//               0:
//               1:
//               2:
//               3:
//               4:
//               5:
//               6:
//
//               else
//
//
//
//          end;
//
//
//
//
//     end;


end;


procedure SentenceToWave(sentence:TSentence;var Data:TDoubleDynArray;var Ts,Fs:Cardinal;var bps:byte);
var
     IndexPart,IndexSyllable,IndexDiphone:Integer;
     Diphone:string;
     DataTemp:TDoubleDynArray;
     Ts1,Fs1:Cardinal;
     bps1:byte;
begin
     SetLength(Data,1);
     for IndexPart := 1 to sentence.Count do
     if sentence.part[IndexPart].Kind=KP_word then
          for IndexSyllable := 1 to sentence.part[IndexPart].Count do
          for IndexDiphone := 1 to sentence.part[IndexPart].Syllable[IndexSyllable].Count do
          begin
               Diphone:=sentence.part[IndexPart].Syllable[IndexSyllable].Diphone[IndexDiphone];
               if DiphoneToWave(Diphone,DataTemp,Ts1,Fs1,bps1) then
               begin
                    AddData(Data,DataTemp,0.35);
               end;
          end
     else
     begin
          SymbolToWave(sentence.part[IndexPart].Value,DataTemp,Ts1,Fs1,bps1);
          AddData(Data,DataTemp,0.2);
     end;


     Ts:=Length(Data)-1;
     Fs:=Fs_Def;
     bps:=bps_Def;
end;


function DiphoneToWave(Diphone:string;var Data:TDoubleDynArray;var Ts,Fs:Cardinal;var bps:byte):boolean;
var
     stemp:string;
     i: Integer;
begin
     stemp:=ProgramPath+'Waves\'+Diphone+'.wav';
     Result:=true;
     if FileExists(stemp) then
     begin
          OpenWaveFile(stemp,Fs,Ts,bps,Data);
          for i := 1 to Ts do
          begin
               Data[i]:=Data[i]*(0.54+0.46*cos(2*pi*(i-Ts/2)/Ts))
          end;

     end
     else
          Result:=False;
end;

procedure SymbolToWave(Symbol:string;var Data:TDoubleDynArray;var Ts,Fs:Cardinal;var bps:byte);
var
     len,I:Integer;
begin
     len:=Length(Symbol);
     Fs:=Fs_Def;
     bps:=bps_Def;
     Ts:=Round(0.2*Fs*len);
     SetLength(Data,Ts+1);
     for I := 1 to Ts do
     begin
          Data[I]:=0;
     end;
end;

procedure AddData(var Data:TDoubleDynArray;DataTemp:TDoubleDynArray;Overlap:Double);
var
     LenData,LenDataTemp,i,lowDataTemp,HiData:Integer;
begin
     LenData:=Length(Data)-1;
     LenDataTemp:=Length(DataTemp)-1;
     HiData:=LenData+Round(LenDataTemp*(1-Overlap));
     lowDataTemp:=LenData-Round(LenDataTemp*Overlap)+1;
     if lowDataTemp<=1 then
     begin
          lowDataTemp:=1;
          HiData:=LenDataTemp;
     end;


     SetLength(Data,HiData+1);

     for i :=lowDataTemp to HiData do
     begin
          if i<=LenData then
               Data[i]:=(Data[i]+DataTemp[i-lowDataTemp+1])/2
          else
               Data[i]:=DataTemp[i-lowDataTemp+1];
     end;

end;


function NumberToStr(s:string):string;
var
     scount:Integer;
     index: Integer;
     stemp:string;
begin
     SCount:=Length(S);
     index:=1;
     stemp:=' ';
     while index<=scount do
     begin
          stemp:=stemp+Form2.MemoNumbers_Str.Lines[strtoint(s[index])]+' ';
          Inc(index);
     end;
     Result:=stemp;

end;
function ConvertSymbolToStr(s:string):string;
var
     stemp,oldpattern,newpattern:string;
     i: Integer;
begin
     stemp:=s;
     for i := 0 to Form2.MemoAlpha2.Lines.Count- 1 do
     begin
          oldpattern:=Form2.MemoSymbol.Lines[i];
          newpattern:=Form2.MemoSymbol_Str.Lines[i];
          stemp:=StringReplace(stemp,oldpattern,newpattern,[rfReplaceAll,rfIgnoreCase]);
     end;
     Result:=stemp;
end;
function Convert2chTo1ch(s:string):string;
var
     stemp,oldpattern,newpattern:string;
     i: Integer;
begin
     stemp:=s;
     for i := 0 to Form2.MemoAlpha2.Lines.Count- 1 do
     begin
          oldpattern:=Form2.MemoAlpha2.Lines[i];
          newpattern:=Form2.MemoAlpha1.Lines[i];
          stemp:=StringReplace(stemp,oldpattern,newpattern,[rfReplaceAll,rfIgnoreCase]);
     end;
     Result:=stemp;
end;
function ConvertNumbersToStr(s:string):string;
var
     index,startpoint,endpoint:Integer;
     SCount:Integer;
     ftemp:Shortint;
     Stemp:string;
     SResult:string;
begin
     SCount:=Length(S);
     index:=1;
     startpoint:=1;
     endpoint:=0;
     ftemp:=-1;
     SResult:='';
     while index<=SCount do
     begin
          if (ftemp=-1) and IsNumber(S[index]) then
          begin
               SResult:=SResult+Copy(S,endpoint+1,index-endpoint-1);
               startpoint:=index;
               ftemp:=0;
          end;

          if (ftemp=0) and not IsNumber(S[index]) then
          begin
               endpoint:=index-1;
               STemp:=Copy(S,startpoint,endpoint-startpoint+1);
               Stemp:=NumberToStr(Stemp);
               SResult:=SResult+Stemp;
               ftemp:=-1;
          end;
          Inc(index);
     end;
     if (ftemp=-1) then
          SResult:=SResult+Copy(S,endpoint+1,index-endpoint-1)
     else
     begin
          endpoint:=index-1;
          STemp:=Copy(S,startpoint,endpoint-startpoint+1);
          Stemp:=NumberToStr(Stemp);
          SResult:=SResult+Stemp;
     end;

     Result:=SResult;

end;
procedure SetWordChar;
var
     i:Integer;
     stemp:string;

begin
     WORDCHAR:=['a'..'z'];
     WORDCHAR:=WORDCHAR+['A'..'Z'];

     for I := 0 to Form2.MemoAlpha1.Lines.Count - 1 do
     begin
          Stemp:=form2.MemoAlpha1.Lines[i];
          WORDCHAR:=WORDCHAR+[stemp[1]];
     end;

     for I := 0 to Form2.MemoVowels.Lines.Count - 1 do
     begin
          Stemp:=form2.MemoVowels.Lines[i];
          WORDCHAR:=WORDCHAR+[stemp[1]];
     end;

     for I := 0 to Form2.MemoConsonants.Lines.Count - 1 do
     begin
          Stemp:=form2.MemoConsonants.Lines[i];
          WORDCHAR:=WORDCHAR+[stemp[1]];
     end;
end;
function Insert_Hamze(s:string):string;
var
     stemp:string;
     index:Integer;
     scount:Integer;
begin
     stemp:=s;
     scount:=Length(stemp);
     for index := 1 to scount do
     begin
          if ISVowel(stemp[index]) then
          begin
               if ((index>1) and not(IsConsonant(stemp[index-1])))or(index=1) then
               begin
                    Insert('w',stemp,index);
               end;
          end;
     end;


     Result:=stemp;
end;

function PreProcess(s:string):string;
var
   //  index,startpoint,endpoint:Integer;
   //  SCount:Integer;
     Stemp:string;
begin
     SetWordChar;
     Stemp:=LowerCase(s);
     stemp:=ConvertNumbersToStr(stemp);
     Stemp:=ConvertSymbolToStr(Stemp);
     //.
     //.
     //.
     stemp:=Convert2chTo1ch(stemp);

     stemp:=Insert_Hamze(stemp);  //   VV -> VwV
     //stemp:=Convert_i_To_y(stemp);
     //....                        //  CCC ->.. ...      CV   CVC   CVCC
   //  stemp:=Check_RulsAndCovertions(stemp); // bbe -> bi be
     Result:=Stemp;
end;
function IsSentenceEnd(s:ShortString):Boolean;
var
  I: Integer;
begin
     Result:=false;
     for I := 0 to Form2.MemoSentence_EndPoint.Lines.Count - 1 do
          if s=Form2.MemoSentence_EndPoint.Lines[i] then
               Result:=true;
end;
function IsNumber(s:ShortString):Boolean;
var
  I: Integer;
begin
     Result:=false;
     for I := 0 to Form2.MemoNumbers.Lines.Count - 1 do
          if s=Form2.MemoNumbers.Lines[i] then
               Result:=true;
end;
function IsVowel(s:ShortString):Boolean;
var
  I: Integer;
begin
     Result:=false;
     for I := 0 to Form2.MemoVowels.Lines.Count - 1 do
          if s=Form2.MemoVowels.Lines[i] then
               Result:=true;
end;
function IsConsonant(s:ShortString):Boolean;
var
  I: Integer;
begin
     Result:=false;
     for I := 0 to Form2.MemoConsonants.Lines.Count - 1 do
          if s=Form2.MemoConsonants.Lines[i] then
               Result:=true;
end;
function TextToSentenceToPartToDiPhone(s:string):TText;
var
     index,startpoint:Integer;
     Scount:Integer;
     Text:TText;
     i: Integer;
     temp: Integer;
     ftemp:Shortint;
  Stemp: string;
  IndexSen: Integer;
  part:string;
  IndexPart,IndexSyllable: Integer;
  Syllable: string;
  kind: TKindSyllable;

begin

// ============    Text To Sentences     ==============
     Scount:= Length(s);
     Text.value:=s;
     Text.Count:=0;
     startpoint:=1;
     for index:= 1 to Scount do
     begin
          if  IsSentenceEnd(s[index]) then
          begin
               if (index-startpoint)> 0 then
               begin
                    Inc(Text.Count);
                    Text.Sentence[Text.Count].Value:=Copy(s,startpoint,index-startpoint);
               end;
               startpoint:=index+1;
          end;
     end;

// ==========      Sentence To Parts       ====================

     for index := 1 to Text.Count do
     begin
          Text.Sentence[index].Count:=0;
          Stemp:=Text.Sentence[index].Value;
          Scount:=Length(Stemp);
          startpoint:=1;

          if stemp[startpoint] in WORDCHAR then
               ftemp:=0
          else
               ftemp:=-1;

          for i := 1 to Scount do
          begin
               if (Stemp[i] in WORDCHAR) and (ftemp=-1) then
               begin
                    inc(Text.Sentence[index].Count);
                    temp:=Text.Sentence[index].Count;
                    Text.Sentence[index].Part[temp].Value:=Copy(Stemp,startpoint,i-startpoint);
                    Text.Sentence[index].Part[temp].Kind:=KP_symbol;
                    ftemp:=0;
                    startpoint:=i;
               end;

               if (not(Stemp[i] in WORDCHAR)) and (ftemp=0) then
               begin
                    inc(Text.Sentence[index].Count);
                    temp:=Text.Sentence[index].Count;
                    Text.Sentence[index].Part[temp].Value:=Copy(Stemp,startpoint,i-startpoint);
                    Text.Sentence[index].Part[temp].Kind:=KP_word;
                    ftemp:=-1;
                    startpoint:=i;
               end;
          end;

          inc(Text.Sentence[index].Count);
          temp:=Text.Sentence[index].Count;
          Text.Sentence[index].Part[temp].Value:=Copy(Stemp,startpoint,Scount+1-startpoint);

          if stemp[startpoint] in WORDCHAR then
               Text.Sentence[index].Part[temp].Kind:=KP_word
          else
               Text.Sentence[index].Part[temp].Kind:=KP_symbol;
     end;

// ================      Parts To Syllable      ==================

     for IndexSen := 1 to Text.Count do
     begin

          for IndexPart := 1 to Text.Sentence[IndexSen].Count do
          begin
               part:=Text.Sentence[IndexSen].part[IndexPart].Value;
               Scount:=Length(part);

               Text.Sentence[IndexSen].part[IndexPart].Count:=0;
               if Text.Sentence[IndexSen].part[IndexPart].Kind=KP_word then
               begin
                    index:=1;
                    while (index<=Scount) do
                    begin
                         if (Scount-index+1 >= 5) and  IS_CVCCC(Copy(part,index,5)) then
                         begin
                              Inc(Text.Sentence[IndexSen].part[IndexPart].Count);
                              temp:=Text.Sentence[IndexSen].part[IndexPart].Count;
                              Text.Sentence[IndexSen].part[IndexPart].Syllable[temp].Value:=Copy(part,index,4);
                              Text.Sentence[IndexSen].part[IndexPart].Syllable[temp].Kind:=KSy_CVCC;
                              index:=index+3;
                         end
                         else
                         begin
                              if (Scount-index+1 >= 5) and IS_CVCCV(Copy(part,index,5)) then
                              begin
                                   Inc(Text.Sentence[IndexSen].part[IndexPart].Count);
                                   temp:=Text.Sentence[IndexSen].part[IndexPart].Count;
                                   Text.Sentence[IndexSen].part[IndexPart].Syllable[temp].Value:=Copy(part,index,3);
                                   Text.Sentence[IndexSen].part[IndexPart].Syllable[temp].Kind:=KSy_CVC;
                                   index:=index+2;
                              end
                              else
                              begin
                                   if (Scount-index+1 >= 4) and IS_CVCV(Copy(part,index,4)) then
                                   begin
                                        Inc(Text.Sentence[IndexSen].part[IndexPart].Count);
                                        temp:=Text.Sentence[IndexSen].part[IndexPart].Count;
                                        Text.Sentence[IndexSen].part[IndexPart].Syllable[temp].Value:=Copy(part,index,2);
                                        Text.Sentence[IndexSen].part[IndexPart].Syllable[temp].Kind:=KSy_CV;
                                        index:=index+1;
                                   end
                                   else
                                   begin
                                        if (Scount-index+1 >= 4) and IS_CVCC(Copy(part,index,4)) then
                                        begin
                                             Inc(Text.Sentence[IndexSen].part[IndexPart].Count);
                                             temp:=Text.Sentence[IndexSen].part[IndexPart].Count;
                                             Text.Sentence[IndexSen].part[IndexPart].Syllable[temp].Value:=Copy(part,index,4);
                                             Text.Sentence[IndexSen].part[IndexPart].Syllable[temp].Kind:=KSy_CVCC;
                                             index:=index+3;
                                        end
                                        else
                                        begin
                                             if (Scount-index+1 >= 3) and IS_CVC(Copy(part,index,3)) then
                                             begin
                                                  Inc(Text.Sentence[IndexSen].part[IndexPart].Count);
                                                  temp:=Text.Sentence[IndexSen].part[IndexPart].Count;
                                                  Text.Sentence[IndexSen].part[IndexPart].Syllable[temp].Value:=Copy(part,index,3);
                                                  Text.Sentence[IndexSen].part[IndexPart].Syllable[temp].Kind:=KSy_CVC;
                                                  index:=index+2;
                                             end
                                             else
                                             begin
                                                  if (Scount-index+1 >= 2) and IS_CV(Copy(part,index,2)) then
                                                  begin
                                                       Inc(Text.Sentence[IndexSen].part[IndexPart].Count);
                                                       temp:=Text.Sentence[IndexSen].part[IndexPart].Count;
                                                       Text.Sentence[IndexSen].part[IndexPart].Syllable[temp].Value:=Copy(part,index,2);
                                                       Text.Sentence[IndexSen].part[IndexPart].Syllable[temp].Kind:=KSy_CV;
                                                       index:=index+1;
                                                  end
                                                  else
                                                  begin
                                                       if (Scount-index+1 >= 1) and IS_C(Copy(part,index,1)) then
                                                       begin
                                                            Inc(Text.Sentence[IndexSen].part[IndexPart].Count);
                                                            temp:=Text.Sentence[IndexSen].part[IndexPart].Count;
                                                            Text.Sentence[IndexSen].part[IndexPart].Syllable[temp].Value:=Copy(part,index,1);
                                                            Text.Sentence[IndexSen].part[IndexPart].Syllable[temp].Kind:=KSy_UnKnown;
                                                            index:=index+0;
                                                       end
                                                       else
                                                       begin
                                                            if (Scount-index+1 >= 1) and IS_V(Copy(part,index,1)) then
                                                            begin
                                                                 Inc(Text.Sentence[IndexSen].part[IndexPart].Count);
                                                                 temp:=Text.Sentence[IndexSen].part[IndexPart].Count;
                                                                 Text.Sentence[IndexSen].part[IndexPart].Syllable[temp].Value:=Copy(part,index,1);
                                                                 Text.Sentence[IndexSen].part[IndexPart].Syllable[temp].Kind:=KSy_UnKnown;
                                                                 index:=index+0;
                                                            end
                                                       end;
                                                  end;
                                             end;
                                        end;

                                   end;
                              end;

                         end;
                         Inc(index);
                    end;
               end;

          end;


     end;

///==================================================================================//

     for IndexSen := 1 to Text.Count do
     begin

          for IndexPart := 1 to Text.Sentence[IndexSen].Count do
          begin

               for IndexSyllable := 1 to Text.Sentence[IndexSen].part[IndexPart].Count do
               begin

                    Syllable:=Text.Sentence[IndexSen].part[IndexPart].Syllable[IndexSyllable].Value;
                    kind:=Text.Sentence[IndexSen].part[IndexPart].Syllable[IndexSyllable].Kind;
                    case kind of
                    //     KSy_UnKnown: ;
                         KSy_CV:
                         begin
                              Text.Sentence[IndexSen].part[IndexPart].Syllable[IndexSyllable].Count:=1;
                              Text.Sentence[IndexSen].part[IndexPart].Syllable[IndexSyllable].Diphone[1]:=Syllable;
                         end;

                         KSy_CVC:
                         begin
                              Text.Sentence[IndexSen].part[IndexPart].Syllable[IndexSyllable].Count:=2;
                              Text.Sentence[IndexSen].part[IndexPart].Syllable[IndexSyllable].Diphone[1]:=copy(Syllable,1,2);
                              Text.Sentence[IndexSen].part[IndexPart].Syllable[IndexSyllable].Diphone[2]:=copy(Syllable,2,2);
                         end;

                         KSy_CVCC:
                         begin
                              Text.Sentence[IndexSen].part[IndexPart].Syllable[IndexSyllable].Count:=3;
                              Text.Sentence[IndexSen].part[IndexPart].Syllable[IndexSyllable].Diphone[1]:=copy(Syllable,1,2);
                              Text.Sentence[IndexSen].part[IndexPart].Syllable[IndexSyllable].Diphone[2]:=copy(Syllable,2,2);
                              Text.Sentence[IndexSen].part[IndexPart].Syllable[IndexSyllable].Diphone[3]:=copy(Syllable,4,1);
                         end;

                    end;


              {     Scount:=Length(part);

                    Text.Sentence[IndexSen].part[IndexPart].Count:=0;
                    if Text.Sentence[IndexSen].part[IndexPart].Kind=KP_word then
                    begin




                    end;     }
               end;
          end;
     end;





     Result:=Text;
end;
function Is_CVCCC(s:string):Boolean;
var
     scount:Integer;
begin
     scount:=Length(s);
     Result:=False;
     if scount=5 then
          if IsConsonant(s[1]) and IsVowel(s[2]) and IsConsonant(s[3]) and IsConsonant(s[4]) and IsConsonant(s[5])  then
               Result:=true;
end;
function Is_CVCCV(s:string):Boolean;
var
     scount:Integer;
begin
     scount:=Length(s);
     Result:=False;
     if scount=5 then
          if IsConsonant(s[1]) and IsVowel(s[2]) and IsConsonant(s[3]) and IsConsonant(s[4]) and IsVowel(s[5])  then
               Result:=true;
end;
function Is_CVCV(s:string):Boolean;
var
     scount:Integer;
begin
     scount:=Length(s);
     Result:=False;
     if scount=4 then
          if IsConsonant(s[1]) and IsVowel(s[2]) and IsConsonant(s[3]) and IsVowel(s[4]) then
               Result:=true;
end;
function Is_CVCC(s:string):Boolean;
var
     scount:Integer;
begin
     scount:=Length(s);
     Result:=False;
     if scount=4 then
          if IsConsonant(s[1]) and IsVowel(s[2]) and IsConsonant(s[3]) and IsConsonant(s[4]) then
               Result:=true;
end;
function Is_CVC(s:string):Boolean;
var
     scount:Integer;
begin
     scount:=Length(s);
     Result:=False;
     if scount=3 then
          if IsConsonant(s[1]) and IsVowel(s[2]) and IsConsonant(s[3]) then
               Result:=true;
end;
function Is_CV(s:string):Boolean;
var
     scount:Integer;
begin
     scount:=Length(s);
     Result:=False;
     if scount=2 then
          if IsConsonant(s[1]) and IsVowel(s[2]) then
               Result:=true;
end;
function Is_C(s:string):Boolean;
var
     scount:Integer;
begin
     scount:=Length(s);
     Result:=False;
     if scount=1 then
          if IsConsonant(s[1]) then
               Result:=true;
end;
function Is_V(s:string):Boolean;
var
     scount:Integer;
begin
     scount:=Length(s);
     Result:=False;
     if scount=1 then
          if IsVowel(s[1]) then
               Result:=true;
end;
procedure TForm1.Button1Click(Sender: TObject);
var
     S:string;
     i,SCount: Integer;
     Text:TText;
     indexsen: Integer;
  //   indexpart: Integer;
   //  IndexSyllable: Integer;
  //   stemp: string;
     Data,DataTemp:TDoubleDynArray;
     Ts,Fs:Cardinal;
     bps:Byte;
   //  path:string;
begin
     MediaPlayer1.Close;

     for i:=0 to Memo1.Lines.Count - 1 do
     begin
          SCount:=Length(Memo1.Lines[i]);
          if Memo1.Lines[i][SCount]<>'.' then
               S:=S+Memo1.Lines[i]+'.'
          else
               S:=S+Memo1.Lines[i];
     end;

     S:=PreProcess(S);
     Text:=TextToSentenceToPartToDiPhone(S);

     SetLength(Data,1);
     SetLength(DataTemp,1);
     for indexsen := 1 to Text.Count do
     begin
          SentenceToWave(Text.Sentence[indexsen],DataTemp,Ts,Fs,bps);
          AddData(Data,DataTemp,0);
     end;
     Ts:=Length(Data)-1;
     SaveWaveFile(ProgramPath+'Result.wav',Fs,Ts,bps,Data);
//     Windows.WaitForSingleObject(Handle,2000);
//     path:='C:\Program Files\Windows Media Player\wmplayer.exe Result.wav';
//     WinExec(PAnsiChar(path),SW_Show);
     MediaPlayer1.Open;

     {
     Memo2.Clear;
     Memo2.Lines.Add(s);
     Memo3.Clear;
     Memo4.Clear;
     for indexsen := 1 to Text.Count do
     begin
          Memo3.Lines.Add(Text.Sentence[indexsen].Value);
          for indexpart := 1 to Text.Sentence[indexsen].Count do
          begin
               if Text.Sentence[indexsen].part[indexpart].Kind=KP_word then
               begin
                    stemp:='';
                    for IndexSyllable:= 1 to Text.Sentence[indexsen].part[indexpart].Count do
                    begin
                         stemp:=stemp+Text.Sentence[indexsen].part[indexpart].Syllable[IndexSyllable].Value+'+';
                    end;
                    Delete(stemp,Length(stemp),1);
                    Memo4.Lines.Add('Word  : '+Text.Sentence[indexsen].part[indexpart].Value+' = '+stemp);
               end;

               if Text.Sentence[indexsen].part[indexpart].Kind=KP_symbol then
                    Memo4.Lines.Add('Symbol: '+Text.Sentence[indexsen].part[indexpart].Value);
          end;
          Memo4.Lines.Add('~~~~~~~~~~~~~~~~~~~~~~~');
     end;}
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
     Memo1.Modified:=true;
     LastFileSaved:='FileName.txt';
end;
procedure TForm1.FormShow(Sender: TObject);
begin
     Form2.LoadFiles;
end;
procedure TForm1.OpenClick(Sender: TObject);
var
     return:Integer;
begin
     return:=mrNo;
     if Memo1.Modified then
          return:=MessageDlg('Save Changes to '+ExtractFileName(LastFileSaved),mtConfirmation,[mbYes,mbNo,mbCancel],0);

     case return of
          mryes: SaveClick(Sender);
          mrNo :
               if OpenTextFileDialog1.Execute then
               begin
                    Memo1.Lines.LoadFromFile(OpenTextFileDialog1.FileName);
                    LastFileSaved:=OpenTextFileDialog1.FileName;
               end;
     end;

end;
procedure TForm1.Options1Click(Sender: TObject);
begin
     Form2.LoadFiles;
     Form2.Show;
end;
procedure TForm1.SaveClick(Sender: TObject);
begin
     if LastFileSaved='FileName.txt' then
     begin
          if SaveTextFileDialog1.Execute then
          begin
               Memo1.Lines.SaveToFile(SaveTextFileDialog1.FileName);
               LastFileSaved:=SaveTextFileDialog1.FileName;
               Memo1.Modified:=false;
          end;
     end
     else
     begin
          Memo1.Lines.SaveToFile(LastFileSaved);
          Memo1.Modified:=false;

     end;
end;
procedure TForm1.SaveAsClick(Sender: TObject);
begin
     if SaveTextFileDialog1.Execute then
     begin
          Memo1.Lines.SaveToFile(SaveTextFileDialog1.FileName);
          LastFileSaved:=SaveTextFileDialog1.FileName;
          Memo1.Modified:=false;
     end;
end;

end.


