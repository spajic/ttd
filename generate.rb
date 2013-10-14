# Идея такая. Генерировать странички сайта из трёх частей - 
# хедер, основная часть, и футер.
# При этом основная часть делается пишется на haml.

def generate_navbar_item_html(text, href, active_link)
	if text == active_link
		"<li class='active'><a href=#{href}>#{text}</a>"
	else
		"<li><a href=#{href}>#{text}</a>"
	end
end

def childs_contain_active_link?(childs, active_link)
	childs.each do |ch|
		if ch.is_a?(Hash) && ch[:text] == active_link
			return true
		end
	end
	return false
end

def generate_dropdown_html(text, childs, active_link, id)
	if childs_contain_active_link?(childs, active_link)
		res = "<li class='active dropdown'>"
	else
		res = "<li class='dropdown'>"
	end
	res = res + "
    	<a id='#{id}' href='#' role='button' class='dropdown-toggle' data-toggle='dropdown'>#{text} <b class='caret'></b></a>
            <ul class='dropdown-menu' role='menu' aria-labelledby='#{id}'>
            "
    childs.each do |ch|
    	if(ch == 'divider')
    		res = res + 
    		"<li role='presentation' class='divider'></li>
    		"
    	else
    		res = res + 
    		"<li role='presentation'><a role='menuitem' tabindex='-1' href=#{ch[:href]}>#{ch[:text]}</a></li>
    		"
    	end
    end
    res = res + 
    '                
            </ul>
    </li>'
    return res
end

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
    				<a class="brand" href="news.html">Кафедра термодинамики и тепловых двигателей</a>
    				<ul class="nav">' +
    					generate_navbar_item_html('Новости', 'news.html', active_link) +
    					generate_navbar_item_html('Состав', 'sostav.html', active_link) +
    					generate_navbar_item_html('Фото', 'photo.html', active_link) + 
    					generate_dropdown_html('Расписание', 
    						[
								{text:"Нагрузка преподавателей"	, href:"schedule.html"	},
								{text:"Консультации"		   	, href:"consult.html"	}
							],
							active_link, 'drop1'
						) + 
    					generate_dropdown_html('Справочная информация', 
    						[
								{text:"История кафедры"			, href:"about.html"},
								{text:"Научно-педагогическая школа", href:"school.html"},
								{text:"Диссертации"				, href:"dissers.html"},
								{text:"Положение о кафедре"		, href:"statement.html"},
								'divider',
								{text:"Литература"				, href:"literature.html"},
								{text:"Рейтинг"					, href:"rating.html"}
							],
							active_link, 'drop2'
						) +
    					generate_navbar_item_html('Контакты', 'contacts.html', active_link) + '
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

def generate_news(nav_links)
	header = generate_header(nav_links, "Новости")
	body   = generate_body("#{Dir.pwd}/Main/news.haml")
	footer = generate_footer
	result_file = File.open("#{Dir.pwd}/news.html", 'w')
	result_file.write(header + body + footer)
end

def generate_consult(nav_links)
	header = generate_header(nav_links, "Консультации")
	body   = generate_body("#{Dir.pwd}/Main/consult.haml")
	footer = generate_footer
	result_file = File.open("#{Dir.pwd}/consult.html", 'w')
	result_file.write(header + body + footer)
end

def generate_about(nav_links)
	header = generate_header(nav_links, "О кафедре")
	body   = generate_body("#{Dir.pwd}/Main/about.haml")
	footer = generate_footer
	result_file = File.open("#{Dir.pwd}/about.html", 'w')
	result_file.write(header + body + footer)
end

def generate_school(nav_links)
	header = generate_header(nav_links, "Научно-педагогическая школа")
	body   = generate_body("#{Dir.pwd}/Main/school.haml")
	footer = generate_footer
	result_file = File.open("#{Dir.pwd}/school.html", 'w')
	result_file.write(header + body + footer)
end

def generate_contacts(nav_links)
	header = generate_header(nav_links, "Контакты")
	body   = generate_body("#{Dir.pwd}/Main/contacts.haml")
	footer = generate_footer
	result_file = File.open("#{Dir.pwd}/contacts.html", 'w')
	result_file.write(header + body + footer)
end

def generate_dissers(nav_links)
	header = generate_header(nav_links, "Подготовка специалистов высшей квалификации")
	body   = generate_body("#{Dir.pwd}/Main/dissers.haml")
	footer = generate_footer
	result_file = File.open("#{Dir.pwd}/dissers.html", 'w')
	result_file.write(header + body + footer)
end

def generate_literature(nav_links)
	header = generate_header(nav_links, "Литература")
	body   = generate_body("#{Dir.pwd}/Main/literature.haml")
	footer = generate_footer
	result_file = File.open("#{Dir.pwd}/literature.html", 'w')
	result_file.write(header + body + footer)
end

def generate_schedule(nav_links)
	header = generate_header(nav_links, "Расписание")
	body   = generate_body("#{Dir.pwd}/Main/schedule.haml")
	footer = generate_footer
	result_file = File.open("#{Dir.pwd}/schedule.html", 'w')
	result_file.write(header + body + footer)
end

def generate_statement(nav_links)
	header = generate_header(nav_links, "Положение о кафедре")
	body   = generate_body("#{Dir.pwd}/Main/statement.haml")
	footer = generate_footer
	result_file = File.open("#{Dir.pwd}/statement.html", 'w')
	result_file.write(header + body + footer)
end

def generate_rating(nav_links)
	header = generate_header(nav_links, "Рейтинг")
	body   = generate_body("#{Dir.pwd}/Main/rating.haml")
	footer = generate_footer
	result_file = File.open("#{Dir.pwd}/rating.html", 'w')
	result_file.write(header + body + footer)
end

def generate_main_pages(nav_links)
	generate_sostav(nav_links)
	generate_photo(nav_links)
	generate_news(nav_links)
	generate_consult(nav_links)
	generate_about(nav_links)
	generate_school(nav_links)
	generate_contacts(nav_links)
	generate_dissers(nav_links)
	generate_literature(nav_links)
	generate_schedule(nav_links)
	generate_statement(nav_links)
	generate_rating(nav_links)
end

nav_links = [
	{text:"Новости"				, href:"news.html"		},
	{text:"Фото"				, href:"photo.html"	 	},
	{text:"Состав"				, href:"sostav.html"	},
	{text:"О кафедре"			, href:"about.html"	 	},
	{text:"Расписание"			, 
		childs: [
			{text:"Нагрузка преподавателей"	, href:"schedule.html"	},
			{text:"Консультации"		   	, href:"consult.html"	}
		]
	},
	{text:"Справочная информация",
		childs: [
			{text:"История кафедры"			, href:"about.html"},
			{text:"Научно-педагогическая школа", href:"school.html"},
			{text:"Диссертации"				, href:"dissers.html"},
			{text:"Литература"				, href:"literature.html"},
			{text:"Положение о кафедре"		, href:"statement.html"},
			{text:"Рейтинг"					, href:"rating.html"},
		]
	},
	{text:"Контакты"			, href:"contacts.html"	}
]

generate_personal_pages(nav_links)
generate_main_pages(nav_links)
