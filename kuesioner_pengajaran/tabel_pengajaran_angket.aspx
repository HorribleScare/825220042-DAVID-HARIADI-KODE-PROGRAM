<%@ Page Language="VB" MasterPageFile="../Site.master" %> <%@ Register
TagPrefix="uc" TagName="TabelPengajaranAngket"
Src="../ascx/kuesioner_pengajaran/tabel_pengajaran_angket.ascx" %>

<asp:Content
  ID="TitleContent"
  ContentPlaceHolderID="TitleContent"
  runat="server"
>
  Pertanyaan Pengajaran | Universitas Tarumanagara
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Memanggil user control TabelPengajaranAngket dengan ID TabelPengajaranAngket1 untuk menampilkan konten utama -->
  <uc:TabelPengajaranAngket ID="TabelPengajaranAngket1" runat="server" />
</asp:Content>
