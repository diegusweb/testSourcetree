<!--#include file='includes/classes.asp'-->
<%
Dim category_id, OwnCandidateName, flag_SQLinjection, categoryname, stage, LeftDays
Set ObjGeneral=new General

Set ObjGeneral=new General

Dim nom, ape, ema, ciu, pai, cab, des, NombreAfiche

PosterHash=Request.QueryString("PosterHash")

Set Ob_RS=ObjGeneral.getUserPoster(PosterHash)

NombreAfiche = PosterHash

link_registro = AbsoluleUrlPath & "posterFinished.asp?PosterHash=" & NombreAfiche

%>
<!--#include file='includes/header.asp'-->
<script type="text/javascript">
function onButtonFacebookClick()
{
	var urlFb = 'http://www.facebook.com/sharer.php?s=100 ' + 
		'&p[url]=<%=link_registro%>'+
		'&p[images][0]=<%=PictureUrl&NombreAfiche%>' +
		'&p[title]=<%=descripcion%> - The History Channel.';
		
	window.open(urlFb,"Facebook"); 
}

function onButtonTwitterClick()
{
	var urlTwt = 'http://twitter.com/share?count=vertical' + 
	'&text=' + escape('<%=tituloTweeer%>') +
	'&url=' + '<%=link_registro%>';
	
	window.open(urlTwt,"Twitter");  
}
</script>
<body>
<div class="cont-fondo">
	<div class="cont-finished">
  		<!-- Esta es la imagen que se crea -->
      <div class="cont-imagen"><img src="<%=PictureUrl&NombreAfiche%>"></div>
      <div class="bottom-finished">
      	<div class="botones">
            <a href="save_post.asp?filename=<%=NombreAfiche%>" class="btn-amigo"></a>
            <a href="javascript:onButtonFacebookClick();" class="btn-compartir"></a>
        </div>
      <div class="botones">
                <a href="javascript:onButtonTwitterClick();" class="ico-twt-2"></a>
                <a href="javascript:window.print();" class="ico-mail-2"></a>
      </div>
      </div>
	</div>
</div>
</body>
</html>
