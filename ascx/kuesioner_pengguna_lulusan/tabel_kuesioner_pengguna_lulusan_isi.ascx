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
            Dim query As String = "SELECT COUNT(*) AS TotalResponden FROM tq_pengguna_lulusan_isi"
            Using command As New OleDb.OleDbCommand(query, connection)
                Dim totalResponden As Integer = Convert.ToInt32(command.ExecuteScalar())

                ' Tambahkan data ke dashboardData
                dashboardData.Add(New With {
                    .Total = totalResponden.ToString(),
                    .Title = "Total Responden (Pengguna Lulusan)",
                    .BgClass = "bg-aqua",
                    .Icon = "fa-solid fa-users"
                })
            End Using

            ' Query untuk mengambil semua isi dari tq_pengguna_lulusan_isi
            Dim queryIsi As String = "SELECT isi FROM tq_pengguna_lulusan_isi"
            Using command As New OleDb.OleDbCommand(queryIsi, connection)
                Dim totalSkor As Double = 0
                Dim totalRespondenIsi As Integer = 0

                Using reader As OleDb.OleDbDataReader = command.ExecuteReader()
                    While reader.Read()
                        Dim isiRaw As String = reader("isi").ToString().Trim()
                        If Not String.IsNullOrEmpty(isiRaw) Then
                            ' Hilangkan karakter terakhir jika '|'
                            If isiRaw.EndsWith("|") Then
                                isiRaw = isiRaw.Substring(0, isiRaw.Length - 1)
                            End If

                            ' Split berdasarkan '|'
                            Dim nilaiStrings() As String = isiRaw.Split("|"c)
                            Dim nilaiList As New List(Of Double)

                            For Each nilaiStr As String In nilaiStrings
                                If IsNumeric(nilaiStr) Then
                                    nilaiList.Add(Convert.ToDouble(nilaiStr))
                                End If
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
                    .Title = "Rerata Skor (Pengguna Lulusan)",
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
            New With {.ChartId = "distribusiChart", .ChartTitle = "Distribusi Skor Jawaban Setiap Pertanyaan (2018)", .ChartType = "bar", .Width = "12"}
        }
        
        rptCharts.DataSource = chartData
        rptCharts.DataBind()
    End Sub



    Sub GenerateChartConfiguration()
        Dim totalMHS As Integer = 0
        Dim totalDSN As Integer = 0
        Dim totalKRY As Integer = 0

        Dim mhs2016 As Integer = 0
        Dim dsn2016 As Integer = 0
        Dim kry2016 As Integer = 0

        Dim mhs2017 As Integer = 0
        Dim dsn2017 As Integer = 0
        Dim kry2017 As Integer = 0

        Dim mhs2018 As Integer = 0
        Dim dsn2018 As Integer = 0
        Dim kry2018 As Integer = 0

        Dim mhs2019 As Integer = 0
        Dim dsn2019 As Integer = 0
        Dim kry2019 As Integer = 0

        Dim mhs2020 As Integer = 0
        Dim dsn2020 As Integer = 0
        Dim kry2020 As Integer = 0

        Dim mhs2021 As Integer = 0
        Dim dsn2021 As Integer = 0
        Dim kry2021 As Integer = 0

        Dim mhs2022 As Integer = 0
        Dim dsn2022 As Integer = 0
        Dim kry2022 As Integer = 0

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

            ' Query untuk menghitung jumlah sts dengan isi "MHS"
            Dim queryMHS As String = "SELECT COUNT(*) AS TotalMHS FROM tqvm_hslangket WHERE sts = 'MHS'"
            Using command As New OleDb.OleDbCommand(queryMHS, connection)
                totalMHS = Convert.ToInt32(command.ExecuteScalar())
            End Using


            ' Query untuk menghitung jumlah sts dengan isi "DSN"
            Dim queryDSN As String = "SELECT COUNT(*) AS TotalDSN FROM tqvm_hslangket WHERE sts = 'DSN'"
            Using command As New OleDb.OleDbCommand(queryDSN, connection)
                totalDSN = Convert.ToInt32(command.ExecuteScalar())
            End Using


            ' Query untuk menghitung jumlah sts dengan isi "KRY"
            Dim queryKRY As String = "SELECT COUNT(*) AS TotalKRY FROM tqvm_hslangket WHERE sts = 'KRY'"
            Using command As New OleDb.OleDbCommand(queryKRY, connection)
                totalKRY = Convert.ToInt32(command.ExecuteScalar())
            End Using



            ' Query untuk menghitung jumlah sts per kategori di tahun 2016
            Dim query2016 As String = "SELECT sts, COUNT(*) AS Total FROM tqvm_hslangket WHERE thn = 2016 GROUP BY sts"
            Using command As New OleDb.OleDbCommand(query2016, connection)
                Using reader As OleDb.OleDbDataReader = command.ExecuteReader()
                    While reader.Read()
                        Dim sts As String = reader("sts").ToString()
                        Dim total As Integer = Convert.ToInt32(reader("Total"))
                        Select Case sts
                            Case "MHS"
                                mhs2016 = total
                            Case "DSN"
                                dsn2016 = total
                            Case "KRY"
                                kry2016 = total
                        End Select
                    End While
                End Using
            End Using

            ' Query untuk menghitung jumlah sts per kategori di tahun 2017
            Dim query2017 As String = "SELECT sts, COUNT(*) AS Total FROM tqvm_hslangket WHERE thn = 2017 GROUP BY sts"
            Using command As New OleDb.OleDbCommand(query2017, connection)
                Using reader As OleDb.OleDbDataReader = command.ExecuteReader()
                    While reader.Read()
                        Dim sts As String = reader("sts").ToString()
                        Dim total As Integer = Convert.ToInt32(reader("Total"))
                        Select Case sts
                            Case "MHS"
                                mhs2017 = total
                            Case "DSN"
                                dsn2017 = total
                            Case "KRY"
                                kry2017 = total
                        End Select
                    End While
                End Using
            End Using

            ' Query untuk menghitung jumlah sts per kategori di tahun 2018
            Dim query2018 As String = "SELECT sts, COUNT(*) AS Total FROM tqvm_hslangket WHERE thn = 2018 GROUP BY sts"
            Using command As New OleDb.OleDbCommand(query2018, connection)
                Using reader As OleDb.OleDbDataReader = command.ExecuteReader()
                    While reader.Read()
                        Dim sts As String = reader("sts").ToString()
                        Dim total As Integer = Convert.ToInt32(reader("Total"))
                        Select Case sts
                            Case "MHS"
                                mhs2018 = total
                            Case "DSN"
                                dsn2018 = total
                            Case "KRY"
                                kry2018 = total
                        End Select
                    End While
                End Using
            End Using

            ' Query untuk menghitung jumlah sts per kategori di tahun 2019
            Dim query2019 As String = "SELECT sts, COUNT(*) AS Total FROM tqvm_hslangket WHERE thn = 2019 GROUP BY sts"
            Using command As New OleDb.OleDbCommand(query2019, connection)
                Using reader As OleDb.OleDbDataReader = command.ExecuteReader()
                    While reader.Read()
                        Dim sts As String = reader("sts").ToString()
                        Dim total As Integer = Convert.ToInt32(reader("Total"))
                        Select Case sts
                            Case "MHS"
                                mhs2019 = total
                            Case "DSN"
                                dsn2019 = total
                            Case "KRY"
                                kry2019 = total
                        End Select
                    End While
                End Using
            End Using

            ' Query untuk menghitung jumlah sts per kategori di tahun 2020
            Dim query2020 As String = "SELECT sts, COUNT(*) AS Total FROM tqvm_hslangket WHERE thn = 2020 GROUP BY sts"
            Using command As New OleDb.OleDbCommand(query2020, connection)
                Using reader As OleDb.OleDbDataReader = command.ExecuteReader()
                    While reader.Read()
                        Dim sts As String = reader("sts").ToString()
                        Dim total As Integer = Convert.ToInt32(reader("Total"))
                        Select Case sts
                            Case "MHS"
                                mhs2020 = total
                            Case "DSN"
                                dsn2020 = total
                            Case "KRY"
                                kry2020 = total
                        End Select
                    End While
                End Using
            End Using

            ' Query untuk menghitung jumlah sts per kategori di tahun 2021
            Dim query2021 As String = "SELECT sts, COUNT(*) AS Total FROM tqvm_hslangket WHERE thn = 2021 GROUP BY sts"
            Using command As New OleDb.OleDbCommand(query2021, connection)
                Using reader As OleDb.OleDbDataReader = command.ExecuteReader()
                    While reader.Read()
                        Dim sts As String = reader("sts").ToString()
                        Dim total As Integer = Convert.ToInt32(reader("Total"))
                        Select Case sts
                            Case "MHS"
                                mhs2021 = total
                            Case "DSN"
                                dsn2021 = total
                            Case "KRY"
                                kry2021 = total
                        End Select
                    End While
                End Using
            End Using

            ' Query untuk menghitung jumlah sts per kategori di tahun 2022
            Dim query2022 As String = "SELECT sts, COUNT(*) AS Total FROM tqvm_hslangket WHERE thn = 2022 GROUP BY sts"
            Using command As New OleDb.OleDbCommand(query2022, connection)
                Using reader As OleDb.OleDbDataReader = command.ExecuteReader()
                    While reader.Read()
                        Dim sts As String = reader("sts").ToString()
                        Dim total As Integer = Convert.ToInt32(reader("Total"))
                        Select Case sts
                            Case "MHS"
                                mhs2022 = total
                            Case "DSN"
                                dsn2022 = total
                            Case "KRY"
                                kry2022 = total
                        End Select
                    End While
                End Using
            End Using



            ' Query untuk menghitung jumlah gabungan MHS, DSN, KRY di tahun 2016
            Dim queryTotal2016 As String = "SELECT COUNT(*) AS Total FROM tqvm_hslangket WHERE thn = 2016 AND sts IN ('MHS', 'DSN', 'KRY')"
            Using command As New OleDb.OleDbCommand(queryTotal2016, connection)
                total2016 = Convert.ToInt32(command.ExecuteScalar())
            End Using

            ' Query untuk menghitung jumlah gabungan MHS, DSN, KRY di tahun 2017
            Dim queryTotal2017 As String = "SELECT COUNT(*) AS Total FROM tqvm_hslangket WHERE thn = 2017 AND sts IN ('MHS', 'DSN', 'KRY')"
            Using command As New OleDb.OleDbCommand(queryTotal2017, connection)
                total2017 = Convert.ToInt32(command.ExecuteScalar())
            End Using

            ' Query untuk menghitung jumlah gabungan MHS, DSN, KRY di tahun 2018
            Dim queryTotal2018 As String = "SELECT COUNT(*) AS Total FROM tqvm_hslangket WHERE thn = 2018 AND sts IN ('MHS', 'DSN', 'KRY')"
            Using command As New OleDb.OleDbCommand(queryTotal2018, connection)
                total2018 = Convert.ToInt32(command.ExecuteScalar())
            End Using

            ' Query untuk menghitung jumlah gabungan MHS, DSN, KRY di tahun 2019
            Dim queryTotal2019 As String = "SELECT COUNT(*) AS Total FROM tqvm_hslangket WHERE thn = 2019 AND sts IN ('MHS', 'DSN', 'KRY')"
            Using command As New OleDb.OleDbCommand(queryTotal2019, connection)
                total2019 = Convert.ToInt32(command.ExecuteScalar())
            End Using

            ' Query untuk menghitung jumlah gabungan MHS, DSN, KRY di tahun 2020
            Dim queryTotal2020 As String = "SELECT COUNT(*) AS Total FROM tqvm_hslangket WHERE thn = 2020 AND sts IN ('MHS', 'DSN', 'KRY')"
            Using command As New OleDb.OleDbCommand(queryTotal2020, connection)
                total2020 = Convert.ToInt32(command.ExecuteScalar())
            End Using

            ' Query untuk menghitung jumlah gabungan MHS, DSN, KRY di tahun 2021
            Dim queryTotal2021 As String = "SELECT COUNT(*) AS Total FROM tqvm_hslangket WHERE thn = 2021 AND sts IN ('MHS', 'DSN', 'KRY')"
            Using command As New OleDb.OleDbCommand(queryTotal2021, connection)
                total2021 = Convert.ToInt32(command.ExecuteScalar())
            End Using

            ' Query untuk menghitung jumlah gabungan MHS, DSN, KRY di tahun 2022
            Dim queryTotal2022 As String = "SELECT COUNT(*) AS Total FROM tqvm_hslangket WHERE thn = 2022 AND sts IN ('MHS', 'DSN', 'KRY')"
            Using command As New OleDb.OleDbCommand(queryTotal2022, connection)
                total2022 = Convert.ToInt32(command.ExecuteScalar())
            End Using

        End Using



        Dim chartDetails As New List(Of Object) From {
            New With {.id = "garisChart", .type = "line", .labels = "2016,2017,2018,2019,2020,2021,2022", .data = "Mahasiswa:" & mhs2016.ToString() & "," & mhs2017.ToString() & "," & mhs2018.ToString() & "," & mhs2019.ToString() & "," & mhs2020.ToString() & "," & mhs2021.ToString() & "," & mhs2022.ToString() &
            ",0,0,0,0,0|Dosen:" & dsn2016.ToString() & "," & dsn2017.ToString() & "," & dsn2018.ToString() & "," & dsn2019.ToString() & "," & dsn2020.ToString() & "," & dsn2021.ToString() & "," & dsn2022.ToString() &
            ",0,0,0,0,0|Karyawan:" & kry2016.ToString() & "," & kry2017.ToString() & "," & kry2018.ToString() & "," & kry2019.ToString() & "," & kry2020.ToString() & "," & kry2021.ToString() & "," & kry2022.ToString() &
            ",0,0,0,0,0", .isMulti = True, .showLegend = True},
            New With {.id = "garisChart2", .type = "line", .labels = "2016,2017,2018,2019,2020,2021,2022", .data = "Jumlah Gabungan Responden (Mahasiswa, Dosen, Karyawan):" & total2016.ToString() & "," & total2017.ToString() & "," & total2018.ToString() & "," & total2019.ToString() & "," & total2020.ToString() & "," & total2021.ToString() & "," & total2022.ToString() &
            ",0,0,0,0,0", .isMulti = True, .showLegend = True}
        }



        Dim distribusi(6, 3) As Integer ' 7 pertanyaan × skor 1–4
        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()
            Dim cmd As New OleDb.OleDbCommand("SELECT isi FROM dbo.tq_pengguna_lulusan_isi WHERE isi IS NOT NULL", connection)
            Dim reader As OleDb.OleDbDataReader = cmd.ExecuteReader()
            While reader.Read()
            Dim isi As String = reader("isi").ToString().Trim()
            If isi.EndsWith("|") Then
                isi = isi.Substring(0, isi.Length - 1) ' Hilangkan karakter "|" di akhir jika ada
            End If
            Dim nilaiStrings() As String = isi.Split("|"c)
            For i As Integer = 0 To Math.Min(nilaiStrings.Length, 7) - 1
                Dim skor As Integer
                If Integer.TryParse(nilaiStrings(i), skor) Then
                If skor >= 1 AndAlso skor <= 4 Then
                    distribusi(i, skor - 1) += 1
                End If
                End If
            Next
            End While
            reader.Close()
        End Using

        ' Labels pertanyaan
        Dim labelsDistribusi As String = "Pertanyaan 1,Pertanyaan 2,Pertanyaan 3,Pertanyaan 4,Pertanyaan 5,Pertanyaan 6,Pertanyaan 7"

        ' Dataset per skor 1–4
        Dim dataParts As New List(Of String)
        For skor As Integer = 1 To 4
            Dim values As New List(Of String)
            For q As Integer = 0 To 6
            values.Add(distribusi(q, skor - 1).ToString())
            Next
            dataParts.Add("Skor " & skor & ":" & String.Join(",", values))
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
    <h1>DASHBOARD PENGGUNA LULUSAN</h1>
    <ol class="breadcrumb">
        <li><a href="/dashboard_kuesioner/index.aspx"><i class="fa fa-dashboard"></i> Dashboard</a></li>
        <li class="active">Dashboard Pengguna Lulusan</li>
    </ol>

    <!-- Tombol View All sebagai LinkButton server-side -->
    <div class="box-footer text-center" style="margin-top: 15px;">
        <asp:LinkButton ID="btnViewAll" runat="server" CssClass="btn btn-default" OnClick="btnViewAll_Click">
            Data Lengkap Tahunan Pengguna Lulusan
        </asp:LinkButton>
    </div>
</section>








<!-- Modal View All -->
<div class="modal fade" id="modal-view-all" tabindex="-1" role="dialog" aria-labelledby="modalLabel" aria-hidden="true">
    <div class="modal-dialog" style="width:850px;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="modalLabel">Data Lengkap Tahunan Pengguna Lulusan</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>

            <div class="modal-body">
                <!-- Dropdown Tahun -->
                <asp:DropDownList ID="ddlTahun" runat="server" 
                    AutoPostBack="True" 
                    OnSelectedIndexChanged="ddlTahun_SelectedIndexChanged"
                    CssClass="form-control" 
                    style="width: 200px; margin-bottom: 10px;">
                </asp:DropDownList>

                <!-- Dropdown Prodi -->
                <asp:DropDownList ID="ddlProdi" runat="server" 
                    AutoPostBack="True" 
                    OnSelectedIndexChanged="ddlProdi_SelectedIndexChanged" 
                    CssClass="form-control" 
                    style="width: 300px; margin-bottom: 10px;">
                </asp:DropDownList>

                <!-- Label total responden -->
                <asp:Label ID="lblTotalResponden" runat="server" Font-Bold="True" />
                <br />
                <asp:Label ID="lblPerStatus" runat="server" Font-Bold="True" />
                <br />

                <!-- GridView -->
                <asp:GridView ID="GridViewTabelTahunan" runat="server" 
                    CssClass="table table-bordered table-striped" 
                    AutoGenerateColumns="False">
                    <Columns>
                        <asp:BoundField DataField="tahun" HeaderText="Tahun" />
                        <asp:BoundField DataField="kd_jur" HeaderText="Kode Jurusan" />
                        <asp:BoundField DataField="perusahaan" HeaderText="Perusahaan" />
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

' === KONFIGURASI KONEKSI DATABASE ===
Dim connectionString As String = "Provider=sqloledb;Data Source=10.200.120.83,1433;Network Library=DBMSSOCN;Initial Catalog=lintar2022;User ID=sa;Password=dbTesting2023;connect timeout=200;pooling=false;max pool size=200"


' === EVENT: Tombol View All ===
Protected Sub btnViewAll_Click(sender As Object, e As EventArgs)
    LoadTahunDropdown()
    LoadProdiDropdown()

    ' Kalau dropdown belum punya data, tidak usah lanjut
    If ddlTahun.Items.Count = 0 Then Exit Sub

    ' Pilih tahun pertama
    ddlTahun.SelectedIndex = 0

    ' Jalankan semua loader
    LoadGridViewData(ddlTahun.SelectedValue)
    LoadDashboardData()
    LoadChartData()
    GenerateChartConfiguration()

    ' Pastikan modal muncul lagi
    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowModal", "$('#modal-view-all').modal('show');", True)
End Sub


' === EVENT: Dropdown Tahun berubah ===
Protected Sub ddlTahun_SelectedIndexChanged(sender As Object, e As EventArgs)
    LoadGridViewData(ddlTahun.SelectedValue)
    LoadDashboardData()
    LoadChartData()
    GenerateChartConfiguration()

    ' Pastikan modal muncul lagi setelah postback
    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowModal", "$('#modal-view-all').modal('show');", True)
End Sub


' === EVENT: Dropdown Prodi berubah ===
Protected Sub ddlProdi_SelectedIndexChanged(sender As Object, e As EventArgs)
    LoadGridViewData(ddlTahun.SelectedValue)
    LoadDashboardData()
    LoadChartData()
    GenerateChartConfiguration()

    ' Pastikan modal muncul lagi
    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowModal", "$('#modal-view-all').modal('show');", True)
End Sub


' === LOAD DROPDOWN TAHUN ===
Private Sub LoadTahunDropdown()
    Dim query As String = "SELECT DISTINCT tahun FROM dbo.tq_pengguna_lulusan_isi ORDER BY tahun"

    Using conn As New System.Data.OleDb.OleDbConnection(connectionString)
        Using cmd As New System.Data.OleDb.OleDbCommand(query, conn)
            conn.Open()
            Dim reader = cmd.ExecuteReader()
            ddlTahun.Items.Clear()

            While reader.Read()
                Dim th As String = reader("tahun").ToString()
                ddlTahun.Items.Add(New ListItem(th, th))
            End While
        End Using
    End Using
End Sub


' === LOAD DROPDOWN PRODI ===
Private Sub LoadProdiDropdown()
    ddlProdi.Items.Clear()
    ddlProdi.Items.Add(New ListItem("Manajemen Bisnis", "111"))
End Sub


' === LOAD DATA GRIDVIEW ===
Private Sub LoadGridViewData(tahun As String)
    Dim selectedProdi As String = ddlProdi.SelectedValue

    Dim query As String = _
        "SELECT " & _
        "i.tahun, " & _
        "i.kd_jur, " & _
        "p.perusahaan, " & _
        "i.isi " & _
        "FROM dbo.tq_pengguna_lulusan_isi AS i " & _
        "INNER JOIN dbo.tq_pengguna_lulusan_persh AS p " & _
        "ON i.id_perusahaan = p.recid " & _
        "AND i.tahun = p.tahun " & _
        "AND i.kd_jur = p.kd_jur " & _
        "WHERE i.tahun = ?"

    If Not String.IsNullOrEmpty(selectedProdi) Then
        query &= " AND i.kd_jur = ?"
    End If

    Using conn As New System.Data.OleDb.OleDbConnection(connectionString)
        Using cmd As New System.Data.OleDb.OleDbCommand(query, conn)
            cmd.Parameters.AddWithValue("@tahun", tahun)
            If Not String.IsNullOrEmpty(selectedProdi) Then
                cmd.Parameters.AddWithValue("@kd_jur", selectedProdi)
            End If

            Dim adapter As New System.Data.OleDb.OleDbDataAdapter(cmd)
            Dim dt As New System.Data.DataTable()
            adapter.Fill(dt)

            ' Tambah kolom perhitungan
            If Not dt.Columns.Contains("Rerata") Then dt.Columns.Add("Rerata", GetType(Double))
            If Not dt.Columns.Contains("Total") Then dt.Columns.Add("Total", GetType(Double))

            ' Hitung Rerata & Total per baris
            For Each row As DataRow In dt.Rows
                Dim isiString As String = Convert.ToString(row("isi"))
                row("Rerata") = HitungRerataDigit(isiString)
                row("Total") = HitungTotalDigit(isiString)
            Next

            lblTotalResponden.Text = "Total Responden: " & dt.Rows.Count

            GridViewTabelTahunan.DataSource = dt
            GridViewTabelTahunan.DataBind()
        End Using
    End Using
End Sub


' === FUNGSI MENGHITUNG RERATA ===
Private Function HitungRerataDigit(text As String) As Double
    If String.IsNullOrEmpty(text) Then Return 0
    Dim digits As New List(Of Integer)

    For Each ch As Char In text
        If Char.IsDigit(ch) Then digits.Add(Convert.ToInt32(Char.GetNumericValue(ch)))
    Next

    If digits.Count = 0 Then Return 0
    Return Math.Round(digits.Average(), 2)
End Function


' === FUNGSI MENGHITUNG TOTAL ===
Private Function HitungTotalDigit(text As String) As Double
    If String.IsNullOrEmpty(text) Then Return 0
    Dim total As Integer = 0

    For Each ch As Char In text
        If Char.IsDigit(ch) Then total += Convert.ToInt32(Char.GetNumericValue(ch))
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
    Chart.register(ChartDataLabels); // aktifkan plugin data labels

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

                                // Kalau warna batang/hirisan hitam → teks putih, selain itu hitam
                                if (Array.isArray(bgColor)) {
                                    const c = bgColor[context.dataIndex] || '#000';
                                    return c.toLowerCase() === '#000000' ? '#fff' : '#000';
                                } else {
                                    return bgColor && bgColor.toLowerCase() === '#000000' ? '#fff' : '#000';
                                }
                            },
                            font: {
                                weight: 'bold',
                                size: 12
                            },
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
                            align: function(ctx) {
                                if (ctx.chart.config.type === 'bar') return 'center';
                                return 'center';
                            }
                        },
                        legend: {
                            display: config.options.plugins.legend.display
                        },
                        tooltip: {
                            enabled: true
                        }
                    }
                },
                plugins: [ChartDataLabels] // daftar plugin aktif
            });
        }
    });
});
</script>


<!-- Menampilkan Icon Font Awesome Pro/Premium -->
<link rel="stylesheet" href="https://site-assets.fontawesome.com/releases/v6.4.2/css/all.css">