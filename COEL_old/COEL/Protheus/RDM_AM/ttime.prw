<html>
	<body>
		<%
			local n
			
			n := left(time(),2)
			if val(n) < 12
				%>
					Bom dia!
				<%
			else
				%>
					Boa Tarde!
				<%
			endif
		%>
	</body>
</html>
			