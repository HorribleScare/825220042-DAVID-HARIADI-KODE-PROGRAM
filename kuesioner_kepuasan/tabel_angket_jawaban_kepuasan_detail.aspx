<%@ Page Language="VB" MasterPageFile="../Site.master" %> <%@ Register
TagPrefix="uc" TagName="TabelAngketJawabanKepuasanDetail"
Src="../ascx/kuesioner_kepuasan/tabel_angket_jawaban_kepuasan_detail.ascx" %>

<asp:Content
  ID="TitleContent"
  ContentPlaceHolderID="TitleContent"
  runat="server"
>
  Dashboard Skor Jawaban Pertanyaan Kepuasan Tahunan | Universitas Tarumanagara
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Memanggil user control TabelAngketJawabanKepuasanDetail dengan ID TabelAngketJawabanKepuasanDetail1 untuk menampilkan konten utama -->
  <uc:TabelAngketJawabanKepuasanDetail
    ID="TabelAngketJawabanKepuasanDetail1"
    runat="server"
  />
</asp:Content>
