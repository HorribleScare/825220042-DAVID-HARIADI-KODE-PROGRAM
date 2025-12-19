<%@ Page Language="VB" MasterPageFile="../Site.master" %> <%@ Register
TagPrefix="uc" TagName="TabelPengajaranHasilAngketJadi"
Src="../ascx/kuesioner_pengajaran/tabel_pengajaran_hasil_angket_jadi.ascx" %>

<asp:Content
  ID="TitleContent"
  ContentPlaceHolderID="TitleContent"
  runat="server"
>
  Dashboard Pengajaran | Universitas Tarumanagara
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Memanggil user control TabelPengajaranHasilAngketJadi dengan ID TabelPengajaranHasilAngketJadi1 untuk menampilkan konten utama -->
  <uc:TabelPengajaranHasilAngketJadi
    ID="TabelPengajaranHasilAngketJadi1"
    runat="server"
  />
</asp:Content>
