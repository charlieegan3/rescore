require_relative '../../config/environment'

task :clean_uncomplete do
  Movie.where.not(complete: true).delete_all
end
