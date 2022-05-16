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
				do {		// DB에서 가져온 값을 Vector에 저장 -> 원하는 값만 꺼내오기 위함
					
					name.addElement(rs.getString("name"));
					email.addElement(rs.getString("email"));
					inputdate.addElement(rs.getString("inputdate"));
					subject.addElement(rs.getString("subject"));
					content.addElement(rs.getString("content"));
					
					
				}while (rs.next());		// rs에 값이 존재하는 동안 계속 순환 
				// 출력할 변수의 범위를 지정
				totalrows = name.size();	// Vector에 저장된 총 값(DB의 총 레코드 개수)
				totalpages = (totalrows - 1) / maxrows + 1;
				startrow = (where - 1) * maxrows;	// 특정페이지에서 시작 row
				endrow = startrow + maxrows - 1;	// 특정페이지에서 마지막 row
				if (endrow >= totalrows) {
					endrow = totalrows - 1;
				}
				
				totalgroup = (totalpages - 1) / maxpage + 1;	// totalgroup을 생성하는 수식
				if(endpage >= totalpages) {
					endpage = totalpages;
				}
				
				for (int j = startrow ; j <= endrow ; j++) {
					// Vector에 저장되어 있는 값을 가져와서 출력.\
					
		%>
				
				<table width = "600" border = "1">
					<tr height = "25"><td colspan = "2"> &nbsp;</td></tr>
					<tr><td colspan = "2" align = "center"><h3> <%= subject.elementAt(j) %> </h3></td></tr>
					<tr>
						<td> 글쓴이 : <%= name.elementAt(j) %> </td> 
						<td> Email : <%= email.elementAt(j) %> </td>
					</tr>
					<tr><td colspan ="2"> 작성일 : <%= inputdate.elementAt(j) %> </td> </tr>
					<tr><td colspan = "2" width = "600"> <%= content.elementAt(j) %> </td></tr>
					<tr height = "25"><td colspan = "2"> &nbsp;</td></tr>
				</table>

		<%
				}	// for문 끝
				
				//out.println("startrow" + startrow + "<p>");
				//out.println("endrow" + endrow + "<p>");
				
				// 페이징 출력
				if (wheregroup > 1) {  // wheregroup이 1이상일 때 처음을 클릭하면 처음그룹으로 가도록
					out.println("[<A href = \"dbgb_show.jsp?go=1\"> 처음 </A> ]");
					out.println("[<A href = \"dbgb_show.jsp?gogroup=" + priorgroup + "\"> 이전 </A> ]");
				} else {
					out.println("[처음]");
					out.println("[이전]");
				}
				
				// 페이징 출력
				for (int jj = startpage; jj <= endpage; jj++){
					if(jj == where){
						out.println("[" + jj + "]");
					}else {
						out.println("[<A href = \" dbgb_show.jsp?go=" + jj + "\">" + jj + "</A>]");
					}
				}
				
				if(wheregroup < totalgroup){
					out.println ("[<A href = \"dbgb_show.jsp?gogroup=" + nextgroup + "\"> 다음 </A> ]");
					out.println ("[<A href = \"dbgb_show.jsp?gogroup=" + totalgroup + "\"> 마지막 </A> ]");
				}else {
					out.println("[다음]");
					out.println("[마지막]");
				}
				out.println (where + "/" + totalpages);
				
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