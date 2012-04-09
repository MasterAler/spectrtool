object FrmCurves: TFrmCurves
  Left = 191
  Top = 137
  Width = 493
  Height = 313
  Caption = #1058#1077#1084#1087#1077#1088#1072#1090#1091#1088#1085#1099#1077' '#1082#1088#1080#1074#1099#1077
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
    Height = 255
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Title.Text.Strings = (
      #1058#1077#1084#1087#1077#1088#1072#1090#1091#1088#1085#1099#1077' '#1082#1088#1080#1074#1099#1077)
    OnClickSeries = ChartCurvesClickSeries
    BottomAxis.Title.Caption = 'F(K)'
    LeftAxis.Title.Caption = 'Ln Z'
    Legend.Alignment = laTop
    Legend.LegendStyle = lsSeries
    View3D = False
    OnGetLegendText = ChartCurvesGetLegendText
    Align = alClient
    TabOrder = 0
    object Series1: TLineSeries
      Marks.ArrowLength = 8
      Marks.Visible = False
      SeriesColor = clRed
      Pointer.Brush.Color = clRed
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = True
      XValues.DateTime = False
      XValues.Name = 'X'
      XValues.Multiplier = 1.000000000000000000
      XValues.Order = loAscending
      YValues.DateTime = False
      YValues.Name = 'Y'
      YValues.Multiplier = 1.000000000000000000
      YValues.Order = loNone
    end
  end
  object MenuCurves: TMainMenu
    Left = 8
    Top = 8
    object N3: TMenuItem
      Caption = #1060#1072#1081#1083
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
