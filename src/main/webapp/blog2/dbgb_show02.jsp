<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title> Insert후 출력페이지</title>
<link href = "filegb.css" rel = "stylesheet" type = "text/css" >
</head>
<body>
	<%@ include file = "dbconn_oracle.jsp" %>
	
	<%
		// 백터 컬렉션을 생성해서 DB에서 가져온 데이터를 저장하는 vector객체 생성.
		Vector name = new Vector();	// 이름 컬럼만 저장하는 Vector
		Vector email = new Vector();
		Vector subject = new Vector();
		Vector inputdate = new Vector();
		Vector content = new Vector();
		
		// 페이징 처리할 변수 선언
		int where = 1;	// 현재 위치한 페이지 번호
		int totalgroup = 0;	// 몇개의 페이지 그룹이 있는지
		int maxpage = 2;	// 출력할 페이지 개수
		int startpage = 1;	// 출력 페이지의 첫번째 레코드
		int endpage = startpage + maxpage - 1;	// 출력페이지의 마지막 레코드
		int wheregroup = 1;	// 현재 위치하는 페이지 그룹
		
		// get방식으로 페이지를 선택했을 때 
			//get방식으로 go(현재페이지) ,gogroup(현재 페이지 그룹) 변수를 받아서 처리
			// go 와 gogroup으로 start와 end 페이지를 계산해서 출력해내야 함
		if (request.getParameter("go") != null) {	// go(현재페이지번호)가 넘어올 떄
			where = Integer.parseInt(request.getParameter("go"));
			wheregroup = (where - 1) / maxpage + 1;
			startpage = (wheregroup - 1) * maxpage + 1;
			endpage = startpage + maxpage - 1;
		} else if(request.getParameter("gogroup") != null) {	//gogroup(현재페이지번호)가 넘어올 때	
				//이전 다음에 gogroup이 걸림
			wheregroup = Integer.parseInt(request.getParameter("gogroup"));
			startpage = (wheregroup - 1) * maxpage + 1;
			where = startpage;
			endpage = startpage + maxpage - 1;
		}
	
		int nextgroup = wheregroup + 1; // [다음]에 링크로 걸릴 변수	<== pagegroup
		int priorgroup = wheregroup - 1;	// [이전]에 링크로 걸릴 변수	<== pagegroup
		
		int nextpage = where + 1;	// 다음페이지
		int priorpage = where - 1;	// 이전페이지
		
		int startrow = 0;	// 특정 페이지에서 시작 레코드 번호
		int endrow = 0;		// 특정페이지에서 마지막 레코드 번호
		int maxrows = 2;	// 출력시 2개의 레코드만 출력
		int totalrows = 0;  // 총 레코드 개수 (DB에 저장되어 있는 개수) 
		int totalpages = 0;	// 
		
		// 페이징 변수 처리 끝
		
		
		
		
		
		
		
		
		String sql = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;	// select할 결과 레코드셋을 담는 객체
		
		try{
			sql = "select * from guestboard2 order by inputdate desc";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			if ( !(rs.next()) ) {	// rs(select한 결과값)이 비어있으면
				out.println("블로그에 올린 글이 없습니다.");
				
			} else {	// DB에서 가져온 값 출력 시작
				do {
	%>
				<table width = "600" border = "1">
					<tr height = "25"><td colspan = "2"> &nbsp;</td></tr>
					<tr><td colspan = "2" align = "center"><h3> <%= rs.getString("subject")%> </h3></td></tr>
					<tr>
						<td> 글쓴이 : <%= rs.getString("name") %> </td>
						<td> Email : <%= rs.getString("email") %> </td>
					</tr>
					<tr><td colspan ="2"> 작성일 : <%= rs.getString("inputdate") %> </td> </tr>
					<tr><td colspan = "2" width = "600"> <%= rs.getString("content") %> </td></tr>
					<tr height = "25"><td colspan = "2"> &nbsp;</td></tr>
				</table>
				
			
			
	<%		
				}while (rs.next());		// rs에 값이 존재하는 동안 계속 순환 
			
			
			}	// DB에서 가져온 값을 출력 끝
		
		
		} catch (Exception e) {
			out.println(e.getMessage());
		}finally {
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