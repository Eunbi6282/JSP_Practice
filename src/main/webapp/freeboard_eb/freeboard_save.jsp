<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import = "java.sql.*, java.text.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>폼의 값을 받아서 DataBase에 값을 넣어주는 파일</title>
</head>
<body>
	<%
		// 폼에서 넘긴 변수를 받아서 저장
		String na = request.getParameter("name");
		String em = request.getParameter("email");
		String sub = request.getParameter("subject");
		String cont = request.getParameter("content");
		String pw = request.getParameter("password");
		
		int id = 1; // DB의 id컬럼에 저장할 값
		
		int pos = 0; // content 커럼에 값이 들어올 때 처리할 변수
		if(cont.length() == 1) {
			cont = cont + " ";
		}
		
		while ((pos = cont.indexOf("\'", pos)) != -1) {
			String left = cont.substring(0,pos);
			
			String right = cont.substring(pos, cont.length());
			
			cont = left + "\'" +right;
			pos += 2;
		}
		
		// 오늘의 날짜 처리
		java.util.Date yymmdd = new java.util.Date();
		SimpleDateFormat myFormat = new SimpleDateFormat ("yy-MM-d h:mm a");
		String ymd = myFormat.format(yymmdd);
		
		// id값에 +1하면서 가져오기
		String sql = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try{
			// 최신 글번호 (id컬럼의 max값 + 1)
			// conn -> autocommit
			sql = "select max(id) from freeboard";
			
			
			
			
			
			
			
		}catch(Exception e){
			out.println(e.getMessage());
		}
		
	
	
	
	
	
	
	
	
	%>
</body>
</html>