require "socket"

server = TCPServer.new("localhost", 3003)

def html_paragraphing(string)
  "<p>#{string}</p>"
end
loop do
  client = server.accept

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/
  puts request_line

  http_method, path_query, http_version = request_line.split(' ')

  dice = path_query.split('?')[-1].split('&').map do |params|
    params.split('=')
  end.to_h

  sides = dice["sides"]
  rolls = dice["rolls"].to_i
  rolled_dice = []
  rolls.times { rolled_dice << rand(sides.to_i) + 1 }
  rolled_dice = rolled_dice.map { |roll| html_paragraphing(roll)}.join
  client.puts "HTTP/1.1 200 OK\r\n"\
              "Content-Type: text/html\r\n"\
              "\r\n"\
              "<html>"\
              "<body>"\
              "<pre>"\
              "<h2><p>#{http_method}</p></h2>"\
              "<h2><p>#{path_query}</p></h2>"\
              "<h2><p>#{http_version}</p></h2>"\
              "</pre>"\
              "<h1>Roll The Dice Emmett!</h1>"\
              "<h1>#{rolled_dice}</h1>"\
              "</body>"\
              "</html>"
  client.close
end
