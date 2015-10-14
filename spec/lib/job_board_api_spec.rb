require 'vcr'
require './spec/support/vcr'

describe JobBoardApi do
  it 'job board gets requested job boards' do
    module JobBoardApi
      class LocalJobs < JobBoard
      end
    end

    job_boards = JobBoardApi::JobBoard.all('127.1.1.1')

    expect(job_boards.map(&:class).include? JobBoardApi::LocalJobs).to be_truthy

    %w(Authentic Indeed).each do |board_name|
      jb = JobBoardApi::JobBoard.new_board(board_name, '', '')
      expect(jb.class.name).to eql("JobBoardApi::#{board_name}")
    end
  end

  it 'job boards find jobs' do
    job_boards = %w(Authentic Indeed)
                 .map { |jb| JobBoardApi::JobBoard.new_board(jb, '127.1.1.1') }

    args = { keywords: %w(ruby rails), city: 'Philadelphia', state: 'PA' }

    VCR.use_cassette('job_board_api') do
      job_boards.each do |jb|
        jb.search_jobs args
      end

      expect(job_boards[0].jobs.count).to eql(3)
      expect(job_boards[1].jobs.count).to eql(25)

      expect(job_boards[0].total_count).to eql(3)
      expect(job_boards[1].total_count).to eql(71)

      job1 = job_boards[0].jobs.first
      job2 = job_boards[1].jobs.first

      expect(job1.title).to eql('Software Engineer')
      expect(job1.company).to eql('Delighted')

      expect(job2.title).to eql('Ruby on Rails Developer')
      expect(job2.company).to eql('Artech Information System LLC')

      job_boards[1].search_jobs args.merge(page: 3)
      expect(job_boards[1].count).to eql(71 - 50)
      job1 = job_boards[1].jobs.first

      expect(job1.title).to eql('Ruby on Rails Developer')
      expect(job1.company).to eql('Open Systems Technologies')

      job_boards[1].search_jobs args.merge(page: 1)
      expect(job_boards[1].count).to eql(25)
    end
  end
end
