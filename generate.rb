# Идея такая. Генерировать странички сайта из трёх частей - 
# хедер, основная часть, и футер.
# При этом основная часть пишется на haml.

def generate_navbar_item_html(title, name, active_title)
	if title == active_title
		"<li class='active'><a href='#{name}'>#{title}</a>"
	else
		"<li><a href='#{name}'>#{title}</a>"
	end
end

def childs_contain_active_link?(childs, active_link)
	childs.each do |ch|
		if ch.is_a?(Hash) && ch[:title] == active_link
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
    		"<li role='presentation'><a role='menuitem' tabindex='-1' href='#{ch[:name]}.html'>#{ch[:title]}</a></li>
    		"
    	end
    end
    res = res + 
    '                
            </ul>
    </li>'
    return res
end

def generate_navbar_html(nav_links, active_link)
	res = ""
	nav_links.each do |item|
		if item[:childs].nil?
			res = res + 
				generate_navbar_item_html(item[:title], "#{item[:name]}.html", active_link) + "
				"
		else
			res = res +
				generate_dropdown_html(item[:title], item[:childs], active_link, item[:title])
		end
	end
	res
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
    					generate_navbar_html(nav_links, active_link) + '
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

def generate_one_of_main_pages(nav_links, page_title, page_name)
	header = generate_header(nav_links, page_title)
	body   = generate_body("#{Dir.pwd}/Main/#{page_name}.haml")
	footer = generate_footer
	result_file = File.open("#{Dir.pwd}/#{page_name}.html", 'w')
	result_file.write(header + body + footer)
end

def generate_main_pages(nav_links)
	nav_links.each do |item|
		if item[:childs].nil?
			generate_one_of_main_pages(nav_links, item[:title], item[:name])
		else
			item[:childs].each do |child_item|
				if child_item.is_a?(Hash)
					generate_one_of_main_pages(nav_links, child_item[:title], child_item[:name])
				end
			end
		end
	end
end

def generate_personal_pages(nav_links)
	Dir["#{Dir.pwd}/PersonalPages/*"].each do |file_name|
		header = generate_header(nav_links, "Состав")
		body   = generate_body(file_name)
		footer = generate_footer
		result = header + body + footer	
		result_file_name = 
			"#{file_name}".sub!('haml', 'html').sub('/PersonalPages', '')
		result_file = File.open(result_file_name, 'w')
		result_file.write(result)
	end
end

nav_links = [
	{title:"Новости"		, name:"news"		},
	{title:"Состав"			, name:"sostav"		},
	{title:"Филиалы"		, name:"branches"	},
	{title:"Расписание"		, 
		childs: [
			{title:"Нагрузка преподавателей"	, name:"schedule"	},
			{title:"Консультации"		   		, name:"consult"	}
		]
	},
	{title:"Справочная информация",
		childs: [
			{title:"История кафедры"				, name:"about"},
			{title:"Научно-педагогическая школа"	, name:"school"},
			{title:"Диссертации"					, name:"dissers"},
			{title:"Положение о кафедре"			, name:"statement"},
			"divider",
			{title:"Литература"						, name:"literature"},
			{title:"Рейтинг"						, name:"rating"},
		]
	},
	{title:"Фото"			, name:"photo"	},
	{title:"Контакты"		, name:"contacts"	}
]

generate_personal_pages(nav_links)
generate_main_pages(nav_links)
generate_one_of_main_pages(nav_links, "Новости", "news_2012")