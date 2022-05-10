<%@ page language="java" contentType="text/html; charset= UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update를 통한 데이터 수정</title>
</head>
<body>
	<form method = "post" action = "update01_process.jsp"> <!-- 페이지 값을 update01_process.jsp으로 넘겨줌  -->
		<p> 아이디 : <input type = "text" name = "id">
		<p> 패스워드 : <input type = "password" name = "passwd">
		<p> 이름 : <input type = "text" name = "name">
		<p> 이메일 : <input type = "text" name = "email">
		<p> <input type = "submit" value = "전송">
		<!--submit누르면 action 페이지 호출  -->
	</form>
</body>
</html>