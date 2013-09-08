# Идея такая. Генерировать странички сайта из трёх частей - 
# хедер, основная часть, и футер.
# При этом основная часть делается пишется на haml.

def generate_header()
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
    				<ul class="nav">
      					<li><a href="sostav.html">Состав кафедры</a></li>
      					<li><a href="#">Новости</a></li>
      					<li><a href="#">О кафедре</a></li>
      					<li><a href="#">Контакты</a></li>
    				</ul>
  			</div>
		</div>  
  		<div class="alert alert-info">
      		<button type="button" class="close" data-dismiss="alert">&times;</button>
      		Для перехода к странице Состав кафедры воспользуйтесь кнопкой вверху страницы</strong>
   		</div>
'
end

def generate_body()
	%x( haml vasylev.html.haml vasylev.body.html )
	file = File.open('vasylev.body.html', "r")
	body = file.read
end

def generate_footer()
	footer = '
	<div id="bottom_div"></div>
	<script src="http://code.jquery.com/jquery-latest.js"></script>
	<script src="bootstrap/js/bootstrap.min.js"></script>    
</body>
</html>'
end

def generate()
	result = generate_header + generate_body + generate_footer
	file = File.open('vasylev.result.html', 'w')
	file.write(result)
end

generate