require_relative 'advice'
require_relative 'monroe'

class App < Monroe
  def call(env)
    case env['REQUEST_PATH']
    when '/'
      status = 200
      headers = {"content-type" => 'text/html'}
      response(status, headers) { erb(:index) }
    when '/advice'
      piece_of_advice = Advice.new.generate
      status = 200
      headers = {"content-type" => 'text/html'}
      response(status, headers) { erb(:advice, message: piece_of_advice) }
    else
      status = 404
      headers = {"content-type" => 'text/html'}
      response(status, headers) { erb(:not_found) }
    end
  end
end