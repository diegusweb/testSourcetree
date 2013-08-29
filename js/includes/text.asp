<%

dim text
set text = Server.CreateObject("Scripting.Dictionary")

text.Add "error.validacion.nombreapellidovacio", "Debes completar tu nombre y apellido"
text.Add "error.validacion.mailvacio", "Debes completar tu e-mail"
text.Add "error.validacion.nombreamigovacio", "Debes completar el nombre de tu amigo"
text.Add "error.validacion.mailamigovacio", "Debes completar el e-mail de tu amigo"
text.Add "error.validacion.emailinvalido", "Tu E-mail no es válido, ingrésalo nuevamente"
text.Add "error.validacion.emailamigoinvalido", "E-mail del destinatario no es válido, ingrésalo nuevamente"
text.Add "error.validacion.sendmail", "El E-mail no ha sido enviado por inconvenientes técnicos, intente luego por favor"
text.Add "error.validacion.captcha", "El código de seguridad es inválido"

%>