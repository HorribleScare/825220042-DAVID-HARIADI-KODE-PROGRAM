<%@ Page Language="VB" MasterPageFile="../Site.master" %> <%@ Register
TagPrefix="uc" TagName="TabelAngketSoalDosen"
Src="../ascx/kuesioner_kepuasan/tabel_angket_soal_dosen.ascx" %>

<asp:Content
  ID="TitleContent"
  ContentPlaceHolderID="TitleContent"
  runat="server"
>
  Pertanyaan Kepuasan | Universitas Tarumanagara
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Memanggil user control TabelAngketSoalDosen dengan ID TabelAngketSoalDosen1 untuk menampilkan konten utama -->
  <uc:TabelAngketSoalDosen ID="TabelAngketSoalDosen1" runat="server" />
</asp:Content>
