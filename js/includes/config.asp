<%
Dim HostSource
Dim UserSource
Dim PassSource
Dim DatBSource
Dim AbsoluleUrlPath
Dim AbsolutePathDisk
Dim mailfromserver
Dim error001

'App data
AppMailFrom = "emmanuel.montes@dcoworks.com"
AppMailSubject = "¡TU TAMBIÉN PUEDES SER UN SUPERHUMANO!"

'PRODUCCION CNX
HostSource="localhost,1433"
UserSource="sa"
PassSource="SQL+2005-sa"
DatBSource="his_thc"
AbsoluleUrlPath="http://192.168.0.9:8080/mg/backstory/history/super-humanos/iis/"
MagnoliaHomeUrl="http://192.168.0.15:8080/tuhistory-author/super-humanos.html"
MagnoliaPosterUrl="http://192.168.0.15:8080/tuhistory-author/super-humanos-poster.html"

'ABZ LOCAL CNX
'HostSource="localhost"
'UserSource="sa"
'PassSource="microsoft"
'DatBSource="breakoutkings_abz"
'AbsoluleUrlPath="http://192.168.1.169/A&E/BOK/"

AbsolutePathDisk=request.serverVariables("APPL_PHYSICAL_PATH")&"mg/backstory/history/super-humanos/iis/"
PicturePath=request.serverVariables("APPL_PHYSICAL_PATH")&"mg/backstory/history/super-humanos/pics/"
PictureUrl=AbsoluleUrlPath&"../pics/"

mailfromserver="info@dcoworks.com"

'Meta headers vars
titleWeb="SuperHumanos: Latinoamerica"
keywords="Super Humanos"
encoding="utf-8"
descripcion="SuperHumanos: Latinoamerica"
author="http://www.backstory.com.ar"

'Error vars
ErrorFile="error_logs.dat"
error001="Sql front injection."

'Mail Config
dim Mail 
Set Mail = CreateObject("CDO.Message") 
Mail.From = "The History Channel <" & mail_from & ">"

Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2 
Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 0 'basic (clear-text) authentication
Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "mail.dcoworks.com"
Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusername") = "info@dcoworks.com"
Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendpassword") = "pzeta"
Mail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25	
Mail.Configuration.Fields.Update

tpl_mail_registro = "tpl-mail-registro"

'CookieExpire
TimeExpire=Date + 1

tituloTweeer = "SuperHumanos"

%>
