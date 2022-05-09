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
	<%@ include file = "dbconn_oracle.jsp" %>
	<!-- dbconn_oracle.jsp파일의 코드가 그대로 file안에 들어가 있다. -->
	
	<%
		request.setCharacterEncoding("UTF-8");	// Insert01.jsp에서 넘긴 한글 처리
		
		int eno = Integer.parseInt(request.getParameter("eno"));
		String name = request.getParameter("name");
		String job = request.getParameter("job");
		int manager = Integer.parseInt(request.getParameter("manager"));
		String hiredate = request.getParameter("hiredate");
		
		int salary = Integer.parseInt(request.getParameter("salary"));
		int commission = Integer.parseInt(request.getParameter("commission"));
		int dno = Integer.parseInt(request.getParameter("dno"));
		
		Statement stmt = null; //Statement 객체 ; sql쿼리 구문을 담아서 실행
		
		try{
			
			String sql = 
			"Insert into emp_copy (eno, ename, job, manager, hiredate, salary, commission , dno) values("+eno+", '"+name+"', '"+job+"', "+manager+", '"+hiredate+"', "+salary+", "+commission+", "+dno+")";
			
			
			stmt = conn.createStatement();
			stmt.execute(sql);
			out.println("테이블 삽입 성공");
		} catch (Exception e){
			out.println("emp_copy 테이블 삽입을 실패했습니다.");
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