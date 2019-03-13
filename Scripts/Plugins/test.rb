def change_encoding(target_encoding, *args)
  conv_proc = Proc.new{ |arg|
    if arg.is_a?(Regexp) && arg.encoding != target_encoding
      rear = arg.inspect.rindex('/')
      Regexp.new(arg.inspect[1...rear].force_encoding(target_encoding), Regexp::FIXEDENCODING | arg.options)
    elsif arg.is_a?(String) && arg.encoding != target_encoding
      arg.force_encoding(target_encoding)
    else
      arg
    end
  }
  if args.size == 0
    return nil
  elsif args.size == 1
    return conv_proc.call(args[0])
  else
    re_args = []
    args.each{|arg| re_args << conv_proc.call(arg)}
    return re_args
  end
end

def show(*args)
  args = change_encoding("ASCII-8BIT", *args)
  args.each{|i| p i.encoding}
end

show("123","456")
str = "789"
str = change_encoding("ASCII-8BIT", str)
p str.encoding
