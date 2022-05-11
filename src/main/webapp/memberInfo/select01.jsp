<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 
<%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>DB의 내용을 가져와서 출력하기</title>
</head>
<body>
	<!--  DB연결 -->
	<%@ include file = "dbconn_oracle.jsp" %>
	
	<!--  DB안의 값들을 테이블 형식으로 루프를 돌면서 출력 
			tr : 한 행
			th : 컬럼 이름지정
			td : 테이블 데이터 / 루프돌면서 계속 찍게 됨
	-->
	<table width = "500" border = "1"> 
		<tr>
			<th> 아이디 </th>  
			<th> 이름 </th> 
			<th> 비밀번호 </th> 
			<th> email </th> 
			<th> city </th> 
			<th> phone </th>
		</tr>
		
		<!--  DB에서 값 게더링 -->
		<% 
		
		ResultSet rs = null; //Resultset 객체는 DB의 테이블을 Select해서 나온 결과 레코드 셋을 담는 객체
		Statement stmt = null; // SQL쿼리를 담아서 실행하는 객체
		
		try{
			//sql변수에 sql코드 저장
			String sql = "select * from mbTbl";
			stmt = conn.createStatement();	// conn => connection 객체(오라클의 hr계정에 연결되어있음)
			rs = stmt.executeQuery(sql); 
				//stmt.executeQuery(sql) : select한 결과를 Result 객체 저장해야 함 / re => result 객체
				// stmt.executeUpdate(sql) : insert, update,delete
			while(rs.next()){
				String id = rs.getString("id");  //id컬럼의 값을 가져와서 id변수에 담기
				String name = rs.getString("name"); // ("컬럼명")
				String pass = rs.getString("pass");
				String email = rs.getString("email");
				String city = rs.getString ("city");
				String phone = rs.getString("phone");
				
			%>
			<!-- jsp끝, html시작 -->
				<tr>
					<td> <%= id %> </td>  
					<td> <%= name %> </td> 
					<td> <%= pass %> </td> 
					<td> <%= email %> </td> 
					<td> <%= city %> </td> 
					<td> <%= phone %> </td>
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
			if (conn != null)
				conn.close();
		}
			
			%>
	
	
	
	</table>

</body>
</html>