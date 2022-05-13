<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page language="java" import="java.sql.*,java.util.*" %> 
<HTML>
<HEAD><TITLE>게시판</TITLE>
<link href="freeboard.css" rel="stylesheet" type="text/css">
<SCRIPT language="javascript">
 function check(){
  with(document.msgsearch){
   if(sval.value.length == 0){
    alert("검색어를 입력해 주세요!!");
    sval.focus();
    return false;
   }	
   document.msgsearch.submit();
  }
 }
 function rimgchg(p1,p2) { 
  if (p2==1) 
   document.images[p1].src= "image/open.gif";  //document : 이 페이지의 전제 문서
  else
   document.images[p1].src= "image/arrow.gif";
  }

 function imgchg(p1,p2) {	//mouseover하면 1, mouseout하면 2
  if (p2==1) 
   document.images[p1].src= "image/open.gif";
  else
   document.images[p1].src= "image/close.gif";
 }
</SCRIPT>
</HEAD>
<BODY>
<%@ include file = "dbconn_oracle.jsp" %>
<P>
<P align=center><FONT color=#0000ff face=굴림 size=3><STRONG>자유 게시판</STRONG></FONT></P> 
<P>
<CENTER>
 <TABLE border=0 width=600 cellpadding=4 cellspacing=0>
  <tr align="center"> 
   <td colspan="5" height="1" bgcolor="#1F4F8F"></td>	
   <!--  colspan5 컬럼 5개 합침 -->
  </tr>
  <tr align="center" bgcolor="#87E8FF"> 
   <td width="42" bgcolor="#DFEDFF"><font size="2">번호</font></td>
   <td width="340" bgcolor="#DFEDFF"><font size="2">제목</font></td>
   <td width="84" bgcolor="#DFEDFF"><font size="2">등록자</font></td>
   <td width="78" bgcolor="#DFEDFF"><font size="2">날짜</font></td>
   <td width="49" bgcolor="#DFEDFF"><font size="2">조회</font></td>
  </tr>
  <tr align="center"> 
   <td colspan="5" bgcolor="#1F4F8F" height="1"></td>
  </tr>
  
 <% 	// Vector : 멀티쓰레드 환경에서 사용. 모든 메서드가 동기화 처리되어 있다.
  Vector name=new Vector();
  Vector inputdate=new Vector();
  Vector email=new Vector();
  Vector subject=new Vector();
  Vector rcount=new Vector();	
  
  Vector step=new Vector();		// db의 step 컬럼만 담는 벡터 변수
  Vector keyid=new Vector();	//db의 id컬럼을 담는 벡터 변수
  
  // 페이징처리 시작
  
  int where=1;

  int totalgroup=0;  //마지막, 출력할 페이징의 그룹핑의 최대 개수
  int maxpages=2;	// 최대 페이지 개수(화면에 출력될 페이지 개수) 
  int startpage=1;	// 시작 페이지
  int endpage=startpage+maxpages-1;
  int wheregroup=1;	// 현재 위치하는 그룹
  
  
	// go : 해당 페이지 번호로 이동
	// freeboard_list.jsp?go=3  (go='페이지번호') => get방식으로 번져줌
	// gogroup : 출력할 페이지의 그룹핑
	// freeboard_list.jsp?gogroup=2 (maxpage가 5일때 6,7,8,9,10 => gogroup2)
	
	//go 변수가 넘어왔을 때
		//go변수 (페이지번호)를 넘겨받아서 whreregroup, startpage, endpage 정보의 값을 알아낸다. ))
  if (request.getParameter("go") != null) { // go 변수의 값을 가지고 있을 때
   where = Integer.parseInt(request.getParameter("go")); // 현재 페이지 번호를 담은 변수
   wheregroup = (where-1)/maxpages + 1;	// 현재 위치한 페이지의 그룹
   startpage=(wheregroup-1) * maxpages+1;  
   endpage=startpage+maxpages-1; 
   
   
   // gogroup변수가 넘어왔을 때
   	// gogroup변수를 넘겨받아서 startpage, endpage, where(페이지 그룹의 첫번째 페이지)
  } else if (request.getParameter("gogroup") != null) {  //gogroup변수의 값을 가지고 올 때
   wheregroup = Integer.parseInt(request.getParameter("gogroup"));
   startpage=(wheregroup-1) * maxpages+1;  
   where = startpage ; 
   endpage=startpage+maxpages-1; 
  }
  
  
  int nextgroup=wheregroup+1;   // 다음그룹 : 현재그룹 + 1
  int priorgroup= wheregroup-1;	// 이전그룹 : 현재그룹 - 1

  int nextpage=where+1;	// 다음페이지 : 현재페이지 + 1
  int priorpage = where-1;	// 이전페이지 : 현재페이지 - 1
  int startrow=0;	// 하나의 page에서 레코드 시작번호
  int endrow=0;		// 하나의 page에서  레코드 마지막 번호
  int maxrows=5;		// 출력할 레코드 수 
  int totalrows=0;		// 총 레코드 개수
  int totalpages=0;		// 총 페이지 개수 
  
  
  // 페이징처리 끝

  int id=0;

  String em=null;
  //Connection con= null;
  Statement st =null;
  ResultSet rs =null;


  // 게시판의 질문, 답변 게시판 출력하는 쿼리-> 항상 저 순서여야 함!!!
 try {
  st = conn.createStatement();
  String sql = "select * from freeboard order by" ;
  sql = sql + " masterid desc, replynum, step, id" ;
  rs = st.executeQuery(sql);
  
  //out.println (sql);
  //if(true) return;	// 프로그램 종료

  if (!(rs.next()))  {
   out.println("게시판에 올린 글이 없습니다");
  } else {
   do {
	   
	   // DataBase의 값을 가져와서 각각의 Vector에 저장 -> 계속 순환하면서!
	   
    keyid.addElement(new Integer(rs.getInt("id")));		//.addElement
    	//rs의 id 컬럼을 가져와서 Vector에 저장
    name.addElement(rs.getString("name"));
    email.addElement(rs.getString("email"));
    String idate = rs.getString("inputdate");
    idate = idate.substring(0,8);  //8자리까지 자름 / 년-월-일 까지만 자름
    inputdate.addElement(idate); // idate를 inputdate에 담는다.
    subject.addElement(rs.getString("subject"));
    rcount.addElement(new Integer(rs.getInt("readcount")));
    step.addElement(new Integer(rs.getInt("step")));
   }while(rs.next());
   
   
   totalrows = name.size();	// name Vector에 저장된 값의 개수, 총 레코드 수
   totalpages = (totalrows-1)/maxrows +1;
   startrow = (where-1) * maxrows;		// 현재 페이지의 시작/ 시작 레코드 번호 => 이전 페이지에서 계산. id값과 무관함
   endrow = startrow+maxrows-1  ;		// 현재 페이지의 마지막 레코드 번호
   
   
   //out.println("========= maxrow : 3일 때=============");
   //out.println("총 레코드 수 : " + totalrows + "<p>" );
   //out.println("시작 레코드 : " + startrow + "<p>" );
   //out.println("마지막 레코드: " + endrow + "<p>" );
   
   
   
   if (endrow >= totalrows)	// 마지막
    endrow=totalrows-1;
  
   totalgroup = (totalpages-1)/maxpages +1;  // 페이지 그룹핑
   
   //out.println("토탈 페이지 그룹" + totalgroup + "<p>");
   
   if (endpage > totalpages) 
    endpage=totalpages;

   // 현재 페이지애서 시작레코드(startindex), 마지막 레코드(endindex)까지 순환하면서 출력 
   for(int j=startrow;j<=endrow;j++) {	// j=startrow 인덱스 번호
    String temp=(String)email.elementAt(j); //email Vector에서 email주소 가지고옴. 만약 j=startrow가 15번째 레코드라면 
    		// index15번방에 있는 이메일 출력
    
    if ((temp == null) || (temp.equals("")) ) //메일주소가 비어있을 때
     em= (String)name.elementAt(j); 	// em변수에 이름만 가져와서 담는다. 
    else
     em = "<A href=mailto:" + temp + ">" + name.elementAt(j) + "</A>"; // 메일주소가 있을 때 이름에 메일 링크를 건다. 

    id= totalrows-j;
     
     
    if(j%2 == 0){	// j가 짝수일 때
     out.println("<TR bgcolor='#FFFFFF' onMouseOver=\" bgColor= '#DFEDFF'\" onMouseOut=\"bgColor=''\">");	
    } else {
     out.println("<TR bgcolor='#F4F4F4' onMouseOver=\" bgColor= '#DFEDFF'\" onMouseOut=\"bgColor='#F4F4F4'\">");
    } 
    
    // 첫번째 td(id)
    out.println("<TD align=center>");
    out.println(id+"</TD>");
    
    // 두번째 td (subject)
    out.println("<TD>");
    int stepi= ((Integer)step.elementAt(j)).intValue(); //step컬럼을 가져옴 => 답변의 깊이
    		// step : 글의 깊이 , 0 : 처음글, 1 : 답변글 , 2: 답변의 답변글
    		// 처음글에는 폴더 아이콘 적용, step 이 0보다 클 때(답변글)일때는 화살표적용
    int imgcount = j-startrow; 
    
    if (stepi > 0 ) { // 답변글인 경우
     for(int count=0; count < stepi; count++)
     out.print("&nbsp;&nbsp;"); // 답변글일 경우 공백2칸 처리
     out.println("<IMG name=icon"+imgcount+ " src=image/arrow.gif>"); //화살표
     	//name=icon"+imgcount 이미지의 name값 처리
     out.print("<A href=freeboard_read.jsp?id=");
     out.print(keyid.elementAt(j) + "&page=" + where );
     out.print(" onmouseover=\"rimgchg(" + imgcount + ",1)\"");
     out.print(" onmouseout=\"rimgchg(" + imgcount + ",2)\">");
     
    } else {	// 처음글인 경우 
     out.println("<IMG name=icon"+imgcount+ " src=image/close.gif>");
     out.print("<A href=freeboard_read.jsp?id=");
     out.print(keyid.elementAt(j) + "&page=" + where );
     out.print(" onmouseover=\"imgchg(" + imgcount + ",1)\"");
     out.print(" onmouseout=\"imgchg(" + imgcount + ",2)\">");
    }
    out.println(subject.elementAt(j) + "</TD>");
    // 세번째 td (이름, 이메일)
    out.println("<TD align=center>");
    out.println(em+ "</TD>");
    
    // 네번째 td (inputdate)
    out.println("<TD align=center>");
    out.println(inputdate.elementAt(j)+ "</TD>");
    
    // 다섯번째 td(rcount)
    out.println("<TD align=center>");
    out.println(rcount.elementAt(j)+ "</TD>");
    out.println("</TR>"); 
    
    
    // 변수 확인용
	    //out.println("J : " + j + "<p>"); //
	   //out.println("ID : " + keyid.elementAt(j) + "<p>");
	    //out.println("Subect : " + subject.elementAt(j) + "<p>");
	    //out.println("em : " + em + "<p>");
	    // if(true) return; // 시험용으로 한번만 루프돌게 하기 (maxrow가 3이므로 원래 루프 3번 돌아야 함)
   }
   
   //if(true) return;
   //for블락 마지막
   
   
   
   rs.close();
  }
  out.println("</TABLE>");
  st.close();
  conn.close();
 } catch (java.sql.SQLException e) {
  out.println(e);
 } 

 if (wheregroup > 1) {	// 현재 내가 있는 그룹이 1이상일 때 링크걸기 -> 처음과 이전에 링크걸기
  out.println("[<A href=freeboard_list.jsp?gogroup=1>처음</A>]"); 
  out.println("[<A href=freeboard_list.jsp?gogroup="+priorgroup +">이전</A>]");
 } else {
  out.println("[처음]") ;
  out.println("[이전]") ;
 }
 if (name.size() !=0) { 
  for(int jj=startpage; jj<=endpage; jj++) {
   if (jj==where) 
    out.println("["+jj+"]") ;
   else
    out.println("[<A href=freeboard_list.jsp?go="+jj+">" + jj + "</A>]") ;  //jj변수에 go를 담아서 출력함
   } 
  }
  if (wheregroup < totalgroup) {
   out.println("[<A href=freeboard_list.jsp?gogroup="+ nextgroup+ ">다음</A>]");
   out.println("[<A href=freeboard_list.jsp?gogroup="+ totalgroup + ">마지막</A>]");
  } else {
   out.println("[다음]");
   out.println("[마지막]");
  }
  out.println ("전체 글수 :"+totalrows); 
 %>
<!--<TABLE border=0 width=600 cellpadding=0 cellspacing=0>
 <TR>
  <TD align=right valign=bottom>
   <A href="freeboard_write.htm"><img src="image/write.gif" width="66" height="21" border="0"></A>
   </TD>
  </TR>
 </TABLE>-->

<FORM method="post" name="msgsearch" action="freeboard_search.jsp">
<TABLE border=0 width=600 cellpadding=0 cellspacing=0>
 <TR>
  <TD align=right width="241"> 
  <!-- stype : 변수명, value = 1.. : 변수에 들어갈 값 -->
   <SELECT name=stype > 
    <OPTION value=1 >이름
    <OPTION value=2 >제목
    <OPTION value=3 >내용
    <OPTION value=4 >이름+제목
    <OPTION value=5 >이름+내용
    <OPTION value=6 >제목+내용
    <OPTION value=7 >이름+제목+내용
   </SELECT>
  </TD>
  
  <TD width="127" align="center">
   <INPUT type=text size="17" name="sval" >
  </TD>
  
  <TD width="115">&nbsp;<a href="#" onClick="check();"><img src="image/serach.gif" border="0" align='absmiddle'></A></TD>
  <TD align=right valign=bottom width="117"><A href="freeboard_write.htm"><img src="image/write.gif" border="0"></TD>
 </TR>
</TABLE>
</FORM>

</BODY>
</HTML>