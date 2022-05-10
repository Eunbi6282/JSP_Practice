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
<!-- 
	Statement :
		- 단일로 한번만 실행할 때 빠른 속도를 가진다. 
		- 쿼리에 인자를 부여할 수 없다. 변수를 쿼리에 적용할 때 따옴표 처리를 잘 해줘야 한다.
		- 매번 컴파일을 수행해야 한다. (cache를 사용하지 않는다.)
		
	
	PreparedStatement :
		- 쿼리에 인자를 부여할 수 있다. (?)로 부여. ?인자에 변수를 할당한다.
		- 처음 컴파일 된 이후, 그 이후에는 컴파일을 수행하지 않는다. (cache 사용)
		- 여러번 수행할 때 빠른 속도를 가진다.
 -->

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
		PreparedStatement pstmt = null; // SQL쿼리를 담아서 실행하는 객체
		
		try{
			//sql변수에 sql코드 저장
			String sql = "select * from mbTbl";
			pstmt = conn.prepareStatement(sql);	//PreparedStatement는 객체 생성시에 sql쿼리를 넣는다.
			rs = pstmt.executeQuery(); 
				// pstmt.executeQuery() : select한 결과를 Result 객체 저장해야 함 / re => result 객체
				// pstmt.executeUpdate() : insert, update,delete
			while(rs.next()){
				String id = rs.getString("id");  //id컬럼의 값을 가져와서 id변수에 담기
				String name = rs.getString("name");
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
			if(pstmt != null)
				pstmt.close();
			if (conn != null)
				conn.close();
		}
			
			%>
	
	
	
	</table>

</body>
</html>