FactoryGirl.define do
  factory :movie do
    title "Gladiator"
    rotten_tomatoes_id 13065
    year 2000
    page_depth 1
    genres ["Drama", "Action & Adventure", "Classics"]
    imdb_link "http://www.imdb.com/title/tt0172495/"
    rotten_tomatoes_link "http://www.rottentomatoes.com/m/gladiator"
    amazon_link "http://www.amazon.com/Gladiator-Signature-Selection-Two-Disc-Collectors/dp/B00003CXE7"
    metacritic_link "http://www.metacritic.com/movie/gladiator"
    image_url "http://resizing.flixster.com/348RC8N3_r-LyPoRTX8l0j6YIQ0=/54x81/dkpu1ddg7pbsk.cloudfront.net/movie/11/16/89/11168944_ori.jpg"
    status nil
    task nil
    related_people({:cast=>[{:name=>"Russell Crowe", :characters=>["Gen. Maximus"]}, {:name=>"Joaquin Phoenix", :characters=>["Commodus"]}, {:name=>"Connie Nielsen", :characters=>["Lucilla"]}, {:name=>"Oliver Reed", :characters=>["Proximo"]}, {:name=>"Richard Harris", :characters=>["Marcus Aurelius"]}, {:name=>"Derek Jacobi", :characters=>["Gracchus"]}, {:name=>"Djimon Hounsou", :characters=>["Juba"]}, {:name=>"David Schofield", :characters=>["Falco"]}, {:name=>"John Shrapnel", :characters=>["Gaius"]}, {:name=>"Tomas Arana", :characters=>["Quintus"]}, {:name=>"Ralph Moeller", :characters=>["Hagen"]}, {:name=>"Ralf Moeller", :characters=>["Hagen"]}, {:name=>"Spencer Treat Clark", :characters=>["Lucius"]}, {:name=>"David Hemmings", :characters=>["Cassius"]}, {:name=>"Tommy Flanagan", :characters=>["Cicero"]}, {:name=>"Sven Ole Thorsen", :characters=>["Tiger"]}, {:name=>"Omid Djalili", :characters=>["Slave Trader"]}, {:name=>"Nicholas McGaughey", :characters=>["Praetorian Officer"]}, {:name=>"Chris Kell", :characters=>["Scribe"]}, {:name=>"Tony Curran", :characters=>["Assasin No. 1"]}, {:name=>"Mark Lewis", :characters=>["Assassin No. 2"]}, {:name=>"John Quinn", :characters=>["Valerius"]}, {:name=>"Alun Raglan", :characters=>["Praetorian Guard No. 1"]}, {:name=>"David Bailie", :characters=>["Engineer"]}, {:name=>"Chick Allen", :characters=>["German Leader"]}, {:name=>"David Nicholls", :characters=>["Giant Man"]}, {:name=>"Al Ashton", :characters=>["Rome Trainer No. 1"]}, {:name=>"Billy Dowd", :characters=>["Narrator"]}, {:name=>"Ray Calleja", :characters=>["Lucius' Attendant"]}, {:name=>"Giannina Facio", :characters=>["Maximus' Wife"]}, {:name=>"Giorgio Cantarini", :characters=>["Maximus' Son"]}], :directors=>[{"name"=>"Ridley Scott"}]})
    sentiment({:topics=>{:editing=>0.03865546218487395, :sound=>0.06386554621848739, :plot=>0.1411764705882353, :dialog=>0.14453781512605043, :cast=>0.16134453781512606, :vision=>0.0453781512605042, :length=>-0.03865546218487395, :credibility=>0.09915966386554621, :cinematography=>0.13949579831932774, :concept=>0.13445378151260504, :novelty=>0.07058823529411765}, :people=>[], :distribution=>[[-1.41, 90], [-0.71, 56], [0.0, 153], ["", 91], [1.41, 481]], :location=>[], :distribution_stats=>{:range=>3, :st_dev=>0.8596398759093506, :values=>[8, 35, 56, 33]}})
    stats({:topic_counts=>{:editing=>0.011396011396011397, :sound=>0.06837606837606838, :plot=>0.36182336182336183, :dialog=>0.042735042735042736, :cast=>0.19943019943019943, :vision=>0.07977207977207977, :length=>0.042735042735042736, :credibility=>0.05413105413105413, :cinematography=>0.1111111111111111, :concept=>0.011396011396011397, :novelty=>0.017094017094017096}, :rating_distribution=>[3, 0, 0, 2, 1, 0, 3, 3, 8, 14, 104]})
    complete true
    updated_at Time.new
    created_at Time.new
  end
end
