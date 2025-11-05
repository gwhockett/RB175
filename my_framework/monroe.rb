class Monroe
  def response(status, headers, body = '')
    body = yield if block_given?
    [status, headers, [body]]
  end

  def erb(filename, local = {})
    b = binding
    message = local[:message]
    template = File.read("views/#{filename}.erb")
    ERB.new(template).result(b)
  end
end