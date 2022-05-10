<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form method = "post" action = "insert05_process.jsp"> <!-- 페이지 값을 insert01_process.jsp으로 넘겨줌  -->
		<p> 아이디 : <input type = "text" name = "id">
		<p> 패스워드 : <input type = "password" name = "passwd">
		<p> 이름 : <input type = "text" name = "name">
		<p> 이메일 : <input type = "text" name = "email">
		<p> <input type = "submit" value = "전송">
		<!--submit누르면 action 페이지 호출  -->
	</form>
<!-- 
	method = "post"
		-- http 헤더 앞에 값을 넣어전송, 보안이 강하다. 전송용량에 제한이 없다. => 파일 전송 할 때
		-- 아이디, 패스워드는 중요 정보이므로 post방식으로 전송
	
	
	
	method = "get"
		-- http 헤더 뒤에 붚여서 값을 전송, 보안에 취약하다. 전송량이 제한을 가지고 있다.
		-- 게시판에서 사용. 

 -->

</body>
</html>