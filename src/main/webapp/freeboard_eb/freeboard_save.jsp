<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import = "java.sql.*, java.text.*" %>

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
		
		int id = 1; // DB�� id�÷��� ������ ��
		
		int pos = 0; // content Ŀ���� ���� ���� �� ó���� ����
		if(cont.length() == 1) {
			cont = cont + " ";
		}
		
		while ((pos = cont.indexOf("\'", pos)) != -1) {
			String left = cont.substring(0,pos);
			
			String right = cont.substring(pos, cont.length());
			
			cont = left + "\'" +right;
			pos += 2;
		}
		
		// ������ ��¥ ó��
		java.util.Date yymmdd = new java.util.Date();
		SimpleDateFormat myFormat = new SimpleDateFormat ("yy-MM-d h:mm a");
		String ymd = myFormat.format(yymmdd);
		
		// id���� +1�ϸ鼭 ��������
		String sql = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try{
			// �ֽ� �۹�ȣ (id�÷��� max�� + 1)
			// conn -> autocommit
			sql = "select max(id) from freeboard";
			
			
			
			
			
			
			
		}catch(Exception e){
			out.println(e.getMessage());
		}
		
	
	
	
	
	
	
	
	
	%>
</body>
</html>