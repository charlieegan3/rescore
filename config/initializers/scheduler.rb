require 'rufus-scheduler'

if Rails.env.production?
  scheduler = Rufus::Scheduler.singleton

  scheduler.every '10m' do
    `rake clean_uncomplete`
  end
end
