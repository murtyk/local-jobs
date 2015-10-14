module JobBoardApi
  require 'httparty'
  # base class for jobs boards
  class JobBoard
    ANY_KEYWORDS_SEARCH = 1
    ALL_KEYWORDS_SEARCH = 2

    attr_reader :ip,
                :search_type, :keywords, :zip, :city, :state,
                :location, :distance, :days,
                :error, :count, :total_count, :jobs,
                :current_page, :page_size, :url

    def initialize(ip, browser = 'Mozilla/%2F4.0%28Firefox%29')
      @ip        = ip
      @browser   = browser
      post_initialize
    end

    def search_jobs(args)
      init_search_parameters(args)

      @url = ''
      @jobs = []

      search
    end

    def total_pages
      1 + (total_count - 1) / page_size
    end

    class << self
      def all(ip, browser = nil)
        sub_classes.map { |c| c.new(ip, browser) }
      end

      def new_board(board_name, ip, browser = nil)
        class_name = 'JobBoardApi::' + board_name
        return nil unless valid_job_board(class_name)
        Object.const_get(class_name).new(ip, browser)
      end

      def valid_job_board(class_name)
        sub_classes.map(&:to_s).include? class_name
      end

      def sub_classes
        JobBoardApi.constants
          .map { |class_symbol| JobBoardApi.const_get(class_symbol) }
          .select { |c| c.superclass == self }
      end
    end

    def to_label
      board_name.split('::')[1]
    end

    private

    # subclass can implement this if needed
    def post_initialize
    end

    def init_search_parameters(args)
      @zip          = args[:zip]
      @city         = args[:city]
      @state        = args[:state]
      @page_size    = args[:page_size] || 25
      @distance     = args[:distance] || 10
      @days         = args[:days] || 0
      @current_page = args[:page] || 1

      build_keywords(args)
      build_location
    end

    def search
      build_url
      Rails.logger.info(url) if ENV['LOG_SEARCH_URL']
      response = HTTParty.get(url)
      parse_results response.parsed_response
    rescue StandardError => e
      @error = "#{board_name} Error - " + e.to_s
      @jobs = []
      @count = 0
      @total_count = 0
    end

    def build_keywords(args)
      search_any = args[:search_type] == ANY_KEYWORDS_SEARCH
      kw         = args[:keywords]
      @keywords = kw.join('+OR+') if search_any
      @keywords = kw.join('+') unless search_any
    end

    def build_location
      loc = zip || "#{city},#{state}"
      loc = loc.split(',').map { |s| s.split.join(' ') }.join(',')
      @location = loc.sub(' ', '+')
    end

    def parse_jobs(a_jobs)
      # works for both Hash (one job) and Array inputs
      @jobs = [a_jobs].flatten.map { |j| new_job(j) }
      @count = @jobs.count
    end

    def board_name
      self.class.name
    end

    def symbolize(obj)
      if obj.is_a? Array
        return obj.each_with_object([]) { |v, memo| memo << symbolize(v) }
      end

      return obj unless obj.is_a? Hash

      obj.each_with_object({}) { |(k, v), memo| memo[k.to_sym] =  symbolize(v) }
    end
  end
end
