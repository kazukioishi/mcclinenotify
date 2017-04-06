module LINENotify
  def self.send_notify(token, message)
    conn = Faraday.new do |faraday|
      faraday.request :url_encoded # form-encode POST params
      faraday.response :logger # log requests to STDOUT
      faraday.adapter Faraday.default_adapter # make requests with Net::HTTP
    end
    post = conn.post('https://notify-api.line.me/api/notify',
                     { message: message },
                     { Authorization: "Bearer #{token}" })
    post.success?
  end
end
