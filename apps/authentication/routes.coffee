routes = (app) ->

  app.get '/login', (req,res) ->
    res.render "#{__dirname}/views/login",
      title: 'Hot Pie - Login'
      stylesheet: 'login'
    
module.exports = routes