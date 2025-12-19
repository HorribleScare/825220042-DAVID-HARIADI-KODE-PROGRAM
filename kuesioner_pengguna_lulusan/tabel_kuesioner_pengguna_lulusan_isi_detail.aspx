<%@ Page Language="VB" MasterPageFile="../Site.master" %> <%@ Register
TagPrefix="uc" TagName="TabelKuesionerPenggunaLulusanIsiDetail"
Src="../ascx/kuesioner_pengguna_lulusan/tabel_kuesioner_pengguna_lulusan_isi_detail.ascx"
%>

<asp:Content
  ID="TitleContent"
  ContentPlaceHolderID="TitleContent"
  runat="server"
>
  Dashboard Skor Jawaban Pertanyaan Pengguna Lulusan Tahunan | Universitas Tarumanagara
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Memanggil user control TabelKuesionerPenggunaLulusanIsiDetail dengan ID TabelKuesionerPenggunaLulusanIsiDetail1 untuk menampilkan konten utama -->
  <uc:TabelKuesionerPenggunaLulusanIsiDetail
    ID="TabelKuesionerPenggunaLulusanIsiDetail1"
    runat="server"
  />
</asp:Content>
