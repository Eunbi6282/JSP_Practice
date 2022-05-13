<%@page import="org.apache.jasper.tagplugins.jstl.core.Out"%>
<%@page import="com.mysql.cj.xdevapi.Result"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page language="java" import="java.sql.*,java.util.*,java.text.*" %> 
<%@ include file = "dbconn_oracle.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>방명록</title>
<link href="freeboard.css" rel="stylesheet" type="text/css">
</head>
<body>

<%
					
   
	
	Vector name = new Vector();
	Vector email = new Vector();
	Vector inputdate = new Vector();
	Vector subject = new Vector();
	Vector content = new Vector();
	
	// 페이징처리 시작
	int where = 1;
	
	int totalgroup = 0;	// 마지막, 출력할 페이징의 그룹핑 최대개수
	int maxpage = 2;
	int startpage = 1;
	int endpage = startpage + maxpage - 1;
	int wheregroup = 1;	// 현재 위치하는 그룹
	
	// go 변수
	if(request.getParameter("go") != null) {
		where = Integer.parseInt(request.getParameter("go"));
		wheregroup = (where - 1) / maxpage + 1;
		endpage = startpage + maxpage - 1;
		
	// gogroup 변수
	}else if (request.getParameter("gogroup") != null){ //gogroup변수의 값을 가지고 올 때
   wheregroup = Integer.parseInt(request.getParameter("gogroup"));
   startpage = (wheregroup-1) * maxpage + 1;  
   where = startpage ; 
   endpage = startpage + maxpage - 1; 
  }
  
  
  int nextgroup = wheregroup+1;   // 다음그룹 : 현재그룹 + 1
  int priorgroup= wheregroup-1;	// 이전그룹 : 현재그룹 - 1

  int nextpage = where + 1;	// 다음페이지 : 현재페이지 + 1
  int priorpage = where - 1;	// 이전페이지 : 현재페이지 - 1
  int startrow = 0;	// 하나의 page에서 레코드 시작번호
  int endrow = 0;		// 하나의 page에서  레코드 마지막 번호
  int maxrows = 2;		// 출력할 레코드 수 
  int totalrows = 0;		// 총 레코드 개수
  int totalpages = 0;		// 총 페이지 개수 
  
  
  // 페이징처리 끝

	String sql = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	// DB값 select 해오기
	try {
		sql = "select * from guestboard order by inputdate desc";
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		
		if ( !(rs.next())) {	// 값이 없는 경우
			out.println("해당 데이터 베이스에 내용이 없습니다.");
		}else {
			
			do{
			
			name.addElement(rs.getString("name"));
		    email.addElement(rs.getString("email"));
		    inputdate.addElement(rs.getString("inputdate"));
		    subject.addElement(rs.getString("subject"));
		    content.addElement(rs.getString("content"));
			}while (rs.next());
			   
				
			totalrows = name.size();	// name Vector에 저장된 값의 개수, 총 레코드 수
			totalpages = (totalrows - 1)/maxrows + 1;
			startrow = (where - 1) * maxrows;		// 현재 페이지의 시작/ 시작 레코드 번호 => 이전 페이지에서 계산. id값과 무관함
			endrow = startrow + maxrows - 1  ;		// 현재 페이지의 마지막 레코드 번호
		
			if (endrow >= totalrows) {
			  endrow = totalrows - 1;
			 }
				
			totalgroup = (totalpages - 1) / maxpage + 1;
			
			
			if (endpage > totalpages){
				endpage = totalpages;
			}
			
			String em = null;
			// 현재 페이지애서 시작레코드(startindex), 마지막 레코드(endindex)까지 순환하면서 출력 
			for( int j = startrow; j <= endrow; j++){
				
				String temp=(String)email.elementAt(j); //email Vector에서 email주소 가지고옴. 만약 j=startrow가 15번째 레코드라면 
	    		// index15번방에 있는 이메일 출력
	    
			    if ((temp == null) || (temp.equals("")) ) { //메일주소가 비어있을 때
			    em= (String)email.elementAt(j); 
			    }// em변수에 이름만 가져와서 담는다. 
			    else {
				   em = "<A href=mailto:" + temp + ">" + email.elementAt(j) + "</A>"; // 메일주소가 있을 때 이름에 메일 링크를 건다.
			    }   
				   
				   out.println("<table width='600' cellspacing='0' cellpadding='2' align='center'>");
				   out.println("<tr>");
				   out.println("<td height='22'>&nbsp;</td></tr>");
				   out.println("<tr align='center'>");
				   out.println("<td height='1' bgcolor='#1F4F8F'></td>");
				   out.println("</tr>");
				   
				   out.println("<tr align='center' bgcolor='#DFEDFF'>");
				   out.println("<td class='button' bgcolor='#DFEDFF'>"); 
				   out.println("<div align='left'><font size='2'>"+ subject.elementAt(j) + "</div> </td>"); // 제목 출력
				   out.println("</tr>");
				   
				   out.println("<tr align='center' bgcolor='#FFFFFF'>");
				   out.println("<td align='center' bgcolor='#F4F4F4'>"); 
				   out.println("<table width='100%' border='0' cellpadding='0' cellspacing='4' height='1'>");
				   out.println("<tr bgcolor='#F4F4F4'>");
				   out.println("<td width='13%' height='7'></td>");
				   out.println("<td width='51%' height='7'>글쓴이 : "+ name.elementAt(j) +"</td>"); // 이름
				   out.println("<td width='51%' height='7'>E-mail : "+ em +"</td>");	// 이메일
				   out.println("<td width='25%' height='7'></td>");
				   out.println("<td width='11%' height='7'></td>");
				   out.println("</tr>");
				   out.println("<tr bgcolor='#F4F4F4'>");
				   out.println("<td width='13%'></td>");
				   out.println("<td width='51%'>작성일 : " + inputdate.elementAt(j) + "</td>");	//작성일
				   out.println("<td width='11%'></td>");
				   out.println("</tr>");
				   out.println("</table>");
				   out.println("</td>");
				   out.println("</tr>");
				   
				   out.println("<tr align='center'>");
				   out.println("<td bgcolor='#1F4F8F' height='1'></td>");
				   out.println("</tr>");
				   
				   out.println("<tr align='center'>");
				   out.println("<td style='padding:10 0 0 0'>");
				   out.println("<div align='left'><br>");
				   out.println("<font size='3' color='#333333'><PRE>"+ content.elementAt(j) + "</PRE></div>"); // 내용
				   out.println("<br>");
				   out.println("</td>");
				   out.println("</tr>");
				   
				   out.println("<tr align='center'>");
				   out.println("<td class='button' height='1'></td>");
				   out.println("</tr>");
				   
				   out.println("<tr align='center'>");
				   out.println("<td bgcolor='#1F4F8F' height='1'></td>");
				   out.println("</tr>");
				   
				   out.println("<tr>");
				   out.println("<td height='22'>&nbsp;</td></tr>");
				   out.println("<tr align='center'>");
			    
			}
				   out.println("</table>");	
				
		}
		
	} catch (Exception e){
		out.println(e.getMessage());
	} finally {
		if( rs != null)
			rs.close();
		if ( pstmt != null)
			pstmt.close();
		if (conn != null)
			conn.close();
	}
	
		out.println("<table>");
		out.println("<center>");
			if (wheregroup > 1) {	// 현재 내가 있는 그룹이 1이상일 때 링크걸기 -> 처음과 이전에 링크걸기
				  out.println("[<A href=dbgb_show.jsp?gogroup=1>처음</A>]"); 
				  out.println("[<A href=dbgb_show.jsp?gogroup="+priorgroup +">이전</A>]");
				 } else {
				  out.println("[처음]") ;
				  out.println("[이전]") ;
				 }
				 if (name.size() !=0) { 
				  for(int jj= startpage; jj <= endpage; jj++) {
				   if (jj == where) 
				    out.println("[" + jj + "]") ;
				   else
				    out.println("[<A href=dbgb_show.jsp?go=" + jj + ">" + jj + "</A>]") ;  //jj변수에 go를 담아서 출력함
				   } 
				  }
				  if (wheregroup < totalgroup) {
				   out.println("[<A href=dbgb_show.jsp?gogroup="+ nextgroup+ ">다음</A>]");
				   out.println("[<A href=dbgb_show.jsp?gogroup="+ totalgroup + ">마지막</A>]");
				  } else {
				   out.println("[다음]");
				   out.println("[마지막]");
				  }
				  out.println ("전체 글수 :"+totalrows); 
			 
			 out.println ("<p>");
			 
			 out.println("<a href = 'dbgb_write.htm'>");
			 out.println("<img src ='image/write.gif' border = '0'></a>");
			  
			 out.println("</center>");
		 out.println("</table>");

	%>
	
	


</body>
</html>