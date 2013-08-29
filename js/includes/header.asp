<!--#include file='utf-8.asp'-->
<%
Randomize
swfrand = Int((rnd*10))+1
%>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:og="http://opengraphprotocol.org/schema/" xmlns:fb="http://developers.facebook.com/schema/"> 
<head>
	<script type="text/javascript">var _sf_startpt=(new Date()).getTime()</script> 
	<title><%=titleWeb%></title>
	<link rel="stylesheet" type="text/css" href="../css/styles.css" />
	<script type="text/javascript" src="../js/functions.js"></script>
	<script type="text/javascript" src="../js/swfobject.js"></script>
	<script type="text/javascript">
		var flashvars = {};
		var params = {};
		params.wmode = "transparent";
		var attributes = {};
		swfobject.embedSWF("../fla/CharacterCreator.swf?id=<%=swfrand%>", "characterCreator", "448", "668", "10.0.0", false, flashvars, params, attributes);
	</script>
	<meta name="Description" content="<%=descripcion%>" />
	<meta name="Keywords" content="<%=keywords%>" />
	<meta name="Author" content="<%=author%>" />
	<meta http-equiv="Cache-Control" content="no-cache" />
	<meta http-equiv="Pragma" content="no-cache" />
	<meta http-equiv="Expires" content="0" />
	<meta http-equiv="content-type" content="text/html; charset=<%=encoding%>" />
	
	<%
	If(Request.QueryString("t")="")Then 
		titlePost=titleWeb
	Else
		titlePost=Request.QueryString("t")
	End If

	If(Request.QueryString("d")="")Then 
		descripcionPost=descripcion
	Else
		descripcionPost=Request.QueryString("d")
	End If

	If(Request.QueryString("i")="")Then 
		image=AbsoluleUrlPath&"imgs/bg_viewer.jpg"
	Else
		image=Request.QueryString("i")
	End If
	%>

		<meta property="og:title" content="<%=titlePost%>" /> 
		<meta property="og:type" content="article" /> 
		<meta property="og:url" content="ar.tuhistory.com/home.html" /> 
		<meta property="og:site_name" content="tuhistory.com" /> 
		<meta property="og:image" content="<%=image%>" /> 
		<meta property="og:description" content="<%=DecodeUTF8(descripcionPost)%>" /> 
</head>

<%
LeftDays=DateDiff("d", Now(), "24/10/2010")
%>
