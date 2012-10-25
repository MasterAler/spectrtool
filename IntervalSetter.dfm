object FrmIntervals: TFrmIntervals
  Left = 854
  Top = 133
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1044#1080#1072#1087#1072#1079#1086#1085#1099' '#1089#1090#1072#1085#1076#1072#1088#1090#1085#1086#1075#1086' '#1052#1053#1050
  ClientHeight = 144
  ClientWidth = 248
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object bbOK: TBitBtn
    Left = 25
    Top = 102
    Width = 75
    Height = 27
    TabOrder = 0
    OnClick = bbOKClick
    Kind = bkOK
  end
  object GroupBox1: TGroupBox
    Left = 10
    Top = 8
    Width = 105
    Height = 88
    Caption = #1061#1086#1083#1086#1076#1085#1072#1103' '#1075#1088#1091#1087#1087#1072
    TabOrder = 1
    object Label1: TLabel
      Left = 13
      Top = 25
      Width = 13
      Height = 16
      Caption = #1086#1090
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 13
      Top = 53
      Width = 14
      Height = 16
      Caption = #1076#1086
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object se1From: TSpinEdit
      Left = 40
      Top = 24
      Width = 50
      Height = 22
      MaxValue = 50
      MinValue = 1
      TabOrder = 0
      Value = 1
    end
    object se1To: TSpinEdit
      Left = 40
      Top = 52
      Width = 50
      Height = 22
      MaxValue = 50
      MinValue = 1
      TabOrder = 1
      Value = 1
    end
  end
  object GroupBox2: TGroupBox
    Left = 127
    Top = 8
    Width = 106
    Height = 88
    Caption = #1043#1086#1088#1103#1095#1072#1103' '#1075#1088#1091#1087#1087#1072
    TabOrder = 2
    object Label3: TLabel
      Left = 13
      Top = 25
      Width = 13
      Height = 16
      Caption = #1086#1090
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 13
      Top = 53
      Width = 14
      Height = 16
      Caption = #1076#1086
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object se2From: TSpinEdit
      Left = 40
      Top = 24
      Width = 50
      Height = 22
      MaxValue = 50
      MinValue = 1
      TabOrder = 0
      Value = 1
    end
    object se2To: TSpinEdit
      Left = 40
      Top = 52
      Width = 50
      Height = 22
      MaxValue = 50
      MinValue = 1
      TabOrder = 1
      Value = 1
    end
  end
  object bbCancel: TBitBtn
    Left = 140
    Top = 102
    Width = 77
    Height = 27
    TabOrder = 3
    Kind = bkCancel
  end
end
