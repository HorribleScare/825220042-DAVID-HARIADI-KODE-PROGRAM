<%@ Control Language="VB" ClassName="KPIDashboard" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.OleDb" %>

<style>
    .panel { border:1px solid #ddd; padding:12px; border-radius:4px; background:#fafafa; margin-top:8px; }
    .form-row { display:flex; gap:8px; align-items:center; margin-bottom:8px; flex-wrap:wrap; }
    .form-row label { width:120px; font-weight:600; font-size:13px; }
    .form-row .input { flex:1; min-width:120px; }
    #chartContainer { margin-top:20px; }
</style>

<script runat="server">

    Private Const CONN As String =
        "Provider=sqloledb;Data Source=10.200.120.83,1433;Network Library=DBMSSOCN;" &
        "Initial Catalog=lintar2022;User ID=sa;Password=dbTesting2023;connect timeout=200;pooling=false;max pool size=200"

    ' =====================================================
    ' PAGE LOAD
    ' =====================================================
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LoadFilterOptions()
            BindKPIDashboard()
        End If
    End Sub

    ' =====================================================
    ' Dropdown Filter
    ' =====================================================
    Private Sub LoadFilterOptions()
        ddlFilterTahun.Items.Clear()
        For th As Integer = 2012 To 2022
            ddlFilterTahun.Items.Add(New ListItem(th.ToString(), th.ToString()))
        Next
        ddlFilterTahun.SelectedValue = "2012"

        ddlFilterKuesioner.Items.Clear()
        ddlFilterKuesioner.Items.Add(New ListItem("Semua Kuesioner", "all"))
        ddlFilterKuesioner.Items.Add(New ListItem("Kuesioner Visi Misi", "visi_misi"))
        ddlFilterKuesioner.Items.Add(New ListItem("Kuesioner Kepuasan", "kepuasan"))
        ddlFilterKuesioner.Items.Add(New ListItem("Kuesioner Pengajaran", "pengajaran"))
        ddlFilterKuesioner.Items.Add(New ListItem("Kuesioner Pengguna Lulusan", "pengguna_lulusan"))

        ddlFilterIndikator.Items.Clear()
        ddlFilterIndikator.Items.Add(New ListItem("Semua Indikator", "all"))
        ddlFilterIndikator.Items.Add(New ListItem("Jumlah Total Responden", "total_responden"))
        ddlFilterIndikator.Items.Add(New ListItem("Tingkat Respon Positif", "respon_positif"))
    End Sub

    Protected Sub btnFilter_Click(sender As Object, e As EventArgs)
        BindKPIDashboard()
    End Sub

    ' =====================================================
    ' BIND DATA KPI
    ' =====================================================
    Private Sub BindKPIDashboard()
        Using cn As New OleDbConnection(CONN)
            cn.Open()

            Dim sql As String = "SELECT tahun, kuesioner, indikator, target_total FROM dbo.kpi_input_kuesioner WHERE 1=1"

            If ddlFilterTahun.SelectedValue <> "0" Then sql &= " AND tahun=" & ddlFilterTahun.SelectedValue
            If ddlFilterKuesioner.SelectedValue <> "all" Then sql &= " AND kuesioner='" & ddlFilterKuesioner.SelectedValue & "'"
            If ddlFilterIndikator.SelectedValue <> "all" Then sql &= " AND indikator='" & ddlFilterIndikator.SelectedValue & "'"
            sql &= " ORDER BY tahun ASC"

            Using cmd As New OleDbCommand(sql, cn)
                Using da As New OleDbDataAdapter(cmd)
                    Dim dt As New DataTable()
                    da.Fill(dt)

                    ' TAMBAHKAN KOLOM PERHITUNGAN PERSENTASE
                    dt.Columns.Add("persentase", GetType(String))

                    For Each row As DataRow In dt.Rows
                        Dim target As Integer = Convert.ToInt32(row("target_total"))
                        Dim actual As Integer = GetActualResult(row, cn) ' ambil hasil perhitungan KPI

                        If target > 0 And actual > 0 Then
                            Dim pct As Double = (actual / target) * 100
                            row("persentase") = pct.ToString("N2") & "%"
                        Else
                            row("persentase") = "-"
                        End If
                    Next

                    gvKPIDashboard.DataSource = dt
                    gvKPIDashboard.DataBind()

                    BindChart(dt)
                End Using
            End Using
        End Using
    End Sub

    ' =====================================================
    ' PERHITUNGAN TOTAL RESPON / RESPON POSITIF
    ' =====================================================
    Private Function GetActualResult(row As DataRow, cn As OleDbConnection) As Integer
        Dim tahun As Integer = row("tahun")
        Dim kues As String = row("kuesioner").ToString().ToLower()
        Dim indikator As String = row("indikator").ToString().ToLower()

        Dim result As Integer = 0

        Select Case kues

            ' ------------------------------------------
            Case "kepuasan"
                If indikator = "total_responden" Then
                    Dim query As String =
                        "SELECT (SELECT COUNT(*) FROM dbo.t_angket_jawab_dsn WHERE tahun=" & tahun & ")+" &
                        " (SELECT COUNT(*) FROM dbo.t_angket_jawab_kry WHERE tahun=" & tahun & ")+" &
                        " (SELECT COUNT(*) FROM dbo.t_angket_jawab_mhs WHERE tahun=" & tahun & ")"
                    result = ExecuteScalarInt(query, cn)

                ElseIf indikator = "respon_positif" Then
                    Dim tables = {"t_angket_jawab_dsn", "t_angket_jawab_kry", "t_angket_jawab_mhs"}

                    For Each tbl In tables
                        Dim q As String = "SELECT pilihan FROM dbo." & tbl & " WHERE pilihan IS NOT NULL AND tahun=" & tahun
                        result += CountPositiveScores(q, cn, positiveScores:={4, 5})
                    Next
                End If

            ' ------------------------------------------
            Case "visi_misi"
                If indikator = "total_responden" Then
                    result = ExecuteScalarInt("SELECT COUNT(*) FROM dbo.tqvm_hslangket WHERE thn=" & tahun, cn)

                ElseIf indikator = "respon_positif" Then
                    Dim q As String = "SELECT isi FROM dbo.tqvm_hslangket WHERE isi IS NOT NULL AND thn=" & tahun
                    result = CountPositiveChars(q, cn, positiveChars:={"4", "5"})
                End If

            ' ------------------------------------------
            Case "pengajaran"
                If indikator = "total_responden" Then
                    result = ExecuteScalarInt("SELECT COUNT(*) FROM dbo.tq_hslangket WHERE tha=" & tahun, cn)

                ElseIf indikator = "respon_positif" Then
                    Dim q As String = "SELECT isi FROM dbo.tq_hslangket WHERE isi IS NOT NULL AND tha=" & tahun
                    result = CountPositiveChars(q, cn, positiveChars:={"C", "D"})
                End If

            ' ------------------------------------------
            Case "pengguna_lulusan"
                If indikator = "total_responden" Then
                    result = ExecuteScalarInt("SELECT COUNT(*) FROM dbo.tq_pengguna_lulusan_isi WHERE tahun=" & tahun, cn)

                ElseIf indikator = "respon_positif" Then
                    Dim q As String = "SELECT isi FROM dbo.tq_pengguna_lulusan_isi WHERE isi IS NOT NULL AND tahun=" & tahun
                    result = CountPositiveScores(q, cn, positiveScores:={3, 4})
                End If

        End Select

        Return result
    End Function

    ' =====================================================
    ' HELPER FUNCTIONS
    ' =====================================================
    Private Function ExecuteScalarInt(sql As String, cn As OleDbConnection) As Integer
        Using cmd As New OleDbCommand(sql, cn)
            Return Convert.ToInt32(cmd.ExecuteScalar())
        End Using
    End Function

    Private Function CountPositiveScores(query As String, cn As OleDbConnection, positiveScores() As Integer) As Integer
        Dim count As Integer = 0

        Using cmd As New OleDbCommand(query, cn)
            Using r = cmd.ExecuteReader()
                While r.Read()
                    Dim data As String = r(0).ToString()
                    For Each x In data.Split("|"c)
                        Dim v As Integer
                        If Integer.TryParse(x.Trim(), v) AndAlso positiveScores.Contains(v) Then
                            count += 1
                        End If
                    Next
                End While
            End Using
        End Using

        Return count
    End Function

    Private Function CountPositiveChars(query As String, cn As OleDbConnection, positiveChars() As String) As Integer
        Dim total As Integer = 0

        Using cmd As New OleDbCommand(query, cn)
            Using r = cmd.ExecuteReader()
                While r.Read()
                    Dim isi = r("isi").ToString()
                    For Each ch As Char In isi
                        If positiveChars.Contains(ch.ToString()) Then total += 1
                    Next
                End While
            End Using
        End Using

        Return total
    End Function

    ' =====================================================
    ' CHART
    ' =====================================================
    Private Sub BindChart(dt As DataTable)
        Dim labels As New List(Of String)
        Dim kpiList As New List(Of String)
        Dim responList As New List(Of String)
        Dim totalList As New List(Of String)

        Using cn As New OleDbConnection(CONN)
            cn.Open()

            For Each row As DataRow In dt.Rows
                Dim tahun As Integer = Convert.ToInt32(row("tahun"))
                Dim kues As String = row("kuesioner").ToString().ToLower()
                Dim indikator As String = row("indikator").ToString().ToLower()

                labels.Add(tahun & " - " & kues & " - " & row("indikator").ToString())

                kpiList.Add(row("target_total").ToString())

                ' ==========================
                '   HITUNG DATA ASLI KPI
                ' ==========================
                Dim totalRespon As Integer = 0
                Dim responPositif As Integer = 0

                Select Case kues

                    ' ==========================================
                    ' KEPUASAN
                    ' ==========================================
                    Case "kepuasan"

                        If indikator = "total_responden" Then
                            Dim sqlTotal As String = "SELECT " &
                            "(SELECT COUNT(*) FROM dbo.t_angket_jawab_dsn WHERE tahun=" & tahun & ") + " &
                            "(SELECT COUNT(*) FROM dbo.t_angket_jawab_kry WHERE tahun=" & tahun & ") + " &
                            "(SELECT COUNT(*) FROM dbo.t_angket_jawab_mhs WHERE tahun=" & tahun & ")"

                            totalRespon = ExecuteScalarInt(sqlTotal, cn)
                            totalList.Add(totalRespon.ToString())
                            responList.Add("")

                        ElseIf indikator = "respon_positif" Then
                            Dim tables = {"t_angket_jawab_dsn", "t_angket_jawab_kry", "t_angket_jawab_mhs"}

                            For Each tbl In tables
                                Dim sql = "SELECT pilihan FROM dbo." & tbl & " WHERE tahun=" & tahun

                                responPositif += CountPositiveScores(sql, cn, {4, 5})
                            Next

                            responList.Add(responPositif.ToString())
                            totalList.Add("")
                        End If


                    ' ==========================================
                    ' VISI MISI
                    ' ==========================================
                    Case "visi_misi"

                        If indikator = "total_responden" Then
                            totalRespon = ExecuteScalarInt("SELECT COUNT(*) FROM dbo.tqvm_hslangket WHERE thn=" & tahun, cn)
                            totalList.Add(totalRespon.ToString())
                            responList.Add("")

                        ElseIf indikator = "respon_positif" Then
                            Dim sql = "SELECT isi FROM dbo.tqvm_hslangket WHERE isi IS NOT NULL AND thn=" & tahun
                            responPositif = CountPositiveChars(sql, cn, {"4", "5"})
                            responList.Add(responPositif.ToString())
                            totalList.Add("")
                        End If


                    ' ==========================================
                    ' PENGAJARAN
                    ' ==========================================
                    Case "pengajaran"

                        If indikator = "total_responden" Then
                            totalRespon = ExecuteScalarInt("SELECT COUNT(*) FROM dbo.tq_hslangket WHERE tha=" & tahun, cn)
                            totalList.Add(totalRespon.ToString())
                            responList.Add("")

                        ElseIf indikator = "respon_positif" Then
                            Dim sql = "SELECT isi FROM dbo.tq_hslangket WHERE isi IS NOT NULL AND tha=" & tahun
                            responPositif = CountPositiveChars(sql, cn, {"C", "D"})
                            responList.Add(responPositif.ToString())
                            totalList.Add("")
                        End If


                    ' ==========================================
                    ' PENGGUNA LULUSAN
                    ' ==========================================
                    Case "pengguna_lulusan"

                        If indikator = "total_responden" Then
                            totalRespon = ExecuteScalarInt("SELECT COUNT(*) FROM dbo.tq_pengguna_lulusan_isi WHERE tahun=" & tahun, cn)
                            totalList.Add(totalRespon.ToString())
                            responList.Add("")

                        ElseIf indikator = "respon_positif" Then
                            Dim sql = "SELECT isi FROM dbo.tq_pengguna_lulusan_isi WHERE isi IS NOT NULL AND tahun=" & tahun
                            responPositif = CountPositiveScores(sql, cn, {3, 4})
                            responList.Add(responPositif.ToString())
                            totalList.Add("")
                        End If

                End Select

            Next
        End Using

        ' =======================================
        ' SIMPAN KE HIDDENFIELD
        ' =======================================
        hfLabels.Value = String.Join(",", labels)
        hfKPI.Value = String.Join(",", kpiList)
        hfRespon.Value = String.Join(",", responList)
        hfTotalRespon.Value = String.Join(",", totalList)

        Page.ClientScript.RegisterStartupScript(Me.GetType(), "RenderChart", "renderKPIChart();", True)
    End Sub

</script>

<!-- ========================================================= -->
<!--                      FILTER PANEL UI                       -->
<!-- ========================================================= -->
<div class="panel">
    <div class="form-row">
        <label>Tahun</label>
        <div class="input">
            <asp:DropDownList ID="ddlFilterTahun" runat="server" CssClass="form-control"></asp:DropDownList>
        </div>
    </div>

    <div class="form-row">
        <label>Kuesioner</label>
        <div class="input">
            <asp:DropDownList ID="ddlFilterKuesioner" runat="server" CssClass="form-control"></asp:DropDownList>
        </div>
    </div>

    <div class="form-row">
        <label>Indikator</label>
        <div class="input">
            <asp:DropDownList ID="ddlFilterIndikator" runat="server" CssClass="form-control"></asp:DropDownList>
        </div>
    </div>

    <asp:Button ID="btnFilter" runat="server" Text="Filter" CssClass="btn btn-primary" OnClick="btnFilter_Click" />
</div>

<hr />

<!-- ========================================================= -->
<!--                     GRIDVIEW + PERSENTASE                 -->
<!-- ========================================================= -->
<asp:GridView ID="gvKPIDashboard" runat="server" CssClass="table table-bordered table-striped"
    AutoGenerateColumns="False">

    <Columns>
        <asp:BoundField DataField="tahun" HeaderText="Tahun" />
        <asp:BoundField DataField="kuesioner" HeaderText="Kuesioner" />
        <asp:BoundField DataField="indikator" HeaderText="Indikator" />
        <asp:BoundField DataField="target_total" HeaderText="Target KPI" />

        <asp:BoundField DataField="persentase" HeaderText="Persentase Tercapai (%)" />
    </Columns>

</asp:GridView>

<!-- ========================================================= -->
<!--                              CHART                         -->
<!-- ========================================================= -->
<div id="chartContainer">
    <canvas id="kpiChart" width="100%" height="40"></canvas>
</div>

<asp:HiddenField ID="hfLabels" runat="server" />
<asp:HiddenField ID="hfKPI" runat="server" />
<asp:HiddenField ID="hfRespon" runat="server" />
<asp:HiddenField ID="hfTotalRespon" runat="server" />

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2"></script>

<script>
    function renderKPIChart() {

        var labels = document.getElementById('<%= hfLabels.ClientID %>').value.split(',');
        var kpiValues = document.getElementById('<%= hfKPI.ClientID %>').value.split(',');
        var responPositif = document.getElementById('<%= hfRespon.ClientID %>').value.split(',');
        var totalRespon = document.getElementById('<%= hfTotalRespon.ClientID %>').value.split(',');

        var ctx = document.getElementById('kpiChart').getContext('2d');

        // Hapus chart lama jika ada
        if (window.kpiChartInstance) {
            window.kpiChartInstance.destroy();
        }

        var datasets = [];

        // =============================
        // 1. Target KPI
        // =============================
        datasets.push({
            label: "Target KPI",
            data: kpiValues,
            backgroundColor: "rgba(75,192,192,0.6)",
            borderColor: "rgba(75,192,192,1)",
            borderWidth: 1
        });

        // =============================
        // 2. Total Responden
        // =============================
        if (totalRespon.some(x => x !== "" && !isNaN(x))) {
            datasets.push({
                label: "Jumlah Total Responden",
                data: totalRespon,
                backgroundColor: "rgba(54,162,235,0.6)",
                borderColor: "rgba(54,162,235,1)",
                borderWidth: 1
            });
        }

        // =============================
        // 3. Respon Positif
        // =============================
        if (responPositif.some(x => x !== "" && !isNaN(x))) {
            datasets.push({
                label: "Respon Positif",
                data: responPositif,
                backgroundColor: "rgba(255,159,64,0.6)",
                borderColor: "rgba(255,159,64,1)",
                borderWidth: 1
            });
        }

        // =============================
        // RENDER CHART
        // =============================
        window.kpiChartInstance = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: datasets
            },
            plugins: [ChartDataLabels],
            options: {
                responsive: true,
                plugins: {
                    legend: { position: 'top' },

                    datalabels: {
                        anchor: 'center',   // ⬅ BARU: angka di dalam batang
                        align: 'center',    // ⬅ BARU
                        color: '#000000',   // ⬅ supaya kontras
                        font: {
                            weight: 'bold',
                            size: 12
                        },
                        formatter: function (value) {
                            return value !== "" ? value : "";
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: { precision: 0 }
                    }
                }
            }
        });
    }
</script>

