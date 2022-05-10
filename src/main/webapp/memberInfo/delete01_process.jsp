<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>form에서 submit으로 넘겨받은 값을 DB에 삭제하는 파일</title>
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
		String sql = null;
		ResultSet rs = null;
		try{
			// 레코드 삭제, 폼에서 넘긴 ID, Passwd와 DB의 ID와 Passwd가 일치 할 때 레코드 제거, id(primary key)
			sql = "select id, pass from mbTbl where id = '" + id + "'";
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
			
			if(rs.next()) {
				//rs의 결과 레코드를 변수에 할당
				String rId = rs.getString("id");
				String rPass = rs.getString("pass");  //("컬럼명")
				
				// 패스워드가 일치하는지 확인
				if (passwd.equals(rPass)){ //폼의 password와 DB의 Password가 일치할 때
					sql = "delete mbTbl where id = '" + id + "'";	
					stmt.executeUpdate(sql);
					out.println("테이블에서 " + id + " 가 잘 삭제 되었습니다.");
					//out.println(sql);
				}else{
					out.println("패스워드가 일치하지 않습니다. ");
				}
				
			}else {
				out.println("해당 아이디는 존재하지 않습니다.");
			}
			
			
			
		}catch(Exception e){
			out.println(e.getMessage());
		}finally {
			if(rs != null)
				rs.close();
			if(stmt != null)
				stmt.close();
			if(conn != null)
				conn.close();
		}
	%>
</body>
</html>