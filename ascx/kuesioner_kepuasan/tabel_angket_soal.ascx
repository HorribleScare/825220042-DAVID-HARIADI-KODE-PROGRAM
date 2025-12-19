<!-- #INCLUDE file = "/con_ascx2022/conlintar2022.ascx" -->

<section class="content-header" style="margin-top:20px;">
    <div style="display: flex; justify-content: space-between; align-items: center;">
        <div>
            <h1>
                PERTANYAAN KEPUASAN
                <small> &nbsp;</small>
            </h1>

            <ol class="breadcrumb" style="margin-bottom:0;">
                <li><a href="/dashboard_kuesioner/index.aspx"><i class="fa fa-dashboard"></i> Dashboard</a></li>
                <li><a href="tabel_angket_soal.aspx">Pertanyaan Kepuasan</a></li>
            </ol>
        </div>

        <!-- Filter jenis mahasiswa/dosen/karyawan -->
        <div>
            <label for="jenisFilter" style="margin-right: 8px;">Filter Jenis Pertanyaan</label>
            <select id="jenisFilter" onchange="handleJenisChange()">
                <option value="mahasiswa" selected>Mahasiswa</option>
                <option value="dosen">Dosen</option>
                <option value="karyawan">Karyawan</option>
            </select>
        </div>
    </div>
</section>



<style>
    .content-header {
        padding-right: 200px; /* atau sesuai lebar dropdown + margin */
    }
</style>



<script>
    function handleJenisChange() {
        var jenis = document.getElementById("jenisFilter").value;
        if(jenis === "dosen") {
            // Ganti ke halaman dosen
            window.location.href = "tabel_angket_soal_dosen.aspx";
        }
        else if(jenis === "mahasiswa") {
            // Ganti ke halaman mahasiswa
            window.location.href = "tabel_angket_soal.aspx";
        }
        else if(jenis === "karyawan") {
            // Ganti ke halaman karyawan
            window.location.href = "tabel_angket_soal_karyawan.aspx";
        }
    }
</script>



<section class="content">
    <div class="box box-success">
        <div class="box-header">
            <h2 class="box-title">Daftar Pertanyaan</h2>
        </div>

        <div class="box-body">
            <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" DataKeyNames="id" CssClass="table table-bordered" OnRowEditing="GridView2_RowEditing" OnRowDeleting="GridView2_RowDeleting" OnRowUpdating="GridView2_RowUpdating" OnRowCancelingEdit="GridView2_RowCancelingEdit">
                <Columns>
                    <asp:BoundField DataField="id" HeaderText="ID" ReadOnly="True" />

                    <asp:TemplateField HeaderText="Pertanyaan">
                        <ItemTemplate>
                            <%# Eval("soal") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtPertanyaan" runat="server" 
                                Text='<%# Bind("soal") %>' 
                                TextMode="MultiLine" 
                                Rows="2" 
                                CssClass="form-control" 
                                Style="width:100%;">
                            </asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Aksi">
                        <ItemTemplate>
                            <!-- Tombol Edit Hijau -->
                            <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" ToolTip="Edit" CssClass="btn btn-success btn-sm">
                                <i class="fa-solid fa-pencil-line"></i>
                            </asp:LinkButton>

                            <!-- Tombol Delete Merah -->
                            <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" ToolTip="Delete" CssClass="btn btn-danger btn-sm"
                                OnClientClick="return confirm('Apakah Saudara yakin akan menghapus data ini?');">
                                <i class="fa-solid fa-trash-can-list"></i>
                            </asp:LinkButton>
                        </ItemTemplate>

                        <EditItemTemplate>
                            <!-- Tombol Update Hijau -->
                            <asp:LinkButton ID="btnUpdate" runat="server" CommandName="Update" ToolTip="Update" CssClass="btn btn-success btn-sm">
                                <i class="fa-solid fa-floppy-disk-pen"></i>
                            </asp:LinkButton>

                            <!-- Tombol Cancel Merah -->
                            <asp:LinkButton ID="btnCancel" runat="server" CommandName="Cancel" ToolTip="Cancel" CssClass="btn btn-danger btn-sm">
                                <i class="fa-solid fa-floppy-disk-circle-xmark"></i>
                            </asp:LinkButton>
                        </EditItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <asp:Button ID="btnAdd" runat="server" Text="Tambah Pertanyaan" CssClass="btn btn-success" OnClick="btnAdd_Click" />
        </div>
    </div>
</section>



<script runat="server">
    Dim connectionString As String = "Provider=sqloledb;Data Source=10.200.120.83,1433;Network Library=DBMSSOCN;Initial Catalog=lintar2022;User ID=sa;Password=dbTesting2023;connect timeout=200;pooling=false;max pool size=200"

    Sub Page_Load(sender As Object, e As EventArgs)
        If Not Page.IsPostBack Then
            BindGrid()
        End If
    End Sub

    Sub BindGrid()
        Using connection As New OleDb.OleDbConnection(connectionString)
            Dim query As String = "SELECT id, soal FROM dbo.t_angket_soal WHERE jns = 'MHS'"
            Dim adapter As New OleDb.OleDbDataAdapter(query, connection)
            Dim dt As New DataTable()
            adapter.Fill(dt)
            GridView2.DataSource = dt
            GridView2.DataBind()
        End Using
    End Sub

    Sub GridView2_RowEditing(sender As Object, e As GridViewEditEventArgs)
        GridView2.EditIndex = e.NewEditIndex
        BindGrid()
    End Sub

    Sub GridView2_RowUpdating(sender As Object, e As GridViewUpdateEventArgs)
        Dim id As Integer = Convert.ToInt32(GridView2.DataKeys(e.RowIndex).Value)
        Dim soal As String = CType(GridView2.Rows(e.RowIndex).FindControl("txtPertanyaan"), TextBox).Text

        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()
            Dim query As String = "UPDATE dbo.t_angket_soal SET soal = ? WHERE id = ? AND jns = 'MHS'"
            Using command As New OleDb.OleDbCommand(query, connection)
                command.Parameters.AddWithValue("?", soal)
                command.Parameters.AddWithValue("?", id)
                command.ExecuteNonQuery()
            End Using
        End Using

        GridView2.EditIndex = -1
        BindGrid()
    End Sub

    Sub GridView2_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs)
        GridView2.EditIndex = -1  ' Kembali ke mode view
        BindGrid()                ' Refresh data
    End Sub

    Sub GridView2_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)
        Dim id As Integer = Convert.ToInt32(GridView2.DataKeys(e.RowIndex).Value)

        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()
            Dim query As String = "DELETE FROM dbo.t_angket_soal WHERE id = ? AND jns = 'MHS'"
            Using command As New OleDb.OleDbCommand(query, connection)
                command.Parameters.AddWithValue("?", id)
                command.ExecuteNonQuery()
            End Using
        End Using

        BindGrid()
    End Sub

    Function GenerateNewId(jns As String) As Integer
        Dim newId As Integer = 1
        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()
            Dim query As String = "SELECT ISNULL(MAX(id), 0) + 1 FROM dbo.t_angket_soal WHERE jns = ?"
            Using command As New OleDb.OleDbCommand(query, connection)
                command.Parameters.AddWithValue("?", jns)
                newId = Convert.ToInt32(command.ExecuteScalar())
            End Using
        End Using
        Return newId
    End Function

    Function GenerateNewUrutan(jns As String) As Integer
        Dim newUrutan As Integer = 1
        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()
            Dim query As String = "SELECT ISNULL(MAX(urutan), 0) + 1 FROM dbo.t_angket_soal WHERE jns = ?"
            Using command As New OleDb.OleDbCommand(query, connection)
                command.Parameters.AddWithValue("?", jns)
                newUrutan = Convert.ToInt32(command.ExecuteScalar())
            End Using
        End Using
        Return newUrutan
    End Function


    Sub btnAdd_Click(sender As Object, e As EventArgs)
        Dim jnsValue As String = "MHS" ' sesuaikan sesuai kebutuhan
        
        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()
            Dim newId As Integer = GenerateNewId(jnsValue)
            Dim newUrutan As Integer = GenerateNewUrutan(jnsValue)
            Dim query As String = "INSERT INTO dbo.t_angket_soal (id, flag, no, subno, urutan, jns, soal, soal_eng, tampil_qs) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
            Using command As New OleDb.OleDbCommand(query, connection)
                command.Parameters.AddWithValue("?", newId)
                command.Parameters.AddWithValue("?", 0)                 ' flag
                command.Parameters.AddWithValue("?", 1)                 ' no
                command.Parameters.AddWithValue("?", 0)                 ' subno
                command.Parameters.AddWithValue("?", newUrutan)         ' urutan
                command.Parameters.AddWithValue("?", jnsValue)          ' jns
                command.Parameters.AddWithValue("?", "Pertanyaan Baru") ' soal
                command.Parameters.AddWithValue("?", "")                ' soal_eng
                command.Parameters.AddWithValue("?", "Y")               ' tampil_qs
                
                command.ExecuteNonQuery()
            End Using
        End Using

        BindGrid()
    End Sub
</script>

<!-- Menampilkan Icon Font Awesome Pro/Premium -->
<link rel="stylesheet" href="https://site-assets.fontawesome.com/releases/v7.0.0/css/all.css">