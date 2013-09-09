# Идея такая. Генерировать странички сайта из трёх частей - 
# хедер, основная часть, и футер.
# При этом основная часть делается пишется на haml.

def generate_header(nav_links, active_link)
	header = 
'<!DOCTYPE html>
<html>
	<head>
  		<meta charset="utf-8">
    	<title>Кафедра термодинамики и тепловых двигателей</title>
    	<!-- Bootstrap -->
    	<link href="bootstrap/css/bootstrap.min.css" rel="stylesheet" media="screen">
    	<link href="my.css" rel="stylesheet" media="screen">
  	</head>
	<body>  	
  		<div class="container-fluid" margin-left: auto;>
  			<div class="navbar">
  				<div class="navbar-inner">
    				<a class="brand" href="sostav.html">Кафедра термодинамики и тепловых двигателей</a>
    				<ul class="nav">
'
    nav_links.each do |link|
    	if link[:text] == active_link
    		str = 
"						<li class='active'><a href='#{link[:href]}'>#{link[:text]}</a></li>
"    		
		else
    		str = 
"						<li><a href='#{link[:href]}'>#{link[:text]}</a></li>
"
		end
    	header = header + str
    end      					
    header = header + '
    				</ul>
  			</div>
		</div>  
'
end

def generate_footer()
	footer = '
	<div id="bottom_div"></div>
	<script src="http://code.jquery.com/jquery-latest.js"></script>
	<script src="bootstrap/js/bootstrap.min.js"></script>    
</body>
</html>'
end

def generate_body(haml_file_name)
	system("haml #{haml_file_name} #{haml_file_name}.html")
	file = File.open("#{haml_file_name}.html", "r")
	body = file.read.to_s
	system("rm #{haml_file_name}.html")
	body
end

def generate_personal_pages(nav_links)
	Dir["#{Dir.pwd}/PersonalPages/*"].each do |file_name|
		header = generate_header(nav_links, "Нет")
		body   = generate_body(file_name)
		footer = generate_footer
		result = header + body + footer	
		result_file_name = 
			"#{file_name}".sub!('haml', 'html').sub('/PersonalPages', '')
		result_file = File.open(result_file_name, 'w')
		result_file.write(result)
	end
end

def generate_sostav(nav_links)
	header = generate_header(nav_links, "Состав кафедры")
	body   = generate_body("#{Dir.pwd}/Main/sostav.haml")
	footer = generate_footer
	result_file = File.open("#{Dir.pwd}/sostav.html", 'w')
	result_file.write(header + body + footer)
end

def generate_photo(nav_links)
	header = generate_header(nav_links, "Фотографии")
	body   = generate_body("#{Dir.pwd}/Main/photo.haml")
	footer = generate_footer
	result_file = File.open("#{Dir.pwd}/photo.html", 'w')
	result_file.write(header + body + footer)
end

def generate_main_pages(nav_links)
	generate_sostav(nav_links)
	generate_photo(nav_links)
end

nav_links = []
		nav_links << {href:"sostav.html", text:"Состав кафедры"}
		#nav_links << {href:"", text:"Новости"}
		nav_links << {href:"photo.html", text:"Фотографии"}
		#nav_links << {href:"", text:"Контакты"}

generate_personal_pages(nav_links)
generate_main_pages(nav_links)