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
    sentiment({:topics=>[[:plot, 34.20119932432433], [:dialog, 22.089375], [:cast, 27.99913043478261], [:sound, 9.951895161290324], [:vision, 10.643083333333339], [:editing, 15.984166666666667]], :people=>[["Ralph Moeller", 0.33925, 5], ["Russell Crowe", 0.2952586206896552, 29], ["Oliver Reed", 0.06412500000000002, 10], ["Ridley Scott", 0.20091911764705878, 34], ["Connie Nielsen", 0.03374999999999998, 12], ["Richard Harris", 0.02350000000000001, 15], ["Joaquin Phoenix", 0.06349431818181818, 44]], :distribution=>[[-1.68, 2], ["", 2], ["", 4], ["", 7], ["", 11], [-0.87, 21], ["", 33], ["", 23], ["", 48], ["", 40], ["", 37], [-0.07, 89], ["", 60], ["", 62], ["", 62], ["", 36], ["", 21], ["", 13], [1.06, 9], ["", 8], ["", 6], ["", 6], [1.7, 3]], :location=>[], :distribution_stats=>[1.81875, 0.2736063358700454]})
    stats({:topic_counts=>{:plot=>74, :dialog=>6, :cast=>69, :sound=>31, :vision=>45, :editing=>12}, :rating_distribution=>[3, 1, 7, 0, 2, 3, 7, 4, 20, 9, 38]})
  end
end
