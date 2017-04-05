# setup mechanize
agent = Mechanize.new
# login to circleapp
agent.user_agent = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.60 Safari/537.36'
lpageform = agent.get('https://circleapp.jp/top').forms[0]
lpageform.email = ENV['circleapp_mail']
lpageform.password = ENV['circleapp_password']
agent.submit(lpageform)
cookie = agent.cookie_jar.cookies('https://circleapp.jp/top')
p CookieTool::gethash(cookie)
# get json
conn = Faraday.new do |faraday|
  faraday.request  :url_encoded             # form-encode POST params
  faraday.response :logger                  # log requests to STDOUT
  faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
end
res = conn.post('https://circleapp.jp/mailinglist/listJSON/2738/p/0',
                   JSON.generate({
                       mode: '0',
                       keyword: ''
                   }), {
                       'Content-Type': 'application/json; charset=UTF-8',
                       'User-Agent': agent.user_agent,
                       'Cookie': CookieTool::gethash(cookie)
                   }
)
mljson = JSON.load(res.body)
