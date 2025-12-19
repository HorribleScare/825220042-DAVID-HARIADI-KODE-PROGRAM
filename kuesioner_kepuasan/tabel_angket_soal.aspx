<%@ Page Language="VB" MasterPageFile="../Site.master" %> <%@ Register
TagPrefix="uc" TagName="TabelAngketSoal"
Src="../ascx/kuesioner_kepuasan/tabel_angket_soal.ascx" %>

<asp:Content
  ID="TitleContent"
  ContentPlaceHolderID="TitleContent"
  runat="server"
>
  Pertanyaan Kepuasan | Universitas Tarumanagara
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Memanggil user control TabelAngketSoal dengan ID TabelAngketSoal1 untuk menampilkan konten utama -->
  <uc:TabelAngketSoal ID="TabelAngketSoal1" runat="server" />
</asp:Content>
