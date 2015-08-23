todayStr = ->
  today = new Date
  dd = today.getDate()
  mm = today.getMonth() + 1
  yyyy = today.getFullYear()
  dd = '0' + dd if dd < 10
  mm = '0' + mm if mm < 10  
  today = yyyy + '-' + mm + '-' + dd

Date::timeNow = ->
    (if @getHours() < 10 then '0' else '') + @getHours() + '' + (if @getMinutes() < 10 then '0' else '') + @getMinutes() + '' + (if @getSeconds() < 10 then '0' else '') + @getSeconds()

exports.getDateTime = ->
  currentdate = new Date
  datetime = todayStr() + "_"+ currentdate.timeNow()

exports.parseCookies = (request) ->
  list = {}
  rc = request.headers.cookie
  rc and rc.split(';').forEach((cookie) ->
    parts = cookie.split('=')
    list[parts.shift().trim()] = decodeURI(parts.join('='))
    return
  )
  list