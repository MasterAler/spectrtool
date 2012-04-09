object FrmMAIN: TFrmMAIN
  Left = 192
  Top = 126
  Width = 795
  Height = 509
  Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1072' "'#1058#1077#1095#1100'". '#1054#1073#1088#1072#1073#1086#1090#1095#1080#1082' '#1089#1087#1077#1082#1090#1088#1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 357
    Width = 779
    Height = 3
    Cursor = crVSplit
    Align = alBottom
  end
  object StatusMain: TStatusBar
    Left = 0
    Top = 432
    Width = 779
    Height = 19
    Panels = <
      item
        Text = #1055#1086#1075#1088#1077#1096#1085#1086#1089#1090#1100':'
        Width = 50
      end>
  end
  object Panel1: TPanel
    Left = 113
    Top = 0
    Width = 666
    Height = 357
    Align = alClient
    TabOrder = 1
    object ChartOut: TChart
      Left = 1
      Top = 1
      Width = 664
      Height = 355
      AnimatedZoom = True
      BackWall.Brush.Color = clWhite
      BackWall.Brush.Style = bsClear
      Title.Text.Strings = (
        #1057#1087#1077#1082#1090#1088#1099)
      OnClickLegend = ChartOutClickLegend
      OnClickSeries = ChartOutClickSeries
      BottomAxis.Title.Caption = #1044#1083'.'#1074#1086#1083#1085#1099', '#1085#1084
      LeftAxis.Title.Caption = 'I,mA'
      Legend.Alignment = laTop
      Legend.LegendStyle = lsSeries
      Align = alClient
      TabOrder = 0
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 360
    Width = 779
    Height = 72
    Align = alBottom
    TabOrder = 2
    object SGStats: TStringGrid
      Left = 1
      Top = 1
      Width = 777
      Height = 70
      Align = alClient
      DefaultColWidth = 75
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowMoving, goRowSelect]
      PopupMenu = PopupMenuStats
      TabOrder = 0
      OnDblClick = SGStatsDblClick
      OnSelectCell = SGStatsSelectCell
    end
  end
  object ValueListSpectr: TValueListEditor
    Left = 0
    Top = 0
    Width = 113
    Height = 357
    Align = alLeft
    KeyOptions = [keyEdit, keyAdd, keyDelete, keyUnique]
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected, goColSizing, goEditing, goThumbTracking]
    TabOrder = 3
    TitleCaptions.Strings = (
      'N'
      #1044#1083'.'#1074#1086#1083#1085#1099)
    OnDrawCell = ValueListSpectrDrawCell
    OnEditButtonClick = ValueListSpectrEditButtonClick
    OnKeyPress = ValueListSpectrKeyPress
    OnMouseDown = ValueListSpectrMouseDown
    OnValidate = ValueListSpectrValidate
    ColWidths = (
      38
      69)
  end
  object MainMenu: TMainMenu
    Left = 200
    Top = 8
    object Af1: TMenuItem
      Caption = #1060#1072#1081#1083
      object N3: TMenuItem
        Bitmap.Data = {
          4E010000424D4E01000000000000760000002800000012000000120000000100
          040000000000D800000000000000000000001000000010000000000000000000
          BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3333330000003333333333333333330000003333333333333333330000003800
          000000000003330000003007B7B7B7B7B7B03300000030F07B7B7B7B7B703300
          000030B0B7B7B7B7B7B70300000030FB0B7B7B7B7B7B0300000030BF07B7B7B7
          B7B7B000000030FBF000007B7B7B7000000030BFBFBFBF0000000300000030FB
          FBFBFBFBFB033300000030BFBFBFBFBFBF033300000030FBFBF0000000333300
          0000330000033333333333000000333333333333333333000000333333333333
          333333000000333333333333333333000000}
        Caption = #1054#1090#1082#1088#1099#1090#1100
        OnClick = N3Click
      end
      object N11: TMenuItem
        Bitmap.Data = {
          16020000424D160200000000000076000000280000001A0000001A0000000100
          040000000000A001000000000000000000001000000010000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888888888888800000088888888888888888888888888000000888888888888
          8888888888888800000088888888888888888888888888000000888800000000
          00000008888888000000888800FBFBFBFBFBFB08888888000000888800BFBFBF
          BFBFBF088888880002208888070BFBFBFBFBFBF088888840440888880B0FBFBF
          BFBFBFB08888880000008888070BFBFBFBFBFBF088888800022188880B70BFBF
          BFBFBFBF08888884804C888807B0FBFBFBFBFBFB08888800000088880B700000
          00000000088888001010888807B7B7B0AEA0B0888888882462208888000B7B00
          0AEA008808888800000088888880008880AEA080088888001010888888888888
          880AEA0A088888A684228888888888888880AEAE088888222226888888888888
          88880AEA0888880000008888888888888880AEAE08888874657F888888888888
          880000000888889505D188888888888888888888888888000000888888888888
          888888888888885CE74788888888888888888888888888000000888888888888
          8888888888888800000088888888888888888888888888105100}
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100
        OnClick = N11Click
      end
      object N4: TMenuItem
        Bitmap.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000010000000000000000000
          BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777770080000000800770330888887703077033088888770307703308888877
          0307703300000000030770333333333333077030000000003307703077777777
          0307703077777777030770307777777703077030777777770307703077777777
          0007703077777777070770000000000000077777777777777777}
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1087#1080#1082#1080
        OnClick = N4Click
      end
      object N13: TMenuItem
        Bitmap.Data = {
          4E010000424D4E01000000000000760000002800000012000000120000000100
          040000000000D800000000000000000000001000000000000000000000000000
          BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777000000
          0000000000007777770788888888800000007777770F77777777800000007777
          770F77700777800000007777000F70000007800000007700EC0F777777778000
          000070EEEC0FFFFFFFFF700000000EEEEE00000000000000000070EEFEECCCBB
          BB3077000000770EFEEECC8BBBB3070000007770EEEE228BB13B070000007770
          EEE2222FB11B3000000077770EE22222111B3000000077770EE222211B000700
          0000777770E22222007777000000777770FEE2207777770000007777770EE007
          777777000000777777700777777777000000}
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1082#1072#1088#1090#1080#1085#1082#1091
        OnClick = N13Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object N1: TMenuItem
        Bitmap.Data = {
          AE010000424DAE010000000000007600000028000000170000001A0000000100
          0400000000003801000000000000000000001000000000000000000000000000
          BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          77777777777777777777777777777777777B77000000000000000000000B7778
          F09111111111110F07707778F09111111111110F07787778F091111111111100
          07777778F091111111111170077B7778F09111111111117007707778F0911111
          1111117007707778F09111111111110F077B7778F09111111111110F077B7778
          F09101111111110F07707778F090B0111111110F077B7778F09101111111110F
          077B7778F09111111111110F077B7778F09111111111110007707778F0911111
          11111170077B7778F091111111111170077B7778F091111111111170077B7778
          F09111111111110F07707778F09111111111110F07707778F09999999999990F
          07707778F00000000000000F07707778FFFFFFFFFFFFFFFF0770777888888888
          888888880770777777777777777777777770}
        Caption = #1042#1099#1093#1086#1076
        OnClick = N1Click
      end
    end
    object N5: TMenuItem
      Caption = #1054#1087#1094#1080#1080
      object N8: TMenuItem
        Bitmap.Data = {
          66010000424D6601000000000000760000002800000014000000140000000100
          040000000000F000000000000000000000001000000010000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
          DDDDDDDD0000DDDD777777777777DDDD0000DDD00000000000007DDD0000DD0F
          EFEFEFEFEFEF07DD0000DD0E00000E00000E07DD0000DD0F88880F88880F07DD
          0000DD0EFEFEFEFEFEFE07DD0000DD0F00E00F00E00F07DD0000DD0E80F80E80
          F80E07DD0000DD0FEFEFEFEFEFEF07DD0000DD0E00F00E00F00E07DD0000DD0F
          80E80F80E80F07DD0000DD0EFEFEFEFEFEFE07DD0000DD0F00000000000F07DD
          0000DD0E08181881880E07DD0000DD0F08818818180F07DD0000DD0E00000000
          000E07DD0000DD0FEFEFEFEFEFEF0DDD0000DDD0000000000000DDDD0000DDDD
          DDDDDDDDDDDDDDDD0000}
        Caption = #1050#1072#1083#1100#1082#1091#1083#1103#1090#1086#1088
        OnClick = N8Click
      end
      object N9: TMenuItem
        Caption = #1057#1082#1088#1099#1090#1100' '#1090#1072#1073#1083#1080#1094#1091' '#1083#1080#1085#1080#1081
        OnClick = N9Click
      end
      object N10: TMenuItem
        Caption = #1057#1082#1088#1099#1090#1100' '#1083#1077#1075#1077#1085#1076#1091
        OnClick = N10Click
      end
      object N18: TMenuItem
        Caption = #1057#1082#1088#1099#1090#1100' '#1089#1090#1072#1090#1080#1089#1090#1080#1082#1091
        OnClick = N18Click
      end
      object N12: TMenuItem
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
        OnClick = N12Click
      end
      object N14: TMenuItem
        Bitmap.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00337333733373
          3373337F3F7F3F7F3F7F33737373737373733F7F7F7F7F7F7F7F770000000000
          000077777777777777773303333333333333337FFF333333333F370993333333
          3399377773F33333337733033933333339333F7FF7FFFFFFF7FF77077797CCC7
          977777777777777777773303339C333C9333337F3377F3377F33370333C93339
          C333377F33773FF77F33330333C39993C3333F7FFF7F777F7FFF770777C77777
          C77777777777777777773303333C333C3333337F33373FF7333337033333CCC3
          3333377F33337773333333033333333333333F7FFFFFFFFFFFFF770777777777
          7777777777777777777733333333333333333333333333333333}
        Caption = #1042#1099#1076#1077#1083#1080#1090#1100' '#1084#1072#1082#1089#1080#1084#1091#1084#1099
        OnClick = N14Click
      end
      object N15: TMenuItem
        Bitmap.Data = {
          BE000000424DBE00000000000000760000002800000010000000090000000100
          0400000000004800000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00800000000000
          0000888777770877777888F888870F8888788848888818888488844444441444
          4448884888881888848888FFFFF80FFFFF888000000000000000888888888888
          8888}
        Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1086#1075#1088#1077#1096#1085#1086#1089#1090#1100' '#1087#1080#1082#1086#1074
        OnClick = N15Click
      end
      object N16: TMenuItem
        Bitmap.Data = {
          66010000424D6601000000000000760000002800000014000000140000000100
          040000000000F000000000000000000000001000000010000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888888800008888888888888888888800008888888888888888888800008808
          88808880888088880000800000000000000000080000880880CCC0AAA0DDD088
          0000880880CCC0AAA0DDD0880000800880CCC0AAA0DDD0880000880880CCC0AA
          A0DDD0880000880880CCC0AAA0DDD08800008008800000AAA0DDD08800008808
          888880AAA0DDD088000088088888800000DDD088000080088888888880DDD088
          000088088888888880DDD0880000880888888888800000880000800888888888
          8888888800008888888888888888888800008888888888888888888800008888
          88888888888888880000}
        Caption = #1056#1072#1089#1089#1095#1080#1090#1072#1090#1100' '#1090#1077#1084#1087#1077#1088#1072#1090#1091#1088#1085#1099#1077' '#1082#1088#1080#1074#1099#1077
        OnClick = N16Click
      end
      object N17: TMenuItem
        Bitmap.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          04000000000080000000120B0000120B00001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          333300000000000000000FFFFFFFFFFFFFF00F00F00F000F00F00FFFFFFFFFFF
          FFF00F00F00FF00000F00FEEEEEFF0F9FCF00FFFFFFFF0F9FCF00F0000FFF0FF
          FCF00F0000FFF0FFFFF00FFFFFFFFFFFFFF00CCCCCCCCCCCCCC0088CCCCCCCCC
          C880000000000000000033333333333333333333333333333333}
        Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
        OnClick = N17Click
      end
    end
    object N6: TMenuItem
      Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
      object N7: TMenuItem
        Bitmap.Data = {
          66010000424D6601000000000000760000002800000014000000140000000100
          040000000000F000000000000000000000001000000010000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888888800008888888888888888888800008888888887778888888800008888
          8888600788888888000088888888E60788888888000088888888EE6888888888
          000088888888877788888888000088888888600788888888000088888888E607
          78888888000088888888E660778888880000888888888E660778888800008888
          888878E660778888000088888880778E660788880000888888660778E6078888
          0000888888E66077E608888800008888888E660066688888000088888888E666
          6E8888880000888888888EEEE888888800008888888888888888888800008888
          88888888888888880000}
        Caption = #1057#1087#1088#1072#1074#1082#1072
        OnClick = N7Click
      end
    end
  end
  object OpenFileDialog: TOpenDialog
    DefaultExt = '*.txt'
    Filter = #1058#1077#1082#1089#1090#1086#1074#1099#1077' '#1092#1072#1081#1083#1099' (*.txt)|*.txt'
    Title = #1042#1099#1073#1077#1088#1080#1090#1077' '#1092#1072#1081#1083' '#1089#1087#1077#1082#1090#1088#1072
    Left = 240
    Top = 8
  end
  object SaveChartDialog: TSavePictureDialog
    DefaultExt = '*.bmp'
    FileName = 'ChartOut'
    Filter = 
      'Bitmaps (*.bmp)|*.bmp|Enhanced Metafiles (*.emf)|*.emf|Metafiles' +
      ' (*.wmf)|*.wmf'
    Title = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1089#1087#1077#1082#1090#1088#1099' '#1082#1072#1082
    Left = 274
    Top = 9
  end
  object SaveDataDialog: TSaveDialog
    DefaultExt = '*.txt'
    FileName = 'Peaks'
    Filter = 'Text Files (*.txt)|*.txt'
    Title = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1087#1080#1082#1080' '#1082#1072#1082
    Left = 314
    Top = 9
  end
  object PopupMenuStats: TPopupMenu
    Left = 354
    Top = 9
    object N19: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1074#1099#1076#1077#1083#1077#1085#1080#1077
      OnClick = N19Click
    end
    object N20: TMenuItem
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100
      OnClick = N20Click
    end
  end
end
