=begin
#==============================================================================
# ■ API相關操作 版本1.0
#------------------------------------------------------------------------------
# 　此腳本目前只適用於RGSS3。
# 　在使用之前，請詳閱使用方法及備註，否則造成系統或檔案損壞後果請自行承擔。
#------------------------------------------------------------------------------
# 　這個腳本可以幫助你：
# 　1.轉換字串的編碼。
# 　2.讀取、寫入INI檔，對應系統編碼和Unicode編碼。
# 　3.對登錄檔進行建立、修改、讀取、刪除機碼和值項，對應系統編碼。
# 　這個腳本的放置位置：main以上，盡量在自訂腳本的最高處，原始腳本以下。
#------------------------------------------------------------------------------
# 　困難度：極高
# 　撰寫者：白羽ゆりな（abc1236762）
# 　工作室：RMGTW工作室 http://rmgtw.eu.org/
#------------------------------------------------------------------------------
# 　更新日誌：
# 　　1.0 2015/02/23 初版公開。
#------------------------------------------------------------------------------
# 　使用方法：
# 　■轉換編碼的部分
# 　　●String.conv(from, to) 將字串從來源編碼轉換至欲輸出的編碼。(*1)
# 　　　from ：字串來源編碼的代碼頁，資料型別為整數或符號。(*2)
# 　　　to   ：欲輸出編碼的代碼頁，資料型別為整數或符號。(*2)
# 　　　avoid：為真能降低輸出額外亂碼的機率，資料型別為布林值，選填項，預設為真。
# 　　　例：
# 　　　　"foobar".conv(65001, 932) 等價於
# 　　　　"foobar".conv(:UTF_8, :Shift_JIS)
# 　　●String.to_uni([usesys]) 將字串從UTF-8轉換至UTF-16
# 　　　usesys：是否使用內建功能取代，選填項預設為真。
# 　　　例：
# 　　　　"foobar".to_uni 等價於
# 　　　　"foobar".conv(:UTF_8, :UTF_16LE)
# 　　●String.to_utf8([usesys]) 將字串從UTF-16轉換至UTF-8
# 　　　usesys：是否使用內建功能取代，選填項預設為真。
# 　　●String.to_ansi() 將字串從UTF-8轉換至系統編碼
# 　■INI檔的操作部分(*3)
# 　　●INI.get(lpAppName, lpKeyName, [lpDefault[, nSize]]) 取得指定位置的參數
# 　　　傳回取得的值，失敗時傳回預設值。
# 　　　lpAppName：欲取得參數所在的節，資料型別為字串。
# 　　　lpKeyName：欲取得參數所在的參數名稱，資料型別為字串。
# 　　　lpDefault：預設值，欲取得的參數不存在時輸出此，資料型別為字串，選填項。
# 　　　nSize    ：緩沖區大小，必須不小於參數的長度，資料型別為整數，選填項。
# 　　　例：
# 　　　　INI.get("Foo", "Bar")
# 　　●INI.set(lpAppName, lpKeyName, lpString) 設定指定位置的參數
# 　　　傳回整數，失敗時傳回0。
# 　　　lpAppName：欲設定參數所在的節，資料型別為字串。
# 　　　lpKeyName：欲設定參數所在的參數名稱，資料型別為字串。
# 　　　lpString ：欲設定參數值，資料型別為字串。
# 　　　例：
# 　　　　INI.set("Foo", "Bar", "Foobar")
# 　■登錄檔的操作部分(*4)
# 　　●Registry.new() 初始化Registry類別，此動作為必要
# 　　●Registry.open(hKey, lpSubKey[, dwOptions]) 開啟指定的機碼
# 　　　傳回錯誤代碼，成功時傳回0。
# 　　　hKey     ：機碼的基底位置，資料型別為符號或整數。(*5)
# 　　　lpSubKey ：機碼的延伸位置，資料型別為字串。(*6)
# 　　　dwOptions：開啟機碼的選項，資料型別為符號或整數，選填項，預設為0。(*7)
# 　　●Registry.create(hKey, lpSubKey[, dwOptions]) 新增指定的機碼
# 　　　成功時傳回字串，失敗時傳回錯誤代碼。
# 　　　成功時，如果原本沒有機碼，是新增的動作，傳回"REG_CREATED_NEW_KEY"
# 　　　        如果原本存在機碼，是開啟的動作，傳回"REG_OPENED_EXISTING_KEY"
# 　　　hKey     ：機碼的基底位置，資料型別為符號或整數。(*5)
# 　　　lpSubKey ：機碼的延伸位置，資料型別為字串。(*6)
# 　　　dwOptions：開啟機碼的選項，資料型別為符號或整數，選填項，預設為0。(*8)
# 　　●Registry.remove(hKey, lpSubKey) 刪除指定的機碼
# 　　　傳回錯誤代碼，成功時傳回0。
# 　　　hKey     ：機碼的基底位置，資料型別為符號或整數。(*5)
# 　　　lpSubKey ：機碼的延伸位置，資料型別為字串。(*6)
# 　　●Registry.close  關閉已指定的機碼
# 　　　傳回錯誤代碼，成功時傳回0。
# 　　●Registry.get(lpValueName) 取得已指定的機碼中指定的值項
# 　　　傳回得到的值，失敗時傳回空（nil）。(9)
# 　　　lpValueName：欲查詢值項的名稱，資料型別為字串。
# 　　●Registry.set(lpValueName, lpData[, dwType]) 設定已指定的機碼中指定的值項
# 　　　傳回錯誤代碼，成功時傳回0。
# 　　　lpValueName：欲設定值項的名稱，資料型別為字串。
# 　　　lpData     ：欲設定值項的值，資料型別因值項的類型(dwType)不同而不同。(*9)
# 　　　dwType     ：欲設定值項的類型，資料型別為符號或整數，選填項，
# 　　　             預設為原本的類型，值項不存在時如沒有設定會為:REG_NONE(0)。(*9)
# 　　●Registry.delete(lpValueName) 刪除已指定的機碼中指定的值項
# 　　　傳回錯誤代碼，成功時傳回0。
# 　　　lpValueName：欲刪除值項的名稱，資料型別為字串。
# 　　登錄檔的範例：
# 　　> reg = Registry.new() # 初始化Registry
# 　　> reg.open(:HKEY_CURRENT_USER, "Software\\Enterbrain\\RGSS3")
# 　　  # 開啟HKEY_CURRENT_USER\Software\Enterbrain\RGSS3機碼
# 　　> reg.set("ButtonAssign", [0] * 25) # 設定ButtonAssign為指定的值
# 　　> value = reg.get("ButtonAssign") # 取得ButtonAssign的值傳回value
# 　　  # => [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
# 　　> reg.set("test", "test", :REG_SZ)
# 　　  # 因為在開啟的機碼中沒有test值項，所以會建立一個，且其值為"test"
# 　　> reg.delete("test") # 刪除剛剛建立的test值項
# 　　> reg.close() # 在操作完這機碼或是要換其他機碼時，記得關閉此機碼
# 　　> reg.create(:HKEY_CURRENT_USER, "Software\\Enterbrain\\RGSS3\\new")
# 　　  # 如果在那位置不存在，則會新增機碼，否則開啟
# 　　> reg.close() # 建立完機碼後不進行任何操作，請關閉。
# 　　> reg.remove(:HKEY_CURRENT_USER, "Software\\Enterbrain\\RGSS3\\new")
# 　　  # 移除剛剛建立的機碼HKEY_CURRENT_USER\Software\Enterbrain\RGSS3\new
# 　　  # 如果不再用reg操作註冊表，可以進行以下動作：
# 　　> reg = nil; GC.start
#------------------------------------------------------------------------------
# 　備註：
# 　　●註1：請勿使用UTF-16BE（代碼頁1201）以及UTF-32等作為來源或輸出編碼。
# 　　●註2：關於代碼頁：
# 　　　1.所有的代碼頁可以參考以下網址
# 　　　　https://msdn.microsoft.com/library/windows/desktop/dd317756.aspx
# 　　　2.from和to可用，以預先設定好的符號如下
# 　　　　符號       編碼名稱         對應代碼頁
# 　　　　:ACP       ANSI（系統編碼） 0
# 　　　　:Shift_JIS Shift-JIS        932
# 　　　　:GB2312    GB2312           936
# 　　　　:BIG5      BIG5             950
# 　　　　:UTF_16LE  UTF-16LE         1200
# 　　　　:UTF_8     UTF-8            65001
# 　　●註3：關於操作INI檔的注意事項
# 　　　1.如果沒有特殊需求，請盡量不要使用Unicode當作操作INI檔的編碼方式。
# 　　　　即使在編碼轉換的部分已經針對了輸出多餘的垃圾字串做了對應的措施，但在操
# 　　　　作INI檔時使用Unicode當作編碼方式時，可能發生以下狀況：
# 　　　　(1) 檔名不符合預期，例如你想設定的值會儲存在與原檔名不同的檔案中。
# 　　　　(2) 節、參數名稱、參數值的取得不符合預期，可能會有垃圾字串。
# 　　　　(3) 發生無法設定或取得的情況，原因是名稱、路徑錯誤，代碼123。
# 　　　　以上方法皆沒有替代方案，唯一只有使用系統編碼才可以避免，而相對的：
# 　　　　(1) 使用系統編碼操作INI檔，可以正常讀寫以系統編碼和UTF-16LE的INI檔。
# 　　　　(2) 在系統編碼無法容許的字元，皆會以'?'存在，包含設定或取得。
# 　　　　(3) 不過包含在系統編碼無法中容許字元的路徑也可以正常讀寫。
# 　　　2.在設定INI檔的值時，如果沒有找到指定的INI檔，則會新增一個。
# 　　　3.關於操昨時傳回的錯誤代碼，可以參考以下網址
# 　　　　https://msdn.microsoft.com/library/windows/desktop/ms681381.aspx
# 　　●註4：關於操作登錄檔的注意事項
# 　　　1.此腳本只提供系統編碼當作操作登錄檔的編碼方式，因此：
# 　　　　(1) 機碼、值項及其值含系統編碼不允許字元的操作可能會找不到名稱、路徑。
# 　　　　(2) 取得值項時，如其值的類別與字串相關，系統編碼不允許字元將會表'?'。
# 　　　　(3) 新增機碼或值項時，如果含系統編碼不允許字元將會以'?'代替。
# 　　　2.在建立、開啟機碼後，如果對裡面的值項操作完畢或不進行任何操昨時，一定要
# 　　　　進行關閉動作，否則如果發生問題，後果自行負責！
# 　　　3.更多關於登錄檔的操作，可以參考以下網址
# 　　　　https://msdn.microsoft.com/library/windows/desktop/ms724871.aspx
# 　　　　https://msdn.microsoft.com/library/windows/desktop/ms724875.aspx
# 　　　3.關於操昨時傳回的錯誤代碼，可以參考以下網址
# 　　　　https://msdn.microsoft.com/library/windows/desktop/ms681381.aspx
# 　　●註5：此處的hKey可以為
# 　　　符號                     代表值
# 　　　:HKEY_CLASSES_ROOT       0x80000000
# 　　　:HKEY_CURRENT_USER       0x80000001
# 　　　:HKEY_LOCAL_MACHINE      0x80000002
# 　　　:HKEY_USERS              0x80000003
# 　　　:HKEY_CURRENT_CONFIG     0x80000005
# 　　●註6：此處的lpSubKey在表示位置字串時，'\'必須標示為'\\'。
# 　　●註7：此處的dwOptions可以為
# 　　　符號                     對應值
# 　　　:REG_OPTION_NON_VOLATILE 0x0000
# 　　　:REG_OPTION_OPEN_LINK    0x0008
# 　　　詳閱：https://msdn.microsoft.com/library/windows/desktop/ms724897.aspx
# 　　●註8：此處的dwOptions可以為
# 　　　符號                       對應值
# 　　　:REG_OPTION_NON_VOLATILE   0x0000
# 　　　:REG_OPTION_VOLATILE       0x0001
# 　　　:REG_OPTION_CREATE_LINK    0x0002
# 　　　:REG_OPTION_BACKUP_RESTORE 0x0004
# 　　　詳閱：https://msdn.microsoft.com/library/windows/desktop/ms724897.aspx
# 　　●註9：對應值項的類型(dwType)，需設定或取得的值的資料型別如下
# 　　　dwType的符號                    對應值 值的資料型別
# 　　　:REG_NONE                       0      另外說明
# 　　　:REG_SZ                         1      String
# 　　　:REG_EXPAND_SZ                  2      String
# 　　　:REG_BINARY                     3      Array(Integer(0~255))
# 　　　:REG_DWORD                      4      Integer(0~4294967295)
# 　　　:REG_DWORD_LITTLE_ENDIAN        4      Integer(0~4294967295)
# 　　　:REG_DWORD_BIG_ENDIAN           5      Integer(0~4294967295)
# 　　　:REG_LINK                       6      String
# 　　　:REG_MULTI_SZ                   7      Array(String)
# 　　　:REG_RESOURCE_LIST              8      Array(Integer(0~255))
# 　　　:REG_FULL_RESOURCE_DESCRIPTOR   9      Array(Integer(0~255))
# 　　　:REG_RESOURCE_REQUIREMENTS_LIST 10     Array(Integer(0~255))
# 　　　:REG_QWORD                      11     Integer(0~18446744073709551615)
# 　　　:REG_QWORD_LITTLE_ENDIAN        11     Integer(0~18446744073709551615)
# 　　　:REG_NONE的值的資料型別：輸入為以上出現過的，輸出為Array(Integer(0~255))
# 　　　詳閱：https://msdn.microsoft.com/library/windows/desktop/ms724884.aspx
#------------------------------------------------------------------------------
# 　本腳本以創用CC 姓名標示-非商業性-禁止改作 4.0 國際 授權條款釋出。
#==============================================================================
 
#==============================================================================
# ■ 預先設定
#==============================================================================
module RMGTW
  # 預設參數（在未指定預設參數時，輸入或輸出此參數，必須是字串）
  DefaultValue = ""
  # 預設緩沖區大小（在未指定緩沖區大小時，使用這數值來當作緩沖區大小）
  DefaultnSize = 400
  # INI檔的位置
  INIPath = "./Game.ini"
  # INI檔使用的編法方式是否為Unicode(UTF-16LE)
  # 　只有VX Ace的INI檔用的了UTF-16LE當作編碼方式。
  # 　為true的風險請閱備註的註4。
  INIUseUni = false
  # 當功能失敗時時是否回報錯誤。
  Debug = true
  # 當回報錯誤時，是否彈出錯誤訊息，否則在主控台顯示。
  RaiseError = true
end
 
#==============================================================================
# ■ NativeMethods
#------------------------------------------------------------------------------
# 　這個模組用來定義原生方法。
# 沒有用到的都是之後新增功能時會用到的。
#==============================================================================
module NativeMethods
  #--------------------------------------------------------------------------
  # ● 處理視窗的API
  #--------------------------------------------------------------------------
  FindWindow    =
    Win32API.new('user32',    'FindWindow',  'PP', 'L')
  GetSystemMenu =
    Win32API.new('user32', 'GetSystemMenu',  'LL', 'L')
  RemoveMenu    =
    Win32API.new('user32',    'RemoveMenu', 'LLL', 'L')
  #--------------------------------------------------------------------------
  # ● 轉換編碼的API
  #--------------------------------------------------------------------------
  MultiByteToWideChar =
    Win32API.new('kernel32', 'MultiByteToWideChar',   'LLPLPL', 'L')
  WideCharToMultiByte =
    Win32API.new('kernel32', 'WideCharToMultiByte', 'LLPLPLPP', 'L')
  #--------------------------------------------------------------------------
  # ● 控制INI檔的API
  #--------------------------------------------------------------------------
  GetPrivateProfileStringA   =
    Win32API.new('kernel32',    'GetPrivateProfileStringA', 'PPPPLP', 'L')
  GetPrivateProfileStringW   =
    Win32API.new('kernel32',    'GetPrivateProfileStringW', 'PPPPLP', 'L')
  WritePrivateProfileStringA =
    Win32API.new('kernel32',  'WritePrivateProfileStringA',   'PPPP', 'L')
  WritePrivateProfileStringW =
    Win32API.new('kernel32',  'WritePrivateProfileStringW',   'PPPP', 'L')
  #--------------------------------------------------------------------------
  # ● 控制登錄檔的機碼的API
  #--------------------------------------------------------------------------
    RegOpenKeyEx   =
    Win32API.new('advapi32',   'RegOpenKeyEx',     'LPLLP', 'L')
  RegCreateKeyEx =
    Win32API.new('advapi32', 'RegCreateKeyEx', 'LPLPLLPPP', 'L')
  RegDeleteKeyEx =
    Win32API.new('advapi32', 'RegDeleteKeyEx',      'LPLL', 'L')
  RegCloseKey    =
    Win32API.new('advapi32',    'RegCloseKey',         'L', 'L')
  #--------------------------------------------------------------------------
  # ● 控制登錄檔的值項的API
  #--------------------------------------------------------------------------
  RegQueryValueEx =
    Win32API.new('advapi32', 'RegQueryValueEx', 'LPPPPP', 'L')
  RegSetValueEx   =
    Win32API.new('advapi32',   'RegSetValueEx', 'LPLLPL', 'L')
  RegDeleteValue  =
    Win32API.new('advapi32',  'RegDeleteValue',     'LP', 'L')
  #--------------------------------------------------------------------------
  # ● 其他API
  #--------------------------------------------------------------------------
  GetLocalTime =
    Win32API.new('kernel32', 'GetLocalTime', 'P', 'V')
  GetLastError =
    Win32API.new('kernel32', 'GetLastError', 'V', 'L')
end
 
#==============================================================================
# ■ String
#------------------------------------------------------------------------------
# 　這個類別定義了資料型別String。
#==============================================================================
class String
  #--------------------------------------------------------------------------
  # ● 防範NativeMethods
  #--------------------------------------------------------------------------
  include NativeMethods
  #--------------------------------------------------------------------------
  # ● 定義常用的編碼代碼
  #--------------------------------------------------------------------------
  CP = {
  :ACP      =>    0, :Shift_JIS =>   932, :GB2312 => 936, :BIG5 => 950,
  :UTF_16LE => 1200, :UTF_8     => 65001
  }
  #--------------------------------------------------------------------------
  # ● 定義轉換字串編碼的輸出
  #--------------------------------------------------------------------------
  def conv(from, to, avoid = true)
    str0 = _conv(from, to)
    str1 = _conv(from, to)
    str2 = _conv(from, to)
    while (str0 != str1 || str0 != str2) && avoid do
      str0 = _conv(from, to)
      str1 = _conv(from, to)
      str2 = _conv(from, to)
    end
    return str0
  end
  #--------------------------------------------------------------------------
  # ● 定義轉換字串編碼
  #--------------------------------------------------------------------------
  def _conv(from, to)
    from = from.is_a?(Symbol) ? CP[from] : from
    to   =   to.is_a?(Symbol) ? CP[to]   : to
    if from != CP[:UTF_16LE]
      length = MultiByteToWideChar.call(from, 0, self, -1, nil, 0)
      buffer = "\0".encode("UTF-16LE") * length
      MultiByteToWideChar.call(from, 0, self, -1, buffer, length)
      wide_str = buffer.chop
      return wide_str if to == CP[:UTF_16LE]
    end
    wide_str = self if wide_str.nil?
    encoding = to == CP[:UTF_8] ? "UTF-8" : "ASCII-8BIT"
    length = WideCharToMultiByte.call(to, 0, wide_str, -1, nil, 0, nil, nil)
    buffer = "\0".encode(encoding) * length
    WideCharToMultiByte.call(to, 0, wide_str, -1, buffer, length, nil, nil)
    multi_str = buffer.chop
    return multi_str
  end
  #--------------------------------------------------------------------------
  # ● 定義轉換字串從UTF-8至UTF-16LE
  #--------------------------------------------------------------------------
  def to_uni(usesys = true)
    return conv(:UTF_8, :UTF_16LE) unless usesys
    self.encode("UTF-16LE")
  end
  #--------------------------------------------------------------------------
  # ● 定義轉換字串從UTF-16LE至UTF-8
  #--------------------------------------------------------------------------
  def to_utf8(usesys = true)
    return conv(:UTF_16LE, :UTF_8) unless usesys
    self.encode("UTF-8")
  end
  #--------------------------------------------------------------------------
  # ● 定義轉換字串從UTF-8至系統編碼
  #--------------------------------------------------------------------------
  def to_ansi
    return conv(:UTF_8, :ACP)
  end
  #--------------------------------------------------------------------------
  # ● 設定權限
  #--------------------------------------------------------------------------
  private :_conv
end
 
#==============================================================================
# ■ INI
#------------------------------------------------------------------------------
# 　這個模組用來操作INI檔。
#==============================================================================
module INI
  #--------------------------------------------------------------------------
  # ● 防範NativeMethods
  #--------------------------------------------------------------------------
  include NativeMethods
  #--------------------------------------------------------------------------
  # ● 定義取得在INI檔中指定的值
  #--------------------------------------------------------------------------
  def self.get(lpAppName, lpKeyName,
    lpDefault = RMGTW::DefaultValue, nSize = RMGTW::DefaultnSize)
    if RMGTW::INIUseUni
      zero = "\0".encode("UTF-16LE")
      lpReturnedString = zero * nSize
      error = GetPrivateProfileStringW.call(
        lpAppName.to_uni, lpKeyName.to_uni,
        lpDefault.to_uni, lpReturnedString, nSize,
        RMGTW::INIPath.to_uni)
      Error.show("INI取得值", error) if error == 0 && RMGTW::Debug
      return lpReturnedString.delete(zero).to_utf8
    else
      zero = "\0".encode("ASCII-8BIT")
      lpReturnedString = zero * nSize
      error = GetPrivateProfileStringA.call(
        lpAppName.to_ansi, lpKeyName.to_ansi,
        lpDefault.to_ansi, lpReturnedString, nSize,
        RMGTW::INIPath.to_ansi)
      Error.show("INI取得值", error) if error == 0 && RMGTW::Debug
      return lpReturnedString.delete(zero).conv(:ACP, :UTF_8)
    end
  end
  #--------------------------------------------------------------------------
  # ● 定義設定在INI檔中指定的值
  #--------------------------------------------------------------------------
  def self.set(lpAppName, lpKeyName, lpString)
    if RMGTW::INIUseUni
      error = WritePrivateProfileStringW.call(
        lpAppName.to_uni, lpKeyName.to_uni,
        lpString.to_uni, RMGTW::INIPath.to_uni)
    else
      error = WritePrivateProfileStringA.call(
        lpAppName.to_ansi, lpKeyName.to_ansi,
        lpString.to_ansi, RMGTW::INIPath.to_ansi)
    end
    Error.show("INI設定值", error) if error == 0 && RMGTW::Debug
    return error
  end
end
 
#==============================================================================
# ■ Registry
#------------------------------------------------------------------------------
# 　這個類別用來操作登錄檔。
#==============================================================================
class Registry
  #--------------------------------------------------------------------------
  # ● 防範NativeMethods
  #--------------------------------------------------------------------------
  include NativeMethods
  #--------------------------------------------------------------------------
  # ● 物件初始化
  #--------------------------------------------------------------------------
  def initialize
    @hKey = nil
    @lpType = nil
    @lpcbData = nil
  end
  #--------------------------------------------------------------------------
  # ● 機碼的操作：開啟指定的機碼並取得其控制代碼
  #--------------------------------------------------------------------------
  def open(hKey, lpSubKey, dwOptions = :REG_OPTION_NON_VOLATILE)
    phkResult = [0].pack('L')
    hKey = hKey.is_a?(Symbol) ? H[hKey] : hKey
    dwOptions = dwOptions.is_a?(Symbol) ? H[dwOptions] : dwOptions
    error = RegOpenKeyEx.call(hKey, lpSubKey.to_ansi, dwOptions,
      H[:KEY_ALL_ACCESS] | H[:KEY_WOW64_32KEY], phkResult)
    @hKey = phkResult.unpack('L')[0]
    Error.show("登錄檔開啟機碼", error) if error != 0 && RMGTW::Debug
    return error
  end
  #--------------------------------------------------------------------------
  # ● 機碼的操作：建立新的機碼並取得其控制代碼
  #--------------------------------------------------------------------------
  def create(hKey, lpSubKey, dwOptions = :REG_OPTION_NON_VOLATILE)
    phkResult = [0].pack('L')
    lpdwDisposition = [0].pack('L')
    hKey = hKey.is_a?(Symbol) ? H[hKey] : hKey
    dwOptions = dwOptions.is_a?(Symbol) ? H[dwOptions] : dwOptions
    error = RegCreateKeyEx.call(hKey, lpSubKey.to_ansi, 0, nil, dwOptions,
      H[:KEY_ALL_ACCESS] | H[:KEY_WOW64_32KEY], nil, phkResult,
      lpdwDisposition)
    @hKey = phkResult.unpack('L')[0]
    lpdwDisposition = lpdwDisposition.unpack('L')[0]
    if error == 0
      if lpdwDisposition = H[:REG_CREATED_NEW_KEY]
        return :REG_CREATED_NEW_KEY.id2name
      elsif lpdwDisposition = H[:REG_OPENED_EXISTING_KEY]
        return :REG_OPENED_EXISTING_KEY.id2name
      end
    else
      Error.show("登錄檔新增機碼", error) if error != 0 && RMGTW::Debug
      return error
    end
  end
  #--------------------------------------------------------------------------
  # ● 機碼的操作：刪除指定的的機碼
  #--------------------------------------------------------------------------
  def remove(hKey, lpSubKey)
    hKey = hKey.is_a?(Symbol) ? H[hKey] : hKey
    error = RegDeleteKeyEx.call(hKey, lpSubKey.to_ansi,
      H[:KEY_WOW64_32KEY], 0)
    Error.show("登錄檔刪除機碼", error) if error != 0 && RMGTW::Debug
    return error
  end
  #--------------------------------------------------------------------------
  # ● 機碼的操作：關閉已開啟的機碼
  #--------------------------------------------------------------------------
  def close
    error = RegCloseKey.call(@hKey)
    @hKey = nil
    @lpType = nil
    @lpcbData = nil
    Error.show("登錄檔關閉機碼", error) if error != 0 && RMGTW::Debug
    return error
  end
  #--------------------------------------------------------------------------
  # ● 值項的操作：取得已指定的鍵中指定值項的種類和長度
  #--------------------------------------------------------------------------
  def query(lpValueName)
    lpType = [0].pack('L')
    lpcbData = [0].pack('L')
    error = RegQueryValueEx.call(@hKey, lpValueName.to_ansi, 0,
      lpType, 0, lpcbData)
    @lpType = lpType
    @lpcbData = lpcbData
    Error.show("登錄檔的機碼中取得值項", error) if error != 0 && RMGTW::Debug
  end
  #--------------------------------------------------------------------------
  # ● 值項的操作：從已指定的機碼中取得指定值項的值
  #--------------------------------------------------------------------------
  def get(lpValueName)
    query(lpValueName)
    lpData = "\0".encode("ASCII-8BIT") * @lpcbData.unpack('L')[0]
    error = RegQueryValueEx.call(@hKey, lpValueName.to_ansi,
      0, @lpType, lpData, @lpcbData)
    Error.show("登錄檔的機碼中取得值項的值", error) if error != 0 && RMGTW::Debug
    return nil if error != 0
    case @lpType.unpack('V')[0]
    when H[:REG_DWORD], H[:REG_DWORD_LITTLE_ENDIAN]
      return lpData.unpack('V')[0]
    when H[:REG_DWORD_BIG_ENDIAN]
      return lpData.unpack('N')[0]
    when H[:REG_QWORD], H[:REG_QWORD_LITTLE_ENDIAN]
      return lpData.unpack('Q')[0]
    when H[:REG_SZ], H[:REG_EXPAND_SZ], H[:REG_LINK]
      return lpData.chop.conv(:ACP, :UTF_8)
    when H[:REG_MULTI_SZ]
      return lpData.chop.split(%r{(\0)})
        .delete_if { |s| s == "\0" }
        .collect { |s| s.conv(:ACP, :UTF_8) }
    else
      return lpData.unpack('C*')
    end
  end
  #--------------------------------------------------------------------------
  # ● 值項的操作：從已指定的機碼中設定指定值項的值
  #--------------------------------------------------------------------------
  def set(lpValueName, lpData, dwType = 0)
    if dwType == 0
      query(lpValueName) if @lpType == nil
      dwType = @lpType.unpack('V')[0]
    else
      dwType = dwType.is_a?(Symbol) ? H[dwType] : dwType
    end
    if dwType == H[:REG_NONE]
      if lpData.is_a?(Integer)
        if lpData >= 0 && lpData <= 0xFFFFFFFF
          dwType = H[:REG_DWORD]
        elsif lpData >= 0 && lpData <= 0xFFFFFFFFFFFFFFFF
          dwType = H[:REG_QWORD]
        elsif lpData < 0 || lpData > 0xFFFFFFFFFFFFFFFF
          raise("lpData Value Error")
        end
      elsif lpData.is_a?(String)
        dwType = H[:REG_SZ]
      elsif lpData.is_a?(Array)
        if lpData[0].is_a?(Integer)
          dwType = H[:REG_BINARY]
        elsif lpData[0].is_a?(String)
          dwType = H[:REG_MULTI_SZ]
        else
          raise("lpData Type Error")
        end
      elsif lpData != nil
        raise("lpData Type Error")
      end
      dwType_none = true
    end
    case dwType
    when H[:REG_DWORD], H[:REG_DWORD_LITTLE_ENDIAN], H[:REG_DWORD_BIG_ENDIAN]
      raise("lpData Type Error") unless lpData.is_a?(Integer)
      if lpData < 0 || lpData > 0xFFFFFFFF
        raise("lpData Value Error")
      end
      _lpData = [
        lpData / 0x1 % 0x100,
        lpData / 0x100 % 0x100,
        lpData / 0x10000 % 0x100,
        lpData / 0x1000000 % 0x100
      ]
      _lpData.reverse if dwType == H[:REG_DWORD_LITTLE_ENDIAN]
      lpData = _lpData.pack("CCCC").force_encoding("ASCII-8BIT")
    when H[:REG_QWORD], H[:REG_QWORD_LITTLE_ENDIAN]
      raise("lpData Type Error") unless lpData.is_a?(Integer)
      if lpData < 0 || lpData > 0xFFFFFFFFFFFFFFFF
        raise("lpData Value Error")
      end
      _lpData = [
        lpData / 0x1 % 0x100,
        lpData / 0x100 % 0x100,
        lpData / 0x10000 % 0x100,
        lpData / 0x1000000 % 0x100,
        lpData / 0x100000000 % 0x100,
        lpData / 0x10000000000 % 0x100,
        lpData / 0x1000000000000 % 0x100,
        lpData / 0x100000000000000 % 0x100
      ]
      lpData = _lpData.pack("CCCCCCCC").force_encoding("ASCII-8BIT")
    when H[:REG_SZ], H[:REG_EXPAND_SZ], H[:REG_LINK]
      raise("lpData Type Error") unless lpData.is_a?(String)
      lpData = lpData.conv(:UTF_8, :ACP)
      lpData += "\0".encode("ASCII-8BIT")
    when H[:REG_MULTI_SZ]
      raise("lpData Type Error") unless lpData.is_a?(Array)
      _lpData = ""
      for i in 0..(lpData.length - 1)
        raise("lpData Type Error") unless lpData[i].is_a?(String)
        _lpData += lpData[i].conv(:UTF_8, :ACP)
        _lpData += "\0".encode("ASCII-8BIT")
      end
      lpData = _lpData + "\0".encode("ASCII-8BIT")
    else
      if lpData != nil
        for i in 0..(lpData.length - 1)
          raise("lpData Type Error") unless lpData[i].is_a?(Integer)
          raise("lpData Value Error") if lpData[i] < 0 || lpData[i] > 0xFF
        end
        lpData = lpData.pack('C*').force_encoding("ASCII-8BIT")
      end
    end
    cbData = lpData.nil? ? 0 : lpData.size
    dwType = H[:REG_NONE] if dwType_none
    error = RegSetValueEx.call(@hKey, lpValueName.to_ansi, 0,
      dwType, lpData, cbData)
    Error.show("登錄檔的機碼中設定值項", error) if error != 0 && RMGTW::Debug
    return error
  end
  #--------------------------------------------------------------------------
  # ● 值項的操作：從已指定的機碼中刪除指定的值項
  #--------------------------------------------------------------------------
  def delete(lpValueName)
    error = RegDeleteValue.call(@hKey, lpValueName)
    Error.show("登錄檔的機碼中刪除值項", error) if error != 0 && RMGTW::Debug
    return error
  end
  #--------------------------------------------------------------------------
  # ● 設定權限
  #--------------------------------------------------------------------------
  private :query
  #--------------------------------------------------------------------------
  # ● 定義常數
  #--------------------------------------------------------------------------
  H = {
    :HKEY_CLASSES_ROOT        => 0x80000000,
    :HKEY_CURRENT_USER        => 0x80000001,
    :HKEY_LOCAL_MACHINE       => 0x80000002,
    :HKEY_USERS               => 0x80000003,
    :HKEY_PERFORMANCE_DATA    => 0x80000004,
    :HKEY_CURRENT_CONFIG      => 0x80000005,
   
    :REG_NONE                       => 0,
    :REG_SZ                         => 1,
    :REG_EXPAND_SZ                  => 2,
    :REG_BINARY                     => 3,
    :REG_DWORD                      => 4,
    :REG_DWORD_LITTLE_ENDIAN        => 4,
    :REG_DWORD_BIG_ENDIAN           => 5,
    :REG_LINK                       => 6,
    :REG_MULTI_SZ                   => 7,
    :REG_RESOURCE_LIST              => 8,
    :REG_FULL_RESOURCE_DESCRIPTOR   => 9,
    :REG_RESOURCE_REQUIREMENTS_LIST => 10,
    :REG_QWORD                      => 11,
    :REG_QWORD_LITTLE_ENDIAN        => 11,
   
    :KEY_QUERY_VALUE        => 0x0001,
    :KEY_SET_VALUE          => 0x0002,
    :KEY_CREATE_SUB_KEY     => 0x0004,
    :KEY_ENUMERATE_SUB_KEYS => 0x0008,
    :KEY_NOTIFY             => 0x0010,
    :KEY_CREATE_LINK        => 0x0020,
    :KEY_READ               => 0x20019,
    :KEY_WRITE              => 0x20006,
    :KEY_EXECUTE            => 0x20019,
    :KEY_ALL_ACCESS         => 0xF003F,
    :KEY_WOW64_32KEY        => 0x0200,
    :KEY_WOW64_64KEY        => 0x0100,
   
    :REG_OPTION_NON_VOLATILE   => 0x0000,
    :REG_OPTION_VOLATILE       => 0x0001,
    :REG_OPTION_CREATE_LINK    => 0x0002,
    :REG_OPTION_BACKUP_RESTORE => 0x0004,
    :REG_OPTION_OPEN_LINK      => 0x0008,
   
    :REG_CREATED_NEW_KEY     => 1,
    :REG_OPENED_EXISTING_KEY => 2
  }
end
 
#==============================================================================
# ■ Error
#------------------------------------------------------------------------------
# 　這個模組用來顯示錯誤訊息。
#==============================================================================
module Error
  #--------------------------------------------------------------------------
  # ● 防範NativeMethods
  #--------------------------------------------------------------------------
  include NativeMethods
  #--------------------------------------------------------------------------
  # ● 定義顯示錯誤訊息
  #--------------------------------------------------------------------------
  def self.show(errstr, errcode)
    url = "https://msdn.microsoft.com/library/windows/desktop/ms681381.aspx"
    errcode = GetLastError.call() if errcode == 0
    msg = sprintf("在%s發生錯誤，錯誤代碼：%i，請至下列網址查詢",
      errstr, errcode)
    if RMGTW::RaiseError
      raise(sprintf("%s\n%s", msg, url))
    else
      p(msg); p(url)
    end
  end
end
=end
