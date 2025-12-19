<%@ Control Language="VB" ClassName="InputDataKPI" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.OleDb" %>

<style>
    .panel { border:1px solid #ddd; padding:12px; border-radius:4px; background:#fafafa; margin-top:8px; }
    .form-row { display:flex; gap:8px; align-items:center; margin-bottom:8px; flex-wrap:wrap; }
    .form-row label { width:160px; font-weight:600; font-size:13px; }
    .form-row .input { flex:1; min-width:160px; }
</style>

<script runat="server">
    Private Const CONN As String =
        "Provider=sqloledb;Data Source=10.200.120.83,1433;Network Library=DBMSSOCN;" &
        "Initial Catalog=lintar2022;User ID=sa;Password=dbTesting2023;connect timeout=200;pooling=false;max pool size=200"

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LoadTahun()
            LoadKuesioner()
            LoadIndikator()
            pnlTambah.Visible = False
            BindGridKPI() ' langsung tampilkan semua data saat load halaman
        End If
    End Sub

    Private Sub LoadTahun()
        ddlTambahTahun.Items.Clear()
        For th As Integer = 2012 To 2022
            ddlTambahTahun.Items.Add(New ListItem(th.ToString(), th.ToString()))
        Next
        ddlTambahTahun.SelectedValue = "2012"
    End Sub

    Private Sub LoadKuesioner()
        ddlKuesioner.Items.Clear()
        ddlKuesioner.Items.Add(New ListItem("Kuesioner Visi Misi", "visi_misi"))
        ddlKuesioner.Items.Add(New ListItem("Kuesioner Kepuasan", "kepuasan"))
        ddlKuesioner.Items.Add(New ListItem("Kuesioner Pengajaran", "pengajaran"))
        ddlKuesioner.Items.Add(New ListItem("Kuesioner Pengguna Lulusan", "pengguna_lulusan"))
    End Sub

    Private Sub LoadIndikator()
        ddlIndikator.Items.Clear()
        ddlIndikator.Items.Add(New ListItem("Jumlah Total Responden", "total_responden"))
        ddlIndikator.Items.Add(New ListItem("Tingkat Respon Positif (Jumlah Skor 4 & 5)", "respon_positif"))
    End Sub

    Protected Sub btnTambah_Click(sender As Object, e As EventArgs)
        pnlTambah.Visible = True
        lblMsg.Text = ""
    End Sub

    Protected Sub btnCancelTambah_Click(sender As Object, e As EventArgs)
        pnlTambah.Visible = False
        txtTargetBaru.Text = ""
        lblMsg.Text = ""
    End Sub

    Protected Sub btnSimpanBaru_Click(sender As Object, e As EventArgs)
        Dim tahun As Integer = Convert.ToInt32(ddlTambahTahun.SelectedValue)
        Dim kuesioner As String = ddlKuesioner.SelectedValue
        Dim indikator As String = ddlIndikator.SelectedValue
        Dim targetVal As Integer

        If Not Integer.TryParse(txtTargetBaru.Text.Trim(), targetVal) Then
            lblMsg.Text = "Target harus berupa angka."
            Return
        End If

        Using cn As New OleDbConnection(CONN)
            cn.Open()

            ' Cek apakah data sudah ada
            Dim sqlCheck As String = "SELECT COUNT(*) FROM dbo.kpi_input_kuesioner WHERE tahun=? AND kuesioner=? AND indikator=?"
            Using cmdCheck As New OleDbCommand(sqlCheck, cn)
                cmdCheck.Parameters.AddWithValue("@p1", tahun)
                cmdCheck.Parameters.AddWithValue("@p2", kuesioner)
                cmdCheck.Parameters.AddWithValue("@p3", indikator)
                Dim exists As Integer = Convert.ToInt32(cmdCheck.ExecuteScalar())

                If exists > 0 Then
                    ' Update jika sudah ada
                    Dim sqlUpd As String = "UPDATE dbo.kpi_input_kuesioner SET target_total=?, update_at=GETDATE() WHERE tahun=? AND kuesioner=? AND indikator=?"
                    Using cmdUpd As New OleDbCommand(sqlUpd, cn)
                        cmdUpd.Parameters.AddWithValue("@p1", targetVal)
                        cmdUpd.Parameters.AddWithValue("@p2", tahun)
                        cmdUpd.Parameters.AddWithValue("@p3", kuesioner)
                        cmdUpd.Parameters.AddWithValue("@p4", indikator)
                        cmdUpd.ExecuteNonQuery()
                    End Using
                Else
                    ' Insert jika belum ada
                    Dim sqlIns As String = "INSERT INTO dbo.kpi_input_kuesioner (tahun, kuesioner, indikator, target_total, created_at) VALUES (?,?,?,?,GETDATE())"
                    Using cmdIns As New OleDbCommand(sqlIns, cn)
                        cmdIns.Parameters.AddWithValue("@p1", tahun)
                        cmdIns.Parameters.AddWithValue("@p2", kuesioner)
                        cmdIns.Parameters.AddWithValue("@p3", indikator)
                        cmdIns.Parameters.AddWithValue("@p4", targetVal)
                        cmdIns.ExecuteNonQuery()
                    End Using
                End If
            End Using
        End Using

        pnlTambah.Visible = False
        txtTargetBaru.Text = ""
        BindGridKPI() ' reload semua data
    End Sub

    Private Sub BindGridKPI()
        Using cn As New OleDbConnection(CONN)
            cn.Open()
            Dim sql As String = "SELECT id, tahun, kuesioner, indikator, target_total, created_at, update_at FROM dbo.kpi_input_kuesioner ORDER BY id ASC"
            Using cmd As New OleDbCommand(sql, cn)
                Using da As New OleDbDataAdapter(cmd)
                    Dim dt As New DataTable()
                    da.Fill(dt)
                    gvKPI.DataSource = dt
                    gvKPI.DataBind()
                End Using
            End Using
        End Using
    End Sub

    Protected Sub gvKPI_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        Dim id As Integer
        If Not Integer.TryParse(e.CommandArgument.ToString(), id) Then Exit Sub

        If e.CommandName = "DeleteRow" Then
            Using cn As New OleDbConnection(CONN)
                cn.Open()
                Dim sql As String = "DELETE FROM dbo.kpi_input_kuesioner WHERE id=?"
                Using cmd As New OleDbCommand(sql, cn)
                    cmd.Parameters.AddWithValue("@p1", id)
                    cmd.ExecuteNonQuery()
                End Using
            End Using
            BindGridKPI()

        ElseIf e.CommandName = "EditRow" Then
            Using cn As New OleDbConnection(CONN)
                cn.Open()
                Dim sql As String = "SELECT tahun, kuesioner, indikator, target_total FROM dbo.kpi_input_kuesioner WHERE id=?"
                Using cmd As New OleDbCommand(sql, cn)
                    cmd.Parameters.AddWithValue("@p1", id)
                    Using rd = cmd.ExecuteReader()
                        If rd.Read() Then
                            ddlTambahTahun.SelectedValue = rd("tahun").ToString()
                            ddlKuesioner.SelectedValue = rd("kuesioner").ToString()
                            ddlIndikator.SelectedValue = rd("indikator").ToString()
                            txtTargetBaru.Text = rd("target_total").ToString()
                            pnlTambah.Visible = True
                        End If
                    End Using
                End Using
            End Using
        End If
    End Sub
</script>

<div class="box box-primary">
    <div class="box-header with-border">
        <h3 class="box-title">Input KPI (Kuesioner)</h3>
    </div>

    <div class="box-body">
        <asp:Button ID="btnTambah" runat="server" Text="Tambah Data" CssClass="btn btn-success" OnClick="btnTambah_Click" />
        <asp:Panel ID="pnlTambah" runat="server" CssClass="panel" Visible="false">
            <div class="form-row">
                <label>Tahun</label>
                <div class="input"><asp:DropDownList ID="ddlTambahTahun" runat="server" CssClass="form-control" /></div>
            </div>
            <div class="form-row">
                <label>Kuesioner</label>
                <div class="input"><asp:DropDownList ID="ddlKuesioner" runat="server" CssClass="form-control" /></div>
            </div>
            <div class="form-row">
                <label>Indikator</label>
                <div class="input"><asp:DropDownList ID="ddlIndikator" runat="server" CssClass="form-control" /></div>
            </div>
            <div class="form-row">
                <label>Target (angka)</label>
                <div class="input"><asp:TextBox ID="txtTargetBaru" runat="server" CssClass="form-control" /></div>
            </div>
            <div style="margin-top:6px;">
                <asp:Button ID="btnSimpanBaru" runat="server" Text="Simpan" CssClass="btn btn-primary" OnClick="btnSimpanBaru_Click" />
                <asp:Button ID="btnCancelTambah" runat="server" Text="Batal" CssClass="btn btn-default" OnClick="btnCancelTambah_Click" />
                <asp:Label ID="lblMsg" runat="server" ForeColor="Red" Style="margin-left:8px;"></asp:Label>
            </div>
        </asp:Panel>

        <hr/>
        <h4>Data KPI</h4>
        <asp:GridView ID="gvKPI" runat="server" CssClass="table table-bordered table-striped"
            AutoGenerateColumns="False" OnRowCommand="gvKPI_RowCommand">
            <Columns>
                <asp:BoundField DataField="id" HeaderText="ID" />
                <asp:BoundField DataField="tahun" HeaderText="Tahun" />
                <asp:BoundField DataField="kuesioner" HeaderText="Kuesioner" />
                <asp:BoundField DataField="indikator" HeaderText="Indikator" />
                <asp:BoundField DataField="target_total" HeaderText="Target" />
                <asp:BoundField DataField="created_at" HeaderText="Dibuat" DataFormatString="{0:dd-MM-yyyy HH:mm}" />
                <asp:BoundField DataField="update_at" HeaderText="Diperbarui" DataFormatString="{0:dd-MM-yyyy HH:mm}" />
                <asp:TemplateField HeaderText="Aksi">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnEdit" runat="server"
                            CommandName="EditRow"
                            CommandArgument='<%# Eval("id") %>'
                            CssClass="btn btn-xs btn-warning" ToolTip="Edit">
                            <i class="fa-solid fa-pencil-line fa-lg"></i>
                        </asp:LinkButton>
                        &nbsp;
                        <asp:LinkButton ID="btnDel" runat="server"
                            CommandName="DeleteRow"
                            CommandArgument='<%# Eval("id") %>'
                            CssClass="btn btn-xs btn-danger" ToolTip="Hapus"
                            OnClientClick="return confirm(&quot;Yakin hapus data ini?&quot;);">
                            <i class="fa-solid fa-trash-can-list fa-lg"></i>
                        </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</div>

<!-- Menampilkan Icon Font Awesome Pro/Premium -->
<link rel="stylesheet" href="https://site-assets.fontawesome.com/releases/v7.0.0/css/all.css">
