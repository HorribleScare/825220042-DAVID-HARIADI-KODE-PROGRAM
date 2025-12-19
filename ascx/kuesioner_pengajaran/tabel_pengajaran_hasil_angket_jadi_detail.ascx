<!-- #INCLUDE file = "/con_ascx2022/conlintar2022.ascx" -->

<script runat="server">
    Public chartConfigJson As String = ""
    Dim connectionString As String = "Provider=sqloledb;Data Source=10.200.120.83,1433;Network Library=DBMSSOCN;Initial Catalog=lintar2022;User ID=sa;Password=dbTesting2023;connect timeout=200;pooling=false;max pool size=200"

    Sub Page_Load(sender As Object, e As EventArgs)
        If Not Page.IsPostBack Then
            GenerateChartConfiguration()
        End If
    End Sub

    Sub GenerateChartConfiguration()
        ' Distribusi Skor Jawaban Pertanyaan 1
        Dim distribusiPertanyaan1(4, 3) As Integer ' 5 tahun (2012-2016) × 4 skor (A-D)
        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()
            ' Ambil kolom isi dan tahun
            Using cmd As New OleDb.OleDbCommand("SELECT isi, tha FROM dbo.tq_hslangket WHERE isi IS NOT NULL", connection)
                Using reader As OleDb.OleDbDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        Dim isi As String = reader("isi").ToString().Trim()
                        Dim tahun As Integer = 0
                        If Integer.TryParse(reader("tha").ToString(), tahun) Then
                            ' Pastikan tahun 2012-2016
                            If tahun >= 2012 AndAlso tahun <= 2016 Then
                                Dim tahunIndex As Integer = tahun - 2012
                                ' Ambil skor pertanyaan 1
                                If isi.Length >= 1 Then
                                    Dim skor As String = isi(0).ToString().ToUpper()
                                    Select Case skor
                                        Case "A"
                                            distribusiPertanyaan1(tahunIndex, 0) += 1
                                        Case "B"
                                            distribusiPertanyaan1(tahunIndex, 1) += 1
                                        Case "C"
                                            distribusiPertanyaan1(tahunIndex, 2) += 1
                                        Case "D"
                                            distribusiPertanyaan1(tahunIndex, 3) += 1
                                    End Select
                                End If
                            End If
                        End If
                    End While
                End Using
            End Using
        End Using

        ' Distribusi Skor Jawaban Pertanyaan 2
        Dim distribusiPertanyaan2(4, 3) As Integer ' 5 tahun (2012-2016) × 4 skor (A-D)
        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()
            ' Ambil kolom isi dan tahun
            Using cmd As New OleDb.OleDbCommand("SELECT isi, tha FROM dbo.tq_hslangket WHERE isi IS NOT NULL", connection)
                Using reader As OleDb.OleDbDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        Dim isi As String = reader("isi").ToString().Trim()
                        Dim tahun As Integer = 0
                        If Integer.TryParse(reader("tha").ToString(), tahun) Then
                            ' Pastikan tahun 2012-2016
                            If tahun >= 2012 AndAlso tahun <= 2016 Then
                                Dim tahunIndex As Integer = tahun - 2012
                                ' Ambil skor pertanyaan 2
                                If isi.Length >= 2 Then
                                    Dim skor As String = isi(1).ToString().ToUpper()
                                    Select Case skor
                                        Case "A"
                                            distribusiPertanyaan2(tahunIndex, 0) += 1
                                        Case "B"
                                            distribusiPertanyaan2(tahunIndex, 1) += 1
                                        Case "C"
                                            distribusiPertanyaan2(tahunIndex, 2) += 1
                                        Case "D"
                                            distribusiPertanyaan2(tahunIndex, 3) += 1
                                    End Select
                                End If
                            End If
                        End If
                    End While
                End Using
            End Using
        End Using

        ' Distribusi Skor Jawaban Pertanyaan 3
        Dim distribusiPertanyaan3(4, 3) As Integer ' 5 tahun (2012-2016) × 4 skor (A-D)
        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()
            ' Ambil kolom isi dan tahun
            Using cmd As New OleDb.OleDbCommand("SELECT isi, tha FROM dbo.tq_hslangket WHERE isi IS NOT NULL", connection)
                Using reader As OleDb.OleDbDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        Dim isi As String = reader("isi").ToString().Trim()
                        Dim tahun As Integer = 0
                        If Integer.TryParse(reader("tha").ToString(), tahun) Then
                            ' Pastikan tahun 2012-2016
                            If tahun >= 2012 AndAlso tahun <= 2016 Then
                                Dim tahunIndex As Integer = tahun - 2012
                                ' Ambil skor pertanyaan 3
                                If isi.Length >= 3 Then
                                    Dim skor As String = isi(2).ToString().ToUpper()
                                    Select Case skor
                                        Case "A"
                                            distribusiPertanyaan3(tahunIndex, 0) += 1
                                        Case "B"
                                            distribusiPertanyaan3(tahunIndex, 1) += 1
                                        Case "C"
                                            distribusiPertanyaan3(tahunIndex, 2) += 1
                                        Case "D"
                                            distribusiPertanyaan3(tahunIndex, 3) += 1
                                    End Select
                                End If
                            End If
                        End If
                    End While
                End Using
            End Using
        End Using

        ' Distribusi Skor Jawaban Pertanyaan 4
        Dim distribusiPertanyaan4(4, 3) As Integer ' 5 tahun (2012-2016) × 4 skor (A-D)
        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()
            ' Ambil kolom isi dan tahun
            Using cmd As New OleDb.OleDbCommand("SELECT isi, tha FROM dbo.tq_hslangket WHERE isi IS NOT NULL", connection)
                Using reader As OleDb.OleDbDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        Dim isi As String = reader("isi").ToString().Trim()
                        Dim tahun As Integer = 0
                        If Integer.TryParse(reader("tha").ToString(), tahun) Then
                            ' Pastikan tahun 2012-2016
                            If tahun >= 2012 AndAlso tahun <= 2016 Then
                                Dim tahunIndex As Integer = tahun - 2012
                                ' Ambil skor pertanyaan 4
                                If isi.Length >= 4 Then
                                    Dim skor As String = isi(3).ToString().ToUpper()
                                    Select Case skor
                                        Case "A"
                                            distribusiPertanyaan4(tahunIndex, 0) += 1
                                        Case "B"
                                            distribusiPertanyaan4(tahunIndex, 1) += 1
                                        Case "C"
                                            distribusiPertanyaan4(tahunIndex, 2) += 1
                                        Case "D"
                                            distribusiPertanyaan4(tahunIndex, 3) += 1
                                    End Select
                                End If
                            End If
                        End If
                    End While
                End Using
            End Using
        End Using


        ' Distribusi Skor Jawaban Pertanyaan 5
        Dim distribusiPertanyaan5(4, 3) As Integer ' 5 tahun (2012-2016) × 4 skor (A-D)
        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()
            ' Ambil kolom isi dan tahun
            Using cmd As New OleDb.OleDbCommand("SELECT isi, tha FROM dbo.tq_hslangket WHERE isi IS NOT NULL", connection)
                Using reader As OleDb.OleDbDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        Dim isi As String = reader("isi").ToString().Trim()
                        Dim tahun As Integer = 0
                        If Integer.TryParse(reader("tha").ToString(), tahun) Then
                            ' Pastikan tahun 2012-2016
                            If tahun >= 2012 AndAlso tahun <= 2016 Then
                                Dim tahunIndex As Integer = tahun - 2012
                                ' Ambil skor pertanyaan 5
                                If isi.Length >= 5 Then
                                    Dim skor As String = isi(4).ToString().ToUpper()
                                    Select Case skor
                                        Case "A"
                                            distribusiPertanyaan5(tahunIndex, 0) += 1
                                        Case "B"
                                            distribusiPertanyaan5(tahunIndex, 1) += 1
                                        Case "C"
                                            distribusiPertanyaan5(tahunIndex, 2) += 1
                                        Case "D"
                                            distribusiPertanyaan5(tahunIndex, 3) += 1
                                    End Select
                                End If
                            End If
                        End If
                    End While
                End Using
            End Using
        End Using


        ' Distribusi Skor Jawaban Pertanyaan 6
        Dim distribusiPertanyaan6(4, 3) As Integer ' 5 tahun (2012-2016) × 4 skor (A-D)
        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()
            ' Ambil kolom isi dan tahun
            Using cmd As New OleDb.OleDbCommand("SELECT isi, tha FROM dbo.tq_hslangket WHERE isi IS NOT NULL", connection)
                Using reader As OleDb.OleDbDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        Dim isi As String = reader("isi").ToString().Trim()
                        Dim tahun As Integer = 0
                        If Integer.TryParse(reader("tha").ToString(), tahun) Then
                            ' Pastikan tahun 2012-2016
                            If tahun >= 2012 AndAlso tahun <= 2016 Then
                                Dim tahunIndex As Integer = tahun - 2012
                                ' Ambil skor pertanyaan 6
                                If isi.Length >= 6 Then
                                    Dim skor As String = isi(5).ToString().ToUpper()
                                    Select Case skor
                                        Case "A"
                                            distribusiPertanyaan6(tahunIndex, 0) += 1
                                        Case "B"
                                            distribusiPertanyaan6(tahunIndex, 1) += 1
                                        Case "C"
                                            distribusiPertanyaan6(tahunIndex, 2) += 1
                                        Case "D"
                                            distribusiPertanyaan6(tahunIndex, 3) += 1
                                    End Select
                                End If
                            End If
                        End If
                    End While
                End Using
            End Using
        End Using


        ' Distribusi Skor Jawaban Pertanyaan 7
        Dim distribusiPertanyaan7(4, 3) As Integer ' 5 tahun (2012-2016) × 4 skor (A-D)
        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()
            ' Ambil kolom isi dan tahun
            Using cmd As New OleDb.OleDbCommand("SELECT isi, tha FROM dbo.tq_hslangket WHERE isi IS NOT NULL", connection)
                Using reader As OleDb.OleDbDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        Dim isi As String = reader("isi").ToString().Trim()
                        Dim tahun As Integer = 0
                        If Integer.TryParse(reader("tha").ToString(), tahun) Then
                            ' Pastikan tahun 2012-2016
                            If tahun >= 2012 AndAlso tahun <= 2016 Then
                                Dim tahunIndex As Integer = tahun - 2012
                                ' Ambil skor pertanyaan 7
                                If isi.Length >= 7 Then
                                    Dim skor As String = isi(6).ToString().ToUpper()
                                    Select Case skor
                                        Case "A"
                                            distribusiPertanyaan7(tahunIndex, 0) += 1
                                        Case "B"
                                            distribusiPertanyaan7(tahunIndex, 1) += 1
                                        Case "C"
                                            distribusiPertanyaan7(tahunIndex, 2) += 1
                                        Case "D"
                                            distribusiPertanyaan7(tahunIndex, 3) += 1
                                    End Select
                                End If
                            End If
                        End If
                    End While
                End Using
            End Using
        End Using


        ' Distribusi Skor Jawaban Pertanyaan 8
        Dim distribusiPertanyaan8(4, 3) As Integer ' 5 tahun (2012-2016) × 4 skor (A-D)
        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()
            ' Ambil kolom isi dan tahun
            Using cmd As New OleDb.OleDbCommand("SELECT isi, tha FROM dbo.tq_hslangket WHERE isi IS NOT NULL", connection)
                Using reader As OleDb.OleDbDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        Dim isi As String = reader("isi").ToString().Trim()
                        Dim tahun As Integer = 0
                        If Integer.TryParse(reader("tha").ToString(), tahun) Then
                            ' Pastikan tahun 2012-2016
                            If tahun >= 2012 AndAlso tahun <= 2016 Then
                                Dim tahunIndex As Integer = tahun - 2012
                                ' Ambil skor pertanyaan 8
                                If isi.Length >= 8 Then
                                    Dim skor As String = isi(7).ToString().ToUpper()
                                    Select Case skor
                                        Case "A"
                                            distribusiPertanyaan8(tahunIndex, 0) += 1
                                        Case "B"
                                            distribusiPertanyaan8(tahunIndex, 1) += 1
                                        Case "C"
                                            distribusiPertanyaan8(tahunIndex, 2) += 1
                                        Case "D"
                                            distribusiPertanyaan8(tahunIndex, 3) += 1
                                    End Select
                                End If
                            End If
                        End If
                    End While
                End Using
            End Using
        End Using


        ' Distribusi Skor Jawaban Pertanyaan 9
        Dim distribusiPertanyaan9(4, 3) As Integer ' 5 tahun (2012-2016) × 4 skor (A-D)
        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()
            ' Ambil kolom isi dan tahun
            Using cmd As New OleDb.OleDbCommand("SELECT isi, tha FROM dbo.tq_hslangket WHERE isi IS NOT NULL", connection)
                Using reader As OleDb.OleDbDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        Dim isi As String = reader("isi").ToString().Trim()
                        Dim tahun As Integer = 0
                        If Integer.TryParse(reader("tha").ToString(), tahun) Then
                            ' Pastikan tahun 2012-2016
                            If tahun >= 2012 AndAlso tahun <= 2016 Then
                                Dim tahunIndex As Integer = tahun - 2012
                                ' Ambil skor pertanyaan 9
                                If isi.Length >= 9 Then
                                    Dim skor As String = isi(8).ToString().ToUpper()
                                    Select Case skor
                                        Case "A"
                                            distribusiPertanyaan9(tahunIndex, 0) += 1
                                        Case "B"
                                            distribusiPertanyaan9(tahunIndex, 1) += 1
                                        Case "C"
                                            distribusiPertanyaan9(tahunIndex, 2) += 1
                                        Case "D"
                                            distribusiPertanyaan9(tahunIndex, 3) += 1
                                    End Select
                                End If
                            End If
                        End If
                    End While
                End Using
            End Using
        End Using


        ' Distribusi Skor Jawaban Pertanyaan 10
        Dim distribusiPertanyaan10(4, 3) As Integer ' 5 tahun (2012-2016) × 4 skor (A-D)
        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()
            ' Ambil kolom isi dan tahun
            Using cmd As New OleDb.OleDbCommand("SELECT isi, tha FROM dbo.tq_hslangket WHERE isi IS NOT NULL", connection)
                Using reader As OleDb.OleDbDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        Dim isi As String = reader("isi").ToString().Trim()
                        Dim tahun As Integer = 0
                        If Integer.TryParse(reader("tha").ToString(), tahun) Then
                            ' Pastikan tahun 2012-2016
                            If tahun >= 2012 AndAlso tahun <= 2016 Then
                                Dim tahunIndex As Integer = tahun - 2012
                                ' Ambil skor pertanyaan 10
                                If isi.Length >= 10 Then
                                    Dim skor As String = isi(9).ToString().ToUpper()
                                    Select Case skor
                                        Case "A"
                                            distribusiPertanyaan10(tahunIndex, 0) += 1
                                        Case "B"
                                            distribusiPertanyaan10(tahunIndex, 1) += 1
                                        Case "C"
                                            distribusiPertanyaan10(tahunIndex, 2) += 1
                                        Case "D"
                                            distribusiPertanyaan10(tahunIndex, 3) += 1
                                    End Select
                                End If
                            End If
                        End If
                    End While
                End Using
            End Using
        End Using

        ' Labels pertanyaan
        Dim labelsDistribusi As String = "Tahun 2012,Tahun 2013,Tahun 2014,Tahun 2015,Tahun 2016"
        ' Build data strings: each "Skor X:val1,val2,val3,val4,val5"

        ' Labels skor
        Dim skorLabels As String() = {"A", "B", "C", "D"}

        Dim dataPartsPertanyaan1 As New List(Of String)
        For skorIndex As Integer = 0 To 3 ' 4 skor: A-D
            Dim values As New List(Of String)
            For tahunIndex As Integer = 0 To 4 ' 5 tahun: 2012-2016
                values.Add(distribusiPertanyaan1(tahunIndex, skorIndex).ToString())
            Next
            dataPartsPertanyaan1.Add("Skor " & skorLabels(skorIndex) & ":" & String.Join(",", values))
        Next
        Dim distribusiDataPertanyaan1 As String = String.Join("|", dataPartsPertanyaan1)

        Dim dataPartsPertanyaan2 As New List(Of String)
        For skorIndex As Integer = 0 To 3 ' 4 skor: A-D
            Dim values As New List(Of String)
            For tahunIndex As Integer = 0 To 4 ' 5 tahun: 2012-2016
                values.Add(distribusiPertanyaan2(tahunIndex, skorIndex).ToString())
            Next
            dataPartsPertanyaan2.Add("Skor " & skorLabels(skorIndex) & ":" & String.Join(",", values))
        Next
        Dim distribusiDataPertanyaan2 As String = String.Join("|", dataPartsPertanyaan2)

        Dim dataPartsPertanyaan3 As New List(Of String)
        For skorIndex As Integer = 0 To 3 ' 4 skor: A-D
            Dim values As New List(Of String)
            For tahunIndex As Integer = 0 To 4 ' 5 tahun: 2012-2016
                values.Add(distribusiPertanyaan3(tahunIndex, skorIndex).ToString())
            Next
            dataPartsPertanyaan3.Add("Skor " & skorLabels(skorIndex) & ":" & String.Join(",", values))
        Next
        Dim distribusiDataPertanyaan3 As String = String.Join("|", dataPartsPertanyaan3)

        Dim dataPartsPertanyaan4 As New List(Of String)
        For skorIndex As Integer = 0 To 3 ' 4 skor: A-D
            Dim values As New List(Of String)
            For tahunIndex As Integer = 0 To 4 ' 5 tahun: 2012-2016
                values.Add(distribusiPertanyaan4(tahunIndex, skorIndex).ToString())
            Next
            dataPartsPertanyaan4.Add("Skor " & skorLabels(skorIndex) & ":" & String.Join(",", values))
        Next
        Dim distribusiDataPertanyaan4 As String = String.Join("|", dataPartsPertanyaan4)

        Dim dataPartsPertanyaan5 As New List(Of String)
        For skorIndex As Integer = 0 To 3 ' 4 skor: A-D
            Dim values As New List(Of String)
            For tahunIndex As Integer = 0 To 4 ' 5 tahun: 2012-2016
                values.Add(distribusiPertanyaan5(tahunIndex, skorIndex).ToString())
            Next
            dataPartsPertanyaan5.Add("Skor " & skorLabels(skorIndex) & ":" & String.Join(",", values))
        Next
        Dim distribusiDataPertanyaan5 As String = String.Join("|", dataPartsPertanyaan5)

        Dim dataPartsPertanyaan6 As New List(Of String)
        For skorIndex As Integer = 0 To 3 ' 4 skor: A-D
            Dim values As New List(Of String)
            For tahunIndex As Integer = 0 To 4 ' 5 tahun: 2012-2016
                values.Add(distribusiPertanyaan6(tahunIndex, skorIndex).ToString())
            Next
            dataPartsPertanyaan6.Add("Skor " & skorLabels(skorIndex) & ":" & String.Join(",", values))
        Next
        Dim distribusiDataPertanyaan6 As String = String.Join("|", dataPartsPertanyaan6)

        Dim dataPartsPertanyaan7 As New List(Of String)
        For skorIndex As Integer = 0 To 3 ' 4 skor: A-D
            Dim values As New List(Of String)
            For tahunIndex As Integer = 0 To 4 ' 5 tahun: 2012-2016
                values.Add(distribusiPertanyaan7(tahunIndex, skorIndex).ToString())
            Next
            dataPartsPertanyaan7.Add("Skor " & skorLabels(skorIndex) & ":" & String.Join(",", values))
        Next
        Dim distribusiDataPertanyaan7 As String = String.Join("|", dataPartsPertanyaan7)

        Dim dataPartsPertanyaan8 As New List(Of String)
        For skorIndex As Integer = 0 To 3 ' 4 skor: A-D
            Dim values As New List(Of String)
            For tahunIndex As Integer = 0 To 4 ' 5 tahun: 2012-2016
                values.Add(distribusiPertanyaan8(tahunIndex, skorIndex).ToString())
            Next
            dataPartsPertanyaan8.Add("Skor " & skorLabels(skorIndex) & ":" & String.Join(",", values))
        Next
        Dim distribusiDataPertanyaan8 As String = String.Join("|", dataPartsPertanyaan8)

        Dim dataPartsPertanyaan9 As New List(Of String)
        For skorIndex As Integer = 0 To 3 ' 4 skor: A-D
            Dim values As New List(Of String)
            For tahunIndex As Integer = 0 To 4 ' 5 tahun: 2012-2016
                values.Add(distribusiPertanyaan9(tahunIndex, skorIndex).ToString())
            Next
            dataPartsPertanyaan9.Add("Skor " & skorLabels(skorIndex) & ":" & String.Join(",", values))
        Next
        Dim distribusiDataPertanyaan9 As String = String.Join("|", dataPartsPertanyaan9)

        Dim dataPartsPertanyaan10 As New List(Of String)
        For skorIndex As Integer = 0 To 3 ' 4 skor: A-D
            Dim values As New List(Of String)
            For tahunIndex As Integer = 0 To 4 ' 5 tahun: 2012-2016
                values.Add(distribusiPertanyaan10(tahunIndex, skorIndex).ToString())
            Next
            dataPartsPertanyaan10.Add("Skor " & skorLabels(skorIndex) & ":" & String.Join(",", values))
        Next
        Dim distribusiDataPertanyaan10 As String = String.Join("|", dataPartsPertanyaan10)

        ' Chart details for the four required charts
        Dim chartDetails As New List(Of Object) From {
            New With {.id = "distribusiChartPertanyaan1", .type = "bar", .labels = labelsDistribusi, .data = distribusiDataPertanyaan1, .isMulti = True, .showLegend = True, .title = "Distribusi Skor Jawaban Pertanyaan 1"},
            New With {.id = "distribusiChartPertanyaan2", .type = "bar", .labels = labelsDistribusi, .data = distribusiDataPertanyaan2, .isMulti = True, .showLegend = True, .title = "Distribusi Skor Jawaban Pertanyaan 2"},
            New With {.id = "distribusiChartPertanyaan3", .type = "bar", .labels = labelsDistribusi, .data = distribusiDataPertanyaan3, .isMulti = True, .showLegend = True, .title = "Distribusi Skor Jawaban Pertanyaan 3"},
            New With {.id = "distribusiChartPertanyaan4", .type = "bar", .labels = labelsDistribusi, .data = distribusiDataPertanyaan4, .isMulti = True, .showLegend = True, .title = "Distribusi Skor Jawaban Pertanyaan 4"},
            New With {.id = "distribusiChartPertanyaan5", .type = "bar", .labels = labelsDistribusi, .data = distribusiDataPertanyaan5, .isMulti = True, .showLegend = True, .title = "Distribusi Skor Jawaban Pertanyaan 5"},
            New With {.id = "distribusiChartPertanyaan6", .type = "bar", .labels = labelsDistribusi, .data = distribusiDataPertanyaan6, .isMulti = True, .showLegend = True, .title = "Distribusi Skor Jawaban Pertanyaan 6"},
            New With {.id = "distribusiChartPertanyaan7", .type = "bar", .labels = labelsDistribusi, .data = distribusiDataPertanyaan7, .isMulti = True, .showLegend = True, .title = "Distribusi Skor Jawaban Pertanyaan 7"},
            New With {.id = "distribusiChartPertanyaan8", .type = "bar", .labels = labelsDistribusi, .data = distribusiDataPertanyaan8, .isMulti = True, .showLegend = True, .title = "Distribusi Skor Jawaban Pertanyaan 8"},
            New With {.id = "distribusiChartPertanyaan9", .type = "bar", .labels = labelsDistribusi, .data = distribusiDataPertanyaan9, .isMulti = True, .showLegend = True, .title = "Distribusi Skor Jawaban Pertanyaan 9"},
            New With {.id = "distribusiChartPertanyaan10", .type = "bar", .labels = labelsDistribusi, .data = distribusiDataPertanyaan10, .isMulti = True, .showLegend = True, .title = "Distribusi Skor Jawaban Pertanyaan 10"}
        }

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
        config.Append(",""plugins"": {""legend"": {""display"": " & chart.showLegend.ToString().ToLower() & "}}")
        config.Append(",""scales"": {""y"": {""beginAtZero"": true}}")
        config.Append("}}")

        Return config.ToString()
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

    Function GenerateColors(count As Integer) As String
        Dim colors As New List(Of String)()
        For i As Integer = 0 To count - 1
            Dim color As String = GetColorFromPalette(i)
            colors.Add("""" & color & """")
        Next
        Return "[" & String.Join(",", colors.ToArray()) & "]"
    End Function

    Function GetColorFromPalette(index As Integer) As String
        Dim hue As Double = (index * 137.508) Mod 360
        Dim saturation As Double = 0.7
        Dim lightness As Double = 0.5

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

        Dim red As Integer = Math.Round((r + m) * 255)
        Dim green As Integer = Math.Round((g + m) * 255)
        Dim blue As Integer = Math.Round((b + m) * 255)

        Return String.Format("#{0:X2}{1:X2}{2:X2}", red, green, blue)
    End Function
</script>

<section class="content-header">
    <h1>DASHBOARD SKOR JAWABAN PERTANYAAN PENGAJARAN TAHUNAN</h1>
</section>

<section class="content">
    <div class="row">
        <div class="col-md-12">
            <div class="box box-primary">
                <div class="box-header with-border">
                    <h3 class="box-title">Distribusi Skor Jawaban Pertanyaan 1</h3>
                </div>
                <div class="box-body" style="height:320px;">
                    <canvas id="distribusiChartPertanyaan1"></canvas>
                </div>
            </div>
        </div>

        <div class="col-md-12">
            <div class="box box-primary">
                <div class="box-header with-border">
                    <h3 class="box-title">Distribusi Skor Jawaban Pertanyaan 2</h3>
                </div>
                <div class="box-body" style="height:320px;">
                    <canvas id="distribusiChartPertanyaan2"></canvas>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-12">
            <div class="box box-primary">
                <div class="box-header with-border">
                    <h3 class="box-title">Distribusi Skor Jawaban Pertanyaan 3</h3>
                </div>
                <div class="box-body" style="height:320px;">
                    <canvas id="distribusiChartPertanyaan3"></canvas>
                </div>
            </div>
        </div>

        <div class="col-md-12">
            <div class="box box-primary">
                <div class="box-header with-border">
                    <h3 class="box-title">Distribusi Skor Jawaban Pertanyaan 4</h3>
                </div>
                <div class="box-body" style="height:320px;">
                    <canvas id="distribusiChartPertanyaan4"></canvas>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-12">
            <div class="box box-primary">
                <div class="box-header with-border">
                    <h3 class="box-title">Distribusi Skor Jawaban Pertanyaan 5</h3>
                </div>
                <div class="box-body" style="height:320px;">
                    <canvas id="distribusiChartPertanyaan5"></canvas>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-12">
            <div class="box box-primary">
                <div class="box-header with-border">
                    <h3 class="box-title">Distribusi Skor Jawaban Pertanyaan 6</h3>
                </div>
                <div class="box-body" style="height:320px;">
                    <canvas id="distribusiChartPertanyaan6"></canvas>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-12">
            <div class="box box-primary">
                <div class="box-header with-border">
                    <h3 class="box-title">Distribusi Skor Jawaban Pertanyaan 7</h3>
                </div>
                <div class="box-body" style="height:320px;">
                    <canvas id="distribusiChartPertanyaan7"></canvas>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-12">
            <div class="box box-primary">
                <div class="box-header with-border">
                    <h3 class="box-title">Distribusi Skor Jawaban Pertanyaan 8</h3>
                </div>
                <div class="box-body" style="height:320px;">
                    <canvas id="distribusiChartPertanyaan8"></canvas>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-12">
            <div class="box box-primary">
                <div class="box-header with-border">
                    <h3 class="box-title">Distribusi Skor Jawaban Pertanyaan 9</h3>
                </div>
                <div class="box-body" style="height:320px;">
                    <canvas id="distribusiChartPertanyaan9"></canvas>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-12">
            <div class="box box-primary">
                <div class="box-header with-border">
                    <h3 class="box-title">Distribusi Skor Jawaban Pertanyaan 10</h3>
                </div>
                <div class="box-body" style="height:320px;">
                    <canvas id="distribusiChartPertanyaan10"></canvas>
                </div>
            </div>
        </div>
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

