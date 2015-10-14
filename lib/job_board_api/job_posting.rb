module JobBoardApi
  # base class for job posting on a job board
  class JobPosting
    attr_accessor :latitude, :longitude
    attr_reader :job_json, :company, :city_state

    def initialize(json)
      @job_json = json
      init_company
      init_address_attributes
    end

    def title
      job_json[keys[:title]]
    end

    def date_posted
      Date.parse job_json[keys[:date_posted]]
    end

    def excerpt
      job_json[keys[:excerpt]]
    end

    def job_url
      job_json[keys[:job_url]]
    end

    def source
      job_json[keys[:source]]
    end

    def company_name
      job_json[keys[:company]]
    end

    def to_json
      { title:       title,
        company:     company,
        location:    city_state,
        source:      source,
        date_posted: date_posted,
        excerpt:     excerpt,
        job_url:     job_url,
        latitude:    latitude,
        longitude:   longitude }
    end

    private

    def init_company
      return unless company_name

      name = company_name.encode Encoding.find('ASCII'), encoding_options
      @company = name.gsub('&amp;', '&')
    end

    def encoding_options
      {
        invalid:          :replace,  # Replace invalid byte sequences
        undef:            :replace,  # Replace anything not defined in ASCII
        replace:          '',        # Use a blank for those replacements
        universal_newline: true      # Always break lines with \n
      }
    end

    def keys
      fail "#{self.class.name} must implement keys"
    end
  end
end
