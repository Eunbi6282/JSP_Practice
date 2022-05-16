<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*, java.util.*" %>
<% request.setCharacterEncoding("utf-8"); %>	<!-- form에서 넘겨주는 한글 처리 -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>form에서 넘겨받은 값을 DB에 insert하는 페이지</title>
</head>
<body>
	<%@ include file = "dbconn_oracle.jsp" %> <!--  Connection 객체 -->
	
	<%
		String na = request.getParameter("name");
		String em = request.getParameter("email");
		String sub = request.getParameter("subject");
		String cont = request.getParameter("content");
		String ymd = (new java.util.Date()).toLocaleString(); // 현재 시스템의 로케일( 한국시간 가져옴)
		
	
		// 폼에서 넘긴 변수가 잘 넘어오는지 확인 .DB에 넣기전에 변수값 잘 넘어오는지 확인!!!!
		// out.println(na + "<p>");
		// out.println(em + "<p>");
		// out.println(sub + "<p>");
		// out.println(cont + "<p>");
		// out.println(ymd + "<p>");
		
		// if(true) return;
		
		String sql = null;
		Statement st = null; //sql 구문을 실행하는 객체
		
		int cnt = 0; //insert, update, delete 가 잘 적용이 되었는지 확인
			// cnt > 0; :잘 적용됨
		
		try{
			sql = "insert into guestboard2 (name, email, inputdate, subject, content)";
			sql = sql + " values( '" + na + "', '" + em + "', '" + ymd + "', '" + sub+ "', '" + cont + "')";
			// out.println(sql); 확인하기
			
			st = conn.createStatement();	// conn -> Statement 객체활성화 (XE, hr2, 1234)
			cnt = st.executeUpdate(sql);
			
			/*
			if (cnt > 0 ){
				out.print("DB에 잘 적용됐습니다.");
			}else {
				out.print("DB에 적용 실패했습니다.");
			}
			*/
			
		}catch (Exception e){
			e.getMessage();
		} finally {
			if (st != null)
				st.close();
			if (conn != null)
				conn.close();
		}
	
	%>
	  <jsp:forward page = "dbgb_show.jsp"/> 
	
</body>
</html>