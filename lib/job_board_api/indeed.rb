module JobBoardApi
  # wrapper for indeed api
  class Indeed < JobBoard
    Q_V         = '&v=2'
    Q_FORMAT    = '&format=json'

    INDEED_SITE = 'http://api.indeed.com/ads/apisearch?publisher='

    attr_reader :publisher, :browser

    def post_initialize
      @browser   = browser || 'Mozilla/%2F4.0%28Firefox%29'
    end

    def attribution_template
      'indeed'
    end

    def java_script
    end

    private

    def build_url
      @url = INDEED_SITE + publisher + Q_V + Q_FORMAT + q_query +
             q_start + q_limit + q_fromage + q_user_info
    end

    def q_query
      "&q=#{keywords}&l=#{location}&radius=#{distance}"
    end

    def q_start
      '&start=' + ((current_page - 1) * page_size).to_s
    end

    def q_limit
      '&limit=' + page_size.to_s
    end

    def q_fromage
      return '' if days == 0
      '&fromage=' + days.to_s
    end

    def q_user_info
      "&userip=#{ip}&useragent=#{browser}"
    end

    def parse_results(pr)
      s_pr =  symbolize JSON.parse(pr)
      parse_header(s_pr)
      parse_jobs(s_pr[:results])
    end

    def parse_header(json)
      @total_count = json[:totalResults]
    end

    def new_job(j)
      IndeedJob.new(j)
    end

    def publisher
      ENV['PUBLISHER']
    end
  end
end
