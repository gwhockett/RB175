require "socket"

server = TCPServer.new("localhost", 3003)

def hashed_parameters(request_line)
  if parsed(request_line)[1].match?(/[=]/)
    parsed(request_line)[1].split('?')[-1].split('&').map do |params|
      params.split('=')
    end.to_h
  else
    {'number' => '0'}
  end
end

def parsed(request_line)
  http_method, path_query, http_version = request_line.split(' ')
  [http_method, path_query, http_version.split('/').last]
end

def html_paragraphing(string)
  "<p>#{string}</p>"
end

loop do
  client = server.accept

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/
  puts request_line

  number = hashed_parameters(request_line).values[0].to_i

  client.puts "HTTP/1.1 200 OK\r\n"\
              "Content-Type: text/html\r\n"\
              "\r\n"\
              "<html>"\
              "<body>"\
              "<pre>"\
              "<h2><p>http method: #{parsed(request_line)[0]}</p></h2>"\
              "<h2><p>URL path and parameters: #{parsed(request_line)[1]}</p></h2>"\
              "<h2><p>http version: #{parsed(request_line)[2]}</p></h2>"\
              "</pre>"\
              "<h1>Counter</h1>"\
              "<h1>The current number is: #{number}</h1>"\
              "<p><a href='?number=#{number + 1}'>Add One</a></p>"\
              "<p><a href='?number=#{number - 1}'>Subtract One</a></P>"\
              "</body>"\
              "</html>"
  client.close
end
