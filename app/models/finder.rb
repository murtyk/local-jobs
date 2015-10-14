class Finder
  attr_reader :job_boards, :keywords, :a_keywords, :location,
              :current_page, :total_pages
  def initialize(ip, browser)
    @job_boards = JobBoardApi::JobBoard.all(ip, browser)
  end

  def search(params)
    init_search_params(params)
    return unless valid_params
    job_boards.each { |jb| jb.search_jobs(search_params) }
  end

  def total_pages
    job_boards.map(&:total_pages).max.to_i
  end

  def first_page?
    current_page == 1
  end

  def last_page?
    current_page == total_pages
  end

  def geocode_jobs
    job_boards.each do |jb|
      next unless jb.jobs
      jb.jobs.each do |job|
        next if job.latitude # already geocoded
        loc = GeoService.coordinates job.city_state
        job.latitude = loc[0]
        job.longitude = loc[1]
      end
    end
  end

  def markers
    geocode_jobs
    job_boards.map do |jb|
      Gmaps4rails.build_markers(jb.jobs) do |job, marker|
        marker.lat job.latitude
        marker.lng job.longitude
        marker.title job.title
      end
    end.flatten.to_json
  end

  private

  def init_search_params(params)
    init_location(params)

    @keywords = params[:keywords] || ''
    @a_keywords = keywords.gsub(',', ' ').split(' ').map(&:squish)

    @current_page = (params[:page] || 1).to_i
  end

  def init_location(params)
    loc = params[:location] || ''
    @location = loc.gsub('United States', '')
                .split(',')
                .map(&:squish)
                .select { |c| c.size > 0 }
                .join(',')
  end

  def valid_params
    location.size > 0 && a_keywords.any?
  end

  def search_params
    { keywords: a_keywords, city: location, page: current_page }
  end
end
