<%@ Page Language="VB" MasterPageFile="../Site.master" %> <%@ Register
TagPrefix="uc" TagName="TabelAngketJawabanKepuasan"
Src="../ascx/kuesioner_kepuasan/tabel_angket_jawaban_kepuasan.ascx" %>

<asp:Content
  ID="TitleContent"
  ContentPlaceHolderID="TitleContent"
  runat="server"
>
  Dashboard Kepuasan | Universitas Tarumanagara
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Memanggil user control TabelAngketJawabanKepuasan dengan ID TabelAngketJawabanKepuasan1 untuk menampilkan konten utama -->
  <uc:TabelAngketJawabanKepuasan
    ID="TabelAngketJawabanKepuasan1"
    runat="server"
  />
</asp:Content>
