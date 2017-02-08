FindWindow = Win32API.new('user32', 'FindWindow', 'pp', 'l')
SetClassLong = Win32API.new('user32', 'SetClassLong', 'lil', 'i')
GetPrivateProfileString = Win32API.new('kernel32','GetPrivateProfileString','pppplp','l')
buf = " " * 256
GetPrivateProfileString.call('Game','Title','',buf,256,".\\Game.ini")
buf.strip!
HWND = FindWindow.call('RGSS Player', buf)
SetClassLong.call(HWND, -26, 0x0200)
 #no exit button
