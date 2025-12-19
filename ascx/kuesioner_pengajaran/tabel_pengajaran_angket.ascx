<!-- #INCLUDE file = "/con_ascx2022/conlintar2022.ascx" -->

<section class="content-header" style="margin-top:20px;">
    <h1>
        PERTANYAAN PENGAJARAN
        <small> &nbsp;</small>
    </h1>

    <ol class="breadcrumb">
        <li><a href="/dashboard_kuesioner/index.aspx"><i class="fa fa-dashboard"></i> Dashboard</a></li>
        <li><a href="tabel_pengajaran_angket.aspx">Pertanyaan Pengajaran</a></li>
    </ol>
</section>



<section class="content">
    <div class="box box-success">
        <div class="box-header">
            <h2 class="box-title">Daftar Pertanyaan</h2>
        </div>

        <div class="box-body">
            <asp:DropDownList ID="ddlProdi" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlProdi_SelectedIndexChanged" CssClass="form-control">
                <asp:ListItem Value="115">Ekonomi Manajemen</asp:ListItem>
                <asp:ListItem Value="125">Ekonomi Akuntansi</asp:ListItem>
                <asp:ListItem Value="127">Magister Akuntansi</asp:ListItem>
                <asp:ListItem Value="205">Hukum</asp:ListItem>
                <asp:ListItem Value="615">Desain Interior</asp:ListItem>
                <asp:ListItem Value="625">Desain Komunikasi Visual</asp:ListItem>
                <asp:ListItem Value="705">Psikologi</asp:ListItem>
                <asp:ListItem Value="706">Profesi Psikologi</asp:ListItem>
                <asp:ListItem Value="707">Magister Psikologi</asp:ListItem>
            </asp:DropDownList>


            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="nomor" CssClass="table table-bordered" OnRowEditing="GridView1_RowEditing" OnRowDeleting="GridView1_RowDeleting" OnRowUpdating="GridView1_RowUpdating" OnRowCancelingEdit="GridView1_RowCancelingEdit">
                <Columns>
                    <asp:BoundField DataField="nomor" HeaderText="Nomor" ReadOnly="True" />

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

    Sub ddlProdi_SelectedIndexChanged(sender As Object, e As EventArgs)
        BindGrid()
    End Sub

    Sub BindGrid()
        Dim kdjur As Integer = Convert.ToInt32(ddlProdi.SelectedValue)
        Using connection As New OleDb.OleDbConnection(connectionString)
            Dim query As String = "SELECT flag, nomor, kdjur, soal FROM tq_angket WHERE kdjur = ? AND flag = 0 ORDER BY flag, nomor"
            Using command As New OleDb.OleDbCommand(query, connection)
                command.Parameters.AddWithValue("?", kdjur)
                Dim adapter As New OleDb.OleDbDataAdapter(command)
                Dim dt As New DataTable()
                adapter.Fill(dt)
                GridView1.DataSource = dt
                GridView1.DataBind()
            End Using
        End Using
    End Sub

    Sub GridView1_RowEditing(sender As Object, e As GridViewEditEventArgs)
        GridView1.EditIndex = e.NewEditIndex
        BindGrid()
    End Sub

    Sub GridView1_RowUpdating(sender As Object, e As GridViewUpdateEventArgs)
        Dim nomor As Integer = Convert.ToInt32(GridView1.DataKeys(e.RowIndex).Value)
        Dim soal As String = CType(GridView1.Rows(e.RowIndex).FindControl("txtPertanyaan"), TextBox).Text

        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()
            Dim query As String = "UPDATE dbo.tq_angket SET soal = ? WHERE nomor = ?"
            Using command As New OleDb.OleDbCommand(query, connection)
                command.Parameters.AddWithValue("?", soal)
                command.Parameters.AddWithValue("?", nomor)
                command.ExecuteNonQuery()
            End Using
        End Using

        GridView1.EditIndex = -1
        BindGrid()
    End Sub

    Sub GridView1_RowCancelingEdit(sender As Object, e As GridViewCancelEditEventArgs)
        GridView1.EditIndex = -1  ' Kembali ke mode view
        BindGrid()                ' Refresh data
    End Sub

    Sub GridView1_RowDeleting(sender As Object, e As GridViewDeleteEventArgs)
        Dim nomor As Integer = Convert.ToInt32(GridView1.DataKeys(e.RowIndex).Value)

        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()
            Dim query As String = "DELETE FROM dbo.tq_angket WHERE nomor = ?"
            Using command As New OleDb.OleDbCommand(query, connection)
                command.Parameters.AddWithValue("?", nomor)
                command.ExecuteNonQuery()
            End Using
        End Using

        BindGrid()
    End Sub

    Function GenerateNewNomor(kdjur As Integer) As Integer
        Dim newNomor As Integer = 0
        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()
            Dim query As String = "SELECT ISNULL(MAX(nomor), 0) + 1 FROM dbo.tq_angket WHERE kdjur = ?"
            Using command As New OleDb.OleDbCommand(query, connection)
                command.Parameters.AddWithValue("?", kdjur)
                newNomor = Convert.ToInt32(command.ExecuteScalar())
            End Using
        End Using
        Return newNomor
    End Function

    Sub btnAdd_Click(sender As Object, e As EventArgs)
        Dim kdjur As Integer = Convert.ToInt32(ddlProdi.SelectedValue)
        Using connection As New OleDb.OleDbConnection(connectionString)
            connection.Open()
            Dim query As String = "INSERT INTO dbo.tq_angket (nomor, soal, flag, kdjur) VALUES (?, ?, ?, ?)"
            Using command As New OleDb.OleDbCommand(query, connection)
                Dim newNomor As Integer = GenerateNewNomor(kdjur) ' ← perbaikan
                command.Parameters.AddWithValue("?", newNomor)
                command.Parameters.AddWithValue("?", "Pertanyaan Baru")
                command.Parameters.AddWithValue("?", 0)      ' flag default 0
                command.Parameters.AddWithValue("?", kdjur)  ' kdjur sesuai dropdown
                command.ExecuteNonQuery()
            End Using
        End Using

        BindGrid()
    End Sub
</script>

<!-- Menampilkan Icon Font Awesome Pro/Premium -->
<link rel="stylesheet" href="https://site-assets.fontawesome.com/releases/v7.0.0/css/all.css">