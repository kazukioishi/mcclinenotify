# setup mechanize
agent = Mechanize.new
# login to circleapp
agent.user_agent = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.60 Safari/537.36'
lpageform = agent.get('https://circleapp.jp/top').forms[0]
lpageform.email = ENV['circleapp_mail']
lpageform.password = ENV['circleapp_password']
agent.submit(lpageform)
cookie = agent.cookie_jar.cookies('https://circleapp.jp/top')
Rails.logger.debug CookieTool.gethash(cookie)
# get json
conn = Faraday.new do |faraday|
  faraday.request :url_encoded # form-encode POST params
  faraday.response :logger # log requests to STDOUT
  faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
end
res = conn.post('https://circleapp.jp/mailinglist/listJSON/2738/p/0',
                JSON.generate({ mode: '0', keyword: '' }),
                { 'Content-Type': 'application/json; charset=UTF-8',
                  'User-Agent': agent.user_agent,
                  'Cookie': CookieTool.gethash(cookie) })
mljson = JSON.parse(res.body, { :symbolize_names => true })
Rails.logger.debug mljson
mljson.each do |ml|
  if Topic.find_by({ recipient_id: ml[:recipientId] }).nil?
    # if there is no recipient in DB, insert it!
    topic = Topic.new
    topic.attributes = {
      creation_date: DateTime.parse(ml[:createDateText]),
      entry_id: ml[:entry][:entryId],
      recipient_id: ml[:recipientId],
      recipients: ml[:entry][:recipients],
      subject: ml[:entry][:subject],
      content: ml[:entry][:content],
      first_name: ml[:entry][:createUser][:firstName],
      last_name: ml[:entry][:createUser][:lastName],
      deadline_text: ml[:deadlineText],
      sender_grade: ml[:entry][:createUser][:educationStateId],
      send_ok: ENV['first_time'] == 'TRUE' ? true : false
    }
    topic.save
  end
end
# find not sent item
Topic.where({ send_ok: false }).order(creation_date: :asc).each do |item|
  Rails.logger.debug item.subject
  # send to LINE ﾖｰｿﾛｰ(*> ᴗ •*)ゞ
  ENV['line_token'].split(':').each do |token|
    if LINENotify.send_notify(token,
                              "#{item.deadline_text ? '(' + item.deadline_text + ')' : ''}" \
                              "#{item.subject}\n" \
                              "#{item.last_name + item.first_name}より#{item.recipients}宛\n" \
                              "https://circleapp.jp/mailinglist/detail/#{item.entry_id}")
      item.send_ok = true
      item.save
    end
  end
end