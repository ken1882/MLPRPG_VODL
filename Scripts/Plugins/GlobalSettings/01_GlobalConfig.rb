#===============================================================================
# * Global variables
#===============================================================================

# Define supported languages map, language vocab files should be placed under 
# 'Vocab/#{language_hey}/' folder.
$supported_languages = {
  :en_us => "English(US)",
  :zh_tw => "繁體中文",
}

$default_encoding = 'utf-8'

# Errno flag shared between threads
$error_activated = false 