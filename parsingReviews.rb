require 'nokogiri'
require 'sqlite3'
Dir.chdir "/Users/williamclarke/Dropbox/Ruby/Films/Downloads"


list_of_films = Dir.glob '*'
list_of_films = list_of_films[1..2]


output_file = File.open('reviews.txt', 'w')


list_of_films.each do |film|

film_html = Nokogiri::HTML(open(film))

review_hash = {}

def standardCleaning s
	a = s.scan(/...\d+.../)
	unless a[0] == nil
		a = a.reject{|i| i=~ /\d\d\d+/ || i=~ /\d\d,/ }
		return a
	end
	return nil
end

def rt (s, film)
	shortlist = standardCleaning s
	if shortlist
		if shortlist.count == 1
			return shortlist[0].scan(/\d+/).to_s.gsub(/(\[|\]|\"|\\")/,'').to_s
		else
			shortlist.reject{|i| i=~/on \d/}
			return shortlist[0].scan(/\d+/).to_s.gsub(/(\[|\]|\"|\\")/,'').to_s
		end

end
end

def rt_mc (s, film)
	# p s
end

def mc (s, film)
	# p s	
end


film_html.text.split('.').each do |sentances|
rt_a, mc_a, rt_mc_a = [], [], []
	if sentances.match(/Rotten/) && sentances.match(/etacritic/)
		rt_mc_a << sentances
	elsif sentances.match(/Rotten/)
		rt_a << sentances

		# p rt sentances, film unless nil
	elsif sentances.match(/etacritic/)
		mc_a << sentances

	else
		# p 'soz. youre a loser'
	end
end
p rt_a
end

p "omg. well done."

__END__

string = page.css("h3+ p").text

string.split('.') 	# => Sentances
		[0]			# => First iteration
		.match(/Rotten/) # => #<MatchData "Rotten">

# so...
review_hash = {}
str.split('.').each do |i|
	if i.match(/Rotten/)
		review_hash[:rottenTomatoes] = i.match /\d+\%/
	end
	if i.match(/Metacritic/)
		 tmp = i.scan(/...\d+.../)
		 if tmp.count = 0
		 	if tmp.count = 1
		 		review_hash[:metacritic] = tmp
		 	elsif tmp.count > 1
		 		tmp = tmp.reject{|i|i=~/100/ || i[0..3]=~/on/ || i=~/\%/ || i=~/\[\d+\]/ || i[0..3]=~/om/}
		 	end
	end
end