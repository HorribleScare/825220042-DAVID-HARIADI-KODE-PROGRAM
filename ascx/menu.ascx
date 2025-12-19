<!-- #INCLUDE file ="./cekauthapp.ascx" -->
<script runat="server">
    Sub navbar()
        Dim asl,nm_menu as string
        Dim spath = HttpContext.Current.Request.Url.AbsolutePath
        Dim strarry As Array = spath.Split("/")
        
        asl = "/utama.aspx"

        response.write("<div class='navbar-header'>")
        response.write("<a href='" & asl & "' class='navbar-brand'><b>LINTAR</b></a>")
        response.write("<a href='' class='navbar-brand'> | </b></a>")
        response.write("<a href='/" & strarry(1) & "/index.aspx' class='navbar-brand'>")
        response.write("<b>DASHBOARD KUESIONER&nbsp;&nbsp;>> </b></a>")
        response.write("<button type='button' class='navbar-toggle collapsed' data-toggle='collapse' data-target='#navbar-collapse'>")
        response.write("<i class='fa fa-bars'></i>")
        response.write("</button>")
        response.write("</div>")
    End Sub



    Sub menu()
        cekAuthPPEPP(Session("idlintar"))

        ' --- if user has multiple roles, let them switch ---
        If (Session("isAlsoUnit") = "Ya" Or Session("isAlsoAud") = "Ya") AndAlso 
          Not String.IsNullOrWhiteSpace(Session("currentRole")) Then
            Session("authority") = Session("currentRole")
        End If

        Select Case Session("authority")
            Case "SUPERADMIN"
                Response.Write("<ul class='nav navbar-nav'>")

                Response.Write("<li class='dropdown'>")
                Response.Write("<a href='#' class='dropdown-toggle' data-toggle='dropdown'>Menu Dashboard <i class='caret'></i></a>")
                Response.Write("<ul class='dropdown-menu' role='menu'>")
                ' --- Menu Kuesioner Visi Misi ---
                writeDropdownSub("Kuesioner Visi Misi", {
                    "/dashboard_kuesioner/kuesioner_visimisi/tabel_kuesioner_angket.aspx|Pertanyaan Visi Misi",
                    "/dashboard_kuesioner/kuesioner_visimisi/tabel_kuesioner_hasil_angket.aspx|Dashboard Visi Misi",
                    "/dashboard_kuesioner/kuesioner_visimisi/tabel_kuesioner_hasil_angket_detail.aspx|Dashboard Skor Jawaban Pertanyaan Visi Misi Tahunan",
                    "/dashboard_kuesioner/kuesioner_visimisi/kmeans_clustering_visimisi.aspx|K-Means Clustering Kuesioner Visi Misi"
                })

                ' --- Menu Kuesioner Kepuasan ---
                writeDropdownSub("Kuesioner Kepuasan", {
                    "/dashboard_kuesioner/kuesioner_kepuasan/tabel_angket_soal.aspx|Pertanyaan Kepuasan",
                    "/dashboard_kuesioner/kuesioner_kepuasan/tabel_angket_jawaban_kepuasan.aspx|Dashboard Kepuasan",
                    "/dashboard_kuesioner/kuesioner_kepuasan/tabel_angket_jawaban_kepuasan_detail.aspx|Dashboard Skor Jawaban Pertanyaan Kepuasan Tahunan",
                    "/dashboard_kuesioner/kuesioner_kepuasan/kmeans_clustering_kepuasan.aspx|K-Means Clustering Kuesioner Kepuasan"
                })

                ' --- Menu Kuesioner Pengajaran ---
                writeDropdownSub("Kuesioner Pengajaran", {
                    "/dashboard_kuesioner/kuesioner_pengajaran/tabel_pengajaran_angket.aspx|Pertanyaan Pengajaran",
                    "/dashboard_kuesioner/kuesioner_pengajaran/tabel_pengajaran_hasil_angket_jadi.aspx|Dashboard Pengajaran",
                    "/dashboard_kuesioner/kuesioner_pengajaran/tabel_pengajaran_hasil_angket_jadi_detail.aspx|Dashboard Skor Jawaban Pertanyaan Pengajaran Tahunan",
                    "/dashboard_kuesioner/kuesioner_pengajaran/kmeans_clustering_pengajaran.aspx|K-Means Clustering Kuesioner Pengajaran"
                })

                ' --- Menu Kuesioner Pengguna Lulusan ---
                writeDropdownSub("Kuesioner Pengguna Lulusan", {
                    "/dashboard_kuesioner/kuesioner_pengguna_lulusan/tabel_kuesioner_pengguna_lulusan_pertanyaan.aspx|Pertanyaan Pengguna Lulusan",
                    "/dashboard_kuesioner/kuesioner_pengguna_lulusan/tabel_kuesioner_pengguna_lulusan_isi.aspx|Dashboard Pengguna Lulusan",
                    "/dashboard_kuesioner/kuesioner_pengguna_lulusan/tabel_kuesioner_pengguna_lulusan_isi_detail.aspx|Dashboard Skor Jawaban Pertanyaan Pengguna Lulusan Tahunan",
                    "/dashboard_kuesioner/kuesioner_pengguna_lulusan/kmeans_clustering_pengguna_lulusan.aspx|K-Means Clustering Kuesioner Pengguna Lulusan"
                })                      
                Response.Write("</ul>")
                Response.Write("</li>")
                
                Response.Write("<ul class='nav navbar-nav'>")

                Response.Write("<li class='dropdown'>")
                Response.Write("<a href='#' class='dropdown-toggle' data-toggle='dropdown'>Menu KPI <i class='caret'></i></a>")
                Response.Write("<ul class='dropdown-menu' role='menu'>")
                ' --- Menu Indikator Pencapaian ---
                writeDropdownSub("Indikator Pencapaian", {
                    "/dashboard_kuesioner/kuesioner_kpi/input_kpi.aspx|Input KPI",
                    "/dashboard_kuesioner/kuesioner_kpi/kpi_dashboard.aspx|Dashboard KPI"
                })
                Response.Write("</ul>")
                Response.Write("</li>")
                Response.Write("</ul>")

            Case "AUDITOR"
                Response.Write("<ul class='nav navbar-nav'>")

                Response.Write("<li class='dropdown'>")
                Response.Write("<a href='#' class='dropdown-toggle' data-toggle='dropdown'>Menu Dashboard <i class='caret'></i></a>")
                Response.Write("<ul class='dropdown-menu' role='menu'>")
                ' --- Menu Kuesioner Visi Misi ---
                writeDropdownSub("Kuesioner Visi Misi", {
                    "/dashboard_kuesioner/kuesioner_visimisi/tabel_kuesioner_hasil_angket.aspx|Dashboard Visi Misi",
                    "/dashboard_kuesioner/kuesioner_visimisi/tabel_kuesioner_hasil_angket_detail.aspx|Dashboard Skor Jawaban Pertanyaan Visi Misi Tahunan",
                    "/dashboard_kuesioner/kuesioner_visimisi/kmeans_clustering_visimisi.aspx|K-Means Clustering Kuesioner Visi Misi"
                })

                ' --- Menu Kuesioner Kepuasan ---
                writeDropdownSub("Kuesioner Kepuasan", {
                    "/dashboard_kuesioner/kuesioner_kepuasan/tabel_angket_jawaban_kepuasan.aspx|Dashboard Kepuasan",
                    "/dashboard_kuesioner/kuesioner_kepuasan/tabel_angket_jawaban_kepuasan_detail.aspx|Dashboard Skor Jawaban Pertanyaan Kepuasan Tahunan",
                    "/dashboard_kuesioner/kuesioner_kepuasan/kmeans_clustering_kepuasan.aspx|K-Means Clustering Kuesioner Kepuasan"
                })

                ' --- Menu Kuesioner Pengajaran ---
                writeDropdownSub("Kuesioner Pengajaran", {
                    "/dashboard_kuesioner/kuesioner_pengajaran/tabel_pengajaran_hasil_angket_jadi.aspx|Dashboard Pengajaran",
                    "/dashboard_kuesioner/kuesioner_pengajaran/tabel_pengajaran_hasil_angket_jadi_detail.aspx|Dashboard Skor Jawaban Pertanyaan Pengajaran Tahunan",
                    "/dashboard_kuesioner/kuesioner_pengajaran/kmeans_clustering_pengajaran.aspx|K-Means Clustering Kuesioner Pengajaran"
                })

                ' --- Menu Kuesioner Pengguna Lulusan ---
                writeDropdownSub("Kuesioner Pengguna Lulusan", {
                    "/dashboard_kuesioner/kuesioner_pengguna_lulusan/tabel_kuesioner_pengguna_lulusan_isi.aspx|Dashboard Pengguna Lulusan",
                    "/dashboard_kuesioner/kuesioner_pengguna_lulusan/tabel_kuesioner_pengguna_lulusan_isi_detail.aspx|Dashboard Skor Jawaban Pertanyaan Pengguna Lulusan Tahunan",
                    "/dashboard_kuesioner/kuesioner_pengguna_lulusan/kmeans_clustering_pengguna_lulusan.aspx|K-Means Clustering Kuesioner Pengguna Lulusan"
                })                      
                Response.Write("</ul>")
                Response.Write("</li>")
                
                Response.Write("<ul class='nav navbar-nav'>")

                Response.Write("<li class='dropdown'>")
                Response.Write("<a href='#' class='dropdown-toggle' data-toggle='dropdown'>Menu KPI <i class='caret'></i></a>")
                Response.Write("<ul class='dropdown-menu' role='menu'>")
                ' --- Menu Indikator Pencapaian ---
                writeDropdownSub("Indikator Pencapaian", {
                    "/dashboard_kuesioner/kuesioner_kpi/kpi_dashboard.aspx|Dashboard KPI"
                })
                Response.Write("</ul>")
                Response.Write("</li>")
                Response.Write("</ul>")

            Case "X"
                Page.ClientScript.RegisterStartupScript(Me.GetType(), "alert", "alert('Anda tidak memiliki akses!');window.location = '../utama.aspx'", True)
        End Select
        ' response.write("ADM : " & session("isSuperAdm") & "| AUD : " & session("isAlsoAud") & "| Unit : " & session("isAlsoUnit"))
    End Sub

    ' Build dropdown sub menu
    Private Sub writeDropdown(title As String, items As IEnumerable(Of String))
        Response.Write("<li class='dropdown'>")
        Response.Write("<a href='#' class='dropdown-toggle' data-toggle='dropdown'>" & title & "<i class='caret'></i></a>")
        Response.Write("<ul class='dropdown-menu' role='menu'>")
        For Each item As String In items
            Dim parts() As String = item.Split("|"c)
            Response.Write("<li><a href='" & parts(0) & "'>" & parts(1) & "</a></li>")
        Next
        Response.Write("</ul>")
        Response.Write("</li>")
    End Sub

    ' Build dropdown sub menu
    Private Sub writeDropdownSub(title As String, items As IEnumerable(Of String))
        Response.Write("<li class='dropdown-submenu'>")
        Response.Write("<a href='#'>" & title & "</i></a>")
        Response.Write("<ul class='dropdown-menu' role='menu'>")
        For Each item As String In items
            Dim parts() As String = item.Split("|"c)
            Response.Write("<li><a href='" & parts(0) & "'>" & parts(1) & "</a></li>")
        Next
        Response.Write("</ul>")
        Response.Write("</li>")
    End Sub

    ' Build role switcher if user has multiple roles
    Private Sub writeRoleSwitcher()
        Dim roles As New List(Of String)

        ' Add roles based on flags
        If Session("isSuperAdm") = "Ya" Then
            roles.Add("yl7jOSHAdK")
        End If
        If Session("isAlsoAud") = "Ya" Then
            roles.Add("b8KxC2Opag")
        End If

    

        ' Only show switcher if more than 1 role
        If roles.Count > 1 Then
            Response.Write("<li class='dropdown'>")
            Response.Write("<a href='#' class='dropdown-toggle' data-toggle='dropdown'>Pilihan Peran Pengguna <i class='caret'></i></a>")
            Response.Write("<ul class='dropdown-menu' role='menu'>")

            For Each r As String In roles
                Dim displayName As String = ""
                Select Case r
                    Case "yl7jOSHAdK" : displayName = "Super Admin"
                    Case "b8KxC2Opag"    : displayName = "Fakultas Admin"
                    Case Else         : displayName = r
                End Select

                Response.Write("<li><a href='change_role.aspx?r=" & r & "'>" & displayName & "</a></li>")
            Next

            Response.Write("</ul>")
            Response.Write("</li>")
        End If
    End Sub


    Sub ketAuth()
        Select Case Session("authority")
            Case "SUPERADMIN"
                Response.Write("<ul class='nav navbar-nav'>")
                ' --- Role Switcher ---
                writeRoleSwitcher()
                Response.Write("</ul>")
            Case "AUDITOR"
                Response.Write("<ul class='nav navbar-nav'>")
                writeRoleSwitcher()
                Response.Write("</ul>")          
        End Select

        ' --- Ganti tampilan role khusus AUDITOR ---
        Dim displayedRole
        If Session("authority") = "AUDITOR" Then
            displayedRole = "FAKULTAS ADMIN"
        ElseIf Session("authority") = "SUPERADMIN" Then
            displayedRole = "SUPER ADMIN"
        Else
            displayedRole = Session("authority")
        End If

        Response.Write("<li><a style='font-weight:bold;'>Peran Pengguna Anda (" & displayedRole & ")</a></li>")         
    End Sub
</script>

<nav class="navbar navbar-static-top">
  <div class="container">
    <% navbar() %>
    <!-- Collect the nav links, forms, and other content for toggling -->
    <div class="collapse navbar-collapse pull-left" id="navbar-collapse">
      <% menu() %>
    </div>
    <!-- /.navbar-collapse -->
    <!-- Navbar Right Menu -->
    <div class="navbar-custom-menu">
      <ul class="nav navbar-nav">
        <!-- User Account Menu -->
        <% ketAuth() %>
      </ul>
    </div>
    <!-- /.navbar-custom-menu -->
  </div>
  <!-- /.container-fluid -->
</nav>