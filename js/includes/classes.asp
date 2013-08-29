<!--#include file='utf-8.asp'-->
<!--#include file='config.asp'-->
<%
dim fs
set fs=Server.CreateObject("Scripting.FileSystemObject")

Class General

Dim Conn
Dim Ob_RS
Dim condition
Dim flag
Dim flag_sent_mail

	Private sub Class_Initialize()

		Response.addHeader "pragma", "no-cache"
		Response.CacheControl = "Private"
		Response.Expires = 0
		Set Conn = Server.CreateObject( "ADODB.Connection" )
		Conn.Open = "Provider=sqloledb;Data Source=" & HostSource & ";Initial Catalog=" & DatBSource & ";User Id=" & UserSource & ";Password="&PassSource
		set Ob_RS = Server.CreateObject ("ADODB.Recordset")
		
		PathDownloads = Server.MapPath( "imgs/afiches" ) 
		
	End sub


	Public Sub CloseRS()

      	 Ob_RS.Close()

   	End Sub

	'Valid Email
	Public Function validarEmail(email) 
					dim partes, parte, i, c 
					'rompo el email en dos partes, antes y después de la arroba 
					partes = Split(email, "@") 
					if UBound(partes) <> 1 then 
					   'si el mayor indice del array es distinto de 1 es que no he obtenido las dos partes 
					   evalemail = 0 
					   exit function 
					end if 
					'para cada parte, compruebo varias cosas 
					for each parte in partes 
					   'Compruebo que tiene algún caracter 
					   if Len(parte) <= 0 then 
						  evalemail = 0 
						  exit function 
					   end if 
					   'para cada caracter de la parte 
					   for i = 1 to Len(parte) 
						  'tomo el caracter actual 
						  c = Lcase(Mid(parte, i, 1)) 
						  'miro a ver si ese caracter es uno de los permitidos 
						  if InStr("._-abcdefghijklmnopqrstuvwxyz", c) <= 0 and not IsNumeric(c) then 
							 evalemail = 0 
							 exit function 
						  end if 
					   next 
					   'si la parte actual acaba o empieza en punto la dirección no es válida 
					   if Left(parte, 1) = "." or Right(parte, 1) = "." then 
						  evalemail = 0 
						  exit function 
					   end if 
					next 
					'si en la segunda parte del email no tenemos un punto es que va mal 
					if InStr(partes(1), ".") <= 0 then 
					   evalemail = 0 
					   exit function 
					end if 
					'calculo cuantos caracteres hay después del último punto de la segunda parte del mail 
					i = Len(partes(1)) - InStrRev(partes(1), ".") 
					'si el número de caracteres es distinto de 2 y 3 
					if not (i = 2 or i = 3) then 
					   evalemail = 0 
					   exit function 
					end if 
					'si encuentro dos puntos seguidos tampoco va bien 
					if InStr(email, "..") > 0 then 
					   evalemail=0 
					   exit function 
					end if 
					evalemail = 1 
		
		validarEmail=evalemail

	End Function

	Public Function saveUserPoster(nom, ape, ema, ciu, pai, cab, des, PosterHash, accion)
		
		sqlstr="INSERT INTO thc_superhumanos_afichesUsuarios (nom, ape, ema, ciu, pai, cab, des, PosterHash, accion) VALUES ('"&nom&"', '"&ape&"', '"&ema&"', '"&ciu&"', '"&pai&"', '"&cab&"', '"&des&"', '"&PosterHash&"', '"&accion&"')"
		Ob_RS.open sqlstr, Conn, 3,1,1
		saveUserPoster=true

	End Function

	Public Function getUserPoster(PosterHash)
		
		PosterHash=Sanitize(PosterHash, "STRING")
		If(PosterHash<>"") Then
			where="WHERE PosterHash='"&PosterHash&"'"
		End If

		sqlstr="SELECT * FROM thc_superhumanos_afichesUsuarios "&where&" ORDER BY id DESC"
		'response.write(sqlstr)
		'response.end		
		Ob_RS.open sqlstr, Conn, 3,1,1	
		Set getUserPoster=Ob_RS

	End Function

	'Save error string in error log file
	Public Function SaveLogFile(errorCode, Str)
		
		Err.Clear
		On Error Resume Next
		FinalStr=DateTime()&" | Exception:"&errorCode&" | "&Str& vbcrlf 
		dim Appending
		Appending=8
		set confile = createObject("scripting.filesystemobject") 
		set fp = confile.OpenTextFile(server.mappath(ErrorFile),8) 
		fp.write(FinalStr) 
		fp.close()
		SaveLogFile=1

	End Function

	'Sql Prevent Injection
	Public Function Sanitize(str,varType) 

	  BlackList = Array("=","#","$","%","^","&","*","|",";",_
				  "<",">","'","""","(",")",_
				  "--", "/*", "*/", "@@",_
				  "cursor ","exec ","execute ","truncate ","delete ","begin ","create ","insert "," table ",_
				  "nchar", "varchar", " drop ", " alter ", "nvarchar", "iframe "_
				  )
	  On Error Resume Next 
	  Dim lstr 

	  If ( IsEmpty(str) ) Then
		'Sanitize = false
		Sanitize = str
		Exit Function
	  ElseIf ( StrComp(str, "") = 0 ) Then
		'Sanitize = false
		Sanitize = str
		Exit Function
	  End If
	  
	  lstr = LCase(str)

	  For Each s in BlackList
		If(IsExceptionList(s,varType)=False) then
			If ( InStr (lstr, s) <> 0 ) Then
				    'Sanitize = true
					'String replace
					flag=SaveLogFile(error001,"Injected character/word:"&s)
					lstr=Replace(lstr, s, "")
					STR=Sanitize(lstr, "STRING")
					'Exit Function
			End If
		End If
	  Next
	  'Sanitize = False
	  Sanitize = str
	  
	End Function 

	Public Function debugging(str)

		If Err.Number <> 0 then
		response.write(Err.Description)
		response.end
		Err.Clear
		End If

		response.write(str)
		response.end
	
	End Function

	Public Function DateTime()

		fecha_visualizar= Day(Now())&"_"&Month(Now())&"_"&Year(Now())

		intMilliseconds = Timer() - Second(Now())
        intMilliseconds = Fix(intMilliseconds * 100)

		hora_visualizar = Hour(Now())&"_"&Minute(Now())&"_"&Second(Now())&"_"&intMilliseconds

		DateTime=fecha_visualizar&"_"&hora_visualizar

	End Function

	Public function recaptcha_challenge_writer()

		  recaptcha_challenge_writer = _
		  "<script type=""text/javascript"">" & _
		  "var RecaptchaOptions = {" & _
		  "   theme : 'blackglass'," & _
		  "lang : 'es'," &_
		  "   tabindex : 1" & _
		  "};" & _
		  "</script>" & _
		  "<script type=""text/javascript"" src=""http://www.google.com/recaptcha/api/challenge?k=" & recaptcha_public_key & """></script>" & _
		  "<noscript>" & _
			"<iframe src=""http://www.google.com/recaptcha/api/noscript?k=" & recaptcha_public_key & """ frameborder=""1""></iframe><>" & _
			  "<textarea name=""recaptcha_challenge_field"" rows=""3"" cols=""50""></textarea>" & _
			  "<input type=""hidden"" name=""recaptcha_response_field""value=""manual_challenge"">" & _
		  "</noscript>"

	End Function

	Public function recaptcha_confirm(rechallenge,reresponse)

		  Dim VarString
		  VarString = _
				  "privatekey=" & recaptcha_private_key & _
				  "&remoteip=" & Request.ServerVariables("REMOTE_ADDR") & _
				  "&challenge=" & rechallenge & _
				  "&response=" & reresponse

		  Dim objXmlHttp
		  Set objXmlHttp = Server.CreateObject("Msxml2.ServerXMLHTTP")
		  objXmlHttp.open "POST", "http://www.google.com/recaptcha/api/verify", False
		  objXmlHttp.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
		  objXmlHttp.send VarString

		  Dim ResponseString
		  ResponseString = split(objXmlHttp.responseText, vblf)
		  Set objXmlHttp = Nothing

		  if ResponseString(0) = "true" then
			'They answered correctly
			 recaptcha_confirm = ""
		  else
			'They answered incorrectly
			 recaptcha_confirm = ResponseString(1)
		  end if

	End function

	Public Function SendMail(from, detination, subject, body)
		flag_sent_mail=0

		Mail.From = from
		Mail.To = detination
		Mail.Subject= subject
		Mail.HTMLBody = body
		
		On Error Resume Next

		Mail.Send
		
		If Err.Number = 0 then
			flag_sent_mail=1
		End If

		'Set Mail = Nothing

		SendMail=flag_sent_mail

	End Function

	Public Function FileExists(path, File)
		dim fs
		set fs=Server.CreateObject("Scripting.FileSystemObject")
		
		if fs.FileExists(path&File)=true then
		  FileExists=true
		else
		  FileExists=false
		end if
		set fs=Nothing
		
	End Function

	Public Function ForceDownload(path, file)

		Response.ContentType = "application/x-unknown"

		Response.AddHeader "Content-Disposition","attachment; filename=" & file

		Set adoStream = CreateObject("ADODB.Stream") 
		adoStream.Open() 
		adoStream.Type = 1 
		adoStream.LoadFromFile(server.mappath(path&file)) 
		Response.BinaryWrite adoStream.Read() 
		adoStream.Close 
		Set adoStream = Nothing 

		Response.End 

	End Function

	Public Function resizeImg(Path)

		Set Jpeg = Server.CreateObject("Persits.Jpeg")

		' Open source image
		Jpeg.Open Path

		percent=(460*100)/Jpeg.OriginalWidth
		pixelsHeight=(percent*Jpeg.OriginalHeight)/100

		Jpeg.Width = 460
		Jpeg.Height = pixelsHeight

		Jpeg.Save PathDownloads&PosterHash

	End Function

	Public Function URLDecode(sConvert)
	    Dim aSplit
	    Dim sOutput
	    Dim I
	    If IsNull(sConvert) Then
	       URLDecode = ""
	       Exit Function
	    End If

	    ' convert all pluses to spaces
	    sOutput = REPLACE(sConvert, "+", " ")

	    ' next convert %hexdigits to the character
	    aSplit = Split(sOutput, "%")

	    If IsArray(aSplit) Then
	      sOutput = aSplit(0)
	      For I = 0 to UBound(aSplit) - 1
		sOutput = sOutput & _
		  Chr("&H" & Left(aSplit(i + 1), 2)) &_
		  Right(aSplit(i + 1), Len(aSplit(i + 1)) - 2)
	      Next
	    End If


	    URLDecode = sOutput
	End Function					

	Public Function setCookie( name, value )
		Response.Cookies(name) = value
		Response.Cookies(name).Expires = DateAdd("d", 365, Now())
		'Response.Cookies(name).Expires = Date + (60 * 60* 24 * 365 )
	End Function
	
	Public Function getCookie( name )
		if Request.Cookies( name ) <> "" then
			getCookie = Request.Cookies( name )
		else
			getCookie = False
		end if
	End Function
	
End Class

		

%>
