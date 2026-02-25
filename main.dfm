object Form1: TForm1
  Left = 245
  Top = 97
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 186
  ClientWidth = 541
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    541
    186)
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 525
    Height = 105
    Anchors = [akLeft, akTop, akRight]
    Lines.Strings = (
      ' yek seri  jomleh@ye modiriyati     '
      
        ' 1  rahbari va modiriyat   tanh@   @n  chizi nist ke dar hozure ' +
        'shom@'
      
        ' ettef@gh mioftad   balke chizist ke  dar ghiy@be shom@  rokh mi' +
        'dahad     '
      '  2   sed@ghat as@se etem@d va ehter@m ast   '
      
        '  3   mosh@rekat va hamk@ri pot@nsiyel va niruye belghovveye gor' +
        'uh'
      '  r@ b@rvar mis@zad     '
      
        '  4  tahsin va tasdigh sabab mishavad afr@d bed@nand   k@ri ke a' +
        'nj@m'
      '  midahand  h@eze ahammiyat mib@shad       '
      ' 5   residan be gholleye kuh vaghti ke b@  yekdigar az @n b@l@ '
      ' miravim r@hattar  ast       '
      ' 6   agar zam@ne kut@hi r@ bar@ye tajdide ghov@   maks konid   '
      '  motmaennan    r@he tul@nitari r@  mitav@nid  bepeym@yid')
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Button1: TButton
    Left = 198
    Top = 119
    Width = 145
    Height = 25
    Caption = 'Text To Speech'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Memo4: TMemo
    Left = 8
    Top = 230
    Width = 525
    Height = 105
    Anchors = [akLeft, akTop, akRight]
    ScrollBars = ssBoth
    TabOrder = 2
    Visible = False
  end
  object MediaPlayer1: TMediaPlayer
    Left = 144
    Top = 150
    Width = 253
    Height = 30
    FileName = 'C:\Projects\TextToSpeech\Text to Diphone\Result.wav'
    TabOrder = 3
  end
  object MainMenu1: TMainMenu
    Left = 368
    Top = 112
    object File1: TMenuItem
      Caption = '&File'
      object Options1: TMenuItem
        Caption = 'O&ptions ...'
        OnClick = Options1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Open1: TMenuItem
        Caption = '&Open'
        OnClick = OpenClick
      end
      object Save1: TMenuItem
        Caption = '&Save'
        OnClick = SaveClick
      end
      object SaveAs1: TMenuItem
        Caption = 'Save &As ...'
        OnClick = SaveAsClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'E&xit'
      end
    end
    object Help1: TMenuItem
      Caption = '&Help'
      object About1: TMenuItem
        Caption = '&About'
      end
    end
  end
  object SaveTextFileDialog1: TSaveTextFileDialog
    DefaultExt = '.txt'
    FileName = 'FileName.txt'
    Filter = 'Text Files|*.txt|All Files|*.*'
    Left = 400
    Top = 112
  end
  object OpenTextFileDialog1: TOpenTextFileDialog
    Filter = 'Text Files|*.txt|All Files|*.*'
    Left = 336
    Top = 112
  end
end
