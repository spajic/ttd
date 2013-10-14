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

def generate_one_of_main_pages(nav_links, page_title, page_name)
	header = generate_header(nav_links, page_title)
	body   = generate_body("#{Dir.pwd}/Main/#{page_name}.haml")
	footer = generate_footer
	result_file = File.open("#{Dir.pwd}/#{page_name}.html", 'w')
	result_file.write(header + body + footer)
end

def generate_main_pages(nav_links)
	generate_one_of_main_pages(nav_links, "Состав", "sostav")
	generate_one_of_main_pages(nav_links, "Фото", "photo")
	generate_one_of_main_pages(nav_links, "Новости", "news")
	generate_one_of_main_pages(nav_links, "Консультации", "consult")
	generate_one_of_main_pages(nav_links, "История кафедры", "about")
	generate_one_of_main_pages(nav_links, "Школа", "school")
	generate_one_of_main_pages(nav_links, "Диссертации", "dissers")
	generate_one_of_main_pages(nav_links, "Литература", "literature")
	generate_one_of_main_pages(nav_links, "Расписание", "schedule")
	generate_one_of_main_pages(nav_links, "Положение о кафедре", "statement")
	generate_one_of_main_pages(nav_links, "Рейтинг", "rating")
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
