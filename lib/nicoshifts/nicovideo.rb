class Nicovideo
  def initialize(mail, pass)
    @agent = Mechanize.new
    @agent.max_history = 0
    login(mail, pass)
  end

  MAX_PAGES = 10
  ONE_WEEK = 7*24*60*60
  def live_archives(co_number)
    co_name = nil
    ret = []

    1.upto(MAX_PAGES) do |i|
      page = @agent.get("http://com.nicovideo.jp/live_archives/co#{co_number}?page=#{i}&bias=0")
      doc = page.root
      co_name ||= doc.at("a.chcom_prof_title").text
      table = doc.at("table.live_history")
      break if table.nil?

      lives = parse_live_history_table(co_number, co_name, table)
      ret.concat lives
      break if (Time.now - lives.last.started_at) > ONE_WEEK
    end 

    ret
  rescue Mechanize::ResponseCodeError
    nil
  end

  private

  def oldest(doc)
    Time.parse((doc/"td.date").to_a.last.text.lines.to_a[1])
  end

  def login(mail, pass)
    result = @agent.post('https://secure.nicovideo.jp/secure/login?site=niconico', 
                'mail' => mail, 'password' => pass)
    raise "Login failed" if not authenticated?(result)
  end

  def authenticated?(page)
    page.header['x-niconico-authflag'] != '0'
  end

  def parse_live_history_table(co_number, co_name, table)
    (table/:tr).map{|tr|
      tds = (tr/:td)
      if tds.empty?
        nil
      else
        td_started_at, td_talker, td_title, td_desc = *tds

        date = td_started_at.text[%r{\d+/\d+/\d+}]
        time = td_started_at.text[%r{\d+:\d+}]
        started_at = Time.parse("#{date} #{time}")

        talker = td_talker.text.strip
        title = td_title.text.strip
        url = (td_title % :a)[:href]
        desc = td_desc.text.strip

        is_recorded = !!(td_title.to_html =~ /btn_timeshift_ss.png/)

        NicoShifts::Live.new(co_number, co_name, url, started_at, talker,
                             title, desc, is_recorded)
      end
    }.compact
  end
end
