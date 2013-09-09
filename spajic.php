<iframe id="spajic_frame" position="absolute" width="100%" height="1300" seamless="" frameborder="0" src="new/sostav.html" onload="load()"> iFrame </iframe> 
<script>
function load()
{
  var my_frame = document.getElementById("spajic_frame");
  var frameDoc = my_frame.contentDocument || my_frame.contentWindow.document;
  var bot = frameDoc.getElementById("bottom_div");
  my_frame.height = bot.offsetTop + 10;
}
</script>
 