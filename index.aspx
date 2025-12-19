<%@ Page Language="VB" MasterPageFile="Site.master" %> <%@ Register
TagPrefix="uc" TagName="Section" Src="ascx/index.ascx" %>

<asp:Content
  ID="TitleContent"
  ContentPlaceHolderID="TitleContent"
  runat="server"
>
  Dashboard Kuesioner | Universitas Tarumanagara
</asp:Content>

<asp:Content ID="MainContent" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Memanggil user control Section dengan ID Section1 untuk menampilkan konten utama -->
  <uc:Section ID="Section1" runat="server" />
</asp:Content>
