module JobBoardApi
  # a job posting from indeed.com
  class IndeedJob < JobPosting
    KEYS = { title: :jobtitle, date_posted: :date, excerpt: :snippet,
             company: :company, source: :source, job_url: :url }
    def init_address_attributes
      @city             = job_json[:city]
      @state            = job_json[:state]
      @country          = job_json[:country]
      @city_state       = job_json[:location] || job_json[:formattedLocation]
      @location         = job_json[:formattedLocation]
    end

    def job_key
      job_json[:jobkey]
    end

    def sponsored?
      job_json[:sponsored]
    end

    def keys
      KEYS
    end
  end
end
