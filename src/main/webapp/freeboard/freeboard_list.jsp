<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page language="java" import="java.sql.*,java.util.*" %> 
<HTML>
<HEAD><TITLE>�Խ���</TITLE>
<link href="freeboard.css" rel="stylesheet" type="text/css">
<SCRIPT language="javascript">
 function check(){
  with(document.msgsearch){
   if(sval.value.length == 0){
    alert("�˻�� �Է��� �ּ���!!");
    sval.focus();
    return false;
   }	
   document.msgsearch.submit();
  }
 }
 function rimgchg(p1,p2) { 
  if (p2==1) 
   document.images[p1].src= "image/open.gif";  //document : �� �������� ���� ����
  else
   document.images[p1].src= "image/arrow.gif";
  }

 function imgchg(p1,p2) {	//mouseover�ϸ� 1, mouseout�ϸ� 2
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
<P align=center><FONT color=#0000ff face=���� size=3><STRONG>���� �Խ���</STRONG></FONT></P> 
<P>
<CENTER>
 <TABLE border=0 width=600 cellpadding=4 cellspacing=0>
  <tr align="center"> 
   <td colspan="5" height="1" bgcolor="#1F4F8F"></td>	
   <!--  colspan5 �÷� 5�� ��ħ -->
  </tr>
  <tr align="center" bgcolor="#87E8FF"> 
   <td width="42" bgcolor="#DFEDFF"><font size="2">��ȣ</font></td>
   <td width="340" bgcolor="#DFEDFF"><font size="2">����</font></td>
   <td width="84" bgcolor="#DFEDFF"><font size="2">�����</font></td>
   <td width="78" bgcolor="#DFEDFF"><font size="2">��¥</font></td>
   <td width="49" bgcolor="#DFEDFF"><font size="2">��ȸ</font></td>
  </tr>
  <tr align="center"> 
   <td colspan="5" bgcolor="#1F4F8F" height="1"></td>
  </tr>
  
 <% 	// Vector : ��Ƽ������ ȯ�濡�� ���. ��� �޼��尡 ����ȭ ó���Ǿ� �ִ�.
  Vector name=new Vector();
  Vector inputdate=new Vector();
  Vector email=new Vector();
  Vector subject=new Vector();
  Vector rcount=new Vector();	
  
  Vector step=new Vector();		// db�� step �÷��� ��� ���� ����
  Vector keyid=new Vector();	//db�� id�÷��� ��� ���� ����
  
  // ����¡ó�� ����
  
  int where=1;

  int totalgroup=0;  //������, ����� ����¡�� �׷����� �ִ� ����
  int maxpages=2;	// �ִ� ������ ����(ȭ�鿡 ��µ� ������ ����) 
  int startpage=1;	// ���� ������
  int endpage=startpage+maxpages-1;
  int wheregroup=1;	// ���� ��ġ�ϴ� �׷�
  
  
	// go : �ش� ������ ��ȣ�� �̵�
	// freeboard_list.jsp?go=3  (go='��������ȣ') => get������� ������
	// gogroup : ����� �������� �׷���
	// freeboard_list.jsp?gogroup=2 (maxpage�� 5�϶� 6,7,8,9,10 => gogroup2)
	
	//go ������ �Ѿ���� ��
		//go���� (��������ȣ)�� �Ѱܹ޾Ƽ� whreregroup, startpage, endpage ������ ���� �˾Ƴ���. ))
  if (request.getParameter("go") != null) { // go ������ ���� ������ ���� ��
   where = Integer.parseInt(request.getParameter("go")); // ���� ������ ��ȣ�� ���� ����
   wheregroup = (where-1)/maxpages + 1;	// ���� ��ġ�� �������� �׷�
   startpage=(wheregroup-1) * maxpages+1;  
   endpage=startpage+maxpages-1; 
   
   
   // gogroup������ �Ѿ���� ��
   	// gogroup������ �Ѱܹ޾Ƽ� startpage, endpage, where(������ �׷��� ù��° ������)
  } else if (request.getParameter("gogroup") != null) {  //gogroup������ ���� ������ �� ��
   wheregroup = Integer.parseInt(request.getParameter("gogroup"));
   startpage=(wheregroup-1) * maxpages+1;  
   where = startpage ; 
   endpage=startpage+maxpages-1; 
  }
  
  
  int nextgroup=wheregroup+1;   // �����׷� : ����׷� + 1
  int priorgroup= wheregroup-1;	// �����׷� : ����׷� - 1

  int nextpage=where+1;	// ���������� : ���������� + 1
  int priorpage = where-1;	// ���������� : ���������� - 1
  int startrow=0;	// �ϳ��� page���� ���ڵ� ���۹�ȣ
  int endrow=0;		// �ϳ��� page����  ���ڵ� ������ ��ȣ
  int maxrows=5;		// ����� ���ڵ� �� 
  int totalrows=0;		// �� ���ڵ� ����
  int totalpages=0;		// �� ������ ���� 
  
  
  // ����¡ó�� ��

  int id=0;

  String em=null;
  //Connection con= null;
  Statement st =null;
  ResultSet rs =null;


  // �Խ����� ����, �亯 �Խ��� ����ϴ� ����-> �׻� �� �������� ��!!!
 try {
  st = conn.createStatement();
  String sql = "select * from freeboard order by" ;
  sql = sql + " masterid desc, replynum, step, id" ;
  rs = st.executeQuery(sql);
  
  //out.println (sql);
  //if(true) return;	// ���α׷� ����

  if (!(rs.next()))  {
   out.println("�Խ��ǿ� �ø� ���� �����ϴ�");
  } else {
   do {
	   
	   // DataBase�� ���� �����ͼ� ������ Vector�� ���� -> ��� ��ȯ�ϸ鼭!
	   
    keyid.addElement(new Integer(rs.getInt("id")));		//.addElement
    	//rs�� id �÷��� �����ͼ� Vector�� ����
    name.addElement(rs.getString("name"));
    email.addElement(rs.getString("email"));
    String idate = rs.getString("inputdate");
    idate = idate.substring(0,8);  //8�ڸ����� �ڸ� / ��-��-�� ������ �ڸ�
    inputdate.addElement(idate); // idate�� inputdate�� ��´�.
    subject.addElement(rs.getString("subject"));
    rcount.addElement(new Integer(rs.getInt("readcount")));
    step.addElement(new Integer(rs.getInt("step")));
   }while(rs.next());
   
   
   totalrows = name.size();	// name Vector�� ����� ���� ����, �� ���ڵ� ��
   totalpages = (totalrows-1)/maxrows +1;
   startrow = (where-1) * maxrows;		// ���� �������� ����/ ���� ���ڵ� ��ȣ => ���� ���������� ���. id���� ������
   endrow = startrow+maxrows-1  ;		// ���� �������� ������ ���ڵ� ��ȣ
   
   
   //out.println("========= maxrow : 3�� ��=============");
   //out.println("�� ���ڵ� �� : " + totalrows + "<p>" );
   //out.println("���� ���ڵ� : " + startrow + "<p>" );
   //out.println("������ ���ڵ�: " + endrow + "<p>" );
   
   
   
   if (endrow >= totalrows)	// ������
    endrow=totalrows-1;
  
   totalgroup = (totalpages-1)/maxpages +1;  // ������ �׷���
   
   //out.println("��Ż ������ �׷�" + totalgroup + "<p>");
   
   if (endpage > totalpages) 
    endpage=totalpages;

   // ���� �������ּ� ���۷��ڵ�(startindex), ������ ���ڵ�(endindex)���� ��ȯ�ϸ鼭 ��� 
   for(int j=startrow;j<=endrow;j++) {	// j=startrow �ε��� ��ȣ
    String temp=(String)email.elementAt(j); //email Vector���� email�ּ� �������. ���� j=startrow�� 15��° ���ڵ��� 
    		// index15���濡 �ִ� �̸��� ���
    
    if ((temp == null) || (temp.equals("")) ) //�����ּҰ� ������� ��
     em= (String)name.elementAt(j); 	// em������ �̸��� �����ͼ� ��´�. 
    else
     em = "<A href=mailto:" + temp + ">" + name.elementAt(j) + "</A>"; // �����ּҰ� ���� �� �̸��� ���� ��ũ�� �Ǵ�. 

    id= totalrows-j;
     
     
    if(j%2 == 0){	// j�� ¦���� ��
     out.println("<TR bgcolor='#FFFFFF' onMouseOver=\" bgColor= '#DFEDFF'\" onMouseOut=\"bgColor=''\">");	
    } else {
     out.println("<TR bgcolor='#F4F4F4' onMouseOver=\" bgColor= '#DFEDFF'\" onMouseOut=\"bgColor='#F4F4F4'\">");
    } 
    
    // ù��° td(id)
    out.println("<TD align=center>");
    out.println(id+"</TD>");
    
    // �ι�° td (subject)
    out.println("<TD>");
    int stepi= ((Integer)step.elementAt(j)).intValue(); //step�÷��� ������ => �亯�� ����
    		// step : ���� ���� , 0 : ó����, 1 : �亯�� , 2: �亯�� �亯��
    		// ó���ۿ��� ���� ������ ����, step �� 0���� Ŭ ��(�亯��)�϶��� ȭ��ǥ����
    int imgcount = j-startrow; 
    
    if (stepi > 0 ) { // �亯���� ���
     for(int count=0; count < stepi; count++)
     out.print("&nbsp;&nbsp;"); // �亯���� ��� ����2ĭ ó��
     out.println("<IMG name=icon"+imgcount+ " src=image/arrow.gif>"); //ȭ��ǥ
     	//name=icon"+imgcount �̹����� name�� ó��
     out.print("<A href=freeboard_read.jsp?id=");
     out.print(keyid.elementAt(j) + "&page=" + where );
     out.print(" onmouseover=\"rimgchg(" + imgcount + ",1)\"");
     out.print(" onmouseout=\"rimgchg(" + imgcount + ",2)\">");
     
    } else {	// ó������ ��� 
     out.println("<IMG name=icon"+imgcount+ " src=image/close.gif>");
     out.print("<A href=freeboard_read.jsp?id=");
     out.print(keyid.elementAt(j) + "&page=" + where );
     out.print(" onmouseover=\"imgchg(" + imgcount + ",1)\"");
     out.print(" onmouseout=\"imgchg(" + imgcount + ",2)\">");
    }
    out.println(subject.elementAt(j) + "</TD>");
    // ����° td (�̸�, �̸���)
    out.println("<TD align=center>");
    out.println(em+ "</TD>");
    
    // �׹�° td (inputdate)
    out.println("<TD align=center>");
    out.println(inputdate.elementAt(j)+ "</TD>");
    
    // �ټ���° td(rcount)
    out.println("<TD align=center>");
    out.println(rcount.elementAt(j)+ "</TD>");
    out.println("</TR>"); 
    
    
    // ���� Ȯ�ο�
	    //out.println("J : " + j + "<p>"); //
	   //out.println("ID : " + keyid.elementAt(j) + "<p>");
	    //out.println("Subect : " + subject.elementAt(j) + "<p>");
	    //out.println("em : " + em + "<p>");
	    // if(true) return; // ��������� �ѹ��� �������� �ϱ� (maxrow�� 3�̹Ƿ� ���� ���� 3�� ���ƾ� ��)
   }
   
   //if(true) return;
   //for��� ������
   
   
   
   rs.close();
  }
  out.println("</TABLE>");
  st.close();
  conn.close();
 } catch (java.sql.SQLException e) {
  out.println(e);
 } 

 if (wheregroup > 1) {	// ���� ���� �ִ� �׷��� 1�̻��� �� ��ũ�ɱ� -> ó���� ������ ��ũ�ɱ�
  out.println("[<A href=freeboard_list.jsp?gogroup=1>ó��</A>]"); 
  out.println("[<A href=freeboard_list.jsp?gogroup="+priorgroup +">����</A>]");
 } else {
  out.println("[ó��]") ;
  out.println("[����]") ;
 }
 if (name.size() !=0) { 
  for(int jj=startpage; jj<=endpage; jj++) {
   if (jj==where) 
    out.println("["+jj+"]") ;
   else
    out.println("[<A href=freeboard_list.jsp?go="+jj+">" + jj + "</A>]") ;  //jj������ go�� ��Ƽ� �����
   } 
  }
  if (wheregroup < totalgroup) {
   out.println("[<A href=freeboard_list.jsp?gogroup="+ nextgroup+ ">����</A>]");
   out.println("[<A href=freeboard_list.jsp?gogroup="+ totalgroup + ">������</A>]");
  } else {
   out.println("[����]");
   out.println("[������]");
  }
  out.println ("��ü �ۼ� :"+totalrows); 
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
  <!-- stype : ������, value = 1.. : ������ �� �� -->
   <SELECT name=stype > 
    <OPTION value=1 >�̸�
    <OPTION value=2 >����
    <OPTION value=3 >����
    <OPTION value=4 >�̸�+����
    <OPTION value=5 >�̸�+����
    <OPTION value=6 >����+����
    <OPTION value=7 >�̸�+����+����
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