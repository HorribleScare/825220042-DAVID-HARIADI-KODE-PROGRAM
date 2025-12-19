<%@ Page Language="VB" MasterPageFile="../Site.master" %> <%@ Register
TagPrefix="uc" TagName="TabelKuesionerHasilAngket"
Src="../ascx/kuesioner_visimisi/tabel_kuesioner_hasil_angket.ascx" %>

<asp:Content
  ID="TitleContent"
  ContentPlaceHolderID="TitleContent"
  runat="server"
>
  Dashboard Visi Misi | Universitas Tarumanagara
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Memanggil user control TabelKuesionerHasilAngket dengan ID TabelKuesionerHasilAngket1 untuk menampilkan konten utama -->
  <uc:TabelKuesionerHasilAngket
    ID="TabelKuesionerHasilAngket1"
    runat="server"
  />
</asp:Content>
