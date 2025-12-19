<!-- #INCLUDE file ="../../con_ascx2022/conlintar2022.ascx" -->
<!-- #INCLUDE file ="../../con_ascx2022/con_mutu.ascx" -->
<!-- #INCLUDE file ="../../con_ascx2022/consadar.ascx" -->
<!-- #INCLUDE file ="../../con_ascx2022/conndecole_untar.ascx" -->

<script runat="server">

    Sub cekAuthPPEPP(nik As String)
        Dim isSuperAdmin As Boolean = isExists("SELECT nik FROM ppepp_super_admin WHERE nik='" & nik & "'")
        Dim isAuditor As Boolean = isExists("SELECT nik FROM ppepp_auditor WHERE nik='" & nik & "'")

        If isSuperAdmin Then
            Session("authority") = "SUPERADMIN"
            Session("isSuperAdm") = "Ya"
            Session("isAlsoAud") = If(isAuditor, "Ya", "Tidak")

            ' cek role tambahan (kaprodi / operator unit)
            cekUnitRole(nik, True)
        ElseIf isAuditor Then
            Session("authority") = "AUDITOR"
            Session("isAlsoAud") = If(isAuditor, "Ya", "Tidak") 
            cekUnitRole(nik, True)
        Else
            ' Bukan superadmin dan bukan auditor → cek apakah kaprodi / operator unit
            If cekUnitRole(nik, False) = False Then 
                Session("authority") = "X"
                Session("idunitkerjalogin") = "NOTFOUND"
            End If
        End If

    End Sub

    ' Cek apakah query menghasilkan data
    Private Function isExists(qry As String) As Boolean
        isidataMT(qry, "tmpCheck")
        Dim result As Boolean = (dtlistMT.Rows.Count > 0)
        dtlistMT.Clear()
        tutupMT()
        Return result
    End Function

    ' Cek apakah NIK punya role kaprodi atau operator unit
    ' Return True kalau ketemu, False kalau tidak
    Private Function cekUnitRole(nik As String, Optional markAlsoUnit As Boolean = False) As Boolean
        ' cek kaprodi / sekprodi
        Dim qry As String = "SELECT kode_jurnim FROM tjurus3 " &
                            "WHERE nik_kaprodi='" & nik & "' OR nik_sekprodi='" & nik & "' OR nik_sekprodi2='" & nik & "'"
        isidata(qry, "cekJabatan")
        tutup()

        If dtlist.Rows.Count > 0 Then
            ' kaprodi ditemukan → cari unitnya
            qry = "SELECT id_unitkerja FROM ppepp_unitkerja WHERE kode_jurnim='" & dtlist.Rows(0)("kode_jurnim") & "'"
            isidataMT2(qry, "getUnit")
            tutupMT()

            If dtlistMT2.Rows.Count > 0 Then
                If Session("authority") Is Nothing OrElse Session("authority") = "AUDITOR" OrElse Session("authority") = "SUPERADMIN" Then
                    Session("isKProd") = "Ya"
                    If markAlsoUnit Then Session("isAlsoUnit") = "Ya" Else Session("authority") = "UNIT"
                    Session("idunitkerjalogin") = dtlistMT2.Rows(0)("id_unitkerja")
                End If
                dtlistMT2.Clear()
                dtlist.Clear()
                Return True
            Else
                Session("isAlsoUnit") = "Tidak"
                Return False
            End If
            dtlistMT2.Clear()
        End If
        dtlist.Clear()

        ' jika bukan kaprodi → cek operator unit
        qry = "SELECT nik, id_unitkerja FROM ppepp_operator_unit WHERE nik='" & nik & "'"
        isidataMT3(qry, "cekOpUnit")
        tutupMT()

        If dtlistMT3.Rows.Count > 0 Then
            If Session("authority") Is Nothing OrElse Session("authority") = "AUDITOR" OrElse Session("authority") = "SUPERADMIN" Then
                Session("isKProd") = "Tidak"
                If markAlsoUnit Then Session("isAlsoUnit") = "Ya" Else Session("authority") = "UNIT"
                Session("idunitkerjalogin") = dtlistMT3.Rows(0)("id_unitkerja")        
            End If
            dtlistMT3.Clear()
            Return True
        Else
            Session("isAlsoUnit") = "Tidak"
            Return False            
        End If

        dtlistMT3.Clear()
        Return False
    End Function

</script>