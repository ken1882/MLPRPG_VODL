#===============================================================================
# * Global variables
#===============================================================================

# Define supported languages map, language vocab files should be placed under 
# 'Vocab/#{language_hey}/' folder.
$supported_languages = {
  :en_us => "English(US)",
  :zh_tw => "繁體中文",
}

$rgss_encoding    = "ASCII-8BIT"  # RGSS default encoding
$default_encoding = 'UTF-8'       # User defined default encoding

# Errno flag shared between threads
$error_activated = false 