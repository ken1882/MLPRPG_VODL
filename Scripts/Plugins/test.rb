str = "(eval):18001 :  stack level too deep  (SystemStackError)"
p str =~ /:(\d+)(:| :)/
p $1