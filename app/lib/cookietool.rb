class CookieTool
  def self.gethash(jar)
    rettext = ''
    jar.each do |cookie|
      rettext += cookie.to_s + '; '
    end
    return rettext
  end
end