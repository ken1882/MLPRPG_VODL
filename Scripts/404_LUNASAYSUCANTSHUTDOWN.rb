#==============================================================================
# ** LUNA SAYS U CANNOT SHUTDOWN
#------------------------------------------------------------------------------
#  Exit button ('X') is disabled in game window, but still available in console
#==============================================================================
SetClassLong = Win32API.new('user32', 'SetClassLong', 'lil', 'i')
SetClassLong.call(PONY::API::Hwnd, -26, 0x0200)
