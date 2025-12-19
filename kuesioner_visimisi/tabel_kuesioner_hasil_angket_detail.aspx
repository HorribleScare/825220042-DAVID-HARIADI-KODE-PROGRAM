<%@ Page Language="VB" MasterPageFile="../Site.master" %> <%@ Register
TagPrefix="uc" TagName="TabelKuesionerHasilAngketDetail"
Src="../ascx/kuesioner_visimisi/tabel_kuesioner_hasil_angket_detail.ascx" %>

<asp:Content
  ID="TitleContent"
  ContentPlaceHolderID="TitleContent"
  runat="server"
>
  Dashboard Skor Jawaban Pertanyaan Visi Misi Tahunan | Universitas Tarumanagara
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Memanggil user control TabelKuesionerHasilAngketDetail dengan ID TabelKuesionerHasilAngketDetail1 untuk menampilkan konten utama -->
  <uc:TabelKuesionerHasilAngketDetail
    ID="TabelKuesionerHasilAngketDetail1"
    runat="server"
  />
</asp:Content>
