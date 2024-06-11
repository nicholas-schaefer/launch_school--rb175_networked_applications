require_relative 'advice'

class HelloWorld
  def call(env)
    case env['REQUEST_PATH']
    when '/'
    html = <<~HTML
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <title>home</title>
        <meta charset="utf-8">
      </head>
      <body>
        <h2>Hello World!</h2>
      </body>
    </html>
    HTML
    [
      '200',
      {'Content-Type' => 'text/html'},
      [html]
    ]
    when '/advice'
    piece_of_advice = Advice.new.generate    # random piece of advice
    html = <<~HTML
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <title>Advice</title>
        <meta charset="utf-8">
      </head>
      <body>
        <em><strong>#{piece_of_advice}</strong></em>
      </body>
    </html>
    HTML
    [
      '200',
      {'Content-Type' => 'text/html'},
      [html]
    ]
    else
    html = <<~HTML
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <title>404</title>
        <meta charset="utf-8">
      </head>
      <body>
        <h4>404 Not Found</h4>
      </body>
    </html>
    HTML
    [
      '404',
      {'Content-Type' => 'text/html', 'Content-Length' => '156'},
      [html]
    ]
    end
  end
end
