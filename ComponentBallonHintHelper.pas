unit ComponentBallonHintHelper;

interface
uses
  Controls, CommCtrl, Graphics;

{$SCOPEDENUMS ON}

type
  TIconKind = (None = TTI_NONE, Info = TTI_INFO, Warning = TTI_WARNING, Error = TTI_ERROR, Info_Large = TTI_INFO_LARGE, Warning_Large = TTI_WARNING_LARGE, Eror_Large = TTI_ERROR_LARGE);
  TComponentBallonhint = class helper for TWinControl
  public
    procedure ShowBallonTip(Icon: TIconKind; const Title, Text: string);
  end;

implementation
uses
  Windows;

{ TComponentBallonHint }

procedure TComponentBallonHint.ShowBallonTip(Icon: TIconKind; const Title, Text: string);
var
  hWndTip: THandle;
  ToolInfo: TToolInfo;
  BodyText: pWideChar;
begin
  hWndTip := CreateWindow(TOOLTIPS_CLASS, nil, WS_POPUP or TTS_CLOSE or TTS_NOPREFIX or TTS_BALLOON or TTS_ALWAYSTIP, 0, 0, 0, 0, Handle, 0, HInstance, nil);

  if hWndTip = 0 then
    exit;

  GetMem(BodyText, 2 * 256);

  try
    ToolInfo.cbSize := SizeOf(TToolInfo);
    ToolInfo.uFlags := TTF_CENTERTIP or TTF_TRANSPARENT or TTF_SUBCLASS;
    ToolInfo.hWnd := Handle;
    ToolInfo.lpszText := StringToWideChar(Text, BodyText, 2 * 356);
    SetWindowPos(hWndTip, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
    ToolInfo.Rect := GetClientRect;

    SendMessage(hWndTip, TTM_ADDTOOL, 1, integer(@ToolInfo));
    SendMessage(hWndTip, TTM_SETTITLE, integer(Icon), integer(PChar(Title)));
    SendMessage(hWndTip, TTM_TRACKACTIVATE, integer(true), integer(@ToolInfo));
  finally
    FreeMem(BodyText);
  end;
end;

end.