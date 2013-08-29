<!--#include file='includes/classes.asp'-->
<!--#include file='includes/text.asp'-->
<% 

	Dim recaptcha_public_key, recaptcha_private_key

	recaptcha_public_key       = "6Ldz77wSAAAAAKmAnKenHbE9Qqj_sZoMDsmimTC6" ' your public key
	recaptcha_private_key      = "6Ldz77wSAAAAAOmIbJVqMuwQ0VM6DcZKGI1fCCFX" ' your private key

	Set ObjGeneral= new General

	dim nom, ape, ciu, pai, cab, ema, max_amigos
	
	max_amigos = 4
	
	if ObjGeneral.getCookie("txt_nombre") <> False then
		nom = ObjGeneral.getCookie("txt_nombre")
	end if
	
	if ObjGeneral.getCookie("txt_apellido") <> False then
		ape = ObjGeneral.getCookie("txt_apellido")
	end if
	
	if ObjGeneral.getCookie("txt_ciudad") <> False then
		ciu = ObjGeneral.getCookie("txt_ciudad")
	end if
	
	if ObjGeneral.getCookie("txt_pais") <> False then
		pai = ObjGeneral.getCookie("txt_pais")
	end if
	
	if ObjGeneral.getCookie("txt_operador") <> False then
		cab = ObjGeneral.getCookie("txt_operador")
	end if
	
	if ObjGeneral.getCookie("txt_mail") <> False then
		ema = ObjGeneral.getCookie("txt_mail")
	end if
	
	If(Request.QueryString("sent")=1) Then

		Dim ByteCount, BinRead, filename

		filename=ObjGeneral.DateTime()&".jpg"
		
		ByteCount = Request.TotalBytes
		
		BinRead = Request.BinaryRead(ByteCount)


			dim fso,fname, photo

			set fso=Server.CreateObject("Scripting.FileSystemObject")
		
			photo=PicturePath&filename

			Set fp = fso.CreateTextFile(photo, true, false)

			For tPoint = 1 to LenB(BinRead)
				fp.Write Chr(AscB(MidB(BinRead,tPoint,1)))
			Next

			fp.Close
			
			response.redirect("save_post.asp?filename="&filename)
		
	End If

	If(Request.Form("flag")=1) Then		
		
		nom=Request.Form("nom")
		ape=Request.Form("ape")
		ciu=Request.Form("ciu")
		pai=Request.Form("pai")
		ema=Request.Form("ema")
		cab=Request.Form("cab")
		des=Request.Form("des")
		ema_des=Request.Form("ema_des")
		filename=Request.Form("filename")
		
		if nom = "" or ape = "" then
			errores = text.Item("error.validacion.nombreapellidovacio")
		end if
		
		if ema = "" then
			errores = text.Item("error.validacion.mailvacio")
		end if
		
		if des = "" then
			errores = text.Item("error.validacion.nombreamigovacio")
		end if
		
		if ema_des = "" then
			errores = text.Item("error.validacion.mailamigovacio")
		end if
		
		'ReCaptcha
		server_response = ""
		newCaptcha = True
		  
		Set regEx = New RegExp 
		regEx.Pattern = "^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w{2,}$" 
		isEmailValid = regEx.Test(trim(ema)) 
		If(Not isEmailValid) Then errores = text.Item("error.validacion.emailinvalido")

		Set regEx = New RegExp 
		regEx.Pattern = "^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w{2,}$" 
		isEmailValid = regEx.Test(trim(ema_des))
		If(Not isEmailValid) Then errores = text.Item("error.validacion.emailamigoinvalido")
		
		for i = 2 to max_amigos
			if  Request.Form("des" & i) <> "" and Request.Form("ema_des" & i) <> "" then
				email_amigo=Request.Form("ema_des" & i)
				isEmailValid = regEx.Test( trim( email_amigo & i ) )
				If(Not isEmailValid) Then errores = text.Item("error.validacion.emailamigoinvalido")
			elseif Request.Form("des" & i) = "" and Request.Form("ema_des" & i) <> "" then
				errores = text.Item("error.validacion.nombreamigovacio")
			elseif Request.Form("des" & i) <> "" and Request.Form("ema_des" & i) = "" then
				errores = text.Item("error.validacion.mailamigovacio")
			end if
		next
		
		nom=ObjGeneral.Sanitize(nom,"string")
		ape=ObjGeneral.Sanitize(ape,"string")
		ciu=ObjGeneral.Sanitize(ciu,"string")
		pai=ObjGeneral.Sanitize(pai,"string")
		cab=ObjGeneral.Sanitize(cab,"string")
		des=ObjGeneral.Sanitize(des,"string")
		
		filename=ObjGeneral.Sanitize(filename,"string")

		If(errores="")Then
		  
			  If (server_response = "") Then
			  
					'SendMAIL -----------------------------------
					
					dim f
					Set FSO = CreateObject("Scripting.FileSystemObject")		
					
					Set f = FSO.OpenTextFile(AbsolutePathDisk & tpl_mail_registro & ".html")	
					body = f.ReadAll()
					
					link_registro = MagnoliaPosterUrl & "?PosterHash=" & filename
					
					body = replace(body, "$nombre", nom)
					body = replace(body, "$apellido", ape)
					body = replace(body, "$link", link_registro)
					body = replace(body, "$home", MagnoliaHomeUrl)
					
					'body="<html><body bgcolor='#000000' style='background:#000;font-family:arial;font-size:16px;color:#dbdc7b;'><div style='background-color:#090909;float:left;width:600px;'><img src='"&AbsoluleUrlPath&"/imgs/mail_header.jpg' width='600' /><br /><div style='width:380px;text-align:center;margin:auto;margin-top:25px;'><span style='font-size:22px;font-weight:bolder;'>"&nom&" "&ape&"</span> <span style='font-size:20px;color:#fff;'>cree que sos un convicto de BreakOut Kings!</span><br /><br />Puedes ver el afiche <a href='http://ar.aeweb.tv/breakout-kings/posterView.html?poster="&filename&"' target='_blank' style='font-weight:bold;text-decoration:underline;color:#dbdc7b;'>ingresando aqu&iacute;</a></div><br /><br clear='all' /><hr style='height:1px;color:#898989;' /><br /><div style='width:380px;text-align:center;margin:auto;'>Tu tambi&eacute;n puedes crear uno <a href='http://www.canalaetv.com/ar/breakout-kings/juego.html' target='_blank' style='font-weight:bold;text-decoration:underline;color:#dbdc7b;'>ingresando al sitio</a></span></div><br /><br clear='all' /><hr style='height:1px;color:#898989;' /><br /><img src='"&AbsoluleUrlPath&"/imgs/mail_footer.gif' width='600' /></div></body></html>"
					
					AppMailSubject = DecodeUTF8(AppMailSubject)
					
					sent=ObjGeneral.SendMail(AppMailFrom, ema_des, AppMailSubject, body)
					sent=ObjGeneral.SendMail(AppMailFrom, ema, AppMailSubject, body)
					
					for i = 2 to max_amigos
						if  Request.Form("des" & i) <> "" and Request.Form("ema_des" & i) <> "" then
							email_amigo=Request.Form("ema_des" & i)
							sent=ObjGeneral.SendMail(AppMailFrom, email_amigo, AppMailSubject, body)
						end if
					next
					
					If(sent=false) Then 
						errores = text.Item("error.validacion.sendmail")
					Else
						'Save it! ------------------------------------
						flag=ObjGeneral.saveUserPoster(nom, ape, ema, ciu, pai, cab, "", filename, "emisor")
						flag=ObjGeneral.saveUserPoster(des, "", ema_des, "", "", "", "", filename, "receptor1")
						
						rindex = 2
						for i = 2 to max_amigos
							if  Request.Form("des" & i) <> "" and Request.Form("ema_des" & i) <> "" then
								nombre_amigo = ObjGeneral.Sanitize( Request.Form("des" & i), "string" )
								email_amigo=Request.Form("ema_des" & i)
								flag=ObjGeneral.saveUserPoster(nombre_amigo, "", email_amigo, "", "", "", "", filename, "receptor" & rindex)
								rindex = rindex + 1
							end if
						next
						
						ObjGeneral.setCookie "txt_nombre",nom 
						ObjGeneral.setCookie "txt_apellido",ape
						ObjGeneral.setCookie "txt_ciudad",ciu
						ObjGeneral.setCookie "txt_pais",pai
						ObjGeneral.setCookie "txt_operador",cab
						ObjGeneral.setCookie "txt_mail",ema
						
						response.redirect("posterFinished.asp?PosterHash="&filename)

					End If

					
					
				Else
					errores = text.Item("error.validacion.captcha")
			  End If
	   
	  	 End If


	End If
	
	'Response.ContentType = "image/jpeg"
	'Response.AddHeader "Content-Disposition", "attachment;filename="&SESSION("namefile")&".jpg"
	'Response.BinaryWrite BinRead
	'response.redirect("publish.asp?PosterHash="&EncodeUTF8(session("PosterHash")))


if(Request.QueryString("filename")="") Then response.redirect(AbsoluleUrlPath)
%>

<html>
<head>
<!--#include file='includes/header.asp'-->

<script type="text/javascript">
function onButtonFacebookClick()
{
	var urlFb = 'http://www.facebook.com/sharer.php?s=100 ' + 
		'&p[url]=<%=AbsoluleUrlPath & "posterFinished.asp?PosterHash=" & request("filename")%>'+
		'&p[images][0]=<%=PictureUrl&request("filename")%>' +
		'&p[title]=<%=descripcion%> - The History Channel.';
		
	window.open(urlFb,"Facebook"); 
}

function onButtonTwitterClick()
{
	var urlTwt = 'http://twitter.com/share?count=vertical' + 
	'&text=' + escape('<%=tituloTweeer%>') +
	'&url=' + '<%=AbsoluleUrlPath & "posterFinished.asp?PosterHash=" & request("filename")%>';
	
	window.open(urlTwt,"Twitter");  
}
</script>
</head>

<body>
<div class="cont-fondo">
<div class="cont-form">
<div class="formEnviar">
	<form method="post" name="ff" action="save_post.asp?filename=<%=Request.QueryString("filename")%>">

	<div class="ingresatus"><img src="../img/tit-form.png" alt="Ingresa tus datos y los de tu amigo"></div>

	  <div class="contenedor">
		
		<div class="colIzq">
		
			<p>Nombre</p>
			<input type="text" name="nom" id="nom" value="<%=nom%>" tabindex="1" />
			<p>Ciudad</p>
			<input type="text" name="ciu" id="ciu" value="<%=ciu%>" tabindex="3" />
			<p>E-Mail</p>
			<input type="text" name="ema" id="ema" value="<%=ema%>" tabindex="5" />
			<p>Nombre del destinatario 1</p>
			<input type="text" name="des" id="des" value="<%=des%>" tabindex="7" />
			<p>Nombre del destinatario 2</p>
			<input type="text" name="des2" id="des" value="" tabindex="9" />
			<p>Nombre del destinatario 3</p>
			<input type="text" name="des3" id="des" value="" tabindex="11" />
			<p>Nombre del destinatario 4</p>
			<input type="text" name="des4" id="des" value="" tabindex="13" />
		
		</div>
		<div class="colDer">
		
			<p>Apellido</p>
			<input type="text" name="ape" id="ape" value="<%=ape%>" tabindex="2" />
			<p>Pa&iacute;s</p>
			<input type="text" name="pai" id="pai" value="<%=pai%>" tabindex="4" />
			<p>Operador de cable</p>
			<input type="text" name="cab" id="cab" value="<%=cab%>" tabindex="6" />
			<p>E-Mail del destinatario 1</p>
			<input type="text" name="ema_des" id="ema_des" value="<%=ema_des%>" tabindex="8" />
			<p>E-Mail del destinatario 2</p>
			<input type="text" name="ema_des2" id="ema_des" value="" tabindex="10" />
			<p>E-Mail del destinatario 3</p>
			<input type="text" name="ema_des3" id="ema_des" value="" tabindex="12" />
			<p>E-Mail del destinatario 4</p>
			<input type="text" name="ema_des4" id="ema_des" value="" tabindex="14" />
		
		</div>

		<br clear="all" />

		<div class="Seguridad">

		 <div class="Box">

			<div class="boton-enviar" >
				<input type="submit" class="enviarBtn" name="btnSubmit03" id="btnSubmit03" value="">
			</div>
            
		 </div>

		 <div class="botones_savepost">
			<a href="javascript:onButtonTwitterClick();" class="ico-twt-2"></a>
			<a href="javascript:onButtonFacebookClick();" class="btn-compartir"></a>
		</div>

		<br clear="all" /><br clear="all" />
		<span class="errores"><%=errores%></span>

	  </div>


	<input type="hidden" name="flag" value="1">
	<input type="hidden" name="filename" value="<%=Request.QueryString("filename")%>">

	</form>

</div>
</div>
</div>
</body>

</html>
