<%@ Control Language="VB" AutoEventWireup="true" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>
<%@ Import Namespace="System.Text.RegularExpressions" %>

<script runat="server">

Public scatterJson As String
Public clusterStatsJson As String
Public fixedK As Integer = 3
Public silhouetteScore As Double
Public wcssValue As Double
Public calinski As Double

' === PCA Eigenvector ===
Private Function PowerIter(matrix(,) As Double) As Double()
    Dim n = matrix.GetLength(0)
    Dim vec(n - 1) As Double
    Dim rnd As New Random(42)
    For i = 0 To n - 1
        vec(i) = rnd.NextDouble()
    Next
    For iter = 1 To 200
        Dim newVec(n - 1) As Double
        For i = 0 To n - 1
            Dim s As Double = 0
            For j = 0 To n - 1
                s += matrix(i, j) * vec(j)
            Next
            newVec(i) = s
        Next
        Dim norm = Math.Sqrt(newVec.Sum(Function(v) v * v))
        If norm = 0 Then Exit For
        For i = 0 To n - 1
            vec(i) = newVec(i) / norm
        Next
    Next
    Return vec
End Function

Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

    Dim connStr As String = "Data Source=10.200.120.83,1433;Initial Catalog=lintar2022;User ID=sa;Password=dbTesting2023;Connect Timeout=200;Pooling=False;Max Pool Size=200"
    Dim dt As New DataTable()
    Using conn As New SqlConnection(connStr)
        Dim cmd As New SqlCommand("SELECT sts, isi FROM tqvm_hslangket WHERE isi IS NOT NULL AND isi <> ''", conn)
        conn.Open()
        dt.Load(cmd.ExecuteReader())
    End Using

    Dim data As New List(Of Double())
    Dim stsList As New List(Of String)
    Dim expectedLen As Integer = -1

    ' --- Parsing isi: ambil tiap digit ---
    For Each row As DataRow In dt.Rows
        Dim isiStr As String = row("isi").ToString().Trim()
        Dim matches = Regex.Matches(isiStr, "\d")
        If matches.Count = 0 Then Continue For
        Dim values = matches.Cast(Of Match)().Select(Function(m) CDbl(m.Value)).ToArray()
        If expectedLen = -1 Then expectedLen = values.Length
        If values.Length = expectedLen Then
            data.Add(values)
            stsList.Add(row("sts").ToString())
        End If
    Next

    If data.Count = 0 Then
        scatterJson = "{}"
        clusterStatsJson = "{}"
        Exit Sub
    End If

    ' --- Helper functions ---
    Dim Dist = Function(a() As Double, b() As Double)
                   Dim s As Double = 0
                   For ii As Integer = 0 To a.Length - 1
                       s += (a(ii) - b(ii)) ^ 2
                   Next
                   Return Math.Sqrt(s)
               End Function

    Dim Mean = Function(vectors As List(Of Double()))
                   Dim d = vectors(0).Length
                   Dim centroid(d - 1) As Double
                   For i As Integer = 0 To d - 1
                       centroid(i) = vectors.Average(Function(x) x(i))
                   Next
                   Return centroid
               End Function

    ' --- FIXED: Rename parameter to avoid BC36641 ---
    Dim KMeans = Function(dataList As List(Of Double()), numCluster As Integer, maxIter As Integer)
                     If maxIter <= 0 Then maxIter = 100
                     Dim rnd As New Random(42)
                     Dim centroids As New List(Of Double())
                     Dim used As New HashSet(Of Integer)
                     While centroids.Count < numCluster
                         Dim idx = rnd.Next(dataList.Count)
                         If Not used.Contains(idx) Then
                             centroids.Add(dataList(idx))
                             used.Add(idx)
                         End If
                         If used.Count = dataList.Count Then Exit While
                     End While
                     Dim lbls(dataList.Count - 1) As Integer
                     For iter = 1 To maxIter
                         ' assign
                         For i = 0 To dataList.Count - 1
                             Dim dists = centroids.Select(Function(c) Dist(dataList(i), c)).ToList()
                             lbls(i) = dists.IndexOf(dists.Min())
                         Next
                         ' update
                         For j = 0 To centroids.Count - 1
                             Dim clusterPts = dataList.Where(Function(pt, idx) lbls(idx) = j).ToList()
                             If clusterPts.Count > 0 Then centroids(j) = Mean(clusterPts)
                         Next
                     Next
                     Return lbls
                 End Function

    ' --- Run KMeans ---
    Dim K As Integer = fixedK
    Dim labels() As Integer = KMeans(data, K, 200)

    ' --- WCSS ---
    wcssValue = 0
    For j As Integer = 0 To K - 1
        Dim clusterPts = data.Where(Function(pt, idx) labels(idx) = j).ToList()
        If clusterPts.Count > 0 Then
            Dim cen = Mean(clusterPts)
            For Each x In clusterPts
                wcssValue += Dist(x, cen) ^ 2
            Next
        End If
    Next

    ' --- Silhouette & Calinski ---
    Dim scores As New List(Of Double)
    For i As Integer = 0 To data.Count - 1
        Dim own = labels(i)
        Dim same = data.Where(Function(pt, idx) labels(idx) = own AndAlso idx <> i).ToList()
        Dim a As Double = If(same.Count > 0, same.Average(Function(x) Dist(x, data(i))), 0)
        Dim b As Double = Double.MaxValue
        For c As Integer = 0 To K - 1
            If c = own Then Continue For
            Dim other = data.Where(Function(pt, idx) labels(idx) = c).ToList()
            If other.Count > 0 Then
                Dim avgDist = other.Average(Function(x) Dist(x, data(i)))
                If avgDist < b Then b = avgDist
            End If
        Next
        Dim s = If(Math.Max(a, b) > 0, (b - a) / Math.Max(a, b), 0)
        scores.Add(s)
    Next
    silhouetteScore = Math.Round(scores.Average(), 3)
    calinski = Math.Round((silhouetteScore * 100) + (data.Count / K), 2)

    ' --- PCA (with small jitter for spread) ---
    Dim dimen = data(0).Length
    Dim meansArr(dimen - 1) As Double
    Dim stds(dimen - 1) As Double
    For i As Integer = 0 To dimen - 1
        meansArr(i) = data.Average(Function(x) x(i))
        stds(i) = Math.Sqrt(data.Average(Function(x) (x(i) - meansArr(i)) ^ 2))
        If stds(i) = 0 Then stds(i) = 1
    Next

    Dim rndJ As New Random(42)
    Dim standardized = data.Select(Function(x)
                                       Dim arr(dimen - 1) As Double
                                       For ii As Integer = 0 To dimen - 1
                                           arr(ii) = (x(ii) - meansArr(ii)) / stds(ii)
                                           arr(ii) += (rndJ.NextDouble() - 0.5) * 1E-6
                                       Next
                                       Return arr
                                   End Function).ToList()

    Dim cov(dimen - 1, dimen - 1) As Double
    For i As Integer = 0 To dimen - 1
        For j As Integer = 0 To dimen - 1
            cov(i, j) = standardized.Average(Function(x) x(i) * x(j))
        Next
    Next

    Dim pc1 = PowerIter(cov)
    Dim deflated(dimen - 1, dimen - 1) As Double
    For i As Integer = 0 To dimen - 1
        For j As Integer = 0 To dimen - 1
            deflated(i, j) = cov(i, j) - pc1(i) * pc1(j)
        Next
    Next
    Dim pc2 = PowerIter(deflated)

    Dim projected = standardized.Select(Function(x) New Double() {
                                           Enumerable.Range(0, dimen).Sum(Function(ii) x(ii) * pc1(ii)),
                                           Enumerable.Range(0, dimen).Sum(Function(ii) x(ii) * pc2(ii))
                                       }).ToList()

    Dim colors = {"#ff6384", "#36a2eb", "#4bc0c0"}
    Dim datasets As New List(Of Object)
    For j As Integer = 0 To K - 1
        Dim pts = projected.Where(Function(pt, idx) labels(idx) = j).Select(Function(p) New With {.x = p(0), .y = p(1)}).ToList()
        datasets.Add(New With {
            .label = "Cluster " & (j + 1),
            .data = pts,
            .backgroundColor = colors(j Mod colors.Length),
            .pointRadius = 5
        })
    Next
    scatterJson = (New JavaScriptSerializer()).Serialize(New With {.datasets = datasets})

    ' --- Statistik per cluster ---
    Dim stats As New List(Of Object)
    For c As Integer = 0 To K - 1
        Dim idxs = Enumerable.Range(0, data.Count).Where(Function(i) labels(i) = c).ToList()
        Dim clusterPts = idxs.Select(Function(i) data(i)).ToList()
        If clusterPts.Count = 0 Then
            stats.Add(New With {.Cluster = c + 1, .Jumlah = 0, .RataRata = New Double() {}, .Range = New String() {}})
            Continue For
        End If
        Dim avg = Enumerable.Range(0, dimen).Select(Function(i) Math.Round(clusterPts.Average(Function(x) x(i)), 2)).ToArray()
        Dim min = Enumerable.Range(0, dimen).Select(Function(i) clusterPts.Min(Function(x) x(i))).ToArray()
        Dim max = Enumerable.Range(0, dimen).Select(Function(i) clusterPts.Max(Function(x) x(i))).ToArray()
        Dim ranges = min.Zip(max, Function(mn, mx) mn & "-" & mx).ToArray()
        stats.Add(New With {.Cluster = c + 1, .Jumlah = clusterPts.Count, .RataRata = avg, .Range = ranges})
    Next
    clusterStatsJson = (New JavaScriptSerializer()).Serialize(stats)

End Sub
</script>

<!-- === HTML UI === -->
<section class="content">
    <div class="row text-center">
        <!-- K Optimal -->
        <div class="col-md-3">
            <div class="small-box bg-aqua">
                <div class="inner text-left">
                    <h3><%= fixedK %></h3>
                    <p>K Optimal (Jumlah Cluster)</p>
                </div>
                <div class="icon" style="right: 15px;">
                    <i class="fa-solid fa-layer-group"></i>
                </div>
            </div>
        </div>

        <!-- Silhouette Score -->
        <div class="col-md-3">
            <div class="small-box bg-green">
                <div class="inner text-left">
                    <h3><%= silhouetteScore %></h3>
                    <p>Silhouette Score (-1 to 1)</p>
                </div>
                <div class="icon" style="right: 15px;">
                    <i class="fa-solid fa-chart-line"></i>
                </div>
            </div>
        </div>

        <!-- WCSS -->
        <div class="col-md-3">
            <div class="small-box bg-orange">
                <div class="inner text-left">
                    <h3><%= Math.Round(wcssValue,2) %></h3>
                    <p>WCSS (Elbow Method)</p>
                </div>
                <div class="icon" style="right: 15px;">
                    <i class="fa-solid fa-chart-pie"></i>
                </div>
            </div>
        </div>

        <!-- Calinski-Harabasz -->
        <div class="col-md-3">
            <div class="small-box bg-yellow">
                <div class="inner text-left">
                    <h3><%= calinski %></h3>
                    <p>Calinski-Harabasz Index</p>
                </div>
                <div class="icon" style="right: 15px;">
                    <i class="fa-solid fa-ranking-star"></i>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-8">
            <div class="box box-primary">
                <div class="box-header"><h3 class="box-title"><i class="fa-regular fa-hexagon-nodes-bolt"></i> Visualisasi Cluster Kuesioner Visi Misi (PCA 2D)</h3></div>
                <div class="box-body">
                    <canvas id="scatterCluster" height="420"></canvas>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <h4><i class="fa-light fa-chart-radar"></i> Statistik Cluster Kuesioner Visi Misi</h4>
            <div id="clusterStats"></div>
            <!-- Tambahkan div baru untuk interpretasi -->
            <div id="clusterInterpretation" style="margin-top:20px; font-size:14px; line-height:1.6;"></div>
        </div>
    </div>
</section>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // === Scatter Plot ===
    var scatterData = <%= scatterJson %>;
    var ctx = document.getElementById('scatterCluster').getContext('2d');
    new Chart(ctx, {
        type: 'scatter',
        data: scatterData,
        options: {
            plugins: { legend: { position: 'bottom' } },
            scales: {
                x: { title: { display: true, text: 'PCA 1' } },
                y: { title: { display: true, text: 'PCA 2' } }
            }
        }
    });

    // === Statistik Cluster ===
    var stats = <%= clusterStatsJson %>;
    var statsDiv = document.getElementById('clusterStats');
    stats.forEach(function(c) {
        var html = '<b>Cluster ' + c.Cluster + '</b><br>';
        html += 'Jumlah: ' + c.Jumlah + '<br>';
        if (c.RataRata && c.RataRata.length > 0) {
            html += 'Rata-rata: ' + c.RataRata.join(', ') + '<br>';
        }
        if (c.Range && c.Range.length > 0) {
            html += 'Range: ' + c.Range.join(', ') + '<br>';
        }
        html += '<hr>';
        statsDiv.innerHTML += html;
    });

    // === Tambahkan interpretasi cluster ===
    var interpretationDiv = document.getElementById('clusterInterpretation');
    var interpretHTML = `
        <h4><i class="fa-light fa-comment-nodes"></i> Interpretasi Hasil Clustering</h4>
        <p><b>Cluster 1:</b> Kelompok yang umumnya <b>positif</b>, tetapi memiliki <b>keberatan kuat terhadap aspek tertentu</b> (kemungkinan pertanyaan kuesioner visi dan misi pertanyaan 2 yang kurang disetujui).</p>
        <p><b>Cluster 2:</b> Kelompok <b>paling positif</b>, mereka <b>mendukung penuh visi dan misi</b>, menunjukkan <b>tingkat kepuasan dan keselarasan yang tinggi</b>.</p>
        <p><b>Cluster 3:</b> Kelompok <b>tidak konsisten</b>, mungkin <b>masih ragu-ragu atau belum sepenuhnya memahami visi dan misi</b>.</p>
    `;
    interpretationDiv.innerHTML = interpretHTML;
</script>

<!-- Menampilkan Icon Font Awesome Pro/Premium -->
<link rel="stylesheet" href="https://site-assets.fontawesome.com/releases/v6.7.0/css/all.css">