require 'open-uri'
require 'nokogiri'


BASE_URL = 'http://en.wikipedia.org'
SUBDIR = 'Downloads/'



film_array = []

year = (2000..2014)

year.each do |year|

  url = "http://en.wikipedia.org/wiki/#{year}_in_film"
  begin
    page = Nokogiri::HTML(open(url))
  rescue Exception => e
    p e
  end
  page.css('table.wikitable').each do |i|
    if i.text=~/Open/
      i.css('tr').each do |film|
        begin
          wiki_link = film.css('td:not([style])')[0].children.children.attribute('href').value
          name = film.css('td:not([style])')[0].text
          studio = film.css('td:not([style])')[1].text
          p "#{name}--#{studio}--#{wiki_link}"
          film_array << "#{name}--#{studio}--#{wiki_link}"
        rescue Exception => e
          p e
        end
      end
    end
  end
  sleep rand(3)+3
end
file = File.open("List of Films on Wikipedia.txt", 'w')
film_array.each do |i|
  file.write("#{i}\n")
end

film_array.sort!


p "written File"

film_array.each_with_index do |a,i|
  name = a.split('--')[0]
  begin
    page = Nokogiri::HTML(open(BASE_URL + a.split('--')[-1]))
    p "Saving #{name}..."
    File.open("#{SUBDIR}#{name}.html", 'w') {|f| f.write( page)}
  rescue Exception => e
    p "#{name} URL doesn't work. :("
  end
  sleep 5 + rand(15)

end
