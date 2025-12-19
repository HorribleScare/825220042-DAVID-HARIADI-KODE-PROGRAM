<%@ Page Language="VB" MasterPageFile="../Site.master" %> <%@ Register
TagPrefix="uc" TagName="TabelKuesionerAngket"
Src="../ascx/kuesioner_visimisi/tabel_kuesioner_angket.ascx" %>

<asp:Content
  ID="TitleContent"
  ContentPlaceHolderID="TitleContent"
  runat="server"
>
  Pertanyaan Visi Misi | Universitas Tarumanagara
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Memanggil user control TabelKuesionerAngket dengan ID TabelKuesionerAngket1 untuk menampilkan konten utama -->
  <uc:TabelKuesionerAngket ID="TabelKuesionerAngket1" runat="server" />
</asp:Content>
