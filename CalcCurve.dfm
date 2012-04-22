object FrmCurves: TFrmCurves
  Left = 191
  Top = 137
  Caption = #1058#1077#1084#1087#1077#1088#1072#1090#1091#1088#1085#1099#1077' '#1082#1088#1080#1074#1099#1077
  ClientHeight = 275
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
  PixelsPerInch = 96
  TextHeight = 13
  object ChartCurves: TChart
    Left = 0
    Top = 0
    Width = 477
    Height = 275
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Legend.Alignment = laTop
    Legend.LegendStyle = lsSeries
    Title.Text.Strings = (
      #1058#1077#1084#1087#1077#1088#1072#1090#1091#1088#1085#1099#1077' '#1082#1088#1080#1074#1099#1077)
    OnClickSeries = ChartCurvesClickSeries
    BottomAxis.Title.Caption = 'F(K)'
    LeftAxis.Title.Caption = 'Ln Z'
    View3D = False
    Align = alClient
    TabOrder = 0
    ExplicitHeight = 255
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
    end
  end
end
