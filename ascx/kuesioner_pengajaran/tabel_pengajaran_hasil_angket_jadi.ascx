<!-- #INCLUDE file = "/con_ascx2022/conlintar2022.ascx" -->

<script runat="server">
    Public chartConfigJson As String = ""
    Private Shared randomGenerator As New Random()
    
    Sub Page_Load(sender As Object, e As EventArgs)
        If Not Page.IsPostBack Then
            LoadDashboardData()
            LoadChartData()
            GenerateChartConfiguration()
        End If
    End Sub

    Sub LoadDashboardData()
        Dim dashboardData As New List(Of Object)()
        
        ' Koneksi ke database
        Dim connectionString As String = "Provider=sqloledb;Data Source=10.200.120.83,1433;Network Library=DBMSSOCN;Initial Catalog=lintar2022;User ID=sa;Password=dbTesting2023;connect timeout=200;pooling=false;max pool size=200"
        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()
            
            ' Query untuk menghitung total jumlah responden di tabel
            Dim query As String = "SELECT COUNT(*) AS TotalResponden FROM tq_hslangket"
            Using command As New OleDb.OleDbCommand(query, connection)
                Dim totalResponden As Integer = Convert.ToInt32(command.ExecuteScalar())
                
                ' Tambahkan data ke dashboardData
                dashboardData.Add(New With {.Total = totalResponden.ToString(), .Title = "Total Responden (Mahasiswa)", .BgClass = "bg-aqua", .Icon = "fa-solid fa-users"})
            End Using


            ' Query untuk mengambil semua isi dari tq_hslangket
            Dim queryIsi As String = "SELECT isi FROM dbo.tq_hslangket"

            Using command As New OleDb.OleDbCommand(queryIsi, connection)
                Dim totalSkor As Double = 0
                Dim totalRespondenIsi As Integer = 0

                Using reader As OleDb.OleDbDataReader = command.ExecuteReader()
                    While reader.Read()
                        Dim pilihanRaw As String = reader("isi").ToString().Trim()
                        If Not String.IsNullOrEmpty(pilihanRaw) Then
                            Dim nilaiList As New List(Of Double)

                            ' Pecah tiap huruf menjadi angka (A=1, B=2, C=3, D=4)
                            For Each ch As Char In pilihanRaw
                                Select Case Char.ToUpper(ch)
                                    Case "A"c
                                        nilaiList.Add(1)
                                    Case "B"c
                                        nilaiList.Add(2)
                                    Case "C"c
                                        nilaiList.Add(3)
                                    Case "D"c
                                        nilaiList.Add(4)
                                    Case Else
                                        ' Abaikan karakter lain
                                End Select
                            Next

                            ' Hitung rata-rata tiap responden
                            If nilaiList.Count > 0 Then
                                Dim rataPerResponden As Double = nilaiList.Average()
                                totalSkor += rataPerResponden
                                totalRespondenIsi += 1
                            End If
                        End If
                    End While
                End Using

                ' Hitung rata-rata keseluruhan responden
                Dim rataTotal As Double = 0
                If totalRespondenIsi > 0 Then
                    rataTotal = Math.Round(totalSkor / totalRespondenIsi, 2)
                End If

                ' Tambahkan ke dashboard
                dashboardData.Add(New With {
                    .Total = rataTotal.ToString(),
                    .Title = "Rerata Skor (Pengajaran)",
                    .BgClass = "bg-green",
                    .Icon = "fa-solid fa-chart-line"
                })
            End Using



        End Using
        rptDashboard.DataSource = dashboardData
        rptDashboard.DataBind()
    End Sub






    Sub LoadChartData()
        Dim chartData As New List(Of Object) From {
            New With {.ChartId = "persentaseChart", .ChartTitle = "Persentase Responden Tahunan", .ChartType = "pie", .Width = "4"},
            New With {.ChartId = "batangChart", .ChartTitle = "Total Jumlah Responden Tahunan", .ChartType = "bar", .Width = "8"},
            New With {.ChartId = "garisChart", .ChartTitle = "Tren Jumlah Responden Tahunan", .ChartType = "line", .Width = "12"},
            New With {.ChartId = "distribusiChart", .ChartTitle = "Distribusi Skor Jawaban Setiap Pertanyaan (2012-2016)", .ChartType = "bar", .Width = "12"}
        }
        
        rptCharts.DataSource = chartData
        rptCharts.DataBind()
    End Sub

    Sub GenerateChartConfiguration()
        Dim totalPengajaran2012 As Integer = 0
        Dim totalPengajaran2013 As Integer = 0
        Dim totalPengajaran2014 As Integer = 0
        Dim totalPengajaran2015 As Integer = 0
        Dim totalPengajaran2016 As Integer = 0

        Dim mhs2012 As Integer = 0
        Dim mhs2013 As Integer = 0
        Dim mhs2014 As Integer = 0
        Dim mhs2015 As Integer = 0
        Dim mhs2016 As Integer = 0
       

        Dim total2016 As Integer = 0
        Dim total2017 As Integer = 0
        Dim total2018 As Integer = 0
        Dim total2019 As Integer = 0
        Dim total2020 As Integer = 0
        Dim total2021 As Integer = 0
        Dim total2022 As Integer = 0

        ' Koneksi ke database
        Dim connectionString As String = "Provider=sqloledb;Data Source=10.200.120.83,1433;Network Library=DBMSSOCN;Initial Catalog=lintar2022;User ID=sa;Password=dbTesting2023;connect timeout=200;pooling=false;max pool size=200"
        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()

            ' Query untuk menghitung jumlah totalPengajaran2012
            Dim queryPengajaran2012 As String = "SELECT COUNT(*) AS TotalPengajaran2012 FROM tq_hslangket WHERE tha = 2012"
            Using command As New OleDb.OleDbCommand(queryPengajaran2012, connection)
                totalPengajaran2012 = Convert.ToInt32(command.ExecuteScalar())
            End Using


            ' Query untuk menghitung jumlah totalPengajaran2013
            Dim queryPengajaran2013 As String = "SELECT COUNT(*) AS TotalPengajaran2013 FROM tq_hslangket WHERE tha = 2013"
            Using command As New OleDb.OleDbCommand(queryPengajaran2013, connection)
                totalPengajaran2013 = Convert.ToInt32(command.ExecuteScalar())
            End Using


            ' Query untuk menghitung jumlah totalPengajaran2014
            Dim queryPengajaran2014 As String = "SELECT COUNT(*) AS TotalPengajaran2014 FROM tq_hslangket WHERE tha = 2014"
            Using command As New OleDb.OleDbCommand(queryPengajaran2014, connection)
                totalPengajaran2014 = Convert.ToInt32(command.ExecuteScalar())
            End Using


            ' Query untuk menghitung jumlah totalPengajaran2015
            Dim queryPengajaran2015 As String = "SELECT COUNT(*) AS TotalPengajaran2015 FROM tq_hslangket WHERE tha = 2015"
            Using command As New OleDb.OleDbCommand(queryPengajaran2015, connection)
                totalPengajaran2015 = Convert.ToInt32(command.ExecuteScalar())
            End Using


            ' Query untuk menghitung jumlah totalPengajaran2016
            Dim queryPengajaran2016 As String = "SELECT COUNT(*) AS TotalPengajaran2016 FROM tq_hslangket WHERE tha = 2016"
            Using command As New OleDb.OleDbCommand(queryPengajaran2016, connection)
                totalPengajaran2016 = Convert.ToInt32(command.ExecuteScalar())
            End Using

           

            ' Query untuk menghitung jumlah baris tahun 2012 dari masing-masing tabel
            Dim queryAngketmhs2012 As String = "SELECT COUNT(*) AS Total FROM tq_hslangket WHERE ISNUMERIC(tha) = 1 AND tha = '2012'"

                ' Hitung total dari tabel mahasiswa
                Using command As New OleDb.OleDbCommand(queryAngketmhs2012, connection)
                    mhs2012 = Convert.ToInt32(command.ExecuteScalar())
                End Using


            ' Query untuk menghitung jumlah baris tahun 2013 dari masing-masing tabel
            Dim queryAngketmhs2013 As String = "SELECT COUNT(*) AS Total FROM tq_hslangket WHERE ISNUMERIC(tha) = 1 AND tha = '2013'"

                ' Hitung total dari tabel mahasiswa
                Using command As New OleDb.OleDbCommand(queryAngketmhs2013, connection)
                    mhs2013 = Convert.ToInt32(command.ExecuteScalar())
                End Using



            ' Query untuk menghitung jumlah baris tahun 2014 dari masing-masing tabel
            Dim queryAngketmhs2014 As String = "SELECT COUNT(*) AS Total FROM tq_hslangket WHERE ISNUMERIC(tha) = 1 AND tha = '2014'"

                ' Hitung total dari tabel mahasiswa
                Using command As New OleDb.OleDbCommand(queryAngketmhs2014, connection)
                    mhs2014 = Convert.ToInt32(command.ExecuteScalar())
                End Using


            ' Query untuk menghitung jumlah baris tahun 2015 dari masing-masing tabel
            Dim queryAngketmhs2015 As String = "SELECT COUNT(*) AS Total FROM tq_hslangket WHERE ISNUMERIC(tha) = 1 AND tha = '2015'"

                ' Hitung total dari tabel mahasiswa
                Using command As New OleDb.OleDbCommand(queryAngketmhs2015, connection)
                    mhs2015 = Convert.ToInt32(command.ExecuteScalar())
                End Using



            ' Query untuk menghitung jumlah baris tahun 2016 dari masing-masing tabel
            Dim queryAngketmhs2016 As String = "SELECT COUNT(*) AS Total FROM tq_hslangket WHERE ISNUMERIC(tha) = 1 AND tha = '2016'"

                ' Hitung total dari tabel mahasiswa
                Using command As New OleDb.OleDbCommand(queryAngketmhs2016, connection)
                    mhs2016 = Convert.ToInt32(command.ExecuteScalar())
                End Using
        End Using

        Dim chartDetails As New List(Of Object) From {
            New With {.id = "persentaseChart", .type = "pie", .labels = "Tahun 2012,Tahun 2013,Tahun 2014,Tahun 2015,Tahun 2016", .data = totalPengajaran2012.ToString() & "," & totalPengajaran2013.ToString() & "," & totalPengajaran2014.ToString() & "," & totalPengajaran2015.ToString() & "," & totalPengajaran2016.ToString(), .isMulti = False, .showLegend = True},
            New With {.id = "batangChart", .type = "bar", .labels = "Tahun 2012,Tahun 2013,Tahun 2014,Tahun 2015,Tahun 2016", .data = "Total Responden Mahasiswa:" & mhs2012.ToString() & "," & mhs2013.ToString() & "," & mhs2014.ToString() & "," & mhs2015.ToString() & "," & mhs2016.ToString() &
            ",0,0,0,0,0", .isMulti = True, .showLegend = True},
            New With {.id = "garisChart", .type = "line", .labels = "2012,2013,2014,2015,2016", .data = "Total Responden Mahasiswa:" & mhs2012.ToString() & "," & mhs2013.ToString() & "," & mhs2014.ToString() & "," & mhs2015.ToString() & "," & mhs2016.ToString() &
            ",0,0,0,0,0", .isMulti = True, .showLegend = True}
        }



        Dim distribusi(9, 3) As Integer ' 10 pertanyaan × skor A–D
        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()
            Dim cmd As New OleDb.OleDbCommand("SELECT isi FROM dbo.tq_hslangket WHERE isi IS NOT NULL", connection)
            Dim reader As OleDb.OleDbDataReader = cmd.ExecuteReader()
            While reader.Read()
            Dim isi As String = reader("isi").ToString().Trim()
            For i As Integer = 0 To Math.Min(isi.Length, 10) - 1
                Dim skor As Char = Char.ToUpper(isi(i))
                If skor >= "A"c AndAlso skor <= "D"c Then
                distribusi(i, Asc(skor) - Asc("A"c)) += 1
                End If
            Next
            End While
            reader.Close()
        End Using

        ' Labels pertanyaan
        Dim labelsDistribusi As String = "Pertanyaan 1,Pertanyaan 2,Pertanyaan 3,Pertanyaan 4,Pertanyaan 5,Pertanyaan 6,Pertanyaan 7,Pertanyaan 8,Pertanyaan 9,Pertanyaan 10"

        ' Dataset per skor A–D
        Dim dataParts As New List(Of String)
        For skor As Integer = 0 To 3
            Dim values As New List(Of String)
            For q As Integer = 0 To 9
            values.Add(distribusi(q, skor).ToString())
            Next
            dataParts.Add("Skor " & Chr(Asc("A"c) + skor) & ":" & String.Join(",", values))
        Next

        Dim distribusiData As String = String.Join("|", dataParts)

        ' Tambahkan chart distribusi ke chartDetails
        chartDetails.Add(New With {
            .id = "distribusiChart",
            .type = "bar",
            .labels = labelsDistribusi,
            .data = distribusiData,
            .isMulti = True,
            .showLegend = True
        })



        Dim sb As New System.Text.StringBuilder()
        sb.Append("[")

        For i As Integer = 0 To chartDetails.Count - 1
            If i > 0 Then sb.Append(",")
            sb.Append(BuildChartConfig(chartDetails(i)))
        Next

        sb.Append("]")
        chartConfigJson = sb.ToString()
    End Sub






    Function BuildChartConfig(chart As Object) As String
        Dim config As New System.Text.StringBuilder()
        
        config.Append("{")
        config.Append("""id"": """ & chart.id & """,")
        config.Append("""type"": """ & chart.type & """,")
        config.Append("""data"": {")
        config.Append("""labels"": " & StringToArray(chart.labels) & ",")
        
        If chart.isMulti Then
            config.Append("""datasets"": " & BuildMultiDatasets(chart.data, chart.labels, chart.type))
        Else
            config.Append("""datasets"": [" & BuildSingleDataset(chart.data, chart.type) & "]")
        End If
        
        config.Append("},")
        config.Append("""options"": {""responsive"": true, ""maintainAspectRatio"": false")
        
        ' Tambahkan pengaturan legend
        config.Append(",""plugins"": {""legend"": {""display"": " & chart.showLegend.ToString().ToLower() & "}}")
        
        If chart.type = "bar" Or chart.type = "line" Then
            config.Append(",""scales"": {""y"": {""beginAtZero"": true}}")
        End If
        
        config.Append("}}")
        
        Return config.ToString()
    End Function

    Function BuildSingleDataset(dataString As String, chartType As String) As String
        Dim data As String = StringToArray(dataString)
        Dim dataCount As Integer = dataString.Split(","c).Length
        Dim colors As String = GenerateColors(dataCount)
        
        Dim dataset As String = """data"": " & data & ", ""backgroundColor"": " & colors
        
        If chartType = "line" Then
            dataset &= ", ""borderColor"": """ & GetColorFromPalette(0) & """, ""tension"": 0.4"
        End If
        
        Return "{" & dataset & "}"
    End Function

    Function BuildMultiDatasets(dataString As String, labelsString As String, chartType As String) As String
        Dim dataGroups() As String = dataString.Split("|"c)
        Dim datasets As New List(Of String)()
        
        For i As Integer = 0 To dataGroups.Length - 1
            Dim parts() As String = dataGroups(i).Split(":"c)
            If parts.Length = 2 Then
                Dim seriesName As String = parts(0).Trim()
                Dim seriesData As String = StringToArray(parts(1))
                Dim color As String = GetColorFromPalette(i)
                
                Dim dataset As String = """label"": """ & seriesName & """, ""data"": " & seriesData & ", ""backgroundColor"": """ & color & """, ""borderColor"": """ & color & """"
                
                If chartType = "line" Then
                    dataset &= ", ""tension"": 0.4, ""fill"": false"
                End If
                
                datasets.Add("{" & dataset & "}")
            End If
        Next
        
        Return "[" & String.Join(",", datasets.ToArray()) & "]"
    End Function

    Function StringToArray(str As String) As String
        If String.IsNullOrEmpty(str) Then Return "[]"
        
        Dim items() As String = str.Split(","c)
        Dim result As New List(Of String)()
        
        For Each item As String In items
            Dim cleanItem As String = item.Trim()
            If IsNumeric(cleanItem) Then
                result.Add(cleanItem)
            Else
                result.Add("""" & cleanItem & """")
            End If
        Next
        
        Return "[" & String.Join(",", result.ToArray()) & "]"
    End Function

    Function GenerateColors(count As Integer) As String
        Dim colors As New List(Of String)()
        
        For i As Integer = 0 To count - 1
            Dim color As String = GetColorFromPalette(i)
            colors.Add("""" & color & """")
        Next
        
        Return "[" & String.Join(",", colors.ToArray()) & "]"
    End Function

    Function GetColorFromPalette(index As Integer) As String
        ' Generate warna menggunakan HSL dengan golden ratio untuk distribusi optimal
        Dim hue As Double = (index * 137.508) Mod 360 ' Golden angle
        Dim saturation As Double = 0.7 ' 70% saturation
        Dim lightness As Double = 0.5 ' 50% lightness
        
        ' Konversi HSL ke RGB
        Dim c As Double = (1 - Math.Abs(2 * lightness - 1)) * saturation
        Dim x As Double = c * (1 - Math.Abs((hue / 60) Mod 2 - 1))
        Dim m As Double = lightness - c / 2
        
        Dim r As Double = 0, g As Double = 0, b As Double = 0
        
        If hue < 60 Then
            r = c : g = x : b = 0
        ElseIf hue < 120 Then
            r = x : g = c : b = 0
        ElseIf hue < 180 Then
            r = 0 : g = c : b = x
        ElseIf hue < 240 Then
            r = 0 : g = x : b = c
        ElseIf hue < 300 Then
            r = x : g = 0 : b = c
        Else
            r = c : g = 0 : b = x
        End If
        
        ' Konversi ke nilai RGB 0-255
        Dim red As Integer = Math.Round((r + m) * 255)
        Dim green As Integer = Math.Round((g + m) * 255)
        Dim blue As Integer = Math.Round((b + m) * 255)
        
        ' Return sebagai hex color
        Return String.Format("#{0:X2}{1:X2}{2:X2}", red, green, blue)
    End Function
</script>

<section class="content-header">
    <h1>DASHBOARD PENGAJARAN</h1>
    <ol class="breadcrumb">
        <li><a href="/dashboard_kuesioner/index.aspx"><i class="fa fa-dashboard"></i> Dashboard</a></li>
        <li class="active">Dashboard Pengajaran</li>
    </ol>

    <!-- Tombol View All sebagai LinkButton server-side -->
    <div class="box-footer text-center" style="margin-top: 15px;">
        <asp:LinkButton ID="btnViewAll" runat="server" CssClass="btn btn-default" OnClick="btnViewAll_Click">
            Data Lengkap Tahunan Pengajaran
        </asp:LinkButton>
    </div>
</section>







<!-- Modal View All -->
<div class="modal fade" id="modal-view-all" tabindex="-1" role="dialog" aria-labelledby="modalLabel" aria-hidden="true">
    <div class="modal-dialog" style="width:850px;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="modalLabel">Data Lengkap Tahunan Pengajaran</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>

            <div class="modal-body">
                <!-- Dropdown Tahun -->
                <asp:DropDownList ID="ddlTahun" runat="server" AutoPostBack="True" 
                    OnSelectedIndexChanged="ddlTahun_SelectedIndexChanged" CssClass="form-control" 
                    style="width: 200px; margin-bottom: 10px;">
                </asp:DropDownList>

                <!-- Dropdown Prodi -->
                <asp:DropDownList ID="ddlProdi" runat="server" AutoPostBack="True" 
                    OnSelectedIndexChanged="ddlProdi_SelectedIndexChanged" CssClass="form-control" 
                    style="width: 300px; margin-bottom: 10px;">
                </asp:DropDownList>

                <!-- Label total responden -->
                <asp:Label ID="lblTotalResponden" runat="server" Font-Bold="True" />
                <br />

                <asp:GridView ID="GridViewTabelTahunan" runat="server" CssClass="table table-bordered table-striped" AutoGenerateColumns="False">
                    <Columns>
                        <asp:BoundField DataField="tha" HeaderText="Tahun" />
                        <asp:BoundField DataField="nim1" HeaderText="ID User" />
                        <asp:BoundField DataField="isi" HeaderText="Isi Jawaban" />
                        <asp:BoundField DataField="Rerata" HeaderText="Rerata" DataFormatString="{0:N2}" />
                        <asp:BoundField DataField="Total" HeaderText="Total" DataFormatString="{0:N2}" />
                    </Columns>
                </asp:GridView> 
            </div>

            <div class="modal-footer justify-content-between">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>


<script runat="server">

    Dim connectionString As String = "Provider=sqloledb;Data Source=10.200.120.83,1433;Network Library=DBMSSOCN;Initial Catalog=lintar2022;User ID=sa;Password=dbTesting2023;connect timeout=200;pooling=false;max pool size=200"

    Protected Sub btnViewAll_Click(sender As Object, e As EventArgs)
        LoadTahunDropdown()
        LoadProdiDropdown()
        LoadDashboardData()
        LoadChartData()
        GenerateChartConfiguration()

        If ddlTahun.Items.Count > 0 Then
            ddlTahun.SelectedIndex = 0
            LoadGridViewData(ddlTahun.SelectedValue)
        End If

        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowModal", "$('#modal-view-all').modal('show');", True)
    End Sub

    Protected Sub ddlTahun_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim selectedYear As String = ddlTahun.SelectedValue
        LoadGridViewData(selectedYear)
        LoadDashboardData()
        LoadChartData()
        GenerateChartConfiguration()

        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowModal", "$('#modal-view-all').modal('show');", True)
    End Sub

    Protected Sub ddlProdi_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim tahun As String = ddlTahun.SelectedValue
        LoadGridViewData(tahun)
        LoadDashboardData()
        LoadChartData()
        GenerateChartConfiguration()
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowModal", "$('#modal-view-all').modal('show');", True)
    End Sub

    Private Sub LoadTahunDropdown()
        Dim query As String = "SELECT DISTINCT tha FROM dbo.tq_hslangket ORDER BY tha"

        Using connection As New System.Data.OleDb.OleDbConnection(connectionString)
            Using command As New System.Data.OleDb.OleDbCommand(query, connection)
                connection.Open()
                Dim reader = command.ExecuteReader()

                ddlTahun.Items.Clear()
                While reader.Read()
                    Dim yearValue As String = reader("tha").ToString()
                    ddlTahun.Items.Add(New ListItem(yearValue, yearValue))
                End While

                connection.Close()
            End Using
        End Using
    End Sub

    Private Sub LoadProdiDropdown()
        ddlProdi.Items.Clear()
        ddlProdi.Items.Add(New ListItem("Semua Prodi", ""))

        Dim prodiMap As New Dictionary(Of String, String) From {
            {"115", "Ekonomi Manajemen"},
            {"125", "Ekonomi Akuntansi"},
            {"205", "Hukum"},
            {"315", "Teknik Arsitektur"},
            {"325", "Teknik Sipil"},
            {"405", "Kedokteran"},
            {"515", "Teknik Mesin"},
            {"525", "Teknik Elektro"},
            {"535", "Teknik Informatika"},
            {"615", "Desain Interior"},
            {"625", "Desain Komunikasi Visual"},
            {"705", "Psikologi"},
            {"915", "Ilmu Komunikasi"}
        }

        For Each kvp In prodiMap
            ddlProdi.Items.Add(New ListItem(kvp.Value, kvp.Key))
        Next
    End Sub


    Private Sub LoadGridViewData(tahun As String)
        Dim selectedProdi As String = ddlProdi.SelectedValue
        Dim query As String = "SELECT tha, nim1, isi FROM dbo.tq_hslangket WHERE tha = ?"

        ' Jika prodi dipilih, filter berdasarkan 3 digit pertama dari nim1
        If Not String.IsNullOrEmpty(selectedProdi) Then
            query &= " AND LEFT(nim1, 3) = ?"
        End If

        Using connection As New System.Data.OleDb.OleDbConnection(connectionString)
            Using command As New System.Data.OleDb.OleDbCommand(query, connection)
                command.Parameters.AddWithValue("@tha", tahun)

                If Not String.IsNullOrEmpty(selectedProdi) Then
                    command.Parameters.AddWithValue("@prodi", selectedProdi)
                End If

                Dim adapter As New System.Data.OleDb.OleDbDataAdapter(command)
                Dim dt As New System.Data.DataTable()
                adapter.Fill(dt)

                ' Tambah kolom Rerata & Total
                If Not dt.Columns.Contains("Rerata") Then dt.Columns.Add("Rerata", GetType(Double))
                If Not dt.Columns.Contains("Total") Then dt.Columns.Add("Total", GetType(Double))

                ' Hitung nilai huruf per baris
                For Each row As DataRow In dt.Rows
                    Dim isiString As String = Convert.ToString(row("isi"))
                    Dim rerata As Double = HitungRerataHuruf(isiString)
                    Dim total As Double = HitungTotalHuruf(isiString)

                    row("Rerata") = rerata
                    row("Total") = total
                Next

                lblTotalResponden.Text = "Total Responden: " & dt.Rows.Count

                GridViewTabelTahunan.DataSource = dt
                GridViewTabelTahunan.DataBind()
            End Using
        End Using
    End Sub


    ' === Fungsi konversi huruf ke angka ===
    Private Function HurufKeNilai(huruf As Char) As Integer
        Select Case Char.ToUpper(huruf)
            Case "A"c : Return 1
            Case "B"c : Return 2
            Case "C"c : Return 3
            Case "D"c : Return 4
            Case Else : Return 0
        End Select
    End Function

    Private Function HitungRerataHuruf(text As String) As Double
        If String.IsNullOrEmpty(text) Then Return 0
        Dim nilaiList As New List(Of Integer)

        For Each ch As Char In text
            Dim val As Integer = HurufKeNilai(ch)
            If val > 0 Then nilaiList.Add(val)
        Next

        If nilaiList.Count = 0 Then Return 0
        Return Math.Round(nilaiList.Average(), 2)
    End Function

    Private Function HitungTotalHuruf(text As String) As Double
        If String.IsNullOrEmpty(text) Then Return 0
        Dim total As Integer = 0

        For Each ch As Char In text
            total += HurufKeNilai(ch)
        Next

        Return Math.Round(total, 2)
    End Function

</script>























<section class="content">
    <div class="row">
        <asp:Repeater ID="rptDashboard" runat="server">
            <ItemTemplate>
                <div class="col-lg-6 col-xs-12">
                    <div class="small-box <%# Eval("BgClass") %>">
                        <div class="inner">
                            <h3><%# Eval("Total") %></h3>
                            <p><%# Eval("Title") %></p>
                        </div>
                        <div class="icon">
                            <i class="fa <%# Eval("Icon") %>"></i>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <div class="row">
        <asp:Repeater ID="rptCharts" runat="server">
            <ItemTemplate>
                <div class="col-md-<%# Eval("Width") %>">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title"><%# Eval("ChartTitle") %></h3>
                            <div class="box-tools pull-right">
                                <button type="button" class="btn btn-box-tool" data-widget="collapse">
                                    <i class="fa fa-minus"></i>
                                </button>
                            </div>
                        </div>
                        <div class="box-body">
                            <div style="height: 300px;">
                                <canvas id="<%# Eval("ChartId") %>"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</section>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2"></script>


<script>
document.addEventListener('DOMContentLoaded', function() {
    Chart.register(ChartDataLabels);

    var chartConfigs = <%= chartConfigJson %>;
    chartConfigs.forEach(function(config) {
        var canvas = document.getElementById(config.id);
        if (canvas) {
            new Chart(canvas, {
                type: config.type,
                data: config.data,
                options: {
                    ...config.options,
                    plugins: {
                        datalabels: {
                            color: function(context) {
                                const bgColor = context.dataset.backgroundColor;
                                if (Array.isArray(bgColor)) {
                                    const c = bgColor[context.dataIndex] || '#000';
                                    return c.toLowerCase() === '#000000' ? '#fff' : '#000';
                                } else {
                                    return bgColor && bgColor.toLowerCase() === '#000000' ? '#fff' : '#000';
                                }
                            },
                            font: { weight: 'bold', size: 12 },
                            formatter: function(value, ctx) {
                                if (ctx.chart.config.type === 'pie' || ctx.chart.config.type === 'doughnut') {
                                    const sum = ctx.chart._metasets[0].total;
                                    const percentage = ((value / sum) * 100).toFixed(1) + "%";
                                    return percentage;
                                } else {
                                    return value;
                                }
                            },
                            anchor: 'center',
                            align: 'center'
                        },
                        legend: { display: config.options.plugins.legend.display },
                        tooltip: { enabled: true }
                    }
                },
                plugins: [ChartDataLabels]
            });
        }
    });

    // ==== Navigasi hanya untuk chart dengan ID 'distribusiChart' ====
    const chartId = "distribusiChart";
    const chart = Chart.getChart(chartId);
    if (!chart) return;

    const questionsPerPage = 5;
    const totalQuestions = chart.data.labels.length;
    const totalPages = Math.ceil(totalQuestions / questionsPerPage);
    let currentPage = 0;

    const fullLabels = [...chart.data.labels];
    const fullDatasets = chart.data.datasets.map(ds => ({
        ...ds,
        fullData: [...ds.data]
    }));

    const canvasContainer = chart.canvas.parentNode;
    canvasContainer.style.position = "relative";
    canvasContainer.style.overflow = "hidden";
    chart.canvas.style.transition = "transform 0.5s ease, opacity 0.4s ease";

    function updateChart(direction = "right") {
        const offset = direction === "right" ? "100%" : "-100%";
        chart.canvas.style.opacity = "0";
        chart.canvas.style.transform = `translateX(${offset})`;

        setTimeout(() => {
            const start = currentPage * questionsPerPage;
            const end = start + questionsPerPage;
            chart.data.labels = fullLabels.slice(start, end);
            chart.data.datasets.forEach((ds, i) => {
                ds.data = fullDatasets[i].fullData.slice(start, end);
            });
            chart.update();

            chart.canvas.style.transform = `translateX(${direction === "right" ? "-100%" : "100%"})`;
            setTimeout(() => {
                chart.canvas.style.transform = "translateX(0)";
                chart.canvas.style.opacity = "1";
            }, 80);
        }, 250);
    }

    // ====== Tombol Navigasi dengan Font Awesome ======
    const navContainer = document.createElement("div");
    navContainer.className = "chart-nav-container";
    navContainer.innerHTML = `
        <button id="prev-${chartId}" class="btn-nav"><i class="fa-solid fa-circle-chevron-left"></i></button>
        <span id="page-${chartId}" class="page-info">Pertanyaan 1-${Math.min(questionsPerPage, totalQuestions)}</span>
        <button id="next-${chartId}" class="btn-nav"><i class="fa-solid fa-circle-chevron-right"></i></button>
    `;
    canvasContainer.parentNode.insertBefore(navContainer, canvasContainer.nextSibling);

    // Tambahkan CSS hanya sekali
    if (!document.getElementById("chartNavStyle")) {
        const style = document.createElement("style");
        style.id = "chartNavStyle";
        style.textContent = `
            .chart-nav-container {
                text-align: center;
                margin-top: 14px;
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 16px;
                z-index: 5;
                position: relative;
            }
            .btn-nav {
                background: none;
                border: none;
                font-size: 32px;
                color: #007bff;
                cursor: pointer;
                transition: all 0.25s ease;
            }
            .btn-nav:hover {
                color: #0056b3;
                transform: scale(1.25) rotate(4deg);
            }
            .btn-nav:disabled {
                color: #ccc !important;
                cursor: not-allowed;
                transform: none;
            }
            .page-info {
                font-weight: 600;
                color: #333;
                min-width: 160px;
                text-align: center;
                font-size: 15px;
            }
        `;
        document.head.appendChild(style);
    }

    const prevBtn = document.getElementById(`prev-${chartId}`);
    const nextBtn = document.getElementById(`next-${chartId}`);
    const pageLabel = document.getElementById(`page-${chartId}`);

    nextBtn.addEventListener("click", () => {
        if (currentPage < totalPages - 1) {
            currentPage++;
            updateChart("right");
            const startQ = currentPage * questionsPerPage + 1;
            const endQ = Math.min((currentPage + 1) * questionsPerPage, totalQuestions);
            pageLabel.textContent = `Pertanyaan ${startQ}-${endQ}`;
        }
        prevBtn.disabled = currentPage === 0;
        nextBtn.disabled = currentPage >= totalPages - 1;
    });

    prevBtn.addEventListener("click", () => {
        if (currentPage > 0) {
            currentPage--;
            updateChart("left");
            const startQ = currentPage * questionsPerPage + 1;
            const endQ = Math.min((currentPage + 1) * questionsPerPage, totalQuestions);
            pageLabel.textContent = `Pertanyaan ${startQ}-${endQ}`;
        }
        prevBtn.disabled = currentPage === 0;
        nextBtn.disabled = currentPage >= totalPages - 1;
    });

    updateChart();
    prevBtn.disabled = true;
});
</script>



<!-- Menampilkan Icon Font Awesome Pro/Premium -->
<link rel="stylesheet" href="https://site-assets.fontawesome.com/releases/v6.4.2/css/all.css">
