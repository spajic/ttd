# Идея такая. Генерировать странички сайта из трёх частей - 
# хедер, основная часть, и футер.
# При этом основная часть делается пишется на haml.

def generate_header(nav_links)
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
    				<a class="brand" href="#">Кафедра термодинамики и тепловых двигателей</a>
    				<ul class="nav">'
    nav_links.each do |link|
    	str = 
"						<li><a href='#{link[:href]}'>#{link[:text]}</a></li>
"
    	header = header + str
    end      					
    header = header + '
    				</ul>
  			</div>
		</div>  
  		<div class="alert alert-info">
      		<button type="button" class="close" data-dismiss="alert">&times;</button>
      		Для перехода к странице Состав кафедры воспользуйтесь кнопкой вверху страницы
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

def generate_personal_pages()
	Dir["#{Dir.pwd}/PersonalPages/*"].each do |file_name|
		nav_links = []
		nav_links << {href:"sostav.html", text:"Состав кафедры"}
		nav_links << {href:"", text:"Новости"}
		nav_links << {href:"", text:"О кафедре"}
		nav_links << {href:"", text:"Контакты"}
		header = generate_header(nav_links)
		body   = generate_body(file_name)
		footer = generate_footer
		result = header + body + footer	
		result_file_name = 
			"#{file_name}".sub!('haml', 'html').sub('/PersonalPages', '')
		result_file = File.open(result_file_name, 'w')
		result_file.write(result)
	end
end

generate_personal_pages