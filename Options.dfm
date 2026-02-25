object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Options'
  ClientHeight = 460
  ClientWidth = 822
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 238
    Width = 609
    Height = 217
    Caption = 'Voiecd/UnVoiced'
    TabOrder = 0
    object Label1: TLabel
      Left = 450
      Top = 23
      Width = 33
      Height = 13
      Caption = 'Vowels'
    end
    object Label2: TLabel
      Left = 540
      Top = 23
      Width = 57
      Height = 13
      Caption = 'Consonants'
    end
    object Label8: TLabel
      Left = 32
      Top = 23
      Width = 33
      Height = 13
      Caption = 'Alpha2'
    end
    object Label9: TLabel
      Left = 93
      Top = 23
      Width = 33
      Height = 13
      Caption = 'Alpha1'
    end
    object Label11: TLabel
      Left = 177
      Top = 23
      Width = 34
      Height = 13
      Caption = 'Symbol'
    end
    object Label12: TLabel
      Left = 243
      Top = 23
      Width = 51
      Height = 13
      Caption = 'Symbol Str'
    end
    object MemoVowels: TMemo
      Left = 440
      Top = 42
      Width = 53
      Height = 159
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object MemoConsonants: TMemo
      Left = 538
      Top = 42
      Width = 53
      Height = 159
      ScrollBars = ssVertical
      TabOrder = 1
    end
    object MemoAlpha2: TMemo
      Left = 22
      Top = 42
      Width = 53
      Height = 159
      ScrollBars = ssVertical
      TabOrder = 2
    end
    object MemoAlpha1: TMemo
      Left = 80
      Top = 42
      Width = 53
      Height = 159
      ScrollBars = ssVertical
      TabOrder = 3
    end
    object MemoSymbol: TMemo
      Left = 167
      Top = 42
      Width = 53
      Height = 159
      ScrollBars = ssVertical
      TabOrder = 4
    end
    object MemoSymbol_Str: TMemo
      Left = 225
      Top = 42
      Width = 168
      Height = 159
      ScrollBars = ssVertical
      TabOrder = 5
    end
  end
  object Button1: TButton
    Left = 688
    Top = 387
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 1
    OnClick = Button1Click
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 15
    Width = 806
    Height = 217
    Caption = 'Characters'
    TabOrder = 2
    object Label3: TLabel
      Left = 16
      Top = 23
      Width = 59
      Height = 13
      Caption = 'Alpha Lower'
    end
    object Label4: TLabel
      Left = 93
      Top = 23
      Width = 59
      Height = 13
      Caption = 'Alpha Upper'
    end
    object Label5: TLabel
      Left = 440
      Top = 21
      Width = 42
      Height = 13
      Caption = 'Numbers'
    end
    object Label6: TLabel
      Left = 611
      Top = 21
      Width = 70
      Height = 13
      Caption = 'Silence Symbol'
    end
    object Label7: TLabel
      Left = 708
      Top = 21
      Width = 90
      Height = 13
      Caption = 'Sentence EndPoint'
    end
    object Label10: TLabel
      Left = 504
      Top = 21
      Width = 62
      Height = 13
      Caption = 'Numbers_Str'
    end
    object Label13: TLabel
      Left = 176
      Top = 21
      Width = 44
      Height = 13
      Caption = 'Alpha Str'
    end
    object MemoAlpha_Lower: TMemo
      Left = 20
      Top = 42
      Width = 53
      Height = 159
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object MemoAlpha_Upper: TMemo
      Left = 93
      Top = 42
      Width = 53
      Height = 159
      ScrollBars = ssVertical
      TabOrder = 1
    end
    object MemoNumbers: TMemo
      Left = 436
      Top = 40
      Width = 53
      Height = 159
      ScrollBars = ssVertical
      TabOrder = 2
    end
    object MemoSilence_Symbol: TMemo
      Left = 611
      Top = 40
      Width = 53
      Height = 159
      ScrollBars = ssVertical
      TabOrder = 3
    end
    object MemoSentence_EndPoint: TMemo
      Left = 720
      Top = 40
      Width = 53
      Height = 159
      ScrollBars = ssVertical
      TabOrder = 4
    end
    object MemoNumbers_Str: TMemo
      Left = 500
      Top = 40
      Width = 93
      Height = 159
      ScrollBars = ssVertical
      TabOrder = 5
    end
    object MemoAlpha_Str: TMemo
      Left = 167
      Top = 40
      Width = 90
      Height = 159
      ScrollBars = ssVertical
      TabOrder = 6
    end
  end
  object Button2: TButton
    Left = 688
    Top = 418
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 688
    Top = 356
    Width = 75
    Height = 25
    Caption = 'Load'
    TabOrder = 4
    OnClick = Button3Click
  end
end
