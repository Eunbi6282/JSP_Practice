<%@ page contentType="text/html; charset=EUC-KR" %>  
<%@ page language="java" import="java.sql.*,java.util.*,java.text.*" %> 
<% request.setCharacterEncoding("EUC-KR"); %>

<%@ include file = "dbconn_oracle.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>폼의 값을 받아서 DataBase에 값을 넣어주는 파일</title>
</head>
<body>
<% 
	// 폼에서 넘긴 변수를 받아서 저장
	String na = request.getParameter("name");
	String em = request.getParameter("email");
	String sub = request.getParameter("subject");
	String cont = request.getParameter("content");
	String pw = request.getParameter("password");
	
	int id = 1; // DS id 컬럼에 저장할 값 => 1씩 커질거임
	
	int pos = 0; // contet 컬럼에 값이 들어올 때 처리할 변수
	if (cont.length() == 1) {
		cont = cont + " ";
	}
	
	//content(Text Area의 enter처리) => Oracle DB에 저장시 enter처리해둬야 함
	while((pos = cont.indexOf("\'" , pos)) != -1) {
		String left = cont.substring(0,pos);
		String right = cont.substring(pos, cont.length());
		cont = left + "\'" + right;
		pos += 2;
	}
	
	//오늘의 날짜 처리
	java.util.Date yymmdd = new java.util.Date();
	SimpleDateFormat myFormat = new SimpleDateFormat("yy-MM-d h:mm a");
	String ymd = myFormat.format(yymmdd);
	
	String sql = null;
	ResultSet rs = null;
	PreparedStatement pstmt = null;
	int cnt = 0; //insert가 잘 되었는지 확인하는 변수
	int temp = 0;
	
	try{
		// 값을 저장하기 전에 최신 글번호 (id 컬럼의 max값을 가져옴)을 가져와서 +1 적용한다.
		// conn (Connection) : Auto commit;
		
		sql = "select max(id) from freeboard";
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		
		if( !(rs.next())) { //rs의 값이 비어있다면
			id = 1; // 제일 처음 값
		}else {
			id = rs.getInt(1) + 1; // 첫번째 인덱스에 + 1
		}
		
		sql = "Insert into freeboard (id, name, password, email, subject, ";
		sql = sql + "content, inputdate, masterid, readcount, replynum, step)";
		sql = sql + " values (?,?,?,?,?,?,?,?,?,?,?)";
		pstmt = conn.prepareStatement(sql);
		
		pstmt.setInt(1, id);
		pstmt.setString(2, na);
		pstmt.setString(3, pw);
		pstmt.setString(4,em);
		pstmt.setString(5, sub);
		pstmt.setString(6, cont);
		pstmt.setString(7, ymd);
		pstmt.setInt(8, id);
		pstmt.setInt(9, temp);
		pstmt.setInt(10, temp);
		pstmt.setInt(11, temp);
		
		cnt = pstmt.executeUpdate();	//cnt변수에 값 넣기 
			// cnt > 0 : Insert성공. 
			//  pstmt.executeUpdate(sql); => 이 값이 int로 반환됨
		if (cnt > 0 ) {
			out.println("데이터가 성공적으로 입력되었습니다.");
		}else {
			out.println("데이터가 입력되지 않았습니다. ");
		}
		
		
	} catch (Exception e){
		out.println(e.getMessage());
	}finally {
		if(rs != null)
			rs.close();
		if (pstmt != null)
			pstmt.close();
		if(conn != null) 
			conn.close();
	}
	%>
	
</body>
</html>