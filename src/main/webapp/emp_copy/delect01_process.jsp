<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Delete_process</title>
</head>
<body>
	<%@ include file = "dbconn_oracle.jsp" %>
	
	<%
		request.setCharacterEncoding("UTF-8");
	
		int eno = Integer.parseInt(request.getParameter("eno"));
		String name = request.getParameter("name");
		String job = request.getParameter("job");
		int manager = Integer.parseInt(request.getParameter("manager"));
		String hiredate = request.getParameter("hiredate");
		
		int salary = Integer.parseInt(request.getParameter("salary"));
		int commission = Integer.parseInt(request.getParameter("commission"));
		int dno = Integer.parseInt(request.getParameter("dno"));
		
		Statement stmt = null; //Statement 객체 ; sql쿼리 구문을 담아서 실행 
		String sql = null;
		ResultSet rs = null;	//select구문 위한 Resultset객체
		
		// 레코드 삭제 : 폼에서 넘긴 eno, ename과 DB안의 eno, ename이 일치할 때 코드 제거
		try{
			
			//eno 같음 설정
			sql = "select * from emp_copy where eno = '" + eno + "'";
			stmt = conn.createStatement(); //오라클 연결 객체
			rs = stmt.executeQuery(sql);	//Resultset객체 안에 넣기
			out.println(sql); //select문 잘 됨
			
			// ename같은지
			if(rs.next()){
				
				// rs의 결과 레코드를 변수에 할당
				int reno = rs.getInt("eno");
				String rname = rs.getString("ename");
				
				// 이름이 일치하는지 확인
				if(name.equals(rname)){
					
					sql = "delete emp_copy where eno = '" + eno + "'";
					stmt.executeUpdate(sql);
					out.println("삭제가 완료되었습니다.");
					
				}else {
					out.println("사원이름이 없습니다.");
				}
				
				
			}else{
				out.println("입력한 사원번호는 없습니다. ");
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