object FrmVAH: TFrmVAH
  Left = 0
  Top = 0
  Caption = #1054#1073#1088#1073#1086#1090#1082#1072' '#1080' '#1089#1075#1083#1072#1078#1080#1074#1072#1085#1080#1077' '#1082#1088#1080#1074#1099#1093' '#1042#1040#1061
  ClientHeight = 321
  ClientWidth = 563
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MenuVAH
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ChartVAH: TChart
    Left = 0
    Top = 0
    Width = 563
    Height = 321
    Legend.CheckBoxes = True
    Title.Text.Strings = (
      'TChart')
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 301
    PrintMargins = (
      15
      21
      15
      21)
  end
  object MenuVAH: TMainMenu
    Left = 8
    Top = 16
    object N1: TMenuItem
      Caption = #1060#1072#1081#1083
      object N4: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100
        OnClick = N4Click
      end
      object N7: TMenuItem
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100
        OnClick = N7Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object N2: TMenuItem
        Caption = #1042#1099#1093#1086#1076
        OnClick = N2Click
      end
    end
    object N5: TMenuItem
      Caption = #1054#1087#1094#1080#1080
      object N6: TMenuItem
        Caption = #1054#1073#1088#1072#1073#1086#1090#1072#1090#1100
        OnClick = N6Click
      end
      object N8: TMenuItem
        Caption = #1054#1095#1080#1089#1090#1080#1090#1100
        OnClick = N8Click
      end
      object N9: TMenuItem
        Caption = #1055#1086#1076#1075#1086#1090#1086#1074#1080#1090#1100' '#1092#1072#1081#1083
        OnClick = N9Click
      end
    end
  end
  object OpenDialogCSV: TOpenDialog
    Filter = 'CSV files|*.csv'
    Left = 48
    Top = 16
  end
  object SaveDialogCSV: TSaveDialog
    Filter = 'CSV files|*.csv'
    Left = 88
    Top = 16
  end
end
