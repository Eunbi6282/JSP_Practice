<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import = "java.sql.*" %>

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
		
		
	
	
	
	
	
	
	
	
	%>
</body>
</html>