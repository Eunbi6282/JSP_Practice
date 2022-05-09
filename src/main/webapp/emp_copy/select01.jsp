<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>DB내용 가져와서 출력하기</title>
</head>
<body>
	<!-- DB연결 -->
	<%@ include file = "dbconn_oracle.jsp" %>
	
	<!-- DB안의 값들을 테이블 형식으로 루프를 돌면서 출력
		tr : 한 행
		th : 컬럼 이름 지정
		td : 테이블 데이터/ 루프돌면서 계속 찍게 됨
	 -->
	 
	 <table width = "500" border ="1">
	 <tr>
	 	<th>사원번호</th>
	 	<th>이름</th>
	 	<th>직책</th>
	 	<th>관리자사원번호</th>
	 	<th>고용날짜</th>
	 	<th>월급</th>
	 	<th>보너스</th>
	 	<th>부서번호</th>
	 </tr>
	 
	 <!--  DB에서 값 게더링 -->
	 <%
	 	ResultSet rs = null;	//Resultset객체는 DB테이블을 Select해서 나온 결과 레코드 셋을 담는 객체
	 	Statement stmt = null; //SQL쿼리를 담아서 실행하는 객체
	 	
	 	try{
	 		//sql변수에 sql코드 저장
	 		String sql = "select * from emp_copy";
	 		stmt = conn.createStatement(); //conn => connection(오라클의 hr계정에 연결되어 있음)
	 		rs = stmt.executeQuery(sql);
	 		
	 		//db안의 값 루프 돌리기
	 		while(rs.next()){
	 			int eno = rs.getInt("eno");
	 			String ename = rs.getString("ename");
	 			String job = rs.getString("job");
	 			int manager = rs.getInt("manager");
	 			String hiredate = rs.getString("hiredate");
	 			int salary = rs.getInt("salary");
	 			int commission = rs.getInt("commission");
	 			int dno = rs.getInt("dno");
	 %>
	 <!-- jsp끝, html시작 -->			
	 		<tr>
	 			<td> <%= eno %> </td>
	 			<td> <%= ename %> </td>
	 			<td> <%= job %> </td>
	 			<td> <%= manager %> </td>
	 			<td> <%= hiredate %> </td>
	 			<td> <%= salary %> </td>
	 			<td> <%= commission %> </td>
	 			<td> <%= dno %> </td>
	 		</tr>
	 <% 		
	 			
	 		}
	 		
	 	}catch(Exception e){
	 		out.println("테이블을 호출하는데 실패했습니다.");
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
	 
	 </table>
</body>
</html>