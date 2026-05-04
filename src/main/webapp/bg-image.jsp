<%@ page import="java.io.File,java.io.FileInputStream,java.io.OutputStream" %><%
    String imagePath = "C:\\Users\\shant\\.gemini\\antigravity\\brain\\b19e8e73-f792-4e0b-b991-8dd2052fbe2b\\media__1777894228270.jpg";
    File imageFile = new File(imagePath);
    if(imageFile.exists()) {
        response.setContentType("image/jpeg");
        response.setContentLength((int) imageFile.length());
        FileInputStream in = new FileInputStream(imageFile);
        OutputStream outStream = response.getOutputStream();
        byte[] buf = new byte[4096];
        int count = 0;
        while ((count = in.read(buf)) >= 0) {
            outStream.write(buf, 0, count);
        }
        outStream.close();
        in.close();
        out.clear();
        out = pageContext.pushBody();
    } else {
        response.sendError(HttpServletResponse.SC_NOT_FOUND);
    }
%>
