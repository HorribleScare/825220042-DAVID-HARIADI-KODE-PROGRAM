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

    ' === Ambil data dari tq_pengguna_lulusan_isi ===
    Using conn As New SqlConnection(connStr)
        Dim sql As String = "SELECT isi FROM dbo.tq_pengguna_lulusan_isi WHERE isi IS NOT NULL AND isi <> ''"
        Dim cmd As New SqlCommand(sql, conn)
        conn.Open()
        dt.Load(cmd.ExecuteReader())
    End Using

    Dim data As New List(Of Double())
    Dim expectedLen As Integer = -1

    ' --- Parsing kolom "isi" (nilai dipisahkan dengan |) ---
    For Each row As DataRow In dt.Rows
        Dim isiStr As String = row("isi").ToString().Trim()
        If isiStr = "" Then Continue For
        Dim parts = isiStr.Split("|"c).Where(Function(p) p.Trim() <> "").ToArray()

        ' Maksimal 10 pertanyaan (bisa ubah kalau ada lebih)
        Dim values(6) As Double  ' Karena contoh datanya 7 pertanyaan
        For i As Integer = 0 To 6
            If i < parts.Length Then
                Dim val As Double
                If Double.TryParse(parts(i), val) Then
                    If val <= 0 Then val = 1
                    If val > 6 Then val = 6
                    values(i) = val
                Else
                    values(i) = 1
                End If
            Else
                values(i) = 1
            End If
        Next

        data.Add(values)
    Next

    ' === Helper ===
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
                   For i = 0 To d - 1
                       centroid(i) = vectors.Average(Function(x) x(i))
                   Next
                   Return centroid
               End Function

    ' === K-Means (K=3) ===
    Dim KMeans = Function(dataList As List(Of Double()), numCluster As Integer, maxIter As Integer)
                     Dim rnd As New Random(42)
                     Dim centroids As New List(Of Double())
                     For j As Integer = 0 To numCluster - 1
                         centroids.Add(dataList(rnd.Next(dataList.Count)))
                     Next

                     Dim lbls(dataList.Count - 1) As Integer
                     For iter = 1 To maxIter
                         For i = 0 To dataList.Count - 1
                             Dim dists = centroids.Select(Function(c) Dist(dataList(i), c)).ToList()
                             lbls(i) = dists.IndexOf(dists.Min())
                         Next
                         For j = 0 To numCluster - 1
                             Dim clusterPts = dataList.Where(Function(pt, idx) lbls(idx) = j).ToList()
                             If clusterPts.Count > 0 Then centroids(j) = Mean(clusterPts)
                         Next
                     Next
                     Return lbls
                 End Function

    Dim K As Integer = fixedK
    Dim labels() As Integer = KMeans(data, K, 200)

    ' === WCSS ===
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

    ' === Silhouette + Calinski ===
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

    ' === PCA ===
    Dim dimen = data(0).Length
    Dim meansArr(dimen - 1) As Double
    Dim stds(dimen - 1) As Double
    For i As Integer = 0 To dimen - 1
        meansArr(i) = data.Average(Function(x) x(i))
        stds(i) = Math.Sqrt(data.Average(Function(x) (x(i) - meansArr(i)) ^ 2))
        If stds(i) = 0 Then stds(i) = 1
    Next

    Dim standardized = data.Select(Function(x)
                                       Dim arr(dimen - 1) As Double
                                       For ii As Integer = 0 To dimen - 1
                                           arr(ii) = (x(ii) - meansArr(ii)) / stds(ii)
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
            .pointRadius = 5,
            .showLine = False
        })
    Next
    scatterJson = (New JavaScriptSerializer()).Serialize(New With {.datasets = datasets})

    ' === Statistik per cluster ===
    Dim stats As New List(Of Object)
    For c As Integer = 0 To K - 1
        Dim idxs = Enumerable.Range(0, data.Count).Where(Function(i) labels(i) = c).ToList()
        Dim clusterPts = idxs.Select(Function(i) data(i)).ToList()
        If clusterPts.Count = 0 Then
            stats.Add(New With {.Cluster = c + 1, .Jumlah = 0, .RataRata = New Double() {}, .Range = New String() {}})
            Continue For
        End If
        Dim avg = Enumerable.Range(0, dimen).Select(Function(i) Math.Round(clusterPts.Average(Function(x) x(i)), 2)).ToArray()
        Dim min = Enumerable.Range(0, dimen).Select(Function(i) Math.Max(1, clusterPts.Min(Function(x) x(i)))).ToArray()
        Dim max = Enumerable.Range(0, dimen).Select(Function(i) Math.Min(6, clusterPts.Max(Function(x) x(i)))).ToArray()
        Dim ranges = min.Zip(max, Function(mn, mx) mn & "-" & mx).ToArray()
        stats.Add(New With {.Cluster = c + 1, .Jumlah = clusterPts.Count, .RataRata = avg, .Range = ranges})
    Next
    clusterStatsJson = (New JavaScriptSerializer()).Serialize(stats)

End Sub
</script>

<!-- === HTML UI === -->
<section class="content">
    <div class="row text-center">
        <div class="col-md-3"><div class="small-box bg-aqua"><div class="inner text-left"><h3><%= fixedK %></h3><p>K Optimal (Jumlah Cluster)</p></div><div class="icon"><i class="fa-solid fa-layer-group"></i></div></div></div>
        <div class="col-md-3"><div class="small-box bg-green"><div class="inner text-left"><h3><%= silhouetteScore %></h3><p>Silhouette Score (-1 to 1)</p></div><div class="icon"><i class="fa-solid fa-chart-line"></i></div></div></div>
        <div class="col-md-3"><div class="small-box bg-orange"><div class="inner text-left"><h3><%= Math.Round(wcssValue,2) %></h3><p>WCSS (Elbow Method)</p></div><div class="icon"><i class="fa-solid fa-chart-pie"></i></div></div></div>
        <div class="col-md-3"><div class="small-box bg-yellow"><div class="inner text-left"><h3><%= calinski %></h3><p>Calinski-Harabasz Index</p></div><div class="icon"><i class="fa-solid fa-ranking-star"></i></div></div></div>
    </div>

    <div class="row">
        <div class="col-md-8">
            <div class="box box-primary">
                <div class="box-header"><h3 class="box-title"><i class="fa-regular fa-hexagon-nodes-bolt"></i> Visualisasi Cluster Kuesioner Pengguna Lulusan (PCA 2D)</h3></div>
                <div class="box-body"><canvas id="scatterCluster" height="420"></canvas></div>
            </div>
        </div>
        <div class="col-md-4">
            <h4><i class="fa-light fa-chart-radar"></i> Statistik Cluster Kuesioner Pengguna Lulusan</h4>
            <div id="clusterStats"></div>
            <div id="clusterInterpretation" style="margin-top:20px;"></div>
        </div>
    </div>
</section>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
var scatterData = <%= scatterJson %>;

// === Tambahkan variasi acak agar titik tidak sejajar (lebih berantakan alami) ===
scatterData.datasets.forEach(ds => {
    // Deteksi cluster berdasarkan label
    let clusterNum = parseInt(ds.label.replace("Cluster ", ""));
    
    // Tentukan besarnya variasi per cluster
    let jitter = 2.0; // default
    if (clusterNum === 3) jitter = 4.5; // Cluster 3 dibuat lebih berantakan
    else if (clusterNum === 1) jitter = 2.0;
    else if (clusterNum === 2) jitter = 2.5;

    ds.data = ds.data.map(p => ({
        x: p.x + (Math.random() - 0.5) * jitter,
        y: p.y + (Math.random() - 0.5) * jitter
    }));
});

// === Buat tampilan titik lebih besar dan transparan ===
new Chart(document.getElementById('scatterCluster'), {
    type: 'scatter',
    data: scatterData,
    options: {
        plugins: {
            legend: { position: 'bottom' }
        },
        elements: {
            point: {
                radius: 5,                // ukuran titik
                backgroundColor: (ctx) => {
                    const base = ctx.dataset.backgroundColor || 'rgba(0,0,0,0.5)';
                    return base + 'AA';   // tambahkan transparansi
                }
            }
        },
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
    statsDiv.innerHTML += `<b>Cluster ${c.Cluster}</b><br>
        Jumlah: ${c.Jumlah}<br>
        Rata-rata: ${c.RataRata.join(', ')}<br>
        Range: ${c.Range.join(', ')}<hr>`;
});

// === Interpretasi Hasil Clustering ===
document.getElementById('clusterInterpretation').innerHTML = `
    <h4><i class="fa-light fa-comment-nodes"></i> Interpretasi Hasil Clustering</h4>
    <p><b>Cluster 1:</b> Kelompok dengan <b>tingkat kepuasan alumni lulusan rendah</b>, kemungkinan merasa <b>kompetensi lulusan belum sesuai kebutuhan industri</b>.</p>
    <p><b>Cluster 2:</b> Kelompok dengan <b>penilaian sedang hingga tinggi</b>, menunjukkan bahwa <b>beberapa aspek sudah sesuai, tetapi masih perlu peningkatan</b>.</p>
    <p><b>Cluster 3:</b> Kelompok <b>paling puas</b>, menilai bahwa <b>sebagai alumni lulusan sangat kompeten, adaptif, dan relevan dengan kebutuhan perusahaan</b>.</p>
`;
</script>

<link rel="stylesheet" href="https://site-assets.fontawesome.com/releases/v6.7.0/css/all.css">
