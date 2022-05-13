<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%@ page language="java" import="java.sql.*,java.util.*,java.text.*" %>
<% request.setCharacterEncoding("EUC-KR");%>	<!-- 한글처리 부분 -->
<%@ include file = "dbconn_oracle.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>폼의 값을 받아서 DataBase에 값을 넣어주는 파일</title>
</head>
<body>
	<%
		// 폼에서 넘긴 변수흘 받아서 저장
		String na = request.getParameter("name");
		String em = request.getParameter("email");
		String sub = request.getParameter("subject");
		String cont = request.getParameter("content");
		String pw = request.getParameter("password");
		
		int id = 1;		// DB의 id컬럼에 저장할 값 
		
		int pos = 0;	// content 컬럼에 값이 들어올 때 처리할 변수
		if(cont.length() == 1 ) {
			cont = cont + " ";
		}
		
		//content(Text Area)의 enter처리해줘야 한다. => Oracle DB에 저장시에 enter에 대한 처리
				// textarea내의 '가 들어가면 DB에 insert, update시 문제 발생 => '처리해줘야 함
		
		while ((pos = cont.indexOf("\'" , pos)) != -1) {  //'의 인덱스 값을 가지고 와서 pos변수에 담기 //-1 : 값이 존재하지 않을때 까지
			String left = cont.substring(0,pos);	// left 변수 => 0번째부터 pos까지 자르기
				out.println("pos : " + pos + "<p>");
				out.println("left : " + left + "<p>");
				
			String right = cont.substring(pos, cont.length());	// right 변수 => pos부터 끝까지 자르기
				out.println("right : " + right + "<p>");
				
			cont = left + "\'" + right;
			pos += 2; 
		}
				
		
		// 오늘의 날짜 처리
		java.util.Date yymmdd = new java.util.Date();
		SimpleDateFormat myformat = new SimpleDateFormat ("yy-MM-d h:mm a");
		String ymd = myformat.format(yymmdd);
		
		String sql = null;
		Statement st = null;
		ResultSet rs = null;
		int cnt = 0;  // insert가 잘 되었는지 확인하는 변수
		
		try{
			
			// 값을 저장하기 전에 최신 글번호(id 컬럼의 max 값을 가져옴)를 가져와서 +1 을 적용한다.
			// conn (Connection) : Auto commit;	
				//commit을 명시하지 않아도 insert, update, delete 할 시 자동 커밋이 된다.
			st = conn.createStatement();
			sql = "select max(id) from freeboard";
			rs = st.executeQuery(sql);
			
			if( !(rs.next())) { //fale 라면 = rs의 값이 비어있을 때
				id = 1;
			} else {
				id = rs.getInt(1) + 1;   //첫번째 인덱스에 +1. 최대값 + 1
			}
			
			
			sql = "Insert into freeboard (id, name, password, email, subject, ";
			sql = sql + "content, inputdate, masterid, readcount, replynum , step)";
			sql = sql + " values (" + id + ",'"  + na + "','" + pw + "', '" + em ;
			sql = sql + "','" + sub + "','" + cont + "','" + ymd + "'," + id + "," ;
			sql = sql + "0,0,0)";
		
			cnt = st.executeUpdate(sql);	// cnt > 0 : Insert 성공
			
			// out.println(sql);
			
			// if (true) return;	// 여기서 멈춤
			
			if(cnt > 0 ) {
				out.println("데이터가 성공적으로 입력 되었습니다.");
			}else {
				out.println("데이터가 입력되지 않았습니다.");
			}
			
		} catch (Exception e){out.println(e.getMessage());}
		finally{
			if( rs != null)
				rs.close();
			if ( st != null)
				st.close();
			if (conn != null)
				conn.close();
		}
		
	%>
	
	 <jsp:forward page = "freeboard_list.jsp" /> 
	<!--  write 페이지에서 입력된 값은 save 로이동 -> save에서 저장된 값(DB에 저장 후)은 list 파일로 이동
	// 페이지 이동 
		jsp:forward  => 서버단에서 페이지를 이동, client의 기존 URL정보가 바뀌지 않는다. 
		respose.sendRedirect => 클라이언트에서 페이지를 재요청으로 페이지 이동, 이동하는 페이지로 URL 정보가 바뀌게 된다. 
	
	-->
	
	
</body>
</html>