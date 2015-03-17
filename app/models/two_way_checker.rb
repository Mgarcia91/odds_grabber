class TwoWayChecker

  attr_accessor :matches

  def initialize url
    @matches = []
    @url = url
  end

  def check!

    c = HTTPClient.new
    c.get @url

    c.cookie_manager.cookies.find{|c| c.name == "odds_type"}.value = "decimal"
    response = c.get @url

    html = Nokogiri::HTML(response.body)

    html.css('tr.match-on').each do |match|

      @matches << {
        :first_competitor => match.css('.fixtures-bet-name').first.text,
        :second_competitor => match.css('.fixtures-bet-name').last.text,
        :first_odds => first_odds = match.css('.odds').first.text.gsub(/\(|\)|\s/, "").to_f,
        :second_odds => second_odds = match.css('.odds').last.text.gsub(/\(|\)|\s/, "").to_f,
        :in_play => match.css('.in-play').any?,
        :probability => 1.0/((1.0/first_odds)+(1.0/second_odds))
      }

    end

  end

end
