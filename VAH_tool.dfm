object FrmVAH: TFrmVAH
  Left = 114
  Top = 118
  Caption = #1054#1073#1088#1072#1073#1086#1090#1082#1072' '#1089#1086' '#1089#1075#1083#1072#1078#1080#1074#1072#1085#1080#1077#1084' '#1082#1088#1080#1074#1099#1093' '#1042#1040#1061
  ClientHeight = 811
  ClientWidth = 736
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MenuVAH
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 17
  object ChartVAH: TChart
    Left = 0
    Top = 0
    Width = 736
    Height = 811
    Legend.Alignment = laTop
    Legend.CheckBoxes = True
    Title.Text.Strings = (
      'TChart')
    OnClickSeries = ChartVAHClickSeries
    BottomAxis.Title.Caption = 'CH1'
    LeftAxis.Title.Caption = 'CH2'
    OnAfterDraw = ChartVAHAfterDraw
    Align = alClient
    TabOrder = 0
    OnMouseDown = ChartVAHMouseDown
    OnMouseLeave = ChartVAHMouseLeave
    OnMouseMove = ChartVAHMouseMove
    OnMouseUp = ChartVAHMouseUp
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
        Caption = #1054#1073#1088#1072#1073#1086#1090#1072#1090#1100' '#1080' '#1086#1090#1082#1088#1099#1090#1100
        OnClick = N4Click
      end
      object N7: TMenuItem
        Caption = #1054#1073#1088#1072#1073#1086#1090#1072#1090#1100' '#1080' '#1076#1086#1073#1072#1074#1080#1090#1100
        OnClick = N7Click
      end
      object N9: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100' '#1086#1073#1088#1072#1073#1086#1090#1072#1085#1085#1086#1077
        OnClick = N9Click
      end
      object N10: TMenuItem
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1086#1073#1088#1072#1073#1086#1090#1072#1085#1085#1086#1077
        OnClick = N10Click
      end
      object dat1: TMenuItem
        Caption = #1054#1073#1088#1072#1073#1086#1090#1072#1090#1100' '#1085#1086#1074#1099#1081' '#1092#1086#1088#1084#1072#1090' (*.dat) '#1080' '#1076#1086#1073#1072#1074#1080#1090#1100
        OnClick = dat1Click
      end
      object N13: TMenuItem
        Bitmap.Data = {
          7E010000424D7E01000000000000760000002800000016000000160000000100
          0400000000000801000000000000000000001000000000000000000000000000
          BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777777777007000777777777777770007007007777777777777777007007070
          7888888888888807070077770000000000000087770077770B3B33B0B303B087
          7700777700B30B0B303B0087770077770E0B33B303B0E087770077770EE0B0B0
          3B0EE087770077770EEE030E00EEE087770077770EEEE0EEEEEEE08777007777
          0EEEEEEEEEEEE087770077770EEEEEEEE00EE087770077770EEEEEEE0BB0E087
          770077770EEEEEEE0BB0E087770077770EEEEEEEE00EE087770077770EEEEEEE
          EEEEE08777007777000000000000007777007070777777777777770707007007
          7777777777777770070070007777777777777700070077777777777777777777
          7700}
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1082#1072#1082' '#1082#1072#1088#1090#1080#1085#1082#1091
        OnClick = N13Click
      end
      object N16: TMenuItem
        Bitmap.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000010000000000000000000
          BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777770080000000800770330888887703077033088888770307703308888877
          0307703300000000030770333333333333077030000000003307703077777777
          0307703077777777030770307777777703077030777777770307703077777777
          0007703077777777070770000000000000077777777777777777}
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1074#1089#1105
        OnClick = N16Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object N2: TMenuItem
        Bitmap.Data = {
          42010000424D4201000000000000760000002800000011000000110000000100
          040000000000CC00000000000000000000001000000010000000000000000000
          BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          777770000000777777777777777770000000777777777777770F700000007777
          0F777777777770000000777000F7777770F770000000777000F777770F777000
          00007777000F77700F777000000077777000F700F7777000000077777700000F
          7777700000007777777000F777777000000077777700000F7777700000007777
          7000F70F7777700000007770000F77700F7770000000770000F7777700F77000
          00007700F7777777700F70000000777777777777777770000000777777777777
          777770000000}
        Caption = #1042#1099#1093#1086#1076
        OnClick = N2Click
      end
    end
    object N5: TMenuItem
      Caption = #1054#1087#1094#1080#1080
      object N19: TMenuItem
        Caption = #1055#1083#1086#1089#1082#1080#1081' '#1074#1080#1076
        OnClick = N19Click
      end
      object N12: TMenuItem
        Bitmap.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000C40E0000C40E00000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFBFBFBF7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
          7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7FFFFFFFFFFFFF7F7F7FFFFFFF
          BFBFBF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF7F7F7FFFFFFFFFFFFF7F7F7FFFFFFF7F7F7F000000BFBFBFFFFFFFFFFFFFFF
          FFFFBFBFBF000000000000FFFFFFFFFFFF7F7F7FFFFFFFFFFFFF7F7F7FFFFFFF
          7F7F7FBFBFBF7F7F7FFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F000000FFFFFFFFFF
          FF7F7F7FFFFFFFFFFFFF7F7F7FFFFFFFFFFFFFFFFFFFFFFFFF7F7F7FFFFFFFFF
          FFFF7F7F7FFFFFFFBFBFBFFFFFFFFFFFFF7F7F7FFFFFFFFFFFFF7F7F7FFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FF7F7F7FFFFFFFFFFFFF7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F
          7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7FFFFFFFFFFFFF7F7F7FFFFFFF
          FFFFFFFFFFFFFFFFFF7F7F7FFFFFFFFFFFFF7F7F7FFFFFFFFFFFFFFFFFFFFFFF
          FF7F7F7FFFFFFFFFFFFF7F7F7FFFFFFFBFBFBFFFFFFF7F7F7FFFFFFFFFFFFFFF
          FFFFFFFFFF7F7F7FFFFFFFFFFFFFFFFFFF7F7F7FFFFFFFFFFFFF7F7F7FFFFFFF
          0000007F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7FBFBFBF7F7F
          7F7F7F7FFFFFFFFFFFFF7F7F7FFFFFFF000000000000BFBFBFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFBFBFBF0000007F7F7F7F7F7FFFFFFFFFFFFF7F7F7FFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7F7F7F7FBFBF
          BF7F7F7FFFFFFFFFFFFF7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7F7FFFFFFFFFFFFFBFBFBF7F7F7F
          7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F7F
          7F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        Caption = #1051#1080#1085#1077#1081#1085#1099#1081' '#1052#1053#1050
        OnClick = N12Click
      end
      object N17: TMenuItem
        Bitmap.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888888888888888888888888888888888888880088008888888888800008888
          8888888880088888888888880000888888888880088008888888888888888818
          8888888888888818888888888888888188888888888888811888888888888888
          8888888888888888888888888888888888888888888888888888}
        Caption = #1055#1077#1088#1074#1072#1103' '#1087#1088#1086#1080#1079#1074#1086#1076#1085#1072#1103
        OnClick = N17Click
      end
      object N6: TMenuItem
        Bitmap.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888888888888888888888888888888888888880088008888888888800008888
          8888888880088888888888880000888888888880088008888888888888888818
          8888888888888818888888888888888188888888888888811888888888888888
          8888888888888888888888888888888888888888888888888888}
        Caption = #1044#1074#1086#1081#1085#1086#1077' '#1076#1080#1092#1092#1077#1088#1077#1085#1094#1080#1088#1086#1074#1072#1085#1080#1077
        OnClick = N6Click
      end
      object N14: TMenuItem
        Caption = #1056#1072#1079#1074#1077#1088#1085#1091#1090#1100
        OnClick = N14Click
      end
      object N21: TMenuItem
        Caption = #1057#1088#1072#1074#1085#1080#1090#1100' '#1089' '#1101#1090#1072#1083#1086#1085#1086#1084
        OnClick = N21Click
      end
      object N15: TMenuItem
        Caption = '-'
      end
      object X1: TMenuItem
        Caption = #1051#1086#1075#1072#1088#1080#1092#1084#1080#1095#1077#1089#1082#1072#1103' '#1086#1089#1100' X'
        OnClick = X1Click
      end
      object Y1: TMenuItem
        Caption = #1051#1086#1075#1072#1088#1080#1092#1084#1080#1095#1077#1089#1082#1072#1103' '#1086#1089#1100' Y'
        OnClick = Y1Click
      end
      object N8: TMenuItem
        Bitmap.Data = {
          16020000424D160200000000000076000000280000001A0000001A0000000100
          040000000000A001000000000000000000001000000000000000000000000000
          BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777777777777709400077777777777777777799977777000000777777777777
          77777999977777FFFF0079997788888888889999777777FFFF00799997888888
          88899998777777FFFF00779999444444444999887777770000007779999FBFBF
          BF999488777777000000777799999BFBF99994887777770000007777799999BF
          9999B488777777000000777774F99999999BF488777777000000777774BF9999
          99BFB488777777FFFF00777774FBF9999BFBF488777777FFFFC0777774BF9999
          99BFB488777777FFFF00777774F99999999BF488777777FFFF007777749999BF
          9999B488777777FFFF00777774999BFBF9999488777777FFFF0077777999BFBF
          B499999777777700FFFF77779999FBFBF4F9999977777700F9007779999FBFBF
          B4B479999777771E8000779999FBFBFBF4477799997777000000799994444444
          4477777999777700800079997777777777777777997777008000799777777777
          7777777777777700800077777777777777777777777777008000777777777777
          7777777777777700800077777777777777777777777777008000}
        Caption = #1054#1095#1080#1089#1090#1080#1090#1100
        OnClick = N8Click
      end
    end
    object N11: TMenuItem
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1076#1072#1085#1085#1099#1093
      object N18: TMenuItem
        Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1086#1090#1089#1077#1095#1082#1080
        OnClick = N18Click
      end
      object N20: TMenuItem
        Caption = #1054#1073#1088#1077#1079#1072#1090#1100
        OnClick = N20Click
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
  object OpenDialogDat: TOpenDialog
    Filter = 'DAT files|*.dat'
    Left = 128
    Top = 16
  end
end
