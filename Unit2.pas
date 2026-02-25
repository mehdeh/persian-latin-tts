unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,unit1,Types, TeEngine, Series, TeeProcs, Chart,Func;

const
     count_of_harmonic=10;

type
  TForm22 = class(TForm)
    Button1: TButton;
    Image1: TImage;
    Button2: TButton;
    Button3: TButton;
    ListBox1: TListBox;
    Button4: TButton;
    Chart1: TChart;
    Series1: TLineSeries;
    Series2: TLineSeries;
    Series3: TLineSeries;
    Button5: TButton;
    OpenDialog1: TOpenDialog;
    Button6: TButton;
    procedure Button6Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private

    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form22: TForm22;

  ///// Calculate X in Linear Equation : M.x=v
  ///

     procedure CalculateM(M:TDouble2DDynArray;N:Integer;T:Double;w0:Double);

implementation
uses Math;
{$R *.dfm}

procedure CalculateM(M:TDouble2DDynArray;N:Integer;T:Double;w0:Double);
var
     i,j:Integer;
begin

     M[0,0]:=T;

     for i := 1 to N do
          M[0,i]:=sin(T*w0*i)/(i*w0);

     for i := 1 to N do
          M[0,i+N]:=(-cos(T*i*w0)/(i*w0)+1/(i*w0));

     for j := 1 to N do
          M[j,0]:=sin(T*w0*j)/(j*w0);

     for j := 1 to N do
          M[j+N,0]:=(-cos(T*j*w0)/(j*w0)+1/(j*w0));

     for j := 1 to N do
     for i := 1 to N do
     begin
          if i<>j then
               M[j,i]:=(-i*sin(T*w0*i)*cos(T*w0*j)+j*cos(T*w0*i)*sin(T*w0*j))/(w0*(j-i)*(j+i))
          else
               M[j,i]:=(sin(2*T*w0*i)+2*T*w0*i)/(4*i*w0);
     end;

     for j := 1 to N do
     for i := 1 to N do
     begin
          if i<>j then
               M[j,i+N]:=(i*cos(T*w0*i)*cos(T*w0*j)+j*sin(T*w0*i)*sin(T*w0*j)-i)/(w0*(j-i)*(j+i))
          else
               M[j,i+N]:=sin(T*w0*i)*sin(T*w0*i)/(2*i*w0);
     end;

     for j := 1 to N do
     for i := 1 to N do
     begin
          if i<>j then
               M[j+N,i]:=(-i*sin(T*w0*i)*sin(T*w0*j)-j*cos(T*w0*i)*cos(T*w0*j)+j)/(w0*(j-i)*(j+i))
          else
               M[j+N,i]:=sin(T*w0*i)*sin(T*w0*i)/(2*i*w0);
     end;

     for j := 1 to N do
     for i := 1 to N do
     begin
          if i<>j then
               M[j+N,i+N]:=(i*cos(T*w0*i)*sin(T*w0*j)-j*sin(T*w0*i)*cos(T*w0*j))/(w0*(j-i)*(j+i))
          else
               M[j+N,i+N]:=(-sin(2*T*w0*i)+2*T*w0*i)/(4*i*w0);
     end;

end;

procedure TForm22.Button1Click(Sender: TObject);
var
     i,j,frame,N:Integer;
     LFrame,HFrame,w0,T:Double;
     M,M1:TDouble2DDynArray;
     v,v1,v2:TDoubleDynArray;
begin
     N:=10;//count_of_Harmonic;
     T:=Frame_Length;

     SetLength(M,2*N+1,2*N+1);
     SetLength(M1,2*N+1,2*N+1);
     SetLength(v,2*N+1);
     SetLength(v1,2*N+1);
     SetLength(v2,2*N+1);

     SetLength(A,Frame_Count,N);
     SetLength(B,Frame_Count,N);
     SetLength(A0,Frame_Count);

     for frame := 0 to Frame_Count-1 do
     begin
          LFrame:=frame*(T_Length-Frame_Length)/(Frame_Count-1);
          HFrame:=LFrame+Frame_Length;

          w0:=2*pi*f0_new[frame];
          if w0<>0 then
          begin
               CalculateM(M,N,T,w0);
               v[0]:=Integral_St(LFrame,HFrame);
               for j := 1 to N do
                    v[j]:=Integral_StCos(j,w0,LFrame,HFrame);
               for j := 1 to N do
                    v[j+N]:=Integral_StSin(j,w0,LFrame,HFrame);

               LSolve(M,v);

               A0[frame]:=v[0];

               for i := 1 to N do
                    A[frame,i-1]:=v[i];

               for i := 1 to N do
                    B[frame,i-1]:=v[i+N];
          end
          else
          begin
               A0[frame]:=0;
               for i := 1 to N do
                    A[frame,i-1]:=0;

               for i := 1 to N do
                    B[frame,i-1]:=0;
          end;

     end;

end;

procedure TForm22.Button2Click(Sender: TObject);
var
  frame: Integer;
  i,y: Integer;
  r:Byte;
  maxf0,minf0,maxf,temp:Double;
begin
     Image1.Picture.LoadFromFile('C:\Documents and Settings\Sheida\My Documents\Borland Studio Projects\OpenWaveFile\white.bmp');
     maxf0:=0;
     maxf:=0;
     minf0:=MaxInt;
     for frame := 0 to Frame_Count-1 do
     begin
          for i := 0 to count_of_Harmonic do
          begin
               if i=0 then
               begin
                    temp:=a0[frame];
                    if maxf0 < temp then
                         maxf0:=temp;
                    if minf0 > temp then
                         minf0:=temp;
               end
               else
               begin
                    temp:=sqrt(A[frame,i]*A[frame,i]+B[frame,i]*B[frame,i]);
                    if maxf < temp then
                         maxf:=temp;
               end;
          end;
     end;

     Caption:=FloatToStr(maxf0)+' , '+FloatToStr(maxf);

     for frame := 0 to Frame_Count-1 do
     begin
          for i := 0 to count_of_Harmonic do
          begin
               if i=0 then
                    r:=round((a0[frame]-minf0)*254/(maxf0-minf0))
               else
                    r:=Round(sqrt(A[frame,i]*A[frame,i]+B[frame,i]*B[frame,i])*(255-30)/maxf+30);      //

               r:=255-r;
               y:=(i*f0_new[frame]) div 30;
               Image1.Canvas.Pixels[frame+1,y]:=rgb(r,r,r);
               Image1.Canvas.Pixels[frame+1,y+1]:=rgb(r,r,r);
               Image1.Canvas.Pixels[frame+1,y+2]:=rgb(r,r,r);
               Image1.Canvas.Pixels[frame+1,y+3]:=rgb(r,r,r);
               Image1.Canvas.Pixels[frame+1,y+4]:=rgb(r,r,r);
          end;

     end;

end;

procedure TForm22.Button3Click(Sender: TObject);
var
  frame: Integer;
  LFrame,w0:Double;
  Lt,Ht:Integer;
  i,t,Nt,L,countf,f:Integer;
  Stemp:TDoubleDynArray;
begin
     Nt:=Round(Fs*Frame_Length);
     SetLength(Stemp,Nt);
     SetLength(Sn_New,Round(T_Length*Fs)+10);
     countf:=Round(T_Length/Frame_Length);
     for f := 0 to Countf-1 do
     begin
          frame:=round(f/countf*(Frame_Count-1));
          LFrame:=frame*(T_Length-Frame_Length)/(Frame_Count-1);
        //  HFrame:=LFrame+Frame_Length;
          w0:=2*pi*f0_new[frame];
         // Lt:=Round(LFrame*Fs);
          Lt:=f*Nt;
          Ht:=Nt+Lt-1;

          for t := 0 to Nt-1 do
          begin
               Stemp[t]:=a0[frame];
               for i:= 1 to count_of_Harmonic do
                    Stemp[t]:=Stemp[t]+A[frame,i]*cos(i*w0*t/Fs)+B[frame,i]*sin(i*w0*t/Fs);
          end;

          for t := Lt to Ht do
          begin
          {     L:=Round(Fs*(T_Length-Frame_Length)/(Frame_Count-1));
               if t<(Lt+L) then
                    Sn_New[t]:=(Sn_New[t]*frame+Stemp[t-Lt])/(Frame+1)
               else}
                    Sn_New[t]:=Stemp[t-Lt];
          end;
     end;
     Series1.Clear;
     Series2.Clear;
     Series3.Clear;
     for t := 0 to Round(T_Length*Fs-1) do
     begin
          Series1.Add(Sn_new[t]);
          Series2.Add(Sn[t]);
        //  Series3.Add(abs(Sn_new[t]-Sn[t]))
     end;
end;


procedure TForm22.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  i: Integer;
begin
     ListBox1.Clear;
     for i := 0 to count_of_Harmonic do
     begin
          if x<Frame_Count then
          begin
               if i=0 then
                    ListBox1.Items.Add(inttostr(i)+' : '+inttostr(round(a0[x-1])))
               else
                    ListBox1.Items.Add(inttostr(i)+' : '+inttostr(round(sqrt(A[x-1,i]*A[x-1,i]+B[x-1,i]*B[x-1,i]))));
          end;
     end;

end;

procedure TForm22.Button5Click(Sender: TObject);
var
     FileSave:TFileStream;

     i:Integer;
     N:integer;
begin
     if OpenDialog1.Execute then
     begin
          FileSave:=TFileStream.Create(OpenDialog1.FileName,fmCreate);
          FileSave.WriteBuffer(headerfile,44);
          N:=Round(T_Length*Fs)-10;
          for i := 1 to N do
               Stemp[i]:=Round(Sn_New[i]);
          FileSave.Position:=44;
          FileSave.WriteBuffer(Stemp,2*N);
     end;
end;


procedure TForm22.Button6Click(Sender: TObject);
begin
   //  form3.show;
end;

end.
