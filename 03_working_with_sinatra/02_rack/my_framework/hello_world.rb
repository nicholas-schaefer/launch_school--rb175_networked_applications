require_relative 'advice'

class HelloWorld
  def call(env)
    case env['REQUEST_PATH']
    when '/'
      ['200', {"Content-Type" => "text/html"}, [erb(:index)]]
    when '/advice'
      piece_of_advice = Advice.new.generate
      [
        '200',
        {"Content-Type" => 'text/html'},
        [erb(:advice, message: piece_of_advice)]
        # ["<html><body><b><em>#{piece_of_advice}</em></b></body></html>"]
      ]
    else
      [
        '404',
        {"Content-Type" => 'text/html', "Content-Length" => '48'},
        ["<html><body><h4>404 Not Found</h4></body></html>"]
      ]
    end
  end
  private
  # def erb(filename)
  #   content = File.read("views/#{filename}.erb")
  #   ERB.new(content).result
  # end

  def erb(filename, local = {})
    b = binding
    message = local[:message]
    content = File.read("views/#{filename}.erb")
    ERB.new(content).result(b)
  end
end
