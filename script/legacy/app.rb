class App < Sinatra::Base
  set :app_file, __FILE__
  set :public, 'public'
  set :static, true
  
  get '/' do
    redirect '/index.html'
  end
  
end