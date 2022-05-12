<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
 <%@ page import = "java.sql.*,java.util.*" %>
 <% request.setCharacterEncoding("EUC-KR"); %>
 <%@ include file = "dbconn_oracle.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<link href = "filegb.css" rel = "stylesheet" type = "text/css">
<title>글 삭제(실제 DataBase에 삭제를 처리하는 페이지)</title>
</head>
<body>
	<a href = "freeboard_list.jsp?go=<%= request.getParameter("page") %>" > 게시판 목록으로 이동</a>
	<p><p>
	
	<%
		String sql = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int cnt = 0;	// delete잘 됐는지 확인하는 변수
		
		// get방식으로 던지는 id값을 받아옴
		int id = Integer.parseInt(request.getParameter("id"));
	
		try{
			// DB의 비밀번호와 폼으로 넘겨온 비밀번호가 같은지 확인
			sql = "select * from freeboard where id = ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, id);
			rs = pstmt.executeQuery(); // rs에는 삭제할 레코드를 조건(get방식으로 얻어온 글의 id값)으로해서 가져옴 
			
			if(!(rs.next())){	//게시판의 데이터가 비어있다면
				out.println("해당 내용은 존재하지 않습니다.");
			}else {
				// 존재하는 경우 폼에서 넘겨받은 패스워드가 DB의 패스워드와 맞다면 삭제
				String pwd = rs.getString("password"); //DB에서 가져온 password
				if (pwd.equals(request.getParameter("password"))){
					
					sql = "delete freeboard where id = ?";
					pstmt = conn.prepareStatement(sql);
					pstmt.setInt(1, id);
					cnt = pstmt.executeUpdate();
					
					if(cnt > 0 ){
						out.println( "해당 내용은 잘 삭제 되었습니다.");
					} else {
						out.println("해당 내용은 삭제되지 않았습니다.");
					}
					
				}else {
					out.println("비밀번호가 틀렸습니다.");
				}
			}
			
			
			
		}catch(Exception e){
			out.println(e.getMessage());
		}finally{
			if (rs != null)
				rs.close();
			if (pstmt != null)
				pstmt.close();
			if (conn != null)
				conn.close();
		}
	
	%>
	
	
	
</body>
</html>