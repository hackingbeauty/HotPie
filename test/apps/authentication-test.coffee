assert  = require "assert"
request = require "request"
app     = require "../../server"

describe "Authentication", ->
  
  describe "GET /login", ->  
    body = null
    
    before (done) ->
      options = 
        uri: "http://localhost:#{app.settings.port}/login"
      request options, (err, response, _body) ->
        body = _body
        done()
              
    it "has title", ->
      assert.hasTag body, "//head/title", "Hot Pie - Login"
      
  describe "POST /sessions", ->
    
    describe "incorrect credentials", ->
      [body, response] = [null,null]
      before (done) ->
        options = 
          uri: "http://localhost:#{app.settings.port}/sessions"
          form:
            user: "incorrect"
            password: "incorect"
          followAllRedirects: true
        request.post options, (err, _response, _body) ->
          [body, response] = [_body, _response]
          done()
          
      it "shows error flash message", ->
        errorText = "Those credentials were incorrect.  Try again."
        assert.hasTag body, "//p[@class='flash error']", errorText
        
        
    describe "correct credentials", ->
      [body, response] = [null, null]
      before (done) ->
        options =
          uri: "http://localhost:#{app.settings.port}/sessions"
          form:
            user: "piechef"
            password: "12345"
          followAllRedirects: true
        request.post options, (err, _response, _body) ->
          [body, response] = [_body, _response]
          done()
    
      it "shows successful flash message", ->
        successMsg = "You are logged in as piechef"
        # console.log body
        # console.log "====="
        # console.log response
        assert.hasTag body, "//p[@class='flash info']", successMsg

    describe "DELETE /sessions (a.k.a Logout)", ->
      [body, response] = [null, null]
      before (done) ->
        options =
          uri: "http://localhost:#{app.settings.port}/sessions"
          followAllRedirects: true
        request.del options, (err, _response, _body) ->
          [body, response] = [_body, _response]
          done()
          
      it "shows flash message after successfully logging out", ->
        logoutMsg = "You've been logged out."
        assert.hasTag body, "//p[@class='flash info']", logoutMsg
      