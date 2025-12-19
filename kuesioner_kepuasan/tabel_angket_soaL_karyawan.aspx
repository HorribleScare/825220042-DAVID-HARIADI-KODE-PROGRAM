<%@ Page Language="VB" MasterPageFile="../Site.master" %> <%@ Register
TagPrefix="uc" TagName="TabelAngketSoalKaryawan"
Src="../ascx/kuesioner_kepuasan/tabel_angket_soal_karyawan.ascx" %>

<asp:Content
  ID="TitleContent"
  ContentPlaceHolderID="TitleContent"
  runat="server"
>
  Pertanyaan Kepuasan | Universitas Tarumanagara
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Memanggil user control TabelAngketSoalKaryawan dengan ID TabelAngketSoalKaryawan1 untuk menampilkan konten utama -->
  <uc:TabelAngketSoalKaryawan ID="TabelAngketSoalKaryawan1" runat="server" />
</asp:Content>
