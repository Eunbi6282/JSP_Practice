<%@ page contentType="text/html; charset=EUC-KR" %>  
<%@ page language="java" import="java.sql.*,java.util.*,java.text.*" %> 
<% request.setCharacterEncoding("EUC-KR"); %>

<%@ include file = "dbconn_oracle.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>���� ���� �޾Ƽ� DataBase�� ���� �־��ִ� ����</title>
</head>
<body>
<% 
	// ������ �ѱ� ������ �޾Ƽ� ����
	String na = request.getParameter("name");
	String em = request.getParameter("email");
	String sub = request.getParameter("subject");
	String cont = request.getParameter("content");
	String pw = request.getParameter("password");
	
	int id = 1; // DS id �÷��� ������ �� => 1�� Ŀ������
	
	int pos = 0; // contet �÷��� ���� ���� �� ó���� ����
	if (cont.length() == 1) {
		cont = cont + " ";
	}
	
	//content(Text Area�� enteró��) => Oracle DB�� ����� enteró���ص־� ��
	while((pos = cont.indexOf("\'" , pos)) != -1) {
		String left = cont.substring(0,pos);
		String right = cont.substring(pos, cont.length());
		cont = left + "\'" + right;
		pos += 2;
	}
	
	//������ ��¥ ó��
	java.util.Date yymmdd = new java.util.Date();
	SimpleDateFormat myFormat = new SimpleDateFormat("yy-MM-d h:mm a");
	String ymd = myFormat.format(yymmdd);
	
	String sql = null;
	ResultSet rs = null;
	PreparedStatement pstmt = null;
	int cnt = 0; //insert�� �� �Ǿ����� Ȯ���ϴ� ����
	int temp = 0;
	
	try{
		// ���� �����ϱ� ���� �ֽ� �۹�ȣ (id �÷��� max���� ������)�� �����ͼ� +1 �����Ѵ�.
		// conn (Connection) : Auto commit;
		
		sql = "select max(id) from freeboard";
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery();
		
		if( !(rs.next())) { //rs�� ���� ����ִٸ�
			id = 1; // ���� ó�� ��
		}else {
			id = rs.getInt(1) + 1; // ù��° �ε����� + 1
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
		
		cnt = pstmt.executeUpdate();	//cnt������ �� �ֱ� 
			// cnt > 0 : Insert����. 
			//  pstmt.executeUpdate(sql); => �� ���� int�� ��ȯ��
		if (cnt > 0 ) {
			out.println("�����Ͱ� ���������� �ԷµǾ����ϴ�.");
		}else {
			out.println("�����Ͱ� �Էµ��� �ʾҽ��ϴ�. ");
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