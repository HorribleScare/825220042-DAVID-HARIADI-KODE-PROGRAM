<%@ Page Language="VB" MasterPageFile="../Site.master" %> <%@ Register
TagPrefix="uc" TagName="TabelKuesionerPenggunaLulusanIsi"
Src="../ascx/kuesioner_pengguna_lulusan/tabel_kuesioner_pengguna_lulusan_isi.ascx"
%>

<asp:Content
  ID="TitleContent"
  ContentPlaceHolderID="TitleContent"
  runat="server"
>
  Dashboard Pengguna Lulusan | Universitas Tarumanagara
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Memanggil user control TabelKuesionerPenggunaLulusanIsi dengan ID TabelKuesionerPenggunaLulusanIsi1 untuk menampilkan konten utama -->
  <uc:TabelKuesionerPenggunaLulusanIsi
    ID="TabelKuesionerPenggunaLulusanIsi1"
    runat="server"
  />
</asp:Content>
