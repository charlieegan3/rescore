class Statistic < ActiveRecord::Base
  validates_uniqueness_of :identifier
  serialize :value, Hash
end
