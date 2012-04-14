object FrmChooser: TFrmChooser
  Left = 192
  Top = 124
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1074#1080#1076' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1080
  ClientHeight = 200
  ClientWidth = 283
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object bbOK: TBitBtn
    Left = 80
    Top = 160
    Width = 57
    Height = 25
    TabOrder = 0
    OnClick = bbOKClick
    Kind = bkOK
  end
  object bbCancel: TBitBtn
    Left = 152
    Top = 160
    Width = 73
    Height = 25
    TabOrder = 1
    Kind = bkCancel
  end
  object GroupBox1: TGroupBox
    Left = 48
    Top = 16
    Width = 217
    Height = 73
    Caption = #1052#1077#1078#1076#1091' '#1089#1090#1086#1083#1073#1094#1072#1084#1080
    TabOrder = 2
    object Label1: TLabel
      Left = 24
      Top = 17
      Width = 21
      Height = 16
      Caption = #8470'1'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 92
      Top = 17
      Width = 21
      Height = 16
      Caption = #8470'2'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label3: TLabel
      Left = 65
      Top = 38
      Width = 4
      Height = 16
      Caption = '/'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 130
      Top = 39
      Width = 4
      Height = 13
      Caption = '*'
    end
    object Label5: TLabel
      Left = 148
      Top = 17
      Width = 8
      Height = 16
      Caption = 'K'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object cbOne: TComboBox
      Left = 16
      Top = 36
      Width = 41
      Height = 21
      ItemHeight = 13
      TabOrder = 0
    end
    object cbTwo: TComboBox
      Left = 80
      Top = 36
      Width = 41
      Height = 21
      ItemHeight = 13
      TabOrder = 1
    end
    object fseCoeff: TFloatSpinEdit
      Left = 144
      Top = 35
      Width = 49
      Height = 22
      Increment = 0.500000000000000000
      TabOrder = 2
      Value = 1.000000000000000000
    end
  end
  object rbST: TRadioButton
    Left = 16
    Top = 56
    Width = 17
    Height = 17
    Checked = True
    TabOrder = 3
    TabStop = True
    OnClick = rbFClick
  end
  object rbF: TRadioButton
    Left = 16
    Top = 112
    Width = 17
    Height = 17
    TabOrder = 4
    OnClick = rbFClick
  end
  object cbFunction: TComboBox
    Left = 48
    Top = 112
    Width = 97
    Height = 21
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 5
    Text = 'Average'
    Items.Strings = (
      'Average')
  end
end
