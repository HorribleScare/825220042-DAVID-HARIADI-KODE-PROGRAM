<!-- #INCLUDE file ="../con_ascx2022/conlintar2022.ascx" -->
<!-- #INCLUDE file ="../con_ascx2022/con_mutu.ascx" -->
<script runat="server">
    Sub page_load(o As Object, e As EventArgs)
        Dim qrystring As String = Request.QueryString("r")
        Dim currRoleConvert As String
        Select Case qrystring
            Case "yl7jOSHAdK"
                qry = "SELECT nik from ppepp_super_admin where nik = '"& session("idlintar") &"'"
                currRoleConvert = "SUPERADMIN"
            Case "b8KxC2Opag"
                qry = "SELECT nik from ppepp_auditor where nik = '"& session("idlintar") &"'"
                currRoleConvert = "AUDITOR"               
            Case Else
                session.RemoveAll()
                response.write("<b>Anda tidak memiliki akses</b>")
                Exit Sub
        End Select
        isidataMT(qry,"cekauthority")
        tutupMT()
        If dtlistMT.Rows.Count <> 0 Then
            dtlistMT.Clear
            session("currentRole") = currRoleConvert
            response.Redirect("index.aspx")
        Else
            dtlistMT.Clear
            session.RemoveAll()
            response.Redirect("lintar.untar.ac.id")
            response.write("<b>Anda tidak memiliki akses</b>")
        End If
	End Sub
</script>