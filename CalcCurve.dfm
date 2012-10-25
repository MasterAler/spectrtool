object FrmCurves: TFrmCurves
  Left = 768
  Top = 103
  Caption = #1058#1077#1084#1087#1077#1088#1072#1090#1091#1088#1085#1099#1077' '#1082#1088#1080#1074#1099#1077
  ClientHeight = 375
  ClientWidth = 477
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MenuCurves
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ChartCurves: TChart
    Left = 0
    Top = 0
    Width = 477
    Height = 375
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Legend.Alignment = laTop
    Legend.CheckBoxes = True
    Legend.LegendStyle = lsSeries
    Title.Text.Strings = (
      #1058#1077#1084#1087#1077#1088#1072#1090#1091#1088#1085#1099#1077' '#1082#1088#1080#1074#1099#1077)
    OnClickSeries = ChartCurvesClickSeries
    BottomAxis.Title.Caption = 'F(K)'
    LeftAxis.Title.Caption = 'Ln Z'
    View3D = False
    Align = alClient
    TabOrder = 0
    OnMouseMove = ChartCurvesMouseMove
  end
  object MenuCurves: TMainMenu
    Left = 8
    Top = 8
    object N3: TMenuItem
      Caption = #1060#1072#1081#1083
      object Origin1: TMenuItem
        Bitmap.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          04000000000080000000130B0000130B00001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333303
          33333333333333903333333333333399033300000099999990330FFFF0999999
          99030FFFF099999999900F00F099999999030FFFF099999990330F00FFFFF099
          03330FFFFFFFF09033330F00F000000333330FFFF0FF033333330F08F0F03333
          33330FFFF0033333333300000033333333333333333333333333}
        Caption = #1069#1082#1089#1087#1086#1088#1090' '#1076#1072#1085#1085#1099#1093' '#1074' Origin'
        OnClick = Origin1Click
      end
      object N6: TMenuItem
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
        OnClick = N6Click
      end
      object N11: TMenuItem
        Bitmap.Data = {
          4E010000424D4E01000000000000760000002800000012000000120000000100
          040000000000D800000000000000000000001000000010000000000000000000
          BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
          DDDDDD000000DDD00000000000DDDD000000DD0777777777070DDD000000D000
          000000000070DD000000D0777777FFF77000DD000000D077777799977070DD00
          0000D0000000000000770D000000D0777777777707070D000000DD0000000000
          70700D000000DDD0FFFFFFFF07070D000000DDDD0FCCCCCF0000DD000000DDDD
          0FFFFFFFF0DDDD000000DDDDD0FCCCCCF0DDDD000000DDDDD0FFFFFFFF0DDD00
          0000DDDDDD000000000DDD000000DDDDDDDDDDDDDDDDDD000000DDDDDDDDDDDD
          DDDDDD000000DDDDDDDDDDDDDDDDDD000000}
        Caption = #1055#1077#1095#1072#1090#1100
        OnClick = N11Click
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object N4: TMenuItem
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
        Caption = #1047#1072#1082#1088#1099#1090#1100
        OnClick = N4Click
      end
    end
    object N1: TMenuItem
      Caption = #1054#1087#1094#1080#1080
      object N2: TMenuItem
        Caption = #1058#1088#1072#1089#1089#1080#1088#1086#1074#1082#1072' '#1079#1085#1072#1095#1077#1085#1080#1081
        OnClick = N2Click
      end
      object N7: TMenuItem
        Bitmap.Data = {
          36010000424D3601000000000000760000002800000011000000100000000100
          040000000000C0000000120B0000120B00001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00337333733373
          3373300000003373737373737373300000007700000000000000700000003303
          3333333333333000000037099333333333993000000033033933333339333000
          000077077797CCC79777700000003303339C333C933330000000370333C93339
          C33330000000330333C39993C33330000000770777C77777C777700000003303
          333C333C33333000000037033333CCC333333000000033033333333333333000
          0000770777777777777770000000333333333333333330000000}
        Caption = #1054#1073#1088#1072#1073#1086#1090#1072#1090#1100' '#1052#1053#1050' '#1074#1080#1076#1080#1084#1086#1077
        OnClick = N7Click
      end
      object N1910231: TMenuItem
        Caption = #1057#1090#1072#1085#1076#1072#1088#1090#1085#1072#1103' '#1086#1073#1088#1072#1073#1086#1090#1082#1072' '#1052#1053#1050
        OnClick = N1910231Click
      end
      object N9: TMenuItem
        Caption = #1054#1073#1088#1072#1073#1086#1090#1072#1090#1100' '#1075#1086#1088#1103#1095#1091#1102' '#1075#1088#1091#1087#1087#1091
        OnClick = N9Click
      end
      object N10: TMenuItem
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
        Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1074#1089#1077' '#1052#1053#1050
        OnClick = N10Click
      end
      object N8: TMenuItem
        Bitmap.Data = {
          BE000000424DBE00000000000000760000002800000010000000090000000100
          0400000000004800000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00800000000000
          0000888777770877777888F888870F8888788848888818888488844444441444
          4448884888881888848888FFFFF80FFFFF888000000000000000888888888888
          8888}
        Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1076#1080#1072#1087#1072#1079#1086#1085#1086#1074
        OnClick = N8Click
      end
    end
  end
end
