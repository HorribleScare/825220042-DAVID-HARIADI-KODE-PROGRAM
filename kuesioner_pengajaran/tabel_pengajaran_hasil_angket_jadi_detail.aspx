<%@ Page Language="VB" MasterPageFile="../Site.master" %> <%@ Register
TagPrefix="uc" TagName="TabelPengajaranHasilAngketJadiDetail"
Src="../ascx/kuesioner_pengajaran/tabel_pengajaran_hasil_angket_jadi_detail.ascx" %>

<asp:Content
  ID="TitleContent"
  ContentPlaceHolderID="TitleContent"
  runat="server"
>
  Dashboard Skor Jawaban Pertanyaan Pengajaran Tahunan | Universitas Tarumanagara
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Memanggil user control TabelPengajaranHasilAngketJadiDetail dengan ID TabelPengajaranHasilAngketJadiDetail1 untuk menampilkan konten utama -->
  <uc:TabelPengajaranHasilAngketJadiDetail
    ID="TabelPengajaranHasilAngketJadiDetail1"
    runat="server"
  />
</asp:Content>
