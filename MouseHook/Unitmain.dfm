object Form1: TForm1
  Left = 192
  Top = 107
  Width = 400
  Height = 192
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 104
    Top = 88
    Width = 52
    Height = 13
    Caption = #30446#26631#31383#21475
  end
  object capture: TButton
    Left = 8
    Top = 56
    Width = 75
    Height = 25
    Caption = #24320#22987
    TabOrder = 0
    OnClick = captureClick
  end
  object Panel1: TPanel
    Left = 184
    Top = 56
    Width = 185
    Height = 25
    Caption = 'x=0 y=0'
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 8
    Top = 32
    Width = 361
    Height = 24
    TabOrder = 2
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 8
    Top = 0
    Width = 361
    Height = 24
    TabOrder = 3
    Text = 'Edit2'
  end
  object Edit3: TEdit
    Left = 88
    Top = 56
    Width = 89
    Height = 24
    TabOrder = 4
    Text = 'Edit3'
  end
  object Edit4: TEdit
    Left = 160
    Top = 82
    Width = 65
    Height = 24
    TabOrder = 5
  end
  object Edit5: TEdit
    Left = 8
    Top = 106
    Width = 369
    Height = 24
    TabOrder = 6
  end
  object Edit6: TEdit
    Left = 8
    Top = 130
    Width = 369
    Height = 24
    TabOrder = 7
  end
  object Button1: TButton
    Left = 8
    Top = 80
    Width = 75
    Height = 25
    Caption = #21491#38190#21462#31383#21475
    TabOrder = 8
    OnClick = Button1Click
  end
end
