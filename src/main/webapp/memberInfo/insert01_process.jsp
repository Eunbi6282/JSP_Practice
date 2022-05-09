<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>form에서 submit으로 넘겨받은 값을 DB에 저장하는 파일</title>
</head>
<body>
	
	<%@ include file = "dbconn_oracle.jsp"%>
	
	<!-- dbconn_oracle.jsp파일의 코드가 그대로 file안에 들어가 있다. -->
	
	<%
		request.setCharacterEncoding("UTF-8");	// Insert01.jsp폼에서 넘긴 한글 처리하기 위함. 
		
		String id = request.getParameter("id"); //Insert01.jsp폼에서 넘겨준 값들 변수에 저장
		String passwd = request.getParameter("passwd");
		String name = request.getParameter("name");
		String email = request.getParameter("email");
	
	
	
		Statement stmt = null; //Statement 객체 : sql 쿼리 구문을 담아서 실행하는 객체
		try{
			// id, pass, name, email 의 값은 문자열이므로 ''들어감/ 변수에 값 넣기
			String sql = 
			"Insert into mbTbl (idx ,id , pass, name, email) values (seq_mbTbl_idx.nextval, '" + id + "','" + passwd + "','" + name + "','" + email + "')";
			
			stmt = conn.createStatement();	//connection 객체를 통해서 statement 객체 생성
			// conn은 include file = "dbconn_oracle.jsp에 들어가 있음
			stmt.executeUpdate(sql); //statement객체를 통해서 sql을 실행함
				// stmt.executeUpdate(sql) : sql 구문에 Insert,Update, Delete 구문이 온다.
				// stmt.executeQuery(sql) : Sql 구문에 select문이 오면서 select한 결과를 Result 객체로 반환.
				
		out.println("테이블 삽입에 성공 했습니다.");
			

		}catch(Exception e){
			out.println("mbTbl 테이블 삽입을 실패했습니다.");
			out.println(e.getMessage());
		}finally {
			if(stmt != null)
				stmt.close();
			if(conn != null)
				conn.close();
		}
		
	
	
	
	
	%>
	
	
	
	
</body>
</html>