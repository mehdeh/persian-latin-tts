unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TeEngine, Series, ExtCtrls, TeeProcs, Chart,Types, ComCtrls,
  Spin,Func;


type
  TForm11 = class(TForm)
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    Chart1: TChart;
    Series1: TLineSeries;
    Button3: TButton;
    Memo1: TMemo;
    GroupBox1: TGroupBox;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Panel1: TPanel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Button4: TButton;
    Edit1: TEdit;
    GroupBox2: TGroupBox;
    Button5: TButton;
    Image4: TImage;
    Edit2: TEdit;
    Button2: TButton;
    Chart2: TChart;
    Series2: TPointSeries;
    Series3: TPointSeries;
    Series4: TPointSeries;
    Button9: TButton;
    Chart3: TChart;
    Series5: TLineSeries;
    Chart4: TChart;
    Series6: TLineSeries;
    Button10: TButton;
    Label2: TLabel;
    SpinEdit1: TSpinEdit;
    Label1: TLabel;
    SpinEdit2: TSpinEdit;
    Label3: TLabel;
    Button11: TButton;
    Button12: TButton;
    Chart5: TChart;
    Series7: TLineSeries;
    Memo2: TMemo;
    Memo3: TMemo;

    procedure Button12Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure SpinEdit2Change(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure Chart1Zoom(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Image4MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Button5Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private




  //  function S(t:Double):Double;
    function Error_Time_Pitch1(t:Double;F0:Double):Double;
    function Error_Time_Pitch2(t:Double;F0:Double):Double;
    function Error_Time_Pitch3(t:Double;F0:Double):Double;

    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form11: TForm11;
     Stemp:array[1..5000000]of Smallint;
     headerfile:array[0..43]of Byte;
     FileStreem:TFileStream;
     Sn:array of Double;
     Sn_New:TDoubleDynArray;
     Ts:DWord;
     Fs:Word;
     T_Length:Double;
     Frame_Length:Double;
     Frame_Count:Integer;
     F0_List:array of Word;
     F0_New:array of Word;
     
     A,B:TDouble2DDynArray;//   frame,i
     A0:TDoubleDynArray; // frame

     DeltaT:Double;



  function Integral_St(Lt,Ht:Double):Double;
  function Integral_Stcos(k:Integer;w0,Lt,Ht:Double):Double;
  function Integral_Stsin(k:Integer;w0,Lt,Ht:Double):Double;
///////////////////////////////////////////////////////////////////////


implementation

uses math,unit2;

{$R *.dfm}


function Integral_St(Lt,Ht:Double):Double;
var
     sum:Double;
     Ln,Hn,i:Integer;
begin
     Ln:=Round(Lt*Fs);
     Hn:=Round(Ht*Fs);
     sum:=0;
     for i:=Ln+1 to Hn-1 do
     begin
          sum:=sum+Sn[i];
     end;

     sum:=sum+(Sn[Ln]+Sn[Hn])/2;
     sum:=sum*DeltaT;

     Result:=sum;
end;


function Integral_Stcos(k:Integer;w0,Lt,Ht:Double):Double;
var
     sum:Double;
     Ln,Hn,i:Integer;
begin
     Ln:=Round(Lt*Fs);
     Hn:=Round(Ht*Fs);
     sum:=0;
     for i:=Ln+1 to Hn-1 do
     begin
          sum:=sum+Sn[i]*Cos(k*w0*(i-Ln)/Fs);
     end;

     sum:=sum+(Sn[Ln]*Cos(k*w0*(0)/Fs)+Sn[Hn]*Cos(k*w0*(Hn-Ln)/Fs))/2;
     sum:=sum*DeltaT;

     Result:=sum;
end;


function Integral_Stsin(k:Integer;w0,Lt,Ht:Double):Double;
var
     sum:Double;
     Ln,Hn,i:Integer;
begin
     Ln:=Round(Lt*Fs);
     Hn:=Round(Ht*Fs);
     sum:=0;
     for i:=Ln+1 to Hn-1 do
     begin
          sum:=sum+Sn[i]*sin(k*w0*(i-Ln)/Fs);
     end;

     sum:=sum+(Sn[Ln]*sin(k*w0*(Ln-Ln)/Fs)+Sn[Hn]*sin(k*w0*(Hn-Ln)/Fs))/2;
     sum:=sum*DeltaT;

     Result:=sum;
end;





function TForm11.Error_Time_Pitch1(t: Double; F0: Double):Double;
var
     sum,T_F0:Double;
     i,L,H:Integer;
begin
     if F0<>0 then
          T_F0:=1/F0
     else
          T_F0:=0.010;

     L:=Round((t+T_F0)*Fs);
     H:=Round((t+Frame_Length)*Fs);
     sum:=0;
     for i :=L to H do
     begin
          sum:=sum+(Sn[i]-Sn[round(i-T_F0*Fs)])*(Sn[i]-Sn[round(i-T_F0*Fs)]);
     end;
     Result:=(sum)/((Frame_Length-T_F0)*Fs);

end;

function TForm11.Error_Time_Pitch2(t: Double; F0: Double):Double;
var
     sum,T_F0:Double;
     i,L,H:Integer;
begin
     if F0<>0 then
          T_F0:=1/F0
     else
          T_F0:=0.010;

     L:=Round((t+T_F0)*Fs);
     H:=Round((t+Frame_Length)*Fs);
     sum:=0;
     for i :=L to H do
     begin
          sum:=sum+(Sn[i]*Sn[round(i-T_F0*Fs)])/10000000;
     end;
     Result:=(sum)/((Frame_Length-T_F0)*Fs);

end;

function TForm11.Error_Time_Pitch3(t: Double; F0: Double):Double;
begin
    Result:=Error_Time_Pitch2(t,F0)/(Error_Time_Pitch1(t,F0)+1);

end;


procedure TForm11.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
      Edit1.Text:=inttostr(y+150);
      //Edit2.Text:=IntToStr(x);
end;

procedure TForm11.Image4MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
      Edit2.Text:=inttostr(y+150);
end;

procedure TForm11.Button10Click(Sender: TObject);
begin
     Form22.Show;
end;

procedure TForm11.Button11Click(Sender: TObject);
begin
  //   Form4.Show;
end;

     function Sin_(t:Double):Double;
     begin
          Result:=intPower(t,30)*sin(t/4.65)*cos(t*3.123);
     end;

procedure TForm11.Button12Click(Sender: TObject);
var
     S1:TDoubleDynArray;
     i:Integer;
     temp,sum:Double;
begin
     SetLength(S1,Ts+1);
     S1[0]:=0;
     sum:=0;
     Memo1.Clear;
     for i := 0 to Ts-1 do
     begin
          S1[i+1]:=Sn[i];
          sum:=sum+abs(sn[i]);
       //   Memo1.Lines.Add(IntToStr(Sn[i]));
     end;
     sum:=(sum);
                           //     *s1[i+1]       sqrt               (Ts-1)
 //    realft(S1,Ts,1);


     Memo2.Clear;
     Memo3.Clear;
     Series7.Clear;
     for i := 1 to Ts div 2 do
     begin
          temp:=sqrt((S1[2*i-1]*S1[2*i-1]+S1[2*i]*S1[2*i]));
          Series7.Add(4*temp/sum);
       //   Memo2.Lines.Add(floatToStr(S1[2*i-1]));
       //   Memo3.Lines.Add(floatToStr(S1[2*i]));
     end;


end;

procedure TForm11.Button1Click(Sender: TObject);
var
     i:Integer;
     min,max:Integer;
begin
     if OpenDialog1.Execute then
     begin
          FileStreem:=TFileStream.Create(OpenDialog1.FileName,fmOpenRead);
          FileStreem.ReadBuffer(headerfile,44);
       //   SetLength(buf,FileStreem.size);
          FileStreem.Position:=24;
          FileStreem.ReadBuffer(Fs,sizeof(Fs));
          FileStreem.Position:=40;
          FileStreem.ReadBuffer(Ts,sizeof(Ts));
          Ts:=Ts div 2;
          FileStreem.Position:=44;
          FileStreem.ReadBuffer(Stemp,2*Ts);
       //  FileStreem.ReadBuffer(buf,100);
        //  FileStreem.Free;
          T_Length:=Ts/Fs;
          DeltaT:=T_Length/(Ts-1);
          Frame_Length:=SpinEdit2.Value/1000;

          if Ts > 0 then
          begin
               Series1.Clear;
               SetLength(Sn,Ts);
               for i := 1 to Ts do
               begin
                    Sn[i-1]:=Stemp[i]/MAXSHORT;
                    Series1.Add(Sn[i-1]);
               end;

          end;
     end;
end;

{function TForm1.s(t: Double):Double;
var
     TsL:DWORD;
     TsH:DWORD;
begin
     Result:=0;
     if (t<T_Length) and (t>0) then
     begin
          TsH:=Floor(t*Fs);
          TsL:=Ceil(t*Fs);
          if TsH<>TsL then
               Result:=(Sn[TsH]-Sn[TsL])*(t-TsL)/(TsH-TsL)+Sn[TsL]
          else
          begin
               Result:=Sn[TsL];
          end;
     end;
end;
 }

procedure TForm11.SpinEdit1Change(Sender: TObject);
begin
     Frame_Count:=SpinEdit1.Value;
     
end;

procedure TForm11.SpinEdit2Change(Sender: TObject);
begin
     Frame_Length:=SpinEdit2.Value/1000;
end;

procedure TForm11.Button2Click(Sender: TObject);
var
  F0,frame: Integer;
  temp,LFrame:Double;
  min:Double;
  max1:Double;
  max2:Double;
  index_F01:Integer;
  index_F02:Integer;
  index_F03:Integer;
begin
     Series2.Clear;
     Series3.Clear;
     Series4.Clear;

     for frame :=0 to Frame_Count-1 do
     begin
          Lframe:=frame*(T_Length-Frame_Length)/(Frame_Count-1);
          min:=MAXDWORD;
          max1:=0;
          max2:=0;
          index_F01:=0;
          index_F02:=0;
          index_F03:=0;

          for F0 := 150 to 450 do
          begin
               temp:=Error_Time_Pitch1(LFrame,F0);
               if temp<min then
               begin
                    min:=temp;
                    index_F01:=F0;
               end;

               temp:=Error_Time_Pitch2(LFrame,F0);
               if temp>max1 then
               begin
                    max1:=temp;
                    index_F02:=F0;
               end;

               temp:=Error_Time_Pitch3(LFrame,F0);
               if temp>max2 then
               begin
                    max2:=temp;
                    index_F03:=F0;
               end;

          end;
               Series2.Add(index_F01);
               Series3.Add(index_F02);
               Series4.Add(index_F03);

     end;
end;




procedure TForm11.Button3Click(Sender: TObject);
var
  i: Integer;
begin

     if Ts > 0 then
     begin
          for i := 1 to 100 do
          begin
               memo1.Lines.Add(floattostr(i)+' : '+floattostr(Sn[i]));
          end;

     end;

end;

procedure TForm11.Button4Click(Sender: TObject);
var
  F0,x,frame: Integer;
  r,g,b:byte;
  temp,LFrame:Double;

  min:Double;
//  max1:Double;
//  max2:Double;
  index_F01:Integer;
//  index_F02:Integer;
//  index_F03:Integer;
begin
     SetLength(F0_List,Frame_Count);
     for frame :=0 to Frame_Count-1 do
     begin
          Lframe:=frame*(T_Length-Frame_Length)/(Frame_Count-1);
          min:=MAXDWORD;
      //    max1:=0;
         // max2:=0;
          index_F01:=0;
//          index_F02:=0;
//          index_F03:=0;

          for F0 := 150 to 400 do
          begin
               temp:=Error_Time_Pitch1(LFrame,F0);
               if temp<min then
               begin
                    min:=temp;
                    index_F01:=F0;
               end;

//               temp:=Error_Time_Pitch2(LFrame,F0);
//               if temp>max1 then
//               begin
//                    max1:=temp;
//                    index_F02:=F0;
//               end;
//
//               temp:=Error_Time_Pitch3(LFrame,F0);
//               if temp>max2 then
//               begin
//                    max2:=temp;
//                    index_F03:=F0;
//               end;


          end;
               x:=frame+1;
               g:=255;
               r:=0;
               b:=0;
               Image1.Canvas.Pixels[x,index_F01-149]:=RGB(r,g,b);
               F0_List[frame]:=index_F01;

//               g:=0;
//               r:=255;
//               b:=0;
//               Image2.Canvas.Pixels[x,index_F02-149]:=RGB(r,g,b);
//
//               g:=0;
//               r:=0;
//               b:=255;
//               Image3.Canvas.Pixels[x,index_F03-149]:=RGB(r,g,b);
     end;
  
end;

procedure TForm11.Button5Click(Sender: TObject);
var
  frame,F0,x,y: Integer;
  r,g,b:byte;
  temp,Lframe:Double;

begin
     for frame :=0 to Frame_Count-1 do
     begin
          y:=1;
          for F0 := 150 to 450 do
          begin
               Lframe:=frame*(T_Length-Frame_Length)/(Frame_Count-1);
               temp:=Error_Time_Pitch1(Lframe,F0);
               g:=round(ln((temp))*12);
               r:=g;
               b:=g;
               x:=frame+1;
               Image4.Canvas.Pixels[x,y]:=RGB(r,g,b);
               Inc(y);
          end;
     end;
end;

procedure TForm11.Button6Click(Sender: TObject);
begin
     Image1.Visible:=not Image1.Visible;
end;

procedure TForm11.Button7Click(Sender: TObject);
begin
     Image2.Visible:=not Image2.Visible;
end;

procedure TForm11.Button8Click(Sender: TObject);
begin
     Image3.Visible:=not Image3.Visible;
end;

procedure TForm11.Button9Click(Sender: TObject);
var
     N:Byte;
     i,j:Integer;
     IY,Y,a,b,E:Double;
begin
     N:=25;
     Series5.Clear;
     Series6.Clear;
     SetLength(F0_New,Frame_Count);

     for i := 0 to Frame_Count-N-2 do
     begin
          IY:=0;
          Y:=0;
          for j :=i to i+N-1 do
          begin
               IY:=IY+(j-i+1)*F0_List[j];
               Y:=Y+F0_list[j];
          end;

          a:=6*(-N*Y-Y+2*IY)/(N*(N*N-1));
          b:=-2*(-2*N*Y+3*IY-Y)/(N*N-N);

          E:=0;
          for j := i to i+N-1 do
               E:=E+(f0_List[j]-(a*(j-i+1)+b))*(f0_List[j]-(a*(j-i+1)+b));
          E:=E/N;

          if E < 10  then
               F0_New[i]:= F0_List[i]//   Round(Y/N ) //
          else
               F0_New[i]:= 0;//F0_List[i];//

          Series5.Add(E);
          Series6.Add(F0_New[i]);
     end;
end;

procedure TForm11.Chart1Zoom(Sender: TObject);
var
     TH,TL,i:Integer;
begin
     tL:=round(Chart1.BottomAxis.Minimum);
     tH:=Round(Chart1.BottomAxis.Maximum);
     Ts:=TH-TL+1;
     Ts:=Round(power(2,floor(log2(Ts))+1));
     T_Length:=Ts/Fs;
     DeltaT:=T_Length/(Ts-1);
     SetLength(Sn,Ts);

     for i :=0 to Ts-1 do
     if i<(TH-TL+1) then 
          Sn[i]:=Series1.YValue[i+TL]
     else
          Sn[i]:=0;

     Frame_Count:=Image1.Width;
     SpinEdit1.Value:=Image1.Width;

end;

end.
