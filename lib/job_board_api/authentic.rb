module JobBoardApi
  # wrapper for authentic api
  class Authentic < JobBoard
    SITE = 'https://authenticjobs.com/api/?method=aj.jobs.search&format=json&api_key='

    def attribution_template
      'authentic'
    end

    def java_script
    end

    private

    def build_keywords(args)
      kw         = args[:keywords]
      @keywords = kw.join(',')
    end

    def build_url
      @url = SITE + api_key + query + q_page + q_perpage
    end

    def query
      "&keywords=#{keywords}&location=#{location}"
    end

    def q_page
      '&page=' + ((current_page - 1) * page_size).to_s
    end

    def q_perpage
      '&perpage=' + page_size.to_s
    end

    def parse_results(pr)
      s_pr =  symbolize JSON.parse(pr)
      parse_header(s_pr)
      parse_jobs(s_pr[:listings][:listing])
    end

    def parse_header(json)
      @total_count = json[:listings][:total]
    end

    def new_job(j)
      AuthenticJob.new(j)
    end

    def api_key
      ENV['AUTHENTIC_KEY']
    end
  end
end
