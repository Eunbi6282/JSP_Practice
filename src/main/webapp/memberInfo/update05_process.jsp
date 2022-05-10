<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update</title>
</head>
<body>
	<%@ include file = "dbconn_oracle.jsp" %>
	
	<%
		//form 에서 request객체의 getParameter로 폼에서 넘긴 변수의 값을 받는다. 
		request.setCharacterEncoding("UTF-8"); // 한글이 깨지지 않도록 처리, EUC-KR, UTF-8
		
		String id = request.getParameter("id");
		String name = request.getParameter("name");
		String passwd = request.getParameter("passwd");
		String email = request.getParameter("email");
		
		PreparedStatement pstmt = null;
		ResultSet rs = null;	//select한 결과를 담는 객체, select한 레코드 셋을 담는 객체
		String sql = null;
		
		// 폼에서 넘겨받은 id와 passwd를 DB에서 가져온 ID와 PASSWD를 확인해서 일치하면 수정
		
		try{
			//폼에서 넘겨받은 id와 passwd를 기준으로 DB의 값을 select해 온다. 
			sql = "select id, pass from mbTbl where id = ?";
			//out.println(sql); -> 잘 적용되는지 구문 찍어보기
			
			pstmt = conn.prepareStatement(sql); 
			pstmt.setString(1, id);  //Parameter로 받는 변수의 id값
			
			rs = pstmt.executeQuery();
				// pstmt.executeUpdate(): insert, update, delete
				// pstmt.executeQuery() : select한 결과를 resultSet 객체로 값을 반환해줘야 한다. 
				
			if(rs.next()){  //true (아이디가 존재한다면) => 폼에서 넘긴 패스워드와 DB의 Password가 일치하는지 확인
				//out.println(id + " : 해당 아이디가 존재합니다.");
				
				// DB에서 값을 가지고 온 ID와 PASS를 변수에 할당.
					//rs => select한 결과를 담고 있음  ("컬럼명")의 값 담기
				String rId = rs.getString("id"); //ResultSet에서 가지고 온 id	//("컬럼명")
				String rPasswd = rs.getString("pass"); //ResultSet에서 가지고 온 passwd	 //("컬럼명")
				
				// 폼에서 넘겨준 값과 D에서 가져온 값이 일치하는지 확인
				if(id.equals(rId) && passwd.equals(rPasswd)){	//passwd.equals(rPasswd) 이 조건만 줘도 됨
					
					// DB에서 가져온 Password와 폼에서 넘긴 Password가 일치할 때 Update
						// sql변수 재사용
						// 폼에서 넘겨받은 값들로 update
					sql = "Update mbTbl set name = ?, email = ? where id = ?";
				pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, name);
					pstmt.setString(2, email);
					pstmt.setString(3, id);
					pstmt.executeUpdate();  
					
					
					out.println("테이블의 내용이 잘 수정되었습니다.");
					//out.println(sql);
					
				}else {		//패스워드가 일치하지않을 때
					out.println("패스워드가 일치하지 않습니다");
				}
				
			}else{	// DB에 폼에서 넘긴 ID 가 존재하지않으면
				out.println(id + " : 해당 아이디가 DataBase에 존재하지 않습니다.");
			}
		}catch(Exception e){
			out.println(e.getMessage());
			
		}finally{
			if(rs != null)
				rs.close();
			if(pstmt != null)
				pstmt.close();
			if(conn != null)
				conn.close();
		}
	%>
</body>
</html>