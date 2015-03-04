FactoryGirl.define do
  factory :review_count_statistic, class: Statistic do
    identifier 'review_count'
    value ({:count => 10})
  end

  factory :topic_counts_statistic, class: Statistic do
    identifier 'topic_counts'
    value ({:editing=>0.19372294372294374, :sound=>0.1457091927680163, :plot=>0.5792844410491469, :dialog=>0.11776165011459128, :cast=>0.37918258212375855, :vision=>0.18284950343773873, :length=>0.07556659027247262, :credibility=>0.087764196587726, :cinematography=>0.1415711739241151, :concept=>0.05765215176979883, :novelty=>0.03893557422969188})
  end

  factory :topic_sentiments_statistic, class: Statistic do
    identifier 'topic_sentiments'
    value ({:editing=>0.20248751936650028, :sound=>0.18738164916508865, :plot=>0.17730030986400414, :dialog=>0.16083878464451712, :cast=>0.26465398519538647, :vision=>0.17464279566190394, :length=>-0.03595713547942848, :credibility=>0.1957845584437941, :cinematography=>0.1376312618350835, :concept=>0.25326002754346705, :novelty=>0.2819762437596832})
  end

  factory :people_count_statistic, class: Statistic do
    identifier 'people_count'
    value ({:count => 10})
  end

  factory :sentiment_variation_statistic, class: Statistic do
    identifier 'sentiment_variation'
    value({:variation=>45})
  end
end
