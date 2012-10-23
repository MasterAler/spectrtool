object FrmCurves: TFrmCurves
  Left = 191
  Top = 137
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
  Position = poMainFormCenter
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
    ExplicitHeight = 355
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
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1082#1072#1082' '#1082#1072#1088#1090#1080#1085#1082#1091
        OnClick = N6Click
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object N4: TMenuItem
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
