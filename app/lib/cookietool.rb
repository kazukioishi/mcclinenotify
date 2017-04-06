module CookieTool
  def self.gethash(jar)
    rettext = ''
    jar.each do |cookie|
      rettext += cookie.to_s + '; '
    end
    rettext.chop!
    return rettext
  end
end