<!-- #INCLUDE file = "/con_ascx2022/conlintar2022.ascx" -->

<script runat="server">
Sub Page_Load(sender As Object, e As EventArgs)
    If Not Page.IsPostBack Then
        nilai_awal()
    End If
End Sub



Sub nilai_awal()
    'LoadKuesioner()
    qry = "SELECT jumlah FROM (" & _
        "SELECT COUNT(thn) AS jumlah, 1 AS rs FROM tqvm_hslangket UNION " & _
        "SELECT (SELECT COUNT(id) FROM t_angket_jawab_mhs) + " & _
        "(SELECT COUNT(id) FROM t_angket_jawab_dsn) + " & _
        "(SELECT COUNT(id) FROM t_angket_jawab_kry) AS jumlah, 2 AS rs UNION " & _
        "SELECT COUNT(sem) AS jumlah, 3 AS rs FROM tq_hslangket UNION " & _
        "SELECT COUNT(recid) AS jumlah, 4 AS rs FROM tq_pengguna_lulusan_isi) t " & _
        "ORDER BY rs;"
        
    isidata(qry, "rsindexkegiatan")
    tutup()

    ' Kondisi pengecekan berdasarkan jumlah baris hasil query (seharusnya 4)
    Select Case dtlist.Rows.Count
        Case 4
            txtjmlvisimisi.Text = "<h3>" & dtlist.Rows(0)(0).ToString() & "</h3>"
            txtjmlkepuasan.Text = "<h3>" & dtlist.Rows(1)(0).ToString() & "</h3>"
            txtjmlpengajaran.Text = "<h3>" & dtlist.Rows(2)(0).ToString() & "</h3>"
            txtjmllulusan.Text = "<h3>" & dtlist.Rows(3)(0).ToString() & "</h3>"
        Case 3
            txtjmlvisimisi.Text = "<h3>" & dtlist.Rows(0)(0).ToString() & "</h3>"
            txtjmlkepuasan.Text = "<h3>" & dtlist.Rows(1)(0).ToString() & "</h3>"
            txtjmlpengajaran.Text = "<h3>" & dtlist.Rows(2)(0).ToString() & "</h3>"
            txtjmllulusan.Text = "<h3>0</h3>"
        Case 2
            txtjmlvisimisi.Text = "<h3>" & dtlist.Rows(0)(0).ToString() & "</h3>"
            txtjmlkepuasan.Text = "<h3>" & dtlist.Rows(1)(0).ToString() & "</h3>"
            txtjmlpengajaran.Text = "<h3>0</h3>"
            txtjmllulusan.Text = "<h3>0</h3>"
        Case 1
            txtjmlvisimisi.Text = "<h3>" & dtlist.Rows(0)(0).ToString() & "</h3>"
            txtjmlkepuasan.Text = "<h3>0</h3>"
            txtjmlpengajaran.Text = "<h3>0</h3>"
            txtjmllulusan.Text = "<h3>0</h3>"
        Case Else
            txtjmlvisimisi.Text = "<h3>0</h3>"
            txtjmlkepuasan.Text = "<h3>0</h3>"
            txtjmlpengajaran.Text = "<h3>0</h3>"
            txtjmllulusan.Text = "<h3>0</h3>"
    End Select

    dtlist.Clear()
End Sub



Function GetBoxStyle(itemIndex As Integer) As String
    ' Generate HSL color with varying hue
    Dim hue As Integer = (itemIndex * 137) Mod 360 ' Golden angle approximation for better distribution
    Dim saturation As Integer = 70 ' Fixed saturation
    Dim lightness As Integer = 85 ' Light background
    
    Return "border-top: 4px solid hsl(" & hue & ", " & saturation & "%, " & (lightness - 20) & "%);"
End Function
        


Sub btnLihatRanking_Command(sender As Object, e As CommandEventArgs)
    Dim idPemeringkatan As String = e.CommandArgument.ToString()
    HttpContext.Current.Items("idPemeringkatan") = idPemeringkatan
    Server.Transfer("dashboard.aspx")
End Sub
</script>



<section class="content-header" style="margin-top:20px;">
    <h1>
        DASHBOARD KUESIONER
        <small> &nbsp;</small>
    </h1>

    <ol class="breadcrumb">
        <li><a href="/dashboard_kuesioner/index.aspx"><i class="fa fa-dashboard"></i> Dashboard</a></li>
    </ol>
</section>



<section class= "content">
    <div class="row" style="margin-top:30px;">

        <!-- Kuesioner Visi Misi -->
        <div class="col-md-3 col-sm-6 col-xs-12">
            <div class="card text-center" style="background:#fff; border-radius:8px; box-shadow:0 2px 5px rgba(0,0,0,0.1); padding:20px;">
                <div style="font-size:50px; color:#00c0ef; margin-bottom:10px;">
                    <i class="fa-solid fa-bullseye-arrow"></i>
                </div>
                <h4>Responden Visi Misi</h4>
                    <span class="info-box-number">
                        <asp:Label ID="txtjmlvisimisi" runat="server"></asp:Label>
                    </span>
                <a href="/dashboard_kuesioner/kuesioner_visimisi/tabel_kuesioner_hasil_angket.aspx" class="btn btn-primary">Lihat Dashboard</a>
            </div>
        </div>

        <!-- Kuesioner Kepuasan -->
        <div class="col-md-3 col-sm-6 col-xs-12">
            <div class="card text-center" style="background:#fff; border-radius:8px; box-shadow:0 2px 5px rgba(0,0,0,0.1); padding:20px;">
                <div style="font-size:50px; color:#00a65a; margin-bottom:10px;">
                    <i class="fa-solid fa-face-smile-hearts"></i>
                </div>
                <h4>Responden Kepuasan</h4>
                    <span class="info-box-number">
                        <asp:Label ID="txtjmlkepuasan" runat="server"></asp:Label>
                    </span>
                <a href="/dashboard_kuesioner/kuesioner_kepuasan/tabel_angket_jawaban_kepuasan.aspx" class="btn btn-primary">Lihat Dashboard</a>
            </div>
        </div>

        <!-- Kuesioner Pengajaran -->
        <div class="col-md-3 col-sm-6 col-xs-12">
            <div class="card text-center" style="background:#fff; border-radius:8px; box-shadow:0 2px 5px rgba(0,0,0,0.1); padding:20px;">
                <div style="font-size:50px; color:#f39c12; margin-bottom:10px;">
                    <i class="fa-solid fa-books"></i>
                </div>
                <h4>Responden Pengajaran</h4>
                    <span class="info-box-number">
                        <asp:Label ID="txtjmlpengajaran" runat="server"></asp:Label>
                    </span>
                <a href="/dashboard_kuesioner/kuesioner_pengajaran/tabel_pengajaran_hasil_angket_jadi.aspx" class="btn btn-primary">Lihat Dashboard</a>
            </div>
        </div>

        <!-- Kuesioner Pengguna Lulusan -->
        <div class="col-md-3 col-sm-6 col-xs-12">
            <div class="card text-center" style="background:#fff; border-radius:8px; box-shadow:0 2px 5px rgba(0,0,0,0.1); padding:20px;">
                <div style="font-size:50px; color:#dd4b39; margin-bottom:10px;">
                    <i class="fa-solid fa-user-graduate"></i>
                </div>
                <h4>Responden Lulusan</h4>
                    <span class="info-box-number">
                        <asp:Label ID="txtjmllulusan" runat="server"></asp:Label>
                    </span>
                <a href="/dashboard_kuesioner/kuesioner_pengguna_lulusan/tabel_kuesioner_pengguna_lulusan_isi.aspx" class="btn btn-primary">Lihat Dashboard</a>
            </div>
        </div>

    </div>
</section>



<section class="content" style="margin-top:20px;">
    <!-- Ranking Categories Grid -->
    <div class="row">
        <asp:Repeater ID="rptPemeringkatan" runat="server">
            <ItemTemplate>
                <div class="col-md-4 col-sm-6 col-xs-12">
                    <div class="box" style="<%# GetBoxStyle(Container.ItemIndex) %>">
                        <div class="box-body text-center" style="padding: 20px;">
                            <img src='images/menu_images/<%# Eval("menu_image") %>' alt="Pemeringkatan Image" class="img-responsive center-block" style="max-height: 70px; margin-bottom: 10px;" />
                            <h4 style="min-height: 48px;"><%# Eval("nama_pemeringkatan") %></h4>
                            <asp:Button ID="btnLihatRanking" runat="server" 
                                Text="Lihat Dashboard" 
                                CssClass="btn btn-primary" 
                                CommandArgument='<%# Eval("id_pemeringkatan") %>'
                                OnCommand="btnLihatRanking_Command" />
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</section>



<!-- Menampilkan Icon Font Awesome Pro/Premium -->
<link rel="stylesheet" href="https://site-assets.fontawesome.com/releases/v6.4.2/css/all.css">