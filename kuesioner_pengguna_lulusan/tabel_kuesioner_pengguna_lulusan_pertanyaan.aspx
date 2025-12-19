<%@ Page Language="VB" MasterPageFile="../Site.master" %> <%@ Register
TagPrefix="uc" TagName="TabelKuesionerPenggunaLulusanPertanyaan"
Src="../ascx/kuesioner_pengguna_lulusan/tabel_kuesioner_pengguna_lulusan_pertanyaan.ascx"
%>

<asp:Content
  ID="TitleContent"
  ContentPlaceHolderID="TitleContent"
  runat="server"
>
  Pertanyaan Pengguna Lulusan | Universitas Tarumanagara
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Memanggil user control TabelKuesionerPenggunaLulusanPertanyaan dengan ID TabelKuesionerPenggunaLulusanPertanyaan1 untuk menampilkan konten utama -->
  <uc:TabelKuesionerPenggunaLulusanPertanyaan
    ID="TabelKuesionerPenggunaLulusanPertanyaan1"
    runat="server"
  />
</asp:Content>
