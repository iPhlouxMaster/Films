require 'nokogiri'
require 'sqlite3'
Dir.chdir "/Users/williamclarke/Dropbox/Ruby/Films/Downloads"


list_of_films = Dir.glob '*'
# list_of_films = list_of_films[1..2]

DB = SQLite3::Database.new('Film_db.sqlite')
DB.execute("DROP TABLE IF EXISTS films")
DB.execute("CREATE TABLE films(id INTEGER PRIMARY KEY AUTOINCREMENT, name, directed, produced, written, starring, music, cinematography, edited, studio, distributed, release, running, country, language, budget, box)")

output_file = []

def create_all_combinations ( hash )
map = create_map(hash)
# p map.values
output_file = {}
map.values.select{|i| i!= nil}.max.times do |iterations|
	tmp = {}
	map.each do |title, number_of_iterations|
map_count = 1

		last_multiplier = map.values[0..(map_count - 1)].max
		if map_count == 0
			last_multiplier = 1
		end


		if map.values[map_count]==nil
			tmp[title]=hash[title.to_sym]
			
		else
		tmp[title] = hash[title][(iterations / last_multiplier) % map[title]]

	end

end
output_file[iterations]=tmp

end

output_file
end


def create_map (a)
	unless a.class==Hash
		p "class = #{a.class}"
	end
my_map = a.values.map do |e| 
	if e == []
		1
	elsif
		e.class == Fixnum
		1
	elsif e.class == Array
		e.count
	else
		p 'someething went wrong mate'
	end
end

sum = 1
test = my_map.map do |x|
	if x==1
		

	else
		sum *= x
	end
end
titles = %w{Name Directed Produced Written Starring Music Cinematography Editing Studio Distributed Release Running Country Language Budget Box}

h = {}
m = test.each_with_index  do |e, i| 
	e ||= 1 
	h[titles[i].to_sym]=e 
end
h
end


def sidebar_info_to_hash (text_to_search_by, film_page, film_name, hash)
tmp_array = []
 film_page.css("table.infobox th:contains('#{text_to_search_by}') + td").css('td').children.each do |i| 
tmp_array << i.text.split("\n")
end
tmp_array.flatten!
tmp_array.select! {|i| i=~ /\S/}
tmp_array.reject! {|i| i=~ /\[\d\]/}

# text = "#{film_name}---#{text_to_search_by}"
# hash["#{film_name}---#{text_to_search_by}"] = tmp_array

hash[text_to_search_by.to_sym] = tmp_array
end


list_of_films.each do |film|


film_html = Nokogiri::HTML(open(film))
hash = {}
max_number = 0
titles = %w{Directed Produced Written Starring Music Cinematography Editing Studio Distributed Release Running Country Language Budget Box}
titles.each do |title|
	sidebar_info_to_hash(title, film_html, film, hash)
	hash["Name".to_sym] = [film.sub('.html','')]
	# DB.execute("INSERT INTO films(name, directed, produced, written, starring, music, cinematography, edited, studio, distributed, release,	running, country, language, budget, box) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",	film.sub('.html', ''), hash["#{film}---directed"], hash["#{film}---produced"], hash["#{film}---written"], hash["#{film}---starring"], hash["#{film}---music"], hash["#{film}---cinematography"], hash["#{film}---edited"], hash["#{film}---studio"], hash["#{film}---distributed"], hash["#{film}---release"], hash["#{film}---running"], hash["#{film}---country"], hash["#{film}---language"], hash["#{film}---budget"], hash["#{film}---box)"])


end
# p hash
# p "hash = #{hash}"
h = create_all_combinations( hash )
max_number = h.count

p "#{film.sub('.html','')}--#{max_number} iterations"

# p h
# p 
h.each do |i|	

	DB.execute("INSERT INTO films(name, directed, produced, written, starring, music, cinematography, edited, studio,
	 distributed, release,	running, country, language, budget, box) 
	VALUES 
	(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
	i[1][:Name], i[1][:Directed], i[1][:Produced], i[1][:Written], 
		i[1][:Starring], i[1][:Music], i[1][:Cinematograpiy], i[1][:Edited],
		 i[1][:Studio], i[1][:Distributed], i[1][:Release], i[1][:Running], 
		 i[1][:Country], i[1][:Language], i[1][:Budget], i[1][:Box])
	# DB.execute("INSERT INTO films(name, directed, produced, written, starring, music, cinematography, edited, studio, distributed, release,	running, country, language, budget, box) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",	h[i][0], h[i][1], h[i][2], h[i][3], h[i][4], h[i][5], h[i][6], h[i][7], h[i][8], h[i][9], h[i][10], h[i][11], h[i][12], h[i][13], h[i][14], h[i][15])
end


end


p "omg. well done."