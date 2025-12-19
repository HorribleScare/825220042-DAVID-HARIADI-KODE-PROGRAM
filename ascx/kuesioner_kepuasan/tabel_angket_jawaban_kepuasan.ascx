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
            
            ' Query untuk menghitung total jumlah responden dari tiga tabel
            Dim query As String = "SELECT (SELECT COUNT(*) FROM t_angket_jawab_dsn) + (SELECT COUNT(*) FROM t_angket_jawab_kry) + (SELECT COUNT(*) FROM t_angket_jawab_mhs) AS TotalResponden"
            Using command As New OleDb.OleDbCommand(query, connection)
                Dim totalResponden As Integer = Convert.ToInt32(command.ExecuteScalar())
                
                ' Tambahkan data ke dashboardData
                dashboardData.Add(New With {.Total = totalResponden.ToString(), .Title = "Total Responden", .BgClass = "bg-aqua", .Icon = "fa-solid fa-users"})
            End Using

            ' Query untuk menghitung jumlah sts dengan isi "MHS"
            Dim query2 As String = "SELECT COUNT(*) AS TotalMHS FROM t_angket_jawab_mhs"
            Using command As New OleDb.OleDbCommand(query2, connection)
                Dim totalMHS As Integer = Convert.ToInt32(command.ExecuteScalar())
                
                ' Tambahkan data ke dashboardData
                dashboardData.Add(New With {.Total = totalMHS.ToString(), .Title = "Total Responden Mahasiswa", .BgClass = "bg-maroon", .Icon = "fa-solid fa-user-graduate"})
            End Using
            

            ' Query untuk menghitung jumlah sts dengan isi "DSN"
            Dim query3 As String = "SELECT COUNT(*) AS TotalDSN FROM t_angket_jawab_dsn"
            Using command As New OleDb.OleDbCommand(query3, connection)
                Dim totalDSN As Integer = Convert.ToInt32(command.ExecuteScalar())
                
                ' Tambahkan data ke dashboardData
                dashboardData.Add(New With {.Total = totalDSN.ToString(), .Title = "Total Responden Dosen", .BgClass = "bg-teal", .Icon = "fa-solid fa-chalkboard-teacher"})
            End Using


            ' Query untuk menghitung jumlah sts dengan isi "KRY"
            Dim query4 As String = "SELECT COUNT(*) AS TotalKRY FROM t_angket_jawab_kry"
            Using command As New OleDb.OleDbCommand(query4, connection)
                Dim totalKRY As Integer = Convert.ToInt32(command.ExecuteScalar())
                
                ' Tambahkan data ke dashboardData
                dashboardData.Add(New With {.Total = totalKRY.ToString(), .Title = "Total Responden Karyawan", .BgClass = "bg-purple", .Icon = "fa-solid fa-people-carry-box"})
            End Using


            ' Query untuk mengambil semua isi dari t_angket_jawab_mhs, t_angket_jawab_dsn, dan t_angket_jawab_kry
            Dim queryIsi As String = "SELECT pilihan FROM dbo.t_angket_jawab_mhs " & _
                "UNION ALL " & _
                "SELECT pilihan FROM dbo.t_angket_jawab_dsn " & _
                "UNION ALL " & _
                "SELECT pilihan FROM dbo.t_angket_jawab_kry"

            Using command As New OleDb.OleDbCommand(queryIsi, connection)
                Dim totalSkor As Double = 0
                Dim totalRespondenIsi As Integer = 0

                Using reader As OleDb.OleDbDataReader = command.ExecuteReader()
                    While reader.Read()
                        Dim pilihanRaw As String = reader("pilihan").ToString().Trim()
                        If Not String.IsNullOrEmpty(pilihanRaw) Then
                            Dim nilaiList As New List(Of Double)

                            ' Pecah tiap karakter menjadi angka
                            For i As Integer = 0 To pilihanRaw.Length - 1
                                Dim ch As Char = pilihanRaw(i)
                                If Char.IsDigit(ch) Then
                                    nilaiList.Add(Convert.ToDouble(ch.ToString()))
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
                    .Title = "Rerata Skor (Kepuasan)",
                    .BgClass = "bg-aqua",
                    .Icon = "fa-solid fa-chart-line"
                })
            End Using



            ' Query untuk mengambil semua isi dari t_angket_jawab_mhs
            Dim queryIsiMahasiswa As String = "SELECT pilihan FROM dbo.t_angket_jawab_mhs"

            Using command As New OleDb.OleDbCommand(queryIsiMahasiswa, connection)
                Dim totalSkor As Double = 0
                Dim totalRespondenIsi As Integer = 0

                Using reader As OleDb.OleDbDataReader = command.ExecuteReader()
                    While reader.Read()
                        Dim pilihanRaw As String = reader("pilihan").ToString().Trim()
                        If Not String.IsNullOrEmpty(pilihanRaw) Then
                            Dim nilaiList As New List(Of Double)

                            ' Pecah tiap karakter menjadi angka
                            For i As Integer = 0 To pilihanRaw.Length - 1
                                Dim ch As Char = pilihanRaw(i)
                                If Char.IsDigit(ch) Then
                                    nilaiList.Add(Convert.ToDouble(ch.ToString()))
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
                    .Title = "Rerata Skor (Mahasiswa)",
                    .BgClass = "bg-maroon",
                    .Icon = "fa-solid fa-chart-line"
                })
            End Using



            ' Query untuk mengambil semua isi dari t_angket_jawab_dsn
            Dim queryIsiDosen As String = "SELECT pilihan FROM dbo.t_angket_jawab_dsn"

            Using command As New OleDb.OleDbCommand(queryIsiDosen, connection)
                Dim totalSkor As Double = 0
                Dim totalRespondenIsi As Integer = 0

                Using reader As OleDb.OleDbDataReader = command.ExecuteReader()
                    While reader.Read()
                        Dim pilihanRaw As String = reader("pilihan").ToString().Trim()
                        If Not String.IsNullOrEmpty(pilihanRaw) Then
                            Dim nilaiList As New List(Of Double)

                            ' Pecah tiap karakter menjadi angka
                            For i As Integer = 0 To pilihanRaw.Length - 1
                                Dim ch As Char = pilihanRaw(i)
                                If Char.IsDigit(ch) Then
                                    nilaiList.Add(Convert.ToDouble(ch.ToString()))
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
                    .Title = "Rerata Skor (Dosen)",
                    .BgClass = "bg-teal",
                    .Icon = "fa-solid fa-chart-line"
                })
            End Using



            ' Query untuk mengambil semua isi dari t_angket_jawab_kry
            Dim queryIsiKaryawan As String = "SELECT pilihan FROM dbo.t_angket_jawab_kry"

            Using command As New OleDb.OleDbCommand(queryIsiKaryawan, connection)
                Dim totalSkor As Double = 0
                Dim totalRespondenIsi As Integer = 0

                Using reader As OleDb.OleDbDataReader = command.ExecuteReader()
                    While reader.Read()
                        Dim pilihanRaw As String = reader("pilihan").ToString().Trim()
                        If Not String.IsNullOrEmpty(pilihanRaw) Then
                            Dim nilaiList As New List(Of Double)

                            ' Pecah tiap karakter menjadi angka
                            For i As Integer = 0 To pilihanRaw.Length - 1
                                Dim ch As Char = pilihanRaw(i)
                                If Char.IsDigit(ch) Then
                                    nilaiList.Add(Convert.ToDouble(ch.ToString()))
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
                    .Title = "Rerata Skor (Karyawan)",
                    .BgClass = "bg-purple",
                    .Icon = "fa-solid fa-chart-line"
                })
            End Using



            End Using
            rptDashboard.DataSource = dashboardData
            rptDashboard.DataBind()
        End Sub






    Sub LoadChartData()
        Dim chartData As New List(Of Object) From {
            New With {.ChartId = "persentaseChart", .ChartTitle = "Persentase Responden", .ChartType = "pie", .Width = "4"},
            New With {.ChartId = "batangChart", .ChartTitle = "Total Jumlah Responden Tahunan", .ChartType = "bar", .Width = "8"},
            New With {.ChartId = "garisChart", .ChartTitle = "Tren Jumlah Responden Tahunan", .ChartType = "line", .Width = "6"},
            New With {.ChartId = "garisChart2", .ChartTitle = "Tren Jumlah Gabungan Responden Tahunan", .ChartType = "line", .Width = "6"},
            New With {.ChartId = "distribusiChartKeseluruhan", .ChartTitle = "Distribusi Skor Jawaban Setiap Pertanyaan (2016-2022)", .ChartType = "bar", .Width = "12"},
            New With {.ChartId = "distribusiChart", .ChartTitle = "Distribusi Skor Jawaban Mahasiswa (2016-2022)", .ChartType = "bar", .Width = "12"},
            New With {.ChartId = "distribusiChart2", .ChartTitle = "Distribusi Skor Jawaban Dosen (2016-2022)", .ChartType = "bar", .Width = "12"},
            New With {.ChartId = "distribusiChart3", .ChartTitle = "Distribusi Skor Jawaban Karyawan (2016-2022)", .ChartType = "bar", .Width = "12"}
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
            Dim queryMHS As String = "SELECT COUNT(*) AS TotalMHS FROM t_angket_jawab_mhs"
            Using command As New OleDb.OleDbCommand(queryMHS, connection)
                totalMHS = Convert.ToInt32(command.ExecuteScalar())
            End Using

            ' Query untuk menghitung jumlah sts dengan isi "DSN"
            Dim queryDSN As String = "SELECT COUNT(*) AS TotalDSN FROM t_angket_jawab_dsn"
            Using command As New OleDb.OleDbCommand(queryDSN, connection)
                totalDSN = Convert.ToInt32(command.ExecuteScalar())
            End Using

            ' Query untuk menghitung jumlah sts dengan isi "KRY"
            Dim queryKRY As String = "SELECT COUNT(*) AS TotalKRY FROM t_angket_jawab_kry"
            Using command As New OleDb.OleDbCommand(queryKRY, connection)
                totalKRY = Convert.ToInt32(command.ExecuteScalar())
            End Using



            ' Query untuk menghitung jumlah baris tahun 2016 dari masing-masing tabel
            Dim queryAngketmhs2016 As String = "SELECT COUNT(*) AS Total FROM t_angket_jawab_mhs WHERE ISNUMERIC(tahun) = 1 AND tahun = '2016'"
            Dim queryAngketdsn2016 As String = "SELECT COUNT(*) AS Total FROM t_angket_jawab_dsn WHERE ISNUMERIC(tahun) = 1 AND tahun = '2016'"
            Dim queryAngketkry2016 As String = "SELECT COUNT(*) AS Total FROM t_angket_jawab_kry WHERE ISNUMERIC(tahun) = 1 AND tahun = '2016'"

                ' Hitung total dari tabel mahasiswa
                Using command As New OleDb.OleDbCommand(queryAngketmhs2016, connection)
                    mhs2016 = Convert.ToInt32(command.ExecuteScalar())
                End Using

                ' Hitung total dari tabel dosen
                Using command As New OleDb.OleDbCommand(queryAngketdsn2016, connection)
                    dsn2016 = Convert.ToInt32(command.ExecuteScalar())
                End Using

                ' Hitung total dari tabel karyawan
                Using command As New OleDb.OleDbCommand(queryAngketkry2016, connection)
                    kry2016 = Convert.ToInt32(command.ExecuteScalar())
                End Using




                ' Query untuk menghitung jumlah baris tahun 2017 dari masing-masing tabel
                Dim queryAngketmhs2017 As String = "SELECT COUNT(*) AS Total FROM t_angket_jawab_mhs WHERE ISNUMERIC(tahun) = 1 AND tahun = '2017'"
                Dim queryAngketdsn2017 As String = "SELECT COUNT(*) AS Total FROM t_angket_jawab_dsn WHERE ISNUMERIC(tahun) = 1 AND tahun = '2017'"
                Dim queryAngketkry2017 As String = "SELECT COUNT(*) AS Total FROM t_angket_jawab_kry WHERE ISNUMERIC(tahun) = 1 AND tahun = '2017'"

                    ' Hitung total dari tabel mahasiswa
                    Using command As New OleDb.OleDbCommand(queryAngketmhs2017, connection)
                        mhs2017 = Convert.ToInt32(command.ExecuteScalar())
                    End Using

                    ' Hitung total dari tabel dosen
                    Using command As New OleDb.OleDbCommand(queryAngketdsn2017, connection)
                        dsn2017 = Convert.ToInt32(command.ExecuteScalar())
                    End Using

                    ' Hitung total dari tabel karyawan
                    Using command As New OleDb.OleDbCommand(queryAngketkry2017, connection)
                        kry2017 = Convert.ToInt32(command.ExecuteScalar())
                    End Using


            
                ' Query untuk menghitung jumlah baris tahun 2018 dari masing-masing tabel
                Dim queryAngketmhs2018 As String = "SELECT COUNT(*) AS Total FROM t_angket_jawab_mhs WHERE ISNUMERIC(tahun) = 1 AND tahun = '2018'"
                Dim queryAngketdsn2018 As String = "SELECT COUNT(*) AS Total FROM t_angket_jawab_dsn WHERE ISNUMERIC(tahun) = 1 AND tahun = '2018'"
                Dim queryAngketkry2018 As String = "SELECT COUNT(*) AS Total FROM t_angket_jawab_kry WHERE ISNUMERIC(tahun) = 1 AND tahun = '2018'"

                ' Hitung total dari tabel mahasiswa
                Using command As New OleDb.OleDbCommand(queryAngketmhs2018, connection)
                    mhs2018 = Convert.ToInt32(command.ExecuteScalar())
                End Using

                ' Hitung total dari tabel dosen
                Using command As New OleDb.OleDbCommand(queryAngketdsn2018, connection)
                    dsn2018 = Convert.ToInt32(command.ExecuteScalar())
                End Using

                ' Hitung total dari tabel karyawan
                Using command As New OleDb.OleDbCommand(queryAngketkry2018, connection)
                    kry2018 = Convert.ToInt32(command.ExecuteScalar())
                End Using





                ' Query untuk menghitung jumlah baris tahun 2019 dari masing-masing tabel
                Dim queryAngketmhs2019 As String = "SELECT COUNT(*) AS Total FROM t_angket_jawab_mhs WHERE ISNUMERIC(tahun) = 1 AND tahun = '2019'"
                Dim queryAngketdsn2019 As String = "SELECT COUNT(*) AS Total FROM t_angket_jawab_dsn WHERE ISNUMERIC(tahun) = 1 AND tahun = '2019'"
                Dim queryAngketkry2019 As String = "SELECT COUNT(*) AS Total FROM t_angket_jawab_kry WHERE ISNUMERIC(tahun) = 1 AND tahun = '2019'"

                ' Hitung total dari tabel mahasiswa
                Using command As New OleDb.OleDbCommand(queryAngketmhs2019, connection)
                    mhs2019 = Convert.ToInt32(command.ExecuteScalar())
                End Using

                ' Hitung total dari tabel dosen
                Using command As New OleDb.OleDbCommand(queryAngketdsn2019, connection)
                    dsn2019 = Convert.ToInt32(command.ExecuteScalar())
                End Using

                ' Hitung total dari tabel karyawan
                Using command As New OleDb.OleDbCommand(queryAngketkry2019, connection)
                    kry2019 = Convert.ToInt32(command.ExecuteScalar())
                End Using





                ' Query untuk menghitung jumlah baris tahun 2020 dari masing-masing tabel
                Dim queryAngketmhs2020 As String = "SELECT COUNT(*) AS Total FROM t_angket_jawab_mhs WHERE ISNUMERIC(tahun) = 1 AND tahun = '2020'"
                Dim queryAngketdsn2020 As String = "SELECT COUNT(*) AS Total FROM t_angket_jawab_dsn WHERE ISNUMERIC(tahun) = 1 AND tahun = '2020'"
                Dim queryAngketkry2020 As String = "SELECT COUNT(*) AS Total FROM t_angket_jawab_kry WHERE ISNUMERIC(tahun) = 1 AND tahun = '2020'"

                ' Hitung total dari tabel mahasiswa
                Using command As New OleDb.OleDbCommand(queryAngketmhs2020, connection)
                    mhs2020 = Convert.ToInt32(command.ExecuteScalar())
                End Using

                ' Hitung total dari tabel dosen
                Using command As New OleDb.OleDbCommand(queryAngketdsn2020, connection)
                    dsn2020 = Convert.ToInt32(command.ExecuteScalar())
                End Using

                ' Hitung total dari tabel karyawan
                Using command As New OleDb.OleDbCommand(queryAngketkry2020, connection)
                    kry2020 = Convert.ToInt32(command.ExecuteScalar())
                End Using






                ' Query untuk menghitung jumlah baris tahun 2021 dari masing-masing tabel
                Dim queryAngketmhs2021 As String = "SELECT COUNT(*) AS Total FROM t_angket_jawab_mhs WHERE ISNUMERIC(tahun) = 1 AND tahun = '2021'"
                Dim queryAngketdsn2021 As String = "SELECT COUNT(*) AS Total FROM t_angket_jawab_dsn WHERE ISNUMERIC(tahun) = 1 AND tahun = '2021'"
                Dim queryAngketkry2021 As String = "SELECT COUNT(*) AS Total FROM t_angket_jawab_kry WHERE ISNUMERIC(tahun) = 1 AND tahun = '2021'"

                ' Hitung total dari tabel mahasiswa
                Using command As New OleDb.OleDbCommand(queryAngketmhs2021, connection)
                    mhs2021 = Convert.ToInt32(command.ExecuteScalar())
                End Using

                ' Hitung total dari tabel dosen
                Using command As New OleDb.OleDbCommand(queryAngketdsn2021, connection)
                    dsn2021 = Convert.ToInt32(command.ExecuteScalar())
                End Using

                ' Hitung total dari tabel karyawan
                Using command As New OleDb.OleDbCommand(queryAngketkry2021, connection)
                    kry2021 = Convert.ToInt32(command.ExecuteScalar())
                End Using






                ' Query untuk menghitung jumlah baris tahun 2020 dari masing-masing tabel
                Dim queryAngketmhs2022 As String = "SELECT COUNT(*) AS Total FROM t_angket_jawab_mhs WHERE ISNUMERIC(tahun) = 1 AND tahun = '2022'"
                Dim queryAngketdsn2022 As String = "SELECT COUNT(*) AS Total FROM t_angket_jawab_dsn WHERE ISNUMERIC(tahun) = 1 AND tahun = '2022'"
                Dim queryAngketkry2022 As String = "SELECT COUNT(*) AS Total FROM t_angket_jawab_kry WHERE ISNUMERIC(tahun) = 1 AND tahun = '2022'"

                ' Hitung total dari tabel mahasiswa
                Using command As New OleDb.OleDbCommand(queryAngketmhs2022, connection)
                    mhs2022 = Convert.ToInt32(command.ExecuteScalar())
                End Using

                ' Hitung total dari tabel dosen
                Using command As New OleDb.OleDbCommand(queryAngketdsn2022, connection)
                    dsn2022 = Convert.ToInt32(command.ExecuteScalar())
                End Using

                ' Hitung total dari tabel karyawan
                Using command As New OleDb.OleDbCommand(queryAngketkry2022, connection)
                    kry2022 = Convert.ToInt32(command.ExecuteScalar())
                End Using

            


            ' Query untuk menghitung jumlah gabungan MHS, DSN, KRY di tahun 2016
            Dim queryTotal2016 As String = "SELECT " & _
                "(SELECT COUNT(*) FROM t_angket_jawab_dsn WHERE ISNUMERIC(tahun) = 1 AND tahun = 2016) + " & _
                "(SELECT COUNT(*) FROM t_angket_jawab_kry WHERE ISNUMERIC(tahun) = 1 AND tahun = 2016) + " & _
                "(SELECT COUNT(*) FROM t_angket_jawab_mhs WHERE ISNUMERIC(tahun) = 1 AND tahun = 2016) AS Total"
            Using command As New OleDb.OleDbCommand(queryTotal2016, connection)
                total2016 = Convert.ToInt32(command.ExecuteScalar())
            End Using


            ' Query untuk menghitung jumlah gabungan MHS, DSN, KRY di tahun 2017
            Dim queryTotal2017 As String = "SELECT " & _
                "(SELECT COUNT(*) FROM t_angket_jawab_dsn WHERE ISNUMERIC(tahun) = 1 AND tahun = 2017) + " & _
                "(SELECT COUNT(*) FROM t_angket_jawab_kry WHERE ISNUMERIC(tahun) = 1 AND tahun = 2017) + " & _
                "(SELECT COUNT(*) FROM t_angket_jawab_mhs WHERE ISNUMERIC(tahun) = 1 AND tahun = 2017) AS Total"
            Using command As New OleDb.OleDbCommand(queryTotal2017, connection)
                total2017 = Convert.ToInt32(command.ExecuteScalar())
            End Using



            ' Query untuk menghitung jumlah gabungan MHS, DSN, KRY di tahun 2018
            Dim queryTotal2018 As String = "SELECT " & _
                "(SELECT COUNT(*) FROM t_angket_jawab_dsn WHERE ISNUMERIC(tahun) = 1 AND tahun = 2018) + " & _
                "(SELECT COUNT(*) FROM t_angket_jawab_kry WHERE ISNUMERIC(tahun) = 1 AND tahun = 2018) + " & _
                "(SELECT COUNT(*) FROM t_angket_jawab_mhs WHERE ISNUMERIC(tahun) = 1 AND tahun = 2018) AS Total"
            Using command As New OleDb.OleDbCommand(queryTotal2018, connection)
                total2018 = Convert.ToInt32(command.ExecuteScalar())
            End Using




            ' Query untuk menghitung jumlah gabungan MHS, DSN, KRY di tahun 2019
            Dim queryTotal2019 As String = "SELECT " & _
                "(SELECT COUNT(*) FROM t_angket_jawab_dsn WHERE ISNUMERIC(tahun) = 1 AND tahun = 2019) + " & _
                "(SELECT COUNT(*) FROM t_angket_jawab_kry WHERE ISNUMERIC(tahun) = 1 AND tahun = 2019) + " & _
                "(SELECT COUNT(*) FROM t_angket_jawab_mhs WHERE ISNUMERIC(tahun) = 1 AND tahun = 2019) AS Total"
            Using command As New OleDb.OleDbCommand(queryTotal2019, connection)
                total2019 = Convert.ToInt32(command.ExecuteScalar())
            End Using





            ' Query untuk menghitung jumlah gabungan MHS, DSN, KRY di tahun 2020
            Dim queryTotal2020 As String = "SELECT " & _
                "(SELECT COUNT(*) FROM t_angket_jawab_dsn WHERE ISNUMERIC(tahun) = 1 AND tahun = 2020) + " & _
                "(SELECT COUNT(*) FROM t_angket_jawab_kry WHERE ISNUMERIC(tahun) = 1 AND tahun = 2020) + " & _
                "(SELECT COUNT(*) FROM t_angket_jawab_mhs WHERE ISNUMERIC(tahun) = 1 AND tahun = 2020) AS Total"
            Using command As New OleDb.OleDbCommand(queryTotal2020, connection)
                total2020 = Convert.ToInt32(command.ExecuteScalar())
            End Using





            ' Query untuk menghitung jumlah gabungan MHS, DSN, KRY di tahun 2021
            Dim queryTotal2021 As String = "SELECT " & _
                "(SELECT COUNT(*) FROM t_angket_jawab_dsn WHERE ISNUMERIC(tahun) = 1 AND tahun = 2021) + " & _
                "(SELECT COUNT(*) FROM t_angket_jawab_kry WHERE ISNUMERIC(tahun) = 1 AND tahun = 2021) + " & _
                "(SELECT COUNT(*) FROM t_angket_jawab_mhs WHERE ISNUMERIC(tahun) = 1 AND tahun = 2021) AS Total"
            Using command As New OleDb.OleDbCommand(queryTotal2021, connection)
                total2021 = Convert.ToInt32(command.ExecuteScalar())
            End Using



            ' Query untuk menghitung jumlah gabungan MHS, DSN, KRY di tahun 2022
            Dim queryTotal2022 As String = "SELECT " & _
                "(SELECT COUNT(*) FROM t_angket_jawab_dsn WHERE ISNUMERIC(tahun) = 1 AND tahun = 2022) + " & _
                "(SELECT COUNT(*) FROM t_angket_jawab_kry WHERE ISNUMERIC(tahun) = 1 AND tahun = 2022) + " & _
                "(SELECT COUNT(*) FROM t_angket_jawab_mhs WHERE ISNUMERIC(tahun) = 1 AND tahun = 2022) AS Total"
            Using command As New OleDb.OleDbCommand(queryTotal2022, connection)
                total2022 = Convert.ToInt32(command.ExecuteScalar())
            End Using

            
        End Using

        Dim chartDetails As New List(Of Object) From {
            New With {.id = "persentaseChart", .type = "pie", .labels = "Mahasiswa,Dosen,Karyawan", .data = totalMHS.ToString() & "," & totalDSN.ToString() & "," & totalKRY.ToString(), .isMulti = False, .showLegend = True},
            New With {.id = "batangChart", .type = "bar", .labels = "Tahun 2016,Tahun 2017,Tahun 2018,Tahun 2019,Tahun 2020,Tahun 2021,Tahun 2022", .data = "Mahasiswa:" & mhs2016.ToString() & "," & mhs2017.ToString() & "," & mhs2018.ToString() & "," & mhs2019.ToString() & "," & mhs2020.ToString() & "," & mhs2021.ToString() & "," & mhs2022.ToString() &
            ",0,0,0,0,0|Dosen:" & dsn2016.ToString() & "," & dsn2017.ToString() & "," & dsn2018.ToString() & "," & dsn2019.ToString() & "," & dsn2020.ToString() & "," & dsn2021.ToString() & "," & dsn2022.ToString() &
            ",0,0,0,0,0|Karyawan:" & kry2016.ToString() & "," & kry2017.ToString() & "," & kry2018.ToString() & "," & kry2019.ToString() & "," & kry2020.ToString() & "," & kry2021.ToString() & "," & kry2022.ToString() &
            ",0,0,0,0,0", .isMulti = True, .showLegend = True},
            New With {.id = "garisChart", .type = "line", .labels = "2016,2017,2018,2019,2020,2021,2022", .data = "Mahasiswa:" & mhs2016.ToString() & "," & mhs2017.ToString() & "," & mhs2018.ToString() & "," & mhs2019.ToString() & "," & mhs2020.ToString() & "," & mhs2021.ToString() & "," & mhs2022.ToString() &
            ",0,0,0,0,0|Dosen:" & dsn2016.ToString() & "," & dsn2017.ToString() & "," & dsn2018.ToString() & "," & dsn2019.ToString() & "," & dsn2020.ToString() & "," & dsn2021.ToString() & "," & dsn2022.ToString() &
            ",0,0,0,0,0|Karyawan:" & kry2016.ToString() & "," & kry2017.ToString() & "," & kry2018.ToString() & "," & kry2019.ToString() & "," & kry2020.ToString() & "," & kry2021.ToString() & "," & kry2022.ToString() &
            ",0,0,0,0,0", .isMulti = True, .showLegend = True},
            New With {.id = "garisChart2", .type = "line", .labels = "2016,2017,2018,2019,2020,2021,2022", .data = "Jumlah Gabungan Responden (Mahasiswa, Dosen, Karyawan):" & total2016.ToString() & "," & total2017.ToString() & "," & total2018.ToString() & "," & total2019.ToString() & "," & total2020.ToString() & "," & total2021.ToString() & "," & total2022.ToString() &
            ",0,0,0,0,0", .isMulti = True, .showLegend = True}
        }



        Dim distribusiKeseluruhan(9, 5) As Integer ' 10 pertanyaan × skor 1–6
        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()
            Dim cmd As New OleDb.OleDbCommand("SELECT pilihan FROM dbo.t_angket_jawab_mhs WHERE pilihan IS NOT NULL " & _
                              "UNION ALL " & _
                              "SELECT pilihan FROM dbo.t_angket_jawab_dsn WHERE pilihan IS NOT NULL " & _
                              "UNION ALL " & _
                              "SELECT pilihan FROM dbo.t_angket_jawab_kry WHERE pilihan IS NOT NULL", connection)
            Dim reader As OleDb.OleDbDataReader = cmd.ExecuteReader()
            While reader.Read()
            Dim pilihan As String = reader("pilihan").ToString().Trim()
            If pilihan.EndsWith("|") Then
                pilihan = pilihan.Substring(0, pilihan.Length - 1) ' Hilangkan karakter "|" di akhir jika ada
            End If
            Dim nilaiStrings() As String = pilihan.Split("|"c)
            For i As Integer = 0 To Math.Min(nilaiStrings.Length, 10) - 1
                Dim skor As Integer
                If Integer.TryParse(nilaiStrings(i), skor) Then
                If skor >= 1 AndAlso skor <= 6 Then
                    distribusiKeseluruhan(i, skor - 1) += 1
                End If
                End If
            Next
            End While
            reader.Close()
        End Using

        ' Labels pertanyaan
        Dim labelsDistribusiKeseluruhan As String = "Pertanyaan 1,Pertanyaan 2,Pertanyaan 3,Pertanyaan 4,Pertanyaan 5,Pertanyaan 6,Pertanyaan 7,Pertanyaan 8, Pertanyaan 9, Pertanyaan 10"

        ' Dataset per skor 1–6
        Dim dataPartsKeseluruhan As New List(Of String)
        For skor As Integer = 1 To 6
            Dim values As New List(Of String)
            For q As Integer = 0 To 9
            values.Add(distribusiKeseluruhan(q, skor - 1).ToString())
            Next
            dataPartsKeseluruhan.Add("Skor " & skor & ":" & String.Join(",", values))
        Next

        Dim distribusiDataKeseluruhan As String = String.Join("|", dataPartsKeseluruhan)

        ' Tambahkan chart distribusi ke chartDetails
        chartDetails.Add(New With {
            .id = "distribusiChartKeseluruhan",
            .type = "bar",
            .labels = labelsDistribusiKeseluruhan,
            .data = distribusiDataKeseluruhan,
            .isMulti = True,
            .showLegend = True
        })



        Dim distribusi(9, 5) As Integer ' 10 pertanyaan × skor 1–6
        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()
            Dim cmd As New OleDb.OleDbCommand("SELECT pilihan FROM dbo.t_angket_jawab_mhs WHERE pilihan IS NOT NULL", connection)
            Dim reader As OleDb.OleDbDataReader = cmd.ExecuteReader()
            While reader.Read()
            Dim pilihan As String = reader("pilihan").ToString().Trim()
            If pilihan.EndsWith("|") Then
                pilihan = pilihan.Substring(0, pilihan.Length - 1) ' Hilangkan karakter "|" di akhir jika ada
            End If
            Dim nilaiStrings() As String = pilihan.Split("|"c)
            For i As Integer = 0 To Math.Min(nilaiStrings.Length, 10) - 1
                Dim skor As Integer
                If Integer.TryParse(nilaiStrings(i), skor) Then
                If skor >= 1 AndAlso skor <= 6 Then
                    distribusi(i, skor - 1) += 1
                End If
                End If
            Next
            End While
            reader.Close()
        End Using

        ' Labels pertanyaan
        Dim labelsDistribusi As String = "Pertanyaan 1,Pertanyaan 2,Pertanyaan 3,Pertanyaan 4,Pertanyaan 5,Pertanyaan 6,Pertanyaan 7,Pertanyaan 8, Pertanyaan 9, Pertanyaan 10"

        ' Dataset per skor 1–6
        Dim dataParts As New List(Of String)
        For skor As Integer = 1 To 6
            Dim values As New List(Of String)
            For q As Integer = 0 To 9
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



        Dim distribusiDSN(9, 5) As Integer ' 10 pertanyaan × skor 1–6
        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()
            Dim cmd As New OleDb.OleDbCommand("SELECT pilihan FROM dbo.t_angket_jawab_dsn WHERE pilihan IS NOT NULL", connection)
            Dim reader As OleDb.OleDbDataReader = cmd.ExecuteReader()
            While reader.Read()
                Dim pilihan As String = reader("pilihan").ToString().Trim()
            If pilihan.EndsWith("|") Then
                pilihan = pilihan.Substring(0, pilihan.Length - 1) ' Hilangkan karakter "|" di akhir jika ada
            End If
            Dim nilaiStrings() As String = pilihan.Split("|"c)
            For i As Integer = 0 To Math.Min(nilaiStrings.Length, 10) - 1
                Dim skor As Integer
                If Integer.TryParse(nilaiStrings(i), skor) Then
                If skor >= 1 AndAlso skor <= 6 Then
                    distribusiDSN(i, skor - 1) += 1
                End If
                End If
            Next
            End While
            reader.Close()
        End Using

        ' Labels pertanyaan
        Dim labelsDistribusiDSN As String = "Pertanyaan 1,Pertanyaan 2,Pertanyaan 3,Pertanyaan 4,Pertanyaan 5,Pertanyaan 6,Pertanyaan 7,Pertanyaan 8, Pertanyaan 9, Pertanyaan 10"

        ' Dataset per skor 1–6
        Dim dataPartsDSN As New List(Of String)
        For skor As Integer = 1 To 6
            Dim values As New List(Of String)
            For q As Integer = 0 To 9
                values.Add(distribusiDSN(q, skor - 1).ToString())
            Next
            dataPartsDSN.Add("Skor " & skor & ":" & String.Join(",", values))
        Next

        Dim distribusiDataDSN As String = String.Join("|", dataPartsDSN)

        ' Tambahkan chart distribusi dosen ke chartDetails
        chartDetails.Add(New With {
            .id = "distribusiChart2",
            .type = "bar",
            .labels = labelsDistribusiDSN,
            .data = distribusiDataDSN,
            .isMulti = True,
            .showLegend = True
        })



        Dim distribusiKRY(9, 5) As Integer ' 10 pertanyaan × skor 1–6
        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()
            Dim cmd As New OleDb.OleDbCommand("SELECT pilihan FROM dbo.t_angket_jawab_kry WHERE pilihan IS NOT NULL", connection)
            Dim reader As OleDb.OleDbDataReader = cmd.ExecuteReader()
            While reader.Read()
                Dim pilihan As String = reader("pilihan").ToString().Trim()
            If pilihan.EndsWith("|") Then
                pilihan = pilihan.Substring(0, pilihan.Length - 1) ' Hilangkan karakter "|" di akhir jika ada
            End If
            Dim nilaiStrings() As String = pilihan.Split("|"c)
            For i As Integer = 0 To Math.Min(nilaiStrings.Length, 10) - 1
                Dim skor As Integer
                If Integer.TryParse(nilaiStrings(i), skor) Then
                If skor >= 1 AndAlso skor <= 6 Then
                    distribusiKRY(i, skor - 1) += 1
                End If
                End If
            Next
            End While
            reader.Close()
        End Using

        ' Labels pertanyaan
        Dim labelsDistribusiKRY As String = "Pertanyaan 1,Pertanyaan 2,Pertanyaan 3,Pertanyaan 4,Pertanyaan 5,Pertanyaan 6,Pertanyaan 7,Pertanyaan 8, Pertanyaan 9, Pertanyaan 10"

        ' Dataset per skor 1–6
        Dim dataPartsKRY As New List(Of String)
        For skor As Integer = 1 To 6
            Dim values As New List(Of String)
            For q As Integer = 0 To 9
                values.Add(distribusiKRY(q, skor - 1).ToString())
            Next
            dataPartsKRY.Add("Skor " & skor & ":" & String.Join(",", values))
        Next

        Dim distribusiDataKRY As String = String.Join("|", dataPartsKRY)

        ' Tambahkan chart distribusi dosen ke chartDetails
        chartDetails.Add(New With {
            .id = "distribusiChart3",
            .type = "bar",
            .labels = labelsDistribusiKRY,
            .data = distribusiDataKRY,
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
    <h1>DASHBOARD KEPUASAN</h1>
    <ol class="breadcrumb">
        <li><a href="/dashboard_kuesioner/index.aspx"><i class="fa fa-dashboard"></i> Dashboard</a></li>
        <li class="active">Dashboard Kepuasan</li>
    </ol>

    <!-- Tombol View All sebagai LinkButton server-side -->
    <div class="box-footer text-center" style="margin-top: 15px;">
        <asp:LinkButton ID="btnViewAll" runat="server" CssClass="btn btn-default" OnClick="btnViewAll_Click">
            Data Lengkap Tahunan Kepuasan
        </asp:LinkButton>
    </div>
</section>





<!-- Modal View All -->
<div class="modal fade" id="modal-view-all" tabindex="-1" role="dialog" aria-labelledby="modalLabel" aria-hidden="true">
    <div class="modal-dialog" style="width:850px;">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="modalLabel">Data Lengkap Tahunan Kepuasan</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>

            <div class="modal-body">
                <!-- Dropdown Tahun -->
                <asp:DropDownList ID="ddlTahun" runat="server" AutoPostBack="True" 
                    OnSelectedIndexChanged="ddlTahun_SelectedIndexChanged" 
                    CssClass="form-control" style="width: 200px; margin-bottom: 10px;">
                </asp:DropDownList>

                <!-- Dropdown Status -->
                <asp:DropDownList ID="ddlStatus" runat="server" AutoPostBack="True" 
                    OnSelectedIndexChanged="ddlStatus_SelectedIndexChanged" 
                    CssClass="form-control" style="width: 250px; margin-bottom: 10px;">
                </asp:DropDownList>

                <!-- Label total responden -->
                <asp:Label ID="lblTotalResponden" runat="server" Font-Bold="True" />
                <br />

                <asp:GridView ID="GridViewTabelTahunan" runat="server" CssClass="table table-bordered table-striped" AutoGenerateColumns="False">
                    <Columns>
                        <asp:BoundField DataField="tahun" HeaderText="Tahun" />
                        <asp:BoundField DataField="nik" HeaderText="ID User" />
                        <asp:BoundField DataField="jns" HeaderText="Status" />
                        <asp:BoundField DataField="pilihan" HeaderText="Isi Jawaban" />
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
        LoadStatusDropdown()

        If ddlTahun.Items.Count > 0 Then
            ddlTahun.SelectedIndex = 0
        End If

        If ddlStatus.Items.Count > 0 Then
            ddlStatus.SelectedIndex = 0
        End If

        LoadGridViewData(ddlTahun.SelectedValue, ddlStatus.SelectedValue)
        LoadDashboardData()
        LoadChartData()
        GenerateChartConfiguration()
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowModal", "$('#modal-view-all').modal('show');", True)
    End Sub

    Protected Sub ddlTahun_SelectedIndexChanged(sender As Object, e As EventArgs)
        LoadGridViewData(ddlTahun.SelectedValue, ddlStatus.SelectedValue)
        LoadDashboardData()
        LoadChartData()
        GenerateChartConfiguration()
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowModal", "$('#modal-view-all').modal('show');", True)
    End Sub

    Protected Sub ddlStatus_SelectedIndexChanged(sender As Object, e As EventArgs)
        LoadGridViewData(ddlTahun.SelectedValue, ddlStatus.SelectedValue)
        LoadDashboardData()
        LoadChartData()
        GenerateChartConfiguration()
        ScriptManager.RegisterStartupScript(Me, Me.GetType(), "ShowModal", "$('#modal-view-all').modal('show');", True)
    End Sub


    ' === Dropdown Tahun ===
    Private Sub LoadTahunDropdown()
        Dim query As String = _
            "SELECT DISTINCT tahun FROM dbo.t_angket_jawab_mhs " & _
            "UNION " & _
            "SELECT DISTINCT tahun FROM dbo.t_angket_jawab_dsn " & _
            "UNION " & _
            "SELECT DISTINCT tahun FROM dbo.t_angket_jawab_kry " & _
            "ORDER BY tahun"

        Using connection As New OleDb.OleDbConnection(connectionString)
            Using command As New OleDb.OleDbCommand(query, connection)
                connection.Open()
                Dim reader = command.ExecuteReader()

                ddlTahun.Items.Clear()
                While reader.Read()
                    Dim yearValue As String = reader("tahun").ToString()
                    ddlTahun.Items.Add(New ListItem(yearValue, yearValue))
                End While
            End Using
        End Using
    End Sub


    ' === Dropdown Status ===
    Private Sub LoadStatusDropdown()
        ddlStatus.Items.Clear()
        ddlStatus.Items.Add(New ListItem("Semua Status", ""))
        ddlStatus.Items.Add(New ListItem("Mahasiswa", "mhs"))
        ddlStatus.Items.Add(New ListItem("Dosen", "dsn"))
        ddlStatus.Items.Add(New ListItem("Karyawan", "kry"))
    End Sub


    ' === Load Data Berdasarkan Tahun dan Status ===
    Private Sub LoadGridViewData(tahun As String, status As String)
        Dim query As String = ""

        Select Case status
            Case "mhs"
                query = "SELECT tahun, nim AS nik, jns, pilihan FROM dbo.t_angket_jawab_mhs WHERE tahun = ?"

            Case "dsn"
                query = "SELECT tahun, nik, jns, pilihan FROM dbo.t_angket_jawab_dsn WHERE tahun = ?"

            Case "kry"
                query = "SELECT tahun, nik, jns, pilihan FROM dbo.t_angket_jawab_kry WHERE tahun = ?"

            Case Else
                query = _
                    "SELECT tahun, nim AS nik, jns, pilihan FROM dbo.t_angket_jawab_mhs WHERE tahun = ? " & _
                    "UNION ALL " & _
                    "SELECT tahun, nik, jns, pilihan FROM dbo.t_angket_jawab_dsn WHERE tahun = ? " & _
                    "UNION ALL " & _
                    "SELECT tahun, nik, jns, pilihan FROM dbo.t_angket_jawab_kry WHERE tahun = ?"
        End Select

        Using connection As New System.Data.OleDb.OleDbConnection(connectionString)
            Using command As New System.Data.OleDb.OleDbCommand(query, connection)
                command.Parameters.AddWithValue("@tahun", tahun)
                If String.IsNullOrEmpty(status) Then
                    command.Parameters.AddWithValue("@tahun2", tahun)
                    command.Parameters.AddWithValue("@tahun3", tahun)
                End If

                Dim adapter As New System.Data.OleDb.OleDbDataAdapter(command)
                Dim dt As New System.Data.DataTable()
                adapter.Fill(dt)

                ' Tambah kolom Rerata dan Total
                If Not dt.Columns.Contains("Rerata") Then dt.Columns.Add("Rerata", GetType(Double))
                If Not dt.Columns.Contains("Total") Then dt.Columns.Add("Total", GetType(Double))

                ' Hitung per baris
                For Each row As DataRow In dt.Rows
                    Dim isiString As String = Convert.ToString(row("pilihan"))
                    Dim rerata As Double = HitungRerataAngka(isiString)
                    Dim total As Double = HitungTotalAngka(isiString)
                    row("Rerata") = rerata
                    row("Total") = total
                Next

                lblTotalResponden.Text = "Total Responden: " & dt.Rows.Count

                GridViewTabelTahunan.DataSource = dt
                GridViewTabelTahunan.DataBind()
            End Using
        End Using
    End Sub


    ' === Fungsi Hitung Rerata dan Total Berdasarkan Angka Dipisahkan "|" ===
Private Function HitungRerataAngka(text As String) As Double
    If String.IsNullOrEmpty(text) Then Return 0

    Dim angkaList As New List(Of Double)
    Dim parts As String() = text.Split("|"c)

    For Each p In parts
        Dim trimmed = p.Trim()
        If trimmed <> "" Then
            Dim val As Double
            If Double.TryParse(trimmed, val) Then
                angkaList.Add(val)
            End If
        End If
    Next

    If angkaList.Count = 0 Then Return 0
    Return Math.Round(angkaList.Average(), 2)
End Function

Private Function HitungTotalAngka(text As String) As Double
    If String.IsNullOrEmpty(text) Then Return 0

    Dim total As Double = 0
    Dim parts As String() = text.Split("|"c)

    For Each p In parts
        Dim trimmed = p.Trim()
        If trimmed <> "" Then
            Dim val As Double
            If Double.TryParse(trimmed, val) Then
                total += val
            End If
        End If
    Next

    Return Math.Round(total, 2)
End Function
</script>




















<section class="content">
    <div class="row">
        <asp:Repeater ID="rptDashboard" runat="server">
            <ItemTemplate>
                <div class="col-lg-3 col-xs-6">
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

    // ==== Navigasi per 5 pertanyaan ====
    const questionsPerPage = 5;
    const chartIds = [
        "distribusiChartKeseluruhan",
        "distribusiChart",
        "distribusiChart2",
        "distribusiChart3"
    ];

    chartIds.forEach(chartId => {
        const chart = Chart.getChart(chartId);
        if (!chart) return;

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
            <span id="page-${chartId}" class="page-info">Pertanyaan 1-5</span>
            <button id="next-${chartId}" class="btn-nav"><i class="fa-solid fa-circle-chevron-right"></i></button>
        `;
        canvasContainer.parentNode.insertBefore(navContainer, canvasContainer.nextSibling); // pastikan di luar canvas

        // ====== Tambahkan CSS tombol (sekali saja) ======
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
                    min-width: 140px;
                    text-align: center;
                    font-size: 15px;
                }
            `;
            document.head.appendChild(style);
        }

        // ====== Event klik tombol ======
        const prevBtn = document.getElementById(`prev-${chartId}`);
        const nextBtn = document.getElementById(`next-${chartId}`);

        nextBtn.addEventListener("click", () => {
            if (currentPage < totalPages - 1) {
                currentPage++;
                updateChart("right");
                const startQ = currentPage * questionsPerPage + 1;
                const endQ = Math.min((currentPage + 1) * questionsPerPage, totalQuestions);
                document.getElementById(`page-${chartId}`).textContent = `Pertanyaan ${startQ}-${endQ}`;
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
                document.getElementById(`page-${chartId}`).textContent = `Pertanyaan ${startQ}-${endQ}`;
            }
            prevBtn.disabled = currentPage === 0;
            nextBtn.disabled = currentPage >= totalPages - 1;
        });

        // Tampilkan pertama kali
        updateChart();
        prevBtn.disabled = true;
    });
});
</script>



<!-- Menampilkan Icon Font Awesome Pro/Premium -->
<link rel="stylesheet" href="https://site-assets.fontawesome.com/releases/v6.4.2/css/all.css">
