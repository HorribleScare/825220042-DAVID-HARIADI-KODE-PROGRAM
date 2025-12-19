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
    ' Distribusi Skor Jawaban Pertanyaan 1 untuk tahun 2018
    Dim distribusiPertanyaan1(3) As Integer ' 4 skor (1-4)

    ' Nama tabel
    Dim tabel As String = "dbo.tq_pengguna_lulusan_isi"

    Using connection As New OleDb.OleDbConnection(connectionString)
        connection.Open()

            Dim sql As String = "SELECT isi, tahun FROM " & tabel & " WHERE isi IS NOT NULL"
            Using cmd As New OleDb.OleDbCommand(sql, connection)
                Using reader As OleDb.OleDbDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        Dim isi As String = reader("isi").ToString().Trim()
                        Dim tahun As Integer = 0
                        If Integer.TryParse(reader("tahun").ToString(), tahun) Then
                            ' Hanya ambil tahun 2018
                            If tahun = 2018 Then
                                ' Ambil skor pertanyaan 1 (digit pertama dari isi)
                                If isi.Length >= 1 Then
                                    Dim skor As Integer
                                    If Integer.TryParse(isi(0).ToString(), skor) Then
                                        If skor >= 1 AndAlso skor <= 4 Then
                                            distribusiPertanyaan1(skor - 1) += 1
                                        End If
                                    End If
                                End If
                            End If
                        End If
                    End While
                End Using
            End Using
        End Using

       ' Distribusi Skor Jawaban Pertanyaan 2 untuk tahun 2018
        Dim distribusiPertanyaan2(3) As Integer ' 4 skor (1-4)

        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()

            Dim sql As String = "SELECT isi, tahun FROM " & tabel & " WHERE isi IS NOT NULL"
            Using cmd As New OleDb.OleDbCommand(sql, connection)
                Using reader As OleDb.OleDbDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        Dim isi As String = reader("isi").ToString().Trim()
                        Dim tahun As Integer = 0
                        If Integer.TryParse(reader("tahun").ToString(), tahun) Then
                            ' Hanya ambil tahun 2018
                            If tahun = 2018 Then
                                ' Ambil skor pertanyaan ke-2 (nilai kedua dari string yang dipisahkan '|')
                                Dim parts() As String = isi.Split("|"c)
                                If parts.Length >= 2 Then
                                    Dim skor As Integer
                                    If Integer.TryParse(parts(1).Trim(), skor) Then
                                        If skor >= 1 AndAlso skor <= 4 Then
                                            distribusiPertanyaan2(skor - 1) += 1
                                        End If
                                    End If
                                End If
                            End If
                        End If
                    End While
                End Using
            End Using
        End Using

       ' Distribusi Skor Jawaban Pertanyaan 3 untuk tahun 2018
        Dim distribusiPertanyaan3(3) As Integer ' 4 skor (1-4)

        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()

            Dim sql As String = "SELECT isi, tahun FROM " & tabel & " WHERE isi IS NOT NULL"
            Using cmd As New OleDb.OleDbCommand(sql, connection)
                Using reader As OleDb.OleDbDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        Dim isi As String = reader("isi").ToString().Trim()
                        Dim tahun As Integer
                        If Integer.TryParse(reader("tahun").ToString(), tahun) Then
                            ' Hanya ambil tahun 2018
                            If tahun = 2018 Then
                                ' Ambil skor pertanyaan ke-3 (nilai ketiga dari string yang dipisahkan '|')
                                Dim parts() As String = isi.Split("|"c)
                                If parts.Length >= 3 Then
                                    Dim skor As Integer
                                    If Integer.TryParse(parts(2).Trim(), skor) Then
                                        If skor >= 1 AndAlso skor <= 4 Then
                                            distribusiPertanyaan3(skor - 1) += 1
                                        End If
                                    End If
                                End If
                            End If
                        End If
                    End While
                End Using
            End Using
        End Using

       ' Distribusi Skor Jawaban Pertanyaan 4 untuk tahun 2018
        Dim distribusiPertanyaan4(3) As Integer ' 4 skor (1-4)

        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()

            Dim sql As String = "SELECT isi, tahun FROM " & tabel & " WHERE isi IS NOT NULL"
            Using cmd As New OleDb.OleDbCommand(sql, connection)
                Using reader As OleDb.OleDbDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        Dim isi As String = reader("isi").ToString().Trim()
                        Dim tahun As Integer
                        If Integer.TryParse(reader("tahun").ToString(), tahun) Then
                            ' Hanya ambil tahun 2018
                            If tahun = 2018 Then
                                ' Ambil skor pertanyaan ke-4 (nilai keempat dari string yang dipisahkan '|')
                                Dim parts() As String = isi.Split("|"c)
                                If parts.Length >= 4 Then
                                    Dim skor As Integer
                                    If Integer.TryParse(parts(3).Trim(), skor) Then
                                        If skor >= 1 AndAlso skor <= 4 Then
                                            distribusiPertanyaan4(skor - 1) += 1
                                        End If
                                    End If
                                End If
                            End If
                        End If
                    End While
                End Using
            End Using
        End Using


       ' Distribusi Skor Jawaban Pertanyaan 5 untuk tahun 2018
        Dim distribusiPertanyaan5(3) As Integer ' 4 skor (1-4)

        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()

            Dim sql As String = "SELECT isi, tahun FROM " & tabel & " WHERE isi IS NOT NULL"
            Using cmd As New OleDb.OleDbCommand(sql, connection)
                Using reader As OleDb.OleDbDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        Dim isi As String = reader("isi").ToString().Trim()
                        Dim tahun As Integer
                        If Integer.TryParse(reader("tahun").ToString(), tahun) Then
                            ' Hanya ambil tahun 2018
                            If tahun = 2018 Then
                                ' Ambil skor pertanyaan ke-5 (nilai kelima dari string yang dipisahkan '|')
                                Dim parts() As String = isi.Split("|"c)
                                If parts.Length >= 5 Then
                                    Dim skor As Integer
                                    If Integer.TryParse(parts(4).Trim(), skor) Then
                                        If skor >= 1 AndAlso skor <= 4 Then
                                            distribusiPertanyaan5(skor - 1) += 1
                                        End If
                                    End If
                                End If
                            End If
                        End If
                    End While
                End Using
            End Using
        End Using


        ' Distribusi Skor Jawaban Pertanyaan 6 untuk tahun 2018
        Dim distribusiPertanyaan6(3) As Integer ' 4 skor (1-4)

        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()

            Dim sql As String = "SELECT isi, tahun FROM " & tabel & " WHERE isi IS NOT NULL"
            Using cmd As New OleDb.OleDbCommand(sql, connection)
                Using reader As OleDb.OleDbDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        Dim isi As String = reader("isi").ToString().Trim()
                        Dim tahun As Integer
                        If Integer.TryParse(reader("tahun").ToString(), tahun) Then
                            ' Hanya ambil tahun 2018
                            If tahun = 2018 Then
                                ' Ambil skor pertanyaan ke-6 (nilai keenam dari string yang dipisahkan '|')
                                Dim parts() As String = isi.Split("|"c)
                                If parts.Length >= 6 Then
                                    Dim skor As Integer
                                    If Integer.TryParse(parts(5).Trim(), skor) Then
                                        If skor >= 1 AndAlso skor <= 4 Then
                                            distribusiPertanyaan6(skor - 1) += 1
                                        End If
                                    End If
                                End If
                            End If
                        End If
                    End While
                End Using
            End Using
        End Using


        ' Distribusi Skor Jawaban Pertanyaan 7 untuk tahun 2018
        Dim distribusiPertanyaan7(3) As Integer ' 4 skor (1-4)

        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()

            Dim sql As String = "SELECT isi, tahun FROM " & tabel & " WHERE isi IS NOT NULL"
            Using cmd As New OleDb.OleDbCommand(sql, connection)
                Using reader As OleDb.OleDbDataReader = cmd.ExecuteReader()
                    While reader.Read()
                        Dim isi As String = reader("isi").ToString().Trim()
                        Dim tahun As Integer
                        If Integer.TryParse(reader("tahun").ToString(), tahun) Then
                            ' Hanya ambil tahun 2018
                            If tahun = 2018 Then
                                ' Ambil skor pertanyaan ke-7 (nilai ketujuh dari string yang dipisahkan '|')
                                Dim parts() As String = isi.Split("|"c)
                                If parts.Length >= 7 Then
                                    Dim skor As Integer
                                    If Integer.TryParse(parts(6).Trim(), skor) Then
                                        If skor >= 1 AndAlso skor <= 4 Then
                                            distribusiPertanyaan7(skor - 1) += 1
                                        End If
                                    End If
                                End If
                            End If
                        End If
                    End While
                End Using
            End Using
        End Using

        ' Labels pertanyaan
        Dim labelsDistribusi As String = "Tahun 2018"

        Dim dataPartsPertanyaan1 As New List(Of String)
        For skor As Integer = 1 To 4
            ' Ambil nilai untuk tahun 2018, array 1 dimensi
            Dim value As String = distribusiPertanyaan1(skor - 1).ToString()
            dataPartsPertanyaan1.Add("Skor " & skor & ":" & value)
        Next
        Dim distribusiDataPertanyaan1 As String = String.Join("|", dataPartsPertanyaan1)

        Dim dataPartsPertanyaan2 As New List(Of String)
        For skor As Integer = 1 To 4
            ' Ambil nilai langsung dari array 1 dimensi
            Dim value As String = distribusiPertanyaan2(skor - 1).ToString()
            dataPartsPertanyaan2.Add("Skor " & skor & ":" & value)
        Next
        Dim distribusiDataPertanyaan2 As String = String.Join("|", dataPartsPertanyaan2)

        Dim dataPartsPertanyaan3 As New List(Of String)
        For skor As Integer = 1 To 4
            ' Ambil nilai langsung dari array 1 dimensi
            Dim value As String = distribusiPertanyaan3(skor - 1).ToString()
            dataPartsPertanyaan3.Add("Skor " & skor & ":" & value)
        Next
        Dim distribusiDataPertanyaan3 As String = String.Join("|", dataPartsPertanyaan3)

        Dim dataPartsPertanyaan4 As New List(Of String)
        For skor As Integer = 1 To 4
            ' Ambil nilai langsung dari array 1 dimensi
            Dim value As String = distribusiPertanyaan4(skor - 1).ToString()
            dataPartsPertanyaan4.Add("Skor " & skor & ":" & value)
        Next
        Dim distribusiDataPertanyaan4 As String = String.Join("|", dataPartsPertanyaan4)

        Dim dataPartsPertanyaan5 As New List(Of String)
        For skor As Integer = 1 To 4
            ' Ambil nilai langsung dari array 1 dimensi
            Dim value As String = distribusiPertanyaan5(skor - 1).ToString()
            dataPartsPertanyaan5.Add("Skor " & skor & ":" & value)
        Next
        Dim distribusiDataPertanyaan5 As String = String.Join("|", dataPartsPertanyaan5)

        Dim dataPartsPertanyaan6 As New List(Of String)
        For skor As Integer = 1 To 4
            ' Ambil nilai langsung dari array 1 dimensi
            Dim value As String = distribusiPertanyaan6(skor - 1).ToString()
            dataPartsPertanyaan6.Add("Skor " & skor & ":" & value)
        Next
        Dim distribusiDataPertanyaan6 As String = String.Join("|", dataPartsPertanyaan6)

        Dim dataPartsPertanyaan7 As New List(Of String)
        For skor As Integer = 1 To 4
            ' Ambil nilai langsung dari array 1 dimensi
            Dim value As String = distribusiPertanyaan7(skor - 1).ToString()
            dataPartsPertanyaan7.Add("Skor " & skor & ":" & value)
        Next
        Dim distribusiDataPertanyaan7 As String = String.Join("|", dataPartsPertanyaan7)


        ' Chart details for the four required charts
        Dim chartDetails As New List(Of Object) From {
            New With {.id = "distribusiChartPertanyaan1", .type = "bar", .labels = labelsDistribusi, .data = distribusiDataPertanyaan1, .isMulti = True, .showLegend = True, .title = "Distribusi Skor Jawaban Pertanyaan 1"},
            New With {.id = "distribusiChartPertanyaan2", .type = "bar", .labels = labelsDistribusi, .data = distribusiDataPertanyaan2, .isMulti = True, .showLegend = True, .title = "Distribusi Skor Jawaban Pertanyaan 2"},
            New With {.id = "distribusiChartPertanyaan3", .type = "bar", .labels = labelsDistribusi, .data = distribusiDataPertanyaan3, .isMulti = True, .showLegend = True, .title = "Distribusi Skor Jawaban Pertanyaan 3"},
            New With {.id = "distribusiChartPertanyaan4", .type = "bar", .labels = labelsDistribusi, .data = distribusiDataPertanyaan4, .isMulti = True, .showLegend = True, .title = "Distribusi Skor Jawaban Pertanyaan 4"},
            New With {.id = "distribusiChartPertanyaan5", .type = "bar", .labels = labelsDistribusi, .data = distribusiDataPertanyaan5, .isMulti = True, .showLegend = True, .title = "Distribusi Skor Jawaban Pertanyaan 5"},
            New With {.id = "distribusiChartPertanyaan6", .type = "bar", .labels = labelsDistribusi, .data = distribusiDataPertanyaan6, .isMulti = True, .showLegend = True, .title = "Distribusi Skor Jawaban Pertanyaan 6"},
            New With {.id = "distribusiChartPertanyaan7", .type = "bar", .labels = labelsDistribusi, .data = distribusiDataPertanyaan7, .isMulti = True, .showLegend = True, .title = "Distribusi Skor Jawaban Pertanyaan 7"}
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
    <h1>DASHBOARD SKOR JAWABAN PERTANYAAN PENGGUNA LULUSAN TAHUNAN</h1>
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

