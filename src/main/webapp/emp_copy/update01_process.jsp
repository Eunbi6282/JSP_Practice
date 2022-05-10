<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>update_process</title>
</head>
<body>
	<!-- DB연결 -->
	<%@ include file = "dbconn_oracle.jsp" %>
	
	<%
		// from에서 requset객체의 getParameter로 폼에서 넘긴 변수의 값을 받는다.
		request.setCharacterEncoding("UTF-8"); 
		
		int eno = Integer.parseInt(request.getParameter("eno"));
		String name = request.getParameter("name");
		String job = request.getParameter("job");
		int manager = Integer.parseInt(request.getParameter("manager"));
		String hiredate = request.getParameter("hiredate");
		int salary = Integer.parseInt(request.getParameter("salary"));
		int commission = Integer.parseInt(request.getParameter("commission"));
		int dno = Integer.parseInt(request.getParameter("dno"));
		
		Statement stmt = null;
		String sql = null;
		ResultSet rs = null;
		
		try{
			// 폼에서 넘겨받은 eno와 이름을 기준으로 DB의 값을 select해온다.
			sql = "select * from emp_copy where eno = '" + eno+ "'"; // 사원번호같으면 update
			//out.println(sql); //select 잘 됨
			
			stmt = conn.createStatement();
			rs = stmt.executeQuery(sql);
				//stmt.executeUpdate (sql) : Insert, update, delete
				//stmt.executeQuery(sql) : select, Resultset 객체에 값 넣기
				
			if(rs.next()){	//true => 사원이름 비교
				out.println(eno + "사원번호가 존재합니다.");
				
				// DB에서 가져온 ename과 폼에서 넘긴 name값이 일치할 때 update <manager, commission>
				int reno = rs.getInt("eno");
				String rname = rs.getString("ename");
				
				if(name.equals(rname)){
				
					// 폼에서 넘겨받은 값들로 update
				sql = "update emp_copy set manager = '" + manager + "', commission = '" + commission + "'where ename = '" + name + "'";
				stmt.executeUpdate(sql);
				out.println("테이블이 잘 업데이트 되었습니다.");
				}
				
				
			}else {
				out.println("사원의 이름이 존재하지 않습니다.");
				
			}
		} catch (Exception e){
			out.println(e.getMessage());
		}finally{
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