module JobBoardApi
  # a job posting from authentic.com
  class AuthenticJob < JobPosting
    KEYS = { title: :title,
             date_posted: :post_date,
             excerpt: :description,
             source: :source,
             job_url: :apply_url }
    def init_address_attributes
      loc = job_json[:company][:location]
      return unless loc
      @city_state       = loc[:city]
      @country          = loc[:country]
      @city             = city_state.split(',')[0]
      @state            = loc[:state]
      @latitude         = loc[:lat]
      @longitude        = loc[:lng]
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

    def company_name
      job_json[:company][:name]
    end

    def source
      'Authentic'
    end
  end
end
